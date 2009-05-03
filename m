Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZECTBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZECTBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbZECTBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:01:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47317 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751AbZECTBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:01:30 -0400
Date: Sun, 3 May 2009 20:56:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace: do not use task_lock() for attach
Message-ID: <20090503185659.GA17099@redhat.com>
References: <20090503185549.GA17087@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503185549.GA17087@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03, Oleg Nesterov wrote:
>
> Remove the "Nasty, nasty" lock dance in ptrace_attach()/ptrace_traceme().
> From now task_lock() has nothing to do with ptrace at all.
>
> With the recent changes nobody uses task_lock() to serialize with ptrace,
> but in fact it was never needed and it was never used consistently.

arch/um still uses task_lock() to clear PT_DTRACE after exec, but this
should be fixed anyway.

UML shouldn't use PT_DTRACE at all, and nobody except ptrace should
change ptrace flags. arch/um/kernel/exec.c:execve1() is just buggy.
For example, it can race with exit_ptrace()->__ptrace_unlink() and
leak PT_ flags on untraced task.

Jeff, what do you think about the patch I sent you a week ago?



> kernel/ptrace.c |  127 ++++++++++++++++++++------------------------------------
> 1 file changed, 47 insertions(+), 80 deletions(-)

To simplify the review I am attaching the code with this patch applied,

	int ptrace_attach(struct task_struct *task)
	{
		int retval;

		audit_ptrace(task);

		retval = -EPERM;
		if (unlikely(task->flags & PF_KTHREAD))
			goto out;
		if (same_thread_group(task, current))
			goto out;
		/*
		 * Protect exec's credential calculations against our interference;
		 * SUID, SGID and LSM creds get determined differently under ptrace.
		 */
		retval = mutex_lock_interruptible(&task->cred_exec_mutex);
		if (retval < 0)
			goto out;

		task_lock(task);
		retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH);
		task_unlock(task);
		if (retval)
			goto unlock_creds;

		write_lock_irq(&tasklist_lock);
		retval = -EPERM;
		if (unlikely(task->exit_state))
			goto unlock_tasklist;
		if (task->ptrace)
			goto unlock_tasklist;

		task->ptrace = PT_PTRACED;
		if (capable(CAP_SYS_PTRACE))
			task->ptrace |= PT_PTRACE_CAP;

		__ptrace_link(task, current);

		send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
	unlock_tasklist:
		write_unlock_irq(&tasklist_lock);
	unlock_creds:
		mutex_unlock(&task->cred_exec_mutex);
	out:
		return retval;
	}

	int ptrace_traceme(void)
	{
		int ret = -EPERM;

		write_lock_irq(&tasklist_lock);
		/* Are we already being traced? */
		if (!current->ptrace) {
			ret = security_ptrace_traceme(current->parent);
			/*
			 * Check PF_EXITING to ensure ->real_parent has not passed
			 * exit_ptrace(). Otherwise we don't report the error but
			 * pretend ->real_parent untraces us right after return.
			 */
			if (!ret && !(current->real_parent->flags & PF_EXITING)) {
				current->ptrace = PT_PTRACED;
				__ptrace_link(current, current->real_parent);
			}
		}
		write_unlock_irq(&tasklist_lock);

		return ret;
	}

Oleg.

