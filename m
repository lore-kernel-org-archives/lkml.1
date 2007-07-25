Return-Path: <linux-kernel-owner+w=401wt.eu-S935098AbXGYSo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935098AbXGYSo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762242AbXGYSoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:44:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:28379 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758929AbXGYSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:44:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tGCanXbYSZ+NOoZZTYcOmU1V8lzPE+UQmz5EnItTfF8rr4vwjT+nIjPuWRBIT2FN5bob9ES5tctFL9gMFsbAAgxoUdJ+YJc6PEawUic5AkeWx0gxywQPlpMrzkAqhY8pzwWEiWyNMDiIKm/ue3QLz3FwGklpmYVX5vC6ydd+bMI=
Message-ID: <dda83e780707251144w5041d393r4d93291daba1d4be@mail.gmail.com>
Date: Wed, 25 Jul 2007 11:44:18 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [patch] agp: don't lock pages
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>, airlied@gmail.com
In-Reply-To: <20070725111922.GF29011@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070725111922.GF29011@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Nick Piggin <npiggin@suse.de> wrote:
> Hi,
>
> Does this patch solve the X problem? Does anyone see anything wrong
> with it or know why agp was locking the pages?

Yeap the mac mini is happy again
Thanks

> --
> AGP should not need to lock pages. They are not protecting any race
> because there is no lock_page calls, only SetPageLocked.
>
> This is causing hangs with d00806b183152af6d24f46f0c33f14162ca1262a.
>
> Signed-off-by: Nick Piggin <npiggin@suse.de>
>
> diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
> index d535c40..3db4f40 100644
> --- a/drivers/char/agp/generic.c
> +++ b/drivers/char/agp/generic.c
> @@ -1170,7 +1170,6 @@ void *agp_generic_alloc_page(struct agp_
>         map_page_into_agp(page);
>
>         get_page(page);
> -       SetPageLocked(page);
>         atomic_inc(&agp_bridge->current_memory_agp);
>         return page_address(page);
>  }
> @@ -1187,7 +1186,6 @@ void agp_generic_destroy_page(void *addr
>         page = virt_to_page(addr);
>         unmap_page_from_agp(page);
>         put_page(page);
> -       unlock_page(page);
>         free_page((unsigned long)addr);
>         atomic_dec(&agp_bridge->current_memory_agp);
>  }
> diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
> index a124060..2f319f4 100644
> --- a/drivers/char/agp/intel-agp.c
> +++ b/drivers/char/agp/intel-agp.c
> @@ -213,7 +213,6 @@ static void *i8xx_alloc_pages(void)
>         }
>         global_flush_tlb();
>         get_page(page);
> -       SetPageLocked(page);
>         atomic_inc(&agp_bridge->current_memory_agp);
>         return page_address(page);
>  }
> @@ -229,7 +228,6 @@ static void i8xx_destroy_pages(void *add
>         change_page_attr(page, 4, PAGE_KERNEL);
>         global_flush_tlb();
>         put_page(page);
> -       unlock_page(page);
>         __free_pages(page, 2);
>         atomic_dec(&agp_bridge->current_memory_agp);
>  }
> diff --git a/drivers/char/agp/sgi-agp.c b/drivers/char/agp/sgi-agp.c
> index cda608c..98cf8ab 100644
> --- a/drivers/char/agp/sgi-agp.c
> +++ b/drivers/char/agp/sgi-agp.c
> @@ -51,7 +51,6 @@ static void *sgi_tioca_alloc_page(struct
>                 return NULL;
>
>         get_page(page);
> -       SetPageLocked(page);
>         atomic_inc(&agp_bridge->current_memory_agp);
>         return page_address(page);
>  }
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
