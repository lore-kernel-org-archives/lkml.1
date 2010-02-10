Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab0BJX50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 18:57:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38249 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab0BJX5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 18:57:24 -0500
Date: Wed, 10 Feb 2010 23:57:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC 0/2] fix dma_map_sg not to do barriers for each buffer
Message-ID: <20100210235700.GD30854@n2100.arm.linux.org.uk>
References: <1265834250-29170-1-git-send-email-adharmap@codeaurora.org> <20100210212156.GB30854@n2100.arm.linux.org.uk> <4B734111.6070206@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B734111.6070206@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 03:28:17PM -0800, Abhijeet Dharmapurikar wrote:
> This would call the barrier in addition to the ones executed by  
> dma_map_page.
>
> We would need to call __dma_page_cpu_to_dev instead of dma_map_page and  
> do the barrier before returning.

It's not that simple because of the dmabounce crap.  Ho hum, let's add
yet another layer of indirection for it.

 arch/arm/include/asm/cacheflush.h  |    4 ++++
 arch/arm/include/asm/dma-mapping.h |   19 +++++++++++++++++--
 arch/arm/mm/cache-fa.S             |   13 +++++++------
 arch/arm/mm/cache-v3.S             |    3 +++
 arch/arm/mm/cache-v4.S             |    3 +++
 arch/arm/mm/cache-v4wb.S           |    9 +++++++--
 arch/arm/mm/cache-v4wt.S           |    3 +++
 arch/arm/mm/cache-v6.S             |   13 +++++++------
 arch/arm/mm/cache-v7.S             |    9 ++++++---
 arch/arm/mm/dma-mapping.c          |   18 +++++++++++++++++-
 arch/arm/mm/proc-arm1020e.S        |   10 +++++++---
 arch/arm/mm/proc-arm1022.S         |   10 +++++++---
 arch/arm/mm/proc-arm1026.S         |   10 +++++++---
 arch/arm/mm/proc-arm920.S          |   10 +++++++---
 arch/arm/mm/proc-arm922.S          |   10 +++++++---
 arch/arm/mm/proc-arm925.S          |   10 +++++++---
 arch/arm/mm/proc-arm926.S          |   10 +++++++---
 arch/arm/mm/proc-arm940.S          |   10 +++++++---
 arch/arm/mm/proc-arm946.S          |   10 +++++++---
 arch/arm/mm/proc-feroceon.S        |   13 ++++++++-----
 arch/arm/mm/proc-mohawk.S          |   10 +++++++---
 arch/arm/mm/proc-xsc3.S            |   10 +++++++---
 arch/arm/mm/proc-xscale.S          |   10 +++++++---
 23 files changed, 166 insertions(+), 61 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index e290885..5928e78 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -200,6 +200,7 @@ struct cpu_cache_fns {
 
 	void (*dma_map_area)(const void *, size_t, int);
 	void (*dma_unmap_area)(const void *, size_t, int);
+	void (*dma_barrier)(void);
 
 	void (*dma_flush_range)(const void *, const void *);
 };
@@ -232,6 +233,7 @@ extern struct cpu_cache_fns cpu_cache;
  */
 #define dmac_map_area			cpu_cache.dma_map_area
 #define dmac_unmap_area		cpu_cache.dma_unmap_area
+#define dmac_barrier			cpu_cache.dma_barrier
 #define dmac_flush_range		cpu_cache.dma_flush_range
 
 #else
@@ -258,10 +260,12 @@ extern void __cpuc_flush_dcache_area(void *, size_t);
  */
 #define dmac_map_area			__glue(_CACHE,_dma_map_area)
 #define dmac_unmap_area		__glue(_CACHE,_dma_unmap_area)
+#define dmac_barrier			__glue(_CACHE,_dma_barrier)
 #define dmac_flush_range		__glue(_CACHE,_dma_flush_range)
 
 extern void dmac_map_area(const void *, size_t, int);
 extern void dmac_unmap_area(const void *, size_t, int);
+extern void dmac_barrier(void);
 extern void dmac_flush_range(const void *, const void *);
 
 #endif
diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 256ee1c..1371db7 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -110,6 +110,8 @@ static inline void __dma_page_dev_to_cpu(struct page *page, unsigned long off,
 		___dma_page_dev_to_cpu(page, off, size, dir);
 }
 
+extern void __dma_barrier(enum dma_data_direction);
+
 /*
  * Return whether the given device DMA address mask can be supported
  * properly.  For example, if your device can only drive the low 24-bits
@@ -299,7 +301,7 @@ extern dma_addr_t dma_map_single(struct device *, void *, size_t,
 		enum dma_data_direction);
 extern void dma_unmap_single(struct device *, dma_addr_t, size_t,
 		enum dma_data_direction);
-extern dma_addr_t dma_map_page(struct device *, struct page *,
+extern dma_addr_t __dma_map_page(struct device *, struct page *,
 		unsigned long, size_t, enum dma_data_direction);
 extern void dma_unmap_page(struct device *, dma_addr_t, size_t,
 		enum dma_data_direction);
@@ -345,6 +347,7 @@ static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
 	BUG_ON(!valid_dma_direction(dir));
 
 	__dma_single_cpu_to_dev(cpu_addr, size, dir);
+	__dma_barrier(dir);
 
 	return virt_to_dma(dev, cpu_addr);
 }
@@ -363,7 +366,7 @@ static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
  * The device owns this memory once this call has completed.  The CPU
  * can regain ownership by calling dma_unmap_page().
  */
-static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
+static inline dma_addr_t __dma_map_page(struct device *dev, struct page *page,
 	     unsigned long offset, size_t size, enum dma_data_direction dir)
 {
 	BUG_ON(!valid_dma_direction(dir));
@@ -373,6 +376,14 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 	return page_to_dma(dev, page) + offset;
 }
 
+static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
+	     unsigned long offset, size_t size, enum dma_data_direction dir)
+{
+	dma_addr_t addr = __dma_map_page(page, offset, size, dir);
+	__dma_barrier(dir);
+	return addr;
+}
+
 /**
  * dma_unmap_single - unmap a single buffer previously mapped
  * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
@@ -391,6 +402,7 @@ static inline void dma_unmap_single(struct device *dev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir)
 {
 	__dma_single_dev_to_cpu(dma_to_virt(dev, handle), size, dir);
+	__dma_barrier(dir);
 }
 
 /**
@@ -412,6 +424,7 @@ static inline void dma_unmap_page(struct device *dev, dma_addr_t handle,
 {
 	__dma_page_dev_to_cpu(dma_to_page(dev, handle), handle & ~PAGE_MASK,
 		size, dir);
+	__dma_barrier(dir);
 }
 #endif /* CONFIG_DMABOUNCE */
 
@@ -443,6 +456,7 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 		return;
 
 	__dma_single_dev_to_cpu(dma_to_virt(dev, handle) + offset, size, dir);
+	__dma_barrier(dir);
 }
 
 static inline void dma_sync_single_range_for_device(struct device *dev,
@@ -455,6 +469,7 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 		return;
 
 	__dma_single_cpu_to_dev(dma_to_virt(dev, handle) + offset, size, dir);
+	__dma_barrier(dir);
 }
 
 static inline void dma_sync_single_for_cpu(struct device *dev,
diff --git a/arch/arm/mm/cache-fa.S b/arch/arm/mm/cache-fa.S
index 7148e53..cdcfae2 100644
--- a/arch/arm/mm/cache-fa.S
+++ b/arch/arm/mm/cache-fa.S
@@ -168,8 +168,6 @@ fa_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -186,8 +184,6 @@ fa_dma_clean_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mov	r0, #0	
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -201,8 +197,6 @@ ENTRY(fa_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mov	r0, #0	
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -229,6 +223,12 @@ ENTRY(fa_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(fa_dma_unmap_area)
 
+ENTRY(fa_dma_barrier)
+	mov	r0, #0	
+	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
+	mov	pc, lr
+ENDPROC(fa_dma_barrier)
+
 	__INITDATA
 
 	.type	fa_cache_fns, #object
@@ -241,5 +241,6 @@ ENTRY(fa_cache_fns)
 	.long	fa_flush_kern_dcache_area
 	.long	fa_dma_map_area
 	.long	fa_dma_unmap_area
+	.long	fa_dma_barrier
 	.long	fa_dma_flush_range
 	.size	fa_cache_fns, . - fa_cache_fns
diff --git a/arch/arm/mm/cache-v3.S b/arch/arm/mm/cache-v3.S
index c2ff3c5..df34458 100644
--- a/arch/arm/mm/cache-v3.S
+++ b/arch/arm/mm/cache-v3.S
@@ -114,9 +114,11 @@ ENTRY(v3_dma_unmap_area)
  *	- dir	- DMA direction
  */
 ENTRY(v3_dma_map_area)
+ENTRY(v3_dma_barrier)
 	mov	pc, lr
 ENDPROC(v3_dma_unmap_area)
 ENDPROC(v3_dma_map_area)
+ENDPROC(v3_dma_barrier)
 
 	__INITDATA
 
@@ -130,5 +132,6 @@ ENTRY(v3_cache_fns)
 	.long	v3_flush_kern_dcache_area
 	.long	v3_dma_map_area
 	.long	v3_dma_unmap_area
+	.long	v3_dma_barrier
 	.long	v3_dma_flush_range
 	.size	v3_cache_fns, . - v3_cache_fns
diff --git a/arch/arm/mm/cache-v4.S b/arch/arm/mm/cache-v4.S
index 4810f7e..20260b1 100644
--- a/arch/arm/mm/cache-v4.S
+++ b/arch/arm/mm/cache-v4.S
@@ -126,9 +126,11 @@ ENTRY(v4_dma_unmap_area)
  *	- dir	- DMA direction
  */
 ENTRY(v4_dma_map_area)
+ENTRY(v4_dma_barrier)
 	mov	pc, lr
 ENDPROC(v4_dma_unmap_area)
 ENDPROC(v4_dma_map_area)
+ENDPROC(v4_dma_barrier)
 
 	__INITDATA
 
@@ -142,5 +144,6 @@ ENTRY(v4_cache_fns)
 	.long	v4_flush_kern_dcache_area
 	.long	v4_dma_map_area
 	.long	v4_dma_unmap_area
+	.long	v4_dma_barrier
 	.long	v4_dma_flush_range
 	.size	v4_cache_fns, . - v4_cache_fns
diff --git a/arch/arm/mm/cache-v4wb.S b/arch/arm/mm/cache-v4wb.S
index df8368a..9c9c875 100644
--- a/arch/arm/mm/cache-v4wb.S
+++ b/arch/arm/mm/cache-v4wb.S
@@ -183,7 +183,6 @@ v4wb_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -200,7 +199,6 @@ v4wb_dma_clean_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -240,6 +238,12 @@ ENTRY(v4wb_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(v4wb_dma_unmap_area)
 
+ENTRY(v4wb_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
+	mov	pc, lr
+ENDPROC(v4wb_dma_barrier)
+
 	__INITDATA
 
 	.type	v4wb_cache_fns, #object
@@ -252,5 +256,6 @@ ENTRY(v4wb_cache_fns)
 	.long	v4wb_flush_kern_dcache_area
 	.long	v4wb_dma_map_area
 	.long	v4wb_dma_unmap_area
+	.long	v4wb_dma_barrier
 	.long	v4wb_dma_flush_range
 	.size	v4wb_cache_fns, . - v4wb_cache_fns
diff --git a/arch/arm/mm/cache-v4wt.S b/arch/arm/mm/cache-v4wt.S
index 45c7031..223eea4 100644
--- a/arch/arm/mm/cache-v4wt.S
+++ b/arch/arm/mm/cache-v4wt.S
@@ -180,9 +180,11 @@ ENTRY(v4wt_dma_unmap_area)
  *	- dir	- DMA direction
  */
 ENTRY(v4wt_dma_map_area)
+ENTRY(v4wt_dma_barrier)
 	mov	pc, lr
 ENDPROC(v4wt_dma_unmap_area)
 ENDPROC(v4wt_dma_map_area)
+ENDPROC(v4wt_dma_barrier)
 
 	__INITDATA
 
@@ -196,5 +198,6 @@ ENTRY(v4wt_cache_fns)
 	.long	v4wt_flush_kern_dcache_area
 	.long	v4wt_dma_map_area
 	.long	v4wt_dma_unmap_area
+	.long	v4wt_dma_barrier
 	.long	v4wt_dma_flush_range
 	.size	v4wt_cache_fns, . - v4wt_cache_fns
diff --git a/arch/arm/mm/cache-v6.S b/arch/arm/mm/cache-v6.S
index 9d89c67..b294854 100644
--- a/arch/arm/mm/cache-v6.S
+++ b/arch/arm/mm/cache-v6.S
@@ -219,8 +219,6 @@ v6_dma_inv_range:
 	add	r0, r0, #D_CACHE_LINE_SIZE
 	cmp	r0, r1
 	blo	1b
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -239,8 +237,6 @@ v6_dma_clean_range:
 	add	r0, r0, #D_CACHE_LINE_SIZE
 	cmp	r0, r1
 	blo	1b
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -259,8 +255,6 @@ ENTRY(v6_dma_flush_range)
 	add	r0, r0, #D_CACHE_LINE_SIZE
 	cmp	r0, r1
 	blo	1b
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -289,6 +283,12 @@ ENTRY(v6_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(v6_dma_unmap_area)
 
+ENTRY(v6_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
+	mov	pc, lr
+ENDPROC(v6_dma_barrier)
+
 	__INITDATA
 
 	.type	v6_cache_fns, #object
@@ -301,5 +301,6 @@ ENTRY(v6_cache_fns)
 	.long	v6_flush_kern_dcache_area
 	.long	v6_dma_map_area
 	.long	v6_dma_unmap_area
+	.long	v6_dma_barrier
 	.long	v6_dma_flush_range
 	.size	v6_cache_fns, . - v6_cache_fns
diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
index bcd64f2..d89d55a 100644
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -231,7 +231,6 @@ v7_dma_inv_range:
 	add	r0, r0, r2
 	cmp	r0, r1
 	blo	1b
-	dsb
 	mov	pc, lr
 ENDPROC(v7_dma_inv_range)
 
@@ -249,7 +248,6 @@ v7_dma_clean_range:
 	add	r0, r0, r2
 	cmp	r0, r1
 	blo	1b
-	dsb
 	mov	pc, lr
 ENDPROC(v7_dma_clean_range)
 
@@ -267,7 +265,6 @@ ENTRY(v7_dma_flush_range)
 	add	r0, r0, r2
 	cmp	r0, r1
 	blo	1b
-	dsb
 	mov	pc, lr
 ENDPROC(v7_dma_flush_range)
 
@@ -297,6 +294,11 @@ ENTRY(v7_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(v7_dma_unmap_area)
 
+ENTRY(v7_dma_barrier)
+	dsb
+	mov	pc, lr
+ENDPROC(v7_dma_barrier)
+
 	__INITDATA
 
 	.type	v7_cache_fns, #object
@@ -309,5 +311,6 @@ ENTRY(v7_cache_fns)
 	.long	v7_flush_kern_dcache_area
 	.long	v7_dma_map_area
 	.long	v7_dma_unmap_area
+	.long	v6_dma_barrier
 	.long	v7_dma_flush_range
 	.size	v7_cache_fns, . - v7_cache_fns
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 64daef2..d807f38 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -108,6 +108,7 @@ static struct page *__dma_alloc_buffer(struct device *dev, size_t size, gfp_t gf
 	memset(ptr, 0, size);
 	dmac_flush_range(ptr, ptr + size);
 	outer_flush_range(__pa(ptr), __pa(ptr) + size);
+	dmac_barrier();
 
 	return page;
 }
@@ -509,6 +510,12 @@ void ___dma_page_dev_to_cpu(struct page *page, unsigned long off,
 }
 EXPORT_SYMBOL(___dma_page_dev_to_cpu);
 
+void __dma_barrier(enum dma_data_direction dir)
+{
+	dmac_barrier();
+}
+EXPORT_SYMBOL(__dma_barrier);
+
 /**
  * dma_map_sg - map a set of SG buffers for streaming mode DMA
  * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
@@ -532,11 +539,14 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	int i, j;
 
 	for_each_sg(sg, s, nents, i) {
-		s->dma_address = dma_map_page(dev, sg_page(s), s->offset,
+		s->dma_address = __dma_map_page(dev, sg_page(s), s->offset,
 						s->length, dir);
 		if (dma_mapping_error(dev, s->dma_address))
 			goto bad_mapping;
 	}
+
+	__dma_barrier(dir);
+
 	return nents;
 
  bad_mapping:
@@ -564,6 +574,8 @@ void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
 
 	for_each_sg(sg, s, nents, i)
 		dma_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir);
+
+	__dma_barrier(dir);
 }
 EXPORT_SYMBOL(dma_unmap_sg);
 
@@ -588,6 +600,8 @@ void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 		__dma_page_dev_to_cpu(sg_page(s), s->offset,
 				      s->length, dir);
 	}
+
+	__dma_barrier(dir);
 }
 EXPORT_SYMBOL(dma_sync_sg_for_cpu);
 
@@ -612,5 +626,7 @@ void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 		__dma_page_cpu_to_dev(sg_page(s), s->offset,
 				      s->length, dir);
 	}
+
+	__dma_barrier(dir);
 }
 EXPORT_SYMBOL(dma_sync_sg_for_device);
diff --git a/arch/arm/mm/proc-arm1020e.S b/arch/arm/mm/proc-arm1020e.S
index d278298..fea33c9 100644
--- a/arch/arm/mm/proc-arm1020e.S
+++ b/arch/arm/mm/proc-arm1020e.S
@@ -271,7 +271,6 @@ arm1020e_dma_inv_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -293,7 +292,6 @@ arm1020e_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -313,7 +311,6 @@ ENTRY(arm1020e_dma_flush_range)
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -340,6 +337,12 @@ ENTRY(arm1020e_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm1020e_dma_unmap_area)
 
+ENTRY(arm1020e_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm1020e_dma_barrier)
+
 ENTRY(arm1020e_cache_fns)
 	.long	arm1020e_flush_kern_cache_all
 	.long	arm1020e_flush_user_cache_all
@@ -349,6 +352,7 @@ ENTRY(arm1020e_cache_fns)
 	.long	arm1020e_flush_kern_dcache_area
 	.long	arm1020e_dma_map_area
 	.long	arm1020e_dma_unmap_area
+	.long	arm1020e_dma_barrier
 	.long	arm1020e_dma_flush_range
 
 	.align	5
diff --git a/arch/arm/mm/proc-arm1022.S b/arch/arm/mm/proc-arm1022.S
index ce13e4a..ba1a7df 100644
--- a/arch/arm/mm/proc-arm1022.S
+++ b/arch/arm/mm/proc-arm1022.S
@@ -260,7 +260,6 @@ arm1022_dma_inv_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -282,7 +281,6 @@ arm1022_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -302,7 +300,6 @@ ENTRY(arm1022_dma_flush_range)
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -329,6 +326,12 @@ ENTRY(arm1022_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm1022_dma_unmap_area)
 
+ENTRY(arm1022_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm1022_dma_barrier)
+
 ENTRY(arm1022_cache_fns)
 	.long	arm1022_flush_kern_cache_all
 	.long	arm1022_flush_user_cache_all
@@ -338,6 +341,7 @@ ENTRY(arm1022_cache_fns)
 	.long	arm1022_flush_kern_dcache_area
 	.long	arm1022_dma_map_area
 	.long	arm1022_dma_unmap_area
+	.long	arm1022_dma_barrier
 	.long	arm1022_dma_flush_range
 
 	.align	5
diff --git a/arch/arm/mm/proc-arm1026.S b/arch/arm/mm/proc-arm1026.S
index 636672a..de648f1 100644
--- a/arch/arm/mm/proc-arm1026.S
+++ b/arch/arm/mm/proc-arm1026.S
@@ -254,7 +254,6 @@ arm1026_dma_inv_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -276,7 +275,6 @@ arm1026_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -296,7 +294,6 @@ ENTRY(arm1026_dma_flush_range)
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -323,6 +320,12 @@ ENTRY(arm1026_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm1026_dma_unmap_area)
 
+ENTRY(arm1026_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm1026_dma_barrier)
+
 ENTRY(arm1026_cache_fns)
 	.long	arm1026_flush_kern_cache_all
 	.long	arm1026_flush_user_cache_all
@@ -332,6 +335,7 @@ ENTRY(arm1026_cache_fns)
 	.long	arm1026_flush_kern_dcache_area
 	.long	arm1026_dma_map_area
 	.long	arm1026_dma_unmap_area
+	.long	arm1026_dma_barrier
 	.long	arm1026_dma_flush_range
 
 	.align	5
diff --git a/arch/arm/mm/proc-arm920.S b/arch/arm/mm/proc-arm920.S
index 8be8199..ec74093 100644
--- a/arch/arm/mm/proc-arm920.S
+++ b/arch/arm/mm/proc-arm920.S
@@ -249,7 +249,6 @@ arm920_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -268,7 +267,6 @@ arm920_dma_clean_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -285,7 +283,6 @@ ENTRY(arm920_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -312,6 +309,12 @@ ENTRY(arm920_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm920_dma_unmap_area)
 
+ENTRY(arm920_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm920_dma_barrier)
+
 ENTRY(arm920_cache_fns)
 	.long	arm920_flush_kern_cache_all
 	.long	arm920_flush_user_cache_all
@@ -321,6 +324,7 @@ ENTRY(arm920_cache_fns)
 	.long	arm920_flush_kern_dcache_area
 	.long	arm920_dma_map_area
 	.long	arm920_dma_unmap_area
+	.long	arm920_dma_barrier
 	.long	arm920_dma_flush_range
 
 #endif
diff --git a/arch/arm/mm/proc-arm922.S b/arch/arm/mm/proc-arm922.S
index c0ff8e4..474d4c6 100644
--- a/arch/arm/mm/proc-arm922.S
+++ b/arch/arm/mm/proc-arm922.S
@@ -251,7 +251,6 @@ arm922_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -270,7 +269,6 @@ arm922_dma_clean_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -287,7 +285,6 @@ ENTRY(arm922_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -314,6 +311,12 @@ ENTRY(arm922_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm922_dma_unmap_area)
 
+ENTRY(arm922_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm922_dma_barrier)
+
 ENTRY(arm922_cache_fns)
 	.long	arm922_flush_kern_cache_all
 	.long	arm922_flush_user_cache_all
@@ -323,6 +326,7 @@ ENTRY(arm922_cache_fns)
 	.long	arm922_flush_kern_dcache_area
 	.long	arm922_dma_map_area
 	.long	arm922_dma_unmap_area
+	.long	arm922_dma_barrier
 	.long	arm922_dma_flush_range
 
 #endif
diff --git a/arch/arm/mm/proc-arm925.S b/arch/arm/mm/proc-arm925.S
index 3c6cffe..0336ae3 100644
--- a/arch/arm/mm/proc-arm925.S
+++ b/arch/arm/mm/proc-arm925.S
@@ -295,7 +295,6 @@ arm925_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -316,7 +315,6 @@ arm925_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -338,7 +336,6 @@ ENTRY(arm925_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -365,6 +362,12 @@ ENTRY(arm925_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm925_dma_unmap_area)
 
+ENTRY(arm925_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm925_dma_barrier)
+
 ENTRY(arm925_cache_fns)
 	.long	arm925_flush_kern_cache_all
 	.long	arm925_flush_user_cache_all
@@ -374,6 +377,7 @@ ENTRY(arm925_cache_fns)
 	.long	arm925_flush_kern_dcache_area
 	.long	arm925_dma_map_area
 	.long	arm925_dma_unmap_area
+	.long	arm925_dma_barrier
 	.long	arm925_dma_flush_range
 
 ENTRY(cpu_arm925_dcache_clean_area)
diff --git a/arch/arm/mm/proc-arm926.S b/arch/arm/mm/proc-arm926.S
index 75b707c..473bbe6 100644
--- a/arch/arm/mm/proc-arm926.S
+++ b/arch/arm/mm/proc-arm926.S
@@ -258,7 +258,6 @@ arm926_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -279,7 +278,6 @@ arm926_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -301,7 +299,6 @@ ENTRY(arm926_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -328,6 +325,12 @@ ENTRY(arm926_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm926_dma_unmap_area)
 
+ENTRY(arm926_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm926_dma_barrier)
+
 ENTRY(arm926_cache_fns)
 	.long	arm926_flush_kern_cache_all
 	.long	arm926_flush_user_cache_all
@@ -337,6 +340,7 @@ ENTRY(arm926_cache_fns)
 	.long	arm926_flush_kern_dcache_area
 	.long	arm926_dma_map_area
 	.long	arm926_dma_unmap_area
+	.long	arm926_dma_barrier
 	.long	arm926_dma_flush_range
 
 ENTRY(cpu_arm926_dcache_clean_area)
diff --git a/arch/arm/mm/proc-arm940.S b/arch/arm/mm/proc-arm940.S
index 1af1657..c44c963 100644
--- a/arch/arm/mm/proc-arm940.S
+++ b/arch/arm/mm/proc-arm940.S
@@ -180,7 +180,6 @@ arm940_dma_inv_range:
 	bcs	2b				@ entries 63 to 0
 	subs	r1, r1, #1 << 4
 	bcs	1b				@ segments 7 to 0
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -204,7 +203,6 @@ ENTRY(cpu_arm940_dcache_clean_area)
 	subs	r1, r1, #1 << 4
 	bcs	1b				@ segments 7 to 0
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -230,7 +228,6 @@ ENTRY(arm940_dma_flush_range)
 	bcs	2b				@ entries 63 to 0
 	subs	r1, r1, #1 << 4
 	bcs	1b				@ segments 7 to 0
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -257,6 +254,12 @@ ENTRY(arm940_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm940_dma_unmap_area)
 
+ENTRY(arm940_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm940_dma_barrier)
+
 ENTRY(arm940_cache_fns)
 	.long	arm940_flush_kern_cache_all
 	.long	arm940_flush_user_cache_all
@@ -266,6 +269,7 @@ ENTRY(arm940_cache_fns)
 	.long	arm940_flush_kern_dcache_area
 	.long	arm940_dma_map_area
 	.long	arm940_dma_unmap_area
+	.long	arm940_dma_barrier
 	.long	arm940_dma_flush_range
 
 	__INIT
diff --git a/arch/arm/mm/proc-arm946.S b/arch/arm/mm/proc-arm946.S
index 1664b6a..11e9ad7 100644
--- a/arch/arm/mm/proc-arm946.S
+++ b/arch/arm/mm/proc-arm946.S
@@ -227,7 +227,6 @@ arm946_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -248,7 +247,6 @@ arm946_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -272,7 +270,6 @@ ENTRY(arm946_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -299,6 +296,12 @@ ENTRY(arm946_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm946_dma_unmap_area)
 
+ENTRY(arm946_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm946_dma_barrier)
+
 ENTRY(arm946_cache_fns)
 	.long	arm946_flush_kern_cache_all
 	.long	arm946_flush_user_cache_all
@@ -308,6 +311,7 @@ ENTRY(arm946_cache_fns)
 	.long	arm946_flush_kern_dcache_area
 	.long	arm946_dma_map_area
 	.long	arm946_dma_unmap_area
+	.long	arm946_dma_barrier
 	.long	arm946_dma_flush_range
 
 
diff --git a/arch/arm/mm/proc-feroceon.S b/arch/arm/mm/proc-feroceon.S
index 53e6323..50a309e 100644
--- a/arch/arm/mm/proc-feroceon.S
+++ b/arch/arm/mm/proc-feroceon.S
@@ -284,7 +284,6 @@ feroceon_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 	.align	5
@@ -320,7 +319,6 @@ feroceon_dma_clean_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 	.align	5
@@ -333,7 +331,6 @@ feroceon_range_dma_clean_range:
 	mcr	p15, 5, r0, c15, c13, 0		@ D clean range start
 	mcr	p15, 5, r1, c15, c13, 1		@ D clean range top
 	msr	cpsr_c, r2			@ restore interrupts
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -351,7 +348,6 @@ ENTRY(feroceon_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 	.align	5
@@ -364,7 +360,6 @@ ENTRY(feroceon_range_dma_flush_range)
 	mcr	p15, 5, r0, c15, c15, 0		@ D clean/inv range start
 	mcr	p15, 5, r1, c15, c15, 1		@ D clean/inv range top
 	msr	cpsr_c, r2			@ restore interrupts
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -405,6 +400,12 @@ ENTRY(feroceon_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(feroceon_dma_unmap_area)
 
+ENTRY(feroceon_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(feroceon_dma_barrier)
+
 ENTRY(feroceon_cache_fns)
 	.long	feroceon_flush_kern_cache_all
 	.long	feroceon_flush_user_cache_all
@@ -414,6 +415,7 @@ ENTRY(feroceon_cache_fns)
 	.long	feroceon_flush_kern_dcache_area
 	.long	feroceon_dma_map_area
 	.long	feroceon_dma_unmap_area
+	.long	feroceon_dma_barrier
 	.long	feroceon_dma_flush_range
 
 ENTRY(feroceon_range_cache_fns)
@@ -425,6 +427,7 @@ ENTRY(feroceon_range_cache_fns)
 	.long	feroceon_range_flush_kern_dcache_area
 	.long	feroceon_range_dma_map_area
 	.long	feroceon_dma_unmap_area
+	.long	feroceon_dma_barrier
 	.long	feroceon_range_dma_flush_range
 
 	.align	5
diff --git a/arch/arm/mm/proc-mohawk.S b/arch/arm/mm/proc-mohawk.S
index caa3115..09e8883 100644
--- a/arch/arm/mm/proc-mohawk.S
+++ b/arch/arm/mm/proc-mohawk.S
@@ -228,7 +228,6 @@ mohawk_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -247,7 +246,6 @@ mohawk_dma_clean_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -265,7 +263,6 @@ ENTRY(mohawk_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -292,6 +289,12 @@ ENTRY(mohawk_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(mohawk_dma_unmap_area)
 
+ENTRY(mohawk_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(mohawk_dma_barrier)
+
 ENTRY(mohawk_cache_fns)
 	.long	mohawk_flush_kern_cache_all
 	.long	mohawk_flush_user_cache_all
@@ -301,6 +304,7 @@ ENTRY(mohawk_cache_fns)
 	.long	mohawk_flush_kern_dcache_area
 	.long	mohawk_dma_map_area
 	.long	mohawk_dma_unmap_area
+	.long	mohawk_dma_barrier
 	.long	mohawk_dma_flush_range
 
 ENTRY(cpu_mohawk_dcache_clean_area)
diff --git a/arch/arm/mm/proc-xsc3.S b/arch/arm/mm/proc-xsc3.S
index 046b3d8..d033ed4 100644
--- a/arch/arm/mm/proc-xsc3.S
+++ b/arch/arm/mm/proc-xsc3.S
@@ -267,7 +267,6 @@ xsc3_dma_inv_range:
 	add	r0, r0, #CACHELINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ data write barrier
 	mov	pc, lr
 
 /*
@@ -284,7 +283,6 @@ xsc3_dma_clean_range:
 	add	r0, r0, #CACHELINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ data write barrier
 	mov	pc, lr
 
 /*
@@ -301,7 +299,6 @@ ENTRY(xsc3_dma_flush_range)
 	add	r0, r0, #CACHELINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ data write barrier
 	mov	pc, lr
 
 /*
@@ -328,6 +325,12 @@ ENTRY(xsc3_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(xsc3_dma_unmap_area)
 
+ENTRY(xsc3_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ data write barrier
+	mov	pc, lr
+ENDPROC(xsc3_dma_barrier)
+
 ENTRY(xsc3_cache_fns)
 	.long	xsc3_flush_kern_cache_all
 	.long	xsc3_flush_user_cache_all
@@ -337,6 +340,7 @@ ENTRY(xsc3_cache_fns)
 	.long	xsc3_flush_kern_dcache_area
 	.long	xsc3_dma_map_area
 	.long	xsc3_dma_unmap_area
+	.long	xsc3_dma_barrier
 	.long	xsc3_dma_flush_range
 
 ENTRY(cpu_xsc3_dcache_clean_area)
diff --git a/arch/arm/mm/proc-xscale.S b/arch/arm/mm/proc-xscale.S
index 63037e2..e390ae6 100644
--- a/arch/arm/mm/proc-xscale.S
+++ b/arch/arm/mm/proc-xscale.S
@@ -325,7 +325,6 @@ xscale_dma_inv_range:
 	add	r0, r0, #CACHELINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ Drain Write (& Fill) Buffer
 	mov	pc, lr
 
 /*
@@ -342,7 +341,6 @@ xscale_dma_clean_range:
 	add	r0, r0, #CACHELINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ Drain Write (& Fill) Buffer
 	mov	pc, lr
 
 /*
@@ -360,7 +358,6 @@ ENTRY(xscale_dma_flush_range)
 	add	r0, r0, #CACHELINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ Drain Write (& Fill) Buffer
 	mov	pc, lr
 
 /*
@@ -400,6 +397,12 @@ ENTRY(xscale_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(xscale_dma_unmap_area)
 
+ENTRY(xscale_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ Drain Write (& Fill) Buffer
+	mov	pc, lr
+ENDPROC(xscsale_dma_barrier)
+
 ENTRY(xscale_cache_fns)
 	.long	xscale_flush_kern_cache_all
 	.long	xscale_flush_user_cache_all
@@ -409,6 +412,7 @@ ENTRY(xscale_cache_fns)
 	.long	xscale_flush_kern_dcache_area
 	.long	xscale_dma_map_area
 	.long	xscale_dma_unmap_area
+	.long	xscale_dma_barrier
 	.long	xscale_dma_flush_range
 
 /*

