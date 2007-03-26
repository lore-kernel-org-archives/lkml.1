Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbXCZJIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbXCZJIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbXCZJIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:08:53 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50191 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbXCZJIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:08:52 -0400
Date: Mon, 26 Mar 2007 01:08:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>, Zachary Amsden <zach@vmware.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] i386: use pte_update_defer in
 ptep_test_and_clear_{dirty,young}
Message-Id: <20070326010842.345118a1.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007 23:37:08 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> 	Date: Sun, 25 Mar 2007 23:07:43 -0800
> 	From: Zachary Amsden <zach@vmware.com>
> 
> 	If you actually clear the bit, you need to:
> 
> 	+         pte_update_defer(vma->vm_mm, addr, ptep);
> 
> 	The reason is, when updating PTEs, the hypervisor must be notified.  Using
> 	atomic operations to do this is fine for all hypervisors I am aware of.
> 	However, for hypervisors which shadow page tables, if these PTE
> 	modifications are not trapped, you need a post-modification call to fulfill
> 	the update of the shadow page table.
> 
> Cc: Zachary Amsden <zach@vmware.com>
> Cc: Hugh Dickins <hugh@veritas.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  include/asm-i386/pgtable.h |   26 ++++++++++++++------------
>  1 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/include/asm-i386/pgtable.h b/include/asm-i386/pgtable.h
> --- a/include/asm-i386/pgtable.h
> +++ b/include/asm-i386/pgtable.h
> @@ -287,18 +287,24 @@ do {									\
>  static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma,
>  					    unsigned long addr, pte_t *ptep)
>  {
> -	if (!pte_dirty(*ptep))
> -		return 0;
> -	return test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low);
> +	int ret = 0;
> +	if (pte_dirty(*ptep))
> +		ret = test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low);
> +	if (ret)
> +		pte_update_defer(vma->vm_mm, addr, ptep);
> +	return ret;
>  }
>  

i386 allmodconfig:

include/asm/pgtable.h: In function 'ptep_test_and_clear_dirty':
include/asm/pgtable.h:294: error: dereferencing pointer to incomplete type
include/asm/pgtable.h: In function 'ptep_test_and_clear_young':
include/asm/pgtable.h:306: error: dereferencing pointer to incomplete type

Due to vm_area_struct.

Turning it into a stinky macro fixes it.


diff -puN include/asm-i386/pgtable.h~i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix
+++ a/include/asm-i386/pgtable.h
@@ -284,28 +284,24 @@ do {									\
 } while (0)
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
-static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep)
-{
-	int ret = 0;
-	if (pte_dirty(*ptep))
-		ret = test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low);
-	if (ret)
-		pte_update_defer(vma->vm_mm, addr, ptep);
-	return ret;
-}
+#define ptep_test_and_clear_dirty(vma, addr, ptep) ({			\
+	int ret = 0;							\
+	if (pte_dirty(*ptep))						\
+		ret = test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low); \
+	if (ret)							\
+		pte_update_defer(vma->vm_mm, addr, ptep);		\
+	ret;								\
+})
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep)
-{
-	int ret = 0;
-	if (pte_young(*ptep))
-		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte_low);
-	if (ret)
-		pte_update_defer(vma->vm_mm, addr, ptep);
-	return ret;
-}
+#define ptep_test_and_clear_young(vma, addr, ptep) ({			\
+	int ret = 0;							\
+	if (pte_young(*ptep))						\
+		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte_low); \
+	if (ret)							\
+		pte_update_defer(vma->vm_mm, addr, ptep);		\
+	ret;								\
+})
 
 /*
  * Rules for using ptep_establish: the pte MUST be a user pte, and
_

