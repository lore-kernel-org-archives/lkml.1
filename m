Return-Path: <linux-kernel-owner+w=401wt.eu-S1761094AbXLLPqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761094AbXLLPqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbXLLPmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:42:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563AbXLLPmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:42:03 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 4/6] prepare time related functions for paravirt
Date: Wed, 12 Dec 2007 10:57:25 -0200
Message-Id: <11974642754014-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11974642682229-git-send-email-gcosta@redhat.com>
References: <11974642471600-git-send-email-gcosta@redhat.com> <11974642553841-git-send-email-gcosta@redhat.com> <11974642622800-git-send-email-gcosta@redhat.com> <11974642682229-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add provisions for time related functions so they
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
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/time_64.c |   12 +++++++++---
 include/asm-x86/time.h    |   26 +++++++++++++++++++++-----
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index bf0bcc9..91d4d49 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -21,6 +21,8 @@
 #include <asm/hpet.h>
 #include <asm/nmi.h>
 #include <asm/vgtod.h>
+#include <asm/time.h>
+#include <asm/timer.h>
 
 volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
 
@@ -54,7 +56,7 @@ static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
 /* calibrate_cpu is used on systems with fixed rate TSCs to determine
  * processor frequency */
 #define TICK_COUNT 100000000
-static unsigned int __init tsc_calibrate_cpu_khz(void)
+unsigned long __init native_calculate_cpu_khz(void)
 {
 	int tsc_start, tsc_now;
 	int i, no_ctr_free;
@@ -104,20 +106,23 @@ static struct irqaction irq0 = {
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
@@ -130,4 +135,5 @@ void __init time_init(void)
 	printk(KERN_INFO "time.c: Detected %d.%03d MHz processor.\n",
 		cpu_khz / 1000, cpu_khz % 1000);
 	init_tsc_clocksource();
+	late_time_init = choose_time_init();
 }
diff --git a/include/asm-x86/time.h b/include/asm-x86/time.h
index b3f94cd..68779b0 100644
--- a/include/asm-x86/time.h
+++ b/include/asm-x86/time.h
@@ -1,8 +1,12 @@
-#ifndef _ASMi386_TIME_H
-#define _ASMi386_TIME_H
+#ifndef _ASMX86_TIME_H
+#define _ASMX86_TIME_H
+
+extern void (*late_time_init)(void);
+extern void hpet_time_init(void);
 
-#include <linux/efi.h>
 #include <asm/mc146818rtc.h>
+#ifdef CONFIG_X86_32
+#include <linux/efi.h>
 
 static inline unsigned long native_get_wallclock(void)
 {
@@ -28,8 +32,20 @@ static inline int native_set_wallclock(unsigned long nowtime)
 	return retval;
 }
 
-extern void (*late_time_init)(void);
-extern void hpet_time_init(void);
+#else
+extern void native_time_init_hook(void);
+
+static inline unsigned long native_get_wallclock(void)
+{
+	return mach_get_cmos_time();
+}
+
+static inline int native_set_wallclock(unsigned long nowtime)
+{
+	return mach_set_rtc_mmss(nowtime);
+}
+
+#endif
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
-- 
1.4.4.2

