Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbZDGT6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbZDGT6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbZDGT6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:58:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10586 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760080AbZDGT6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:58:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=oZlZ7rEQxKBZ/7D8I1LNdij70kgzEXkoyJDUKi/lFbj5r2SzQ7KeeDINAzSIigrnJ
	jASBJ2TXgYmSQxKa3HOCQ==
MIME-Version: 1.0
In-Reply-To: <20090407072132.943283183@intel.com>
References: <20090407071729.233579162@intel.com>
	 <20090407072132.943283183@intel.com>
Date: Tue, 7 Apr 2009 12:58:16 -0700
Message-ID: <604427e00904071258y78eea757m6d95d08deec49450@mail.gmail.com>
Subject: Re: [PATCH 02/14] mm: fix major/minor fault accounting on retried 
	fault
From: Ying Han <yinghan@google.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 7, 2009 at 12:17 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> VM_FAULT_RETRY does make major/minor faults accounting a bit twisted..
>
> Cc: Ying Han <yinghan@google.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  arch/x86/mm/fault.c |    2 ++
>  mm/memory.c         |   22 ++++++++++++++--------
>  2 files changed, 16 insertions(+), 8 deletions(-)
>
> --- mm.orig/arch/x86/mm/fault.c
> +++ mm/arch/x86/mm/fault.c
> @@ -1160,6 +1160,8 @@ good_area:
>        if (fault & VM_FAULT_RETRY) {
>                if (retry_flag) {
>                        retry_flag = 0;
> +                       tsk->maj_flt++;
> +                       tsk->min_flt--;
>                        goto retry;
>                }
>                BUG();
sorry, little bit confuse here. are we assuming the retry path will
return min_flt as always?


> --- mm.orig/mm/memory.c
> +++ mm/mm/memory.c
> @@ -2882,26 +2882,32 @@ int handle_mm_fault(struct mm_struct *mm
>        pud_t *pud;
>        pmd_t *pmd;
>        pte_t *pte;
> +       int ret;
>
>        __set_current_state(TASK_RUNNING);
>
> -       count_vm_event(PGFAULT);
> -
> -       if (unlikely(is_vm_hugetlb_page(vma)))
> -               return hugetlb_fault(mm, vma, address, write_access);
> +       if (unlikely(is_vm_hugetlb_page(vma))) {
> +               ret = hugetlb_fault(mm, vma, address, write_access);
> +               goto out;
> +       }
>
> +       ret = VM_FAULT_OOM;
>        pgd = pgd_offset(mm, address);
>        pud = pud_alloc(mm, pgd, address);
>        if (!pud)
> -               return VM_FAULT_OOM;
> +               goto out;
>        pmd = pmd_alloc(mm, pud, address);
>        if (!pmd)
> -               return VM_FAULT_OOM;
> +               goto out;
>        pte = pte_alloc_map(mm, pmd, address);
>        if (!pte)
> -               return VM_FAULT_OOM;
> +               goto out;
>
> -       return handle_pte_fault(mm, vma, address, pte, pmd, write_access);
> +       ret = handle_pte_fault(mm, vma, address, pte, pmd, write_access);
> +out:
> +       if (!(ret & VM_FAULT_RETRY))
> +               count_vm_event(PGFAULT);
> +       return ret;
>  }
>
>  #ifndef __PAGETABLE_PUD_FOLDED
>
> --
>
>
