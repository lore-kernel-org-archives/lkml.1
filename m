Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab0BJUhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 15:37:40 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61548 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab0BJUhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 15:37:36 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5888"; a="33877070"
From: adharmap@codeaurora.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arm-msm@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: [PATCH 1/2] dma: define barrierless versions of map and unmap area
Date: Wed, 10 Feb 2010 12:37:29 -0800
Message-Id: <1265834250-29170-2-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1265834250-29170-1-git-send-email-adharmap@codeaurora.org>
References: <1265834250-29170-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@quicinc.com>

Barrierless versions of dma_map_area and dma_unmap_area will be used in
the scatter-gather mapping and unmapping functions.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
---
 arch/arm/include/asm/cacheflush.h |    9 +++
 arch/arm/mm/cache-v3.S            |    6 ++
 arch/arm/mm/cache-v4.S            |    6 ++
 arch/arm/mm/cache-v4wb.S          |   94 +++++++++++++++++--------
 arch/arm/mm/cache-v4wt.S          |    6 ++
 arch/arm/mm/cache-v6.S            |  139 ++++++++++++++++++++++++++-----------
 arch/arm/mm/cache-v7.S            |  120 ++++++++++++++++++++++++--------
 7 files changed, 283 insertions(+), 97 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 8148a00..e91e014 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -215,6 +215,9 @@ struct cpu_cache_fns {
 	void (*dma_map_area)(const void *, size_t, int);
 	void (*dma_unmap_area)(const void *, size_t, int);
 
+	void (*dma_map_area_nobarrier)(const void *, size_t, int);
+	void (*dma_unmap_area_nobarrier)(const void *, size_t, int);
+
 	void (*dma_flush_range)(const void *, const void *);
 };
 
@@ -246,6 +249,8 @@ extern struct cpu_cache_fns cpu_cache;
  */
 #define dmac_map_area			cpu_cache.dma_map_area
 #define dmac_unmap_area		cpu_cache.dma_unmap_area
+#define dmac_map_area_nobarrier			cpu_cache.dma_map_area_nobarrier
+#define dmac_unmap_area_nobarrier	cpu_cache.dma_unmap_area_nobarrier
 #define dmac_flush_range		cpu_cache.dma_flush_range
 
 #else
@@ -272,10 +277,14 @@ extern void __cpuc_flush_dcache_area(void *, size_t);
  */
 #define dmac_map_area			__glue(_CACHE,_dma_map_area)
 #define dmac_unmap_area		__glue(_CACHE,_dma_unmap_area)
+#define dmac_map_area_nobarrier			__glue(_CACHE,_dma_map_area_nobarrier)
+#define dmac_unmap_area_nobarrier		__glue(_CACHE,_dma_unmap_area_nobarrier)
 #define dmac_flush_range		__glue(_CACHE,_dma_flush_range)
 
 extern void dmac_map_area(const void *, size_t, int);
 extern void dmac_unmap_area(const void *, size_t, int);
+extern void dmac_map_area_nobarrier(const void *, size_t, int);
+extern void dmac_unmap_area_nobarrier(const void *, size_t, int);
 extern void dmac_flush_range(const void *, const void *);
 
 #endif
diff --git a/arch/arm/mm/cache-v3.S b/arch/arm/mm/cache-v3.S
index c2ff3c5..5ba5b9b 100644
--- a/arch/arm/mm/cache-v3.S
+++ b/arch/arm/mm/cache-v3.S
@@ -103,6 +103,7 @@ ENTRY(v3_dma_flush_range)
  *	- dir	- DMA direction
  */
 ENTRY(v3_dma_unmap_area)
+ENTRY(v3_dma_unmap_area_nobarrier)
 	teq	r2, #DMA_TO_DEVICE
 	bne	v3_dma_flush_range
 	/* FALLTHROUGH */
@@ -114,9 +115,12 @@ ENTRY(v3_dma_unmap_area)
  *	- dir	- DMA direction
  */
 ENTRY(v3_dma_map_area)
+ENTRY(v3_dma_map_area_nobarrier)
 	mov	pc, lr
 ENDPROC(v3_dma_unmap_area)
+ENDPROC(v3_dma_unmap_area_nobarrier)
 ENDPROC(v3_dma_map_area)
+ENDPROC(v3_dma_map_area_nobarrier)
 
 	__INITDATA
 
@@ -130,5 +134,7 @@ ENTRY(v3_cache_fns)
 	.long	v3_flush_kern_dcache_area
 	.long	v3_dma_map_area
 	.long	v3_dma_unmap_area
+	.long	v3_dma_map_area_nobarrier
+	.long	v3_dma_unmap_area_nobarrier
 	.long	v3_dma_flush_range
 	.size	v3_cache_fns, . - v3_cache_fns
diff --git a/arch/arm/mm/cache-v4.S b/arch/arm/mm/cache-v4.S
index 4810f7e..a914c5f 100644
--- a/arch/arm/mm/cache-v4.S
+++ b/arch/arm/mm/cache-v4.S
@@ -115,6 +115,7 @@ ENTRY(v4_dma_flush_range)
  *	- dir	- DMA direction
  */
 ENTRY(v4_dma_unmap_area)
+ENTRY(v4_dma_unmap_area_nobarrier)
 	teq	r2, #DMA_TO_DEVICE
 	bne	v4_dma_flush_range
 	/* FALLTHROUGH */
@@ -126,9 +127,12 @@ ENTRY(v4_dma_unmap_area)
  *	- dir	- DMA direction
  */
 ENTRY(v4_dma_map_area)
+ENTRY(v4_dma_map_area_nobarrier)
 	mov	pc, lr
 ENDPROC(v4_dma_unmap_area)
+ENDPROC(v4_dma_unmap_area_nobarrier)
 ENDPROC(v4_dma_map_area)
+ENDPROC(v4_dma_map_area_nobarrier)
 
 	__INITDATA
 
@@ -142,5 +146,7 @@ ENTRY(v4_cache_fns)
 	.long	v4_flush_kern_dcache_area
 	.long	v4_dma_map_area
 	.long	v4_dma_unmap_area
+	.long	v4_dma_map_area_nobarrier
+	.long	v4_dma_unmap_area_nobarrier
 	.long	v4_dma_flush_range
 	.size	v4_cache_fns, . - v4_cache_fns
diff --git a/arch/arm/mm/cache-v4wb.S b/arch/arm/mm/cache-v4wb.S
index df8368a..dff8248 100644
--- a/arch/arm/mm/cache-v4wb.S
+++ b/arch/arm/mm/cache-v4wb.S
@@ -113,6 +113,37 @@ ENTRY(v4wb_flush_user_cache_range)
 	mcrne	p15, 0, ip, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
+	.macro v4wb_dma_flush_range_macro, start, end
+	bic	\start, \start, #CACHE_DLINESIZE - 1
+1:	mcr	p15, 0, \start, c7, c10, 1		@ clean D entry
+	mcr	p15, 0, \start, c7, c6, 1		@ invalidate D entry
+	add	\start, \start, #CACHE_DLINESIZE
+	cmp	\start, \end
+	blo	1b
+	mov	ip, #0
+	mcr	p15, 0, ip, c7, c5, 0		@ invalidate I cache
+	.endm
+
+	.macro v4wb_dma_inv_range, start, end
+	tst	\start, #CACHE_DLINESIZE - 1
+	bic	\start, \start, #CACHE_DLINESIZE - 1
+	mcrne	p15, 0, \start, c7, c10, 1		@ clean D entry
+	tst	\end, #CACHE_DLINESIZE - 1
+	mcrne	p15, 0, \end, c7, c10, 1		@ clean D entry
+1:	mcr	p15, 0, \start, c7, c6, 1		@ invalidate D entry
+	add	\start, \start, #CACHE_DLINESIZE
+	cmp	\start, \end
+	blo	1b
+	.endm
+
+	.macro v4wb_dma_clean_range, start, end
+	bic	\start, \start, #CACHE_DLINESIZE - 1
+1:	mcr	p15, 0, \start, c7, c10, 1		@ clean D entry
+	add	\start, \start, #CACHE_DLINESIZE
+	cmp	\start, \end
+	blo	1b
+	.endm
+
 /*
  *	flush_kern_dcache_area(void *addr, size_t size)
  *
@@ -150,20 +181,12 @@ ENTRY(v4wb_coherent_kern_range)
  *	- end	 - virtual end address
  */
 ENTRY(v4wb_coherent_user_range)
-	bic	r0, r0, #CACHE_DLINESIZE - 1
-1:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
-	mcr	p15, 0, r0, c7, c6, 1		@ invalidate D entry
-	add	r0, r0, #CACHE_DLINESIZE
-	cmp	r0, r1
-	blo	1b
-	mov	ip, #0
-	mcr	p15, 0, ip, c7, c5, 0		@ invalidate I cache
+	v4wb_dma_flush_range_macro r0, r1
 	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
-
 /*
- *	dma_inv_range(start, end)
+ *	dma_inv_range_barrier(start, end)
  *
  *	Invalidate (discard) the specified virtual address range.
  *	May not write back any entries.  If 'start' or 'end'
@@ -173,16 +196,8 @@ ENTRY(v4wb_coherent_user_range)
  *	- start  - virtual start address
  *	- end	 - virtual end address
  */
-v4wb_dma_inv_range:
-	tst	r0, #CACHE_DLINESIZE - 1
-	bic	r0, r0, #CACHE_DLINESIZE - 1
-	mcrne	p15, 0, r0, c7, c10, 1		@ clean D entry
-	tst	r1, #CACHE_DLINESIZE - 1
-	mcrne	p15, 0, r1, c7, c10, 1		@ clean D entry
-1:	mcr	p15, 0, r0, c7, c6, 1		@ invalidate D entry
-	add	r0, r0, #CACHE_DLINESIZE
-	cmp	r0, r1
-	blo	1b
+v4wb_dma_inv_range_barrier:
+	v4wb_dma_inv_range r0, r1
 	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
@@ -194,12 +209,8 @@ v4wb_dma_inv_range:
  *	- start  - virtual start address
  *	- end	 - virtual end address
  */
-v4wb_dma_clean_range:
-	bic	r0, r0, #CACHE_DLINESIZE - 1
-1:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
-	add	r0, r0, #CACHE_DLINESIZE
-	cmp	r0, r1
-	blo	1b
+v4wb_dma_clean_range_barrier:
+	v4wb_dma_clean_range r0, r1
 	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
@@ -216,17 +227,32 @@ v4wb_dma_clean_range:
 	.globl	v4wb_dma_flush_range
 	.set	v4wb_dma_flush_range, v4wb_coherent_kern_range
 
+
+v4wb_dma_inv_range_nobarrier:
+	v4wb_dma_inv_range r0, r1
+	mov	pc, lr
+
+v4wb_dma_clean_range_nobarrier:
+	v4wb_dma_clean_range r0, r1
+	mov	pc, lr
+
+v4wb_dma_flush_range_nobarrier:
+	v4wb_dma_flush_range_macro r0, r1
+	mov	pc, lr
+
+
 /*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
  *	- dir	- DMA direction
  */
+
 ENTRY(v4wb_dma_map_area)
 	add	r1, r1, r0
 	cmp	r2, #DMA_TO_DEVICE
-	beq	v4wb_dma_clean_range
-	bcs	v4wb_dma_inv_range
+	beq	v4wb_dma_clean_range_barrier
+	bcs	v4wb_dma_inv_range_barrier
 	b	v4wb_dma_flush_range
 ENDPROC(v4wb_dma_map_area)
 
@@ -237,8 +263,18 @@ ENDPROC(v4wb_dma_map_area)
  *	- dir	- DMA direction
  */
 ENTRY(v4wb_dma_unmap_area)
+ENTRY(v4wb_dma_unmap_area_nobarrier)
 	mov	pc, lr
 ENDPROC(v4wb_dma_unmap_area)
+ENDPROC(v4wb_dma_unmap_area_nobarrier)
+
+ENTRY(v4wb_dma_map_area_nobarrier)
+	add	r1, r1, r0
+	cmp	r2, #DMA_TO_DEVICE
+	beq	v4wb_dma_clean_range_nobarrier
+	bcs	v4wb_dma_inv_range_nobarrier
+	b	v4wb_dma_flush_range_nobarrier
+ENDPROC(v4wb_dma_map_area_nobarrier)
 
 	__INITDATA
 
@@ -252,5 +288,7 @@ ENTRY(v4wb_cache_fns)
 	.long	v4wb_flush_kern_dcache_area
 	.long	v4wb_dma_map_area
 	.long	v4wb_dma_unmap_area
+	.long	v4wb_dma_map_area_nobarrier
+	.long	v4wb_dma_unmap_area_nobarrier
 	.long	v4wb_dma_flush_range
 	.size	v4wb_cache_fns, . - v4wb_cache_fns
diff --git a/arch/arm/mm/cache-v4wt.S b/arch/arm/mm/cache-v4wt.S
index 45c7031..df587b6 100644
--- a/arch/arm/mm/cache-v4wt.S
+++ b/arch/arm/mm/cache-v4wt.S
@@ -168,6 +168,7 @@ v4wt_dma_inv_range:
  *	- dir	- DMA direction
  */
 ENTRY(v4wt_dma_unmap_area)
+ENTRY(v4wt_dma_unmap_area_nobarrier)
 	add	r1, r1, r0
 	teq	r2, #DMA_TO_DEVICE
 	bne	v4wt_dma_inv_range
@@ -180,9 +181,12 @@ ENTRY(v4wt_dma_unmap_area)
  *	- dir	- DMA direction
  */
 ENTRY(v4wt_dma_map_area)
+ENTRY(v4wt_dma_map_area_nobarrier)
 	mov	pc, lr
 ENDPROC(v4wt_dma_unmap_area)
+ENDPROC(v4wt_dma_unmap_area_nobarrier)
 ENDPROC(v4wt_dma_map_area)
+ENDPROC(v4wt_dma_map_area_nobarrier)
 
 	__INITDATA
 
@@ -196,5 +200,7 @@ ENTRY(v4wt_cache_fns)
 	.long	v4wt_flush_kern_dcache_area
 	.long	v4wt_dma_map_area
 	.long	v4wt_dma_unmap_area
+	.long	v4wt_dma_map_area_nobarrier
+	.long	v4wt_dma_unmap_area_nobarrier
 	.long	v4wt_dma_flush_range
 	.size	v4wt_cache_fns, . - v4wt_cache_fns
diff --git a/arch/arm/mm/cache-v6.S b/arch/arm/mm/cache-v6.S
index 9d89c67..0e3f9b9 100644
--- a/arch/arm/mm/cache-v6.S
+++ b/arch/arm/mm/cache-v6.S
@@ -185,65 +185,96 @@ ENTRY(v6_flush_kern_dcache_area)
 	mov	pc, lr
 
 
-/*
- *	v6_dma_inv_range(start,end)
- *
- *	Invalidate the data cache within the specified region; we will
- *	be performing a DMA operation in this region and we want to
- *	purge old data in the cache.
- *
- *	- start   - virtual start address of region
- *	- end     - virtual end address of region
- */
-v6_dma_inv_range:
-	tst	r0, #D_CACHE_LINE_SIZE - 1
-	bic	r0, r0, #D_CACHE_LINE_SIZE - 1
+	.macro v6_dma_inv_range, start,end
+	tst	\start, #D_CACHE_LINE_SIZE - 1
+	bic	\start, \start, #D_CACHE_LINE_SIZE - 1
 #ifdef HARVARD_CACHE
-	mcrne	p15, 0, r0, c7, c10, 1		@ clean D line
+	mcrne	p15, 0, \start, c7, c10, 1	@ clean D line
 #else
-	mcrne	p15, 0, r0, c7, c11, 1		@ clean unified line
+	mcrne	p15, 0, \start, c7, c11, 1	@ clean unified line
 #endif
-	tst	r1, #D_CACHE_LINE_SIZE - 1
-	bic	r1, r1, #D_CACHE_LINE_SIZE - 1
+	tst	\end, #D_CACHE_LINE_SIZE - 1
+	bic	\end, \end, #D_CACHE_LINE_SIZE - 1
 #ifdef HARVARD_CACHE
-	mcrne	p15, 0, r1, c7, c14, 1		@ clean & invalidate D line
+	mcrne	p15, 0, \end, c7, c14, 1	@ clean & invalidate D line
 #else
-	mcrne	p15, 0, r1, c7, c15, 1		@ clean & invalidate unified line
+	mcrne	p15, 0, \end, c7, c15, 1	@ clean & invalidate unifiedline
 #endif
 1:
 #ifdef HARVARD_CACHE
-	mcr	p15, 0, r0, c7, c6, 1		@ invalidate D line
+	mcr	p15, 0, \start, c7, c6, 1	@ invalidate D line
 #else
-	mcr	p15, 0, r0, c7, c7, 1		@ invalidate unified line
+	mcr	p15, 0, \start, c7, c7, 1	@ invalidate unified line
 #endif
-	add	r0, r0, #D_CACHE_LINE_SIZE
-	cmp	r0, r1
+	add	\start, \start, #D_CACHE_LINE_SIZE
+	cmp	\start, \end
 	blo	1b
-	mov	r0, #0
+	mov	\start, #0
+	.endm
+
+	.macro v6_dma_clean_range, start, end
+	bic	\start, \start, #D_CACHE_LINE_SIZE - 1
+1:
+#ifdef HARVARD_CACHE
+	mcr	p15, 0, \start, c7, c10, 1	@ clean D line
+#else
+	mcr	p15, 0, \start, c7, c11, 1	@ clean unified line
+#endif
+	add	\start, \start, #D_CACHE_LINE_SIZE
+	cmp	\start, \end
+	blo	1b
+	mov	\start, #0
+	.endm
+
+/*
+ *	v6_dma_inv_range_barrier(start,end)
+ *
+ *	Invalidate the data cache within the specified region; we will
+ *	be performing a DMA operation in this region and we want to
+ *	purge old data in the cache.
+ *
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+v6_dma_inv_range_barrier:
+	v6_dma_inv_range r0, r1
 	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
- *	v6_dma_clean_range(start,end)
+ *	v6_dma_clean_range_barrier(start,end)
  *	- start   - virtual start address of region
  *	- end     - virtual end address of region
  */
-v6_dma_clean_range:
-	bic	r0, r0, #D_CACHE_LINE_SIZE - 1
-1:
-#ifdef HARVARD_CACHE
-	mcr	p15, 0, r0, c7, c10, 1		@ clean D line
-#else
-	mcr	p15, 0, r0, c7, c11, 1		@ clean unified line
-#endif
-	add	r0, r0, #D_CACHE_LINE_SIZE
-	cmp	r0, r1
-	blo	1b
-	mov	r0, #0
+v6_dma_clean_range_barrier:
+	v6_dma_clean_range r0, r1
 	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
+ *	v6_dma_inv_range_nobarrier(start,end)
+ *
+ *	Invalidate the data cache within the specified region; we will
+ *	be performing a DMA operation in this region and we want to
+ *	purge old data in the cache.
+ *
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+v6_dma_inv_range_nobarrier:
+	v6_dma_inv_range r0, r1
+	mov	pc, lr
+
+/*
+ *	v6_dma_clean_range_nobarrier(start,end)
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+v6_dma_clean_range_nobarrier:
+	v6_dma_clean_range r0, r1
+	mov	pc, lr
+
+/*
  *	v6_dma_flush_range(start,end)
  *	- start   - virtual start address of region
  *	- end     - virtual end address of region
@@ -272,8 +303,8 @@ ENTRY(v6_dma_flush_range)
 ENTRY(v6_dma_map_area)
 	add	r1, r1, r0
 	teq	r2, #DMA_FROM_DEVICE
-	beq	v6_dma_inv_range
-	b	v6_dma_clean_range
+	beq	v6_dma_inv_range_barrier
+	b	v6_dma_clean_range_barrier
 ENDPROC(v6_dma_map_area)
 
 /*
@@ -285,10 +316,36 @@ ENDPROC(v6_dma_map_area)
 ENTRY(v6_dma_unmap_area)
 	add	r1, r1, r0
 	teq	r2, #DMA_TO_DEVICE
-	bne	v6_dma_inv_range
+	bne	v6_dma_inv_range_barrier
 	mov	pc, lr
 ENDPROC(v6_dma_unmap_area)
 
+/*
+ *	dma_map_area_nobarrier(start, size, dir)
+ *	- start	- kernel virtual start address
+ *	- size	- size of region
+ *	- dir	- DMA direction
+ */
+ENTRY(v6_dma_map_area_nobarrier)
+	add	r1, r1, r0
+	teq	r2, #DMA_FROM_DEVICE
+	beq	v6_dma_inv_range_nobarrier
+	b	v6_dma_clean_range_nobarrier
+ENDPROC(v6_dma_map_area_nobarrier)
+
+/*
+ *	dma_unmap_area_nobarrier(start, size, dir)
+ *	- start	- kernel virtual start address
+ *	- size	- size of region
+ *	- dir	- DMA direction
+ */
+ENTRY(v6_dma_unmap_area_nobarrier)
+	add	r1, r1, r0
+	teq	r2, #DMA_TO_DEVICE
+	bne	v6_dma_inv_range_nobarrier
+	mov	pc, lr
+ENDPROC(v6_dma_unmap_area_nobarrier)
+
 	__INITDATA
 
 	.type	v6_cache_fns, #object
@@ -301,5 +358,7 @@ ENTRY(v6_cache_fns)
 	.long	v6_flush_kern_dcache_area
 	.long	v6_dma_map_area
 	.long	v6_dma_unmap_area
+	.long	v6_dma_map_area_nobarrier
+	.long	v6_dma_unmap_area_nobarrier
 	.long	v6_dma_flush_range
 	.size	v6_cache_fns, . - v6_cache_fns
diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
index bcd64f2..d748137 100644
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -206,8 +206,33 @@ ENTRY(v7_flush_kern_dcache_area)
 	mov	pc, lr
 ENDPROC(v7_flush_kern_dcache_area)
 
+	.macro	v7_dma_inv_range, start, end, line_size, tmp
+	sub	\tmp, \line_size, #1
+	tst	\start, \line_size
+	bic	\start, \start, \tmp
+	mcrne	p15, 0, \start, c7, c14, 1	@ clean & invalidate D / U line
+
+	tst	\end, \tmp
+	bic	\end, \end, \tmp
+	mcrne	p15, 0, \end, c7, c14, 1	@ clean & invalidate D / U line
+1:
+	mcr	p15, 0, \start, c7, c6, 1	@ invalidate D / U line
+	add	\start, \start, \line_size
+	cmp	\start, \end
+	blo	1b
+	.endm
+
+	.macro	v7_dma_clean_range, start, end, line_size, tmp
+	sub	\tmp, \line_size, #1
+	bic	\start, \start, \tmp
+1:
+	mcr	p15, 0, \start, c7, c10, 1	@ clean D / U line
+	add	\start, \start, \line_size
+	cmp	\start, \end
+	blo	1b
+	.endm
 /*
- *	v7_dma_inv_range(start,end)
+ *	v7_dma_inv_range_barrier(start,end)
  *
  *	Invalidate the data cache within the specified region; we will
  *	be performing a DMA operation in this region and we want to
@@ -216,42 +241,51 @@ ENDPROC(v7_flush_kern_dcache_area)
  *	- start   - virtual start address of region
  *	- end     - virtual end address of region
  */
-v7_dma_inv_range:
+v7_dma_inv_range_barrier:
 	dcache_line_size r2, r3
-	sub	r3, r2, #1
-	tst	r0, r3
-	bic	r0, r0, r3
-	mcrne	p15, 0, r0, c7, c14, 1		@ clean & invalidate D / U line
-
-	tst	r1, r3
-	bic	r1, r1, r3
-	mcrne	p15, 0, r1, c7, c14, 1		@ clean & invalidate D / U line
-1:
-	mcr	p15, 0, r0, c7, c6, 1		@ invalidate D / U line
-	add	r0, r0, r2
-	cmp	r0, r1
-	blo	1b
+	v7_dma_inv_range r0, r1, r2, r3
 	dsb
 	mov	pc, lr
-ENDPROC(v7_dma_inv_range)
+ENDPROC(v7_dma_inv_range_barrier)
 
 /*
- *	v7_dma_clean_range(start,end)
+ *	v7_dma_clean_range_barrier(start,end)
  *	- start   - virtual start address of region
  *	- end     - virtual end address of region
  */
-v7_dma_clean_range:
+v7_dma_clean_range_barrier:
 	dcache_line_size r2, r3
-	sub	r3, r2, #1
-	bic	r0, r0, r3
-1:
-	mcr	p15, 0, r0, c7, c10, 1		@ clean D / U line
-	add	r0, r0, r2
-	cmp	r0, r1
-	blo	1b
+	v7_dma_clean_range r0, r1, r2 ,r3
 	dsb
 	mov	pc, lr
-ENDPROC(v7_dma_clean_range)
+ENDPROC(v7_dma_clean_range_barrier)
+
+/*
+ *	v7_dma_inv_range_nobarrier(start,end)
+ *
+ *	Invalidate the data cache within the specified region; we will
+ *	be performing a DMA operation in this region and we want to
+ *	purge old data in the cache.
+ *
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+v7_dma_inv_range_nobarrier:
+	dcache_line_size r2, r3
+	v7_dma_inv_range r0, r1, r2, r3
+	mov	pc, lr
+ENDPROC(v7_dma_inv_range_nobarrier)
+
+/*
+ *	v7_dma_clean_range_nobarrier(start,end)
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+v7_dma_clean_range_nobarrier:
+	dcache_line_size r2, r3
+	v7_dma_clean_range r0, r1, r2 ,r3
+	mov	pc, lr
+ENDPROC(v7_dma_clean_range_nobarrier)
 
 /*
  *	v7_dma_flush_range(start,end)
@@ -280,8 +314,8 @@ ENDPROC(v7_dma_flush_range)
 ENTRY(v7_dma_map_area)
 	add	r1, r1, r0
 	teq	r2, #DMA_FROM_DEVICE
-	beq	v7_dma_inv_range
-	b	v7_dma_clean_range
+	beq	v7_dma_inv_range_barrier
+	b	v7_dma_clean_range_barrier
 ENDPROC(v7_dma_map_area)
 
 /*
@@ -293,10 +327,36 @@ ENDPROC(v7_dma_map_area)
 ENTRY(v7_dma_unmap_area)
 	add	r1, r1, r0
 	teq	r2, #DMA_TO_DEVICE
-	bne	v7_dma_inv_range
+	bne	v7_dma_inv_range_barrier
 	mov	pc, lr
 ENDPROC(v7_dma_unmap_area)
 
+/*
+ *	dma_map_area_nobarrier(start, size, dir)
+ *	- start	- kernel virtual start address
+ *	- size	- size of region
+ *	- dir	- DMA direction
+ */
+ENTRY(v7_dma_map_area_nobarrier)
+	add	r1, r1, r0
+	teq	r2, #DMA_FROM_DEVICE
+	beq	v7_dma_inv_range_nobarrier
+	b	v7_dma_clean_range_nobarrier
+ENDPROC(v7_dma_map_area_nobarrier)
+
+/*
+ *	dma_unmap_area_nobarrier(start, size, dir)
+ *	- start	- kernel virtual start address
+ *	- size	- size of region
+ *	- dir	- DMA direction
+ */
+ENTRY(v7_dma_unmap_area_nobarrier)
+	add	r1, r1, r0
+	teq	r2, #DMA_TO_DEVICE
+	bne	v7_dma_inv_range_nobarrier
+	mov	pc, lr
+ENDPROC(v7_dma_unmap_area_nobarrier)
+
 	__INITDATA
 
 	.type	v7_cache_fns, #object
@@ -309,5 +369,7 @@ ENTRY(v7_cache_fns)
 	.long	v7_flush_kern_dcache_area
 	.long	v7_dma_map_area
 	.long	v7_dma_unmap_area
+	.long	v7_dma_map_area_nobarrier
+	.long	v7_dma_unmap_area_nobarrier
 	.long	v7_dma_flush_range
 	.size	v7_cache_fns, . - v7_cache_fns
-- 
1.5.6.3

