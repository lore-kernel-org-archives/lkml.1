Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZD0BoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZD0BoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 21:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZD0BoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 21:44:00 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:2478 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbZD0Bn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 21:43:59 -0400
From: "Cai, Cliff" <Cliff.Cai@analog.com>
X-IronPort-AV: E=Sophos;i="4.40,250,1238990400"; 
   d="scan'208";a="86970182"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH][RESEND][mmc/host]:Blackfin SD Host Controller Driver
Date: Mon, 27 Apr 2009 09:47:15 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA03F20154@chinexm1.ad.analog.com>
In-Reply-To: <20090426215030.582a6fbb@mjolnir.ossman.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][RESEND][mmc/host]:Blackfin SD Host Controller Driver
Thread-Index: AcnGqEcdIFv+bJztQCy4wFQ4IUeK7gALUWyw
References: <1239903641-14342-1-git-send-email-cliffcai.sh@gmail.com> <20090426215030.582a6fbb@mjolnir.ossman.eu>
To: "Pierre Ossman" <pierre@ossman.eu>
CC: <linux-kernel@vger.kernel.org>, "Cliff Cai" <cliffcai.sh@gmail.com>
X-OriginalArrivalTime: 27 Apr 2009 01:43:53.0324 (UTC) FILETIME=[9EEC02C0:01C9C6D9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Pierre Ossman [mailto:pierre@ossman.eu] 
>Sent: Monday, April 27, 2009 3:51 AM
>To: cliffcai.sh@gmail.com
>Cc: linux-kernel@vger.kernel.org; Cai, Cliff; Cliff Cai
>Subject: Re: [PATCH][RESEND][mmc/host]:Blackfin SD Host 
>Controller Driver
>
>On Fri, 17 Apr 2009 01:40:41 +0800
>cliffcai.sh@gmail.com wrote:
>
>> From: Cliff Cai <cliffcai.sh@gmail.com>
>> 
>> Signed-off-by: Cliff Cai <cliffcai.sh@gmail.com>
>> ---
>>  drivers/mmc/host/Kconfig    |   19 ++
>>  drivers/mmc/host/Makefile   |    1 +
>>  drivers/mmc/host/bfin_sdh.c |  648 
>> +++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 668 insertions(+), 0 deletions(-)  create mode 
>> 100644 drivers/mmc/host/bfin_sdh.c
>> 
>
>I'd also like a MAINTAINERS entry for the driver.
>
>> +config SDH_BFIN
>> +	tristate "Blackfin Secure Digital Host support"
>> +	depends on MMC && ((BF54x && !BF544) || (BF51x && !BF512))
>
>You don't need "depends on MMC" as the entire block is 
>conditioned on MMC already.
>
>> +/* In term of 
>> +ADSP_BF5xx_Blackfin_Processor_Peripheral_Hardware_Reference,
>> + * the SDH allows software to detect a card when it is 
>inserted into its slot.
>> + * The SD_DATA3 pin powers up low due to a special pull-down 
>> +resistor. When an
>> + * SD Card is inserted in its slot, the resistance increases and a 
>> +rising edge
>> + * is detected by the SDH module.
>> + * But this doesn't work sometimes. When a MMC/SD card is inserted, 
>> +the voltage
>> + * doesn't rise on SD_DATA3. In term of The MultiMediaCard System 
>> +Specification,
>> + * SD_DATA3 is used as CS pin in SPI mode. The MultiMediaCard wakes 
>> +up in the
>> + * MultiMediaCard mode. During the scan procedure, host will send 
>> +CMD0 to reset
>> + * MMC card, if CS pin is low, MMC card will enter SPI mode. Of 
>> +course Secure
>> + * Digital Host controller is not a SPI controller. So the Card 
>> +detect function
>> + * has to be disabled. After card is inserted run "echo 0 > 
>/proc/driver/sdh"
>> + * to trigger card scanning */
>
>If the controller can only do DAT3-detection, then I think 
>it's best if we put it into polling mode.

What did you mean the polling mode,using a timer?


>> +	BUG_ON(data->blksz & (data->blksz -1));
>
>Not a bug so you need to deal with this. Most likely fail the 
>request with EINVAL.
>
>> +#if defined(CONFIG_BF54x)
>> +	dma_cfg |= DMAFLOW_ARRAY | NDSIZE_5 | RESTART | 
>WDSIZE_32 | DMAEN;
>> +	for (i = 0; i < host->dma_len; i++) {
>> +		host->sg_cpu[i].start_addr = 
>sg_dma_address(&data->sg[i]);
>
>You cannot index sg lists directly anymore. You have to 
>iterate over them using the iteration helpers.

Why?

>> +	if (!data->error)
>> +		data->bytes_xfered = data->blocks * data->blksz;
>> +	else
>> +		data->bytes_xfered = data->blocks * data->blksz - \
>> +				     bfin_read_SDH_DATA_CNT();
>
>This is probably wrong. You need to set bytes_xfered to the 
>number of bytes acked by the card, not the number of bytes 
>sent over the wire (for writes that is). If your hardware can 
>provide that then fine, otherwise set bytes_xfered to 0 on failure.
>
>> +	mmc->ops = &sdh_ops;
>> +	mmc->max_phys_segs = NR_SG;
>> +	mmc->max_seg_size = 1 << 16;
>> +	mmc->max_blk_size = 2 << 11;
>> +	mmc->max_blk_count = 2 << 16;
>
>You forgot max_req_size.
>
>> +out3:
>> +	free_dma(host->dma_ch);
>
>You need a mmc_remove_host() here.
>
>Also check Mike's comments.
 
I will.

Thanks

Cliff
