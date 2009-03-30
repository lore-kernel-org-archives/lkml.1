Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZC3H1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZC3H1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 03:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbZC3H1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 03:27:22 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44209 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZC3H1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 03:27:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=JiLgoBIGUJdsI8xftDbmC8O066CQ0t7HScMS78OKqhh+ZUMw2AlOtYAptgEdS0YDjE
         GWIjmlSkCqbiFbwgmhMNUYdzEmK0YeFSiqVSZRHsaBLZuOACc8ASw1DYKNIOWI3oKwlo
         fovOAEOrfvtjdzeq2TRXivPiDcr4wDRi6Jz3M=
Date: Mon, 30 Mar 2009 09:27:13 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Michael Roth <mroth@nessie.de>, bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug in 2.6.29 ide-cd: Kernel freeze: bisected + unacceptable
	workaround
Message-ID: <20090330072713.GA13776@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Michael Roth <mroth@nessie.de>,
	bzolnier@gmail.com, linux-kernel@vger.kernel.org
References: <49CFCB2A.4020505@nessie.de> <20090329201337.GA9962@liondog.tnic> <49CFEA24.10700@nessie.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <49CFEA24.10700@nessie.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Sun, Mar 29, 2009 at 11:37:40PM +0200, Michael Roth wrote:
> Hello Borislav,
> 
> thank you for your help.
> 
> Borislav Petkov schrieb:
> 
> >  Can we please see a dmesg of a working
> > kernel on your machine
> 
> Sure, dmesg output appended beneath. I also added the dmesg output
> of the patched kernel. See below.
> 
> 
> > and also is it possible to catch any kernel output of the crash
> > any oops or something when your machine freezes - the more the better.
> 
> There aren't any messages, neither on the console nor in the syslog.
> The kernel simple freeze, cursor on the console stops blinking, no
> more ide activity. I have to hit the reset-bottom to restart.
> 
> 
> > Probably over a serial console would be best but photographed
> > with a digicam and uploaded somewhere as a screenshot would do too.
> 
> I will do that on request, but it will take some time (about days)
> because currently I don't have access to a second computer or so.

That'll definitely be very helpful since I wanna know exactly why it
locks up. If you still have no output it'd be cool if you could enable
ide-cd debugging and retry catching the output. Here's a patch for that,
just recompile and reboot (I admit this is not one of the finest ways to
enable debugging but since this is work in progress...:) ):

--
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index e9d042d..4ef3b7e 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -8,6 +8,8 @@
 #include <linux/ide.h>
 #include <scsi/scsi.h>
 
+#define DEBUG 1
+
 #ifdef DEBUG
 #define debug_log(fmt, args...) \
 	printk(KERN_INFO "ide: " fmt, ## args)
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index ddfbea4..ea36295 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1991,7 +1991,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 		}
 	}
 
-	drive->debug_mask = debug_mask;
+	drive->debug_mask = 0xffffffff;
 	drive->irq_handler = cdrom_newpc_intr;
 
 	info = kzalloc(sizeof(struct cdrom_info), GFP_KERNEL);
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index c878bfc..225afca 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -8,7 +8,7 @@
 #include <linux/cdrom.h>
 #include <asm/byteorder.h>
 
-#define IDECD_DEBUG_LOG		0
+#define IDECD_DEBUG_LOG		1
 
 #if IDECD_DEBUG_LOG
 #define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)

> > You could also try the following patch to see whether that is of any
> > help:
> 
> Your patch helps perfectly. I'm writing this email on the patched
> 2.6.29. I also tested CD and DVD access: They work well. Burning not
> tested but I assume it will work too.

@Bart: can you take at look at this. Somehow, if the device is behind a
PCI IDE controller, the order of issuing the command and enabling DMA is
important. Seen something like that before?

> Probing IDE interface ide2...
> hde: HL-DT-ST DVDRAM GSA-H42N, ATAPI CD/DVD-ROM drive
> hde: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hde: UDMA/66 mode selected
> Probing IDE interface ide3...
> ide2 at 0xa400-0xa407,0xa802 on irq 18
> ide3 at 0xac00-0xac07,0xb002 on irq 18
> via82cxxx 0000:00:11.1: VIA vt8235 (rev 00) IDE UDMA133
> via82cxxx 0000:00:11.1: IDE controller (0x1106:0x0571 rev 0x06)
> ACPI: PCI Interrupt Link [ALKA] BIOS reported IRQ 0, using IRQ 20
> ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
> VIA_IDE 0000:00:11.1: PCI INT A -> Link[ALKA] -> GSI 20 (level, low) -> IRQ 20
> via82cxxx 0000:00:11.1: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0xc400-0xc407
>     ide1: BM-DMA at 0xc408-0xc40f
> Probing IDE interface ide0...
> hda: SAMSUNG HD400LD, ATA DISK drive
> hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> hda: UDMA/100 mode selected
> Probing IDE interface ide1...
> hdc: SAMSUNG HD400LD, ATA DISK drive
> hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> hdc: UDMA/100 mode selected
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> ide1 at 0x170-0x177,0x376 on irq 15
> ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> ide-gd driver 1.18
> hda: max request size: 512KiB
> hda: 781422768 sectors (400088 MB) w/8192KiB Cache, CHS=48641/255/63
> hda: cache flushes supported
>  hda: hda1 hda2 hda3 hda4
> hdc: max request size: 512KiB
> hdc: 781422768 sectors (400088 MB) w/8192KiB Cache, CHS=48641/255/63
> hdc: cache flushes supported
>  hdc: hdc1 hdc2 hdc3 hdc4
> ide-cd driver 5.00
> ide-cd: hde: ATAPI 48X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
> Uniform CD-ROM driver Revision: 3.20

-- 
Regards/Gruss,
    Boris.
