Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab0BHMaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 07:30:25 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:51126 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab0BHMaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 07:30:22 -0500
To: tglx@linutronix.de
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       linux-security-module@vger.kernel.org
Subject: [PATCH] Update comment on find_task_by_pid_ns
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20091210001308.247025548@linutronix.de>
	<20091210004703.029784964@linutronix.de>
	<20091210142036.GA8226@redhat.com>
	<200912110008.BEJ00511.FVOJLtSMOFHOQF@I-love.SAKURA.ne.jp>
	<alpine.LFD.2.00.0912102214180.3089@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912102214180.3089@localhost.localdomain>
Message-Id: <201002082130.JDC57339.OHOVJFQtFSLFMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 8 Feb 2010 21:30:17 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 11 Dec 2009, Tetsuo Handa wrote:
> > > Usually tasklist gives enough protection, but if copy_process() fails
> > > it calls free_pid() lockless and does call_rcu(delayed_put_pid().
> > > This means, without rcu lock find_pid_ns() can't scan the hash table
> > > safely.
> > 
> > So, we need to change below comment from "or" to "and" ?
> 
> No, both functions must be called with rcu_read_lock()
> 
> tasklist_lock read-held is not protecting the rcu lists and does not
> protect against a concurrent update. It merily protects against tasks
> going away or being added while we look up the lists.
>  
> > 378 /*
> > 379  * Must be called under rcu_read_lock() or with tasklist_lock read-held.
> > 380  */
> > 381 struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
> > 382 {
> > 383         return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
> > 384 }
> > 385
> > 386 struct task_struct *find_task_by_vpid(pid_t vnr)
> > 387 {
> > 388         return find_task_by_pid_ns(vnr, current->nsproxy->pid_ns);
> > 389 }
> > 
> 
> Thanks,
> 
> 	tglx

So, we need to update the comment on these functions?
----------------------------------------
[PATCH] Update comment on find_task_by_pid_ns

Caller of find_task_by_vpid() and find_task_by_pid_ns() needs to call
rcu_read_lock() rather than read_lock(&tasklist_lock) because find_pid_ns()
uses RCU primitives but spinlock does not prevent RCU callback if preemptive
RCU ( CONFIG_TREE_PREEMPT_RCU ) is enabled.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 kernel/pid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/kernel/pid.c
+++ linux-next/kernel/pid.c
@@ -376,7 +376,7 @@ struct task_struct *pid_task(struct pid 
 EXPORT_SYMBOL(pid_task);
 
 /*
- * Must be called under rcu_read_lock() or with tasklist_lock read-held.
+ * Must be called under rcu_read_lock().
  */
 struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
 {
