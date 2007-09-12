Return-Path: <linux-kernel-owner+w=401wt.eu-S1764141AbXILTZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764141AbXILTZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 15:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXILTYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 15:24:39 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57639 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbXILTYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 15:24:38 -0400
Date: Wed, 12 Sep 2007 12:33:38 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: check and enable MMCONFIG for AMD Family 10h Opteron
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200709121233.39218.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: check and enable MMCONFIG for AMD Family 10h Opteron

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86_64/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/setup.c	2007-09-12 11:28:08.000000000 -0700
+++ linux-2.6/arch/x86_64/kernel/setup.c	2007-09-12 12:09:32.000000000 -0700
@@ -507,6 +507,32 @@
 }
 #endif
 
+/*[39:8] */
+/* why not using 0xfe000000 ? */
+#define FAM10H_PCI_MMIO_BASE 0xc0000000
+static void fam10h_check_enable_mmcfg(struct cpuinfo_x86 *c)
+{
+	u32 low, high, address;
+
+	address = 0xc0010058;
+	if (rdmsr_safe(address, &low, &high))
+		return;
+
+	if (low & 1)
+		return;
+
+	printk(KERN_INFO "Enable MMCONFIG on AMD Family 10h\n");
+	/*
+	 * if it is not enable, let enable it and assume only one segement
+	 * with 256 buses
+	 */
+	low &= ~(0xfff00000 | (0xf<<2));
+	low |= (8<<2) | (1<<0);
+	high &= ~(0x0000ffff);
+	high |= (FAM10H_PCI_MMIO_BASE>>(32-8));
+	wrmsr_safe(address, low, high);
+}
+
 /*
  * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
  * Assumes number of cores is a power of two.
@@ -655,6 +681,9 @@
 	/* Family 10 doesn't support C states in MWAIT so don't use it */
 	if (c->x86 == 0x10 && !force_mwait)
 		clear_bit(X86_FEATURE_MWAIT, &c->x86_capability);
+
+	if (c->x86 == 0x10)
+		fam10h_check_enable_mmcfg(c);
 }
 
 static void __cpuinit detect_ht(struct cpuinfo_x86 *c)
