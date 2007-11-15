Return-Path: <linux-kernel-owner+w=401wt.eu-S1759405AbXKOJgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405AbXKOJgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 04:36:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbXKOJfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 04:35:55 -0500
Received: from anubis.medic.chalmers.se ([129.16.30.218]:50259 "EHLO
	anubis.medic.chalmers.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbXKOJfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 04:35:54 -0500
X-Greylist: delayed 1698 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2007 04:35:53 EST
Message-ID: <473C0CCE.40407@ce.chalmers.se>
Date: Thu, 15 Nov 2007 10:09:34 +0100
From: Patric Karlsson <patric@ce.chalmers.se>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.ide
To: Grzegorz Kulewski <kangur@polcom.net>
CC: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: libata_uli puts second channel to PIO4 on 2.6.18
References: <Pine.LNX.4.63.0702030231150.6097@alpha.polcom.net> <45C96174.2030407@gmail.com> <Pine.LNX.4.63.0702110512010.15871@alpha.polcom.net>
In-Reply-To: <Pine.LNX.4.63.0702110512010.15871@alpha.polcom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grzegorz Kulewski wrote:
> On Wed, 7 Feb 2007, Tejun Heo wrote:
>> Grzegorz Kulewski wrote:
>>>  It worked very well for half a year but with one disk (IIRC it was even
>>>  plugged into second channel but I wont bet on it). Now I have second 
>>> disk
>>>  (very similar) and it is always put into PIO4 mode:
>>>
>>>  [   17.404451] libata version 2.00 loaded.
>>>  [   17.404916] sata_uli 0000:00:04.0: version 1.0
>>>  [   17.405009] ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 18 (level, 
>>> low)
>>>  -> IRQ 185
>>>  [   17.405223] ata1: SATA max UDMA/133 cmd 0xD400 ctl 0xD002 bmdma 
>>> 0xB000
>>>  irq 185
>>>  [   17.405385] ata2: SATA max UDMA/133 cmd 0xB800 ctl 0xB402 bmdma 
>>> 0xB008
>>>  irq 185
>>>  [   17.405519] scsi2 : sata_uli
>>>  [   17.858803] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>>>  [   17.880541] ata1.00: ATA-7, max UDMA/133, 488397168 sectors: 
>>> LBA48 NCQ
>>>  (depth 0/32)
>>>  [   17.880660] ata1.00: ata1: dev 0 multi count 16
>>>  [   17.888858] ata1.00: configured for UDMA/133
>>>  [   17.888941] scsi3 : sata_uli
>>>  [   18.342469] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>>>  [   18.343573] ata2.00: ATA-7, max UDMA/133, 488397168 sectors: 
>>> LBA48 NCQ
>>>  (depth 0/32)
>>>  [   18.343691] ata2.00: ata2: dev 0 multi count 16
>>>  [   18.344972] ata2.00: configured for PIO4
>>
>> Some uli controllers have simplex bit stuck high indicating that they
>> can't perform DMA transfers simultaneously on both channels.  In this
>> case, libata configures the second channel as PIO only.  This has been
>> worked around by the following commit.
>>
>> commit b2a8bbe67d73631c71492fd60b757fc50a87f182
>> Author: Tejun Heo <htejun@gmail.com>
>> Date:   Thu Jan 25 19:40:05 2007 +0900
>>
>>   libata: implement ATA_FLAG_IGN_SIMPLEX and use it in sata_uli
>>
>>    Some uli controllers have stuck SIMPLEX bit which can't be cleared
>>    with ata_pci_clear_simplex(), but the controller is capable of doing
>>    DMAs on both channels simultaneously.  Implement ATA_FLAG_IGN_SIMPLEX
>>    which makes libata ignore the simplex bit and use it in sata_uli.
>>
>>    Signed-off-by: Tejun Heo <htejun@gmail.com>
>>    Signed-off-by: Jeff Garzik <jeff@garzik.org>
>>
>> For quick fix, just comment out lines which set ATA_HOST_SIMPLEX in
>> drivers/scsi/libata-bmdma.c.  e.g.
>>
>>      /*if (inb(bmdma + 2) & 0x80)
>>          probe_ent->host_set_flags |= ATA_HOST_SIMPLEX;*/
> 
> Thanks! After this fix it is working ok. Any chance to see the proper 
> fix in -stable kernels for at least 2.6.18.x and 2.6.19.x?
> 
> 
> Thanks,
> 
> Grzegorz Kulewski
> 

I was wondering the same thing. While I could patch the kernel, and make 
a custom build. I prefer not to, and just upgrade to a newer version.

/Patric
