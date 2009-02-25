Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbZBYAf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbZBYAf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 19:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbZBYAfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 19:35:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbZBYAfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 19:35:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] forget_original_parent: split out the un-ptrace
	part
In-Reply-To: Oleg Nesterov's message of  Monday, 23 February 2009 17:46:32 +0100 <20090223164632.GA16294@redhat.com>
References: <20090211211216.GA16847@redhat.com>
	<20090220022746.8852CFC2F7@magilla.sf.frob.com>
	<20090223164632.GA16294@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090225003408.1DA81FC380@magilla.sf.frob.com>
Date: Tue, 24 Feb 2009 16:34:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But from the _pure theoretical_ pov, it is not correct to assume that
> list_empty(&tracer->ptraced) == T means that current can not be used
> somehow as tracee->parent. Another subthread can release a dead tracee.

I don't follow how that's relevant.  If list_empty(), then it was empty or
is becoming empty.  It can't then become nonempty again (because the thread
doing the check is the only one that adds to that list).  That's all we're
assuming.

> For example, list_empty(&tracer->ptraced) == T doesn't mean that the
> STOREs to this task_struct are finished, list_del_init(->ptrace_entry)
> can still be in progress.

Sure, but so what?  The check is to verify that some new list_del* (and
related cleanup work, of course) doesn't need to be *started*.

> > --- a/kernel/ptrace.c
> > +++ b/kernel/ptrace.c
> > @@ -534,7 +534,7 @@ repeat:
> >  		 * Set the ptrace bit in the process ptrace flags.
> >  		 * Then link us on our parent's ptraced list.
> >  		 */
> > -		if (!ret) {
> > +		if (!ret && !(current->real_parent->flags & PF_EXITING)) {
> >  			current->ptrace |= PT_PTRACED;
> 
> Yes sure.
> 
> But this means exit_ptrace() must always take tasklist, otherwise we
> don't have the necessary barriers.

Really?

	exit_signals(tsk);  /* sets PF_EXITING */
	/*
	 * tsk->flags are checked in the futex code to protect against
	 * an exiting task cleaning up the robust pi futexes.
	 */
	smp_mb();

This is an exactly analogous use, isn't it?  So exit_ptrace() just has to
follow this same existing barrier.  Right?


Thanks,
Roland

