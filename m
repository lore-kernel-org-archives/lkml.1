Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbYIAXQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbYIAXQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYIAXPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:15:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:40563 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbYIAXPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:15:33 -0400
Date: Mon, 1 Sep 2008 16:14:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: [PATCH 12/13] hrtimer: create a "timer_slack" field in the task
 struct
Message-ID: <20080901161423.59ebf2fc@infradead.org>
In-Reply-To: <20080901160343.75a89ec9@infradead.org>
References: <20080901160343.75a89ec9@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] hrtimer: create a "timer_slack" field in the task struct

We want to be able to control the default "rounding" that is used by
select() and poll() and friends. This is a per process property
(so that we can have a "nice" like program to start certain programs with
a looser or stricter rounding) that can be set/get via a prctl().

For this purpose, a field called "timer_slack_ns" is added to the task
struct. In addition, a field called "default_timer_slack"ns" is added
so that tasks easily can temporarily to a more/less accurate slack and then
back to the default.

The default value of the slack is set to 50 usec; this is significantly less
than 2.6.27's average select() and poll() timing error but still allows
the kernel to group timers somewhat to preserve power behavior. Applications
and admins can override this via the prctl()

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/init_task.h |    1 +
 include/linux/prctl.h     |    7 +++++++
 include/linux/sched.h     |    6 ++++++
 kernel/fork.c             |    2 ++
 kernel/sys.c              |   10 ++++++++++
 5 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 021d8e7..23fd890 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -170,6 +170,7 @@ extern struct group_info init_groups;
 	.cpu_timers	= INIT_CPU_TIMERS(tsk.cpu_timers),		\
 	.fs_excl	= ATOMIC_INIT(0),				\
 	.pi_lock	= __SPIN_LOCK_UNLOCKED(tsk.pi_lock),		\
+	.timer_slack_ns = 50000, /* 50 usec default slack */		\
 	.pids = {							\
 		[PIDTYPE_PID]  = INIT_PID_LINK(PIDTYPE_PID),		\
 		[PIDTYPE_PGID] = INIT_PID_LINK(PIDTYPE_PGID),		\
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index 5ad7919..48d887e 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -78,4 +78,11 @@
 #define PR_GET_SECUREBITS 27
 #define PR_SET_SECUREBITS 28
 
+/*
+ * Get/set the timerslack as used by poll/select/nanosleep
+ * A value of 0 means "use default"
+ */
+#define PR_SET_TIMERSLACK 29
+#define PR_GET_TIMERSLACK 30
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index cfb0d87..f357780 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1301,6 +1301,12 @@ struct task_struct {
 	int latency_record_count;
 	struct latency_record latency_record[LT_SAVECOUNT];
 #endif
+	/*
+	 * time slack values; these are used to round up poll() and
+	 * select() etc timeout values. These are in nanoseconds.
+	 */
+	unsigned long timer_slack_ns;
+	unsigned long default_timer_slack_ns;
 };
 
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index 7ce2ebe..4308d75 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -987,6 +987,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->prev_utime = cputime_zero;
 	p->prev_stime = cputime_zero;
 
+	p->default_timer_slack_ns = current->timer_slack_ns;
+
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 	p->last_switch_count = 0;
 	p->last_switch_timestamp = 0;
diff --git a/kernel/sys.c b/kernel/sys.c
index 038a7bc..1b96401 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1727,6 +1727,16 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 		case PR_SET_TSC:
 			error = SET_TSC_CTL(arg2);
 			break;
+		case PR_GET_TIMERSLACK:
+			error = current->timer_slack_ns;
+			break;
+		case PR_SET_TIMERSLACK:
+			if (arg2 <= 0)
+				current->timer_slack_ns =
+					current->default_timer_slack_ns;
+			else
+				current->timer_slack_ns = arg2;
+			break;
 		default:
 			error = -EINVAL;
 			break;
-- 
1.5.5.1

