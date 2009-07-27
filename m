Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbZG0I1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbZG0I1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 04:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbZG0I1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 04:27:47 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:51842 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbZG0I1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 04:27:46 -0400
Date: Mon, 27 Jul 2009 09:27:21 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       "Karpov Denis.2 (EXT-Teleca/Helsinki)" <ext-denis.2.karpov@nokia.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 32/32] ARM: OMAP: RX51: set MMC capabilities and
	power-saving flag
Message-ID: <20090727082721.GG12665@console-pimps.org>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower> <20090710124353.1262.22788.sendpatchset@ahunter-tower> <20090725235329.GE12665@console-pimps.org> <4A6D5E40.7030608@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6D5E40.7030608@nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 10:58:56AM +0300, Adrian Hunter wrote:
> Matt Fleming wrote:
>> On Fri, Jul 10, 2009 at 03:43:53PM +0300, Adrian Hunter wrote:
>>> >From 3865867159f25cf706480236f6d4f0e4adde5dac Mon Sep 17 00:00:00 2001
>>> From: Adrian Hunter <adrian.hunter@nokia.com>
>>> Date: Fri, 10 Jul 2009 10:32:44 +0300
>>> Subject: [PATCH] ARM: OMAP: RX51: set MMC capabilities and power-saving flag
>>>
>>> Specify MMC capabilities and set the power-saving flag
>>> for RX51.
>>>
>>
>> After the changes to [PATCH 7/32], this becomes,
>
> I think this will leave every other board that uses omap_hsmmc
> without any card caps.
>

Doh. You're right, good catch!

> What about adding something like this:
>
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 8900bae..f2548f1 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -1720,6 +1720,11 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
> 		mmc->caps |= MMC_CAP_4_BIT_DATA;
>
> 	mmc->caps |= mmc_slot(host).caps;
> +	/* If no card caps specified then assume them all */
> +	if (!((mmc->caps & MMC_CAP_SD) ||
> +	      (mmc->caps & MMC_CAP_MMC) ||
> +	      (mmc->caps & MMC_CAP_SDIO)))
> +		mmc->caps |= MMC_CAP_SD & MMC_CAP_MMC & MMC_CAP_SDIO;
>
> 	omap_hsmmc_conf_bus_power(host);
>

Those & should be |

	/* If no card caps specified then assume them all */
	if (!((mmc->caps & MMC_CAP_SD) ||
	      (mmc->caps & MMC_CAP_MMC) ||
	      (mmc->caps & MMC_CAP_SDIO)))
	        mmc->caps |= MMC_CAP_SD | MMC_CAP_MMC | MMC_CAP_SDIO;

or more compactly,

	/* If no card caps specified then assume them all */
	if (!(mmc->caps & (MMC_CAP_SD | MMC_CAP_SDIO | MMC_CAP_MMC)))
		mmc->caps |= MMC_CAP_SD | MMC_CAP_MMC | MMC_CAP_SDIO;

	
