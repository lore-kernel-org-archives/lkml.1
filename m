Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbXCEA3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbXCEA3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbXCEA30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:29:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:62124 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbXCEA3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:29:24 -0500
Message-Id: <20070305002632.836555844@arndb.de>
References: <20070305002024.875968120@arndb.de>
User-Agent: quilt/0.45-1
Date: Mon, 05 Mar 2007 01:20:25 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 1/3] introduce schedule_timeout_hr
Content-Disposition: inline; filename=add-schedule-timeout-hr.diff
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18GD6gPpDXN6/GcOs+XUZpRHRnqBPo9WL72fnP
 ySja5jMFkSS9W0GKRJRrrIlsjQC1ED5AXvpFrujed4CTUXt6Fl
 SEotdUZ5ei0UmKoBlL+gg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The new schedule_timeout_hr function is a variant of schedule_timeout
that uses hrtimers internally. Consequently, its argument and
return value are ktime_t.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Index: linux-cg/include/linux/sched.h
===================================================================
--- linux-cg.orig/include/linux/sched.h
+++ linux-cg/include/linux/sched.h
@@ -246,6 +246,8 @@ extern int in_sched_functions(unsigned l
 
 #define	MAX_SCHEDULE_TIMEOUT	LONG_MAX
 extern signed long FASTCALL(schedule_timeout(signed long timeout));
+extern ktime_t FASTCALL(schedule_timeout_hr(ktime_t timeout));
+
 extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
Index: linux-cg/kernel/hrtimer.c
===================================================================
--- linux-cg.orig/kernel/hrtimer.c
+++ linux-cg/kernel/hrtimer.c
@@ -1206,6 +1206,54 @@ void hrtimer_init_sleeper(struct hrtimer
 #endif
 }
 
+/**
+ * schedule_timeout_hr - sleep until timeout
+ * @timeout: timeout value
+ *
+ * Make the current task sleep until @timeout has elapsed.
+ * The routine will return immediately unless the current task
+ * state has been set (see set_current_state()).
+ *
+ * You can set the task state as follows -
+ *
+ * %TASK_UNINTERRUPTIBLE - at least @timeout is guaranteed to
+ * pass before the routine returns. The routine will return 0
+ *
+ * %TASK_INTERRUPTIBLE - the routine may return early if a signal is
+ * delivered to the current task. In this case the remaining time
+ * in jiffies will be returned, or 0 if the timer expired in time
+ *
+ * The current task state is guaranteed to be TASK_RUNNING when this
+ * routine returns.
+ *
+ * In all cases the return value is guaranteed to be a non-negative
+ * time value.
+ */
+static ktime_t __sched __schedule_timeout_hr(ktime_t time, void *addr)
+{
+	struct hrtimer_sleeper t;
+	ktime_t remain;
+
+	hrtimer_init(&t.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer_init_sleeper(&t, current);
+	__timer_stats_hrtimer_set_start_info(&t.timer, addr);
+	hrtimer_start(&t.timer, time, HRTIMER_MODE_REL);
+	schedule();
+	hrtimer_cancel(&t.timer);
+	remain = hrtimer_get_remaining(&t.timer);
+
+	if (ktime_to_ns(remain) < 0)
+		return ktime_set(0, 0);
+	else
+		return remain;
+}
+
+fastcall ktime_t __sched schedule_timeout_hr(ktime_t time)
+{
+	return __schedule_timeout_hr(time, __builtin_return_address(0));
+}
+EXPORT_SYMBOL_GPL(schedule_timeout_hr);
+
 static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
 {
 	hrtimer_init_sleeper(t, current);

--

