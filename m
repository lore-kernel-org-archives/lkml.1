Return-Path: <linux-kernel-owner+w=401wt.eu-S1764047AbYCECQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764047AbYCECQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 21:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYCECQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 21:16:12 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:63750 "EHLO
	outbound6-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484AbYCECQL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 21:16:11 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JX8JMA-04-OBT-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH RFC] ahci: fix SB600 h/w errata issue
Date: Wed, 5 Mar 2008 10:15:53 +0800
Message-ID: <B90463BC30D2E446BA423D888DC85E503633A7@sshaexmb1.amd.com>
In-Reply-To: <20080228204348.GA30539@havoc.gtf.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH RFC] ahci: fix SB600 h/w errata issue
Thread-Index: Ach6Sqfg06IBgzSRRQ6U1NJFg6tu8QEG6C/A
From: "Su, Henry" <Henry.Su@amd.com>
To: "Jeff Garzik" <jeff@garzik.org>, <linux-ide@vger.kernel.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Mar 2008 02:15:58.0224 (UTC) FILETIME=[D994F100:01C87E66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, SB600 SATA AHCI controller can only support single PRD data xfer
less 
than 256 sectors.

BRs,
Henry Su

AMD SRDC SW/Linux Group
T (8621)61658067



-----Original Message-----
From: Jeff Garzik [mailto:jeff@garzik.org] 
Sent: Friday, February 29, 2008 4:44 AM
To: linux-ide@vger.kernel.org; Cai, Crane; Su, Henry; Huang, Shane
Cc: LKML
Subject: [PATCH RFC] ahci: fix SB600 h/w errata issue

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
 	AHCI_HFLAG_NO_HOTPLUG		= (1 << 7), /* ignore
PxSERR.DIAG.N */
+	AHCI_HFLAG_SECT255		= (1 << 8), /* max 255 sectors
*/
 
 	/* ap->flags bits */
 
@@ -255,6 +256,7 @@ static void ahci_vt8251_error_handler(struct
ata_port *ap);
 static void ahci_p5wdh_error_handler(struct ata_port *ap);
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
 static int ahci_port_resume(struct ata_port *ap);
+static void ahci_dev_config(struct ata_device *dev);
 static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void
*cmd_tbl);
 static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int
tag,
 			       u32 opts);
@@ -294,6 +296,8 @@ static const struct ata_port_operations ahci_ops = {
 	.check_altstatus	= ahci_check_status,
 	.dev_select		= ata_noop_dev_select,
 
+	.dev_config		= ahci_dev_config,
+
 	.tf_read		= ahci_tf_read,
 
 	.qc_defer		= sata_pmp_qc_defer_cmd_switch,
@@ -425,7 +429,7 @@ static const struct ata_port_info ahci_port_info[] =
{
 	/* board_ahci_sb600 */
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
-				 AHCI_HFLAG_32BIT_ONLY |
AHCI_HFLAG_NO_PMP),
+				 AHCI_HFLAG_SECT255 |
AHCI_HFLAG_NO_PMP),
 		.flags		= AHCI_FLAG_COMMON,
 		.link_flags	= AHCI_LFLAG_COMMON,
 		.pio_mask	= 0x1f, /* pio0-4 */
@@ -1176,6 +1180,14 @@ static void ahci_init_controller(struct ata_host
*host)
 	VPRINTK("HOST_CTL 0x%x\n", tmp);
 }
 
+static void ahci_dev_config(struct ata_device *dev)
+{
+	struct ahci_host_priv *hpriv =
dev->link->ap->host->private_data;
+
+	if (hpriv->flags & AHCI_HFLAG_SECT255)
+		dev->max_sectors = 255;
+}
+
 static unsigned int ahci_dev_classify(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);


