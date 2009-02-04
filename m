Return-Path: <linux-kernel-owner+w=401wt.eu-S1759736AbZBDSmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736AbZBDSmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbZBDShP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:15 -0500
Received: from kroah.org ([198.145.64.141]:51029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758458AbZBDShK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:10 -0500
Date: Wed, 4 Feb 2009 10:34:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 13/33] sata_nv: fix MCP5x reset
Message-ID: <20090204183442.GN13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sata_nv-fix-mcp5x-reset.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 2d775708bc6613f1be47f1e720781343341ecc94 upstream.

MCP5x family of controllers seem to share much more with nf2's as far
as reset protocol is concerned.  It requires heardreset to get the PHY
going and classfication code report after hardreset is unreliable.
Create a new board type MCP5x and use noclassify hardreset.  SWNCQ is
modified to inherit from this new type.

This fixes hotplug regression reported in kernel bz#12351.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_nv.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -352,6 +352,7 @@ enum nv_host_type
 	NFORCE3 = NFORCE2,	/* NF2 == NF3 as far as sata_nv is concerned */
 	CK804,
 	ADMA,
+	MCP5x,
 	SWNCQ,
 };
 
@@ -363,10 +364,10 @@ static const struct pci_device_id nv_pci
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_CK804_SATA2), CK804 },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_SATA), CK804 },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_SATA2), CK804 },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA), SWNCQ },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2), SWNCQ },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA), SWNCQ },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA), MCP5x },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2), MCP5x },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA), MCP5x },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2), MCP5x },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA), GENERIC },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2), GENERIC },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3), GENERIC },
@@ -467,8 +468,19 @@ static struct ata_port_operations nv_adm
 	.host_stop		= nv_adma_host_stop,
 };
 
+/* Kernel bz#12351 reports that when SWNCQ is enabled, for hotplug to
+ * work, hardreset should be used and hardreset can't report proper
+ * signature, which suggests that mcp5x is closer to nf2 as long as
+ * reset quirkiness is concerned.  Define separate ops for mcp5x with
+ * nv_noclassify_hardreset().
+ */
+static struct ata_port_operations nv_mcp5x_ops = {
+	.inherits		= &nv_common_ops,
+	.hardreset		= nv_noclassify_hardreset,
+};
+
 static struct ata_port_operations nv_swncq_ops = {
-	.inherits		= &nv_generic_ops,
+	.inherits		= &nv_mcp5x_ops,
 
 	.qc_defer		= ata_std_qc_defer,
 	.qc_prep		= nv_swncq_qc_prep,
@@ -531,6 +543,15 @@ static const struct ata_port_info nv_por
 		.port_ops	= &nv_adma_ops,
 		.private_data	= NV_PI_PRIV(nv_adma_interrupt, &nv_adma_sht),
 	},
+	/* MCP5x */
+	{
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+		.pio_mask	= NV_PIO_MASK,
+		.mwdma_mask	= NV_MWDMA_MASK,
+		.udma_mask	= NV_UDMA_MASK,
+		.port_ops	= &nv_mcp5x_ops,
+		.private_data	= NV_PI_PRIV(nv_generic_interrupt, &nv_sht),
+	},
 	/* SWNCQ */
 	{
 		.flags	        = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
@@ -2355,14 +2376,9 @@ static int nv_init_one(struct pci_dev *p
 	if (type == CK804 && adma_enabled) {
 		dev_printk(KERN_NOTICE, &pdev->dev, "Using ADMA mode\n");
 		type = ADMA;
-	}
-
-	if (type == SWNCQ) {
-		if (swncq_enabled)
-			dev_printk(KERN_NOTICE, &pdev->dev,
-				   "Using SWNCQ mode\n");
-		else
-			type = GENERIC;
+	} else if (type == MCP5x && swncq_enabled) {
+		dev_printk(KERN_NOTICE, &pdev->dev, "Using SWNCQ mode\n");
+		type = SWNCQ;
 	}
 
 	ppi[0] = &nv_port_info[type];

