Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbZHBS2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbZHBS2U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 14:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZHBS2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 14:28:20 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51184 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbZHBS2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 14:28:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=cQfwIluB5LKIo9ydKvF9mZ1EKoPtsSA8iADWoiBp/nqaAAR1s7KDNcD2VaXpyG8XwB
         iHsyjEhQkbAFQvIvkS8gnWR390hh5VP4u06AwZg7Y8eOVY/B3ftghjrk7+LiIq1JXobE
         ex23sMbu/PtbiZQlLFNrYtAkD0GgedSkiNle0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jack Byer <ojbyer@usa.net>
Subject: Re: Extremely slow IO with a PCMCIA CompactFlash adapter
Date: Sun, 2 Aug 2009 20:27:18 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090731-05372-g784fb81; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andreas Mohr <andi@lisas.de>,
       linux-ide@vger.kernel.org
References: <h51hro$p6j$1@ger.gmane.org> <200908021538.45180.bzolnier@gmail.com> <cdb43e8a0908020830r3ef054cbs30ee6669115e8335@mail.gmail.com>
In-Reply-To: <cdb43e8a0908020830r3ef054cbs30ee6669115e8335@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908022027.18937.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 August 2009 17:30:56 Jack Byer wrote:
> > Get 2.6.31-rc5 kernel.
> >
> > Set:
> >
> >        CONFIG_IDE=m
> >        CONFIG_BLK_DEV_IDECS=m
> >
> > in the kernel config.
> >
> > Build, install, reboot.
> >
> > Load ide-cs module.
> >
> > Enjoy the speed increase using /dev/hda.
> >
> > You may try "hdparm -c1 /dev/hda" for an extra enjoyment.
> 
> I still get the IRQ error, but reads are 73 kB/s without irqpoll, 580
> kB/s with irqpoll.  When I try to use hdparm the mount command hangs
> forever.
> 
> Is there any harm with using irqpoll all the time?

Depends on the system and usage, in this particular case it should
probably be fine but it would be better to fix the underlying problem
or apply the workaround automatically..

(hdparm fails since it turns out that 32-bit I/O cannot be used)

> ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 3
> PCI: setting IRQ 3 as level-triggered
> serial 0000:00:08.0: PCI INT A -> Link[LNKG] -> GSI 3 (level, low) ->
> IRQ 3
> serial 0000:00:08.0: PCI INT A disabled

There is an unsupported softmodem on the same IRQ that cardbus/pcmcia
controller and it is probably the source of unexpected IRQs..

> pata_ali 0000:00:10.0: can't derive routing for PCI INT A
> scsi0 : pata_ali
> scsi1 : pata_ali
> ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x8080 irq 14
> ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x8088 irq 15
> yenta_cardbus 0000:00:0a.0: CardBus bridge found [103c:0024]
> yenta_cardbus 0000:00:0a.0: O2: res at 0x94/0xD4: 00/ea
> yenta_cardbus 0000:00:0a.0: O2: enabling read prefetch/write burst
> ACPI: Lid Switch [LID]
> ata1.00: ATA-6: ST9100823A, 3.00, max UDMA/100
> ata1.00: 195371568 sectors, multi 16: LBA
> ata1.00: configured for UDMA/100
> scsi 0:0:0:0: Direct-Access     ATA      ST9100823A       3.00 PQ: 0
> ANSI: 5
> ata2.00: ATAPI: DW-224E, A.0H, max MWDMA2
> ata2.00: WARNING: ATAPI DMA disabled for reliablity issues.  It can be
> enabled
> ata2.00: WARNING: via pata_ali.atapi_dma modparam or corresponding
> sysfs node.
> ata2.00: configured for MWDMA2

BTW configured for MWDMA2 but DMA won't be used..

per comment from pata_ali.c:

static int ali_check_atapi_dma(struct ata_queued_cmd *qc)
{
        if (!ali_atapi_dma) {
                /* FIXME: pata_ali can't do ATAPI DMA reliably but the
                 * IDE alim15x3 driver can.  I tried lots of things
                 * but couldn't find what the actual difference was.
                 * If you got an idea, please write it to
                 * linux-ide@vger.kernel.org and cc htejun@gmail.com.
                 *
                 * Disable ATAPI DMA for now.
                 */
                return -EOPNOTSUPP;
        }

If you want to use DMA you need to use alim15x3..

> Uniform Multi-Platform E-IDE driver
> Probing IDE interface ide0...
> hda: IBM-DMDM-10340, CFA DISK drive
> hdb: IBM-DMDM-10340, CFA DISK drive
> ide-probe: ignoring undecoded slave
> irq 3: nobody cared (try booting with the "irqpoll" option)
> Pid: 1144, comm: modprobe Not tainted 2.6.31-rc5 #3
> Call Trace:
>  [<c104e424>] ? __report_bad_irq+0x24/0x90
>  [<c104e5e7>] ? note_interrupt+0x157/0x1a0
>  [<c104edfb>] ? handle_level_irq+0xbb/0x100
>  [<c1004ec7>] ? handle_irq+0x17/0x20
>  [<c100490a>] ? do_IRQ+0x3a/0xb0
>  [<c1003329>] ? common_interrupt+0x29/0x30
>  [<c10284e5>] ? __do_softirq+0x35/0xf0
>  [<c104d51d>] ? handle_IRQ_event+0x2d/0xc0
>  [<c10285cd>] ? do_softirq+0x2d/0x40
>  [<c102877d>] ? irq_exit+0x5d/0x80
>  [<c1004913>] ? do_IRQ+0x43/0xb0
>  [<c1003329>] ? common_interrupt+0x29/0x30
>  [<c104dc3a>] ? __setup_irq+0x17a/0x2c0
>  [<f8450df0>] ? ide_intr+0x0/0x250 [ide_core]
>  [<c104de41>] ? request_threaded_irq+0xc1/0x100
>  [<f84547da>] ? ide_host_register+0x3ea/0x650 [ide_core]
>  [<f8454a6f>] ? ide_host_add+0x2f/0x70 [ide_core]
>  [<f846a157>] ? idecs_register+0xb7/0x160 [ide_cs]
>  [<f846a3a9>] ? ide_probe+0x1a9/0x2d0 [ide_cs]
>  [<f834ba26>] ? pcmcia_device_probe+0xf6/0x1b0 [pcmcia]
>  [<c10ca0f1>] ? sysfs_do_create_link+0xa1/0x140
>  [<c1155cd4>] ? driver_probe_device+0x74/0x180
>  [<c1155e61>] ? __driver_attach+0x81/0x904a0 [pcmcia]
>  [<f834b7b0>] ? pcmcia_device_remove+0x0/0x140 [pcmcia]
>  [<c1155624>] ? bus_for_each_dev+0x54/0x80
>  [<f834b7b0>] ? pcmcia_device_remove+0x0/0x140 [pcmcia]
>  [<c1155b76>] ? driver_attach+0x16/0x20
>  [<c1155de0>] ? __driver_attach+0x0/0x90
>  [<c1154eb6>] ? bus_add_driver+0xb6/0x250
>  [<f834b7b0>] ? pcmcia_device_remove+0x0/0x140 [pcmcia]
>  [<c11560d7>] ? driver_register+0x67/0x150
>  [<f834cb51>] ? pcmcia_register_driver+0x91/0x110 [pcmcia]
>  [<f846f000>] ? init_ide_cs+0x0/0xa [ide_cs]
>  [<c100102a>] ? _stext+0x2a/0x160
>  [<c104b3f3>] ? sys_init_module+0xb3/0x1f0
>  [<c1081cf1>] ? sys_read+0x41/0x80
>  [<c1002cf4>] ? sysenter_do_call+0x12/0x26
> handlers:
> [<f8450df0>] (ide_intr+0x0/0x250 [ide_core])
> Disabling IRQ #3
> ali_stimer_read: stimer is not ready.

Seems like there is also a bug in ali5451 sound driver..

This should help:

---
 sound/pci/ali5451/ali5451.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: b/sound/pci/ali5451/ali5451.c
===================================================================
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -314,8 +314,11 @@ static int snd_ali_codec_ready(struct sn
 		res = snd_ali_5451_peek(codec,port);
 		if (!(res & 0x8000))
 			return 0;
+		if (time_after_eq(end_time, jiffies))
+			break;
 		schedule_timeout_uninterruptible(1);
-	} while (time_after_eq(end_time, jiffies));
+	} while (1);
+
 	snd_ali_5451_poke(codec, port, res & ~0x8000);
 	snd_printdd("ali_codec_ready: codec is not ready.\n ");
 	return -EIO;
@@ -327,15 +330,17 @@ static int snd_ali_stimer_ready(struct s
 	unsigned long dwChk1,dwChk2;
 	
 	dwChk1 = snd_ali_5451_peek(codec, ALI_STIMER);
-	dwChk2 = snd_ali_5451_peek(codec, ALI_STIMER);
 
 	end_time = jiffies + msecs_to_jiffies(250);
 	do {
 		dwChk2 = snd_ali_5451_peek(codec, ALI_STIMER);
 		if (dwChk2 != dwChk1)
 			return 0;
+		if (time_after_eq(end_time, jiffies))
+			break;
 		schedule_timeout_uninterruptible(1);
-	} while (time_after_eq(end_time, jiffies));
+	} while (1);
+
 	snd_printk(KERN_ERR "ali_stimer_read: stimer is not ready.\n");
 	return -EIO;
 }

--

> AC'97 1 does not respond - RESET
> AC'97 1 access is not valid [0xffffffff], removing mixer.
> ali mixer 1 creating error.

This was also present in the previous log (before libata's setup) so
there is some more general problem with the sound..

You may try this patch which keeps softmodem device alive instead of
disabling it (since it shares some hardware with the sound codec)..

---
 drivers/serial/8250_pci.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: b/drivers/serial/8250_pci.c
===================================================================
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -2222,7 +2222,7 @@ serial_pci_guess_board(struct pci_dev *d
 	     blacklist++) {
 		if (dev->vendor == blacklist->vendor &&
 		    dev->device == blacklist->device)
-			return -ENODEV;
+			return -EOPNOTSUPP;
 	}
 
 	num_iomem = num_port = 0;
@@ -2448,8 +2448,12 @@ pciserial_init_one(struct pci_dev *dev, 
 		 * determine the parameters of this board.
 		 */
 		rc = serial_pci_guess_board(dev, &tmp);
-		if (rc)
-			goto disable;
+		if (rc) {
+			if (rc == -EOPNOTSUPP)
+				goto out;
+			else
+				goto disable;
+		}
 	} else {
 		/*
 		 * We matched an explicit entry.  If we are able to
@@ -2474,6 +2478,7 @@ pciserial_init_one(struct pci_dev *dev, 
 
  disable:
 	pci_disable_device(dev);
+ out:
 	return rc;
 }
 
