Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZJBCCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZJBCCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbZJBCCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 22:02:49 -0400
Received: from kroah.org ([198.145.64.141]:32853 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbZJBBcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:06 2009
Message-Id: <20091002012406.008265948@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:15:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Hancock <hancockrwd@gmail.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [002/136] pata_amd: do not filter out valid modes in nv_mode_filter
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=pata_amd-do-not-filter-out-valid-modes-in-nv_mode_filter.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Robert Hancock <hancockrwd@gmail.com>

commit 90950a2504b66d626a73f55ca949a2e79ff4b7c4 upstream.

On a Compaq Presario V3000 laptop (NVIDIA MCP51 chipset), pata_amd selects
PIO0 mode for the PATA DVD-RAM drive instead of MWDMA2 which it supports:

ata4.00: ATAPI: HL-DT-ST DVDRAM GSA-4084N, KQ09, max MWDMA2
ata4: nv_mode_filter: 0x39f&0x7001->0x1, BIOS=0x0 (0x0) ACPI=0x7001 (60:600:0x11)
ata4.00: configured for PIO0

For some reason, the BIOS-set UDMA configuration returns 0 and the ACPI _GTM
reports that UDMA2 and PIO0 are enabled. This causes nv_mode_filter to end up
allowing only PIO0 and UDMA0-2. Since the drive doesn't support UDMA we end up
using PIO0.

Since the controllers should always support PIO4, MWDMA2 and UDMA2 regardless
of what cable type is used, let's make sure we don't filter out these modes
regardless of what wacky settings the BIOS is using.

Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_amd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -307,6 +307,9 @@ static unsigned long nv_mode_filter(stru
 		limit |= ATA_MASK_PIO;
 	if (!(limit & (ATA_MASK_MWDMA | ATA_MASK_UDMA)))
 		limit |= ATA_MASK_MWDMA | ATA_MASK_UDMA;
+	/* PIO4, MWDMA2, UDMA2 should always be supported regardless of
+	   cable detection result */
+	limit |= ata_pack_xfermask(ATA_PIO4, ATA_MWDMA2, ATA_UDMA2);
 
 	ata_port_printk(ap, KERN_DEBUG, "nv_mode_filter: 0x%lx&0x%lx->0x%lx, "
 			"BIOS=0x%lx (0x%x) ACPI=0x%lx%s\n",


