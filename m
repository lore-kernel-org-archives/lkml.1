Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbXA3XQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbXA3XQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbXA3XQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:16:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:63892 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbXA3XQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:16:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=GCBWX480V0wYgJhfac/F/yVcsPoV3kjUEduY8A5YvE8IGtQoErCCYAa5hQteSIyk8ORcpVBnChqw35DWVht67XY21s9npSxLnEcuXWaa7zgOPGy4RLTDAHJmTWRbr5v5YFtFqe0t8NOpnnhU1w/+kL/yeZ1EfeRO9s1qHESq+LM=
Date: Wed, 31 Jan 2007 00:16:23 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org
Subject: Re: [2.6.20-rc6] pktcdvd doesn't work
Message-ID: <20070130231623.GA7648@dreamland.darkstar.lan>
References: <20070130195319.GA10994@dreamland.darkstar.lan> <Pine.LNX.4.61.0701302100370.13737@yvahk01.tjqt.qr> <20070130203601.GB15067@dreamland.darkstar.lan> <Pine.LNX.4.61.0701302141420.13737@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0701302141420.13737@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff, linux-ide,
I'm having troubles with libata and UDF on RW media. See below.

Il Tue, Jan 30, 2007 at 09:42:34PM +0100, Jan Engelhardt ha scritto: 
> On Jan 30 2007 21:36, Luca Tettamanti wrote:
> >Il Tue, Jan 30, 2007 at 09:02:20PM +0100, Jan Engelhardt ha scritto: 
> >> 
> >> On Jan 30 2007 20:53, Luca Tettamanti wrote:
> >> >Hi,
> >> >pktcdvd on kernel 2.6.20-rc6 is not working as expected. Any file that
> >> 
> >> Did it work previously?
> >
> >Yup, It used to work but since I rarely use it I don't remember which
> >kernel version worked for me.
> 
> Hm, maybe you can take a guess.

I can bisect pktcdvd.c if necessary, but it seems that it's innocent.
 
> >> >is written to the device is lost after umount.
> >> >I rarely use pktcdvd but at some point it used to work on my system.
> >> >
> >> >This is what I'm doing:
> >> >
> >> >root@dreamland:/tmp# cdrwtool -d /dev/scd0 -q
> >> >scsi 8:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4167B DL13 PQ: 0 ANSI: 5
> >> 
> >> In case you are using ide-scsi: try without.
> >
> >It's libata jmicron driver. Shall I try the "old" PATA driver on the
> >next reboot?
> 
> If you have lots of CDRs/DVDRs to spare (or a CDRW/DVDRW), every test is
> welcome.

With the legacy IDE driver it works fine.
The unit is DVD-RAM capable so the firmware should handle random writes
fine; I've tried mounting /dev/scd0 rw *without* pktcdvd and I still
lose files. So I guess it has something to do with libata.

So to recap, after formatting the disk with UDF:

* libata
  - mount with pktcdvd: all files are lost upon umount
  - mount scd0 w/out pktcdvd: all files are lost upon umount
  - write the disk with cdrecord: OK

  pktcdvd reports wrong capacity:
  
  pktcdvd: Fixed packets, 32 blocks, Mode-2 disc
  pktcdvd: Max. media speed: 4
  pktcdvd: write speed 4x
  pktcdvd: 0kB available on disc
  UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'LinuxUDF', timestamp 2007/01/30 18:18 (103c)

* legacy IDE driver
  - mount with pktcdvd: OK
  - mount hda w/out pktcdvd: corrupts FS (duh)
  - write the disk with cdrecord: OK

  pktcdvd reports correct capacity:
  
  pktcdvd: writer pktcdvd0 mapped to hda
  pktcdvd: Fixed packets, 32 blocks, Mode-2 disc
  pktcdvd: Max. media speed: 4
  pktcdvd: write speed 4x
  pktcdvd: 551232kB available on disc
  UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'LinuxUDF', timestamp 2007/01/30 22:19 (103c)

The HW is a JMicron controller:
02:00.0 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 02)
02:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 02)

(one of the 2 has PATA ports)

driven either by libata (CONFIG_PATA_JMICRON):

PCI: Enabling device 0000:02:00.1 (0000 -> 0001)
ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 17 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:02:00.1 to 64
ata9: PATA max UDMA/100 cmd 0xAC00 ctl 0xA882 bmdma 0xA400 irq 19
ata10: PATA max UDMA/100 cmd 0xA800 ctl 0xA482 bmdma 0xA408 irq 19
scsi8 : pata_jmicron
ata9.00: ATAPI, max UDMA/33
ata9.01: ATAPI, max UDMA/33
ata9.00: configured for UDMA/33
ata9.01: configured for UDMA/33
scsi9 : pata_jmicron
ATA: abnormal status 0x7F on port 0xA807
scsi 8:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4167B DL13 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 8:0:0:0: Attached scsi CD-ROM sr0
sr 8:0:0:0: Attached scsi generic sg1 type 5
scsi 8:0:1:0: CD-ROM            WAITEC   ALADAR/1         B1.5 PQ: 0 ANSI: 5
sr1: scsi3-mmc drive: 16x/40x writer cd/rw xa/form2 cdda tray
sr 8:0:1:0: Attached scsi CD-ROM sr1
sr 8:0:1:0: Attached scsi generic sg2 type 5

or by the legacy driver (CONFIG_BLK_DEV_JMICRON):

Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
JMB361: IDE controller at PCI slot 0000:02:00.1
PCI: Enabling device 0000:02:00.1 (0000 -> 0001)
ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 17 (level, low) -> IRQ 18
JMB361: chipset revision 2
JMB361: 100% native mode on irq 18
PCI: Setting latency timer of device 0000:02:00.1 to 64
    ide0: BM-DMA at 0xa400-0xa407, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xa408-0xa40f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: HL-DT-ST DVDRAM GSA-4167B, ATAPI CD/DVD-ROM drive
hdb: WAITEC ALADAR/1, ATAPI CD/DVD-ROM drive
ide0 at 0xac00-0xac07,0xa882 on irq 18
Probing IDE interface ide1...
JMB361: IDE controller at PCI slot 0000:02:00.0
PCI: Device 0000:02:00.0 not available because of resource collisions
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
JMB361: BIOS configuration fixed.
JMB361: chipset revision 2
JMB361: 100% native mode on irq 16
JMB361: dma_base is invalid
ide2: JMB361 Bus-Master DMA disabled (BIOS)
JMB361: dma_base is invalid
ide3: JMB361 Bus-Master DMA disabled (BIOS)
Probing IDE interface ide2...
Probing IDE interface ide3...
ALI15X3: IDE controller at PCI slot 0000:05:02.1
ACPI: PCI Interrupt 0000:05:02.1[A] -> GSI 23 (level, low) -> IRQ 19
ALI15X3: chipset revision 198
ALI15X3: 100% native mode on irq 19
ALI15X3: too many IDE interfaces, no room in table
ALI15X3: too many IDE interfaces, no room in table
(hum, must increase MAX_HWIF)
ALI15X3: neither IDE port enabled (BIOS)
hda: ATAPI 40X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdb: ATAPI 40X CD-ROM CD-R/RW drive, 8192kB Cache, UDMA(33)


Luca
-- 
Not an editor command: Wq
