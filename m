Return-Path: <linux-kernel-owner+w=401wt.eu-S1751034AbYH2PVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034AbYH2PVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYH2PVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:21:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:42533 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYH2PVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:21:05 -0400
Date: Fri, 29 Aug 2008 08:07:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu, tglx@tglx.de,
       torvalds@linux-foundation.org
Subject: [PATCH 3/5] select: introduce a schedule_hrtimeout() function
Message-ID: <20080829080740.7857618e@infradead.org>
In-Reply-To: <20080829080549.6906b744@infradead.org>
References: <20080829080549.6906b744@infradead.org>
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
Date: Thu, 28 Aug 2008 13:44:03 -0700
Subject: [PATCH] select: introduce a schedule_hrtimeout() function

This patch adds a schedule_hrtimeout() function, to be used by select() and poll()
in a later patch. This function works similar to schedule_timeout() in most ways,
but takes a timespec rather than jiffies.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/hrtimer.h |    3 ++
 kernel/hrtimer.c        |   57 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 6d93dce..526b62f 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -346,6 +346,9 @@ extern long hrtimer_nanosleep_restart(struct restart_block *restart_block);
 extern void hrtimer_init_sleeper(struct hrtimer_sleeper *sl,
 				 struct task_struct *tsk);
 
+extern signed long schedule_hrtimeout(struct timespec *time, int mode);
+
+
 /* Soft interrupt function to run the hrtimer queues: */
 extern void hrtimer_run_queues(void);
 extern void hrtimer_run_pending(void);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b8e4dce..0ab7b04 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1678,3 +1678,60 @@ void __init hrtimers_init(void)
 #endif
 }
 
+
+/**
+ * schedule_hrtimeout - sleep until timeout
+ * @timeout: timeout value (timespec)
+ * @mode: timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
+ *
+ * Make the current task sleep until @timeout time has
+ * elapsed. The routine will return immediately unless
+ * the current task state has been set (see set_current_state()).
+ *
+ * You can set the task state as follows -
+ *
+ * %TASK_UNINTERRUPTIBLE - at least @timeout time is guaranteed to
+ * pass before the routine returns. The routine will return 0
+ *
+ * %TASK_INTERRUPTIBLE - the routine may return early if a signal is
+ * delivered to the current task. In this case a positivee value will
+ * be returned or 0 if the timer expired in time
+ *
+ * The current task state is guaranteed to be TASK_RUNNING when this
+ * routine returns.
+ *
+ * In all cases the return value is guaranteed to be non-negative.
+ */
+signed long __sched schedule_hrtimeout(struct timespec *time, int mode)
+{
+	struct hrtimer_sleeper t;
+	ktime_t expire;
+
+	expire = timespec_to_ktime(*time);
+
+	if (ktime_to_ns(expire) <= 0) {
+		__set_current_state(TASK_RUNNING);
+		return 0;
+	}
+
+	hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC, mode);
+	t.timer.expires = expire;
+
+	hrtimer_init_sleeper(&t, current);
+
+	hrtimer_start(&t.timer, t.timer.expires, mode);
+	if (!hrtimer_active(&t.timer))
+		t.task = NULL;
+
+	if (likely(t.task))
+		schedule();
+
+	hrtimer_cancel(&t.timer);
+
+
+	__set_current_state(TASK_RUNNING);
+
+	return t.task == NULL;
+}
+EXPORT_SYMBOL_GPL(schedule_hrtimeout);
+
-- 
1.5.5.1

