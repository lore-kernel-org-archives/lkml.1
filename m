Return-Path: <linux-kernel-owner+w=401wt.eu-S933895AbZINUYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbZINUYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933641AbZINUYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:24:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55115 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932733AbZINUYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:24:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI / PCIe portdrv: Fix pcie_portdrv_slot_reset()
Date: Mon, 14 Sep 2009 22:25:11 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909142225.11874.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After commit c82f63e411f1b58427c103bd95af2863b1c96dd1
(PCI: check saved state before restore) pcie_portdrv_slot_reset()
may not work correctly if dev->error_state is equal to
pci_channel_io_frozen, because dev->state_saved need not be set at
that time.  Fix this issue by setting dev->state_saved before
pci_restore_state() is called in pcie_portdrv_slot_reset().

From: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pcie/portdrv_pci.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_pci.c
+++ linux-2.6/drivers/pci/pcie/portdrv_pci.c
@@ -205,6 +205,7 @@ static pci_ers_result_t pcie_portdrv_slo
 
 	/* If fatal, restore cfg space for possible link reset at upstream */
 	if (dev->error_state == pci_channel_io_frozen) {
+		dev->state_saved = true;
 		pci_restore_state(dev);
 		pcie_portdrv_restore_config(dev);
 		pci_enable_pcie_error_reporting(dev);
