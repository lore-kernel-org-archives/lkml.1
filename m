Return-Path: <linux-kernel-owner+w=401wt.eu-S1764917AbZFOSFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764917AbZFOSFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933524AbZFOSEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:04:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:60514 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562AbZFOSEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:04:46 -0400
Subject: Re: [tip:perfcounters/core] x86: Add NMI types for kmap_atomic
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, efault@gmx.de, npiggin@suse.de,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1245080486.6800.561.camel@laptop>
References: <tip-3ff0141aa3a03ca3388b40b36167d0a37919f3fd@git.kernel.org>
	 <1245077165.6800.497.camel@laptop>
	 <Pine.LNX.4.64.0906151623570.5225@sister.anvils>
	 <1245080486.6800.561.camel@laptop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 15 Jun 2009 20:04:25 +0200
Message-Id: <1245089065.13761.19316.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 17:41 +0200, Peter Zijlstra wrote:
> On Mon, 2009-06-15 at 16:30 +0100, Hugh Dickins wrote:
> > On Mon, 15 Jun 2009, Peter Zijlstra wrote:
> > > 
> > > The below would fix it, but that's getting rather ugly :-/,
> > > alternatively I would have to introduce something like
> > > pte_offset_map_irq() which would make the irq/nmi detection and leave
> > > the regular code paths alone, however that would mean either duplicating
> > > the gup_fast() pagewalk or passing down a pte function pointer, which
> > > would only duplicate the gup_pte_range() bit, neither is really
> > > attractive...
> > 
> > > Index: linux-2.6/arch/x86/include/asm/pgtable_32.h
> > > ===================================================================
> > > --- linux-2.6.orig/arch/x86/include/asm/pgtable_32.h
> > > +++ linux-2.6/arch/x86/include/asm/pgtable_32.h
> > > @@ -49,7 +49,10 @@ extern void set_pmd_pfn(unsigned long, u
> > >  #endif
> > >  
> > >  #if defined(CONFIG_HIGHPTE)
> > > -#define __KM_PTE	(in_nmi() ? KM_NMI_PTE : KM_PTE0)
> > > +#define __KM_PTE			\
> > > +	(in_nmi() ? KM_NMI_PTE : 	\
> > > +	 in_irq() ? KM_IRQ_PTE :	\
> > > +	 KM_PTE0)
> > >  #define pte_offset_map(dir, address)					\
> > >  	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), __KM_PTE) +		\
> > >  	 pte_index((address)))
> > 
> > Yes, that does look ugly!
> > 
> > I've not been following the background to this, 
> 
> We need/want to do a user-space stack walk from IRQ/NMI context. The NMI
> bit means we cannot simply use __copy_from_user_inatomic() since that
> will still fault (albeit not page), and the fault return path invokes
> IRET which will terminate the NMI context.
> 
> Therefore I wrote a copy_from_user_nmi() variant that is based of of
> __get_user_pages_fast() (a variant that doesn't fall back to the regular
> GUP), but that means we get 2 kmap_atomic()s, one for HIGHPTE and one
> for the user page.
> 
> So this introduces the pte map from IRQ context and one from NMI
> context.
> 
> > but I've often
> > wondered if a kmap_push() and kmap_pop() could be useful,
> > allowing you to reuse the slot in between - any use here?
> 
> Yes, that would be much nicer, although less we would loose some of the
> type validation that lives in -mm, (along with a massive overhaul of the
> current kmap_atomic usage).
> 
> Hmm, if we give each explicit type an level and ensure the new push()'ed
> type's level <= the previous one, we'd still have the full nesting
> validation and such..
> 
> I'll look into doing this.

OK, utterly untested, but how does this look?

Not-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/arch/x86/include/asm/kmap_types.h b/arch/x86/include/asm/kmap_types.h
index ff00a44..f866138 100644
--- a/arch/x86/include/asm/kmap_types.h
+++ b/arch/x86/include/asm/kmap_types.h
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
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index 8546497..d31930a 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -49,7 +49,20 @@ extern void set_pmd_pfn(unsigned long, unsigned long, pgprot_t);
 #endif
 
 #if defined(CONFIG_HIGHPTE)
-#define __KM_PTE	(in_nmi() ? KM_NMI_PTE : KM_PTE0)
+
+#ifdef CONFIG_DEBUG_VM
+/*
+ * for debug we need the right type so that we can validate context
+ * nesting
+ */
+#define __KM_PTE			\
+	(in_nmi() ? KM_NMI_PTE :	\
+	 in_irq() ? KM_IRQ_PTE :	\
+	 KM_PTE0)
+#else
+#define __KM_PTE	KM_PTE0
+#endif
+
 #define pte_offset_map(dir, address)					\
 	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), __KM_PTE) +		\
 	 pte_index((address)))
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 58f621e..62d15f7 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -19,6 +19,147 @@ void kunmap(struct page *page)
 	kunmap_high(page);
 }
 
+struct kmap_atomic_state {
+	int slot;
+#ifdef CONFIG_DEBUG_VM
+	int taken[KM_TYPE_NR];
+	int context;
+#endif
+};
+
+#ifdef CONFIG_DEBUG_VM
+enum km_context {
+	KM_CTX_USER,
+	KM_CTX_SOFTIRQ,
+	KM_CTX_IRQ,
+	KM_CTX_NMI,
+
+	KM_CTX_MAX
+};
+
+static int kmap_type_to_context(enum km_type type)
+{
+	switch (type) {
+	case KM_BOUNCE_READ:
+		return KM_CTX_USER;
+	case KM_SKB_SUNRPC_DATA:
+		return KM_CTX_USER;
+	case KM_SKB_DATA_SOFTIRQ:
+		return KM_CTX_SOFTIRQ;
+	case KM_USER0:
+		return KM_CTX_USER;
+	case KM_USER1:
+		return KM_CTX_USER;
+	case KM_BIO_SRC_IRQ:
+		return KM_CTX_IRQ;
+	case KM_BIO_DST_IRQ:
+		return KM_CTX_IRQ;
+	case KM_PTE0:
+		return KM_CTX_USER;
+	case KM_PTE1:
+		return KM_CTX_USER;
+	case KM_IRQ0:
+		return KM_CTX_IRQ;
+	case KM_IRQ1:
+		return KM_CTX_IRQ;
+	case KM_SOFTIRQ0:
+		return KM_CTX_SOFTIRQ;
+	case KM_SOFTIRQ1:
+		return KM_CTX_SOFTIRQ;
+	case KM_NMI:
+		return KM_CTX_NMI;
+	case KM_NMI_PTE:
+		return KM_CTX_NMI;
+	}
+
+	return KM_CTX_MAX;
+}
+
+static void
+kmap_atomic_push_debug(struct kmap_atomic_state *state, enum km_type type)
+{
+	int context = kmap_type_to_context(type);
+	int i;
+
+	for (i = 0; i < state->slot; i++)
+		WARN_ON_ONCE(state->taken[i] == type);
+
+	WARN_ON_ONCE(state->context > context);
+
+	if (context > state->context)
+		state->context = context;
+
+	switch (context) {
+	case KM_CTX_USER:
+		WARN_ON_ONCE(in_irq());
+		WARN_ON_ONCE(in_nmi());
+		break;
+
+	case KM_CTX_SOFTIRQ:
+		WARN_ON_ONCE(in_irq());
+		WARN_ON_ONCE(in_nmi());
+		break;
+
+	case KM_CTX_IRQ:
+		WARN_ON_ONCE(in_nmi());
+		break;
+
+	case KM_CTX_NMI:
+		break;
+
+	case KM_CTX_MAX:
+		WARN_ON_ONCE(1);
+		break;
+	}
+}
+
+static void
+kmap_atomic_pop_debug(struct kmap_atomic_state *state, enum km_type type)
+{
+	WARN_ON_ONCE(state->taken[state->slot] != type);
+
+	if (!state->slot) {
+		state->context = KM_CTX_USER;
+		return;
+	}
+
+	state->context = kmap_type_to_context(state->taken[state->slot - 1]);
+}
+
+#else /* !CONFIG_DEBUG_VM */
+static inline void
+kmap_atomic_push_debug(struct kmap_atomic_state *state, enum km_type type)
+{
+}
+
+static inline void
+kmap_atomic_pop_debug(struct kmap_atomic_state *state, enum km_type type)
+{
+}
+#endif
+
+static DEFINE_PER_CPU(struct kmap_atomic_state, kmap_state);
+
+static int kmap_atomic_push(enum km_type type)
+{
+	struct kmap_atomic_state *state = &per_cpu(kmap_state);
+
+	kmap_atomic_push_debug(state, type);
+
+	return state->slot++;
+}
+
+static int kmap_atomic_pop(enum km_type type)
+{
+	struct kmap_atomic_state *state = &per_cpu(kmap_state);
+
+	state->slot--;
+
+	kmap_atomic_pop_debug(state, type);
+
+	return state->slot;
+}
+
 /*
  * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap because
  * no global lock is needed and because the kmap code must perform a global TLB
@@ -38,9 +179,7 @@ void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
 	if (!PageHighMem(page))
 		return page_address(page);
 
-	debug_kmap_atomic(type);
-
-	idx = type + KM_TYPE_NR*smp_processor_id();
+	idx = KM_TYPE_NR*smp_processor_id() + kmap_atomic_push(type);
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
 	set_pte(kmap_pte-idx, mk_pte(page, prot));
@@ -56,8 +195,9 @@ void *kmap_atomic(struct page *page, enum km_type type)
 void kunmap_atomic(void *kvaddr, enum km_type type)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
-	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
+	enum fixed_addresses idx = KM_TYPE_NR*smp_processor_id();
 
+	idx += kmap_atomic_pop(type);
 	/*
 	 * Force other mappings to Oops if they'll try to access this pte
 	 * without first remap it.  Keeping stale mappings around is a bad idea
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 1fcb712..92123b9 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -21,18 +21,6 @@ static inline void flush_kernel_dcache_page(struct page *page)
 
 #include <asm/kmap_types.h>
 
-#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
-
-void debug_kmap_atomic(enum km_type type);
-
-#else
-
-static inline void debug_kmap_atomic(enum km_type type)
-{
-}
-
-#endif
-
 #ifdef CONFIG_HIGHMEM
 #include <asm/highmem.h>
 
diff --git a/mm/highmem.c b/mm/highmem.c
index 68eb1d9..9101980 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -422,48 +422,3 @@ void __init page_address_init(void)
 }
 
 #endif	/* defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL) */
-
-#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
-
-void debug_kmap_atomic(enum km_type type)
-{
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
-}
-
-#endif

