Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbXGIMt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbXGIMt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 08:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbXGIMtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 08:49:23 -0400
Received: from mail.atmel.fr ([81.80.104.162]:47264 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbXGIMtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 08:49:22 -0400
Message-ID: <46922EAD.5050802@rfo.atmel.com>
Date: Mon, 09 Jul 2007 14:48:45 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <andrew@sanpeople.com>, Andreas Beier <mughat@gmail.com>,
       Hamish Guthrie <hamish@prodigi.ch>, Marc Pignat <marc.pignat@hevs.ch>,
       wux@landicorp.com, Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
Subject: Re: [PATCH] mmc: at91_mci: fix hanging and rework to match flowcharts
References: <4688EC94.1090901@rfo.atmel.com> <4688FE50.7050806@drzeus.cx>
In-Reply-To: <4688FE50.7050806@drzeus.cx>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman :
> Nicolas Ferre wrote:
>> Fixes hanging using multi block operations (seen during CMD25).
>> Follows closely the datasheet flowcharts.
>>
>> This piece of code handles better big file writing. I had to take care
>> of the notbusy signal during write (at91_mci_handle_cmdrdy function) and
>> to rearrange the AT91_MCI_ENDRX and AT91_MCI_RXBUFF flag usage.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
>> ---
> 
> Most of the patch looks ok. Do you want to wait for some more tests or should I
> chuck this into the imminent merge window?

*pong*

I think it is ok to put it into the merge window.

>> @@ -817,7 +834,11 @@ static int __init at91_mci_probe(struct
>>     mmc->ops = &at91_mci_ops;
>>     mmc->f_min = 375000;
>> -    mmc->f_max = 25000000;
>> +    if (cpu_is_at91sam9263())
>> +        mmc->f_max = 50000000;
>> +    else
>> +        mmc->f_max = 25000000;
>> +
>>     mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
>>     mmc->caps = MMC_CAP_BYTEBLOCK | MMC_CAP_MULTIWRITE;
>>
> 
> This seems unrelated to the rest of the patch. Also, high-speed won't be enabled
> unless you set the appropriate caps (which should be checked against timing
> specifications, not just assigned and hope for the best).

True. I remove this chunk off the patch.


>> @@ -830,11 +851,11 @@ static int __init at91_mci_probe(struct
>>     host->bus_mode = 0;
>>     host->board = pdev->dev.platform_data;
>>     if (host->board->wire4) {
>> -#ifdef SUPPORT_4WIRE
>> -        mmc->caps |= MMC_CAP_4_BIT_DATA;
>> -#else
>> -        printk("AT91 MMC: 4 wire bus mode not supported by this driver
>> - using 1 wire\n");
>> -#endif
>> +        if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
>> +            mmc->caps |= MMC_CAP_4_BIT_DATA;
>> +        else
>> +            printk("AT91 MMC: 4 wire bus mode not supported"
>> +                " - using 1 wire\n");
>>     }
>>
>>     /*
>>
> 
> This also looks unrelated.

Well, It is related to capacities of newer IPs that allow readproof and 
writeproof features that I enable here :

+	if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
+		mr |= AT91_MCI_RDPROOF | AT91_MCI_WRPROOF;

This allows to have a smooth data transmission internally (prevent 
underruns) and so have full 4 wires capacity. So I think this is good 
for having a full featured driver on all chips.

I resend a corrected patch now.

Regards,
-- 
Nicolas Ferre


