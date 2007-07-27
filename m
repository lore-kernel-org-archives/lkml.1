Return-Path: <linux-kernel-owner+w=401wt.eu-S935295AbXG0R7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935295AbXG0R7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932871AbXG0R7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:59:00 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:51592 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932660AbXG0R67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:58:59 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] x86, serial: always probe for legacy COM ports
Date: Fri, 27 Jul 2007 11:58:49 -0600
User-Agent: KMail/1.9.6
Cc: Russell King <rmk@arm.linux.org.uk>, Adam Belay <ambx1@neo.rr.com>,
       Jeff Garzik <jeff@garzik.org>, Len Brown <lenb@kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       =?iso-8859-1?q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707271158.50028.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, if you drop
    revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
and apply this, we should have the previous behavior.  I think the
conversion to platform devices is still worthwhile.  Obviously, I intend
this as 2.6.23 material.


Always probe for serial ports at legacy addresses, even if we have PNPBIOS
or ACPI that should tell us about those ports.

We have no reports yet of defective firmware that completely omits ports.
However, Sébastien Dugué <sebastien.dugue@bull.net> reported that the
NEC Express5800/120Lh with Phoenix BIOS 6.0.5N52, released 7/12/2005,
reports COM2 first, then COM1 in the ACPI namespace.

8250_pnp currently registers devices in namespace order.  On this machine,
that makes ttyS0=COM2 and ttyS1=COM1, the reverse of what we want.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/arch/i386/kernel/legacy_serial.c
===================================================================
--- w.orig/arch/i386/kernel/legacy_serial.c	2007-07-27 10:57:41.000000000 -0600
+++ w/arch/i386/kernel/legacy_serial.c	2007-07-27 10:58:03.000000000 -0600
@@ -11,7 +11,6 @@
  */
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/pnp.h>
 #include <linux/serial_8250.h>
 
 /* Standard COM flags (except for COM4, because of the 8514 problem) */
@@ -48,15 +47,8 @@
 	},
 };
 
-static int force_legacy_probe;
-module_param_named(force, force_legacy_probe, bool, 0);
-MODULE_PARM_DESC(force, "Force legacy serial port probe");
-
 static int __init serial8250_x86_com_init(void)
 {
-	if (pnp_platform_devices && !force_legacy_probe)
-		return -ENODEV;
-
 	return platform_device_register(&x86_com_device);
 }
 
Index: w/Documentation/kernel-parameters.txt
===================================================================
--- w.orig/Documentation/kernel-parameters.txt	2007-07-27 10:58:12.000000000 -0600
+++ w/Documentation/kernel-parameters.txt	2007-07-27 10:58:19.000000000 -0600
@@ -859,11 +859,6 @@
 	lasi=		[HW,SCSI] PARISC LASI driver for the 53c700 chip
 			Format: addr:<io>,irq:<irq>
 
-	legacy_serial.force [HW,IA-32,X86-64]
-			Probe for COM ports at legacy addresses even
-			if PNPBIOS or ACPI should describe them.  This
-			is for working around firmware defects.
-
 	llsc*=		[IA64] See function print_params() in
 			arch/ia64/sn/kernel/llsc4.c.
 
