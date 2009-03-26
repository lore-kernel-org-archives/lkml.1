Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbZCZCBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbZCZCBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZCZCBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:01:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39307 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbZCZCBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:01:31 -0400
Date: Thu, 26 Mar 2009 02:58:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "Kleen, Andi" <andi.kleen@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [rfc] x86, bts: fix crash
Message-ID: <20090326015801.GA451@redhat.com>
References: <928CFBE8E7CB0040959E56B4EA41A77E9260843D@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E9260843D@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Metzger, let's move this discussion to lkml, I also cc'ed Roland.
Imho, this problem (which I don't fully understand ;) needs more
eyes.

On 03/25, Metzger, Markus T wrote:
>
> The attached patch

Please don't use attachments ;)

> I would appreciate any comment or directions you have if you think that this is the
>
> wrong approach to tackle this problem.

Metzger, this all is a black magic to me, I don't even know what bts does.
But at least some bits doesn't look right to me.

> +static void ptrace_bts_exit_tracer(void)
>  {
> +	struct task_struct *child, *n;
> +
>  	/*
> -	 * Ptrace_detach() races with ptrace_untrace() in case
> -	 * the child dies and is reaped by another thread.
> +	 * We must not hold the tasklist_lock when we release the bts
> +	 * tracer, since we need to make sure the cpu executing the
> +	 * tracee stops tracing before we may free the trace buffer.
>  	 *
> -	 * We only do the memory accounting at this point and
> -	 * leave the buffer deallocation and the bts tracer
> -	 * release to ptrace_bts_untrace() which will be called
> -	 * later on with tasklist_lock held.
> +	 * read_lock(&tasklist_lock) and smp_call_function() may
> +	 * deadlock with write_lock_irq(&tasklist_lock).
> +	 *
> +	 * As long as we're the only one modifying our list of traced
> +	 * children, we should be safe, since we're currently busy.
>  	 */
> -	release_locked_buffer(child->bts_buffer, child->bts_size);
> +	list_for_each_entry_safe(child, n, &current->ptraced, ptrace_entry) {

It is not safe to iterate over current->ptraced lockless, the comment
is not right. Anoter subthread can reap the dead tracee, or at least
do ptrace_unlink() if the tracee is not the child of our thread group.

> +static void ptrace_bts_exit_tracee(void)
> +{
> +	struct mm_struct *mm = NULL;
> +
> +	/*
> +	 * This code may race with ptrace reparenting.
> +	 *
> +	 * We hold the tasklist lock while we check whether we're
> +	 * ptraced and grab our ptracer's mm.
> +	 *
> +	 * It does not really matter if we're reparented,
> +	 * afterwards. We hold onto the correct mm.
> +	 *
> +	 * If we're reparented before we get the tasklist_lock, our
> +	 * former ptrace parent will release the bts tracer.
> +	 */
> +	write_lock_irq(&tasklist_lock);
> +	if (current->ptrace)
> +		mm = get_task_mm(current->parent);

We can't take task_lock() (called by get_task_mm) under write_lock(tasklist),
this is deadlockable. Afaics, read_lock() is enough here, in that case it is
safe to call get_task_mm().

> @@ -752,6 +752,14 @@ void ds_release_bts(struct bts_tracer *t
>
>  	ds_suspend_bts(tracer);
>
> +	/*
> +	 * We must wait for the suspend to take effect before we may
> +	 * free the tracer and the ds configuration.
> +	 */
> +	if (tracer->ds.context->task &&
> +	    (tracer->ds.context->task != current))
> +		wait_task_inactive(tracer->ds.context->task, 0);

I am not sure I understand the problem. From the changelog:

	If the children are currently executing, the buffer
	may be freed while the hardware is still tracing.
	This might cause the hardware to overwrite memory.

So, the problem is that ds.context->task must not be running before we
can start to disable/free ds, yes? Something like ds_switch_to() should
be completed, right?

In that case I don't really understand how wait_task_inactive() can help.
If the task is killed it can be scheduled again, right after
wait_task_inactive() returns.

Also. This function is called from ptrace_bts_exit_tracer(), when the
tracee is not stopped. In this case wait_task_inactive() can spin forever.
For example, if the tracee simply does "for (;;) ;" it never succeeds.


If my understanding of the problem is wrong, could you please explain
it for dummies?

Oleg.

