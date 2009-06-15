Return-Path: <linux-kernel-owner+w=401wt.eu-S1760611AbZFOMZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611AbZFOMZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbZFOMZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:25:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46283 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757683AbZFOMZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:25:07 -0400
Date: Mon, 15 Jun 2009 13:26:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Li, Jiebing" <jiebing.li@intel.com>
Cc: Pierre Ossman <pierre@ossman.eu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>,
       "Zhu, Daniel" <daniel.zhu@intel.com>,
       "Yuan, Hang" <hang.yuan@intel.com>,
       "Li, Jiebing" <jiebing.li@intel.com>
Subject: Re: [PATCH 1/1] MMC: SDIO driver for Intel Moorestown  platform
Message-ID: <20090615132622.45fce509@lxorguk.ukuu.org.uk>
In-Reply-To: <95608CFE3D0C064B8468DB61F8403BE036C19F9C0E@PDSMSX501.ccr.corp.intel.com>
References: <95608CFE3D0C064B8468DB61F8403BE036C19F9C0E@PDSMSX501.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +       /*
> +        * Read the common CIS tuples.
> +        */
> +       err = sdio_read_cccr(card);
> +       if (err)
> +               goto remove;
> +
> +#ifdef CONFIG_MRST_MMC_WR
> +       /* restricting to 24MHz for Langwell A0 */
> +       if (card->cis.max_dtr > 24000000)
> +               card->cis.max_dtr = 24000000;
> +#endif

What if you have an SDIO device on a PCI card plugged into the system ?
You need some kind of card specific "fix up" call as a lot of other
drivers have I suspect ?


>
>         for (i = 0;i < host->card->sdio_funcs;i++) {
>                 if (host->card->sdio_func[i]) {
> +#ifdef CONFIG_SDIO_SUSPEND
> +                       sdio_remove_sysfs_file(host->card->sdio_func[i]);
> +#endif

Would be cleaner to always define sdio_remove_sysfs_file() and arrange in
the header files that this is

#define sdio_remove_sysfs_file(x)  do {} while (0)

>  static const struct mmc_bus_ops mmc_sdio_ops = {
>         .remove = mmc_sdio_remove,
>         .detect = mmc_sdio_detect,
> +       .suspend = mmc_sdio_suspend,
> +       .resume = mmc_sdio_resume,
>  };

You always expose suspend/resume yet you ifdef other stuff ?

> 
> @@ -323,6 +722,10 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
>                 goto err;
>         }
> 
> +#ifdef CONFIG_SDIO_SUSPEND
> +       mutex_init(&card->pm_mutex);
> +#endif

Again this and the create_sysfs_file one could be hidden more nicely in
the header

>
