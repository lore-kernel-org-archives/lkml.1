Return-Path: <linux-kernel-owner+w=401wt.eu-S1750968AbXDOOWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968AbXDOOWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 10:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbXDOOWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 10:22:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbXDOOWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 10:22:02 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [AppArmor 39/41] AppArmor: Profile loading and manipulation, pathname matching
Date: Sun, 15 Apr 2007 16:21:52 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org
References: <20070412090809.917795000@suse.de> <20070412090849.465428000@suse.de> <p733b35903l.fsf@bingen.suse.de>
In-Reply-To: <p733b35903l.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151621.52906.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007 15:46, Andi Kleen wrote:
> > +struct aa_dfa {
> > +	struct table_header *tables[YYTD_ID_NXT];
> > +};
> 
> If that is passed in from user space you would need special compat
> code for 64bit kernels who support 32bit userland.
> Better to avoid pointers.

This struct is not passed between the kernel and user space; no problem here. 
In fact the profiles format used is fully machine independent.

> > +
> > +	/* get optional subprofiles */
> > +	if (aa_is_nameX(e, AA_LIST, "hats")) {
> > +		while (!aa_is_nameX(e, AA_LISTEND, NULL)) {
> > +			struct aa_profile *subprofile;
> > +			subprofile = aa_unpack_profile(e);
> 
> Is there any check that would guard the recursion from stack
> overflow on malicious input?  

It's nice to check for consistency though, so we're adding that. Profile 
loading is a trusted operation, at least so far, and so security wise we 
don't actually have to care --- if loading an invalid profile can bring down 
the system, then that's no worse than an arbitrary module that crashes the 
machine. Not sure if there will ever be user loadable profiles; at least at 
that point we had to care.

> > +	/*
> > +	 * Replacement needs to allocate a new aa_task_context for each
> > +	 * task confined by old_profile.  To do this the profile locks
> > +	 * are only held when the actual switch is done per task.  While
> > +	 * looping to allocate a new aa_task_context the old_task list
> > +	 * may get shorter if tasks exit/change their profile but will
> > +	 * not get longer as new task will not use old_profile detecting
> > +	 * that is stale.
> > +	 */
> > +	do {
> > +		new_cxt = aa_alloc_task_context(GFP_KERNEL | __GFP_NOFAIL);
> 
> NOFAIL is usually a bad sign. It should be only used if there is no
> alternative.

At this point there is no secure alternative to allocating a task context --- 
except killing the task, maybe.

Thanks,
Andreas
