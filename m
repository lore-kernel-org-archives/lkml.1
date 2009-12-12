Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbZLLHlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbZLLHlO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 02:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZLLHlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 02:41:13 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:33726 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbZLLHlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 02:41:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=j6A3XheaFixcBYxnLYnKyywUPiKpSxG2pZBJd/JsVy/0pLEEqxIh15g+8ynBPi82P5
         gpuKNnahj6rCj8ZsuQLBwuTWfqDyolRwNkTKGHxxkLnebCbyUJn6ccFJqUp/jmZL/8ya
         RXRyqt+YJcXP/5zUXYJq8r0CVYn0DfVCb1TQs=
MIME-Version: 1.0
In-Reply-To: <1260598486-12623-1-git-send-email-ngupta@vflare.org>
References: <1260598486-12623-1-git-send-email-ngupta@vflare.org>
Date: Sat, 12 Dec 2009 09:41:18 +0200
X-Google-Sender-Auth: ae7f0402ed09af08
Message-ID: <84144f020912112341jc7fdc1eqac719578e2aa746b@mail.gmail.com>
Subject: Re: [PATCH] ramzswap: remove ARM specific d-cache hack
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 8:14 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> Remove d-cache hack in ramzswap driver that was needed
> to workaround a bug in ARM version of update_mmu_cache()
> which caused stale data in d-cache to be transferred to
> userspace. This bug was fixed by git commit:
>        787b2faadc4356b6c2c71feb42fb944fece9a12f
> This also brings down one entry in TODO file.
>
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  drivers/staging/ramzswap/TODO           |    1 -
>  drivers/staging/ramzswap/ramzswap_drv.c |   28 +++-------------------------
>  2 files changed, 3 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/staging/ramzswap/TODO b/drivers/staging/ramzswap/TODO
> index bac40d6..8d64e28 100644
> --- a/drivers/staging/ramzswap/TODO
> +++ b/drivers/staging/ramzswap/TODO
> @@ -1,6 +1,5 @@
>  TODO:
>        - Add support for swap notifiers
> -       - Remove CONFIG_ARM hack
>
>  Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
>  Nitin Gupta <ngupta@vflare.org>
> diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
> index b839f05..989fac5 100644
> --- a/drivers/staging/ramzswap/ramzswap_drv.c
> +++ b/drivers/staging/ramzswap/ramzswap_drv.c
> @@ -222,28 +222,6 @@ out:
>        return ret;
>  }
>
> -static void ramzswap_flush_dcache_page(struct page *page)
> -{
> -#ifdef CONFIG_ARM
> -       int flag = 0;
> -       /*
> -        * Ugly hack to get flush_dcache_page() work on ARM.
> -        * page_mapping(page) == NULL after clearing this swap cache flag.
> -        * Without clearing this flag, flush_dcache_page() will simply set
> -        * "PG_dcache_dirty" bit and return.
> -        */
> -       if (PageSwapCache(page)) {
> -               flag = 1;
> -               ClearPageSwapCache(page);
> -       }
> -#endif
> -       flush_dcache_page(page);
> -#ifdef CONFIG_ARM
> -       if (flag)
> -               SetPageSwapCache(page);
> -#endif
> -}
> -
>  void ramzswap_ioctl_get_stats(struct ramzswap *rzs,
>                        struct ramzswap_ioctl_stats *s)
>  {
> @@ -655,7 +633,7 @@ static int handle_zero_page(struct bio *bio)
>        memset(user_mem, 0, PAGE_SIZE);
>        kunmap_atomic(user_mem, KM_USER0);
>
> -       ramzswap_flush_dcache_page(page);
> +       flush_dcache_page(page);
>
>        set_bit(BIO_UPTODATE, &bio->bi_flags);
>        bio_endio(bio, 0);
> @@ -679,7 +657,7 @@ static int handle_uncompressed_page(struct ramzswap *rzs, struct bio *bio)
>        kunmap_atomic(user_mem, KM_USER0);
>        kunmap_atomic(cmem, KM_USER1);
>
> -       ramzswap_flush_dcache_page(page);
> +       flush_dcache_page(page);
>
>        set_bit(BIO_UPTODATE, &bio->bi_flags);
>        bio_endio(bio, 0);
> @@ -779,7 +757,7 @@ static int ramzswap_read(struct ramzswap *rzs, struct bio *bio)
>                goto out;
>        }
>
> -       ramzswap_flush_dcache_page(page);
> +       flush_dcache_page(page);
>
>        set_bit(BIO_UPTODATE, &bio->bi_flags);
>        bio_endio(bio, 0);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
