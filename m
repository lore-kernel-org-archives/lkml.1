Return-Path: <linux-kernel-owner+w=401wt.eu-S1161380AbXDKW4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161380AbXDKW4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161342AbXDKWzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:55:37 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55754 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161374AbXDKWzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:55:31 -0400
Date: Wed, 11 Apr 2007 15:52:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Conke Hu <conke.hu@amd.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 25/31] ahci.c: walkaround for SB600 SATA internal error
	issue
Message-ID: <20070411225242.GZ24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ahci.c-walkaround-for-sb600-sata-internal-error-issue.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Conke Hu <conke.hu@gmail.com>

ahci.c: walkaround for SB600 SATA internal error issue

   There is a HW issue in ATI SB600 SATA that PxSERR.E should not be
set on some conditions, for example, when there is no media in SATA
CD/DVD drive or media is not ready, AHCI controller fails to execute
ATAPI commands and reports PORT_IRQ_TF_ERR, but ATI SB600 SATA
controller sets PxSERR.E at the
same time, which is not necessary.
    This patch is just to ignore the INTERNAL ERROR in such case.
Without this patch, ahci error handler will report many errors as
below:
    ----------- cut from dmesg -----------
ata9: soft resetting port
ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata9.00: configured for UDMA/33
ata9: EH complete
ata9.00: exception Emask 0x40 SAct 0x0 SErr 0x800 action 0x2
ata9.00: (irq_stat 0x40000001)
ata9.00: cmd a0/00:00:00:00:20/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0
        res 51/24:03:00:00:20/00:00:00:00:00/a0 Emask 0x40 (internal error)
ata9: soft resetting port
ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata9.00: configured for UDMA/33
ata9: EH complete
ata9.00: exception Emask 0x40 SAct 0x0 SErr 0x800 action 0x2
ata9.00: (irq_stat 0x40000001)
ata9.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x43 data 12 in
        res 51/24:03:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
    -------- end cut ---------

Signed-off-by: Conke Hu <conke.hu@amd.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -82,6 +82,7 @@ enum {
 	board_ahci_pi		= 1,
 	board_ahci_vt8251	= 2,
 	board_ahci_ign_iferr	= 3,
+	board_ahci_sb600	= 4,
 
 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -173,6 +174,7 @@ enum {
 	AHCI_FLAG_NO_NCQ		= (1 << 24),
 	AHCI_FLAG_IGN_IRQ_IF_ERR	= (1 << 25), /* ignore IRQ_IF_ERR */
 	AHCI_FLAG_HONOR_PI		= (1 << 26), /* honor PORTS_IMPL */
+	AHCI_FLAG_IGN_SERR_INTERNAL	= (1 << 27), /* ignore SERR_INTERNAL */
 };
 
 struct ahci_cmd_hdr {
@@ -365,6 +367,18 @@ static const struct ata_port_info ahci_p
 		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
 		.port_ops	= &ahci_ops,
 	},
+	/* board_ahci_sb600 */
+	{
+		.sht		= &ahci_sht,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
+				  ATA_FLAG_SKIP_D2H_BSY |
+				  AHCI_FLAG_IGN_SERR_INTERNAL,
+		.pio_mask	= 0x1f, /* pio0-4 */
+		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.port_ops	= &ahci_ops,
+	},
+
 };
 
 static const struct pci_device_id ahci_pci_tbl[] = {
@@ -404,7 +418,7 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(JMICRON, 0x2366), board_ahci_ign_iferr }, /* JMB366 */
 
 	/* ATI */
-	{ PCI_VDEVICE(ATI, 0x4380), board_ahci }, /* ATI SB600 non-raid */
+	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 non-raid */
 	{ PCI_VDEVICE(ATI, 0x4381), board_ahci }, /* ATI SB600 raid */
 
 	/* VIA */
@@ -1076,8 +1090,11 @@ static void ahci_error_intr(struct ata_p
 	if (ap->flags & AHCI_FLAG_IGN_IRQ_IF_ERR)
 		irq_stat &= ~PORT_IRQ_IF_ERR;
 
-	if (irq_stat & PORT_IRQ_TF_ERR)
+	if (irq_stat & PORT_IRQ_TF_ERR) {
 		err_mask |= AC_ERR_DEV;
+		if (ap->flags & AHCI_FLAG_IGN_SERR_INTERNAL)
+			serror &= ~SERR_INTERNAL;
+	}
 
 	if (irq_stat & (PORT_IRQ_HBUS_ERR | PORT_IRQ_HBUS_DATA_ERR)) {
 		err_mask |= AC_ERR_HOST_BUS;

-- 
