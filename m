Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbXC0DoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbXC0DoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 23:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbXC0DoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 23:44:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:45242 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbXC0DoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 23:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a/gqjPFWdowQDKTpaliPPoh5GWBP4ICpFTurfmZaj6wsI7K7izilarUjR0gFrPShJJ3D5YgM1cu59IqBEuBq+AARi7+HJELGMfGyBbvN1Sl0FMtwL5wkFYwPrRxlD5D6jUe9HkFfWnHFBPvrKDG1ZE0SY1ekH6SFqpioFL6sF+8=
Message-ID: <6d6a94c50703262044q22e94538i5e79a32a82f7c926@mail.gmail.com>
Date: Tue, 27 Mar 2007 11:44:03 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3][RFC] Containers: Pagecache controller reclaim
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       ckrm-tech@lists.sourceforge.net, "Balbir Singh" <balbir@in.ibm.com>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, devel@openvz.org, xemul@sw.ru,
       "Paul Menage" <menage@google.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <45ED266E.7040107@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ED251C.2010400@linux.vnet.ibm.com>
	 <45ED266E.7040107@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/07, Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
>
> The reclaim code is similar to RSS memory controller.  Scan control is
> slightly different since we are targeting different type of pages.
>
> Additionally no mapped pages are touched when scanning for pagecache pages.
>
> RSS memory controller and pagecache controller share common code in reclaim
> and hence pagecache controller patches are dependent on RSS memory controller
> patch even though the features are independently configurable at compile time.
>
> --- linux-2.6.20.orig/mm/vmscan.c
> +++ linux-2.6.20/mm/vmscan.c
> @@ -43,6 +43,7 @@
>
>  #include <linux/swapops.h>
>  #include <linux/memcontrol.h>
> +#include <linux/pagecache_acct.h>
>
>  #include "internal.h"
>
> @@ -70,6 +71,8 @@ struct scan_control {
>
>         struct container *container;    /* Used by containers for reclaiming */
>                                         /* pages when the limit is exceeded  */
> +       int reclaim_pagecache_only;     /* Set when called from
> +                                          pagecache controller */
>  };
>
>  /*
> @@ -474,6 +477,15 @@ static unsigned long shrink_page_list(st
>                         goto keep;
>
>                 VM_BUG_ON(PageActive(page));
> +               /* Take it easy if we are doing only pagecache pages */
> +               if (sc->reclaim_pagecache_only) {
> +                       /* Check if this is a pagecache page they are not mapped */
> +                       if (page_mapped(page))
> +                               goto keep_locked;
> +                       /* Check if this container has exceeded pagecache limit */
> +                       if (!pagecache_acct_page_overlimit(page))
> +                               goto keep_locked;
> +               }
>
>                 sc->nr_scanned++;
>
> @@ -522,7 +534,8 @@ static unsigned long shrink_page_list(st
>                 }
>
>                 if (PageDirty(page)) {
> -                       if (referenced)
> +                       /* Reclaim even referenced pagecache pages if over limit */
> +                       if (!pagecache_acct_page_overlimit(page) && referenced)
>                                 goto keep_locked;
>                         if (!may_enter_fs)
>                                 goto keep_locked;
> @@ -869,6 +882,13 @@ force_reclaim_mapped:
>                 cond_resched();
>                 page = lru_to_page(&l_hold);
>                 list_del(&page->lru);
> +               /* While reclaiming pagecache make it easy */
> +               if (sc->reclaim_pagecache_only) {
> +                       if (page_mapped(page) || !pagecache_acct_page_overlimit(page)) {
> +                               list_add(&page->lru, &l_active);
> +                               continue;
> +                       }
> +               }

Please correct me if I'm wrong.
Here, if page type is mapped or not overlimit, why add it back to active list?
Did  shrink_page_list() is called by shrink_inactive_list()?

-Aubrey
