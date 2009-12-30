Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbZL3QjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbZL3QjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 11:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZL3QjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 11:39:14 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42417 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZL3QjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 11:39:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xkLZRNgiUL3iNq/GgBoXLrigyPbrjQbzNdCwgU4kn+32IoyxNSodOZNZ27rMsM6AfX
         KQHckr/9zPXaF4WB9qWtjcOZGM7Uvey5GmP6UzXDEGDNAYEFzWzfREONqIZV0X6fWxie
         8c40EMc7zZ1LdUWNrNzMVbQmYwBTEoHc9WXc4=
Date: Wed, 30 Dec 2009 17:39:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, lkml <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Fix 2.6.33 x86 regression to kgdb hw breakpoints - due
	to perf API changes
Message-ID: <20091230163903.GA5024@nowhere>
References: <4B227F2C.7050403@windriver.com> <20091212132428.GB22389@elte.hu> <20091212135216.GA18597@elte.hu> <4B2404C6.2050003@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2404C6.2050003@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 03:01:58PM -0600, Jason Wessel wrote:
> Ingo Molnar wrote:
> > Basically we have two options:
> >
> >  A- change kgdb to use the hw-breakpoints highlevel APIs (i'd prefer 
> >     that)
> >
> >   
> 
> Right now we can't because the high level code uses all sorts of mutexes
> and sync points to get the hw breakpoints installs on the various
> processors.  After I re-spun my RFC patch, I found another problem.  I
> do use the high level code to create a block of 4 (struct perf_event **)
> structures, but doing so ultimately calls the reserve hw breakpoint even
> though they are marked as disabled when created.
> 
> Should I, or can I change that behavior?



We could probably have a helper that allocates a disabled breakpoint
without reserving it. But the problem remains: you'll need to take
locks when you eventually reserve it and when you activate it.

The fact that it can happen from nmi is really a problem.

Is there any possibility that we know the user has started a
kgdb session, and then reserve as much hardware breakpoints
as we can in kgdb at this time?

Thanks.

