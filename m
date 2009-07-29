Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbZG2VMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbZG2VMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZG2VMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:12:48 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:54991 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbZG2VMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UkbR3uyaSwVPnxTIBJlSAz0qD9kmrk9TwJl7fn0xsepeyTOqKGDuZrv/UCp36W6A85
         iZQk2lcDRxR7FDYXWRdDMfOOjhTxD21BCfesXxSYFj+YJxHylQi5CgAAoaQ+KsrfFdHO
         CJpT6hV6MdhEMij2oJj78smdfVygsieoGoqQ0=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0907280937000.4943@axis700.grange>
References: <Pine.LNX.4.64.0907280937000.4943@axis700.grange>
Date: Wed, 29 Jul 2009 23:12:45 +0200
Message-ID: <74d0deb30907291412v4227d6a8gb1bfd312c4282cf0@mail.gmail.com>
Subject: Re: [PATCH] tmio_mmc: Optionally support using platform clock
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ian Molton <ian@mnementh.co.uk>, linux-kernel@vger.kernel.org,
       Magnus Damm <damm@opensource.se>, akpm@linux-foundation.org,
       Matt Fleming <matt@console-pimps.org>,
       Philip Langdale <philipl@overt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 9:51 AM, Guennadi
Liakhovetski<g.liakhovetski@gmx.de> wrote:
> If the platform device has a clock associated with the tmio-mmc device,
> use it.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Magnus Damm <damm@opensource.se>
> ---
>
> Depends (at least logically) on
> http://marc.info/?l=linux-kernel&m=124782904228865&w=2
>
> Sorry if I forgot anyone who volunteered to help out with MMC patches.
>
>  drivers/mmc/host/tmio_mmc.c |   21 +++++++++++++++++++++
>  drivers/mmc/host/tmio_mmc.h |    3 +++
>  include/linux/mfd/tmio.h    |    1 +
>  3 files changed, 25 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
> index c246191..2a01572 100644
> --- a/drivers/mmc/host/tmio_mmc.c
> +++ b/drivers/mmc/host/tmio_mmc.c
> @@ -32,6 +32,7 @@
>  #include <linux/mmc/host.h>
>  #include <linux/mfd/core.h>
>  #include <linux/mfd/tmio.h>
> +#include <linux/clk.h>
>
>  #include "tmio_mmc.h"
>
> @@ -57,10 +58,18 @@ static void tmio_mmc_clk_stop(struct tmio_mmc_host *host)
>        sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, ~0x0100 &
>                sd_ctrl_read16(host, CTL_SD_CARD_CLK_CTL));
>        msleep(10);
> +       if (!IS_ERR(host->clk) && host->clk_is_running) {
> +               clk_disable(host->clk);
> +               host->clk_is_running = false;
> +       }
>  }
>
>  static void tmio_mmc_clk_start(struct tmio_mmc_host *host)
>  {
> +       if (!IS_ERR(host->clk) && !host->clk_is_running &&
> +           !clk_enable(host->clk))
> +               host->clk_is_running = true;
> +
>        sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, 0x0100 |
>                sd_ctrl_read16(host, CTL_SD_CARD_CLK_CTL));
>        msleep(10);
> @@ -567,6 +576,11 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
>                        goto unmap_cnf;
>        }
>
> +       host->clk = clk_get(&dev->dev, pdata->clk_name);

As long as we are going to ignore the error code, I think the rest of
the patch would be easier on the eyes with
          if (IS_ERR(host->clk))
                  host->clk = NULL;
inserted here.

> +       if (!IS_ERR(host->clk) && !clk_enable(host->clk))
> +               host->clk_is_running = true;
> +
>        /* Enable the MMC/SD Control registers */
>        sd_config_write16(host, CNF_CMD, SDCREN);
>        sd_config_write32(host, CNF_CTL_BASE,
> @@ -608,6 +622,11 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
>        return 0;
>
>  unmap_cnf:
> +       if (!IS_ERR(host->clk)) {
> +               clk_disable(host->clk);
> +               host->clk_is_running = false;
> +               clk_put(host->clk);
> +       }
>        if (host->cnf)
>                iounmap(host->cnf);
>  unmap_ctl:
> @@ -632,6 +651,8 @@ static int __devexit tmio_mmc_remove(struct platform_device *dev)
>                if (host->cnf)
>                        iounmap(host->cnf);
>                mmc_free_host(mmc);
> +               if (!IS_ERR(host->clk))
> +                       clk_put(host->clk);
>        }
>
>        return 0;
> diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
> index 45f06aa..a76d237 100644
> --- a/drivers/mmc/host/tmio_mmc.h
> +++ b/drivers/mmc/host/tmio_mmc.h
> @@ -108,6 +108,7 @@
>                sd_ctrl_write32((host), CTL_STATUS, mask); \
>        } while (0)
>
> +struct clk;
>
>  struct tmio_mmc_host {
>        void __iomem *cnf;
> @@ -117,6 +118,8 @@ struct tmio_mmc_host {
>        struct mmc_request      *mrq;
>        struct mmc_data         *data;
>        struct mmc_host         *mmc;
> +       struct clk              *clk;
> +       bool                    clk_is_running;
>        int                     irq;
>
>        /* pio related stuff */
> diff --git a/include/linux/mfd/tmio.h b/include/linux/mfd/tmio.h
> index 6b9c5d0..e405895 100644
> --- a/include/linux/mfd/tmio.h
> +++ b/include/linux/mfd/tmio.h
> @@ -23,6 +23,7 @@
>  */
>  struct tmio_mmc_data {
>        const unsigned int              hclk;
> +       const char                      *clk_name;
>  };
>
>  /*
> --
> 1.6.2.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Also I quickly tested this on ASIC3 and so far the device hangs if I
remove the code that enables hclk already in mfd_cell->enable (in
asic3.c). I'll try to find out why that happens.

regards
Philipp
