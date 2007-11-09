Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbXKIVd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbXKIVd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbXKIV3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:29:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757780AbXKIV3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:29:32 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 17/24] This patch add provisions for time related functions so they
Date: Fri,  9 Nov 2007 16:42:58 -0200
Message-Id: <1194633878886-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1194633873306-git-send-email-gcosta@redhat.com>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com> <11946338212915-git-send-email-gcosta@redhat.com> <11946338263902-git-send-email-gcosta@redhat.com> <1194633831882-git-send-email-gcosta@redhat.com> <11946338361369-git-send-email-gcosta@redhat.com> <11946338413283-git-send-email-gcosta@redhat.com> <11946338473652-git-send-email-gcosta@redhat.com> <1194633852469-git-send-email-gcosta@redhat.com> <1194633857930-git-send-email-gcosta@redhat.com> <11946338621966-git-send-email-gcosta@redhat.com> <11946338683305-git-send-email-gcosta@redhat.com> <1194633873306-git-send-email-gcosta@redhat.com>
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
 arch/x86/kernel/time_64.c |   12 +++++++++---
 include/asm-x86/time.h    |   26 +++++++++++++++++++++-----
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index f88bf6b..89943d8 100644
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

