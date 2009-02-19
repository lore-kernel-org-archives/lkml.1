Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZBSHUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZBSHUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 02:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZBSHUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 02:20:00 -0500
Received: from smtp.nokia.com ([192.100.105.134]:61611 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbZBSHT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 02:19:59 -0500
Message-ID: <499D0B5C.4000005@nokia.com>
Date: Thu, 19 Feb 2009 09:33:48 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc_core: fix data timeout for SEND_EXT_CSD
References: <4991A00B.8040002@nokia.com>	<20090211133004.GH478@console-pimps.org>	<4992D90E.10506@nokia.com>	<4992E597.2030404@nokia.com> <20090218211627.7c16339a@mjolnir.ossman.eu>
In-Reply-To: <20090218211627.7c16339a@mjolnir.ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Feb 2009 07:19:31.0861 (UTC) FILETIME=[68BFA450:01C99262]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Pierre Ossman wrote:
> On Wed, 11 Feb 2009 16:49:59 +0200
> Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:
> 
>> Commit 0d3e0460f307e84904968aad6cff97bd688583d8
>> "MMC: CSD and CID timeout values" inadvertently broke
>> the timeout for the MMC command SEND_EXT_CSD.
>>
>> This patch puts it back again.
>>
>> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
>> ---
>>  drivers/mmc/core/mmc_ops.c |   16 ++++++++++------
>>  1 files changed, 10 insertions(+), 6 deletions(-)
>>
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
>> +     if (!mmc_host_is_spi(host) && opcode == MMC_SEND_EXT_CSD)
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
> I'm confused. Where did the 64 come from in the first place? That
> function will not be called for CID/CSD when !SPI. So the way I see it
> the code should be:
> 
> if ((opcode == MMC_SEND_CSD) || (opcode == (MMC_SEND_CID)) {
>         data.timeout_ns = 0;
>         data.timeout_clks = 8;
> } else {
>         mmc_set_data_timeout(&data, card);
> }

Theoretically yes, it should be 8 not 64 - if all the SPI devices obey
the standard.  As I do not have an SPI device I did not feel comfortable
changing it.  Also 64 clocks is not a long time anyway, so it did not
seem to do any harm.

