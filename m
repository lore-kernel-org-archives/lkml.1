Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbZA0AbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbZA0AbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbZA0AbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:31:15 -0500
Received: from smtp-out.google.com ([216.239.33.17]:37085 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbZA0AbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:31:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:content-transfer-encoding:in-reply-to:
	x-operating-system:user-agent:x-gmailtapped-by:x-gmailtapped;
	b=FLx+1a49G4UIM2aPZtwuMpl29CBI0ZhLIzTUVGCGLo0ta06Zo1+mKkz/WM2bkUNb6
	dgo9mKw7gQ28WAnSCeoKQ==
Date: Mon, 26 Jan 2009 16:30:55 -0800
From: Mandeep Singh Baines <msb@google.com>
To: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Cc: rientjes@google.com, mbligh@google.com, thockin@google.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v4] softlockup: remove hung_task_check_count
Message-ID: <20090127003055.GA21269@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1232991701.4863.222.camel@laptop>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.28.16.145
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra (peterz@infradead.org) wrote:
> On Mon, 2009-01-26 at 09:36 -0800, Mandeep Baines wrote:
> 
> > Unfortunately, this can't be done for hung_task. It writes to the
> > task_struct here:
> 
> Don't top post!
> 
> > static void check_hung_task(struct task_struct *t, unsigned long now,
> >                             unsigned long timeout)
> > {
> >         unsigned long switch_count = t->nvcsw + t->nivcsw;
> > 
> >         if (t->flags & PF_FROZEN)
> >                 return;
> > 
> >         if (switch_count != t->last_switch_count || !t->last_switch_timestamp) {
> >                 t->last_switch_count = switch_count;
> >                 t->last_switch_timestamp = now;
> >                 return;
> >         }
> > 
> > It is able to get away with using only a read_lock because no one else
> > reads or writes to these fields.
> 
> How would RCU be different here?
> 

My bad, RCU wouldn't be any different. I misunderstood how RCU works. Just
spent the morning reading the LWN 3-part series on RCU and I think I'm able to
grok it now;)

Below is a patch to hung_task which removes the hung_task_check_count and
converts the read_locks to RCU.

Thanks Frédéric and Peter!

---
To avoid holding the tasklist lock too long, hung_task_check_count was used
as an upper bound on the number of tasks that are checked by hung_task.
This patch removes the hung_task_check_count sysctl.

Instead of checking a limited number of tasks, all tasks are checked. To
avoid holding the CPU for too long, need_resched() is checked often. To
avoid blocking out writers, the read_lock has been converted to an
rcu_read_lock().

It is safe convert to an rcu_read_lock() because the tasks and thread_group
lists are both protected by list_*_rcu() operations. The worst that can
happen is that hung_task will update last_switch_timestamp field of a DEAD
task.

The design was proposed by Frédéric Weisbecker. Peter Zijlstra suggested
the use of RCU.

Signed-off-by: Mandeep Singh Baines <msb@google.com>
---
 include/linux/sched.h |    1 -
 kernel/hung_task.c    |   12 +++---------
 kernel/sysctl.c       |    9 ---------
 3 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f2f94d5..278121c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -315,7 +315,6 @@ static inline void touch_all_softlockup_watchdogs(void)
 
 #ifdef CONFIG_DETECT_HUNG_TASK
 extern unsigned int  sysctl_hung_task_panic;
-extern unsigned long sysctl_hung_task_check_count;
 extern unsigned long sysctl_hung_task_timeout_secs;
 extern unsigned long sysctl_hung_task_warnings;
 extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index ba8ccd4..7d67350 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -17,11 +17,6 @@
 #include <linux/sysctl.h>
 
 /*
- * Have a reasonable limit on the number of tasks checked:
- */
-unsigned long __read_mostly sysctl_hung_task_check_count = 1024;
-
-/*
  * Zero means infinite timeout - no checking done:
  */
 unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
@@ -116,7 +111,6 @@ static void check_hung_task(struct task_struct *t, unsigned long now,
  */
 static void check_hung_uninterruptible_tasks(unsigned long timeout)
 {
-	int max_count = sysctl_hung_task_check_count;
 	unsigned long now = get_timestamp();
 	struct task_struct *g, *t;
 
@@ -127,16 +121,16 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 	if (test_taint(TAINT_DIE) || did_panic)
 		return;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	do_each_thread(g, t) {
-		if (!--max_count)
+		if (need_resched())
 			goto unlock;
 		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
 		if (t->state == TASK_UNINTERRUPTIBLE)
 			check_hung_task(t, now, timeout);
 	} while_each_thread(g, t);
  unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 }
 
 static void update_poll_jiffies(void)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 2481ed3..16526a2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -820,15 +820,6 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "hung_task_check_count",
-		.data		= &sysctl_hung_task_check_count,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
-		.strategy	= &sysctl_intvec,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "hung_task_timeout_secs",
 		.data		= &sysctl_hung_task_timeout_secs,
 		.maxlen		= sizeof(unsigned long),
-- 
1.5.4.5

