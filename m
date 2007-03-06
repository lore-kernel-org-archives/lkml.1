Return-Path: <linux-kernel-owner+w=401wt.eu-S933180AbXCFJUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180AbXCFJUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934007AbXCFJUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:20:14 -0500
Received: from 85-18-76-201.ip.fastwebnet.it ([85.18.76.201]:55962 "EHLO
	85-18-76-201.ip.fastwebnet.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933180AbXCFJTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:19:55 -0500
Message-ID: <45ED3218.5000406@robox.it>
Date: Tue, 06 Mar 2007 10:19:20 +0100
From: Marco Lazzarotto <m.lazzarotto@robox.it>
User-Agent: Mozilla Thunderbird 1.0.2 (X11/20070113)
X-Accept-Language: it, it-it, en-us, en
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Trouble using some (fast) compact flash as ide device on an embedded
 system
References: <45E6D7EB.5080501@robox.it> <20070302195650.GA5697@ucw.cz> <200703052316.50257.bzolnier@gmail.com>
In-Reply-To: <200703052316.50257.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ciao!

Bartlomiej Zolnierkiewicz ha scritto:
> On Friday 02 March 2007, Pavel Machek wrote:
> 
>>Hi!
>>
>>
>>>As I reported in bug 8036 in bugzilla.kernel.org,
>>>
>>>Hardware Environment:
>>>
>>> - Use a compact flash SanDisk SDCFB-128 Firmware revision HDX 2.15
>>>   (we used other compact flashes with the same hw ad sw for years
>>>    with  no trouble)
>>>
>>>It happens on both etx boards:
>>> - VIA SOM-ETX (4475)
>>> - Gene-4312

ERRATA CORRIGE: Gene-4312 is not a etx board ;-) but a pc/104

>>>
>>>Doing the command
>>>sfdisk -R /dev/hdc
>>>
>>>gives:
>>>
>>> * * *
>>>ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
>>>hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
>>>ide: failed opcode was: unknown
>>>hdc: drive not ready for command
>>>ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
>>>hdc: do_special: 0x02
>>>hdc: do_special: recalibrate
>>>ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
>>>hdc: reading: block=0 sectors=8, buffer = 0xc6cd40000
>>>ide1: end_request: current=0xc6ebe754
>>> * * *
>>>
>>>the 'bad bit' in status error is DataRequest
>>>
>>>
>>>
>>>doing
>>>sfdisk -l /dev/hdc
>>>
>>>gives:
>>>
>>> * * *
>>>ide1: start_request: current=0xc6ebecd4 (rq->sect=0,block 0)
>>>hdc: reading: block=0, sectors=32, buffer=0xc6f37000
>>>hdc: lost interrupt
>>>hdc: lost interrupt [and so on several times]
>>> * * *
>>>
>>>I have no knowledge of the internals of the linux kernel, but I'm a
>>>programmer and have both hardware and time to spend on solving this issue.
>>
>>Debug it, then :-). Try limiting its speed with hdparm to see if it
>>helps.

I tried hdparm -p 0 /dev/hdc but nothing changes

> I would suggest trying booting with "ide=nodma" first.

I tried this too, without success.
I disabled 'Use PCI DMA by default when available' in the kernel, if
this is enabled the message 'hdc: lost interrupt' comes when the kernel
tries to access the CF for the first time.

 * * * Other information : * * *

If I try hdparm -I /dev/hdc immediately after boot I receive:

/ # hdparm -I /dev/hdc

/dev/hdc:
hdc: ide_cmd_ioctl()
hdc: ide_do_drive_cmd()
ide1: start_request: current=0xc6e1dcc8 (rq->sect=0,block0)
hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: 0xec
hdc: drive not ready for command

ATA device, with non-removable media
Standards:
	Likely used: 1
Configuration:
	Logical		max	current
	cylinders	0	0
	heads		0	0
	sectors/track	0	0
	--
	device size with M = 1024*1024:           0 MBytes
	device size with M = 1000*1000:           0 MBytes
Capabilities:
	IORDY not likely
	Cannot perform double-word IO
	R/W multiple sector transfer: not supported
	DMA: not supported
	PIO: pio0
/ #

Then, I must do for example

/ # dd if=/dev/hdc of=/dev/null bs=512 count=1 skip=128

ide1: start_request: current=0xc6e7fcd4 (rq->sect=128,block 128)
hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown
hdc: GOOD BITS   : ATA status=0x40 { DriveReady }
ide: failed opcode was: unknown
hdc: BAD BITS    : ATA status=0x08 { DataRequest }
ide: failed opcode was: unknown
hdc: drive not ready for command
ide1: start_request: current=0xc6e7fcd4 (rq->sect=128,block 128)
hdc: do_special: 0x02
hdc: do_special: recalibrate
ide1: start_request: current=0xc6e7fcd4 (rq->sect=128,block 128)
hdc: reading: block=128, sectors=8, buffer=0xc1306000
ide1: end_request:   current=0xc6e7fcd4
1+0 record in
1+0 record out
/ #

The lines with 'GOOD BITS' and 'BAD BITS' is debugging made by me in
drivers/ide/ide-iops.c :
    *startstop = ide_error(drive, "status error", stat);
+   *startstop = ide_error(drive, "GOOD BITS   ", (stat & good));
+   *startstop = ide_error(drive, "BAD BITS    ", (stat & bad));

After that, redoing the command
/ # dd if=/dev/hdc of=/dev/null bs=512 count=1 skip=128
does not give an error, and

/ # hdparm -I /dev/hdc	# gives:

CompactFlash ATA device, with removable media
	Model Number:       SanDisk SDCFB-128
	Serial Number:      012101G0604F3431
	Firmware Revision:  HDX 2.15
Standards:
	Supported: 10
	Likely used: 10
Configuration:
	Logical		max	current
	cylinders	980	497
	heads		8	8
	sectors/track	32	63
	--
	CHS current addressable sectors:     250488
	LBA    user addressable sectors:     250880
	device size with M = 1024*1024:         122 MBytes
	device size with M = 1000*1000:         128 MBytes
Capabilities:
	LBA, IORDY(may be)(cannot be disabled)
	Standby timer values: spec'd by Vendor
	R/W multiple sector transfer: Max = 1	Current = 1
	DMA: mdma0 mdma1 *mdma2
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4
	     Cycle time: no flow control=120ns  IORDY flow control=120ns
	Integrity word not set (found 0x0000, expected 0x10a5)

/ #

after that,

/ # dd if=/dev/hdc of=/dev/null bs=512 count=1
ide1: start_request: current=0xc6e7fc24 (rq->sect=0,block=0)
hdc: reading: block=0, sectors=32, buffer=0xc1104000

hdc: lost interrupt
hdc: lost interrupt
...

> Should help if this is CF adapter without DMA support with DMA capable CF.
> [ Hmm, this should be in the documentation somewhere but actually isn't. ]
> 
> Thanks,
> Bart

Tanks
	Marco Lazzarotto

-- 
 *------------------------------------------------------------------*
 | Vi preghiamo, se questo messaggio fosse ricevuto per errore,     |
 | di avvisare il mittente e, tenuto conto delle responsabilita'    |
 | connesse all'indebito utilizzo e/o divulgazione del messaggio    |
 | e/o delle informazioni in esso contenute, di cancellare          |
 | l'originale e distruggere le varie copie o stampe. Grazie        |
 *------------------------------------------------------------------*
 | The information in this e-mail is solely for the addressee.      |
 | Please delete this e-mail if you are not the intended recipient. |
 | Do not disclose or distribute the communication in any form.     |
 *------------------------------------------------------------------*
