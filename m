Return-Path: <linux-kernel-owner+w=401wt.eu-S932237AbZJINtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbZJINtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 09:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760829AbZJINtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 09:49:22 -0400
Received: from relay1.sgi.com ([192.48.179.29]:49251 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760804AbZJINtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 09:49:21 -0400
Date: Fri, 9 Oct 2009 08:47:27 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86 UV: Fixes for UV rtc timers
Message-ID: <20091009134727.GB3218@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miscellaneous fixes and cleanup for uv rtc timers.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 arch/x86/kernel/irq.c     |   10 +----
 arch/x86/kernel/uv_time.c |   81 +++++++++++++++++++++++++++++-------------
 2 files changed, 58 insertions(+), 33 deletions(-)

Index: linux/arch/x86/kernel/uv_time.c
===================================================================
--- linux.orig/arch/x86/kernel/uv_time.c	2009-10-08 11:31:05.000000000 -0500
+++ linux/arch/x86/kernel/uv_time.c	2009-10-09 07:49:05.000000000 -0500
@@ -25,6 +25,7 @@
 #include <asm/uv/bios.h>
 #include <asm/uv/uv.h>
 #include <asm/apic.h>
+#include <asm/idle.h>
 #include <asm/cpu.h>
 
 #define RTC_NAME		"sgi_rtc"
@@ -75,6 +76,7 @@ struct uv_rtc_timer_head {
 static struct uv_rtc_timer_head		**blade_info __read_mostly;
 
 static int				uv_rtc_enable;
+static int				uv_rtc_evt_enable;
 
 /*
  * Hardware interface routines
@@ -123,7 +125,10 @@ static int uv_setup_intr(int cpu, u64 ex
 	/* Initialize comparator value */
 	uv_write_global_mmr64(pnode, UVH_INT_CMPB, expires);
 
-	return (expires < uv_read_rtc(NULL) && !uv_intr_pending(pnode));
+	if (uv_read_rtc(NULL) <= expires)
+		return 0;
+
+	return !uv_intr_pending(pnode);
 }
 
 /*
@@ -223,6 +228,7 @@ static int uv_rtc_set_timer(int cpu, u64
 
 	next_cpu = head->next_cpu;
 	*t = expires;
+
 	/* Will this one be next to go off? */
 	if (next_cpu < 0 || bcpu == next_cpu ||
 			expires < head->cpu[next_cpu].expires) {
@@ -231,7 +237,7 @@ static int uv_rtc_set_timer(int cpu, u64
 			*t = ULLONG_MAX;
 			uv_rtc_find_next_timer(head, pnode);
 			spin_unlock_irqrestore(&head->lock, flags);
-			return 1;
+			return -ETIME;
 		}
 	}
 
@@ -244,7 +250,7 @@ static int uv_rtc_set_timer(int cpu, u64
  *
  * Returns 1 if this timer was pending.
  */
-static int uv_rtc_unset_timer(int cpu)
+static int uv_rtc_unset_timer(int cpu, int force)
 {
 	int pnode = uv_cpu_to_pnode(cpu);
 	int bid = uv_cpu_to_blade_id(cpu);
@@ -256,14 +262,15 @@ static int uv_rtc_unset_timer(int cpu)
 
 	spin_lock_irqsave(&head->lock, flags);
 
-	if (head->next_cpu == bcpu && uv_read_rtc(NULL) >= *t)
+	if ((head->next_cpu == bcpu && uv_read_rtc(NULL) >= *t) || force)
 		rc = 1;
 
-	*t = ULLONG_MAX;
-
-	/* Was the hardware setup for this timer? */
-	if (head->next_cpu == bcpu)
-		uv_rtc_find_next_timer(head, pnode);
+	if (rc) {
+		*t = ULLONG_MAX;
+		/* Was the hardware setup for this timer? */
+		if (head->next_cpu == bcpu)
+			uv_rtc_find_next_timer(head, pnode);
+	}
 
 	spin_unlock_irqrestore(&head->lock, flags);
 
@@ -310,7 +317,7 @@ static void uv_rtc_timer_setup(enum cloc
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		uv_rtc_unset_timer(ced_cpu);
+		uv_rtc_unset_timer(ced_cpu, 1);
 		break;
 	}
 }
@@ -320,13 +327,21 @@ static void uv_rtc_interrupt(void)
 	struct clock_event_device *ced = &__get_cpu_var(cpu_ced);
 	int cpu = smp_processor_id();
 
+	exit_idle();
+
+	irq_enter();
+
+	ack_APIC_irq();
+
 	if (!ced || !ced->event_handler)
-		return;
+		goto out;
 
-	if (uv_rtc_unset_timer(cpu) != 1)
-		return;
+	if (uv_rtc_unset_timer(cpu, 0) != 1)
+		goto out;
 
 	ced->event_handler(ced);
+out:
+	irq_exit();
 }
 
 static int __init uv_enable_rtc(char *str)
@@ -337,6 +352,14 @@ static int __init uv_enable_rtc(char *st
 }
 __setup("uvrtc", uv_enable_rtc);
 
+static int __init uv_enable_evt_rtc(char *str)
+{
+	uv_rtc_evt_enable = 1;
+
+	return 1;
+}
+__setup("uvrtcevt", uv_enable_evt_rtc);
+
 static __init void uv_rtc_register_clockevents(struct work_struct *dummy)
 {
 	struct clock_event_device *ced = &__get_cpu_var(cpu_ced);
@@ -353,24 +376,25 @@ static __init int uv_rtc_setup_clock(voi
 	if (!uv_rtc_enable || !is_uv_system() || generic_interrupt_extension)
 		return -ENODEV;
 
-	generic_interrupt_extension = uv_rtc_interrupt;
-
 	clocksource_uv.mult = clocksource_hz2mult(sn_rtc_cycles_per_second,
 				clocksource_uv.shift);
 
 	rc = clocksource_register(&clocksource_uv);
-	if (rc) {
-		generic_interrupt_extension = NULL;
+	if (rc)
+		printk(KERN_INFO "UV RTC clocksource failed rc %d\n", rc);
+	else
+		printk(KERN_INFO "UV RTC clocksource registered freq %lu MHz\n",
+			sn_rtc_cycles_per_second/(unsigned long)1E6);
+
+	if (rc || !uv_rtc_evt_enable)
 		return rc;
-	}
+
+	generic_interrupt_extension = uv_rtc_interrupt;
 
 	/* Setup and register clockevents */
 	rc = uv_rtc_allocate_timers();
-	if (rc) {
-		clocksource_unregister(&clocksource_uv);
-		generic_interrupt_extension = NULL;
-		return rc;
-	}
+	if (rc)
+		goto error;
 
 	clock_event_device_uv.mult = div_sc(sn_rtc_cycles_per_second,
 				NSEC_PER_SEC, clock_event_device_uv.shift);
@@ -383,10 +407,17 @@ static __init int uv_rtc_setup_clock(voi
 
 	rc = schedule_on_each_cpu(uv_rtc_register_clockevents);
 	if (rc) {
-		clocksource_unregister(&clocksource_uv);
-		generic_interrupt_extension = NULL;
 		uv_rtc_deallocate_timers();
+		goto error;
 	}
+	printk(KERN_INFO "UV RTC clockevents registered\n");
+
+	return 0;
+
+error:
+	generic_interrupt_extension = NULL;
+	clocksource_unregister(&clocksource_uv);
+	printk(KERN_INFO "UV RTC clockevents failed rc %d\n", rc);
 
 	return rc;
 }
Index: linux/arch/x86/kernel/irq.c
===================================================================
--- linux.orig/arch/x86/kernel/irq.c	2009-10-08 11:31:05.000000000 -0500
+++ linux/arch/x86/kernel/irq.c	2009-10-08 11:31:15.000000000 -0500
@@ -257,18 +257,12 @@ void smp_generic_interrupt(struct pt_reg
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
-	ack_APIC_irq();
-
-	exit_idle();
-
-	irq_enter();
-
 	inc_irq_stat(generic_irqs);
 
 	if (generic_interrupt_extension)
 		generic_interrupt_extension();
-
-	irq_exit();
+	else
+		ack_APIC_irq();
 
 	set_irq_regs(old_regs);
 }
