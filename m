Return-Path: <linux-kernel-owner+w=401wt.eu-S933786AbXCTTFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786AbXCTTFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 15:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934029AbXCTTFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 15:05:06 -0400
Received: from usea-naimss2.unisys.com ([192.61.61.104]:4020 "EHLO
	usea-naimss2.unisys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933786AbXCTTFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 15:05:04 -0400
Subject: [PATCH] I/O space boot parameter
From: Daniel Yeisley <dan.yeisley@unisys.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, akpm@osdl.org
Content-Type: text/plain
Date: Tue, 20 Mar 2007 12:18:24 -0400
Message-Id: <1174407505.23830.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-2.fc7) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Mar 2007 17:50:14.0309 (UTC) FILETIME=[369E7550:01C76B18]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It has been mentioned before that large systems with a lot of PCI buses
have issues with the 64k I/O space limit.  The ES7000 has a BIOS option
to either assign I/O space to all adapters, or only to those that need
it.  A list of supported adapters that don't need it is kept in the
BIOS.  When this option is used, the kernel sees the BARs on the
adapters and still tries to assign I/O space (until it runs out).  I've
written a patch to implement a boot parameter that tells the kernel not
to assign I/O space if the BIOS hasn't.  

Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>
---

diff -Naur linux-2.6.20-org/Documentation/kernel-parameters.txt linux-2.6.20-new/Documentation/kernel-parameters.txt
--- linux-2.6.20-org/Documentation/kernel-parameters.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.20-new/Documentation/kernel-parameters.txt	2007-03-05 21:35:15.000000000 -0500
@@ -1259,6 +1259,7 @@
 				This sorting is done to get a device
 				order compatible with older (<= 2.4) kernels.
 		nobfsort	Don't sort PCI devices into breadth-first order.
+		noiospace	Do not allocate I/O space unless the BIOS has done so.
 
 	pcmv=		[HW,PCMCIA] BadgePAD 4
 
diff -Naur linux-2.6.20-org/drivers/pci/pci.c linux-2.6.20-new/drivers/pci/pci.c
--- linux-2.6.20-org/drivers/pci/pci.c	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.20-new/drivers/pci/pci.c	2007-03-06 00:58:52.000000000 -0500
@@ -20,6 +20,7 @@
 #include "pci.h"
 
 unsigned int pci_pm_d3_delay = 10;
+unsigned int noiospace = 0;
 
 /**
  * pci_bus_max_busnr - returns maximum PCI bus number of given bus' children
@@ -1168,6 +1169,8 @@
 		if (*str && (str = pcibios_setup(str)) && *str) {
 			if (!strcmp(str, "nomsi")) {
 				pci_no_msi();
+			} else if (!strcmp(str, "noiospace")) {
+				noiospace = 1;
 			} else {
 				printk(KERN_ERR "PCI: Unknown option `%s'\n",
 						str);
diff -Naur linux-2.6.20-org/drivers/pci/pci.h linux-2.6.20-new/drivers/pci/pci.h
--- linux-2.6.20-org/drivers/pci/pci.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.20-new/drivers/pci/pci.h	2007-03-06 01:00:11.000000000 -0500
@@ -49,6 +49,7 @@
 #define pci_msi_quirk 0
 #endif
 extern unsigned int pci_pm_d3_delay;
+extern unsigned int noiospace;
 #ifdef CONFIG_PCI_MSI
 void disable_msi_mode(struct pci_dev *dev, int pos, int type);
 void pci_no_msi(void);
diff -Naur linux-2.6.20-org/drivers/pci/probe.c linux-2.6.20-new/drivers/pci/probe.c
--- linux-2.6.20-org/drivers/pci/probe.c	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.20-new/drivers/pci/probe.c	2007-03-05 21:24:29.000000000 -0500
@@ -178,6 +178,12 @@
 		}
 		res->end = res->start + (unsigned long) sz;
 		res->flags |= pci_calc_resource_flags(l);
+
+		if (noiospace && !res->start && (res->flags & IORESOURCE_IO)) {
+			res->flags = 0;
+			res->end = 0;
+		}
+
 		if ((l & (PCI_BASE_ADDRESS_SPACE | PCI_BASE_ADDRESS_MEM_TYPE_MASK))
 		    == (PCI_BASE_ADDRESS_SPACE_MEMORY | PCI_BASE_ADDRESS_MEM_TYPE_64)) {
 			u32 szhi, lhi;


