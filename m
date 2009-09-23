Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbZIWIYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbZIWIYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbZIWIYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:24:31 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:40765 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbZIWIY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:24:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GppwVJ3kBwm28IXl6wrD9+kxyX7U+K22WjT52SFq5BVX5E6Lpg0b8g3ReUAWzgEAxQ
         h8oDjUYoliLwn6CPIEy7e3ag4rYe5Iin4KtQxtjTJ/DZpjoOCyhQ7uilDRnBzuSAKYYR
         beoxsMfzfObXm1qloGCorDfw3iND2Qd1KGZ/o=
MIME-Version: 1.0
In-Reply-To: <1253690346-17865-1-git-send-email-anuj.aggarwal@ti.com>
References: <1253690346-17865-1-git-send-email-anuj.aggarwal@ti.com>
Date: Wed, 23 Sep 2009 13:54:30 +0530
X-Google-Sender-Auth: fa2c9b0b34c6dfe9
Message-ID: <618f0c910909230124q773b90f6xd377e67a758e1237@mail.gmail.com>
Subject: Re: [PATCH] SDMA: Fixing bug in omap_dma_set_global_params()
From: Venkatraman S <svenkatr@ti.com>
To: Anuj Aggarwal <anuj.aggarwal@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 12:49 PM, Anuj Aggarwal <anuj.aggarwal@ti.com> wrote:
> Argument tparams was not being used to program
> global register GCR.HI_THREAD_RESERVED. This patch fixes the same.
>
> Signed-off-by: Anuj Aggarwal <anuj.aggarwal@ti.com>
> ---
>  arch/arm/plat-omap/dma.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
> index bf08634..7a7b6df 100644
> --- a/arch/arm/plat-omap/dma.c
> +++ b/arch/arm/plat-omap/dma.c
> @@ -829,10 +829,10 @@ EXPORT_SYMBOL(omap_free_dma);
>  *
>  * @param arb_rate
>  * @param max_fifo_depth
> - * @param tparams - Number of thereads to reserve : DMA_THREAD_RESERVE_NORM
> - *                                                 DMA_THREAD_RESERVE_ONET
> - *                                                 DMA_THREAD_RESERVE_TWOT
> - *                                                 DMA_THREAD_RESERVE_THREET
> + * @param tparams - Number of threads to reserve : DMA_THREAD_RESERVE_NORM
> + *                                                DMA_THREAD_RESERVE_ONET
> + *                                                DMA_THREAD_RESERVE_TWOT
> + *                                                DMA_THREAD_RESERVE_THREET
>  */
>  void
>  omap_dma_set_global_params(int arb_rate, int max_fifo_depth, int tparams)
> @@ -847,8 +847,9 @@ omap_dma_set_global_params(int arb_rate, int max_fifo_depth, int tparams)
>        if (arb_rate == 0)
>                arb_rate = 1;
>
> -       reg = (arb_rate & 0xff) << 16;
> -       reg |= (0xff & max_fifo_depth);
> +       reg = 0xff & max_fifo_depth;
> +       reg |= (0x3 & tparams) << 12;
> +       reg |= (arb_rate & 0xff) << 16;
>
>        dma_write(reg, GCR);
>  }

max_fifo_depth should not be set to zero. Perhaps it deserves a check
similar to arb_rate ?
