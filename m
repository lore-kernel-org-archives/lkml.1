Return-Path: <linux-kernel-owner+w=401wt.eu-S1767585AbXCIWqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767585AbXCIWqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767584AbXCIWqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:46:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:7040 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767585AbXCIWqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:46:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fxivtuP8y9EIyaLfcHRjHwuIeGVtb7p0aBc2Z3xC6G3uXr9EIoVDr0ysq2ksKT7MuHbYmUDdk5kmiTy8dgHRO5QBX7RGBEWNwoMH/+8oAT+hpERbEnTJVD1ogVm0fJmCh2RdO5Wm3TBohar80tdhZUSgRLzDaenk6uajmLc0jN8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Marco Lazzarotto <m.lazzarotto@robox.it>
Subject: Re: Trouble using some (fast) compact flash as ide device on an embedded system
Date: Fri, 9 Mar 2007 23:53:09 +0100
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>
References: <45E6D7EB.5080501@robox.it> <200703082237.36231.bzolnier@gmail.com> <45F197BA.7030309@robox.it>
In-Reply-To: <45F197BA.7030309@robox.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703092353.09736.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ cc:ing Alan who may have a better idea what is wrong with this CF than me ]

On Friday 09 March 2007, Marco Lazzarotto wrote:
> Hallo! :-)
> 
> Bartlomiej Zolnierkiewicz ha scritto:
> > Czesc!
> > 
> > On Tuesday 06 March 2007, Marco Lazzarotto wrote:
> > 
> >>Ciao!
> >>
> >>Bartlomiej Zolnierkiewicz ha scritto:
> >>
> >>>On Friday 02 March 2007, Pavel Machek wrote:
> >>>
> >>>
> >>>>Hi!
> >>>>
> >>>>
> >>>>
> >>>>>As I reported in bug 8036 in bugzilla.kernel.org,
> >>>>>
> >>>>>Hardware Environment:
> >>>>>
> >>>>>- Use a compact flash SanDisk SDCFB-128 Firmware revision HDX 2.15
> >>>>>  (we used other compact flashes with the same hw ad sw for years
> >>>>>   with  no trouble)
> >>>>>
> >>>>>It happens on both etx boards:
> >>>>>- VIA SOM-ETX (4475)
> >>>>>- Gene-4312
> >>
> >>ERRATA CORRIGE: Gene-4312 is not a etx board ;-) but a pc/104
> > 
> > 
> > What IDE hardware / host driver is used by this system?
> 
> NB: I'm usign the VIA SOM-ETX (4475) for debugging
> 
> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> VP_IDE: IDE controller at PCI slot 0000:00:07.1
> PCI: Calling quirk c01dc1e8 for 0000:00:07.1
> VP_IDE: chipset revision 6
> VP_IDE: not 100% native mode: will probe irqs later
> VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
>     ide1: BM-DMA at 0xe408-0xe40f, BIOS settings: hdc:DMA, hdd:pio
> 
> (I disabled DMA in the bios, why is saying it is enabled?)

BIOS "forgot" to disable DMA bits...

> >>>>>Doing the command
> >>>>>sfdisk -R /dev/hdc
> >>>>>
> >>>>>gives:
> >>>>>
> >>>>>* * *
> >>>>>ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
> >>>>>hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> >>>>>ide: failed opcode was: unknown
> >>>>>hdc: drive not ready for command
> >>>>>ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
> >>>>>hdc: do_special: 0x02
> >>>>>hdc: do_special: recalibrate
> >>>>>ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
> >>>>>hdc: reading: block=0 sectors=8, buffer = 0xc6cd40000
> >>>>>ide1: end_request: current=0xc6ebe754
> >>>>>* * *
> >>>>>
> >>>>>the 'bad bit' in status error is DataRequest
> > 
> > 
> > Seems like the device wants data from/to host and I have no idea why this
> > is happening.  It might be that this particular CF has problems with one
> > of the commands that IDE driver issues during device initialization.
> > 
> > I assume that device is recognized properly by the driver during probe, right?
> > If so probably adding some debugging printks (i.e. dumping status register)
> > to ide-disk.c:idedisk_setup() would shed some more light at the problem...
> 
> The device seems to be recognized properly.
> Here's (part of) the dmesg output:
> 
>  * * *
> 
>     ide1: BM-DMA at 0xe408-0xe40f, BIOS settings: hdc:DMA, hdd:pio
> Probing IDE interface ide1...
> probing for hdc: present=0, media=32, probetype=ATA
> hdc: SanDisk SDCFB-128, CFA DISK drive ()
> Before ide_disk_init_chs() and ide_disk_init_mult_count()
> IDE_STATUS_REG=0x50
> After ide_disk_init_chs() and ide_disk_init_mult_count() IDE_STATUS_REG=0x50
> probing for hdd: present=0, media=32, probetype=ATA
> probing for hdd: present=0, media=32, probetype=ATAPI
> ide_init_queue()
> ide1 at 0x170-0x177,0x376 on irq 15
> Probing IDE interface ide0...
> probing for hda: present=0, media=32, probetype=ATA
> probing for hda: present=0, media=32, probetype=ATAPI
> probing for hdb: present=0, media=32, probetype=ATA
> probing for hdb: present=0, media=32, probetype=ATAPI
> Probing IDE interface ide2...
> probing for hde: present=0, media=32, probetype=ATA
> probing for hde: present=0, media=32, probetype=ATAPI
> probing for hdf: present=0, media=32, probetype=ATA
> probing for hdf: present=0, media=32, probetype=ATAPI
> Probing IDE interface ide3...
> probing for hdg: present=0, media=32, probetype=ATA
> probing for hdg: present=0, media=32, probetype=ATAPI
> probing for hdh: present=0, media=32, probetype=ATA
> probing for hdh: present=0, media=32, probetype=ATAPI
> hdc: max request size: 128KiB
> After init_idedisk_capacity() IDE_STATUS_REG=0x50
> After idedisk_capacity() IDE_STATUS_REG=0x50
> hdc: 250880 sectors (128 MB) w/1KiB Cache (buf_size=2), CHS=980/8/32
> After write_cache(drive,1) IDE_STATUS_REG=0x50
>  hdc:
> ide1: start_request: current=0xc1190804 (rq->sect=0,block 0, SECTOR_SIZE=512
> hdc: do_special: 0x03
> hdc: do_special: set_geometry
> ide1: start_request: current=0xc1190804 (rq->sect=0,block 0, SECTOR_SIZE=512
> hdc: do_special: 0x02
> hdc: do_special: recalibrate
> hdc : recal_intr() IDE_STATUS_REG=50
> ide1: start_request: current=0xc1190804 (rq->sect=0,block 0, SECTOR_SIZE=512
> hdc: reading: block=0, sectors=8, buffer=0xc6c2d000
> ide1: end_request:   current=0xc1190804
>  hdc1
> 
>  * * *
> 
> I dump IDE_STATUS_REG with e.g. 'printk("%s : recal_intr()
> IDE_STATUS_REG=%02x\n",drive->name,stat)'
> where stat was assigned as 'u8 stat=hwif->INB(IDE_STATUS_REG)'
> 
> It seems to me that the status is good until it tries to read the
> partition table...
> 
> In fact, after I do
> 
> sfdisk -R /dev/hdc
> 
> every other reading from compact flash (if ever does not get 'lost
> interrupt) generates the message
>  hdc: status error: status=0x58 {...}
> 
> >>>>>
> >>>>>doing
> >>>>>sfdisk -l /dev/hdc
> >>>>>
> >>>>>gives:
> >>>>>
> >>>>>* * *
> >>>>>ide1: start_request: current=0xc6ebecd4 (rq->sect=0,block 0)
> >>>>>hdc: reading: block=0, sectors=32, buffer=0xc6f37000
> >>>>>hdc: lost interrupt
> >>>>>hdc: lost interrupt [and so on several times]
> >>>>>* * *
> >>>>>
> >>>>>I have no knowledge of the internals of the linux kernel, but I'm a
> >>>>>programmer and have both hardware and time to spend on solving this issue.
> >>>>
> >>>>Debug it, then :-). Try limiting its speed with hdparm to see if it
> >>>>helps.
> >>
> >>I tried hdparm -p 0 /dev/hdc but nothing changes
> >>
> >>
> >>>I would suggest trying booting with "ide=nodma" first.
> >>
> >>I tried this too, without success.
> >>I disabled 'Use PCI DMA by default when available' in the kernel, if
> >>this is enabled the message 'hdc: lost interrupt' comes when the kernel
> >>tries to access the CF for the first time.
> > 
> > 
> > Yep, disabling this config option should have the same effect as "ide=nodma".
> > However the kernel parameter should work too (bug in the host driver?).
> 
> I intended:
> I disabled 'Use PCI DMA by default when available' in the kernel,
> because I did not know the ide=nodma option.
> It works, of course.
> 
> >> * * * Other information : * * *
> >>
> >>If I try hdparm -I /dev/hdc immediately after boot I receive:
> >>
> >>/ # hdparm -I /dev/hdc
> >>
> >>/dev/hdc:
> >>hdc: ide_cmd_ioctl()
> >>hdc: ide_do_drive_cmd()
> >>ide1: start_request: current=0xc6e1dcc8 (rq->sect=0,block0)
> >>hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> >>ide: failed opcode was: 0xec
> >>hdc: drive not ready for command
> >>
> >>ATA device, with non-removable media
> >>Standards:
> >>	Likely used: 1
> >>Configuration:
> >>	Logical		max	current
> >>	cylinders	0	0
> >>	heads		0	0
> >>	sectors/track	0	0
> >>	--
> >>	device size with M = 1024*1024:           0 MBytes
> >>	device size with M = 1000*1000:           0 MBytes
> >>Capabilities:
> >>	IORDY not likely
> >>	Cannot perform double-word IO
> >>	R/W multiple sector transfer: not supported
> >>	DMA: not supported
> >>	PIO: pio0
> >>/ #
> >>
> >>Then, I must do for example
> >>
> >>/ # dd if=/dev/hdc of=/dev/null bs=512 count=1 skip=128
> >>
> >>ide1: start_request: current=0xc6e7fcd4 (rq->sect=128,block 128)
> >>hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> >>ide: failed opcode was: unknown
> >>hdc: GOOD BITS   : ATA status=0x40 { DriveReady }
> >>ide: failed opcode was: unknown
> >>hdc: BAD BITS    : ATA status=0x08 { DataRequest }
> >>ide: failed opcode was: unknown
> >>hdc: drive not ready for command
> >>ide1: start_request: current=0xc6e7fcd4 (rq->sect=128,block 128)
> >>hdc: do_special: 0x02
> >>hdc: do_special: recalibrate
> >>ide1: start_request: current=0xc6e7fcd4 (rq->sect=128,block 128)
> >>hdc: reading: block=128, sectors=8, buffer=0xc1306000
> >>ide1: end_request:   current=0xc6e7fcd4
> >>1+0 record in
> >>1+0 record out
> >>/ #
> >>
> >>The lines with 'GOOD BITS' and 'BAD BITS' is debugging made by me in
> >>drivers/ide/ide-iops.c :
> >>    *startstop = ide_error(drive, "status error", stat);
> >>+   *startstop = ide_error(drive, "GOOD BITS   ", (stat & good));
> >>+   *startstop = ide_error(drive, "BAD BITS    ", (stat & bad));
> >>
> >>After that, redoing the command
> >>/ # dd if=/dev/hdc of=/dev/null bs=512 count=1 skip=128
> >>does not give an error, and
> >>
> >>/ # hdparm -I /dev/hdc	# gives:
> >>
> >>CompactFlash ATA device, with removable media
> >>	Model Number:       SanDisk SDCFB-128
> >>	Serial Number:      012101G0604F3431
> >>	Firmware Revision:  HDX 2.15
> >>Standards:
> >>	Supported: 10
> >>	Likely used: 10
> >>Configuration:
> >>	Logical		max	current
> >>	cylinders	980	497
> >>	heads		8	8
> >>	sectors/track	32	63
> >>	--
> >>	CHS current addressable sectors:     250488
> >>	LBA    user addressable sectors:     250880
> >>	device size with M = 1024*1024:         122 MBytes
> >>	device size with M = 1000*1000:         128 MBytes
> >>Capabilities:
> >>	LBA, IORDY(may be)(cannot be disabled)
> >>	Standby timer values: spec'd by Vendor
> >>	R/W multiple sector transfer: Max = 1	Current = 1
> > 
> > 
> > This is a bit suspicious... R/W multiple with max/current count == 1?
> > You may try disabling CONFIG_IDEDISK_MULTI_MODE or even #ifdef 0 all
> > the code in ide-probe.c:ide_disk_init_mult_count() (it seems to try
> > to enable multiple PIO support even if the config option is disabled).
> 
> I tried to #if 0 all the function, without changes.
> I tried modifying the function:
> 
> static void ide_disk_init_mult_count(ide_drive_t *drive)
> {
>     drive->mult_count = 0;
>     struct hd_driveid *id = drive->id;
>     id->max_multsect = 0;
>     id->multsect_valid = 0;
>     drive->mult_req = 0;
>     drive->special.b.set_multmode = 0;
> }
> 
> with the same result:
> 
> > # hdparm -I /dev/hdc
> 
> CompactFlash ATA device, with removable media
> 	Model Number:       SanDisk SDCFB-128
> 	Serial Number:      012101G0604F3431
> 	Firmware Revision:  HDX 2.15
> Standards:
> 	Supported: 10
> 	Likely used: 10
> Configuration:
> 	Logical		max	current
> 	cylinders	980	980
> 	heads		8	8
> 	sectors/track	32	32
> 	--
> 	CHS current addressable sectors:     250880
> 	LBA    user addressable sectors:     250880
> 	device size with M = 1024*1024:         122 MBytes
> 	device size with M = 1000*1000:         128 MBytes
> Capabilities:
> 	LBA, IORDY(may be)(cannot be disabled)
> 	Standby timer values: spec'd by Vendor
> 	R/W multiple sector transfer: Max = 1	Current = 1
> 	DMA: mdma0 mdma1 *mdma2
> 	     Cycle time: min=120ns recommended=120ns
> 	PIO: pio0 pio1 pio2 pio3 pio4
> 	     Cycle time: no flow control=120ns  IORDY flow control=120ns
> 	Integrity word not set (found 0x0000, expected 0xc0a5)
> 
> >>	DMA: mdma0 mdma1 *mdma2
> >>	     Cycle time: min=120ns recommended=120ns
> >>	PIO: pio0 pio1 pio2 pio3 pio4
> >>	     Cycle time: no flow control=120ns  IORDY flow control=120ns
> >>	Integrity word not set (found 0x0000, expected 0x10a5)
> >>
> >>/ #
> >>
> >>after that,
> >>
> >>/ # dd if=/dev/hdc of=/dev/null bs=512 count=1
> >>ide1: start_request: current=0xc6e7fc24 (rq->sect=0,block=0)
> >>hdc: reading: block=0, sectors=32, buffer=0xc1104000
> >>
> >>hdc: lost interrupt
> >>hdc: lost interrupt
> >>...
> > 
> > 
> > There is seems to be some more mistery here (but if the multiple
> > PIO support is indeed buggy that would explain why the device stops
> > responding here)...

OK, thanks for all the testing - it seems that this theory failed...

> I notice that sfdisk -R causes to read 8 sectors, while sfdisk -l will
> read 32 sectors...

I'm lost here - do you mean that 32 sectors read (sfdisk -R) work
and 8 sectors one (sfdisk -l) doesn't?

Could you send lspci -vvvxxx and hdparm --Istdout /dev/hdc outputs
(preferably by putting them into the kernel bugzilla bug entry)?

It would be also great to verify if this CF works with different PATA chipset
/ host driver (i.e. Intel one).  That way we would know where to look further
for the problem.  If it works on the other PATA chipset it might be that
via82cxxx PATA driver misses some errata (or has a weird bug in PIO mode
timings setup).  VIA686b datasheet should be publicly available so you may
want to compare the PIO timings programmed into PCI IDE timings registers
(lspci output + VIA686b datasheet) vs the ones given by the ATA standard
(ide-timing.h) and also generally verify that via82cxxx do the sane things
when compared with the datasheet...

Thanks,
Bart
