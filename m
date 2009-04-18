Return-Path: <linux-kernel-owner+w=401wt.eu-S1751990AbZDRFka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbZDRFka (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 01:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZDRFkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 01:40:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:50835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbZDRFkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 01:40:19 -0400
Message-ID: <49E96731.1000501@kernel.org>
Date: Fri, 17 Apr 2009 22:37:53 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: [PATCH] pci: keep pci device resource name pointer right.
References: <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <20090416235452.GE21405@elte.hu> <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain> <20090417131633.GA30578@elte.hu> <49E8FD0B.2050308@zytor.com>
In-Reply-To: <49E8FD0B.2050308@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix bug

notice one system /proc/iomem some entries missed the name for pci_devices

# cat /proc/iomem
00000000-000973ff : System RAM
00097400-0009ffff : reserved
000a0000-000bffff : PCI Bus #00
000c0000-000cffff : pnp 00:0c
000e0000-000fffff : reserved
00100000-b7f9ffff : System RAM
 00200000-00c67b4b : Kernel code
 00c67b4c-01331edf : Kernel data
 015a5000-01fc9657 : Kernel bss
 20000000-23ffffff : GART
b7fae000-b7faffff : System RAM
b7fb0000-b7fbdfff : ACPI Tables
b7fbe000-b7feffff : ACPI Non-volatile Storage
b7ff0000-b7ffffff : reserved
b8000000-beffffff : PCI Bus #00
bf000000-bfffffff : PCI Bus #80
 bfe80000-bfebffff : pnp 00:0e
 bfef9000-bfef9fff :
   bfef9000-bfef9fff : forcedeth
 bfefa000-bfefa00f :
   bfefa000-bfefa00f : forcedeth
 bfefa400-bfefa4ff :
   bfefa400-bfefa4ff : forcedeth
 bfefa800-bfefa80f :
   bfefa800-bfefa80f : forcedeth
 bfefac00-bfefacff :
   bfefac00-bfefacff : forcedeth
 bfefb000-bfefbfff :
   bfefb000-bfefbfff : forcedeth
 bfefc000-bfefcfff :
   bfefc000-bfefcfff : sata_nv
 bfefd000-bfefdfff :
   bfefd000-bfefdfff : sata_nv
 bfefe000-bfefefff :
   bfefe000-bfefefff : sata_nv
 bfeff000-bfefffff : IOAPIC 1
   bfeff000-bfefffff :
...

it turns that we need to reget res->name because dev->dev.kobj name is changed
after device_add.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/bus.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6/drivers/pci/bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/bus.c
+++ linux-2.6/drivers/pci/bus.c
@@ -70,6 +70,19 @@ pci_bus_alloc_resource(struct pci_bus *b
 	return ret;
 }
 
+static void pci_dev_update_res_name(struct pci_dev *dev)
+{
+	int idx;
+
+	/* after device_add will get new name, reget it */
+	for (idx = 0; idx <= PCI_ROM_RESOURCE; idx++) {
+		struct resource *res = &dev->resource[idx];
+
+		if (res->name)
+			res->name = pci_name(dev);
+	}
+}
+
 /**
  * pci_bus_add_device - add a single device
  * @dev: device to add
@@ -84,6 +97,7 @@ int pci_bus_add_device(struct pci_dev *d
 	if (retval)
 		return retval;
 
+	pci_dev_update_res_name(dev);
 	dev->is_added = 1;
 	pci_proc_attach_device(dev);
 	pci_create_sysfs_dev_files(dev);
