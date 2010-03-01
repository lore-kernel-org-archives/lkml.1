Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab0CAFO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 00:14:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51252 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab0CAFO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 00:14:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CzCle6QMItddXtbu70bcc37aNsRFIUJN5unbgBI1Z15MDHQp1URnufoWVkf0xOyvrb
         7S3aLHIuc8gHHEGx5p+1bgk7bqSVeEGtVGY0a3SfOSBWBE/ZoIjW57txeIAXSfom3FaK
         GOgzMZtE1cBtHRp+ErsXOEweCMX7uiaShavGI=
MIME-Version: 1.0
In-Reply-To: <1267126777-21520-1-git-send-email-steve@digidescorp.com>
References: <1267126777-21520-1-git-send-email-steve@digidescorp.com>
Date: Sun, 28 Feb 2010 22:14:27 -0700
X-Google-Sender-Auth: b9f996274dec96de
Message-ID: <e9c3a7c21002282114w3de2806eoe2ecc8e0f9207d00@mail.gmail.com>
Subject: Re: [async_tx-next PATCH v2 2/2] fsldma: Fix cookie issues
From: Dan Williams <dan.j.williams@intel.com>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 12:39 PM, Steven J. Magnani
<steve@digidescorp.com> wrote:
> fsl_dma_update_completed_cookie() appears to calculate the last completed
> cookie incorrectly in the corner case where DMA on cookie 1 is in progress
> just following a cookie wrap.
>
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> --- a/drivers/dma/fsldma.c      2010-02-22 11:16:36.000000000 -0600
> +++ b/drivers/dma/fsldma.c      2010-02-22 11:08:41.000000000 -0600
> @@ -819,8 +819,11 @@ static void fsl_dma_update_completed_coo
>        desc = to_fsl_desc(chan->ld_running.prev);
>        if (dma_is_idle(chan))
>                cookie = desc->async_tx.cookie;
> -       else
> +       else {
>                cookie = desc->async_tx.cookie - 1;
> +               if (unlikely(cookie < DMA_MIN_COOKIE))
> +                       cookie = DMA_MAX_COOKIE;
> +       }
>
>        chan->completed_cookie = cookie;
>
> diff -uprN a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> --- a/include/linux/dmaengine.h 2010-02-22 11:18:11.000000000 -0600
> +++ b/include/linux/dmaengine.h 2010-02-22 11:18:30.000000000 -0600
> @@ -31,6 +31,8 @@
>  * if dma_cookie_t is >0 it's a DMA request cookie, <0 it's an error code
>  */
>  typedef s32 dma_cookie_t;
> +#define DMA_MIN_COOKIE 1
> +#define DMA_MAX_COOKIE ((1 << 31) - 1)
>

This patch introduces a new warning::

drivers/dma/fsldma.c:825: warning: integer overflow in expression

I'll fix this up to use INT_MAX instead.

--
Dan

powerpc-linux-gnu-gcc --version
powerpc-linux-gnu-gcc (Sourcery G++ Lite 4.2-50) 4.2.1
