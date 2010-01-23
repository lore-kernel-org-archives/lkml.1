Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616Ab0AWXml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab0AWXml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 18:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262Ab0AWXmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 18:42:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43520 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab0AWXmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 18:42:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/8] PM: Allow PCI devices to suspend/resume asynchronously
Date: Sun, 24 Jan 2010 00:39:40 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-usb@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Linux SCSI <linux-scsi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Nigel Cunningham <ncunningham@crca.org.au>
References: <201001240033.34253.rjw@sisk.pl>
In-Reply-To: <201001240033.34253.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001240039.40419.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Set power.async_suspend for all PCI devices and PCIe port services,
so that they can be suspended and resumed in parallel with other
devices they don't depend on in a known way (i.e. devices which are
not their parents or children).

This only affects the "regular" suspend and resume stages, which
means in particular that the restoration of the PCI devices' standard
configuration registers during resume will still be carried out
synchronously (at the "early" resume stage).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c               |    1 +
 drivers/pci/pcie/portdrv_core.c |    1 +
 drivers/pci/probe.c             |    1 +
 3 files changed, 3 insertions(+)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1541,6 +1541,7 @@ void pci_pm_init(struct pci_dev *dev)
 	int pm;
 	u16 pmc;
 
+	device_enable_async_suspend(&dev->dev);
 	dev->wakeup_prepared = false;
 	dev->pm_cap = 0;
 
Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-2.6/drivers/pci/pcie/portdrv_core.c
@@ -285,6 +285,7 @@ static int pcie_device_init(struct pci_d
 		     pci_name(pdev),
 		     get_descriptor_id(pdev->pcie_type, service));
 	device->parent = &pdev->dev;
+	device_enable_async_suspend(device);
 
 	retval = device_register(device);
 	if (retval)
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1200,6 +1200,7 @@ struct pci_bus * pci_create_bus(struct d
 	if (error)
 		goto dev_reg_err;
 	b->bridge = get_device(dev);
+	device_enable_async_suspend(b->bridge);
 
 	if (!parent)
 		set_dev_node(b->bridge, pcibus_to_node(b));

