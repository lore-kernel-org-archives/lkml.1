Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZEQBgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZEQBgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 21:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbZEQBgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 21:36:44 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:39900 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbZEQBgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 21:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=puhWqMFjc38sZdEgJgIIFSovXR5CIq6RHPc/KmY2TUZptVP1D1rReMT7DlL1Ync3QX
         ZBJjlTOPEhB5NIeW+nlT61NyOOHtHsrR6z8lAruTZ1s21sF2zoi3U3j8r3KSY61F3Nhx
         s5Gqsg1YDnozyx0PkiCW8q3wgIMbZFz0bVE8c=
MIME-Version: 1.0
In-Reply-To: <20090516090448.249602749@intel.com>
References: <20090516090005.916779788@intel.com>
	 <20090516090448.249602749@intel.com>
Date: Sun, 17 May 2009 10:36:44 +0900
Message-ID: <28c262360905161836u332f9e9aj6fa3f3b65da95592@mail.gmail.com>
Subject: Re: [PATCH 1/3] vmscan: report vm_flags in page_referenced()
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "riel@redhat.com" <riel@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 6:00 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> Collect vma->vm_flags of the VMAs that actually referenced the page.
>
> This is preparing for more informed reclaim heuristics,
> eg. to protect executable file pages more aggressively.
> For now only the VM_EXEC bit will be used by the caller.
>
> CC: Minchan Kim <minchan.kim@gmail.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  include/linux/rmap.h |    5 +++--
>  mm/rmap.c            |   37 ++++++++++++++++++++++++++-----------
>  mm/vmscan.c          |    7 +++++--
>  3 files changed, 34 insertions(+), 15 deletions(-)
>
> --- linux.orig/include/linux/rmap.h
> +++ linux/include/linux/rmap.h
> @@ -83,7 +83,8 @@ static inline void page_dup_rmap(struct
>  /*
>  * Called from mm/vmscan.c to handle paging out
>  */
> -int page_referenced(struct page *, int is_locked, struct mem_cgroup *cnt);
> +int page_referenced(struct page *, int is_locked,
> +                       struct mem_cgroup *cnt, unsigned long *vm_flags);
>  int try_to_unmap(struct page *, int ignore_refs);
>
>  /*
> @@ -128,7 +129,7 @@ int page_wrprotect(struct page *page, in
>  #define anon_vma_prepare(vma)  (0)
>  #define anon_vma_link(vma)     do {} while (0)
>
> -#define page_referenced(page,l,cnt) TestClearPageReferenced(page)
> +#define page_referenced(page, locked, cnt, flags) TestClearPageReferenced(page)
>  #define try_to_unmap(page, refs) SWAP_FAIL
>
>  static inline int page_mkclean(struct page *page)
> --- linux.orig/mm/rmap.c
> +++ linux/mm/rmap.c
> @@ -333,7 +333,9 @@ static int page_mapped_in_vma(struct pag
>  * repeatedly from either page_referenced_anon or page_referenced_file.
>  */
>  static int page_referenced_one(struct page *page,
> -       struct vm_area_struct *vma, unsigned int *mapcount)
> +                              struct vm_area_struct *vma,
> +                              unsigned int *mapcount,
> +                              unsigned long *vm_flags)
>  {
>        struct mm_struct *mm = vma->vm_mm;
>        unsigned long address;
> @@ -381,11 +383,14 @@ out_unmap:
>        (*mapcount)--;
>        pte_unmap_unlock(pte, ptl);
>  out:
> +       if (referenced)
> +               *vm_flags |= vma->vm_flags;
>        return referenced;
>  }
>
>  static int page_referenced_anon(struct page *page,
> -                               struct mem_cgroup *mem_cont)
> +                               struct mem_cgroup *mem_cont,
> +                               unsigned long *vm_flags)
>  {
>        unsigned int mapcount;
>        struct anon_vma *anon_vma;
> @@ -405,7 +410,8 @@ static int page_referenced_anon(struct p
>                 */
>                if (mem_cont && !mm_match_cgroup(vma->vm_mm, mem_cont))
>                        continue;
> -               referenced += page_referenced_one(page, vma, &mapcount);
> +               referenced += page_referenced_one(page, vma,
> +                                                 &mapcount, vm_flags);
>                if (!mapcount)
>                        break;
>        }
> @@ -418,6 +424,7 @@ static int page_referenced_anon(struct p
>  * page_referenced_file - referenced check for object-based rmap
>  * @page: the page we're checking references on.
>  * @mem_cont: target memory controller
> + * @vm_flags: collect encountered vma->vm_flags

I missed this.
To clarify, how about ?
collect encountered vma->vm_flags among vma which referenced the page

-- 
Kinds regards,
Minchan Kim
