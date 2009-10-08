Return-Path: <linux-kernel-owner+w=401wt.eu-S933299AbZJHX1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbZJHX1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932814AbZJHX07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:26:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:43308 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759933AbZJHX0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:26:55 -0400
Message-Id: <20091008232528.581477033@chello.nl>
References: <20091008232226.768382977@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 09 Oct 2009 01:22:30 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 4/4] mm: remove KM_type argument fallout
Content-Disposition: inline; filename=kmap-5.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manual fixups of the previous patch

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/arm/mm/highmem.c              |    6 +++---
 arch/frv/include/asm/highmem.h     |    3 ++-
 arch/mips/mm/highmem.c             |    2 ++
 arch/mn10300/include/asm/highmem.h |    1 +
 arch/x86/include/asm/highmem.h     |    2 +-
 arch/x86/include/asm/pgtable_32.h  |    8 ++------
 arch/x86/kernel/cpu/perf_event.c   |    5 ++---
 arch/x86/mm/iomap_32.c             |   16 ++--------------
 drivers/net/e1000/e1000_main.c     |    6 ++----
 drivers/scsi/libfc/fc_fcp.c        |    6 ++----
 drivers/staging/hv/netvsc_drv.c    |    3 +--
 drivers/staging/hv/storvsc_drv.c   |   11 +++++------
 include/crypto/scatterwalk.h       |   16 ++--------------
 net/sunrpc/xprtrdma/rpc_rdma.c     |    6 ++----
 14 files changed, 29 insertions(+), 62 deletions(-)

Index: linux-2.6/arch/arm/mm/highmem.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/highmem.c
+++ linux-2.6/arch/arm/mm/highmem.c
@@ -38,7 +38,7 @@ EXPORT_SYMBOL(kunmap);
 
 void *kmap_atomic(struct page *page)
 {
-	unsigned int idx;
+	unsigned int idx, type;
 	unsigned long vaddr;
 	void *kmap;
 
@@ -76,7 +76,7 @@ EXPORT_SYMBOL(kmap_atomic);
 void kunmap_atomic(void *kvaddr)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
-	unsigned int idx;
+	unsigned int idx, type;
 
 	type = kmap_atomic_idx_pop();
 	idx = type + KM_TYPE_NR * smp_processor_id();
@@ -100,7 +100,7 @@ EXPORT_SYMBOL(kunmap_atomic);
 
 void *kmap_atomic_pfn(unsigned long pfn)
 {
-	unsigned int idx;
+	unsigned int idx, type;
 	unsigned long vaddr;
 
 	pagefault_disable();
Index: linux-2.6/arch/frv/include/asm/highmem.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/highmem.h
+++ linux-2.6/arch/frv/include/asm/highmem.h
@@ -115,6 +115,7 @@ extern struct page *kmap_atomic_to_page(
 static inline void *kmap_atomic(struct page *page)
 {
 	unsigned long paddr;
+	int type;
 
 	pagefault_disable();
 	type = kmap_atomic_idx_push();
@@ -154,7 +155,7 @@ do {									\
 
 static inline void kunmap_atomic(void *kvaddr)
 {
-	type = kmap_atomic_idx_pop();
+	int type = kmap_atomic_idx_pop();
 	switch (type) {
         case 0:		__kunmap_atomic_primary(0, 2);	break;
         case 1:		__kunmap_atomic_primary(1, 3);	break;
Index: linux-2.6/arch/mips/mm/highmem.c
===================================================================
--- linux-2.6.orig/arch/mips/mm/highmem.c
+++ linux-2.6/arch/mips/mm/highmem.c
@@ -44,6 +44,7 @@ void *__kmap_atomic(struct page *page)
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
+	int type;
 
 	/* even !CONFIG_PREEMPT needs this, for in_atomic in do_page_fault */
 	pagefault_disable();
@@ -101,6 +102,7 @@ void *kmap_atomic_pfn(unsigned long pfn)
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
+	int type;
 
 	pagefault_disable();
 
Index: linux-2.6/arch/x86/include/asm/highmem.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/highmem.h
+++ linux-2.6/arch/x86/include/asm/highmem.h
@@ -67,7 +67,7 @@ void *kmap_atomic_prot_pfn(unsigned long
 struct page *kmap_atomic_to_page(void *ptr);
 
 #ifndef CONFIG_PARAVIRT
-#define kmap_atomic_pte(page, type)	kmap_atomic(page, type)
+#define kmap_atomic_pte(page)	kmap_atomic(page)
 #endif
 
 #define flush_cache_kmaps()	do { } while (0)
Index: linux-2.6/arch/x86/include/asm/pgtable_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable_32.h
+++ linux-2.6/arch/x86/include/asm/pgtable_32.h
@@ -49,17 +49,13 @@ extern void set_pmd_pfn(unsigned long, u
 #endif
 
 #if defined(CONFIG_HIGHPTE)
-#define __KM_PTE			\
-	(in_nmi() ? KM_NMI_PTE : 	\
-	 in_irq() ? KM_IRQ_PTE :	\
-	 KM_PTE0)
 #define pte_offset_map(dir, address)					\
-	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), __KM_PTE) +		\
+	((pte_t *)kmap_atomic_pte(pmd_page(*(dir))) +		\
 	 pte_index((address)))
 #define pte_offset_map_nested(dir, address)				\
 	((pte_t *)kmap_atomic_pte(pmd_page(*(dir))) +		\
 	 pte_index((address)))
-#define pte_unmap(pte) kunmap_atomic((pte), __KM_PTE)
+#define pte_unmap(pte) kunmap_atomic((pte))
 #define pte_unmap_nested(pte) kunmap_atomic((pte))
 #else
 #define pte_offset_map(dir, address)					\
Index: linux-2.6/arch/x86/mm/iomap_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/iomap_32.c
+++ linux-2.6/arch/x86/mm/iomap_32.c
@@ -70,25 +70,13 @@ iomap_atomic_prot_pfn(unsigned long pfn,
 	if (!pat_enabled && pgprot_val(prot) == pgprot_val(PAGE_KERNEL_WC))
 		prot = PAGE_KERNEL_UC_MINUS;
 
-	return kmap_atomic_prot_pfn(pfn, type, prot);
+	return kmap_atomic_prot_pfn(pfn, prot);
 }
 EXPORT_SYMBOL_GPL(iomap_atomic_prot_pfn);
 
 void
 iounmap_atomic(void *kvaddr)
 {
-	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
-	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
-
-	/*
-	 * Force other mappings to Oops if they'll try to access this pte
-	 * without first remap it.  Keeping stale mappings around is a bad idea
-	 * also, in case the page changes cacheability attributes or becomes
-	 * a protected page in a hypervisor.
-	 */
-	if (vaddr == __fix_to_virt(FIX_KMAP_BEGIN+idx))
-		kpte_clear_flush(kmap_pte-idx, vaddr);
-
-	pagefault_enable();
+	kunmap_atomic(kvaddr);
 }
 EXPORT_SYMBOL_GPL(iounmap_atomic);
Index: linux-2.6/arch/mn10300/include/asm/highmem.h
===================================================================
--- linux-2.6.orig/arch/mn10300/include/asm/highmem.h
+++ linux-2.6/arch/mn10300/include/asm/highmem.h
@@ -74,6 +74,7 @@ static inline unsigned long kmap_atomic(
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
+	int type;
 
 	if (page < highmem_start_page)
 		return page_address(page);
Index: linux-2.6/drivers/scsi/libfc/fc_fcp.c
===================================================================
--- linux-2.6.orig/drivers/scsi/libfc/fc_fcp.c
+++ linux-2.6/drivers/scsi/libfc/fc_fcp.c
@@ -377,8 +377,7 @@ static void fc_fcp_recv_data(struct fc_f
 		off = offset + sg->offset;
 		sg_bytes = min(sg_bytes, (size_t)
 			       (PAGE_SIZE - (off & ~PAGE_MASK)));
-		page_addr = kmap_atomic(sg_page(sg) + (off >> PAGE_SHIFT),
-					KM_SOFTIRQ0);
+		page_addr = kmap_atomic(sg_page(sg) + (off >> PAGE_SHIFT));
 		if (!page_addr)
 			break;		/* XXX panic? */
 
@@ -560,8 +559,7 @@ static int fc_fcp_send_data(struct fc_fc
 			sg_bytes = min(sg_bytes, (size_t) (PAGE_SIZE -
 							   (off & ~PAGE_MASK)));
 			page_addr = kmap_atomic(sg_page(sg) +
-						(off >> PAGE_SHIFT),
-						KM_SOFTIRQ0);
+						(off >> PAGE_SHIFT));
 			memcpy(data, (char *)page_addr + (off & ~PAGE_MASK),
 			       sg_bytes);
 			kunmap_atomic(page_addr);
Index: linux-2.6/drivers/staging/hv/netvsc_drv.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/netvsc_drv.c
+++ linux-2.6/drivers/staging/hv/netvsc_drv.c
@@ -342,8 +342,7 @@ static int netvsc_recv_callback(struct h
 	 * hv_netvsc_packet cannot be deallocated
 	 */
 	for (i = 0; i < packet->PageBufferCount; i++) {
-		data = kmap_atomic(pfn_to_page(packet->PageBuffers[i].Pfn),
-					       KM_IRQ1);
+		data = kmap_atomic(pfn_to_page(packet->PageBuffers[i].Pfn));
 		data = (void *)(unsigned long)data +
 				packet->PageBuffers[i].Offset;
 
Index: linux-2.6/drivers/staging/hv/storvsc_drv.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/storvsc_drv.c
+++ linux-2.6/drivers/staging/hv/storvsc_drv.c
@@ -525,8 +525,8 @@ static unsigned int copy_to_bounce_buffe
 	local_irq_save(flags);
 
 	for (i = 0; i < orig_sgl_count; i++) {
-		src_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])),
-				KM_IRQ0) + orig_sgl[i].offset;
+		src_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])))
+			+ orig_sgl[i].offset;
 		src = src_addr;
 		srclen = orig_sgl[i].length;
 
@@ -587,8 +587,8 @@ static unsigned int copy_from_bounce_buf
 	local_irq_save(flags);
 
 	for (i = 0; i < orig_sgl_count; i++) {
-		dest_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])),
-					KM_IRQ0) + orig_sgl[i].offset;
+		dest_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])))
+			+ orig_sgl[i].offset;
 		dest = dest_addr;
 		destlen = orig_sgl[i].length;
 		ASSERT(orig_sgl[i].offset + orig_sgl[i].length <= PAGE_SIZE);
@@ -622,8 +622,7 @@ static unsigned int copy_from_bounce_buf
 			}
 		}
 
-		kunmap_atomic((void *)(dest_addr - orig_sgl[i].offset),
-			      KM_IRQ0);
+		kunmap_atomic((void *)(dest_addr - orig_sgl[i].offset));
 	}
 
 	local_irq_restore(flags);
Index: linux-2.6/net/sunrpc/xprtrdma/rpc_rdma.c
===================================================================
--- linux-2.6.orig/net/sunrpc/xprtrdma/rpc_rdma.c
+++ linux-2.6/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -334,8 +334,7 @@ rpcrdma_inline_pullup(struct rpc_rqst *r
 			curlen = copy_len;
 		dprintk("RPC:       %s: page %d destp 0x%p len %d curlen %d\n",
 			__func__, i, destp, copy_len, curlen);
-		srcp = kmap_atomic(rqst->rq_snd_buf.pages[i],
-					KM_SKB_SUNRPC_DATA);
+		srcp = kmap_atomic(rqst->rq_snd_buf.pages[i])
 		if (i == 0)
 			memcpy(destp, srcp+rqst->rq_snd_buf.page_base, curlen);
 		else
@@ -635,8 +634,7 @@ rpcrdma_inline_fixup(struct rpc_rqst *rq
 			dprintk("RPC:       %s: page %d"
 				" srcp 0x%p len %d curlen %d\n",
 				__func__, i, srcp, copy_len, curlen);
-			destp = kmap_atomic(rqst->rq_rcv_buf.pages[i],
-						KM_SKB_SUNRPC_DATA);
+			destp = kmap_atomic(rqst->rq_rcv_buf.pages[i]);
 			if (i == 0)
 				memcpy(destp + rqst->rq_rcv_buf.page_base,
 						srcp, curlen);
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -2190,7 +2190,6 @@ static unsigned long
 copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long offset, addr = (unsigned long)from;
-	int type = in_nmi() ? KM_NMI : KM_IRQ0;
 	unsigned long size, len = 0;
 	struct page *page;
 	void *map;
@@ -2204,9 +2203,9 @@ copy_from_user_nmi(void *to, const void 
 		offset = addr & (PAGE_SIZE - 1);
 		size = min(PAGE_SIZE - offset, n - len);
 
-		map = kmap_atomic(page, type);
+		map = kmap_atomic(page);
 		memcpy(to, map+offset, size);
-		kunmap_atomic(map, type);
+		kunmap_atomic(map);
 		put_page(page);
 
 		len  += size;
Index: linux-2.6/drivers/net/e1000/e1000_main.c
===================================================================
--- linux-2.6.orig/drivers/net/e1000/e1000_main.c
+++ linux-2.6/drivers/net/e1000/e1000_main.c
@@ -3705,11 +3705,9 @@ static bool e1000_clean_jumbo_rx_irq(str
 				if (length <= copybreak &&
 				    skb_tailroom(skb) >= length) {
 					u8 *vaddr;
-					vaddr = kmap_atomic(buffer_info->page,
-					                    KM_SKB_DATA_SOFTIRQ);
+					vaddr = kmap_atomic(buffer_info->page);
 					memcpy(skb_tail_pointer(skb), vaddr, length);
-					kunmap_atomic(vaddr,
-					              KM_SKB_DATA_SOFTIRQ);
+					kunmap_atomic(vaddr);
 					/* re-use the page, so don't erase
 					 * buffer_info->page */
 					skb_put(skb, length);
Index: linux-2.6/include/crypto/scatterwalk.h
===================================================================
--- linux-2.6.orig/include/crypto/scatterwalk.h
+++ linux-2.6/include/crypto/scatterwalk.h
@@ -25,26 +25,14 @@
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 
-static inline enum km_type crypto_kmap_type(int out)
-{
-	enum km_type type;
-
-	if (in_softirq())
-		type = out * (KM_SOFTIRQ1 - KM_SOFTIRQ0) + KM_SOFTIRQ0;
-	else
-		type = out * (KM_USER1 - KM_USER0) + KM_USER0;
-
-	return type;
-}
-
 static inline void *crypto_kmap(struct page *page, int out)
 {
-	return kmap_atomic(page, crypto_kmap_type(out));
+	return kmap_atomic(page);
 }
 
 static inline void crypto_kunmap(void *vaddr, int out)
 {
-	kunmap_atomic(vaddr, crypto_kmap_type(out));
+	kunmap_atomic(vaddr);
 }
 
 static inline void crypto_yield(u32 flags)

-- 

