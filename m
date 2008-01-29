Return-Path: <linux-kernel-owner+w=401wt.eu-S1763274AbYA2PFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763274AbYA2PFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 10:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYA2PFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 10:05:10 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:58700 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbYA2PFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:05:08 -0500
Date: Tue, 29 Jan 2008 10:04:12 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <20080129074127.5699afcf.valdyn@gmail.com>
To: Florian Attenberger <valdyn@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Message-id: <200801291004.12565.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <200801281413.21347.gene.heskett@gmail.com>
 <20080129074127.5699afcf.valdyn@gmail.com>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008, Florian Attenberger wrote:
>On Mon, 28 Jan 2008 14:13:21 -0500
>
>Gene Heskett <gene.heskett@gmail.com> wrote:
>> >> I had to reboot early this morning due to a freezeup, and I had a
>> >> bunch of these in the messages log:
>> >> ==============
>> >> Jan 27 19:42:11 coyote kernel: [42461.915961] ata1.00: exception Emask
>> >> 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen Jan 27 19:42:11 coyote kernel:
>> >> [42461.915973] ata1.00: cmd ca/00:08:b1:66:46/00:00:00:00:00/e8 tag 0
>> >> dma 4096 out Jan 27 19:42:11 coyote kernel: [42461.915974]          res
>> >> 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout) Jan 27 19:42:11
>> >> coyote kernel: [42461.915978] ata1.00: status: { DRDY } Jan 27 19:42:11
>> >> coyote kernel: [42461.916005] ata1: soft resetting link Jan 27 19:42:12
>> >> coyote kernel: [42462.078216] ata1.00: configured for UDMA/100 Jan 27
>> >> 19:42:12 coyote kernel: [42462.078232] ata1: EH complete
>> >> Jan 27 19:42:12 coyote kernel: [42462.090700] sd 0:0:0:0: [sda]
>> >> 390721968 512-byte hardware sectors (200050 MB) Jan 27 19:42:12 coyote
>> >> kernel: [42462.114230] sd 0:0:0:0: [sda] Write Protect is off Jan 27
>> >> 19:42:12 coyote kernel: [42462.115079] sd 0:0:0:0: [sda] Write cache:
>> >> enabled, read cache: enabled, doesn't support DPO or FUA
>> >> ===============
>
>I had this error too, or maybe only a similar one, and another, neither
>of which of i still have the error output laying around, so I'm posting both
>fixes, that i found here on lkml:
>1) disabling ncq like that:
>"echo 1 > /sys/block/sda/device/queue_depth"

Interesting..

>2) this patch: libata_drain_fifo_on_stuck_drq_hsm.patch
>( applies to 2.6.24 too )
>
>Signed-off-by: Mark Lord <mlord@pobox.com>
>---
>
>--- old/drivers/ata/libata-sff.c	2007-09-28 09:29:22.000000000 -0400
>+++ linux/drivers/ata/libata-sff.c	2007-09-28 09:39:44.000000000 -0400
>@@ -420,6 +420,28 @@
> 	ap->ops->irq_on(ap);
> }
>
>+static void ata_drain_fifo(struct ata_port *ap, struct ata_queued_cmd *qc)
>+{
>+	u8 stat = ata_chk_status(ap);
>+	/*
>+	 * Try to clear stuck DRQ if necessary,
>+	 * by reading/discarding up to two sectors worth of data.
>+	 */
>+	if ((stat & ATA_DRQ) && (!qc || qc->dma_dir != DMA_TO_DEVICE)) {
>+		unsigned int i;
>+		unsigned int limit = qc ? qc->sect_size : ATA_SECT_SIZE;
>+
>+		printk(KERN_WARNING "Draining up to %u words from data FIFO.\n",
>+									limit);
>+		for (i = 0; i < limit ; ++i) {
>+			ioread16(ap->ioaddr.data_addr);
>+			if (!(ata_chk_status(ap) & ATA_DRQ))
>+				break;
>+		}
>+		printk(KERN_WARNING "Drained %u/%u words.\n", i, limit);
>+	}
>+}
>+
> /**
>  *	ata_bmdma_drive_eh - Perform EH with given methods for BMDMA controller
>  *	@ap: port to handle error for
>@@ -476,7 +498,7 @@
> 	}
>
> 	ata_altstatus(ap);
>-	ata_chk_status(ap);
>+	ata_drain_fifo(ap, qc);
> 	ap->ops->irq_clear(ap);
>
> 	spin_unlock_irqrestore(ap->lock, flags);
>-

This too.  Thanks Florian.  I'll keep these in mind as there may be more than 
one cat in need of skinning here.

See a couple of posts I made to lkml this morning for the investigation I'm 
doing re the kernel argument 'acpi_use_timer_override', experimental builds 
under way right now.

Does anyone know why my dvdwriter isn't being assigned a '/dev/sdx' number 
when dmesg says its found ok at ata2.00?  I've turned on an option that says 
something about using the bios for device access this build, but I'll be 
surprised if that's it. :)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Ah, sweet Springtime, when a young man lightly turns his fancy over!
