Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbYHYNfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbYHYNfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 09:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbYHYNfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 09:35:10 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:45604 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbYHYNfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 09:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mFG4gkZOOlkiL0spFwUdbk09/ulh+LeBWvp8l/r9ecbB/FI67rRnvRRhgSC2PPbY4G
         8HfPbvUhKvjzohzOfk4h2SKDSiL4wh8cpe8Dg8VJGMbxDwTiuCHh4oTLFNDBND6erfEB
         +SA4kyjJsoI1YcmLhtxFDoktS2VDFH+DYaakM=
Message-ID: <74d0deb30808250635p670d7fd8vdf75ea5111ad0077@mail.gmail.com>
Date: Mon, 25 Aug 2008 15:35:06 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Felipe Balbi" <me@felipebalbi.com>
Subject: Re: [PATCH 2/4] USB: OTG: Make otg_get_transceiver() and otg_set_transceiver() generic
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       david-b@pacbell.net, tony@atomide.com
In-Reply-To: <1200753446-9378-3-git-send-email-me@felipebalbi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200753446-9378-1-git-send-email-me@felipebalbi.com>
	 <1200753446-9378-2-git-send-email-me@felipebalbi.com>
	 <1200753446-9378-3-git-send-email-me@felipebalbi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jan 19, 2008 at 4:37 PM, Felipe Balbi <me@felipebalbi.com> wrote:
> From: Tony Lidgren <tony@atomide.com>
>
> Move otg_get_transceiver() and otg_set_transceiver() from omap specific code
> to common otg.c so other upcoming drivers can share them.
>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Felipe Balbi <me@felipebalbi.com>
> ---
>  arch/arm/plat-omap/usb.c |   32 --------------------------------
>  drivers/usb/core/otg.c   |   20 ++++++++++++++++++++
>  2 files changed, 20 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/usb/core/otg.c b/drivers/usb/core/otg.c
> index 11967c0..531afa6 100644
> --- a/drivers/usb/core/otg.c
> +++ b/drivers/usb/core/otg.c
> @@ -14,9 +14,29 @@
>  #include <linux/byteorder/generic.h>
>  #include <linux/gfp.h>
>  #include <linux/usb.h>
> +#include <linux/usb/otg.h>
>
>  #include "otg_whitelist.h"
>
> +static struct otg_transceiver *xceiv;
> +
> +int otg_set_transceiver(struct otg_transceiver *x)
> +{
> +       if (xceiv && x)
> +               return -EBUSY;
> +       xceiv = x;
> +       return 0;
> +}
> +EXPORT_SYMBOL(otg_set_transceiver);
> +
> +struct otg_transceiver *otg_get_transceiver(void)
> +{
> +       if (xceiv)
> +               get_device(xceiv->dev);
> +       return xceiv;
> +}
> +EXPORT_SYMBOL(otg_get_transceiver);
> +
>  #ifdef CONFIG_USB_OTG_WHITELIST
>
>  /*
> diff --git a/arch/arm/plat-omap/usb.c b/arch/arm/plat-omap/usb.c
> index a5aedf9..5cd39fa 100644
> --- a/arch/arm/plat-omap/usb.c
> +++ b/arch/arm/plat-omap/usb.c
> @@ -76,38 +76,6 @@
>
>  /*-------------------------------------------------------------------------*/
>
> -#ifdef CONFIG_ARCH_OMAP_OTG
> -
> -static struct otg_transceiver *xceiv;
> -
> -/**
> - * otg_get_transceiver - find the (single) OTG transceiver driver
> - *
> - * Returns the transceiver driver, after getting a refcount to it; or
> - * null if there is no such transceiver.  The caller is responsible for
> - * releasing that count.
> - */
> -struct otg_transceiver *otg_get_transceiver(void)
> -{
> -       if (xceiv)
> -               get_device(xceiv->dev);
> -       return xceiv;
> -}
> -EXPORT_SYMBOL(otg_get_transceiver);
> -
> -int otg_set_transceiver(struct otg_transceiver *x)
> -{
> -       if (xceiv && x)
> -               return -EBUSY;
> -       xceiv = x;
> -       return 0;
> -}
> -EXPORT_SYMBOL(otg_set_transceiver);
> -
> -#endif
> -
> -/*-------------------------------------------------------------------------*/
> -
>  #if defined(CONFIG_ARCH_OMAP_OTG) || defined(CONFIG_ARCH_OMAP15XX)
>
>  static u32 __init omap_usb0_init(unsigned nwires, unsigned is_device)
> --
> 1.5.4.rc3.24.gb53139
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

what is the status of this patch? I guess moving
otg_get/set_transceiver into usb core like this (and adding
otg_put_transceiver) is better than duplicating this code for PXA and
other architectures?

regards
Philipp
