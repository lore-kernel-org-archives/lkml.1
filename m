Return-Path: <linux-kernel-owner+w=401wt.eu-S1762998AbYB1UoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762998AbYB1UoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbYB1Unu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:43:50 -0500
Received: from havoc.gtf.org ([69.61.125.42]:53845 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757905AbYB1Unt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:43:49 -0500
Date: Thu, 28 Feb 2008 15:43:48 -0500
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org, crane.cai@amd.com, Henry.Su@amd.com,
       shane.huang@amd.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] ahci: fix SB600 h/w errata issue
Message-ID: <20080228204348.GA30539@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't seen anyone work on the recent SB600 errata, where the
hardware does not like 256-length PRD entries.

Is this correct, AMD folks?

It hurts performance on SB600, but it is more important to get a
correct patch eliminating the data corruption/lockups, and then later
on tune for performance.

We simply limit each command to a maximum of 255 sectors, on SB600.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/ata/ahci.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 1db93b6..8a49835 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -186,6 +186,7 @@ enum {
 	AHCI_HFLAG_NO_MSI		= (1 << 5), /* no PCI MSI */
 	AHCI_HFLAG_NO_PMP		= (1 << 6), /* no PMP */
 	AHCI_HFLAG_NO_HOTPLUG		= (1 << 7), /* ignore PxSERR.DIAG.N */
+	AHCI_HFLAG_SECT255		= (1 << 8), /* max 255 sectors */
 
 	/* ap->flags bits */
 
@@ -255,6 +256,7 @@ static void ahci_vt8251_error_handler(struct ata_port *ap);
 static void ahci_p5wdh_error_handler(struct ata_port *ap);
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
 static int ahci_port_resume(struct ata_port *ap);
+static void ahci_dev_config(struct ata_device *dev);
 static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl);
 static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 			       u32 opts);
@@ -294,6 +296,8 @@ static const struct ata_port_operations ahci_ops = {
 	.check_altstatus	= ahci_check_status,
 	.dev_select		= ata_noop_dev_select,
 
+	.dev_config		= ahci_dev_config,
+
 	.tf_read		= ahci_tf_read,
 
 	.qc_defer		= sata_pmp_qc_defer_cmd_switch,
@@ -425,7 +429,7 @@ static const struct ata_port_info ahci_port_info[] = {
 	/* board_ahci_sb600 */
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
-				 AHCI_HFLAG_32BIT_ONLY | AHCI_HFLAG_NO_PMP),
+				 AHCI_HFLAG_SECT255 | AHCI_HFLAG_NO_PMP),
 		.flags		= AHCI_FLAG_COMMON,
 		.link_flags	= AHCI_LFLAG_COMMON,
 		.pio_mask	= 0x1f, /* pio0-4 */
@@ -1176,6 +1180,14 @@ static void ahci_init_controller(struct ata_host *host)
 	VPRINTK("HOST_CTL 0x%x\n", tmp);
 }
 
+static void ahci_dev_config(struct ata_device *dev)
+{
+	struct ahci_host_priv *hpriv = dev->link->ap->host->private_data;
+
+	if (hpriv->flags & AHCI_HFLAG_SECT255)
+		dev->max_sectors = 255;
+}
+
 static unsigned int ahci_dev_classify(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
