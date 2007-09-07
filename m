Return-Path: <linux-kernel-owner+w=401wt.eu-S965696AbXIGNk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965696AbXIGNk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 09:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965429AbXIGNkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 09:40:49 -0400
Received: from rtr.ca ([76.10.145.34]:2001 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965252AbXIGNkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 09:40:47 -0400
Message-ID: <46E154DE.2060602@rtr.ca>
Date: Fri, 07 Sep 2007 09:40:46 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, michal.k.k.piotrowski@gmail.com,
       bryan@arbores.ca, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Stardom SATA HSM violation
References: <46CFA08E.6090604@arbores.ca>	<6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>	<46DBCB6C.8080206@gmail.com> <20070905095327.6277d054.akpm@linux-foundation.org> <46DEE617.4050004@rtr.ca> <46E0A253.7060803@gmail.com>
In-Reply-To: <46E0A253.7060803@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Mark Lord wrote:
>> I reported a very similar bug back a few releases ago.
>> Anyone who wants to try it themselves, can do this with hdparm-7.7 (from
>> sourceforge):
>>
>>    hdparm --drq-hsm-error /dev/sda
>>
>> Whether or not it hangs the machine does depend upon exactly which SATA
>> LLD is used,
>> and what model/revision of drive is installed.  But if it hangs for you
>> (eg. Tejun),
>> then you now have a way to reproduce a HSM error "on demand" for
>> testing.  :)
> 
> Neat.  Is this the FIFO-draining issue?

Yeah, that's the one.  And I still patch my own kernels to
automatically drain up to 512 words from the FIFO when this happens.

Works like a charm.  Patch below for demonstration purposes.

Signed-Off-By:  Mark Lord <mlord@pobox.com>
---

--- linux/drivers/ata/libata-sff.c.orig	2007-04-26 12:02:46.000000000 -0400
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
