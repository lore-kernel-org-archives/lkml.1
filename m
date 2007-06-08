Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbXFHWqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbXFHWqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbXFHWqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:46:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:34350 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbXFHWqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:46:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,401,1175497200"; 
   d="scan'208";a="94947181"
From: Auke Kok <auke-jan.h.kok@intel.com>
Subject: [PATCH 1/2] [RFC] PCI: read revision ID by default
To: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       gregkh@suse.de
Date: Fri, 08 Jun 2007 15:46:30 -0700
Message-ID: <20070608224630.31777.17807.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2007 22:46:31.0540 (UTC) FILETIME=[DBB8A340:01C7AA1E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there are 97 occurrences where drivers need the pci
revision ID. We can do this once for all devices. Even the pci
subsystem needs the revision several times for quirks. The extra
u8 member pads out nicely in the pci_dev struct.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
---

 drivers/pci/probe.c |    3 +++
 include/linux/pci.h |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e48fcf0..0fdb71d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -918,6 +918,9 @@ pci_scan_device(struct pci_bus *bus, int devfn)
 	dev->cfg_size = pci_cfg_space_size(dev);
 	dev->error_state = pci_channel_io_normal;
 
+	/* read the PCI revision: 1 byte */
+	pci_read_config_byte(dev, PCI_REVISION_ID, &dev->revision);
+
 	/* Assume 32-bit PCI; let 64-bit PCI cards (which are far rarer)
 	   set this higher, assuming the system even supports it.  */
 	dev->dma_mask = 0xffffffff;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index fbf3766..9847936 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -138,6 +138,7 @@ struct pci_dev {
 	unsigned short	subsystem_vendor;
 	unsigned short	subsystem_device;
 	unsigned int	class;		/* 3 bytes: (base,sub,prog-if) */
+	u8		revision;	/* PCI revision, low byte of class word */
 	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
 	u8		rom_base_reg;	/* which config register controls the ROM */
 	u8		pin;  		/* which interrupt pin this device uses */
