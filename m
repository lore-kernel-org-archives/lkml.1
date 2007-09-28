Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbXI1D4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbXI1D4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 23:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbXI1D4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 23:56:37 -0400
Received: from rtr.ca ([76.10.145.34]:4451 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbXI1D4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 23:56:36 -0400
Message-ID: <46FC7B72.2030103@rtr.ca>
Date: Thu, 27 Sep 2007 23:56:34 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       michal.k.k.piotrowski@gmail.com, bryan@arbores.ca,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH] libata drain fifo on stuck DRQ HSM violation
References: <46CFA08E.6090604@arbores.ca>	<6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>	<46DBCB6C.8080206@gmail.com>	<20070905095327.6277d054.akpm@linux-foundation.org>	<46DEE617.4050004@rtr.ca>	<46E0A253.7060803@gmail.com>	<46E154DE.2060602@rtr.ca>	<46FB563A.80108@gmail.com> <20070927193701.6230d77f@the-village.bc.nu> <46FC3D7D.90009@gmail.com> <46FC3FDD.5060201@pobox.com> <46FC423C.2050206@gmail.com>
In-Reply-To: <46FC423C.2050206@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-Off-By:  Mark Lord <mlord@pobox.com>
---

--- old/drivers/ata/libata-sff.c	2007-04-26 12:02:46.000000000 -0400
+++ linux/drivers/ata/libata-sff.c	2007-04-29 08:29:27.000000000 -0400
@@ -413,6 +413,24 @@
 	ap->ops->irq_on(ap);
 }
 
+static void ata_drain_fifo (struct ata_port *ap, struct ata_queued_cmd *qc)
+{
+	u8 stat = ata_chk_status(ap);
+	/*
+	 * Try to clear stuck DRQ if necessary.
+	 */
+	if ((stat & ATA_DRQ) && (!qc || qc->dma_dir != DMA_TO_DEVICE)) {
+		unsigned int i, limit = 512;
+		printk("Draining up to %u words from data FIFO.\n", limit);
+		for (i = 0; i < limit ; ++i) {
+			ioread16(ap->ioaddr.data_addr);
+			if (!(ata_chk_status(ap) & ATA_DRQ))
+				break;
+		}
+		printk("Drained %u/%u words.\n", i, limit);
+	}
+}
+
 /**
  *	ata_bmdma_drive_eh - Perform EH with given methods for BMDMA controller
  *	@ap: port to handle error for
@@ -469,7 +487,7 @@
 	}
 
 	ata_altstatus(ap);
-	ata_chk_status(ap);
+	ata_drain_fifo(ap, qc);
 	ap->ops->irq_clear(ap);
 
 	spin_unlock_irqrestore(ap->lock, flags);
