Return-Path: <linux-kernel-owner+w=401wt.eu-S933239AbZGPT6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbZGPT6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933116AbZGPT6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:58:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34059 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933147AbZGPT6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:58:19 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/3] libata: Allow AHCI to flag ports as non-hotpluggable
Date: Thu, 16 Jul 2009 20:58:10 +0100
Message-Id: <1247774290-4194-4-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1247774290-4194-3-git-send-email-mjg@redhat.com>
References: <1247774290-4194-1-git-send-email-mjg@redhat.com>
 <1247774290-4194-2-git-send-email-mjg@redhat.com>
 <1247774290-4194-3-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 78.86.230.144
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SATA ports are fully internal and unlikely to be hotplugged. The
AHCI spec allows vendors to flag these ports differently, allowing
hotplug bays and eSATA ports to be treated differently. Flag ports with
this information so userspace policy decisions can be made.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/ata/ahci.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 4863da9..eda8a11 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -77,6 +77,7 @@ static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
 			      size_t size);
 static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 					ssize_t size);
+static int ahci_is_hotplug_capable(struct ata_port *ap);
 
 enum {
 	AHCI_PCI_BAR		= 5,
@@ -193,6 +194,8 @@ enum {
 	PORT_CMD_ASP		= (1 << 27), /* Aggressive Slumber/Partial */
 	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
 	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
+	PORT_CMD_ESP		= (1 << 21), /* port is esata capable */
+	PORT_CMD_HPCP           = (1 << 18), /* port is hot plug capable */
 	PORT_CMD_PMP		= (1 << 17), /* PMP attached */
 	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
 	PORT_CMD_FIS_ON		= (1 << 14), /* FIS DMA engine running */
@@ -877,6 +880,15 @@ static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 	return -EINVAL;
 }
 
+static int ahci_is_hotplug_capable(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u8 cmd;
+
+	cmd = readl(port_mmio + PORT_CMD);
+	return cmd & (PORT_CMD_HPCP | PORT_CMD_ESP);
+}
+
 static void ahci_start_engine(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
@@ -2378,6 +2390,9 @@ static int ahci_port_start(struct ata_port *ap)
 	if (!pp)
 		return -ENOMEM;
 
+	if (!ahci_is_hotplug_capable(ap))
+		ap->flags |= ATA_FLAG_NO_SATA_HOTPLUG;
+
 	mem = dmam_alloc_coherent(dev, AHCI_PORT_PRIV_DMA_SZ, &mem_dma,
 				  GFP_KERNEL);
 	if (!mem)
-- 
1.6.2.5

