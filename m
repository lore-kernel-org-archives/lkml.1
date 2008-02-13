Return-Path: <linux-kernel-owner+w=401wt.eu-S1763992AbYBMCmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763992AbYBMCmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYBMCmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:42:37 -0500
Received: from smtp-out.google.com ([216.239.45.13]:46118 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbYBMCmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:42:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=rkjHN51X/AaEk0LUVwpLL4Scb5km5D33hZdXqMG4gu+3ODMNX4vrXlSRyYNw0hWP9
	x6sQOjUXCItr3nUUhwTgQ==
Date: Tue, 12 Feb 2008 18:42:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
In-Reply-To: <20080212202201.a534cef8.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802121832520.29792@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <1202861432.4974.29.camel@localhost> <20080212183158.3ff4ccd5.pj@sgi.com> <Pine.LNX.4.64.0802121702431.11628@schroedinger.engr.sgi.com> <20080212193229.edbff05a.pj@sgi.com>
 <alpine.DEB.1.00.0802121755400.23110@chino.kir.corp.google.com> <20080212202201.a534cef8.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Paul Jackson wrote:

> However, once inside the kernel, how we store this flag in struct mempolicy,
> and how we pass it about between kernel routines, is our choice.
> 
> We can leave it packed, and unpack and repack it each time we consider the
> flag and mode bits, or we can store and pass it as separate flags.
> 
> I urge us to consider handling it as separate flags within the kernel
> because it most clearly and explicitly represents what is going on logically.
> There are two different kinds of flags here, the original mempolicy modes,
> and these meta modes (MPOL_F_STATIC_NODES, being the first example) which
> affect the nodemask intepretation.
> 

Again, if you did it this way, the lower MPOL_FLAG_SHIFT bits of the new 
'flags' member would always be zero if you are still going to use the 
MPOL_F_* defines from linux/mempolicy.h to do your bit testing.

I do not subscribe to the theory that just because we have a couple extra 
bytes of space somewhere in struct mempolicy that we have to use it 
immediately.

> Cramming both these into a single int is necessary across the kernel-user API,
> but it's an obfuscation that is not needed, therefore better avoided, within
> the kernel code.
> 

It makes the kernel code simpler, in a way.

Now we only have to pass a single actual among functions that include both 
the mode and optional flags (there are a lot of them and they span not 
only the VM but also filesystem code).  The catch is that we have to use a 
mpol_mode() wrapper for mode conditionals or switch statements.

But testing the flags is just as easy as

	if (mode & MPOL_F_STATIC_NODES) {
		...
	}

That test would remain unchanged (except for s/mode/flags/) if flags were 
stored in a separate member.

So by storing them both in an 'unsigned short' member of struct mempolicy:

 - we don't use any additional memory (and we can use those two extra
   bytes you identified earlier later), and

 - we only have to pass a single actual to many different functions that
   require both the mode and optional mode flags.
