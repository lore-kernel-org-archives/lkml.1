Return-Path: <linux-kernel-owner+w=401wt.eu-S1759794AbXKASwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759794AbXKASwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbXKASwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:52:44 -0400
Received: from smtp-out.google.com ([216.239.33.17]:41053 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbXKASwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:52:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=GyEuMDT6w5M37SbXRsrtYtETOxvsmlirLx26RSQQXRuV+jSpI1JdlFvtdXJ13zUnF
	9ghf3IXicdyuflb6jXGNg==
Date: Thu, 1 Nov 2007 11:52:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Christoph Lameter <clameter@sgi.com>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [RFC] cpuset relative memory policies - second choice
In-Reply-To: <20071031131949.b91bf383.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0711011145090.21823@chino.kir.corp.google.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com> <Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com> <20071031131949.b91bf383.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007, Paul Jackson wrote:

> The basic reason that I went with an additional per-task modal
> state, rather than a modal flag for each mbind, set_mempolicy and
> get_mempolicy call was to reduce the likely rate of bugs in user
> level C code using this API.
> 

I think it may be more error prone to accidently leave off the 
get_mempolicy() system call to use the system-wide numbering or for 
user-level code to forget that the mode was already set (and now stored in 
their task_struct) without a subsequent get_mempolicy() to revert back to 
the default behavior.  Both of these problems can be addressed by checking 
the *policy returned by get_mempolicy(), as you've coded it, but many 
applications will probably ignore that overhead.

Allowing the mode to be passed on each set_mempolicy() system call seems 
better, this is where the nodemask is passed anyway so it's legitimate for 
the caller to specify how that nodemask should be interpreted (either 
system-wide or cpuset-wide).  This keeps all semantics of the nodemask to 
a single invocation of a system call instead of setting policy modes with 
get_mempolicy() and confusing the matter later.

I think get_mempolicy() can remain unchanged because it will simply return 
the contextualized nodemask in either case and would not require a mode to 
be passed.

		David
