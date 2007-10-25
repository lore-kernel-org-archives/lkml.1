Return-Path: <linux-kernel-owner+w=401wt.eu-S1760488AbXJYGzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488AbXJYGzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 02:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760510AbXJYGz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 02:55:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:51194 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760458AbXJYGzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 02:55:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,328,1188802800"; 
   d="scan'208";a="357762000"
Subject: [PATCH 2/3 -v4] x86_64 EFI runtime service support: EFI runtime
	services
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Oct 2007 14:58:05 +0800
Message-Id: <1193295485.23935.203.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 25 Oct 2007 06:55:18.0727 (UTC) FILETIME=[0117BD70:01C816D4]
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
 arch/x86/kernel/time_64.c           |   48 ++++++++++++++++++++++++------------
 include/asm-x86/emergency-restart.h |    8 ++++++
 include/asm-x86/time_64.h           |    7 +++++
 4 files changed, 60 insertions(+), 22 deletions(-)

Index: linux-2.6.24-rc1/arch/x86/kernel/reboot_64.c
===================================================================
--- linux-2.6.24-rc1.orig/arch/x86/kernel/reboot_64.c	2007-10-25 11:25:29.000000000 +0800
+++ linux-2.6.24-rc1/arch/x86/kernel/reboot_64.c	2007-10-25 11:25:38.000000000 +0800
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
--- linux-2.6.24-rc1.orig/arch/x86/kernel/time_64.c	2007-10-25 11:25:29.000000000 +0800
+++ linux-2.6.24-rc1/arch/x86/kernel/time_64.c	2007-10-25 11:25:38.000000000 +0800
@@ -25,6 +25,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/kallsyms.h>
+#include <linux/efi.h>
 #include <linux/acpi.h>
 #include <linux/clockchips.h>
 
@@ -45,12 +46,19 @@
 #include <asm/mpspec.h>
 #include <asm/nmi.h>
 #include <asm/vgtod.h>
+#include <asm/time_64.h>
 
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
@@ -84,13 +92,6 @@
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
 
@@ -138,14 +139,23 @@
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
@@ -157,14 +167,11 @@
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
@@ -179,8 +186,6 @@
 #endif
 	} while (sec != CMOS_READ(RTC_SECONDS));
 
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
 	/*
 	 * We know that x86-64 always uses BCD format, no need to check the
 	 * config register.
@@ -208,6 +213,17 @@
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
--- linux-2.6.24-rc1.orig/include/asm-x86/emergency-restart.h	2007-10-25 11:25:29.000000000 +0800
+++ linux-2.6.24-rc1/include/asm-x86/emergency-restart.h	2007-10-25 11:25:38.000000000 +0800
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
+++ linux-2.6.24-rc1/include/asm-x86/time_64.h	2007-10-25 11:25:38.000000000 +0800
@@ -0,0 +1,7 @@
+#ifndef __ASM_X86_64_TIME_H
+#define __ASM_X86_64_TIME_H
+
+extern unsigned long (*get_wallclock)(void);
+extern int (*set_wallclock)(unsigned long nowtime);
+
+#endif
