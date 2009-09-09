Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbZIIQQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbZIIQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZIIQQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:16:56 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:55411 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbZIIQQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:16:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v9yg4HdSYl/pGMe628IQ2avuly+LO/BVh8bBq3WwiUOGlryWEVpUrw4UWScmSSblmx
         DDvM0ri658He5Ou/I7kd56GhbIo35SPcuHqDTkp5buP0soUMQ+ZEqUbEqugbCXWJj+64
         LDOIy7sT538/0McqzfJr3Mv/0kV+CJEhBWJD4=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0909072233240.15430@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
	 <Pine.LNX.4.64.0909072233240.15430@sister.anvils>
Date: Thu, 10 Sep 2009 01:16:57 +0900
Message-ID: <28c262360909090916w12d700b3w7fa8a970f3aba3af@mail.gmail.com>
Subject: Re: [PATCH 4/8] mm: FOLL_DUMP replace FOLL_ANON
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 8, 2009 at 6:35 AM, Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> The "FOLL_ANON optimization" and its use_zero_page() test have caused
> confusion and bugs: why does it test VM_SHARED? for the very good but
> unsatisfying reason that VMware crashed without.  As we look to maybe
> reinstating anonymous use of the ZERO_PAGE, we need to sort this out.
>
> Easily done: it's silly for __get_user_pages() and follow_page() to
> be guessing whether it's safe to assume that they're being used for
> a coredump (which can take a shortcut snapshot where other uses must
> handle a fault) - just tell them with GUP_FLAGS_DUMP and FOLL_DUMP.
>
> get_dump_page() doesn't even want a ZERO_PAGE: an error suits fine.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Just a nitpick below. :)

> ---
>
>  include/linux/mm.h |    2 +-
>  mm/internal.h      |    1 +
>  mm/memory.c        |   43 ++++++++++++-------------------------------
>  3 files changed, 14 insertions(+), 32 deletions(-)
>
> --- mm3/include/linux/mm.h      2009-09-07 13:16:32.000000000 +0100
> +++ mm4/include/linux/mm.h      2009-09-07 13:16:39.000000000 +0100
> @@ -1247,7 +1247,7 @@ struct page *follow_page(struct vm_area_
>  #define FOLL_WRITE     0x01    /* check pte is writable */
>  #define FOLL_TOUCH     0x02    /* mark page accessed */
>  #define FOLL_GET       0x04    /* do get_page on page */
> -#define FOLL_ANON      0x08    /* give ZERO_PAGE if no pgtable */
> +#define FOLL_DUMP      0x08    /* give error on hole if it would be zero */
>
>  typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
>                        void *data);
> --- mm3/mm/internal.h   2009-09-07 13:16:22.000000000 +0100
> +++ mm4/mm/internal.h   2009-09-07 13:16:39.000000000 +0100
> @@ -252,6 +252,7 @@ static inline void mminit_validate_memmo
>
>  #define GUP_FLAGS_WRITE                0x01
>  #define GUP_FLAGS_FORCE                0x02
> +#define GUP_FLAGS_DUMP         0x04
>
>  int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>                     unsigned long start, int len, int flags,
> --- mm3/mm/memory.c     2009-09-07 13:16:32.000000000 +0100
> +++ mm4/mm/memory.c     2009-09-07 13:16:39.000000000 +0100
> @@ -1174,41 +1174,22 @@ no_page:
>        pte_unmap_unlock(ptep, ptl);
>        if (!pte_none(pte))
>                return page;
> -       /* Fall through to ZERO_PAGE handling */
> +
>  no_page_table:
>        /*
>         * When core dumping an enormous anonymous area that nobody
> -        * has touched so far, we don't want to allocate page tables.
> +        * has touched so far, we don't want to allocate unnecessary pages or
> +        * page tables.  Return error instead of NULL to skip handle_mm_fault,
> +        * then get_dump_page() will return NULL to leave a hole in the dump.
> +        * But we can only make this optimization where a hole would surely
> +        * be zero-filled if handle_mm_fault() actually did handle it.
>         */
> -       if (flags & FOLL_ANON) {
> -               page = ZERO_PAGE(0);
> -               if (flags & FOLL_GET)
> -                       get_page(page);
> -               BUG_ON(flags & FOLL_WRITE);
> -       }
> +       if ((flags & FOLL_DUMP) &&
> +           (!vma->vm_ops || !vma->vm_ops->fault))

How about adding comment about zero page use?

> +               return ERR_PTR(-EFAULT);
>        return page;
>  }


-- 
Kind regards,
Minchan Kim
