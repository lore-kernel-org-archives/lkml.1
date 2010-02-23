Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0BWC24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 21:28:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:59034 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab0BWC2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 21:28:54 -0500
Message-ID: <4B833FA1.8030207@kernel.org>
Date: Tue, 23 Feb 2010 11:38:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2VuZ2l6IEfDvG5heQ==?= <cgunay@emory.edu>
CC: Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_nv times out for BD-ROM iHOS104-08
References: <Pine.LNX.4.64.0912221105010.5876@stg.biology.emory.edu> 	<51f3faa71001191859l3c323a8ev6b7c0cced2c59e92@mail.gmail.com> 	<d2d378041001220611ieb9d715of8d727f8f93ca9f@mail.gmail.com> 	<4B5A70E5.6050106@kernel.org> <d2d378041001231339o1d1b0984y2b2a85b717987d93@mail.gmail.com> 	<4B67A149.10406@kernel.org> <d2d378041002170814l1da6b022p4902128c604fc84b@mail.gmail.com> 	<4B7C9CEE.4080902@kernel.org> <d2d378041002201111g7af41a3dpdb2fa300a65d56bf@mail.gmail.com> 	<4B8085E7.5000501@kernel.org> <d2d378041002211328w6355d2f9ued625de53964cee5@mail.gmail.com>
In-Reply-To: <d2d378041002211328w6355d2f9ued625de53964cee5@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040603050803040501090108"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 23 Feb 2010 02:28:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040603050803040501090108
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,

On 02/22/2010 06:28 AM, Cengiz Günay wrote:
> On Sat, Feb 20, 2010 at 8:01 PM, Tejun Heo <tj@kernel.org> wrote:
>> Hmmm... So, DRQ gets cleared?  That's strange.  When then the 18 extra
>> bytes happen?  Can you please try this one?
> 
> It worked!
> 
> $ lsscsi
> ...
> [4:0:0:0]    cd/dvd  ATAPI    iHOS104          WL08  /dev/sr0
> ...
> 
> I was able to read a regular DVD in the drive. According to dmesg the
> negotiated speed was down to UDMA/33, so I am not sure about the
> performance of the drive.

Hmmm.... it could be that the drive is sending more data then
requested and the state machine in the controller doesn't like that
and fails to assert IRQ on the host side.  You're still getting
timeouts on 96 byte dma inquiries.  Can you please this patch?

-- 
tejun

--------------040603050803040501090108
Content-Type: text/x-patch;
 name="swncq-atapi-pio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="swncq-atapi-pio.patch"

diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 0c82d33..4ad76f1 100644
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
@@ -1614,6 +1616,24 @@ static int nv_hardreset(struct ata_link *link, unsigned int *class,
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
+		return 0;
+	}
+	return 1;
+}
+
 static void nv_nf2_freeze(struct ata_port *ap)
 {
 	void __iomem *scr_addr = ap->host->ports[0]->ioaddr.scr_addr;

--------------040603050803040501090108--
