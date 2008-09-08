Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYIHS62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYIHS62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbYIHS6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:58:19 -0400
Received: from rtr.ca ([76.10.145.34]:34257 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbYIHS6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:58:18 -0400
Message-ID: <48C575C9.7090900@rtr.ca>
Date: Mon, 08 Sep 2008 14:58:17 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pascal GREGIS <pgs@synerway.com>, linux-kernel@vger.kernel.org
Subject: Re: SCSI or libata problem with an RDX removable disk
References: <20080904095447.GE2814@venus.synerway.com>	<20080904123418.4fab9ea3@lxorguk.ukuu.org.uk>	<20080904135216.GF2814@venus.synerway.com> <20080908112134.7bca9dea@lxorguk.ukuu.org.uk>
In-Reply-To: <20080908112134.7bca9dea@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Sep  4 08:03:08 devsni1 kernel: ata4: port is slow to respond, please be patient (Status 0xd0)
>> Sep  4 08:03:31 devsni1 kernel: ata4: port failed to respond (30 secs, Status 0xd0)
>> Sep  4 08:03:31 devsni1 kernel: ata4: soft resetting port
>> Sep  4 08:03:32 devsni1 kernel: ATA: abnormal status 0xD0 on port 0x0001d807
>> Sep  4 08:03:32 devsni1 last message repeated 4 times
> 
> Your disk went offline and then refused to come back when the link was
> reset. The initial trigger appears to have been the drive, the fact it
> didn't come back could either be the drive or a controller problem. We've
> seen a few cases where devices or controllers fail to recover from one
> end being stuck expecting data.
> 
> Mark Lord did some patches to try and drain data in this case but I don't
> remember if they were merged yet.
..

That would be this patch, currently not merged, not maintained,
and probably needs rework for some chipsets.  But for the record:


Tejun Heo wrote:
> Jeff Garzik wrote:
>> Tejun Heo wrote:
>>> Alan Cox wrote:
>>>>> I think there have been enough cases where this draining was necessary.
>>>>>  IIRC, ata_piix was involved in those cases, right?  If so, can you
>>>>> please submit a patch which applies this only to affected controllers?
>>>>> I don't feel too confident about applying this to all SFF controllers.
>>>> Old IDE does it on all controllers bar a couple. So we have a very good
>>>> knowledge of what does/doesn't work. The one that needs care in old ide
>>>> is an ordering issue where a state machine reset done first causes the
>>>> drain of the I/O to hang.
>>> Hmmm... So, do we apply draining to all PATA?  Or is ata_piix SATA
>>> affected too?
>> I would think all SFF controllers, since a lot of first gen SATA are
>> really bridged solutions.  If they are flagging DRQ, I say oblige them :)
>
> Alright, then the posted patch should be good enough.  Mark, can you be
> bothered to regenerate the patch and post it one more time (again)?  It
> seems we all agree the update is needed.

I think this original patch still applies cleanly on at least 2.6.23-rc7.

Drain up to 512 words from host/bridge FIFO on stuck DRQ HSM violation,
rather than just getting stuck there forever.

Signed-off-by: Mark Lord <mlord@pobox.com>
---

--- old/drivers/ata/libata-sff.c	2007-09-28 09:29:22.000000000 -0400
+++ linux/drivers/ata/libata-sff.c	2007-09-28 09:39:44.000000000 -0400
@@ -420,6 +420,28 @@
 	ap->ops->irq_on(ap);
 }
 
+static void ata_drain_fifo(struct ata_port *ap, struct ata_queued_cmd *qc)
+{
+	u8 stat = ata_chk_status(ap);
+	/*
+	 * Try to clear stuck DRQ if necessary,
+	 * by reading/discarding up to two sectors worth of data.
+	 */
+	if ((stat & ATA_DRQ) && (!qc || qc->dma_dir != DMA_TO_DEVICE)) {
+		unsigned int i;
+		unsigned int limit = qc ? qc->sect_size : ATA_SECT_SIZE;
+
+		printk(KERN_WARNING "Draining up to %u words from data FIFO.\n",
+									limit);
+		for (i = 0; i < limit ; ++i) {
+			ioread16(ap->ioaddr.data_addr);
+			if (!(ata_chk_status(ap) & ATA_DRQ))
+				break;
+		}
+		printk(KERN_WARNING "Drained %u/%u words.\n", i, limit);
+	}
+}
+
 /**
  *	ata_bmdma_drive_eh - Perform EH with given methods for BMDMA controller
  *	@ap: port to handle error for
@@ -476,7 +498,7 @@
 	}
 
 	ata_altstatus(ap);
-	ata_chk_status(ap);
+	ata_drain_fifo(ap, qc);
 	ap->ops->irq_clear(ap);
 
 	spin_unlock_irqrestore(ap->lock, flags);
