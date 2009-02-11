Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZBKNnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZBKNnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbZBKNmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:42:55 -0500
Received: from smtp.nokia.com ([192.100.122.230]:25397 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbZBKNmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:42:54 -0500
Message-ID: <4992D90E.10506@nokia.com>
Date: Wed, 11 Feb 2009 15:56:30 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Pierre Ossman <drzeus-mmc@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc_core: fix data timeout for SEND_EXT_CSD
References: <4991A00B.8040002@nokia.com> <20090211133004.GH478@console-pimps.org>
In-Reply-To: <20090211133004.GH478@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2009 13:42:43.0784 (UTC) FILETIME=[9DB2AC80:01C98C4E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Fleming wrote:
> On Tue, Feb 10, 2009 at 05:40:59PM +0200, Adrian Hunter wrote:
>> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
>> index 9c50e6f..418a270 100644
>> --- a/drivers/mmc/core/mmc_ops.c
>> +++ b/drivers/mmc/core/mmc_ops.c
>> @@ -248,12 +248,16 @@ mmc_send_cxd_data(struct mmc_card *card, struct mmc_host *host,
>>
>>       sg_init_one(&sg, data_buf, len);
>>
>> -     /*
>> -      * The spec states that CSR and CID accesses have a timeout
>> -      * of 64 clock cycles.
>> -      */
>> -     data.timeout_ns = 0;
>> -     data.timeout_clks = 64;
>> +     if (!mmc_host_is_spi(card->host) && opcode == MMC_SEND_EXT_CSD)
>> +             mmc_set_data_timeout(&data, card);
>> +     else {
>> +             /*
>> +              * The spec states that CSR and CID accesses have a timeout
>> +              * of 64 clock cycles (8 for SPI).
>> +              */
>> +             data.timeout_ns = 0;
>> +             data.timeout_clks = 64;
>> +     }
>>
>>       mmc_wait_for_req(host, &mrq);
>>
> 
> Doh! You're right, I did inadvertently break this. Your fix looks good.
> 

Actually looking at it now, it seems to have an error, because card may be
NULL in the MMC_SEND_CID case.

Should be 

	if (!mmc_host_is_spi(host) && opcode == MMC_SEND_EXT_CSD)

I will resend.
