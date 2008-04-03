Return-Path: <linux-kernel-owner+w=401wt.eu-S1758988AbYDCVoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988AbYDCVoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbYDCVn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:43:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716AbYDCVn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:43:58 -0400
Date: Thu, 3 Apr 2008 14:43:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       schwidefsky@de.ibm.com, mingo@elte.hu, davem@davemloft.net,
       tony.luck@intel.com, paulus@samba.org, tglx@linutronix.de,
       lethal@linux-sh.org
Subject: Re: [PATCH 1/3] hugetlbfs: architecture header cleanup
Message-Id: <20080403144324.fc672728.akpm@linux-foundation.org>
In-Reply-To: <1207146415.4980.11.camel@localhost.localdomain>
References: <1207145843.4980.7.camel@localhost.localdomain>
	<1207146415.4980.11.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Apr 2008 16:26:55 +0200
Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:

> Subject: [PATCH 1/3] hugetlbfs: architecture header cleanup
> 
> From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> 
> This patch moves all architecture functions for hugetlb to architecture
> header files (include/asm-foo/hugetlb.h). It also removes (!)
> ARCH_HAS_HUGEPAGE_ONLY_RANGE, ARCH_HAS_HUGETLB_FREE_PGD_RANGE,
> ARCH_HAS_PREPARE_HUGEPAGE_RANGE, ARCH_HAS_SETCLEAR_HUGE_PTE and
> ARCH_HAS_HUGETLB_PREFAULT_HOOK.
> 
> Cross-Compile tests on the affected architectures (and one unaffected)
> worked fine, but I had no cross-compiler for sh.
> 

This text explains what the patch does but not why it does it.  Always provide
both, please.  That way people will stop asking why this:

> 
>  include/asm-ia64/hugetlb.h    |   21 +++++++++++++++++++
>  include/asm-ia64/page.h       |    6 -----
>  include/asm-powerpc/hugetlb.h |   35 +++++++++++++++++++++++++++++++
>  include/asm-powerpc/page_64.h |    7 ------
>  include/asm-sh/hugetlb.h      |   28 +++++++++++++++++++++++++
>  include/asm-sparc64/hugetlb.h |   30 +++++++++++++++++++++++++++
>  include/asm-sparc64/page.h    |    2 -
>  include/asm-x86/hugetlb.h     |   28 +++++++++++++++++++++++++
>  include/linux/hugetlb.h       |   46 ------------------------------------------
>  9 files changed, 143 insertions(+), 60 deletions(-)

is the way it is.

> Index: linux-2.6.25-rc7/include/asm-ia64/hugetlb.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6.25-rc7/include/asm-ia64/hugetlb.h
> @@ -0,0 +1,21 @@
> +#ifndef _ASM_IA64_HUGETLB_H
> +#define _ASM_IA64_HUGETLB_H
> +
> +#include <asm/page.h>
> +
> +
> +#define is_hugepage_only_range(mm, addr, len)		\
> +	(REGION_NUMBER(addr) == RGN_HPAGE ||	\
> +	 REGION_NUMBER((addr)+(len)-1) == RGN_HPAGE)
> +
> +void hugetlb_free_pgd_range(struct mmu_gather **tlb, unsigned long addr,
> +			    unsigned long end, unsigned long floor,
> +			    unsigned long ceiling);
> +int prepare_hugepage_range(unsigned long addr, unsigned long len);
> +
> +#define set_huge_pte_at(mm, addr, ptep, pte)	set_pte_at(mm, addr, ptep, pte)
> +#define huge_ptep_get_and_clear(mm, addr, ptep) ptep_get_and_clear(mm, addr, ptep)
> +
> +#define hugetlb_prefault_arch_hook(mm)		do { } while (0)
> +
> +#endif /* _ASM_IA64_HUGETLB_H */
> Index: linux-2.6.25-rc7/include/asm-sh/hugetlb.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6.25-rc7/include/asm-sh/hugetlb.h
> @@ -0,0 +1,28 @@
> +#ifndef _ASM_SH_HUGETLB_H
> +#define _ASM_SH_HUGETLB_H
> +
> +#include <asm/page.h>
> +
> +
> +#define is_hugepage_only_range(mm, addr, len)	0
> +#define hugetlb_free_pgd_range			free_pgd_range
> +
> +/*
> + * If the arch doesn't supply something else, assume that hugepage
> + * size aligned regions are ok without further preparation.
> + */
> +static inline int prepare_hugepage_range(unsigned long addr, unsigned long len)
> +{
> +	if (len & ~HPAGE_MASK)
> +		return -EINVAL;
> +	if (addr & ~HPAGE_MASK)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +#define set_huge_pte_at(mm, addr, ptep, pte)	set_pte_at(mm, addr, ptep, pte)
> +#define huge_ptep_get_and_clear(mm, addr, ptep) ptep_get_and_clear(mm, addr, ptep)
> +
> +#define hugetlb_prefault_arch_hook(mm)		do { } while (0)

urgh.  I wouldn't say the result of this "cleanup" is very clean. 
Basically all the macros there should be zapped and turned into inlines. 
That will happen to fix the bug in ia64's is_hugepage_only_range(), which
presently references its arg once or twice, and will do bad things if
called with an expression-with-side-effects.

> +
> +#endif /* _ASM_SH_HUGETLB_H */
> Index: linux-2.6.25-rc7/include/asm-sparc64/hugetlb.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6.25-rc7/include/asm-sparc64/hugetlb.h
> @@ -0,0 +1,30 @@
> +#ifndef _ASM_SPARC64_HUGETLB_H
> +#define _ASM_SPARC64_HUGETLB_H
> +
> +#include <asm/page.h>
> +
> +
> +#define is_hugepage_only_range(mm, addr, len)	0

This is bad too, because it can lead to unused-var warnings if compiled
with suitable config combinations.

So basically the existing hugetlb arch support code needs a big de-macro
crapectomy.  But your patch has gone and massively duplicated the existing
crap, making that decrapectomy larger and harder.

