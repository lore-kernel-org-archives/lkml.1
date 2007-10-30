Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbXJ3Fx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbXJ3Fx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 01:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbXJ3FxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 01:53:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:36681 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbXJ3FxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 01:53:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,345,1188802800"; 
   d="scan'208";a="308136315"
Subject: [PATCH 2/4 -v5] x86_64 EFI runtime service support: EFI runtime
	services
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 30 Oct 2007 13:55:43 +0800
Message-Id: <1193723743.23935.352.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 30 Oct 2007 05:52:42.0220 (UTC) FILETIME=[161B02C0:01C81AB9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for several EFI runtime services for EFI
x86_64 system.

The EFI support for emergency_restart and RTC clock is added. The EFI
based implementation and legacy BIOS or CMOS based implementation are
put in separate functions and can be chosen with kernel boot options.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 arch/x86/kernel/reboot_64.c         |   19 +++++++++-----
 arch/x86/kernel/time_64.c           |   47 +++++++++++++++++++++++-------------
 include/asm-x86/emergency-restart.h |    8 ++++++
 include/asm-x86/time.h              |   47 +++---------------------------------
 include/asm-x86/time_32.h           |   44 +++++++++++++++++++++++++++++++++
 include/asm-x86/time_64.h           |    7 +++++
 6 files changed, 107 insertions(+), 65 deletions(-)

Index: linux-2.6.24-rc1/arch/x86/kernel/reboot_64.c
===================================================================
--- linux-2.6.24-rc1.orig/arch/x86/kernel/reboot_64.c	2007-10-30 10:15:03.000000000 +0800
+++ linux-2.6.24-rc1/arch/x86/kernel/reboot_64.c	2007-10-30 10:22:00.000000000 +0800
@@ -9,6 +9,7 @@
 #include <linux/pm.h>
 #include <linux/kdebug.h>
 #include <linux/sched.h>
+#include <linux/efi.h>
 #include <asm/io.h>
 #include <asm/delay.h>
 #include <asm/desc.h>
@@ -26,18 +27,16 @@
 EXPORT_SYMBOL(pm_power_off);
 
 static long no_idt[3];
-static enum { 
-	BOOT_TRIPLE = 't',
-	BOOT_KBD = 'k'
-} reboot_type = BOOT_KBD;
+enum reboot_type reboot_type = BOOT_KBD;
 static int reboot_mode = 0;
 int reboot_force;
 
-/* reboot=t[riple] | k[bd] [, [w]arm | [c]old]
+/* reboot=t[riple] | k[bd] | e[fi] [, [w]arm | [c]old]
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
    kbd    Use the keyboard controller. cold reset (default)
+   efi    Use efi reset_system runtime service
    force  Avoid anything that could hang.
  */ 
 static int __init reboot_setup(char *str)
@@ -55,6 +54,7 @@
 		case 't':
 		case 'b':
 		case 'k':
+		case 'e':
 			reboot_type = *str;
 			break;
 		case 'f':
@@ -142,7 +142,14 @@
 
 			reboot_type = BOOT_KBD;
 			break;
-		}      
+
+		case BOOT_EFI:
+			if (efi_enabled)
+				efi.reset_system(reboot_mode ? EFI_RESET_WARM : EFI_RESET_COLD,
+						 EFI_SUCCESS, 0, NULL);
+			reboot_type = BOOT_KBD;
+			break;
+		}
 	}      
 }
 
Index: linux-2.6.24-rc1/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.24-rc1.orig/arch/x86/kernel/time_64.c	2007-10-30 10:15:03.000000000 +0800
+++ linux-2.6.24-rc1/arch/x86/kernel/time_64.c	2007-10-30 10:22:04.000000000 +0800
@@ -45,12 +45,19 @@
 #include <asm/mpspec.h>
 #include <asm/nmi.h>
 #include <asm/vgtod.h>
+#include <asm/time.h>
 
 DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
 
 volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
 
+static int set_rtc_mmss(unsigned long nowtime);
+static unsigned long read_cmos_clock(void);
+
+unsigned long (*get_wallclock)(void) = read_cmos_clock;
+int (*set_wallclock)(unsigned long nowtime) = set_rtc_mmss;
+
 unsigned long profile_pc(struct pt_regs *regs)
 {
 	unsigned long pc = instruction_pointer(regs);
@@ -84,13 +91,6 @@
 	unsigned char control, freq_select;
 
 /*
- * IRQs are disabled when we're called from the timer interrupt,
- * no need for spin_lock_irqsave()
- */
-
-	spin_lock(&rtc_lock);
-
-/*
  * Tell the clock it's being set and stop it.
  */
 
@@ -138,14 +138,23 @@
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
+
+	spin_lock(&rtc_lock);
+	retval = set_wallclock(now.tv_sec);
+	spin_unlock(&rtc_lock);
+
+	return retval;
 }
 
 static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
@@ -157,14 +166,11 @@
 	return IRQ_HANDLED;
 }
 
-unsigned long read_persistent_clock(void)
+static unsigned long read_cmos_clock(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
-	unsigned long flags;
 	unsigned century = 0;
 
-	spin_lock_irqsave(&rtc_lock, flags);
-
 	do {
 		sec = CMOS_READ(RTC_SECONDS);
 		min = CMOS_READ(RTC_MINUTES);
@@ -179,8 +185,6 @@
 #endif
 	} while (sec != CMOS_READ(RTC_SECONDS));
 
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
 	/*
 	 * We know that x86-64 always uses BCD format, no need to check the
 	 * config register.
@@ -208,6 +212,17 @@
 	return mktime(year, mon, day, hour, min, sec);
 }
 
+unsigned long read_persistent_clock(void)
+{
+	unsigned long flags, retval;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	retval = get_wallclock();
+	spin_unlock_irqrestore(&rtc_lock, flags);
+
+	return retval;
+}
+
 /* calibrate_cpu is used on systems with fixed rate TSCs to determine
  * processor frequency */
 #define TICK_COUNT 100000000
Index: linux-2.6.24-rc1/include/asm-x86/emergency-restart.h
===================================================================
--- linux-2.6.24-rc1.orig/include/asm-x86/emergency-restart.h	2007-10-30 10:15:03.000000000 +0800
+++ linux-2.6.24-rc1/include/asm-x86/emergency-restart.h	2007-10-30 10:22:00.000000000 +0800
@@ -1,6 +1,14 @@
 #ifndef _ASM_EMERGENCY_RESTART_H
 #define _ASM_EMERGENCY_RESTART_H
 
+enum reboot_type {
+	BOOT_TRIPLE = 't',
+	BOOT_KBD = 'k',
+	BOOT_EFI = 'e'
+};
+
+extern enum reboot_type reboot_type;
+
 extern void machine_emergency_restart(void);
 
 #endif /* _ASM_EMERGENCY_RESTART_H */
Index: linux-2.6.24-rc1/include/asm-x86/time_64.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.24-rc1/include/asm-x86/time_64.h	2007-10-30 10:22:00.000000000 +0800
@@ -0,0 +1,7 @@
+#ifndef __ASM_X86_TIME_64_H
+#define __ASM_X86_TIME_64_H
+
+extern unsigned long (*get_wallclock)(void);
+extern int (*set_wallclock)(unsigned long nowtime);
+
+#endif
Index: linux-2.6.24-rc1/include/asm-x86/time.h
===================================================================
--- linux-2.6.24-rc1.orig/include/asm-x86/time.h	2007-10-30 10:15:03.000000000 +0800
+++ linux-2.6.24-rc1/include/asm-x86/time.h	2007-10-30 10:22:00.000000000 +0800
@@ -1,44 +1,5 @@
-#ifndef _ASMi386_TIME_H
-#define _ASMi386_TIME_H
-
-#include <linux/efi.h>
-#include "mach_time.h"
-
-static inline unsigned long native_get_wallclock(void)
-{
-	unsigned long retval;
-
-	if (efi_enabled)
-		retval = efi_get_time();
-	else
-		retval = mach_get_cmos_time();
-
-	return retval;
-}
-
-static inline int native_set_wallclock(unsigned long nowtime)
-{
-	int retval;
-
-	if (efi_enabled)
-		retval = efi_set_rtc_mmss(nowtime);
-	else
-		retval = mach_set_rtc_mmss(nowtime);
-
-	return retval;
-}
-
-extern void (*late_time_init)(void);
-extern void hpet_time_init(void);
-
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else /* !CONFIG_PARAVIRT */
-
-#define get_wallclock() native_get_wallclock()
-#define set_wallclock(x) native_set_wallclock(x)
-#define choose_time_init() hpet_time_init
-
-#endif /* CONFIG_PARAVIRT */
-
+#ifdef CONFIG_X86_32
+# include "time_32.h"
+#else
+# include "time_64.h"
 #endif
Index: linux-2.6.24-rc1/include/asm-x86/time_32.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.24-rc1/include/asm-x86/time_32.h	2007-10-30 10:22:00.000000000 +0800
@@ -0,0 +1,44 @@
+#ifndef _ASMi386_TIME_H
+#define _ASMi386_TIME_H
+
+#include <linux/efi.h>
+#include "mach_time.h"
+
+static inline unsigned long native_get_wallclock(void)
+{
+	unsigned long retval;
+
+	if (efi_enabled)
+		retval = efi_get_time();
+	else
+		retval = mach_get_cmos_time();
+
+	return retval;
+}
+
+static inline int native_set_wallclock(unsigned long nowtime)
+{
+	int retval;
+
+	if (efi_enabled)
+		retval = efi_set_rtc_mmss(nowtime);
+	else
+		retval = mach_set_rtc_mmss(nowtime);
+
+	return retval;
+}
+
+extern void (*late_time_init)(void);
+extern void hpet_time_init(void);
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else /* !CONFIG_PARAVIRT */
+
+#define get_wallclock() native_get_wallclock()
+#define set_wallclock(x) native_set_wallclock(x)
+#define choose_time_init() hpet_time_init
+
+#endif /* CONFIG_PARAVIRT */
+
+#endif
