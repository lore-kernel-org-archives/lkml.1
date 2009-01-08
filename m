Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbZAHMHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbZAHMHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbZAHMHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:07:24 -0500
Received: from smtp.nokia.com ([192.100.122.233]:59364 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZAHMHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:07:22 -0500
Message-ID: <4965EEF7.2010400@nokia.com>
Date: Thu, 08 Jan 2009 14:17:59 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jean Pihet <jpihet@mvista.com>
CC: linux-arm-kernel@lists.arm.linux.org.uk, Tony Lindgren <tony@atomide.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Madhusudhan Chikkature <madhu.cr@ti.com>,
       David Brownell <david-b@pacbell.net>,
       "Jarkko Lavinen (NMP/Helsinki)" <jarkko.lavinen@nokia.com>
Subject: Re: [PATCH] OMAP: MMC: recover from transfer failures
References: <20081207213617.10456.43951.stgit@localhost> <200901071128.43937.jpihet@mvista.com> <4965C120.3010705@nokia.com> <200901081249.20152.jpihet@mvista.com>
In-Reply-To: <200901081249.20152.jpihet@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jan 2009 12:06:06.0395 (UTC) FILETIME=[7C23D0B0:01C97189]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Pihet wrote:
> Thanks for the suggestion, it works great (stress tested) and is a cleaner 
> fix.
> Here is a patch the latest linux-omap-2.6 tree. Is this OK?

OK by me.

> Regards,
> Jean
> 
> From d143f6b2e705aa4e9d2b032097fd1c82f8163262 Mon Sep 17 00:00:00 2001
> From: Jean Pihet <jpihet@mvista.com>
> Date: Thu, 8 Jan 2009 12:35:21 +0100
> Subject: [PATCH] OMAP: MMC: recover from transfer failures
> 
> Timeouts during a command that has a data phase can result in the
> next command issued after the command that failed not being processed,
> i.e. no interrupt ever occurs to indicate the command has completed.
> This failure can result in a deadlock.
> 
> This patch resets the data state machine to clear the error in
> case of a command timeout.
> 
> Tested on OMAP3430 chip and intensive MMC/SD device removal while
> transferring data.
> 
> Signed-off-by: Andy Lowe <alowe@mvista.com>
> Signed-off-by: Jean Pihet <jpihet@mvista.com>
> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index d5c1e9d..97150c0 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -464,8 +464,15 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
>                                 }
>                                 end_cmd = 1;
>                         }
> -                       if (host->data)
> +                       if (host->data) {
>                                 mmc_dma_cleanup(host);
> +                               OMAP_HSMMC_WRITE(host->base, SYSCTL,
> +                                       OMAP_HSMMC_READ(host->base,
> +                                                       SYSCTL) | SRD);
> +                               while (OMAP_HSMMC_READ(host->base,
> +                                               SYSCTL) & SRD)
> +                                       ;
> +                       }
>                 }
>                 if ((status & DATA_TIMEOUT) ||
>                         (status & DATA_CRC)) {
> --
> 1.5.4.4.21.gc4a6c
> 
> 
> 
> On Thursday 08 January 2009 10:02:24 Adrian Hunter wrote:
>> Why not do the reset in mmc_omap_irq() like the other resets?
>> e.g.
>>
>> static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
>> ...
>>                 if ((status & CMD_TIMEOUT) ||
>>                         (status & CMD_CRC)) {
>>                         if (host->cmd) {
>>                                 if (status & CMD_TIMEOUT) {
>>                                         OMAP_HSMMC_WRITE(host->base,
>> SYSCTL, OMAP_HSMMC_READ(host->base, SYSCTL) | SRC); while
>> (OMAP_HSMMC_READ(host->base, SYSCTL) & SRC) ;
>>
>>                                         host->cmd->error = -ETIMEDOUT;
>>                                 } else {
>>                                         host->cmd->error = -EILSEQ;
>>                                 }
>>                                 end_cmd = 1;
>>                         }
>> -                       if (host->data)
>> +                       if (host->data) {
>>                                 mmc_dma_cleanup(host);
>> +                               OMAP_HSMMC_WRITE(host->base, SYSCTL,
>> +                                       OMAP_HSMMC_READ(host->base,
>> +                                                       SYSCTL) | SRD);
>> +                               while (OMAP_HSMMC_READ(host->base,
>> +                                               SYSCTL) & SRD)
>> +                                       ;
>> +                       }
>>                 }
>>                 if ((status & DATA_TIMEOUT) ||
>>                         (status & DATA_CRC)) {
> 
> 

