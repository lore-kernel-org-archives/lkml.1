Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZG3HQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZG3HQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 03:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZG3HQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 03:16:18 -0400
Received: from smtp.nokia.com ([192.100.122.233]:48902 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZG3HQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 03:16:17 -0400
Message-ID: <4A7148C3.2000005@nokia.com>
Date: Thu, 30 Jul 2009 10:16:19 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Madhusudhan <madhu.cr@ti.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       "'linux-omap Mailing List'" <linux-omap@vger.kernel.org>,
       "'Pierre Ossman'" <pierre@ossman.eu>,
       "Karpov Denis.2 (EXT-Teleca/Helsinki)" <ext-denis.2.karpov@nokia.com>,
       "'Matt Fleming'" <matt@console-pimps.org>,
       "'lkml'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 4/32] mmc: add ability to save power by powering off
 cards
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop> <20090728103904.2371.68231.sendpatchset@ahunter-laptop> <00a001ca10b1$e4d7e390$544ff780@am.dhcp.ti.com>
In-Reply-To: <00a001ca10b1$e4d7e390$544ff780@am.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2009 07:15:47.0822 (UTC) FILETIME=[8FB7C0E0:01CA10E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Madhusudhan wrote:
> 
>> -----Original Message-----
>> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
>> owner@vger.kernel.org] On Behalf Of Adrian Hunter
>> Sent: Tuesday, July 28, 2009 5:39 AM
>> To: Andrew Morton
>> Cc: Jarkko Lavinen; Adrian Hunter; linux-omap Mailing List; Pierre Ossman;
>> Denis Karpov; Matt Fleming; lkml
>> Subject: [PATCH V2 4/32] mmc: add ability to save power by powering off
>> cards
>>
>> From e6355578d082d94707c8fda1e1342c478019b5c8 Mon Sep 17 00:00:00 2001
>> From: Adrian Hunter <adrian.hunter@nokia.com>
>> Date: Mon, 11 May 2009 12:20:57 +0300
>> Subject: [PATCH] mmc: add ability to save power by powering off cards
>>
>> Power can be saved by powering off cards that are not
>> in use.  This is similar to suspend / resume except
>> it is under the control of the driver, and does not
>> require any power management support.  It can only
>> be used when the driver can monitor whether the card
>> is removed, otherwise it is unsafe.  This is possible
>> because, unlike suspend, the driver still receives
>> card detect and / or cover switch interrupts.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
>> ---
>>  drivers/mmc/core/core.c  |   34 ++++++++++++++++++++++++++++++++++
>>  drivers/mmc/core/core.h  |    2 ++
>>  drivers/mmc/core/mmc.c   |   11 +++++++++++
>>  drivers/mmc/core/sd.c    |   11 +++++++++++
>>  include/linux/mmc/host.h |    3 +++
>>  5 files changed, 61 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
>> index bab5015..39f7bd1 100644
>> --- a/drivers/mmc/core/core.c
>> +++ b/drivers/mmc/core/core.c
>> @@ -1145,6 +1145,40 @@ void mmc_stop_host(struct mmc_host *host)
>>  	mmc_power_off(host);
>>  }
>>
>> +void mmc_power_save_host(struct mmc_host *host)
>> +{
>> +	mmc_bus_get(host);
>> +
>> +	if (!host->bus_ops || host->bus_dead || !host->bus_ops-
>>> power_restore) {
>> +		mmc_bus_put(host);
>> +		return;
>> +	}
>> +
>> +	if (host->bus_ops->power_save)
>> +		host->bus_ops->power_save(host);
>> +
>> +	mmc_bus_put(host);
>> +
>> +	mmc_power_off(host);
>> +}
>> +EXPORT_SYMBOL(mmc_power_save_host);
>> +
>> +void mmc_power_restore_host(struct mmc_host *host)
>> +{
>> +	mmc_bus_get(host);
>> +
>> +	if (!host->bus_ops || host->bus_dead || !host->bus_ops-
>>> power_restore) {
>> +		mmc_bus_put(host);
>> +		return;
>> +	}
>> +
>> +	mmc_power_up(host);
>> +	host->bus_ops->power_restore(host);
>> +
>> +	mmc_bus_put(host);
>> +}
>> +EXPORT_SYMBOL(mmc_power_restore_host);
>> +
> 
> Who calls these exported functions " mmc_power_save_host" and "
> mmc_power_restore_host"? 

The present design has the host driver calling them i.e. for us it
is omap_hsmmc.  See the "support for deeper power saving states"
patch.


