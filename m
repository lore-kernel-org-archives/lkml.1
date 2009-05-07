Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbZEGGmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbZEGGmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 02:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZEGGlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 02:41:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45837 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZEGGlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 02:41:51 -0400
Date: Thu, 7 May 2009 08:36:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH 3/3a] ptrace: add _ptrace_may_access()
Message-ID: <20090507063606.GA15220@redhat.com>
References: <20090505224729.GA965@redhat.com> <20090506080050.GF17457@elte.hu> <20090506235349.GC3756@redhat.com> <20090507002133.02D05FC39E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507002133.02D05FC39E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06, Roland McGrath wrote:
>
> > I was going to cleanup this later. Because I think that
> > __ptrace_may_access() should die. It has only one caller, mm_for_maps().
>
> CC'ing Al Viro, who wrote mm_for_maps() (and no one has touched it since,
> see commit 831830b).
>
> > I will re-check, but it looks a bit strange. More precisely, I just
> > can't understand it. Why we can't just do
> >
> > 	struct mm_struct *mm_for_maps(struct task_struct *task)
> > 	{
> > 		struct mm_struct *mm = get_task_mm(task);
> >
> > 		if (mm && mm != current->mm && !ptrace_may_access()) {
> > 			mmput(mm);
> > 			mm = NULL;
> > 		}
> >
> > 		return mm;
> > 	}
>
> That seems fine to me.  I suspect the old code just predated the PF_KTHREAD
> check in get_task_mm() and excluding the borrowed-mm window races was the
> only reason for using task_lock() that way.
>
> > ? We do not care if this task exits and clears ->mm right before
> > or after ptrace_may_access(), and this is possible eith the current
> > code too once it drops tasklist.
>
> I agree.

Great. Will try to make the patches soon.

And I forgot to mention, there is another reason to kill __ptrace_may_access.
Because we can "narrow" the critical section protected by task_lock(). Not
for performance of course, just for clarity:

/* the callers of ptrace_may_access should be fixed */

	int ptrace_may_access(struct task_struct *task, unsigned int mode)
	{
		const struct cred *cred = current_cred(), *tcred;
		int ret = 0;

		/* May we inspect the given task?
		 * This check is used both for attaching with ptrace
		 * and for allowing access to sensitive information in /proc.
		 *
		 * ptrace_attach denies several cases that /proc allows
		 * because setting up the necessary parent/child relationship
		 * or halting the specified task is impossible.
		 */
		/* Don't let security modules deny introspection */
		if (task == current)
			return ret;

		rcu_read_lock();
		tcred = __task_cred(task);
		if ((cred->uid != tcred->euid ||
		     cred->uid != tcred->suid ||
		     cred->uid != tcred->uid  ||
		     cred->gid != tcred->egid ||
		     cred->gid != tcred->sgid ||
		     cred->gid != tcred->gid) &&
		    !capable(CAP_SYS_PTRACE))
			ret = -EPERM;
		rcu_read_unlock();
		if (ret)
			return ret;
/* kill rmb ? */

		task_lock(task);
		if (!task->mm || !get_dumpable(task->mm)) {
			if (!capable(CAP_SYS_PTRACE))
				ret = -EPERM;
		task_unclock(task);
		if (ret)
			return ret;

		return security_ptrace_may_access(task, mode);
	}

Btw, "[PATCH 3/3]" notes that security_ptrace_may_access() is called without
task_lock(), this note "leaked" from this change in future ;)

But firsty I'll try to grep/recheck this all.

Oleg.

