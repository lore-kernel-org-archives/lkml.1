Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYHaQbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYHaQbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 12:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbYHaQbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 12:31:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:36212 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbYHaQbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 12:31:19 -0400
Date: Sun, 31 Aug 2008 09:29:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, tglx@tglx.de, mingo@elte.hu,
       torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/5] select: Introduce a hrtimeout function
Message-ID: <20080831092903.633d0173@infradead.org>
In-Reply-To: <20080831092828.13ae0279@infradead.org>
References: <20080831092828.13ae0279@infradead.org>
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
Subject: [PATCH] select: Introduce a hrtimeout function

This patch adds a schedule_hrtimeout() function, to be used by select() and
poll() in a later patch. This function works similar to schedule_timeout()
in most ways, but takes a timespec rather than jiffies.

With a lot of contributions/fixes from Thomas

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h |    2 +
 kernel/hrtimer.c        |   65 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 6d93dce..becd17d 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -346,6 +346,8 @@ extern long hrtimer_nanosleep_restart(struct restart_block *restart_block);
 extern void hrtimer_init_sleeper(struct hrtimer_sleeper *sl,
 				 struct task_struct *tsk);
 
+extern int schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode);
+
 /* Soft interrupt function to run the hrtimer queues: */
 extern void hrtimer_run_queues(void);
 extern void hrtimer_run_pending(void);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b8e4dce..782137d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1678,3 +1678,68 @@ void __init hrtimers_init(void)
 #endif
 }
 
+/**
+ * schedule_hrtimeout - sleep until timeout
+ * @expires:	timeout value (ktime_t)
+ * @mode:	timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
+ *
+ * Make the current task sleep until the given expiry time has
+ * elapsed. The routine will return immediately unless
+ * the current task state has been set (see set_current_state()).
+ *
+ * You can set the task state as follows -
+ *
+ * %TASK_UNINTERRUPTIBLE - at least @timeout time is guaranteed to
+ * pass before the routine returns.
+ *
+ * %TASK_INTERRUPTIBLE - the routine may return early if a signal is
+ * delivered to the current task.
+ *
+ * The current task state is guaranteed to be TASK_RUNNING when this
+ * routine returns.
+ *
+ * Returns 0 when the timer has expired otherwise -EINTR
+ */
+int __sched schedule_hrtimeout(ktime_t *expires,
+			       const enum hrtimer_mode mode)
+{
+	struct hrtimer_sleeper t;
+
+	/*
+	 * Optimize when a zero timeout value is given. It does not
+	 * matter whether this is an absolute or a relative time.
+	 */
+	if (expires && !expires->tv64) {
+		__set_current_state(TASK_RUNNING);
+		return 0;
+	}
+
+	/*
+	 * A NULL parameter means "inifinte"
+	 */
+	if (!expires) {
+		schedule();
+		__set_current_state(TASK_RUNNING);
+		return -EINTR;
+	}
+
+	hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC, mode);
+	t.timer.expires = *expires;
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
+	destroy_hrtimer_on_stack(&t.timer);
+
+	__set_current_state(TASK_RUNNING);
+
+	return !t.task ? 0 : -EINTR;
+}
+EXPORT_SYMBOL_GPL(schedule_hrtimeout);
-- 
1.5.5.1

