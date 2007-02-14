Return-Path: <linux-kernel-owner+w=401wt.eu-S964782AbXBNVoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964782AbXBNVoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964780AbXBNVoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:44:06 -0500
Received: from mailhub2.otago.ac.nz ([139.80.64.247]:38982 "EHLO
	mailhub2.otago.ac.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964779AbXBNVoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:44:04 -0500
Message-ID: <45D3829C.8050302@maths.otago.ac.nz>
Date: Thu, 15 Feb 2007 10:43:56 +1300
From: Greg Trounson <gregt@maths.otago.ac.nz>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AHCI - remove probing of ata2
References: <45D25E37.1060106@maths.otago.ac.nz> <45D34B47.5090005@tmr.com>
In-Reply-To: <45D34B47.5090005@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Greg Trounson wrote:
>> At the risk of sounding like a "me too" post:
>>
>> I also have an Asus P5W-DH, with the following drives connected:
>>
>> SATA: ST3250820AS, connected to sata1
>> PATA: HL-DT-ST GSA-H12N, ATAPI DVD Writer, Primary master
>>
>> On bootup of 2.6.19 and 2.6.20, the kernel stalls for 1 minute when 
>> probing sata2, eventually giving up and continuing the boot process.  
>> There is no physical sata2 connector on the Motherboard, just solder 
>> lugs between sata1 and sata3.  From other users I understand this is 
>> really a Silicon Image SIL4723 SATA to 2-Port SATA splitter.  It is 
>> detected by the kernel as a disk, as below.
>>
>> The relevant part of the boot process looks like:
>> ...
>> libata version 2.00 loaded.
>> ahci 0000:00:1f.2: version 2.0
>> ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 22
>> PCI: Setting latency timer of device 0000:00:1f.2 to 64
>> ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl 
>> SATA mode
>> ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part
>> ata1: SATA max UDMA/133 cmd 0xF882A900 ctl 0x0 bmdma 0x0 irq 219
>> ata2: SATA max UDMA/133 cmd 0xF882A980 ctl 0x0 bmdma 0x0 irq 219
>> ata3: SATA max UDMA/133 cmd 0xF882AA00 ctl 0x0 bmdma 0x0 irq 219
>> ata4: SATA max UDMA/133 cmd 0xF882AA80 ctl 0x0 bmdma 0x0 irq 219
>> scsi0 : ahci
>> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> ata1.00: ATA-7, max UDMA/133, 488397168 sectors: LBA48 NCQ (depth 31/32)
>> ata1.00: ata1: dev 0 multi count 16
>> ata1.00: configured for UDMA/133
>> scsi1 : ahci
>> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>
>> ...waits 20 seconds...
>>
>> ata2.00: qc timeout (cmd 0xec)
>> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x104)
>>
>> ...waits 5 seconds...
>>
>> ata2: port is slow to respond, please be patient (Status 0x80)
>>
>> ...waits 30 seconds...
>>
>> ata2: port failed to respond (30 secs, Status 0x80)
>> ata2: COMRESET failed (device not ready)
>> ata2: hardreset failed, retrying in 5 secs
>>
>> ...waits 5 seconds...
>>
>> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> ata2.00: ATA-6, max UDMA/133, 640 sectors: LBA
>> ata2.00: ata2: dev 0 multi count 1
>> ata2.00: configured for UDMA/133
>> scsi2 : ahci
>> ata3: SATA link down (SStatus 0 SControl 300)
>> ...
>>
>> A bit of poking about shows:
>>
>> fdisk -l /dev/sdb
>> Disk /dev/sdb: 0 MB, 327680 bytes
>> 255 heads, 63 sectors/track, 0 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Disk /dev/sdb doesn't contain a valid partition table
>>
>> So it presents itself as a 320k disk, filled with zeroes as below:
>>
>> dd if=/dev/sdb |hexdump
>> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
>> *
>> 0050000
>>
>> 640+0 records in
>> 640+0 records out
>> 327680 bytes (328 kB) copied, 0.0106662 seconds, 30.7 MB/s
>>
...
> Is this 320k of cache memory, or in any way some actual storage on the 
> system? Have you tried to write to it out of curiosity? Seems odd that 
> it would be detected if there were nothing at all present, although 
> obviously it could be artifact.

According to the product outline at 
http://www.siliconimage.com/products/product.aspx?id=64, the Silicon Image port multiplier 
has an EEPROM of unspecified size.

With the drive appearing as precisely 320K I wouldn't be surprised if this EEPROM is what 
it was seeing.  Even though it's currently filled with zeros I dare not write to it 
through fear of bricking the controller.

Greg



