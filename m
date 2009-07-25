Return-Path: <linux-kernel-owner+w=401wt.eu-S1752034AbZGYQQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbZGYQQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 12:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZGYQQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 12:16:56 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18979 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbZGYQQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 12:16:55 -0400
Message-ID: <4A6B300A.10706@nokia.com>
Date: Sat, 25 Jul 2009 19:17:14 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Pierre Ossman <pierre@ossman.eu>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       "Karpov Denis.2 (EXT-Teleca/Helsinki)" <ext-denis.2.karpov@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 7/32] mmc: add host capabilities for SD only and MMC	only
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower> <20090710124054.1262.18902.sendpatchset@ahunter-tower> <20090725155336.GA12665@console-pimps.org>
In-Reply-To: <20090725155336.GA12665@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jul 2009 16:16:40.0263 (UTC) FILETIME=[4AD08570:01CA0D43]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Fleming wrote:
> On Fri, Jul 10, 2009 at 03:40:54PM +0300, Adrian Hunter wrote:
>> Some hosts can accept only certain types of cards.
>> For example, an eMMC is MMC only and a uSD slot may
>> be SD only.  However the MMC card scanning logic
>> checks for all card types one by one.
>>
>> Add host capabilities to specify which card types
>> cannot be used, and amend the card scanning logic
>> to skip scanning for those types.
>>
> 
> I'm only nitpicking here, but I think that logic is a little inverted.
> By saying which cards cannot be used (as opposed to which cards can be
> used), we get conditionals like this,
> 
>>  
>> -	mmc_send_if_cond(host, host->ocr_avail);
>> +	if (!(host->caps & MMC_CAP_NOT_SDIO) || !(host->caps & MMC_CAP_NOT_SD))
>> +		mmc_send_if_cond(host, host->ocr_avail);
>> +
> 
> Whilst reviewing this patch it took my brain a few too many seconds to
> parse that as "if the host is capable of SDIO or SD".
> 
> 
>> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
>> index 0a60b02..e996967 100644
>> --- a/include/linux/mmc/host.h
>> +++ b/include/linux/mmc/host.h
>> @@ -150,6 +150,13 @@ struct mmc_host {
>>  #define MMC_CAP_DISABLE		(1 << 7)	/* Can the host be disabled */
>>  #define MMC_CAP_NONREMOVABLE	(1 << 8)	/* Nonremovable e.g. eMMC */
>>  #define MMC_CAP_WAIT_WHILE_BUSY	(1 << 9)	/* Waits while card is busy */
>> +#define MMC_CAP_NOT_SDIO	(1 << 10)	/* Card cannot be SDIO */
>> +#define MMC_CAP_NOT_SD		(1 << 11)	/* Card cannot be SD */
>> +#define MMC_CAP_NOT_MMC		(1 << 12)	/* Card cannot be MMC */
>> +
>> +#define MMC_CAP_SDIO_ONLY	(MMC_CAP_NOT_SD | MMC_CAP_NOT_MMC)
>> +#define MMC_CAP_SD_ONLY		(MMC_CAP_NOT_SDIO | MMC_CAP_NOT_MMC)
>> +#define MMC_CAP_MMC_ONLY	(MMC_CAP_NOT_SDIO | MMC_CAP_NOT_SD)
>>  
> 
> And by saying what capabilities a host supports, when we add new
> capabilities we don't have to modify existing code to say that it
> doesn't support the new capability.

If the capabilities are the other way around, then all existing drivers
must be changed.  On the other hand, the if statement can easily be
improved:

#define mmc_cap_mmc(host) (!((host)->caps & MMC_CAP_NOT_MMC))
#define mmc_cap_sd(host) (!((host)->caps & MMC_CAP_NOT_SD))
#define mmc_cap_sdio(host) (!((host)->caps & MMC_CAP_NOT_SDIO))

-	mmc_send_if_cond(host, host->ocr_avail);
+	if (mmc_cap_sdio(host) || mmc_cap_sd(host))
+		mmc_send_if_cond(host, host->ocr_avail);
+
