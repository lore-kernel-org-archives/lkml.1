Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZETK4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZETK4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZETK4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:56:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:4056 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbZETK4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:56:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,221,1241420400"; 
   d="scan'208";a="692048493"
From: "Li, Jiebing" <jiebing.li@intel.com>
To: Pierre Ossman <pierre@ossman.eu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Arjan van de Ven <arjan@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 20 May 2009 18:55:43 +0800
Subject: RE: [PATCH 2/2] MMC: MMC/SD/CE-ATA/SDIO driver for Intel Moorestown
  platform
Thread-Topic: [PATCH 2/2] MMC: MMC/SD/CE-ATA/SDIO driver for Intel
 Moorestown  platform
Thread-Index: AcnRnxDoXInqwnIMS3++dVI6ZwL+5QHme0DQ
Message-ID: <95608CFE3D0C064B8468DB61F8403BE036C16F33FB@PDSMSX501.ccr.corp.intel.com>
References: <95608CFE3D0C064B8468DB61F8403BE029D298B1F7@PDSMSX501.ccr.corp.intel.com>
	<95608CFE3D0C064B8468DB61F8403BE029D298B1FF@PDSMSX501.ccr.corp.intel.com>
 <20090510204214.2c0ce736@mjolnir.ossman.eu>
In-Reply-To: <20090510204214.2c0ce736@mjolnir.ossman.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Thanks a lot for your comments and instructions! I will modify the code, prepare for the use cases and re-submit the patches in next days.


Rgds,
Jiebing 

-----Original Message-----
From: Pierre Ossman [mailto:pierre@ossman.eu] 
Sent: Monday, May 11, 2009 2:42 AM
To: Li, Jiebing
Cc: linux-kernel@vger.kernel.org; Johnson, Charles F; Zhu, Daniel; Yuan, Hang; Pasrija, Geeta; Li, Jiebing
Subject: Re: [PATCH 2/2] MMC: MMC/SD/CE-ATA/SDIO driver for Intel Moorestown platform

On Thu, 30 Apr 2009 17:19:06 +0800
"Li, Jiebing" <jiebing.li@intel.com> wrote:

> 
> This patch enables support of SDIO bus driver suspend/resume operation and supply sysfs interface for user
> to call suspend/resume selectively.Remind that this function should work together with SDIO device driver's
> suspend/resume function.
> 

As Matthew asked, what's the use case?

> And Moorestown's specific code is added into this patch to enable the second SDIO slot of the host controller.
> 

Again, stop mixing unrelated things in the same patch.

> @@ -452,3 +828,84 @@ err:
>         return err;
>  }
> 
> +/*
> + * warn device driver and perform a SDIO device reset.
> + * Assume that device driver knows hot to handle resets.
> + */
> +int sdio_reset_device(struct mmc_card *card)
> +{

Use case?

> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index b4cf691..0c9d2eb 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -44,6 +44,14 @@ config MMC_SDHCI_IO_ACCESSORS
>           This is silent Kconfig symbol that is selected by the drivers that
>           need to overwrite SDHCI IO memory accessors.
> 
> +config MMC_SDHCI_MRST_SDIO1
> +       bool
> +       depends on MMC_SDHCI
> +       help
> +         This enables Moorestown SD host controller's 2nd SDIO slot.
> +
> +         If unsure, say N.
> +

Detect this at runtime.

> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index a2804f1..4d4ad6d 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -914,6 +914,17 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
>         if (cmd->data)
>                 flags |= SDHCI_CMD_DATA;
> 
> +#ifdef CONFIG_MMC_SDHCI_MRST_SDIO1
> +       if (host->quirks & SDHCI_QUIRK_MRST_RESTRICTION) {
> +               u16 clk;
> +
> +               clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
> +
> +               clk |= SDHCI_CLOCK_CARD_EN;
> +               sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
> +       }
> +#endif
> +
>         sdhci_writew(host, SDHCI_MAKE_CMD(cmd->opcode, flags), SDHCI_COMMAND);
>  }
> 

Huh? Is this some kind of multiplexed nonsense?

> diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
> index fa87b8b..50be698 100644
> --- a/drivers/mmc/host/sdhci.h
> +++ b/drivers/mmc/host/sdhci.h
> @@ -227,6 +227,8 @@ struct sdhci_host {
>  #define SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET           (1<<19)
>  /* Controller has to be forced to use block size of 2048 bytes */
>  #define SDHCI_QUIRK_FORCE_BLK_SZ_2048                  (1<<20)
> +/* Controller of Moorestown specific restriction */
> +#define SDHCI_QUIRK_MRST_RESTRICTION                   (1<<21)
> 

No. Quirks should be defined in a way that allows reuse.

-- 
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
