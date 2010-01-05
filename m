Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081Ab0AEAzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab0AEAzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179Ab0AEAep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:34:45 -0500
Received: from kroah.org ([198.145.64.141]:34111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab0AEAen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:43 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Jeff Garzik <jgarzik@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/97] pata_hpt3x2n: fix clock turnaround
Date: Mon,  4 Jan 2010 16:32:22 -0800
Message-Id: <1262651630-7354-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 256ace9bbd4cdb6d48d5f55d55d42fa20527fad1 upstream.

The clock turnaround code still doesn't work for several reasons:

- 'USE_DPLL' flag in 'ap->host->private_data' is never initialized
  or updated, so the driver can only set the chip to the DPLL clock
  mode, not the PCI mode;

- the driver doesn't serialize access to the channels depending on
  the current clock mode like the vendor drivers, so the clock
  turnaround is only executed "optionally", not always as it should be;

- the wrong ports are written to when hpt3x2n_set_clock() is called
  for the secondary channel;

- hpt3x2n_set_clock() can inadvertently enable the disabled channels
  when resetting the channel state machines.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ata/pata_hpt3x2n.c |   64 ++++++++++++++++++++++++--------------------
 1 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 21c5bd6..d16e87e 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -8,7 +8,7 @@
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
  * Portions Copyright (C) 2003		Red Hat Inc
- * Portions Copyright (C) 2005-2007	MontaVista Software, Inc.
+ * Portions Copyright (C) 2005-2009	MontaVista Software, Inc.
  *
  *
  * TODO
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x2n"
-#define DRV_VERSION	"0.3.7"
+#define DRV_VERSION	"0.3.8"
 
 enum {
 	HPT_PCI_FAST	=	(1 << 31),
@@ -262,7 +262,7 @@ static void hpt3x2n_bmdma_stop(struct ata_queued_cmd *qc)
 
 static void hpt3x2n_set_clock(struct ata_port *ap, int source)
 {
-	void __iomem *bmdma = ap->ioaddr.bmdma_addr;
+	void __iomem *bmdma = ap->ioaddr.bmdma_addr - ap->port_no * 8;
 
 	/* Tristate the bus */
 	iowrite8(0x80, bmdma+0x73);
@@ -272,9 +272,9 @@ static void hpt3x2n_set_clock(struct ata_port *ap, int source)
 	iowrite8(source, bmdma+0x7B);
 	iowrite8(0xC0, bmdma+0x79);
 
-	/* Reset state machines */
-	iowrite8(0x37, bmdma+0x70);
-	iowrite8(0x37, bmdma+0x74);
+	/* Reset state machines, avoid enabling the disabled channels */
+	iowrite8(ioread8(bmdma+0x70) | 0x32, bmdma+0x70);
+	iowrite8(ioread8(bmdma+0x74) | 0x32, bmdma+0x74);
 
 	/* Complete reset */
 	iowrite8(0x00, bmdma+0x79);
@@ -284,21 +284,10 @@ static void hpt3x2n_set_clock(struct ata_port *ap, int source)
 	iowrite8(0x00, bmdma+0x77);
 }
 
-/* Check if our partner interface is busy */
-
-static int hpt3x2n_pair_idle(struct ata_port *ap)
-{
-	struct ata_host *host = ap->host;
-	struct ata_port *pair = host->ports[ap->port_no ^ 1];
-
-	if (pair->hsm_task_state == HSM_ST_IDLE)
-		return 1;
-	return 0;
-}
-
 static int hpt3x2n_use_dpll(struct ata_port *ap, int writing)
 {
 	long flags = (long)ap->host->private_data;
+
 	/* See if we should use the DPLL */
 	if (writing)
 		return USE_DPLL;	/* Needed for write */
@@ -307,20 +296,35 @@ static int hpt3x2n_use_dpll(struct ata_port *ap, int writing)
 	return 0;
 }
 
+static int hpt3x2n_qc_defer(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ata_port *alt = ap->host->ports[ap->port_no ^ 1];
+	int rc, flags = (long)ap->host->private_data;
+	int dpll = hpt3x2n_use_dpll(ap, qc->tf.flags & ATA_TFLAG_WRITE);
+
+	/* First apply the usual rules */
+	rc = ata_std_qc_defer(qc);
+	if (rc != 0)
+		return rc;
+
+	if ((flags & USE_DPLL) != dpll && alt->qc_active)
+		return ATA_DEFER_PORT;
+	return 0;
+}
+
 static unsigned int hpt3x2n_qc_issue(struct ata_queued_cmd *qc)
 {
-	struct ata_taskfile *tf = &qc->tf;
 	struct ata_port *ap = qc->ap;
 	int flags = (long)ap->host->private_data;
+	int dpll = hpt3x2n_use_dpll(ap, qc->tf.flags & ATA_TFLAG_WRITE);
 
-	if (hpt3x2n_pair_idle(ap)) {
-		int dpll = hpt3x2n_use_dpll(ap, (tf->flags & ATA_TFLAG_WRITE));
-		if ((flags & USE_DPLL) != dpll) {
-			if (dpll == 1)
-				hpt3x2n_set_clock(ap, 0x21);
-			else
-				hpt3x2n_set_clock(ap, 0x23);
-		}
+	if ((flags & USE_DPLL) != dpll) {
+		flags &= ~USE_DPLL;
+		flags |= dpll;
+		ap->host->private_data = (void *)(long)flags;
+
+		hpt3x2n_set_clock(ap, dpll ? 0x21 : 0x23);
 	}
 	return ata_sff_qc_issue(qc);
 }
@@ -337,6 +341,8 @@ static struct ata_port_operations hpt3x2n_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 
 	.bmdma_stop	= hpt3x2n_bmdma_stop,
+
+	.qc_defer	= hpt3x2n_qc_defer,
 	.qc_issue	= hpt3x2n_qc_issue,
 
 	.cable_detect	= hpt3x2n_cable_detect,
@@ -454,7 +460,7 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	unsigned int f_low, f_high;
 	int adjust;
 	unsigned long iobase = pci_resource_start(dev, 4);
-	void *hpriv = NULL;
+	void *hpriv = (void *)USE_DPLL;
 	int rc;
 
 	rc = pcim_enable_device(dev);
@@ -542,7 +548,7 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	/* Set our private data up. We only need a few flags so we use
 	   it directly */
 	if (pci_mhz > 60) {
-		hpriv = (void *)PCI66;
+		hpriv = (void *)(PCI66 | USE_DPLL);
 		/*
 		 * On  HPT371N, if ATA clock is 66 MHz we must set bit 2 in
 		 * the MISC. register to stretch the UltraDMA Tss timing.
-- 
1.6.6

