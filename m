Return-Path: <linux-kernel-owner+w=401wt.eu-S933339AbXCHVap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbXCHVap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbXCHVap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:30:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:20807 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339AbXCHVao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:30:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=XTmAdwTNHCWJIN2c3Zxk1/vqKQIfSdNY5RpkMZCgqC2CWARFwnanKaG2XQlKw0hUmd/GWGEvqlbkOOSUIbtW1+uVtnuk8t4EYK4MiyO8wHLX4xle2KawQtrMLii8AlYFPjkaD57hv3LRJAaAyweKP+v8GtF6C0f37FXvLsSZ1eY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Marco Lazzarotto <m.lazzarotto@robox.it>
Subject: Re: Trouble using some (fast) compact flash as ide device on an embedded system
Date: Thu, 8 Mar 2007 22:37:36 +0100
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
References: <45E6D7EB.5080501@robox.it> <200703052316.50257.bzolnier@gmail.com> <45ED3218.5000406@robox.it>
In-Reply-To: <45ED3218.5000406@robox.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703082237.36231.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Czesc!

On Tuesday 06 March 2007, Marco Lazzarotto wrote:
> Ciao!
> 
> Bartlomiej Zolnierkiewicz ha scritto:
> > On Friday 02 March 2007, Pavel Machek wrote:
> > 
> >>Hi!
> >>
> >>
> >>>As I reported in bug 8036 in bugzilla.kernel.org,
> >>>
> >>>Hardware Environment:
> >>>
> >>> - Use a compact flash SanDisk SDCFB-128 Firmware revision HDX 2.15
> >>>   (we used other compact flashes with the same hw ad sw for years
> >>>    with  no trouble)
> >>>
> >>>It happens on both etx boards:
> >>> - VIA SOM-ETX (4475)
> >>> - Gene-4312
> 
> ERRATA CORRIGE: Gene-4312 is not a etx board ;-) but a pc/104

What IDE hardware / host driver is used by this system?

> >>>
> >>>Doing the command
> >>>sfdisk -R /dev/hdc
> >>>
> >>>gives:
> >>>
> >>> * * *
> >>>ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
> >>>hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> >>>ide: failed opcode was: unknown
> >>>hdc: drive not ready for command
> >>>ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
> >>>hdc: do_special: 0x02
> >>>hdc: do_special: recalibrate
> >>>ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
> >>>hdc: reading: block=0 sectors=8, buffer = 0xc6cd40000
> >>>ide1: end_request: current=0xc6ebe754
> >>> * * *
> >>>
> >>>the 'bad bit' in status error is DataRequest

Seems like the device wants data from/to host and I have no idea why this
is happening.  It might be that this particular CF has problems with one
of the commands that IDE driver issues during device initialization.

I assume that device is recognized properly by the driver during probe, right?
If so probably adding some debugging printks (i.e. dumping status register)
to ide-disk.c:idedisk_setup() would shed some more light at the problem...

> >>>
> >>>
> >>>doing
> >>>sfdisk -l /dev/hdc
> >>>
> >>>gives:
> >>>
> >>> * * *
> >>>ide1: start_request: current=0xc6ebecd4 (rq->sect=0,block 0)
> >>>hdc: reading: block=0, sectors=32, buffer=0xc6f37000
> >>>hdc: lost interrupt
> >>>hdc: lost interrupt [and so on several times]
> >>> * * *
> >>>
> >>>I have no knowledge of the internals of the linux kernel, but I'm a
> >>>programmer and have both hardware and time to spend on solving this issue.
> >>
> >>Debug it, then :-). Try limiting its speed with hdparm to see if it
> >>helps.
> 
> I tried hdparm -p 0 /dev/hdc but nothing changes
> 
> > I would suggest trying booting with "ide=nodma" first.
> 
> I tried this too, without success.
> I disabled 'Use PCI DMA by default when available' in the kernel, if
> this is enabled the message 'hdc: lost interrupt' comes when the kernel
> tries to access the CF for the first time.

Yep, disabling this config option should have the same effect as "ide=nodma".
However the kernel parameter should work too (bug in the host driver?).

>  * * * Other information : * * *
> 
> If I try hdparm -I /dev/hdc immediately after boot I receive:
> 
> / # hdparm -I /dev/hdc
> 
> /dev/hdc:
> hdc: ide_cmd_ioctl()
> hdc: ide_do_drive_cmd()
> ide1: start_request: current=0xc6e1dcc8 (rq->sect=0,block0)
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: 0xec
> hdc: drive not ready for command
> 
> ATA device, with non-removable media
> Standards:
> 	Likely used: 1
> Configuration:
> 	Logical		max	current
> 	cylinders	0	0
> 	heads		0	0
> 	sectors/track	0	0
> 	--
> 	device size with M = 1024*1024:           0 MBytes
> 	device size with M = 1000*1000:           0 MBytes
> Capabilities:
> 	IORDY not likely
> 	Cannot perform double-word IO
> 	R/W multiple sector transfer: not supported
> 	DMA: not supported
> 	PIO: pio0
> / #
> 
> Then, I must do for example
> 
> / # dd if=/dev/hdc of=/dev/null bs=512 count=1 skip=128
> 
> ide1: start_request: current=0xc6e7fcd4 (rq->sect=128,block 128)
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: GOOD BITS   : ATA status=0x40 { DriveReady }
> ide: failed opcode was: unknown
> hdc: BAD BITS    : ATA status=0x08 { DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> ide1: start_request: current=0xc6e7fcd4 (rq->sect=128,block 128)
> hdc: do_special: 0x02
> hdc: do_special: recalibrate
> ide1: start_request: current=0xc6e7fcd4 (rq->sect=128,block 128)
> hdc: reading: block=128, sectors=8, buffer=0xc1306000
> ide1: end_request:   current=0xc6e7fcd4
> 1+0 record in
> 1+0 record out
> / #
> 
> The lines with 'GOOD BITS' and 'BAD BITS' is debugging made by me in
> drivers/ide/ide-iops.c :
>     *startstop = ide_error(drive, "status error", stat);
> +   *startstop = ide_error(drive, "GOOD BITS   ", (stat & good));
> +   *startstop = ide_error(drive, "BAD BITS    ", (stat & bad));
> 
> After that, redoing the command
> / # dd if=/dev/hdc of=/dev/null bs=512 count=1 skip=128
> does not give an error, and
> 
> / # hdparm -I /dev/hdc	# gives:
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
> 	cylinders	980	497
> 	heads		8	8
> 	sectors/track	32	63
> 	--
> 	CHS current addressable sectors:     250488
> 	LBA    user addressable sectors:     250880
> 	device size with M = 1024*1024:         122 MBytes
> 	device size with M = 1000*1000:         128 MBytes
> Capabilities:
> 	LBA, IORDY(may be)(cannot be disabled)
> 	Standby timer values: spec'd by Vendor
> 	R/W multiple sector transfer: Max = 1	Current = 1

This is a bit suspicious... R/W multiple with max/current count == 1?
You may try disabling CONFIG_IDEDISK_MULTI_MODE or even #ifdef 0 all
the code in ide-probe.c:ide_disk_init_mult_count() (it seems to try
to enable multiple PIO support even if the config option is disabled).

> 	DMA: mdma0 mdma1 *mdma2
> 	     Cycle time: min=120ns recommended=120ns
> 	PIO: pio0 pio1 pio2 pio3 pio4
> 	     Cycle time: no flow control=120ns  IORDY flow control=120ns
> 	Integrity word not set (found 0x0000, expected 0x10a5)
> 
> / #
> 
> after that,
> 
> / # dd if=/dev/hdc of=/dev/null bs=512 count=1
> ide1: start_request: current=0xc6e7fc24 (rq->sect=0,block=0)
> hdc: reading: block=0, sectors=32, buffer=0xc1104000
> 
> hdc: lost interrupt
> hdc: lost interrupt
> ...

There is seems to be some more mistery here (but if the multiple
PIO support is indeed buggy that would explain why the device stops
responding here)...

Bart
