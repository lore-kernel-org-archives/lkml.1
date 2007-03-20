Return-Path: <linux-kernel-owner+w=401wt.eu-S965808AbXCTS5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965808AbXCTS5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965914AbXCTS5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:57:40 -0400
Received: from usea-naimss2.unisys.com ([192.61.61.104]:1386 "EHLO
	usea-naimss2.unisys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965808AbXCTS5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:57:39 -0400
X-Greylist: delayed 4033 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2007 14:57:38 EDT
Subject: Re: [PATCH] I/O space boot parameter
From: Daniel Yeisley <dan.yeisley@unisys.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20070320180020.GB21470@suse.de>
References: <1174407505.23830.14.camel@localhost.localdomain>
	 <20070320180020.GB21470@suse.de>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 13:25:38 -0400
Message-Id: <1174411538.23830.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-2.fc7) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Mar 2007 18:57:21.0009 (UTC) FILETIME=[96B81E10:01C76B21]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 11:00 -0700, Greg KH wrote:
> On Tue, Mar 20, 2007 at 12:18:24PM -0400, Daniel Yeisley wrote:
> > It has been mentioned before that large systems with a lot of PCI buses
> > have issues with the 64k I/O space limit.  The ES7000 has a BIOS option
> > to either assign I/O space to all adapters, or only to those that need
> > it.  A list of supported adapters that don't need it is kept in the
> > BIOS.  When this option is used, the kernel sees the BARs on the
> > adapters and still tries to assign I/O space (until it runs out).  I've
> > written a patch to implement a boot parameter that tells the kernel not
> > to assign I/O space if the BIOS hasn't.  
> 
> How prelevant are machines like this?  And why are the BARs on these
> devices wrong?
> 
I don't have any sales numbers, but I can tell you that our current
systems can have up to 64 PCI buses.  

I've been working with Emulex cards, and my understanding is that the
BARs on the devices aren't wrong, but we can't allocate 4k of I/O space
for each one.  So we maintain a list in the BIOS of devices that don't
actually need I/O space and then don't assign it.  I've tested an a
x86_64 system with 20+ adapters and saw all the disks attached without
any problems.

I've changed the patch with the suggested variable name change.

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
+++ linux-2.6.20-new/drivers/pci/pci.c	2007-03-20 13:38:43.000000000 -0400
@@ -20,6 +20,7 @@
 #include "pci.h"
 
 unsigned int pci_pm_d3_delay = 10;
+unsigned int pci_no_iospace = 0;
 
 /**
  * pci_bus_max_busnr - returns maximum PCI bus number of given bus' children
@@ -1168,6 +1169,8 @@
 		if (*str && (str = pcibios_setup(str)) && *str) {
 			if (!strcmp(str, "nomsi")) {
 				pci_no_msi();
+			} else if (!strcmp(str, "noiospace")) {
+				pci_no_iospace = 1;
 			} else {
 				printk(KERN_ERR "PCI: Unknown option `%s'\n",
 						str);
diff -Naur linux-2.6.20-org/drivers/pci/pci.h linux-2.6.20-new/drivers/pci/pci.h
--- linux-2.6.20-org/drivers/pci/pci.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.20-new/drivers/pci/pci.h	2007-03-20 13:06:14.000000000 -0400
@@ -49,6 +49,7 @@
 #define pci_msi_quirk 0
 #endif
 extern unsigned int pci_pm_d3_delay;
+extern unsigned int pci_no_iospace;
 #ifdef CONFIG_PCI_MSI
 void disable_msi_mode(struct pci_dev *dev, int pos, int type);
 void pci_no_msi(void);
diff -Naur linux-2.6.20-org/drivers/pci/probe.c linux-2.6.20-new/drivers/pci/probe.c
--- linux-2.6.20-org/drivers/pci/probe.c	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.20-new/drivers/pci/probe.c	2007-03-20 13:06:43.000000000 -0400
@@ -178,6 +178,12 @@
 		}
 		res->end = res->start + (unsigned long) sz;
 		res->flags |= pci_calc_resource_flags(l);
+
+		if (pci_no_iospace && !res->start && (res->flags & IORESOURCE_IO)) {
+			res->flags = 0;
+			res->end = 0;
+		}
+
 		if ((l & (PCI_BASE_ADDRESS_SPACE | PCI_BASE_ADDRESS_MEM_TYPE_MASK))
 		    == (PCI_BASE_ADDRESS_SPACE_MEMORY | PCI_BASE_ADDRESS_MEM_TYPE_64)) {
 			u32 szhi, lhi;



