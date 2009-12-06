Return-Path: <linux-kernel-owner+w=401wt.eu-S932551AbZLFJQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551AbZLFJQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 04:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbZLFJQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 04:16:08 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:47567 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695AbZLFJQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 04:16:06 -0500
Date: Sun, 6 Dec 2009 10:16:11 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Faisal Latif <faisal.latif@intel.com>,
       Chien Tung <chien.tin.tung@intel.com>,
       Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/5] drivers/infiniband: correct size computation
Message-ID: <Pine.LNX.4.64.0912061015540.20858@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The size argument to ioremap_nocache should be the size of desired
information, not the pointer to it.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@expression@
expression *x;
@@

x =
 <+...
-sizeof(x)
+sizeof(*x)
...+>// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/infiniband/hw/nes/nes.c     |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index cbde0cf..b8c5372 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -521,7 +521,8 @@ static int __devinit nes_probe(struct pci_dev *pcidev, const struct pci_device_i
 	spin_lock_init(&nesdev->indexed_regs_lock);
 
 	/* Remap the PCI registers in adapter BAR0 to kernel VA space */
-	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0), sizeof(mmio_regs));
+	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0),
+				    sizeof(*mmio_regs));
 	if (mmio_regs == NULL) {
 		printk(KERN_ERR PFX "Unable to remap BAR0\n");
 		ret = -EIO;
