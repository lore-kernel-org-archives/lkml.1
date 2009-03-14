Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbZCNEUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbZCNEUp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 00:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZCNEUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 00:20:34 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:39600 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbZCNEUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 00:20:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j4veDq0jQSpFVYmkFVOPmVnXQHvWkkgw3gUd6xo5YCQzkHt6ghfPTuZoEIt97V6CaB
         qBfR4pKLDjDnsmJNobeOiqGYErSmMR9qIsYl0wHWXrVcRB9UgR2p74lbC3ZpIajJ5H6n
         uJfOSuF53te094IBtGmb4xITcud7ELxwjJCdg=
Date: Sat, 14 Mar 2009 13:19:49 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: [PATCH -tip 1/2] mm: introduce debug_kmap_atomic
Message-ID: <20090314041948.GA3697@localhost.localdomain>
References: <20090311143317.GA22244@localhost.localdomain> <tip-dd63fdcc63f0f853b116b52e56200a0e0227cf5f@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <tip-dd63fdcc63f0f853b116b52e56200a0e0227cf5f@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 01:39:31AM +0000, Ingo Molnar wrote:
> x86: unify kmap_atomic_pfn() and iomap_atomic_prot_pfn(), fix
> 
> Impact: build fix
> 
> Move kmap_atomic_prot_pfn() to iomap_32.c. It is used on all 32-bit
> kernels, while highmem_32.c is only built on highmem kernels.

Thanks for fixing that.

> ( Note: the debug_kmap_atomic_prot() check is removed for now, that
>   problem is handled via another patch. )

The patches are now sitting in -mmotm now. For -tip, here are the rebased
patches for the debug_kmap_atomic_prot() check.

Subject: mm: introduce debug_kmap_atomic
From: Akinobu Mita <akinobu.mita@gmail.com>

x86 has debug_kmap_atomic_prot() which is error checking function for
kmap_atomic.  It is usefull for the other architectures, although it needs
CONFIG_TRACE_IRQFLAGS_SUPPORT.

This patch exposes it to the other architectures.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 arch/x86/mm/highmem_32.c |   45 +--------------------------------------------
 include/linux/highmem.h  |   12 ++++++++++++
 mm/highmem.c             |   45 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 44 deletions(-)

Index: linux-2.6-tip/arch/x86/mm/highmem_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/mm/highmem_32.c
+++ linux-2.6-tip/arch/x86/mm/highmem_32.c
@@ -19,49 +19,6 @@ void kunmap(struct page *page)
 	kunmap_high(page);
 }
 
-static void debug_kmap_atomic_prot(enum km_type type)
-{
-#ifdef CONFIG_DEBUG_HIGHMEM
-	static unsigned warn_count = 10;
-
-	if (unlikely(warn_count == 0))
-		return;
-
-	if (unlikely(in_interrupt())) {
-		if (in_irq()) {
-			if (type != KM_IRQ0 && type != KM_IRQ1 &&
-			    type != KM_BIO_SRC_IRQ && type != KM_BIO_DST_IRQ &&
-			    type != KM_BOUNCE_READ) {
-				WARN_ON(1);
-				warn_count--;
-			}
-		} else if (!irqs_disabled()) {	/* softirq */
-			if (type != KM_IRQ0 && type != KM_IRQ1 &&
-			    type != KM_SOFTIRQ0 && type != KM_SOFTIRQ1 &&
-			    type != KM_SKB_SUNRPC_DATA &&
-			    type != KM_SKB_DATA_SOFTIRQ &&
-			    type != KM_BOUNCE_READ) {
-				WARN_ON(1);
-				warn_count--;
-			}
-		}
-	}
-
-	if (type == KM_IRQ0 || type == KM_IRQ1 || type == KM_BOUNCE_READ ||
-			type == KM_BIO_SRC_IRQ || type == KM_BIO_DST_IRQ) {
-		if (!irqs_disabled()) {
-			WARN_ON(1);
-			warn_count--;
-		}
-	} else if (type == KM_SOFTIRQ0 || type == KM_SOFTIRQ1) {
-		if (irq_count() == 0 && !irqs_disabled()) {
-			WARN_ON(1);
-			warn_count--;
-		}
-	}
-#endif
-}
-
 /*
  * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap because
  * no global lock is needed and because the kmap code must perform a global TLB
@@ -81,7 +38,7 @@ void *kmap_atomic_prot(struct page *page
 	if (!PageHighMem(page))
 		return page_address(page);
 
-	debug_kmap_atomic_prot(type);
+	debug_kmap_atomic(type);
 
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
Index: linux-2.6-tip/include/linux/highmem.h
===================================================================
--- linux-2.6-tip.orig/include/linux/highmem.h
+++ linux-2.6-tip/include/linux/highmem.h
@@ -187,4 +187,16 @@ static inline void copy_highpage(struct 
 	kunmap_atomic(vto, KM_USER1);
 }
 
+#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
+
+void debug_kmap_atomic(enum km_type type);
+
+#else
+
+static inline void debug_kmap_atomic(enum km_type type)
+{
+}
+
+#endif
+
 #endif /* _LINUX_HIGHMEM_H */
Index: linux-2.6-tip/mm/highmem.c
===================================================================
--- linux-2.6-tip.orig/mm/highmem.c
+++ linux-2.6-tip/mm/highmem.c
@@ -373,3 +373,48 @@ void __init page_address_init(void)
 }
 
 #endif	/* defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL) */
+
+#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
+
+void debug_kmap_atomic(enum km_type type)
+{
+	static unsigned warn_count = 10;
+
+	if (unlikely(warn_count == 0))
+		return;
+
+	if (unlikely(in_interrupt())) {
+		if (in_irq()) {
+			if (type != KM_IRQ0 && type != KM_IRQ1 &&
+			    type != KM_BIO_SRC_IRQ && type != KM_BIO_DST_IRQ &&
+			    type != KM_BOUNCE_READ) {
+				WARN_ON(1);
+				warn_count--;
+			}
+		} else if (!irqs_disabled()) {	/* softirq */
+			if (type != KM_IRQ0 && type != KM_IRQ1 &&
+			    type != KM_SOFTIRQ0 && type != KM_SOFTIRQ1 &&
+			    type != KM_SKB_SUNRPC_DATA &&
+			    type != KM_SKB_DATA_SOFTIRQ &&
+			    type != KM_BOUNCE_READ) {
+				WARN_ON(1);
+				warn_count--;
+			}
+		}
+	}
+
+	if (type == KM_IRQ0 || type == KM_IRQ1 || type == KM_BOUNCE_READ ||
+			type == KM_BIO_SRC_IRQ || type == KM_BIO_DST_IRQ) {
+		if (!irqs_disabled()) {
+			WARN_ON(1);
+			warn_count--;
+		}
+	} else if (type == KM_SOFTIRQ0 || type == KM_SOFTIRQ1) {
+		if (irq_count() == 0 && !irqs_disabled()) {
+			WARN_ON(1);
+			warn_count--;
+		}
+	}
+}
+
+#endif
