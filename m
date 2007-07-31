Return-Path: <linux-kernel-owner+w=401wt.eu-S967622AbXGaDOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967622AbXGaDOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967391AbXGaDNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:13:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:24523 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967277AbXGaDNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:13:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,201,1183359600"; 
   d="scan'208";a="256697417"
Subject: [PATCH 3/5] x86_64 EFI support -v3: EFI runtime support
From: "Huang, Ying" <ying.huang@intel.com>
To: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Jul 2007 11:12:59 +0800
Message-Id: <1185851579.23149.28.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 31 Jul 2007 03:13:10.0641 (UTC) FILETIME=[B968B610:01C7D320]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds runtime service support for EFI x86_64 system.

The EFI support for emergency_restart and RTC clock is added. The EFI
based implementation and legacy BIOS or CMOS based implementation are
put in separate functions and are chosen based on the value of
efi_enabled.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 reboot.c |   11 ++++++++++-
 time.c   |   47 +++++++++++++++++++++++++++++++----------------
 2 files changed, 41 insertions(+), 17 deletions(-)

Index: linux-2.6.23-rc1/arch/x86_64/kernel/reboot.c
===================================================================
--- linux-2.6.23-rc1.orig/arch/x86_64/kernel/reboot.c	2007-07-23 04:41:00.000000000 +0800
+++ linux-2.6.23-rc1/arch/x86_64/kernel/reboot.c	2007-07-30 09:26:56.000000000 +0800
@@ -9,6 +9,7 @@
 #include <linux/pm.h>
 #include <linux/kdebug.h>
 #include <linux/sched.h>
+#include <linux/efi.h>
 #include <asm/io.h>
 #include <asm/delay.h>
 #include <asm/hw_irq.h>
@@ -117,7 +118,7 @@
 	pci_iommu_shutdown();
 }
 
-void machine_emergency_restart(void)
+static inline void bios_emergency_restart(void)
 {
 	int i;
 
@@ -145,6 +146,14 @@
 	}      
 }
 
+void machine_emergency_restart(void)
+{
+	if (efi_enabled)
+		efi_emergency_restart();
+	else
+		bios_emergency_restart();
+}
+
 void machine_restart(char * __unused)
 {
 	printk("machine restart\n");
Index: linux-2.6.23-rc1/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.23-rc1.orig/arch/x86_64/kernel/time.c	2007-07-23 04:41:00.000000000 +0800
+++ linux-2.6.23-rc1/arch/x86_64/kernel/time.c	2007-07-30 09:42:12.000000000 +0800
@@ -27,6 +27,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/kallsyms.h>
+#include <linux/efi.h>
 #include <linux/acpi.h>
 #ifdef CONFIG_ACPI
 #include <acpi/achware.h>	/* for PM timer frequency */
@@ -89,13 +90,6 @@
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
 
@@ -143,14 +137,26 @@
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
+	if (efi_enabled)
+		retval = efi_set_rtc_mmss(now.tv_sec);
+	else
+		retval = set_rtc_mmss(now.tv_sec);
+	spin_unlock(&rtc_lock);
+
+	return retval;
 }
 
 void main_timer_handler(void)
@@ -195,14 +201,11 @@
 	return IRQ_HANDLED;
 }
 
-unsigned long read_persistent_clock(void)
+unsigned long read_cmos_clock(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
-	unsigned long flags;
 	unsigned century = 0;
 
-	spin_lock_irqsave(&rtc_lock, flags);
-
 	do {
 		sec = CMOS_READ(RTC_SECONDS);
 		min = CMOS_READ(RTC_MINUTES);
@@ -217,8 +220,6 @@
 #endif
 	} while (sec != CMOS_READ(RTC_SECONDS));
 
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
 	/*
 	 * We know that x86-64 always uses BCD format, no need to check the
 	 * config register.
@@ -246,6 +247,20 @@
 	return mktime(year, mon, day, hour, min, sec);
 }
 
+unsigned long read_persistent_clock(void)
+{
+	unsigned long flags, retval;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	if (efi_enabled)
+		retval = efi_get_time();
+	else
+		retval = read_cmos_clock();
+	spin_unlock_irqrestore(&rtc_lock, flags);
+
+	return retval;
+}
+
 /* calibrate_cpu is used on systems with fixed rate TSCs to determine
  * processor frequency */
 #define TICK_COUNT 100000000
