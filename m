Return-Path: <linux-kernel-owner+w=401wt.eu-S966674AbXEGUep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966674AbXEGUep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966660AbXEGUeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:34:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:39734 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966637AbXEGUen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:34:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="84696939"
Date: Mon, 7 May 2007 13:32:17 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 5/8] Late init of HPET after PCI quirk detection
Message-ID: <20070507203217.GE3926@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Enable HPET later during boot, after the force detect in PCI quirks.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21-rc-mm-hpet/include/asm-i386/hpet.h
===================================================================
--- linux-2.6.21-rc-mm-hpet.orig/include/asm-i386/hpet.h	2007-04-17 14:09:06.000000000 -0700
+++ linux-2.6.21-rc-mm-hpet/include/asm-i386/hpet.h	2007-04-18 10:03:47.000000000 -0700
@@ -91,6 +91,7 @@
 #define HPET_TICK_RATE  (HZ * 100000UL)
 
 extern unsigned long hpet_address;	/* hpet memory map physical address */
+extern unsigned long force_hpet_address;/* hpet address as detected by quirks */
 extern int is_hpet_enabled(void);
 
 #ifdef CONFIG_X86_64
Index: linux-2.6.21-rc-mm-hpet/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.21-rc-mm-hpet.orig/arch/i386/kernel/hpet.c	2007-04-17 15:51:34.000000000 -0700
+++ linux-2.6.21-rc-mm-hpet/arch/i386/kernel/hpet.c	2007-04-18 10:00:20.000000000 -0700
@@ -125,6 +125,7 @@
 	.set_next_event = hpet_legacy_next_event,
 	.shift		= 32,
 	.irq		= 0,
+	.rating		= 50,
 };
 
 static void hpet_start_counter(void)
@@ -285,6 +286,9 @@
 {
 	unsigned long id;
 
+	if (hpet_virt_address)
+		return 0;
+
 	if (!is_hpet_capable())
 		return 0;
 
@@ -329,6 +333,26 @@
 }
 
 
+static int __init hpet_late_init(void)
+{
+	if (boot_hpet_disable)
+		return -ENODEV;
+
+	if (!hpet_address) {
+		if (!force_hpet_address)
+			return -ENODEV;
+
+		hpet_address = force_hpet_address;
+		hpet_enable();
+		if (!hpet_virt_address)
+			return -ENODEV;
+	}
+
+	return 0;
+}
+module_init(hpet_late_init);
+
+
 #ifdef CONFIG_HPET_EMULATE_RTC
 
 /* HPET in LegacyReplacement Mode eats up RTC interrupt line. When, HPET
