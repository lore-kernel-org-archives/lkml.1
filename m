Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbYKXMMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbYKXMMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 07:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYKXMMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 07:12:25 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:61789 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751191AbYKXMMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 07:12:24 -0500
Message-ID: <492A9A1F.50401@ru.mvista.com>
Date: Mon, 24 Nov 2008 15:12:15 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Shane McDonald <mcdonald.shane@gmail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Resurrect IT8172 IDE controller driver
References: <E1L4UpB-0007ro-1g@localhost> <492A8306.9000400@ru.mvista.com>
In-Reply-To: <492A8306.9000400@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>> diff -uprN a/drivers/ide/it8172.c b/drivers/ide/it8172.c
>> --- a/drivers/ide/it8172.c    1969-12-31 18:00:00.000000000 -0600
>> +++ b/drivers/ide/it8172.c    2008-11-23 01:06:01.000000000 -0600
[...]
>> +    pci_read_config_word(dev, 0x40, &drive_enables);
>> +    pci_read_config_dword(dev, 0x44, &drive_timing);
>> +
>> +    /*
>> +     * FIX! The DIOR/DIOW pulse width and recovery times in port 0x44
>>   
>
>   It's usually FIXME. :-)
>
>> +     * are being left at the default values of 8 PCI clocks (242 nsec
>> +     * for a 33 MHz clock).
>
>   It's 240, not 242 ns as 33 is actually 33.333.

   The maximum values give cycle time of 480 ns menaing that the 
controller doesn't support PIO mode 0. Hm...

>> +         * even though both numbers meet the minimum ATAPI-4 spec
>> +         * of 73 and 54 nsec for UDMA 1 and 2 respectively.
>> +         * So the faster times are not implemented here.
>> +         * The good news is that the slower cycle time has
>> +         * very little affect on transfer performance.
>>   
>
>   This should only affect the write performance, reads.

   Don't know where the reset of the phrase go -- it should have been 
"on reads the drive dicteates the UDMA timings".

>> +
>> +        u_speed = 0 << (drive->dn * 4);
>>   
> +         */
>
>   I think you're actually setting UltraDMA mode 2 timing regardless of 
> the mode selected.

   Oops, I thought I'd edited that out. That's mode 0 timing.

>> +static const struct ide_port_info it8172_chipset __devinitdata = {
>> +    .name        = DRV_NAME,
>> +    .init_chipset    = init_chipset_it8172,
>> +    .port_ops    = &it8172_port_ops,
>> +    .enablebits    = {{0x00, 0x00, 0x00}, {0x40, 0x00, 0x01} },
>>   
>
>   Wrong, should be:
>
>     .enablebits    = {{0x41, 0x80, 0x80}, {0x00, 0x00, 0x00}},
>
>  If that doesn't work (firmware doesn't enable the channel), you can 
> leave it all 0s...
>
>>     .host_flags    = IDE_HFLAG_SINGLE,
>> +    .pio_mask    = ATA_PIO4,

   No, PIO mode 0 isn't supported, hence the mask should be 0x1e.

MBR, Sergei


