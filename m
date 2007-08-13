Return-Path: <linux-kernel-owner+w=401wt.eu-S944935AbXHMMre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944935AbXHMMre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966864AbXHMHaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:30:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:8557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966700AbXHMHaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:30:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,253,1183359600"; 
   d="scan'208";a="280147746"
Subject: [PATCH 2/3] x86_64 EFI runtime service support: EFI runtime
	services
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <ak@suse.de>, akpm@linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Aug 2007 15:30:23 +0800
Message-Id: <1186990223.22431.39.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 13 Aug 2007 07:30:00.0569 (UTC) FILETIME=[C1CFDE90:01C7DD7B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog between v3 of EFI x86_64 support patch and this version

1. EFI reboot runtime service is embedded into the framework of
   reboot_type.
2. Function pointers are used for EFI time runtime service.
3. A kernel command line option "noefi_time" is added to make it
   possible to fall back to CMOS based implementation.

---

This patch adds support for several EFI runtime services for EFI
x86_64 system.

The EFI support for emergency_restart and RTC clock is added. The EFI
based implementation and legacy BIOS or CMOS based implementation are
put in separate functions and can be chosen with kernel boot options.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 arch/x86_64/kernel/reboot.c            |   19 ++++++++-----
 arch/x86_64/kernel/time.c              |   48 ++++++++++++++++++++++-----------
 include/asm-x86_64/emergency-restart.h |    8 +++++
 include/asm-x86_64/time.h              |    7 ++++
 4 files changed, 60 insertions(+), 22 deletions(-)

Index: linux-2.6.23-rc2/arch/x86_64/kernel/reboot.c
===================================================================
--- linux-2.6.23-rc2.orig/arch/x86_64/kernel/reboot.c	2007-08-13 13:09:57.000000000 +0800
+++ linux-2.6.23-rc2/arch/x86_64/kernel/reboot.c	2007-08-13 13:47:55.000000000 +0800
@@ -9,6 +9,7 @@
 #include <linux/pm.h>
 #include <linux/kdebug.h>
 #include <linux/sched.h>
+#include <linux/efi.h>
 #include <asm/io.h>
 #include <asm/delay.h>
 #include <asm/hw_irq.h>
@@ -25,18 +26,16 @@
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
+   efi    Use efi reset_system runtime service. cold reset (default)
    force  Avoid anything that could hang.
  */ 
 static int __init reboot_setup(char *str)
@@ -54,6 +53,7 @@
 		case 't':
 		case 'b':
 		case 'k':
+		case 'e':
 			reboot_type = *str;
 			break;
 		case 'f':
@@ -141,7 +141,14 @@
 
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
 
Index: linux-2.6.23-rc2/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.23-rc2.orig/arch/x86_64/kernel/time.c	2007-08-13 13:09:57.000000000 +0800
+++ linux-2.6.23-rc2/arch/x86_64/kernel/time.c	2007-08-13 13:10:02.000000000 +0800
@@ -27,6 +27,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/kallsyms.h>
+#include <linux/efi.h>
 #include <linux/acpi.h>
 #ifdef CONFIG_ACPI
 #include <acpi/achware.h>	/* for PM timer frequency */
@@ -46,6 +47,7 @@
 #include <asm/mpspec.h>
 #include <asm/nmi.h>
 #include <asm/vgtod.h>
+#include <asm/time.h>
 
 static char *timename = NULL;
 
@@ -56,6 +58,12 @@
 
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
@@ -89,13 +97,6 @@
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
 
@@ -143,14 +144,23 @@
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
 
 void main_timer_handler(void)
@@ -195,14 +205,11 @@
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
@@ -217,8 +224,6 @@
 #endif
 	} while (sec != CMOS_READ(RTC_SECONDS));
 
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
 	/*
 	 * We know that x86-64 always uses BCD format, no need to check the
 	 * config register.
@@ -246,6 +251,17 @@
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
Index: linux-2.6.23-rc2/include/asm-x86_64/emergency-restart.h
===================================================================
--- linux-2.6.23-rc2.orig/include/asm-x86_64/emergency-restart.h	2007-08-13 13:09:57.000000000 +0800
+++ linux-2.6.23-rc2/include/asm-x86_64/emergency-restart.h	2007-08-13 13:10:02.000000000 +0800
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
Index: linux-2.6.23-rc2/include/asm-x86_64/time.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.23-rc2/include/asm-x86_64/time.h	2007-08-13 13:10:02.000000000 +0800
@@ -0,0 +1,7 @@
+#ifndef __ASM_X86_64_TIME_H
+#define __ASM_X86_64_TIME_H
+
+extern unsigned long (*get_wallclock)(void);
+extern int (*set_wallclock)(unsigned long nowtime);
+
+#endif
