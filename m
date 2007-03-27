Return-Path: <linux-kernel-owner+w=401wt.eu-S933175AbXC0Qqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbXC0Qqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933217AbXC0Qqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:46:39 -0400
Received: from gw.goop.org ([64.81.55.164]:51851 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933175AbXC0Qqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:46:38 -0400
Message-ID: <46094A70.9080901@goop.org>
Date: Tue, 27 Mar 2007 09:46:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       clalance@redhat.com, mingo@redhat.com, davej@redhat.com,
       Thilo.Cestonaro.external@fujitsu-siemens.com
Subject: Re: [PATCH]: Fix bogus softlockup warning with sysrq-t
References: <20070315132247.11291.28827.sendpatchset@prarit.boston.redhat.com> <4608AF01.4060804@goop.org> <460902CF.1030202@redhat.com>
In-Reply-To: <460902CF.1030202@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Prarit Bhargava wrote:
> I think that's a good idea -- I'll propose an add on patch to fix the
> sysrq-t case ...

I'm working on this patch at the moment.  I'm just wondering what
happens if you do a global re-enable while a CPU is locally disabled.  I
think it won't matter; it will end up in the "enabled but need to update
timestamp" state, and the next time it gets a timer tick, it will simply
update the timestamp and carry on.

(This is relative to the other two softlockup patches, but modified
since I posted them.)

    J

diff -r 4c81d8cafb67 drivers/char/sysrq.c
--- a/drivers/char/sysrq.c	Tue Mar 27 01:16:07 2007 -0700
+++ b/drivers/char/sysrq.c	Tue Mar 27 01:18:05 2007 -0700
@@ -408,6 +408,8 @@ void __handle_sysrq(int key, struct tty_
 	int i;
 	unsigned long flags;
 
+	softlockup_global_disable();
+
 	spin_lock_irqsave(&sysrq_key_table_lock, flags);
 	orig_log_level = console_loglevel;
 	console_loglevel = 7;
@@ -445,6 +447,8 @@ void __handle_sysrq(int key, struct tty_
 		console_loglevel = orig_log_level;
 	}
 	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
+
+	softlockup_global_enable();
 }
 
 /*
diff -r 4c81d8cafb67 include/linux/sched.h
--- a/include/linux/sched.h	Tue Mar 27 01:16:07 2007 -0700
+++ b/include/linux/sched.h	Tue Mar 27 01:18:05 2007 -0700
@@ -235,6 +235,8 @@ extern void softlockup_tick(void);
 extern void softlockup_tick(void);
 extern void softlockup_enable(void);
 extern void softlockup_disable(void);
+extern void softlockup_global_enable(void);
+extern void softlockup_global_disable(void);
 extern void spawn_softlockup_task(void);
 extern void touch_softlockup_watchdog(void);
 #else
@@ -245,6 +247,12 @@ static inline void softlockup_enable(voi
 {
 }
 static inline void softlockup_disable(void)
+{
+}
+static inline void softlockup_global_enable(void)
+{
+}
+static inline void softlockup_global_disable(void)
 {
 }
 static inline void spawn_softlockup_task(void)
diff -r 4c81d8cafb67 kernel/softlockup.c
--- a/kernel/softlockup.c	Tue Mar 27 01:16:07 2007 -0700
+++ b/kernel/softlockup.c	Tue Mar 27 01:18:05 2007 -0700
@@ -17,10 +17,16 @@
 
 static DEFINE_SPINLOCK(print_lock);
 
+enum enable {
+	SL_OFF = 0,		/* disabled */
+	SL_UPDATE,		/* enabled, but timestamp old */
+	SL_ON,			/* enabled */
+};
+
 static DEFINE_PER_CPU(unsigned long long, touch_timestamp);
 static DEFINE_PER_CPU(unsigned long long, print_timestamp);
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
-static DEFINE_PER_CPU(int, enabled);
+static DEFINE_PER_CPU(enum enable, enabled);
 
 static int did_panic = 0;
 
@@ -39,6 +45,8 @@ void touch_softlockup_watchdog(void)
 void touch_softlockup_watchdog(void)
 {
 	__raw_get_cpu_var(touch_timestamp) = sched_clock();
+	barrier();			/* update timestamp before enable */
+	__raw_get_cpu_var(enabled) = SL_ON;
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -57,13 +65,27 @@ void softlockup_enable(void)
 void softlockup_enable(void)
 {
 	touch_softlockup_watchdog();
-	barrier();			/* update timestamp before enable */
-	__get_cpu_var(enabled) = 1;
 }
 
 void softlockup_disable(void)
 {
-	__get_cpu_var(enabled) = 0;
+	__get_cpu_var(enabled) = SL_OFF;
+}
+
+void softlockup_global_enable()
+{
+	unsigned cpu;
+
+	for_each_online_cpu(cpu)
+		per_cpu(enabled, cpu) = SL_UPDATE;
+}
+
+void softlockup_global_disable()
+{
+	unsigned cpu;
+
+	for_each_online_cpu(cpu)
+		per_cpu(enabled, cpu) = SL_OFF;
 }
 
 /*
@@ -79,9 +101,19 @@ void softlockup_tick(void)
 
 	touch_timestamp = get_timestamp(&__get_cpu_var(touch_timestamp));
 
-	/* return if not enabled */
-	if (!__get_cpu_var(enabled))
-		return;
+	switch(__get_cpu_var(enabled)) {
+	case SL_OFF:
+		/* not enabled */
+		return;
+
+	case SL_UPDATE:
+		/* update timestamp */
+		touch_softlockup_watchdog();
+		break;
+
+	case SL_ON:
+		break;
+	}
 
 	print_timestamp = __get_cpu_var(print_timestamp);
 

