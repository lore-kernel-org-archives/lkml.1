Return-Path: <linux-kernel-owner+w=401wt.eu-S1752378AbXG1NJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbXG1NJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 09:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbXG1NJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 09:09:33 -0400
Received: from mfo32.po.2iij.NET ([210.128.50.15]:11203 "EHLO
	mfo32.po.2iij.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbXG1NJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 09:09:31 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jul 2007 09:09:31 EDT
Date: Sat, 28 Jul 2007 22:04:20 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Greg KH <greg@kroah.com>
Cc: yoichi_yuasa@tripeaks.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: [PATCH] fix IDE legacy mode resource
Message-Id: <20070728220420.352c316b.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got the following error on MIPS Cobalt.
MIPS Cobalt has the 0x10000000 offset between resource and bus region. 

PCI: Unable to reserve I/O region #1:8@f00001f0 for device 0000:00:09.1
pata_via 0000:00:09.1: failed to request/iomap BARs for port 0 (errno=-16)
PCI: Unable to reserve I/O region #3:8@f0000170 for device 0000:00:09.1
pata_via 0000:00:09.1: failed to request/iomap BARs for port 1 (errno=-16)
pata_via 0000:00:09.1: no available native port

At this point, these resources should be the bus regions.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X generic/Documentation/dontdiff generic-orig/drivers/pci/probe.c generic/drivers/pci/probe.c
--- generic-orig/drivers/pci/probe.c	2007-07-26 17:07:44.151670750 +0900
+++ generic/drivers/pci/probe.c	2007-07-26 17:25:42.227046250 +0900
@@ -744,22 +744,40 @@ static int pci_setup_device(struct pci_d
 		 */
 		if (class == PCI_CLASS_STORAGE_IDE) {
 			u8 progif;
+			struct pci_bus_region region;
+			struct resource resource;
 			pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
 			if ((progif & 1) == 0) {
-				dev->resource[0].start = 0x1F0;
-				dev->resource[0].end = 0x1F7;
-				dev->resource[0].flags = LEGACY_IO_RESOURCE;
-				dev->resource[1].start = 0x3F6;
-				dev->resource[1].end = 0x3F6;
-				dev->resource[1].flags = LEGACY_IO_RESOURCE;
+				resource.start = 0x1F0;
+				resource.end = 0x1F7;
+				resource.flags = LEGACY_IO_RESOURCE;
+				pcibios_resource_to_bus(dev, &region, &resource);
+				dev->resource[0].start = region.start;
+				dev->resource[0].end = region.end;
+				dev->resource[0].flags = resource.flags;
+				resource.start = 0x3F6;
+				resource.end = 0x3F6;
+				resource.flags = LEGACY_IO_RESOURCE;
+				pcibios_resource_to_bus(dev, &region, &resource);
+				dev->resource[1].start = region.start;
+				dev->resource[1].end = region.end;
+				dev->resource[1].flags = resource.flags;
 			}
 			if ((progif & 4) == 0) {
-				dev->resource[2].start = 0x170;
-				dev->resource[2].end = 0x177;
-				dev->resource[2].flags = LEGACY_IO_RESOURCE;
-				dev->resource[3].start = 0x376;
-				dev->resource[3].end = 0x376;
-				dev->resource[3].flags = LEGACY_IO_RESOURCE;
+				resource.start = 0x170;
+				resource.end = 0x177;
+				resource.flags = LEGACY_IO_RESOURCE;
+				pcibios_resource_to_bus(dev, &region, &resource);
+				dev->resource[2].start = region.start;
+				dev->resource[2].end = region.end;
+				dev->resource[2].flags = resource.flags;
+				resource.start = 0x376;
+				resource.end = 0x376;
+				resource.flags = LEGACY_IO_RESOURCE;
+				pcibios_resource_to_bus(dev, &region, &resource);
+				dev->resource[3].start = region.start;
+				dev->resource[3].end = region.end;
+				dev->resource[3].flags = resource.flags;
 			}
 		}
 		break;
