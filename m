Return-Path: <linux-kernel-owner+w=401wt.eu-S1760676AbZLJPIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676AbZLJPIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 10:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbZLJPIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 10:08:11 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:55424 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZLJPIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 10:08:10 -0500
To: oleg@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       linux-security-module@vger.kernel.org
Subject: Re: [patch 1/9] sys: Fix missing rcu protection for __task_cred()access
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20091210001308.247025548@linutronix.de>
	<20091210004703.029784964@linutronix.de>
	<20091210142036.GA8226@redhat.com>
In-Reply-To: <20091210142036.GA8226@redhat.com>
Message-Id: <200912110008.BEJ00511.FVOJLtSMOFHOQF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 11 Dec 2009 00:08:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 12/10, Thomas Gleixner wrote:
> >
> > commit c69e8d9 (CRED: Use RCU to access another task's creds and to
> > release a task's own creds) added non rcu_read_lock() protected access
> > to task creds of the target task in set_prio_one().
> >
> > The comment above the function says:
> >  * - the caller must hold the RCU read lock
> >
> > The calling code in sys_setpriority does read_lock(&tasklist_lock) but
> > not rcu_read_lock(). This works only when CONFIG_TREE_PREEMPT_RCU=n.
> > With CONFIG_TREE_PREEMPT_RCU=y the rcu_callbacks can run in the tick
> > interrupt when they see no read side critical section.
> > ...
> > --- linux-2.6-tip.orig/kernel/sys.c
> > +++ linux-2.6-tip/kernel/sys.c
> > @@ -163,6 +163,7 @@ SYSCALL_DEFINE3(setpriority, int, which,
> >  	if (niceval > 19)
> >  		niceval = 19;
> >
> > +	rcu_read_lock();
> >  	read_lock(&tasklist_lock);
> 
> Off-topic, but can't resist...
> 
> This also fixes another bug here. find_task_by_vpid() is not safe
> without rcu_read_lock(). I do not mean it is not safe to use the
> result, just find_pid_ns() by itself is not safe.
> 
> Usually tasklist gives enough protection, but if copy_process() fails
> it calls free_pid() lockless and does call_rcu(delayed_put_pid().
> This means, without rcu lock find_pid_ns() can't scan the hash table
> safely.

So, we need to change below comment from "or" to "and" ?

378 /*
379  * Must be called under rcu_read_lock() or with tasklist_lock read-held.
380  */
381 struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
382 {
383         return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
384 }
385
386 struct task_struct *find_task_by_vpid(pid_t vnr)
387 {
388         return find_task_by_pid_ns(vnr, current->nsproxy->pid_ns);
389 }
