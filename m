Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYLVVdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYLVVdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbYLVVc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:32:58 -0500
Received: from aun.it.uu.se ([130.238.12.36]:65045 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbYLVVc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:32:57 -0500
Date: Mon, 22 Dec 2008 22:32:53 +0100 (MET)
Message-Id: <200812222132.mBMLWrNU028431@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: drivers using the non-PCI dma_set_mask() on PCI devices
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several drivers do the following:

	struct pci_dev *pdev = ...;
	...
	if (dma_set_mask(&pdev->dev, mask))
		...

But pdev->dev.dma_mask == &pdev->dma_mask, so this is essentially a
roundabout way of saying

	if (pci_set_dma_mask(pdev, mask))

except that it bypasses the PCI-specific operations pci_set_dma_mask()
may do on that platform.

Drivers doing this include drivers/scsi/aic7xxx/aic79xx_osm_pci.c,
drivers/scsi/aic7xxxx/aic7xxx_osm_pci.c, drivers/scsi/qla2xxx/qla_os.c,
drivers/net/wireless/rt2x00/rt2x00pci.c, and drivers/media/video/meye.c.

Is it considered acceptable that drivers bypass the PCI DMA API on
PCI devices like this, or are these drivers in error?

I'm doing some work on an embedded platform (ARM IXP4xx) with some
PCI DMA restrictions. To handle these the platform provides its own
versions of pci_set_dma_mask() and pci_set_consistent_dma_mask(),
but its dma_set_mask() currently does not do anything PCI-specific.
The question is: should dma_set_mask() have PCI knowledge or not?

/Mikael
