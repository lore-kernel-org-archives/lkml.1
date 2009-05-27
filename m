Return-Path: <linux-kernel-owner+w=401wt.eu-S1762020AbZE0Vuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762020AbZE0Vuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZE0Vu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:50:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44785 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZE0Vu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:50:28 -0400
Date: Wed, 27 May 2009 23:45:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 8/X] ptrace: introduce ptrace_tracer() helper
Message-ID: <20090527214557.GB6770@redhat.com>
References: <20090525000016.GA2239@redhat.com> <20090525215903.GA9113@redhat.com> <20090525223932.GA11508@redhat.com> <20090527024540.177FAFC36B@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527024540.177FAFC36B@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26, Roland McGrath wrote:
>
> > Introduce ptrace_tracer() (or suggest a better name) to simplify/cleanup
> > the code which needs the tracer and checks task_ptrace(). From now nobody
> > else uses ->pt_tracer except ptrace_link/ptrace_unlink.
>
> There is nothing really wrong with this.  But I think that this stuff will
> get sufficiently reworked again differently later on if it's converted to
> use utrace that this incremental cleanup may not really help any.

Yes, but currently this change really makes the code look better. Just look
at this

-       if (task_ptrace(child) && child->ptrace_task->pt_tracer == current) {
+       if (ptrace_tracer(child) == current) {

change. But yes, these cosmetic changes will likely be reconsidered
later. The same for s/task->ptrace/task_ptrace(task)/ changes.

> > Question. Note that ptrace_tracer() is equal to tracehook_tracer_task().
> > But I do not understand the future plans for tracehook_tracer_task().
> > Should we just use tracehook_tracer_task() ? If yes, how
> > ptrace_reparented() can use this helper?
>
> It seems likely that we will rework tracehook_tracer_task() later.
> It has three kinds of callers:
>
> 1. task_state() for "TracerPid:" line.
>    It remains to be seen if we want to make some hookified way that might
>    ever have a non-ptrace tracer supply the value here.  This was the main
>    original expectation of what tracehook_tracer_task() would do.
> 2. check_mem_permission()
>    I've already suggested to you that I think we want to swallow this
>    use as part of the clean-up/replacement of ptrace_may_access().
> 3. SELinux: selinux_bprm_set_creds(), selinux_setprocattr()
>    It makes sure that "PROCESS PTRACE" tracer->tracee avc checks can
>    inhibit the transition (exec/setprocattr call).
>
> For each of these, we have yet to hash out whether we will only ever want a
> cleaned-up ptrace support here, or if in a future generalized tracing setup
> like utrace these should be hooks that some non-ptrace kind of tracer
> facility could also supply.  Figuring any piece of all that out is way
> beyond the simple data structure cleanup phase.  I don't think we want to
> get into any of that quite yet.

So, I assume it is better to not use tracehook_tracer_task() and add
another helper like this patch does.

> > +	parent = ptrace_tracer(tsk);
> > +	if (likely(!parent))
> >  		parent = tsk->real_parent;
>
> This likely() doesn't buy much anyway, I'd just write the shorter:
>
> 	parent = ptrace_tracer(task) ?: tsk->real_parent;

OK,

> >  static inline int may_ptrace_stop(void)
> >  {
> > -	if (!likely(task_ptrace(current)))
> > +	struct task_struct *tracer = ptrace_tracer(current);
> > +
> > +	if (!likely(tracer))
> >  		return 0;
>
> Is there a particular rationale to checking ptrace_tracer() != NULL vs
> task_ptrace() != 0?

No, except the code looks better, imho.

> Or is it just that they should already be guaranteed
> synonymous, and here you have use for the tracer pointer a few lines later?

Yes.

Oleg.

