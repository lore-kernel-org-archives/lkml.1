Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbYFRX5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbYFRX5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 19:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbYFRX5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 19:57:41 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:29330 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbYFRX5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 19:57:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BOb1FXQWwwx8FLMqK5fbLMANPv/nSXvzkHONjzHaAMFfcJi5A9awcWhXj1ol4zT6pN
         Gj7YTF17gPDd8EBg4slekNSuyOzO1sEwYS7tRdW7qlfK2LiUU2zzauPzMrXd5ZJYMjfg
         Ffs59TKhMTEN1a9qTULK51GISPuGDeP8Ayvx4=
Message-ID: <21d7e9970806181657l79fa4e43oc42f23a18a33c4ee@mail.gmail.com>
Date: Thu, 19 Jun 2008 09:57:38 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: agp: two-stage page destruction issue
Cc: "Dave Airlie" <airlied@linux.ie>, linux-kernel@vger.kernel.org
In-Reply-To: <4858E330.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4858E330.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 6:28 PM, Jan Beulich <jbeulich@novell.com> wrote:
> Dave,
>
> besides it apparently being useful only in 2.6.24 (the changes in 2.6.25
> really mean that it could be converted back to a single-stage mechanism),
> I'm seeing an issue in Xen Dom0 kernels, which is caused by the calling
> of gart_to_virt() in the second stage invocations of the destroy function.
> I think that besides this being a real issue with Xen (where
> unmap_page_from_agp() is not just a page table attribute change), this
> also is invalid from a theoretical perspective: One should not assume that
> gart_to_virt() is still valid after unmapping a page. So minimally (keeping
> the 2-stage mechanism) a patch like the one below would be needed.
>

Looks good to me, its the simpler change for 2.6.26 at this point.

Dave.

> Jan
>
> --- a/drivers/char/agp/backend.c
> +++ b/drivers/char/agp/backend.c
> @@ -188,10 +188,10 @@ static int agp_backend_initialize(struct
>
>  err_out:
>        if (bridge->driver->needs_scratch_page) {
> -               bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
> -                                                AGP_PAGE_DESTROY_UNMAP);
> -               bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
> -                                                AGP_PAGE_DESTROY_FREE);
> +               void *va = gart_to_virt(bridge->scratch_page_real);
> +
> +               bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
> +               bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
>        }
>        if (got_gatt)
>                bridge->driver->free_gatt_table(bridge);
> @@ -215,10 +215,10 @@ static void agp_backend_cleanup(struct a
>
>        if (bridge->driver->agp_destroy_page &&
>            bridge->driver->needs_scratch_page) {
> -               bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
> -                                                AGP_PAGE_DESTROY_UNMAP);
> -               bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
> -                                                AGP_PAGE_DESTROY_FREE);
> +               void *va = gart_to_virt(bridge->scratch_page_real);
> +
> +               bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
> +               bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
>        }
>  }
>
> --- a/drivers/char/agp/generic.c
> +++ b/drivers/char/agp/generic.c
> @@ -202,10 +202,13 @@ void agp_free_memory(struct agp_memory *
>        }
>        if (curr->page_count != 0) {
>                for (i = 0; i < curr->page_count; i++) {
> -                       curr->bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[i]), AGP_PAGE_DESTROY_UNMAP);
> +                       curr->memory[i] = (unsigned long)gart_to_virt(curr->memory[i]);
> +                       curr->bridge->driver->agp_destroy_page((void *)curr->memory[i],
> +                                                              AGP_PAGE_DESTROY_UNMAP);
>                }
>                for (i = 0; i < curr->page_count; i++) {
> -                       curr->bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[i]), AGP_PAGE_DESTROY_FREE);
> +                       curr->bridge->driver->agp_destroy_page((void *)curr->memory[i],
> +                                                              AGP_PAGE_DESTROY_FREE);
>                }
>        }
>        agp_free_key(curr->key);
> --- a/drivers/char/agp/intel-agp.c
> +++ b/drivers/char/agp/intel-agp.c
> @@ -428,9 +428,11 @@ static void intel_i810_free_by_type(stru
>                if (curr->page_count == 4)
>                        i8xx_destroy_pages(gart_to_virt(curr->memory[0]));
>                else {
> -                       agp_bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[0]),
> +                       void *va = gart_to_virt(curr->memory[0]);
> +
> +                       agp_bridge->driver->agp_destroy_page(va,
>                                                             AGP_PAGE_DESTROY_UNMAP);
> -                       agp_bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[0]),
> +                       agp_bridge->driver->agp_destroy_page(va,
>                                                             AGP_PAGE_DESTROY_FREE);
>                }
>                agp_free_page_array(curr);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
