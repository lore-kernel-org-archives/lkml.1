Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYJOVXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYJOVXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYJOVW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:22:58 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:36772 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753714AbYJOVWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:22:55 -0400
Message-ID: <48F65F2A.9020007@ru.mvista.com>
Date: Thu, 16 Oct 2008 01:22:50 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/18] ide: add ->set_irq method
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <20080620213424.13202.16889.sendpatchset@localhost.localdomain> <48F5DFF7.9010908@ru.mvista.com> <200810152022.44708.bzolnier@gmail.com>
In-Reply-To: <200810152022.44708.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>> Add ->set_irq method for setting nIEN bit of ATA Device Control
>>> register and use it instead of ide_set_irq().
>>>
>>> While at it:
>>>
>>> * Use ->set_irq in init_irq() and do_reset1().
>>>
>>> * Don't use HWIF() macro in ide_check_pm_state().
>>>
>>> There should be no functional changes caused by this patch.
>>>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>>   
>>>       
>> [...]
>>     
>>> Index: b/drivers/ide/ide-iops.c
>>> ===================================================================
>>> --- a/drivers/ide/ide-iops.c
>>> +++ b/drivers/ide/ide-iops.c
>>> @@ -135,6 +135,23 @@ static u8 ide_read_sff_dma_status(ide_hw
>>>  		return inb(hwif->dma_base + ATA_DMA_STATUS);
>>>  }
>>>  
>>> +static void ide_set_irq(ide_hwif_t *hwif, int on)
>>> +{
>>> +	u8 ctl = ATA_DEVCTL_OBS;
>>> +
>>> +	if (on == 4) { /* hack for SRST */
>>> +		ctl |= 4;
>>> +		on &= ~4;
>>> +	}
>>> +
>>> +	ctl |= on ? 0 : 2;
>>> +
>>> +	if (hwif->host_flags & IDE_HFLAG_MMIO)
>>> +		writeb(ctl, (void __iomem *)hwif->io_ports.ctl_addr);
>>> +	else
>>> +		outb(ctl, hwif->io_ports.ctl_addr);
>>> +}
>>> +
>>>  static void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
>>>  {
>>>  	ide_hwif_t *hwif = drive->hwif;
>>>   
>>>       
>> [...]
>>     
>>> @@ -1162,16 +1180,15 @@ static ide_startstop_t do_reset1 (ide_dr
>>>  	 * immediate interrupt due to the edge transition it produces.
>>>  	 * This single interrupt gives us a "fast poll" for drives that
>>>  	 * recover from reset very quickly, saving us the first 50ms wait time.
>>> +	 *
>>> +	 * TODO: add ->softreset method and stop abusing ->set_irq
>>>  	 */
>>>  	/* set SRST and nIEN */
>>> -	hwif->OUTBSYNC(hwif, ATA_DEVCTL_OBS | 6, io_ports->ctl_addr);
>>> +	hwif->set_irq(hwif, 4);
>>>  	/* more than enough time */
>>>  	udelay(10);
>>>       
>>    It seems to me that the whole idea of having 2 separate methods for 
>> writing the single device control register is a wrong idea.
>> I'm suggesting to convert set_irq() method to write_devctrl() method and 
>> pass the register value directly to it.
>>     

   Perhaps with the method itself forcing the obsolete bit 3 set like 
it's done now...

> Makes sense.  Care to make a patch?
>   

   I would if I had the time. Can only make another notch for now...

MBR, Sergei


