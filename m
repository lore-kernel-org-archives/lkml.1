Return-Path: <linux-kernel-owner+w=401wt.eu-S966709AbXEGUgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966709AbXEGUgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966658AbXEGUgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:36:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:41802 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966700AbXEGUgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:36:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="243050692"
Date: Mon, 7 May 2007 13:34:20 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 7/8] HPET boot option for the new standard interrupt delivery mode
Message-ID: <20070507203420.GG3926@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add a new boot option related to HPET. Current mode of HPET functioning:

(1) If HPET is listed in BIOS:
default: HPET gets detected at boot time and gets enabled in 
"legacy replacement" mode.
"hpet=standard" boot option: HPET does not get used during early boot and
PIT will be used in early boot. HPET gets enabled in "standard" mode during
late boot stages.
"hpet=disable" boot option: HPET is disabled and not used.

(2) If HPET is not listed in BIOS and force detected with PCI quirks:
default: HPET does not get used during early boot and
PIT will be used in early boot. HPET gets enabled in "standard" mode during
late boot stages.
"hpet=disable" boot option: HPET is disabled and not used.


We can change the default behavior of (1) to match (2) after this patch gets
some testing.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21/include/asm-i386/hpet.h
===================================================================
--- linux-2.6.21.orig/include/asm-i386/hpet.h	2007-04-27 15:27:12.000000000 -0700
+++ linux-2.6.21/include/asm-i386/hpet.h	2007-04-27 15:30:22.000000000 -0700
@@ -112,7 +112,7 @@
 extern int is_hpet_capable(void);
 extern int hpet_readl(unsigned long a);
 #else
-extern int hpet_enable(void);
+extern int hpet_enable(int early_call);
 #endif
 
 #ifdef CONFIG_HPET_EMULATE_RTC
@@ -127,7 +127,7 @@
 
 #else
 
-static inline int hpet_enable(void) { return 0; }
+static inline int hpet_enable(int early_call) { return 0; }
 
 #endif /* CONFIG_HPET_TIMER */
 #endif /* _I386_HPET_H */
Index: linux-2.6.21/arch/i386/kernel/time.c
===================================================================
--- linux-2.6.21.orig/arch/i386/kernel/time.c	2007-04-27 15:27:12.000000000 -0700
+++ linux-2.6.21/arch/i386/kernel/time.c	2007-04-27 15:30:22.000000000 -0700
@@ -264,7 +264,7 @@
 /* Duplicate of time_init() below, with hpet_enable part added */
 void __init hpet_time_init(void)
 {
-	if (!hpet_enable())
+	if (!hpet_enable(1))
 		setup_pit_timer();
 	time_init_hook();
 }
Index: linux-2.6.21/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.21.orig/arch/i386/kernel/hpet.c	2007-04-27 15:30:15.000000000 -0700
+++ linux-2.6.21/arch/i386/kernel/hpet.c	2007-04-27 15:30:22.000000000 -0700
@@ -51,6 +51,8 @@
 	if (str) {
 		if (!strncmp("disable", str, 7))
 			boot_hpet_disable = 1;
+		else if (!strncmp("standard", str, 9))
+			hpet_preferred_int_mode = HPET_INT_STD;
 	}
 	return 1;
 }
@@ -723,13 +725,16 @@
 /*
  * Try to setup the HPET timer
  */
-int __init hpet_enable(void)
+int __init hpet_enable(int early_call)
 {
 	unsigned long id;
 
 	if (hpet_virt_address)
 		return 0;
 
+	if (early_call && hpet_preferred_int_mode == HPET_INT_STD)
+		return 0;
+
 	if (!is_hpet_capable())
 		return 0;
 
@@ -784,13 +789,15 @@
 	if (boot_hpet_disable)
 		return -ENODEV;
 
-	if (!hpet_address) {
-		if (!force_hpet_address)
-			return -ENODEV;
+	if (!hpet_virt_address) {
+		if (!hpet_address) {
+			if (!force_hpet_address)
+				return -ENODEV;
 
-		hpet_address = force_hpet_address;
+			hpet_address = force_hpet_address;
+		}
 		hpet_preferred_int_mode = HPET_INT_STD;
-		ret = hpet_enable();
+		ret = hpet_enable(0);
 		if (ret < 0 || !hpet_virt_address)
 			return -ENODEV;
 	}
Index: linux-2.6.21/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.21.orig/Documentation/kernel-parameters.txt	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21/Documentation/kernel-parameters.txt	2007-04-27 15:31:31.000000000 -0700
@@ -384,8 +384,8 @@
 			over the 8254 in addition to over the IO-APIC. The
 			kernel tries to set a sensible default.
 
-	hpet=		[IA-32,HPET] option to disable HPET and use PIT.
-			Format: disable
+	hpet=		[IA-32,HPET] option to choose HPET modes.
+			Format: {disable | standard}
 
 	cm206=		[HW,CD]
 			Format: { auto | [<io>,][<irq>] }
