Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbZFOOqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbZFOOqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZFOOqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:46:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:40289 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbZFOOqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:46:17 -0400
Subject: Re: [tip:perfcounters/core] x86: Add NMI types for kmap_atomic
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, efault@gmx.de, npiggin@suse.de,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>
In-Reply-To: <tip-3ff0141aa3a03ca3388b40b36167d0a37919f3fd@git.kernel.org>
References: <tip-3ff0141aa3a03ca3388b40b36167d0a37919f3fd@git.kernel.org>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 16:46:05 +0200
Message-Id: <1245077165.6800.497.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 14:07 +0000, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  3ff0141aa3a03ca3388b40b36167d0a37919f3fd
> Gitweb:     http://git.kernel.org/tip/3ff0141aa3a03ca3388b40b36167d0a37919f3fd
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Mon, 15 Jun 2009 12:40:41 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 15 Jun 2009 15:57:52 +0200
> 
> x86: Add NMI types for kmap_atomic
> 
> Two new kmap_atomic slots for NMI context. And teach pte_offset_map()
> about NMI context.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Nick Piggin <npiggin@suse.de>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/include/asm/kmap_types.h |    4 +++-
>  arch/x86/include/asm/pgtable_32.h |    5 +++--
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kmap_types.h b/arch/x86/include/asm/kmap_types.h
> index 5759c16..ff00a44 100644
> --- a/arch/x86/include/asm/kmap_types.h
> +++ b/arch/x86/include/asm/kmap_types.h
> @@ -21,7 +21,9 @@ D(9)	KM_IRQ0,
>  D(10)	KM_IRQ1,
>  D(11)	KM_SOFTIRQ0,
>  D(12)	KM_SOFTIRQ1,
> -D(13)	KM_TYPE_NR
> +D(13)	KM_NMI,
> +D(14)	KM_NMI_PTE,
> +D(15)	KM_TYPE_NR
>  };
>  
>  #undef D
> diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
> index 31bd120..8546497 100644
> --- a/arch/x86/include/asm/pgtable_32.h
> +++ b/arch/x86/include/asm/pgtable_32.h
> @@ -49,13 +49,14 @@ extern void set_pmd_pfn(unsigned long, unsigned long, pgprot_t);
>  #endif
>  
>  #if defined(CONFIG_HIGHPTE)
> +#define __KM_PTE	(in_nmi() ? KM_NMI_PTE : KM_PTE0)
>  #define pte_offset_map(dir, address)					\
> -	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE0) +		\
> +	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), __KM_PTE) +		\
>  	 pte_index((address)))
>  #define pte_offset_map_nested(dir, address)				\
>  	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE1) +		\
>  	 pte_index((address)))
> -#define pte_unmap(pte) kunmap_atomic((pte), KM_PTE0)
> +#define pte_unmap(pte) kunmap_atomic((pte), __KM_PTE)
>  #define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
>  #else
>  #define pte_offset_map(dir, address)					\

I just realized this has a kmap_atomic bug in... 

The below would fix it, but that's getting rather ugly :-/,
alternatively I would have to introduce something like
pte_offset_map_irq() which would make the irq/nmi detection and leave
the regular code paths alone, however that would mean either duplicating
the gup_fast() pagewalk or passing down a pte function pointer, which
would only duplicate the gup_pte_range() bit, neither is really
attractive...

Index: linux-2.6/arch/x86/include/asm/kmap_types.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/kmap_types.h
+++ linux-2.6/arch/x86/include/asm/kmap_types.h
@@ -19,11 +19,12 @@ D(7)	KM_PTE0,
 D(8)	KM_PTE1,
 D(9)	KM_IRQ0,
 D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_NMI,
-D(14)	KM_NMI_PTE,
-D(15)	KM_TYPE_NR
+D(11)	KM_IRQ_PTE,
+D(12)	KM_SOFTIRQ0,
+D(13)	KM_SOFTIRQ1,
+D(14)	KM_NMI,
+D(15)	KM_NMI_PTE,
+D(16)	KM_TYPE_NR
 };
 
 #undef D
Index: linux-2.6/arch/x86/include/asm/pgtable_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable_32.h
+++ linux-2.6/arch/x86/include/asm/pgtable_32.h
@@ -49,7 +49,10 @@ extern void set_pmd_pfn(unsigned long, u
 #endif
 
 #if defined(CONFIG_HIGHPTE)
-#define __KM_PTE	(in_nmi() ? KM_NMI_PTE : KM_PTE0)
+#define __KM_PTE			\
+	(in_nmi() ? KM_NMI_PTE : 	\
+	 in_irq() ? KM_IRQ_PTE :	\
+	 KM_PTE0)
 #define pte_offset_map(dir, address)					\
 	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), __KM_PTE) +		\
 	 pte_index((address)))



