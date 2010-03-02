Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab0CBLhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 06:37:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:44288 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab0CBLhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 06:37:06 -0500
Message-ID: <4B8CFAF4.7030303@kernel.org>
Date: Tue, 02 Mar 2010 20:48:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2VuZ2l6IEfDvG5heQ==?= <cgunay@emory.edu>
CC: Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_nv times out for BD-ROM iHOS104-08
References: <Pine.LNX.4.64.0912221105010.5876@stg.biology.emory.edu> 	<4B5A70E5.6050106@kernel.org> <d2d378041001231339o1d1b0984y2b2a85b717987d93@mail.gmail.com> 	<4B67A149.10406@kernel.org> <d2d378041002170814l1da6b022p4902128c604fc84b@mail.gmail.com> 	<4B7C9CEE.4080902@kernel.org> <d2d378041002201111g7af41a3dpdb2fa300a65d56bf@mail.gmail.com> 	<4B8085E7.5000501@kernel.org> <d2d378041002211328w6355d2f9ued625de53964cee5@mail.gmail.com> 	<4B833FA1.8030207@kernel.org> <d2d378041002280924q26b4a159g5ad22a3476ec3e18@mail.gmail.com>
In-Reply-To: <d2d378041002280924q26b4a159g5ad22a3476ec3e18@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020103000700030706070403"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Mar 2010 11:37:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020103000700030706070403
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,

On 03/01/2010 02:24 AM, Cengiz Günay wrote:
> Before and after the swncq-atapi-pio patch I still get awful read
> times from the BD-ROM drive:
> 
> $ time dd if=/dev/sr0 of=/dev/null bs=64k count=1024
> 67108864 bytes (67 MB) copied, 106.945 seconds, 628 kB/s
> => real	1m46.977s

Hmmm... the drive is timing out even on 4k READ10's.  This shouldn't
really be happening.  Can you please try this one?

-- 
tejun

--------------020103000700030706070403
Content-Type: text/x-patch;
 name="swncq-atapi-pio-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="swncq-atapi-pio-2.patch"

diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 0c82d33..84d3eba 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -307,6 +307,7 @@ static int nv_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 
 static int nv_hardreset(struct ata_link *link, unsigned int *class,
 			unsigned long deadline);
+static int nv_check_atapi_dma(struct ata_queued_cmd *qc);
 static void nv_nf2_freeze(struct ata_port *ap);
 static void nv_nf2_thaw(struct ata_port *ap);
 static void nv_ck804_freeze(struct ata_port *ap);
@@ -470,6 +471,7 @@ static struct ata_port_operations nv_generic_ops = {
 	.scr_read		= nv_scr_read,
 	.scr_write		= nv_scr_write,
 	.hardreset		= nv_hardreset,
+	.check_atapi_dma	= nv_check_atapi_dma,
 };
 
 static struct ata_port_operations nv_nf2_ops = {
@@ -585,7 +587,7 @@ static const struct ata_port_info nv_port_info[] = {
 	/* SWNCQ */
 	{
 		.flags	        = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_NCQ,
+				  ATA_FLAG_NCQ | ATA_FLAG_PIO_POLLING,
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
@@ -1614,6 +1616,25 @@ static int nv_hardreset(struct ata_link *link, unsigned int *class,
 	return -EAGAIN;
 }
 
+#include <scsi/scsi_cmnd.h>
+static int nv_check_atapi_dma(struct ata_queued_cmd *qc)
+{
+	/* Whitelist commands that may use DMA. */
+	switch (qc->scsicmd->cmnd[0]) {
+	case WRITE_12:
+	case WRITE_10:
+	case WRITE_6:
+	case READ_12:
+	case READ_10:
+	case READ_6:
+	case 0xad: /* READ_DVD_STRUCTURE */
+	case 0xbe: /* READ_CD */
+		if (ata_qc_raw_nbytes(qc) > 4096)
+			return 0;
+	}
+	return 1;
+}
+
 static void nv_nf2_freeze(struct ata_port *ap)
 {
 	void __iomem *scr_addr = ap->host->ports[0]->ioaddr.scr_addr;

--------------020103000700030706070403--
