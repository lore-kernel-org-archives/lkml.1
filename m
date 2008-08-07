Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYHGDxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYHGDxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 23:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbYHGDxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 23:53:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:38113 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYHGDxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 23:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d2Q1rJlq+bTtGusgY0C9JIuWGJOu4w3KP2FuRbBHYrkh5r45Krl49iq/rpXs0NMdif
         f4BxJs56jzHMQTKzzrQgp3XarvgMvyYl9XTgDR78K/a1ClIiJJLBUEN/AqH+vn1FlLNO
         scoYbaxyxqpTrf4F8aost/0F6JCvyR5cpWq1g=
Message-ID: <f17812d70808062053v76d93925l716749f5347ec972@mail.gmail.com>
Date: Thu, 7 Aug 2008 11:53:43 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Marc Zyngier" <maz@misterjones.org>
Subject: Re: [PATCH 3/5] [PCMCIA] Add support for platform dependant quirks
Cc: linux-kernel@vger.kernel.org,
       "Amit Walambe" <amit.walambe@eurotech-ltd.co.uk>,
       "Dominik Brodowski" <linux@dominikbrodowski.net>,
       "Marc Zyngier" <marc.zyngier@altran.com>
In-Reply-To: <b6f70421a31e59e19a0aaa79d068fa34876e60b7.1218018637.git.marc.zyngier@altran.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <37f79c8da83c915c5ecc1d81cad9f4f5ae3c2b4a.1218018636.git.marc.zyngier@altran.com>
	 <b6f70421a31e59e19a0aaa79d068fa34876e60b7.1218018637.git.marc.zyngier@altran.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You may want to use

    if (machine_is_viper())
        do_some_quirks();

instead of modifying the generic ops structure.

On Wed, Aug 6, 2008 at 9:19 PM, Marc Zyngier <maz@misterjones.org> wrote:
> Some platforms, namely the Arcom/Eurotech Viper, need some extra care
> to run (on this board, the PC104 connector is actually wired to the
> second PCMCIA slot, and needs to be powered on despite not being managed
> by the PCMCIA code...).
>
> Add a quirks field to the pcmcia_low_level structure that the SOC
> dependant code can inspect.
>
> Introduce a PXA2XX_QUIRK_NEEDS_MECR_NOS that can be used by the offending
> board.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@altran.com>
> ---
>  drivers/pcmcia/pxa2xx_base.c |   20 ++++++++++++++++++--
>  drivers/pcmcia/pxa2xx_base.h |    7 +++++++
>  drivers/pcmcia/soc_common.h  |    2 ++
>  3 files changed, 27 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pcmcia/pxa2xx_base.c b/drivers/pcmcia/pxa2xx_base.c
> index ccfdf19..9e61f21 100644
> --- a/drivers/pcmcia/pxa2xx_base.c
> +++ b/drivers/pcmcia/pxa2xx_base.c
> @@ -195,7 +195,7 @@ int __pxa2xx_drv_pcmcia_probe(struct device *dev)
>                MECR |= MECR_CIT;
>
>                /* Set MECR:NOS (Number Of Sockets) */
> -               if (nr > 1)
> +               if (nr > 1 || (ops->quirks & PXA2XX_QUIRK_NEEDS_MECR_NOS))
>                        MECR |= MECR_NOS;
>                else
>                        MECR &= ~MECR_NOS;
> @@ -226,7 +226,23 @@ static int pxa2xx_drv_pcmcia_resume(struct platform_device *dev)
>        struct pcmcia_low_level *ops = dev->dev.platform_data;
>        int nr = ops ? ops->nr : 0;
>
> -       MECR = nr > 1 ? MECR_CIT | MECR_NOS : (nr > 0 ? MECR_CIT : 0);
> +       if (nr > 0) {
> +               u32 quirks = ops ? ops->quirks : 0;
> +               int v;
> +
> +               /*
> +                * We have at least one socket, so set MECR:CIT
> +                * (Card Is There)
> +                */
> +               v = MECR_CIT;
> +
> +               /* Set MECR:NOS (Number Of Sockets) */
> +               if (nr > 1 || (quirks & PXA2XX_QUIRK_NEEDS_MECR_NOS))
> +                       v |= MECR_NOS;
> +
> +               MECR = v;
> +       } else
> +               MECR = 0;
>
>        return pcmcia_socket_dev_resume(&dev->dev);
>  }
> diff --git a/drivers/pcmcia/pxa2xx_base.h b/drivers/pcmcia/pxa2xx_base.h
> index 235d681..956ee9d 100644
> --- a/drivers/pcmcia/pxa2xx_base.h
> +++ b/drivers/pcmcia/pxa2xx_base.h
> @@ -1,3 +1,10 @@
> +#ifndef PXA2XX_BASE
> +#define PXA2XX_BASE
> +
> +#define PXA2XX_QUIRK_NEEDS_MECR_NOS            (1 << 0)
> +
>  /* temporary measure */
>  extern int __pxa2xx_drv_pcmcia_probe(struct device *);
>
> +#endif
> +
> diff --git a/drivers/pcmcia/soc_common.h b/drivers/pcmcia/soc_common.h
> index 91ef6a0..9e288fc 100644
> --- a/drivers/pcmcia/soc_common.h
> +++ b/drivers/pcmcia/soc_common.h
> @@ -76,6 +76,8 @@ struct pcmcia_low_level {
>        int first;
>        /* nr of sockets */
>        int nr;
> +       /* Quirks required by this system, SOC dependant */
> +       u32 quirks;
>
>        int (*hw_init)(struct soc_pcmcia_socket *);
>        void (*hw_shutdown)(struct soc_pcmcia_socket *);
> --
> 1.5.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Cheers
- eric
