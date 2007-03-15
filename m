Return-Path: <linux-kernel-owner+w=401wt.eu-S933552AbXCONWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbXCONWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 09:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933559AbXCONWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 09:22:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933552AbXCONWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 09:22:49 -0400
Date: Thu, 15 Mar 2007 09:22:47 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       clalance@redhat.com, mingo@redhat.com, davej@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070315132247.11291.28827.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: Fix bogus softlockup warning with sysrq-t
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are some situations when soft lockup warnings are expected in the
kernel.  For example, when doing an alt-sysrq-t on a large number of processes,
the dump to console can take a long time and the tasklist_lock is held over
that period.  This results in a bogus soft lockup warning.

This patch reworks touch_softlockup_watchdog to touch ALL cpu's
touch_timestamp.  It also introduces touch_cpu_softlockup_watchdog to touch
a single cpu's touch_timestamp.  This makes it functionally equivalent to
touch_nmi_watchdog.

touch_nmi_watchdog is not modified -- AFAICT it was attempting to touch all
cpu's softlockup watchdogs, not just a specific cpu.

/drivers/ide/ide-iops.c does not need to call touch_softlockup_watchdog as it
is done in the call to touch_nmi_watchdog.

The EXPORT_SYMBOL for touch_softlockup_watchdog is needed by
drivers/scsi/ips.ko

Acked-by: Chris Lalancette <clalance@redhat.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/ia64/kernel/uncached.c b/arch/ia64/kernel/uncached.c
index c58e933..db514bb 100644
--- a/arch/ia64/kernel/uncached.c
+++ b/arch/ia64/kernel/uncached.c
@@ -254,7 +254,7 @@ static int __init uncached_build_memmap(unsigned long uc_start,
 	struct gen_pool *pool = uncached_pools[nid].pool;
 	size_t size = uc_end - uc_start;
 
-	touch_softlockup_watchdog();
+	touch_cpu_softlockup_watchdog();
 
 	if (pool != NULL) {
 		memset((char *)uc_start, 0, size);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index bd513f5..176c97b 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -1225,7 +1225,6 @@ int ide_wait_not_busy(ide_hwif_t *hwif, unsigned long timeout)
 		 */
 		if (stat == 0xff)
 			return -ENODEV;
-		touch_softlockup_watchdog();
 		touch_nmi_watchdog();
 	}
 	return -EBUSY;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 30175c7..5fb2dce 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -313,7 +313,7 @@ static void ide_pio_datablock(ide_drive_t *drive, struct request *rq,
 	if (rq->bio)	/* fs request */
 		rq->errors = 0;
 
-	touch_softlockup_watchdog();
+	touch_cpu_softlockup_watchdog();
 
 	switch (drive->hwif->data_phase) {
 	case TASKFILE_MULTI_IN:
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 6af37b8..9669d5f 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -425,7 +425,7 @@ void nand_wait_ready(struct mtd_info *mtd)
 	do {
 		if (chip->dev_ready(mtd))
 			break;
-		touch_softlockup_watchdog();
+		touch_cpu_softlockup_watchdog();
 	} while (time_before(jiffies, timeo));
 	led_trigger_event(nand_led_trigger, LED_OFF);
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 49fe299..113421e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -225,6 +225,7 @@ extern void scheduler_tick(void);
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 extern void softlockup_tick(void);
 extern void spawn_softlockup_task(void);
+extern void touch_cpu_softlockup_watchdog(void);
 extern void touch_softlockup_watchdog(void);
 #else
 static inline void softlockup_tick(void)
@@ -233,6 +234,9 @@ static inline void softlockup_tick(void)
 static inline void spawn_softlockup_task(void)
 {
 }
+static inline void touch_cpu_softlockup_watchdog(void)
+{
+}
 static inline void touch_softlockup_watchdog(void)
 {
 }
diff --git a/kernel/panic.c b/kernel/panic.c
index 623d182..9e4565c 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -132,7 +132,7 @@ NORET_TYPE void panic(const char * fmt, ...)
 #endif
 	local_irq_enable();
 	for (i = 0;;) {
-		touch_softlockup_watchdog();
+		touch_cpu_softlockup_watchdog();
 		i += panic_blink(i);
 		mdelay(1);
 		i++;
diff --git a/kernel/power/swsusp.c b/kernel/power/swsusp.c
index 7fb8343..d259b12 100644
--- a/kernel/power/swsusp.c
+++ b/kernel/power/swsusp.c
@@ -323,7 +323,7 @@ int swsusp_resume(void)
 	 */
 	swsusp_free();
 	restore_processor_state();
-	touch_softlockup_watchdog();
+	touch_cpu_softlockup_watchdog();
 	device_power_up();
 	local_irq_enable();
 	return error;
diff --git a/kernel/sched.c b/kernel/sched.c
index a4ca632..243f558 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4783,6 +4783,7 @@ void show_state_filter(unsigned long state_filter)
 		if (p->state & state_filter)
 			show_task(p);
 	} while_each_thread(g, p);
+	touch_softlockup_watchdog();
 
 	read_unlock(&tasklist_lock);
 	/*
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 50afeb8..05b66db 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -8,6 +8,7 @@
  */
 #include <linux/mm.h>
 #include <linux/cpu.h>
+#include <linux/cpumask.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
@@ -34,10 +35,19 @@ static struct notifier_block panic_block = {
 	.notifier_call = softlock_panic,
 };
 
-void touch_softlockup_watchdog(void)
+void touch_cpu_softlockup_watchdog(void)
 {
 	__raw_get_cpu_var(touch_timestamp) = jiffies;
 }
+EXPORT_SYMBOL(touch_cpu_softlockup_watchdog);
+
+void touch_softlockup_watchdog(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		per_cpu(touch_timestamp, cpu) = jiffies;
+}
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
 /*
@@ -57,7 +67,7 @@ void softlockup_tick(void)
 
 	/* do not print during early bootup: */
 	if (unlikely(system_state != SYSTEM_RUNNING)) {
-		touch_softlockup_watchdog();
+		touch_cpu_softlockup_watchdog();
 		return;
 	}
 
@@ -94,7 +104,7 @@ static int watchdog(void * __bind_cpu)
 	 */
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		touch_softlockup_watchdog();
+		touch_cpu_softlockup_watchdog();
 		schedule();
 	}
 
