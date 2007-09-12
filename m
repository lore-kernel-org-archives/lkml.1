Return-Path: <linux-kernel-owner+w=401wt.eu-S1764880AbXIKTRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764880AbXIKTRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764131AbXIKTRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:17:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:44039 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763979AbXIKTQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:16:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,239,1186383600"; 
   d="scan'208";a="133083506"
Date: Wed, 12 Sep 2007 12:28:54 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: akpm@osdl.org, Greg KH <greg@kroah.com>
Cc: Paul Mackerras <paulus@samba.org>, muli@il.ibm.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       kristen.c.accardi@intel.com, anil.s.keshavamurthy@intel.com
Subject: [patch][Intel-IOMMU] Fix for IOMMU early crash
Message-ID: <20070912192854.GA32610@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com> <18148.12140.21118.252581@cargo.ozlabs.ibm.com> <20070911174231.GC24627@askeshav-devel.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911174231.GC24627@askeshav-devel.jf.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Fix IOMMU early crash

This patch avoids copying pci_bus's->sysdata to
pci_dev's->sysdata as one can easily obtain
the same through pci_dev->bus->sysdata.

Now with some recent pci_sysdata patches,
the bus's->sysdata gets populated way early
and a value of non-NULL gets copied from
bus's->sysdata to pci_dev's->sysdata
which causes IOMMU to crash way early in the
boot time as IOMMU depends on this field for its
per device IOMMU context.

Hence this patch not only makes pci_dev's->sysdata
useful and but also fixes the IOMMU early crash.

This patch needs to be applied before IOMMU patches,
so that git bisect will not fail on IOMMU code :-)

Tested on x86_64.

Please apply.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

---
 drivers/pci/hotplug/fakephp.c |    1 -
 drivers/pci/probe.c           |    1 -
 2 files changed, 2 deletions(-)

Index: work/drivers/pci/hotplug/fakephp.c
===================================================================
--- work.orig/drivers/pci/hotplug/fakephp.c	2007-09-11 10:29:30.000000000 -0700
+++ work/drivers/pci/hotplug/fakephp.c	2007-09-11 10:35:22.000000000 -0700
@@ -243,7 +243,6 @@
 		return;
 
 	dev->bus = (struct pci_bus*)bus;
-	dev->sysdata = bus->sysdata;
 	for (devfn = 0; devfn < 0x100; devfn += 8) {
 		dev->devfn = devfn;
 		pci_rescan_slot(dev);
Index: work/drivers/pci/probe.c
===================================================================
--- work.orig/drivers/pci/probe.c	2007-09-11 10:29:30.000000000 -0700
+++ work/drivers/pci/probe.c	2007-09-11 10:35:22.000000000 -0700
@@ -994,7 +994,6 @@
 		return NULL;
 
 	dev->bus = bus;
-	dev->sysdata = bus->sysdata;
 	dev->dev.parent = bus->bridge;
 	dev->dev.bus = &pci_bus_type;
 	dev->devfn = devfn;
