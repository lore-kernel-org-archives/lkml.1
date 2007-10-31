Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbXJaWSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbXJaWSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbXJaWRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:17:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbXJaWRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:17:49 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 9/16] This patch add provisions for time related functions so they
Date: Wed, 31 Oct 2007 16:14:54 -0300
Message-Id: <11938581512730-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11938581451804-git-send-email-gcosta@redhat.com>
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com> <1193858118284-git-send-email-gcosta@redhat.com> <11938581242810-git-send-email-gcosta@redhat.com> <1193858130443-git-send-email-gcosta@redhat.com> <11938581351064-git-send-email-gcosta@redhat.com> <11938581403478-git-send-email-gcosta@redhat.com> <11938581451804-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

can be later replaced by paravirt versions.

it basically encloses {g,s}et_wallclock inside the
already existent functions update_persistent_clock and
read_persistent_clock, and defines {s,g}et_wallclock
to the core of such functions.

it also allow for a later-on-game time initialization, as done
by i386. Paravirt guests can set a function to do their own
initialization this way.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/time_64.c |   42 ++++++++++++++++++++++++++++--------------
 include/asm-x86/time.h    |   26 ++++++++++++++++++++++----
 2 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index c821edc..85ec401 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -33,9 +33,12 @@
 #include <acpi/acpi_bus.h>
 #endif
 #include <asm/i8253.h>
+#include <asm/arch_hooks.h>
 #include <asm/pgtable.h>
 #include <asm/vsyscall.h>
+#include <asm/time.h>
 #include <asm/timex.h>
+#include <asm/timer.h>
 #include <asm/proto.h>
 #include <asm/hpet.h>
 #include <asm/sections.h>
@@ -77,18 +80,12 @@ EXPORT_SYMBOL(profile_pc);
  * sheet for details.
  */
 
-static int set_rtc_mmss(unsigned long nowtime)
+int do_set_rtc_mmss(unsigned long nowtime)
 {
 	int retval = 0;
 	int real_seconds, real_minutes, cmos_minutes;
 	unsigned char control, freq_select;
 
-/*
- * IRQs are disabled when we're called from the timer interrupt,
- * no need for spin_lock_irqsave()
- */
-
-	spin_lock(&rtc_lock);
 
 /*
  * Tell the clock it's being set and stop it.
@@ -138,14 +135,22 @@ static int set_rtc_mmss(unsigned long nowtime)
 	CMOS_WRITE(control, RTC_CONTROL);
 	CMOS_WRITE(freq_select, RTC_FREQ_SELECT);
 
-	spin_unlock(&rtc_lock);
-
 	return retval;
 }
 
 int update_persistent_clock(struct timespec now)
 {
-	return set_rtc_mmss(now.tv_sec);
+	int retval;
+
+/*
+ * IRQs are disabled when we're called from the timer interrupt,
+ * no need for spin_lock_irqsave()
+ */
+	spin_lock(&rtc_lock);
+	retval = set_wallclock(now.tv_sec);
+	spin_unlock(&rtc_lock);
+
+	return retval;
 }
 
 static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
@@ -157,7 +162,7 @@ static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-unsigned long read_persistent_clock(void)
+unsigned long do_get_cmos_time(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
 	unsigned long flags;
@@ -208,10 +213,15 @@ unsigned long read_persistent_clock(void)
 	return mktime(year, mon, day, hour, min, sec);
 }
 
+unsigned long read_persistent_clock(void)
+{
+	return get_wallclock();
+}
+
 /* calibrate_cpu is used on systems with fixed rate TSCs to determine
  * processor frequency */
 #define TICK_COUNT 100000000
-static unsigned int __init tsc_calibrate_cpu_khz(void)
+unsigned long __init native_calculate_cpu_khz(void)
 {
 	int tsc_start, tsc_now;
 	int i, no_ctr_free;
@@ -261,20 +271,23 @@ static struct irqaction irq0 = {
 	.name		= "timer"
 };
 
-void __init time_init(void)
+void __init hpet_time_init(void)
 {
 	if (!hpet_enable())
 		setup_pit_timer();
 
 	setup_irq(0, &irq0);
+}
 
+void __init time_init(void)
+{
 	tsc_calibrate();
 
 	cpu_khz = tsc_khz;
 	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
 		boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
 		boot_cpu_data.x86 == 16)
-		cpu_khz = tsc_calibrate_cpu_khz();
+		cpu_khz = calculate_cpu_khz();
 
 	if (unsynchronized_tsc())
 		mark_tsc_unstable("TSCs unsynchronized");
@@ -287,4 +300,5 @@ void __init time_init(void)
 	printk(KERN_INFO "time.c: Detected %d.%03d MHz processor.\n",
 		cpu_khz / 1000, cpu_khz % 1000);
 	init_tsc_clocksource();
+	late_time_init = choose_time_init();
 }
diff --git a/include/asm-x86/time.h b/include/asm-x86/time.h
index eac0113..0d18c78 100644
--- a/include/asm-x86/time.h
+++ b/include/asm-x86/time.h
@@ -1,6 +1,10 @@
-#ifndef _ASMi386_TIME_H
-#define _ASMi386_TIME_H
+#ifndef _ASMX86_TIME_H
+#define _ASMX86_TIME_H
 
+extern void (*late_time_init)(void);
+extern void hpet_time_init(void);
+
+#ifndef CONFIG_X86_64
 #include <linux/efi.h>
 #include "mach_time.h"
 
@@ -28,8 +32,22 @@ static inline int native_set_wallclock(unsigned long nowtime)
 	return retval;
 }
 
-extern void (*late_time_init)(void);
-extern void hpet_time_init(void);
+#else
+extern unsigned long do_get_cmos_time(void);
+extern int do_set_rtc_mmss(unsigned long nowtime);
+extern void native_time_init_hook(void);
+
+static inline unsigned long native_get_wallclock(void)
+{
+	return do_get_cmos_time();
+}
+
+static inline int native_set_wallclock(unsigned long nowtime)
+{
+	return do_set_rtc_mmss(nowtime);
+}
+
+#endif
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
-- 
1.4.4.2

