Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbZBWQuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbZBWQuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbZBWQuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:50:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49534 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbZBWQuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:50:09 -0500
Date: Mon, 23 Feb 2009 17:46:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] forget_original_parent: split out the un-ptrace
	part
Message-ID: <20090223164632.GA16294@redhat.com>
References: <20090211211216.GA16847@redhat.com> <20090220022746.8852CFC2F7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220022746.8852CFC2F7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Roland McGrath wrote:
>
> > +static inline int task_detached(struct task_struct *p)
>
> Maybe take the opportunity to make it bool?
> Clearly trivial, but a bit of implicit documentation that doesn't hurt.

Agreed. Actually I was going to do this, but forgot.

I'll send the cleanup patch.

> > +void exit_ptrace(struct task_struct *tracer)
> > +{
> > +	struct task_struct *p, *n;
> > +	LIST_HEAD(ptrace_dead);
>
> I think this can do a short-circuit for the common case and avoid the lock:
>
> 	if (list_empty(&tracer->ptraced))
> 		return;

4/4 does this, but

> I see your patch 4/4 on this.  In fact, I think the short-circuit
> optimization of these two cases should be two separate patches.

agreed,

> The real-child optimization is just a new
> optimization beyond the status quo.  It can really be considered wholly
> after this whole series (and probably just punted because it gets so hairy).

Yes. You can see from the changelog that I don't actually like this
optimizatio very much. Because it complicates the code, adds the barrier,
but needs thread_group_empty().

If we are going to optimize out tasklist in forget_original_parent(), then
I'd prefer http://marc.info/?l=linux-kernel&m=123438710725342

But this needs a fat comment. And I didn't think carefully about this code.

> (I don't
> see how release_task() could be a problem at all.

This was mostly about forget_original_parent...

But from the _pure theoretical_ pov, it is not correct to assume that
list_empty(&tracer->ptraced) == T means that current can not be used
somehow as tracee->parent. Another subthread can release a dead tracee.

For example, list_empty(&tracer->ptraced) == T doesn't mean that the
STOREs to this task_struct are finished, list_del_init(->ptrace_entry)
can still be in progress.

But since we take tasklist before release_task(current) we are safe,
even in theory.

> You didn't mention ptrace_traceme() in your 4/4 message.

And I guess you want to know why I didn't...

Because I forgot completely about traceme! Thanks Roland.

> In fact, that seems
> like a new hole, period--without the short-circuit optimization.

I think you are right, the current code looks racy too.

> That seems addressed by e.g.:
>
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -534,7 +534,7 @@ repeat:
>  		 * Set the ptrace bit in the process ptrace flags.
>  		 * Then link us on our parent's ptraced list.
>  		 */
> -		if (!ret) {
> +		if (!ret && !(current->real_parent->flags & PF_EXITING)) {
>  			current->ptrace |= PT_PTRACED;

Yes sure.

But this means exit_ptrace() must always take tasklist, otherwise we
don't have the necessary barriers.

I am still feeling bad, will try to think more later.

Oleg.

