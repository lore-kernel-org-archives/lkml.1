Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZKZPQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZKZPQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 10:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbZKZPQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 10:16:55 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:26718 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1754788AbZKZPQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 10:16:54 -0500
Message-ID: <4B0E9C1F.4000104@ru.mvista.com>
Date: Thu, 26 Nov 2009 18:17:51 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 36/86] pata_it8213: add UDMA100 and UDMA133 support
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125170637.5446.77089.sendpatchset@localhost> <4B0E9928.2020809@ru.mvista.com>
In-Reply-To: <4B0E9928.2020809@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>> There shouldn't be any problems with it as IDE it8213 host driver
>> has been supporting UDMA100 and UDMA133 for years.

>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

>> Index: b/drivers/ata/pata_it8213.c
>> ===================================================================
>> --- a/drivers/ata/pata_it8213.c
>> +++ b/drivers/ata/pata_it8213.c
>> @@ -164,7 +164,7 @@ static void it8213_set_dmamode (struct a
>>  
>>          /* Clocks follow the PIIX style */
>>          u_speed = min(2 - (udma & 1), udma);
>> -        if (udma == 5)
>> +        if (udma > 4)
>>              u_clock = 0x1000;    /* 100Mhz */
>>          else if (udma > 2)
>>              u_clock = 1;        /* 66Mhz */
>> @@ -264,7 +264,7 @@ static int it8213_init_one (struct pci_d
>>          .flags        = ATA_FLAG_SLAVE_POSS,
>>          .pio_mask    = ATA_PIO4,
>>          .mwdma_mask    = ATA_MWDMA2,
>> -        .udma_mask     = ATA_UDMA4, /* FIXME: want UDMA 100? */
>> +        .udma_mask     = ATA_UDMA6,
>>          .port_ops    = &it8213_ops,
>>      };
>>      /* Current IT8213 stuff is single port */

>    Well, at 100 MHz it's probably not really UDMA6 but UDMA5 in 
> disguise... though u_speed would be 2 instead of 1 which should 
> correspond to either 3 clocks or 1 clock according to Intel's 
> documentation (different Intel docs give different figures and even ICH 
> PRM gives *both* clocks).

    If we take 3 clocks as correct (1 clock doesn't seem correct anyways, as 
with UDMA mode 5 UDMA cycle must be 20 ns and 1 clock gives only 10 ns). 
Well, then UDMA5 doesn't seem different from UDMA4 with ICH controllers and 
it's not clear why all the fuss about 100 MHz bit was necessary... :-/
    Returning to IT8213, with UDMA6 we have 'u_speed' of 2 that should 
correspond to 2 clocks which is 20 ns at 100 MHz and really is an UDMA5 
speed. Well, given UDMA5's slowness, that's definitely a gain. The question 
remains however, isn't this value reserved like on original ICH?

MBR, Sergei
