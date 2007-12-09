Return-Path: <linux-kernel-owner+w=401wt.eu-S1751816AbXLIRze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbXLIRze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 12:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXLIRzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 12:55:24 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:28170 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbXLIRzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 12:55:23 -0500
Date: Sun, 09 Dec 2007 11:55:14 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Bug: get EXT3-fs error Allocating block in system zone
In-reply-to: <fa.hqM73i24f6G31R5F3sKL8+3H8Ww@ifi.uio.no>
To: Marco Gatti <marco@pianoinflames.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Message-id: <475C2C02.70001@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Fg53DJSEh/kZhf/uRCv9FYZsaSQ@ifi.uio.no>
 <fa.nPzIjJ2SchPb1LOa/dRWb/WyEZU@ifi.uio.no>
 <fa.LkmHGN+Fx6H930bfeCDU6pGdBKM@ifi.uio.no>
 <fa.oSqMiIX7WubypXrhZGaRKU5wNGU@ifi.uio.no>
 <fa.0pc9/nNmTq+eWIU9rADRn0xYGdI@ifi.uio.no>
 <fa.hqM73i24f6G31R5F3sKL8+3H8Ww@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco Gatti wrote:
> Linus Torvalds schrieb:
>> Was there a dmesg out there somewhere?
>>
>> With 4G of RAM, you probably have some of it above the 4GB mark 
>> (because of RAM remapping etc, and the PCI decode hole in the low 
>> 4GB). It does sound like this is a DMA problem, and your controller 
>> cannot correctly DMA to the upper 4GB.
>>
>> So what controller/driver, what's the dmesg, and let's see if we can 
>> fix it by adding a DMA mask to it to limit it to the low 32 bits.
> 
> Controller / drivers:
> it's a board with intel Q35 chipset. The southbridge has an ICH9
> Intel Gigabit 82566DM-2 => e1000
> Intel matrix storage SATA => ahci.c
> Intel graphics media accelerator => not added to kernel
> Intel Audio => Intel HD Audio AC97
> 
> I just got "EXT3-fs error Allocating block in system zone" in dmesg with 
> 4 or more GBs of RAM. I listed boot up dmesg to get an idea of dma 
> config with different amount of RAM.
> 
> Thanks for your help.

The obvious suspect with a filesystem problem would be the disk 
controller driver, AHCI here. However, the controller appears to set the 
flag to indicate that it supports 64-bit DMA, so it should be fine, 
unless it lies of course (which we know that ATI SB600 chipset does, but 
I don't believe Intel is known to).

Could still be a DMA mapping bug that only shows up when IOMMU is used. 
However, AHCI is a pretty well tested driver..

> 
> dmesg with 2GB:

..

> 
> ahci 0000:00:1f.2: version 2.3
> ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
> ahci 0000:00:1f.2: nr_ports (6) and implemented port map (0xf) don't match
> ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0xf impl SATA 
> mode
> ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pmp pio slum part
> PCI: Setting latency timer of device 0000:00:1f.2 to 64
> scsi0 : ahci
> scsi1 : ahci
> scsi2 : ahci
> scsi3 : ahci
> ata1: SATA max UDMA/133 cmd 0xffffc20000334100 ctl 0x0000000000000000 
> bmdma 0x0000000000000000 irq 316
> ata2: SATA max UDMA/133 cmd 0xffffc20000334180 ctl 0x0000000000000000 
> bmdma 0x0000000000000000 irq 316
> ata3: SATA max UDMA/133 cmd 0xffffc20000334200 ctl 0x0000000000000000 
> bmdma 0x0000000000000000 irq 316
> ata4: SATA max UDMA/133 cmd 0xffffc20000334280 ctl 0x0000000000000000 
> bmdma 0x0000000000000000 irq 316

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

