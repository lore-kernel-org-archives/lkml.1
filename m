Return-Path: <linux-kernel-owner+w=401wt.eu-S968871AbXFHM60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968871AbXFHM60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 08:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968515AbXFHM57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 08:57:59 -0400
Received: from lollipop.listbox.com ([208.210.124.78]:46475 "EHLO
	lollipop.listbox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968424AbXFHM54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 08:57:56 -0400
Message-ID: <46694FB2.6040007@pobox.com>
Date: Fri, 08 Jun 2007 08:46:42 -0400
From: Mark Lord <mlord@pobox.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Robert de Rooy <robert.de.rooy@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com>	<464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com>	<46503192.1040300@gmail.com> <4650B9E3.7070409@gmail.com>	<46518798.2020808@gmail.com> <4651B66E.6030505@gmail.com>	<4651B834.3060702@gmail.com> <4651C4A1.6000101@gmail.com>	<4651C74B.7020108@gmail.com> <46520B36.90409@garzik.org> <20070523150229.00a0c3c4@the-village.bc.nu> <466718B6.4080105@gmail.com> <4667B39D.209@gmail.com> <46685AE5.4010908@gmail.com> <466900F3.7040801@gmail.com>
In-Reply-To: <466900F3.7040801@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>
>> Jun  7 21:10:29 localhost kernel: ata3.00: CFA: Memory Card Adapter,
>> 20011212, max PIO1
>> Jun  7 21:10:29 localhost kernel: ata3.00: 253696 sectors, multi 0: LBA
>> Jun  7 21:10:29 localhost kernel: ata3.00: issuing IDENTIFY
>> Jun  7 21:10:29 localhost kernel: ata3.00: IDENTIFY complete
>> Jun  7 21:10:29 localhost kernel: ata3.00: configured for PIO0
>> Jun  7 21:10:29 localhost kernel: ata3: EH complete
>> Jun  7 21:10:29 localhost kernel: scsi 3:0:0:0: Direct-Access    
>> ATA      Memory Card Adap 2001 PQ: 0 ANSI: 5
>> Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] 253696 512-byte
>> hardware sectors (130 MB)
>> Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
>> Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] Write cache:
>> disabled, read cache: enabled, doesn't support DPO or FUA
>> Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] 253696 512-byte
>> hardware sectors (130 MB)
>> Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
>> Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] Write cache:
>> disabled, read cache: enabled, doesn't support DPO or FUA
> 
> So, that made it go through detection okay.  That's a good news.
> 
>> Jun  7 21:10:59 localhost kernel:  sdd:<3>ata3.00: exception Emask 0x0
>> SAct 0x0 SErr 0x0 action 0x2 frozen
>> Jun  7 21:10:59 localhost kernel: ata3.00: cmd
>> 20/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>> Jun  7 21:10:59 localhost kernel:          res
>> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> 
> But, read for partition table failed miserably and took the device
> offline completely.
> 
> Whee... Cc'ing linux-ide and Mark Lord.  The original thread is..
> 
>   http://thread.gmane.org/gmane.linux.kernel/530099
> 
> Any ideas?

I still don't see much evidence that interrupts are actually functioning here.
It would be good to see /proc/interrupts before/after libata tries to talk to it.

Let's assume for the moment that interrupts are b0rken.
The legacy IDE driver can talk to such devices completely without interrupts,
if the IDE polling patch (below) is applied.

So, Robert:  could you try again with the old IDE driver,
except apply this patch to it first?  This will give valuable info.


--- old/drivers/ide/ide-probe.c	2007-04-11 00:18:51.000000000 -0400
+++ linux/drivers/ide/ide-probe.c	2007-04-12 09:26:14.000000000 -0400
@@ -1014,6 +1014,27 @@
  * but anything else has led to problems on some machines.  We re-enable
  * interrupts as much as we can safely do in most places.
  */
+struct timer_list polling_timer;
+static void ide_polling (unsigned long data)
+{
+	ide_hwgroup_t *hwgroup = (void *)data;
+	ide_hwif_t *hwif;
+	int irq = 0;
+
+	if (hwgroup) {
+		hwif = hwgroup->hwif;
+		if (hwif)
+			irq = hwif->irq;
+	}
+
+	ide_intr(irq, hwgroup);
+	init_timer(&polling_timer);
+	polling_timer.expires = jiffies + 2;
+	polling_timer.function = &ide_polling;
+	polling_timer.data = (unsigned long) hwgroup;
+	add_timer(&polling_timer);
+}
+
 static int init_irq (ide_hwif_t *hwif)
 {
 	unsigned int index;
@@ -1110,9 +1131,12 @@
 		if (hwif->io_ports[IDE_CONTROL_OFFSET])
 			/* clear nIEN */
 			hwif->OUTB(0x08, hwif->io_ports[IDE_CONTROL_OFFSET]);
-
+#if 0
 		if (request_irq(hwif->irq,&ide_intr,sa,hwif->name,hwgroup))
 	       		goto out_unlink;
+#else
+		ide_polling((unsigned long)hwgroup);
+#endif
 	}
 
 	/*
@@ -1156,6 +1180,7 @@
 	printk("\n");
 	up(&ide_cfg_sem);
 	return 0;
+#if 0
 out_unlink:
 	spin_lock_irq(&ide_lock);
 	if (hwif->next == hwif) {
@@ -1176,6 +1201,7 @@
 		BUG_ON(hwgroup->hwif == hwif);
 	}
 	spin_unlock_irq(&ide_lock);
+#endif
 out_up:
 	up(&ide_cfg_sem);
 	return 1;
--- old/drivers/ide/ide.c	2007-04-11 00:18:51.000000000 -0400
+++ linux/drivers/ide/ide.c	2007-04-12 09:31:59.000000000 -0400
@@ -569,6 +569,8 @@
  *	This is raving bonkers.
  */
 
+extern struct timer_list polling_timer;
+
 void ide_unregister(unsigned int index)
 {
 	ide_drive_t *drive;
@@ -612,7 +614,11 @@
 		g = g->next;
 	} while (g != hwgroup->hwif);
 	if (irq_count == 1)
+#if 0
 		free_irq(hwif->irq, hwgroup);
+#else
+		del_timer(&polling_timer);
+#endif
 
 	spin_lock_irq(&ide_lock);
 	/*
