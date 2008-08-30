Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbYH3K6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbYH3K6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 06:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbYH3K55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 06:57:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:58705 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbYH3K54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 06:57:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ZZ0m8mOAZvi5+hUVw8RXMj9gqOSGZHSuiBbEGgHCPd2s19kfys/xUEUPd3LbXV0uIQ
         AabLjbqiOIUFpyCBeMILTigKvfKtnwA9wh/fLt/nzhQ3BOcHdPetPzzc1IUVUw4xe3KW
         ELECu7H2NWWQ2uvTy8tnLmQvENT5Ht+lXjQ0I=
Message-ID: <84144f020808300357l9dddda4y726622641ac7f592@mail.gmail.com>
Date: Sat, 30 Aug 2008 13:57:55 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Steve VanDeBogart" <vandebo-lkml@nerdbox.net>
Subject: Re: [PATCH 4/6] VM: Annotate pagealloc
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       jiayingz@google.com, dkegel@google.com
In-Reply-To: <alpine.DEB.1.00.0808291616170.15543@abydos.NerdBox.Net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
	 <alpine.DEB.1.00.0808291616170.15543@abydos.NerdBox.Net>
X-Google-Sender-Auth: f25a0e90947d5a62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Sat, Aug 30, 2008 at 2:16 AM, Steve VanDeBogart
<vandebo-lkml@nerdbox.net> wrote:
> Valgrind annotations for valgrind: memory is addressable once it's been
> alloced, and unaddressable when it is freed again.  Can't use malloc-like
> and free-like because valgrind considers a malloc-like chunk indivisible.
>
> Signed-off-by: Steve VanDeBogart <vandebo-lkml@nerdbox.net>
> ---
>
> Index: linux-2.6.27-rc5/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.27-rc5.orig/mm/page_alloc.c       2008-08-29
> 14:24:27.000000000 -0700
> +++ linux-2.6.27-rc5/mm/page_alloc.c    2008-08-29 14:24:37.000000000 -0700
> @@ -46,6 +46,7 @@
>  #include <linux/page-isolation.h>
>  #include <linux/memcontrol.h>
>  #include <linux/debugobjects.h>
> +#include <linux/memcheck.h>
>
>  #include <asm/tlbflush.h>
>  #include <asm/div64.h>
> @@ -1080,6 +1081,7 @@
>                if (!page)
>                        goto failed;
>        }
> +       VALGRIND_MAKE_MEM_UNDEFINED(page_address(page), PAGE_SIZE << order);

No SHOUTING macros please, and I think you should just pass page and
order here and do the calculation elsewhere.

>
>        __count_zone_vm_events(PGALLOC, zone, 1 << order);
>        zone_statistics(preferred_zone, zone);
> @@ -1679,6 +1681,8 @@
>  void __free_pages(struct page *page, unsigned int order)
>  {
>        if (put_page_testzero(page)) {
> +               VALGRIND_MAKE_MEM_NOACCESS(page_address(page),
> +                                               PAGE_SIZE << order);

Same here.

>                if (order == 0)
>                        free_hot_page(page);
>                else

Other than that, looks good to me.
