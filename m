Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab0BRBma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:42:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:46699 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab0BRBm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:42:29 -0500
Message-ID: <4B7C9CEE.4080902@kernel.org>
Date: Thu, 18 Feb 2010 10:50:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2VuZ2l6IEfDvG5heQ==?= <cgunay@emory.edu>
CC: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: sata_nv times out for BD-ROM iHOS104-08
References: <Pine.LNX.4.64.0912221105010.5876@stg.biology.emory.edu> 	<d2d378040912232302u4b550dap687fcadced237935@mail.gmail.com> 	<4B331771.3090309@kernel.org> <d2d378041001161334r6fe3ee65w39cf98a6c2d1d399@mail.gmail.com> 	<4B5666B4.6000804@kernel.org> <51f3faa71001191859l3c323a8ev6b7c0cced2c59e92@mail.gmail.com> 	<d2d378041001220611ieb9d715of8d727f8f93ca9f@mail.gmail.com> 	<4B5A70E5.6050106@kernel.org> <d2d378041001231339o1d1b0984y2b2a85b717987d93@mail.gmail.com> 	<4B67A149.10406@kernel.org> <d2d378041002170814l1da6b022p4902128c604fc84b@mail.gmail.com>
In-Reply-To: <d2d378041002170814l1da6b022p4902128c604fc84b@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060400070204040406020702"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Feb 2010 01:42:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060400070204040406020702
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 02/18/2010 01:14 AM, Cengiz Günay wrote:
> 2010/2/1 Tejun Heo <tj@kernel.org>:
> 
>> Can you please attach full dmesg w/ the patch applied w/o any kernel
>> parameter?  I'm curious where the hda warnings are coming from.  Is
>> generic IDE driver loaded?
> 
> The dmesg snippet I attached last time was w/o any kernel parameters.
> This time I'm attaching the full dmesg output. hda is my other DVD-RW
> drive, I'm not sure what the warnings mean. ide_core is loaded, but
> not the ide-generic or ide-pci-generic modules, although they are
> available. Would you like me to force them to load?

No, I was concerned because there were a few cases where two drivers
were attached to the same controller but I don't think that's possible
here.

Does the attached patch make any difference?

Thanks.

-- 
tejun

--------------060400070204040406020702
Content-Type: text/x-patch;
 name="drain-from-atapi_pio_bytes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="drain-from-atapi_pio_bytes.patch"

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 730ef3c..d189b48 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1070,6 +1070,7 @@ static void atapi_pio_bytes(struct ata_queued_cmd *qc)
 	struct ata_eh_info *ehi = &dev->link->eh_info;
 	unsigned int ireason, bc_lo, bc_hi, bytes;
 	int i_write, do_write = (qc->tf.flags & ATA_TFLAG_WRITE) ? 1 : 0;
+	u8 stat;
 
 	/* Abuse qc->result_tf for temp storage of intermediate TF
 	 * here to save some kernel stack usage.
@@ -1099,6 +1100,21 @@ static void atapi_pio_bytes(struct ata_queued_cmd *qc)
 
 	if (unlikely(__atapi_pio_bytes(qc, bytes)))
 		goto err_out;
+
+	/* this really should be done only after the final transfer is complete */
+	stat = ata_sff_altstatus(ap);
+	if (stat & ATA_DRQ) {
+		int count;
+
+		ata_port_printk(ap, KERN_INFO, "stat=%x after atapi_pio_bytes\n", stat);
+
+		for (count = 0; (ap->ops->sff_check_status(ap) & ATA_DRQ)
+						&& count < 65536; count += 2)
+			ioread16(ap->ioaddr.data_addr);
+		if (count)
+			ata_port_printk(ap, KERN_DEBUG,
+					"drained %d bytes to clear DRQ.\n", count);
+	}
 	ata_sff_sync(ap); /* flush */
 
 	return;

--------------060400070204040406020702--
