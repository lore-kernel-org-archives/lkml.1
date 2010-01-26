Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541Ab0AZEbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0AZEbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 23:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513Ab0AZEbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 23:31:10 -0500
Received: from gate.crashing.org ([63.228.1.57]:51335 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab0AZEbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 23:31:08 -0500
Subject: Re: [RFC PATCH] dma: Add barrierless dma mapping/unmapping api
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: adharmap@codeaurora.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
       dwalker@codeaurora.org, Arnd Bergmann <arnd@arndb.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joerg Roedel <joerg.roedel@amd.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Dan Williams <dan.j.williams@intel.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       Yang Hongyang <yanghy@cn.fujitsu.com>, linux-arch@vger.kernel.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
In-Reply-To: <1264473346-32721-1-git-send-email-adharmap@codeaurora.org>
References: <1264473346-32721-1-git-send-email-adharmap@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 15:30:10 +1100
Message-ID: <1264480210.3601.118.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 18:35 -0800, adharmap@codeaurora.org wrote:
> From: Abhijeet Dharmapurikar <adharmap@quicinc.com>
> 
> Tests have shown that there is a significant performance gain
> when a driver uses mapping/unmapping functions without a barrier
> multiple times and calls dsb() only after the last buffer. This
> api adds support for barrierless dma operations on ARMv6
> and ARMv7.

Gotta love when each architecture has subtely different barriers
semantics ...

This is ARM stuff at this stage and as such not a huge deal to me but I
don't like seeing new arch specific API extending generic ones for
drivers, it's just going to make it harder when those drivers start
using them and those devices are use on other archs.

There are people nowadays putting AXI bridges and the whole ARM
paraphernalia of IP cores behind them on PowerPC cores for example and I
can see that happening with x86 as well.

In your case, I believe your are fixing the wrong problem anyways. The
right approach would be instead to put all your buffer into an sglist
and use dma_map/unmap_sg().

So again, I'm no ARM maintainer, but heh, you CCed me, and as such, for
my part this is a nack...

Cheers,
Ben.

> Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> ---
> 
> Please refer to the earlier post here http://lkml.org/lkml/2010/1/4/347. 
> These changes only are only for the arm v6 and v7
> architecture and introduce dma_map/unmap_single_nobarrier api.
> The idea is to extend the cpu_cache_fns.dma_.*_range functions to accept 
> a third boolean argument that tells it whether to execute the barrier or
> skip it. Note that this applies over Linux 2.6.33-rc5 and needs a few changes
> to apply on the linux-next tree.
> 
> 
>  arch/arm/include/asm/cacheflush.h  |   12 ++++----
>  arch/arm/include/asm/dma-mapping.h |   57 ++++++++++++++++++++++++++++++++++--
>  arch/arm/mm/cache-v6.S             |   15 ++++++----
>  arch/arm/mm/cache-v7.S             |   19 +++++++++++-
>  arch/arm/mm/dma-mapping.c          |   17 ++++++-----
>  drivers/staging/dream/pmem.c       |    4 +-
>  6 files changed, 97 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
> index c77d2fa..59ce7fb 100644
> --- a/arch/arm/include/asm/cacheflush.h
> +++ b/arch/arm/include/asm/cacheflush.h
> @@ -227,9 +227,9 @@ struct cpu_cache_fns {
>  	void (*coherent_user_range)(unsigned long, unsigned long);
>  	void (*flush_kern_dcache_area)(void *, size_t);
>  
> -	void (*dma_inv_range)(const void *, const void *);
> -	void (*dma_clean_range)(const void *, const void *);
> -	void (*dma_flush_range)(const void *, const void *);
> +	void (*dma_inv_range)(const void *, const void *, unsigned long);
> +	void (*dma_clean_range)(const void *, const void *, unsigned long);
> +	void (*dma_flush_range)(const void *, const void *, unsigned long);
>  };
>  
>  struct outer_cache_fns {
> @@ -288,9 +288,9 @@ extern void __cpuc_flush_dcache_area(void *, size_t);
>  #define dmac_clean_range		__glue(_CACHE,_dma_clean_range)
>  #define dmac_flush_range		__glue(_CACHE,_dma_flush_range)
>  
> -extern void dmac_inv_range(const void *, const void *);
> -extern void dmac_clean_range(const void *, const void *);
> -extern void dmac_flush_range(const void *, const void *);
> +extern void dmac_inv_range(const void *, const void *, unsigned long);
> +extern void dmac_clean_range(const void *, const void *, unsigned long);
> +extern void dmac_flush_range(const void *, const void *, unsigned long);
>  
>  #endif
>  
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index a96300b..066923c 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -66,7 +66,8 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
>   * platforms with CONFIG_DMABOUNCE.
>   * Use the driver DMA support - see dma-mapping.h (dma_sync_*)
>   */
> -extern void dma_cache_maint(const void *kaddr, size_t size, int rw);
> +extern void dma_cache_maint(const void *kaddr, size_t size, int rw,
> +						unsigned long barrier);
>  extern void dma_cache_maint_page(struct page *page, unsigned long offset,
>  				 size_t size, int rw);
>  
> @@ -297,6 +298,7 @@ static inline int dmabounce_sync_for_device(struct device *d, dma_addr_t addr,
>   *
>   * The device owns this memory once this call has completed.  The CPU
>   * can regain ownership by calling dma_unmap_single() or
> + * or dma_unmap_single_nobarrier followed by dsb/dmb or
>   * dma_sync_single_for_cpu().
>   */
>  static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
> @@ -305,12 +307,40 @@ static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
>  	BUG_ON(!valid_dma_direction(dir));
>  
>  	if (!arch_is_coherent())
> -		dma_cache_maint(cpu_addr, size, dir);
> +		dma_cache_maint(cpu_addr, size, dir, 1);
>  
>  	return virt_to_dma(dev, cpu_addr);
>  }
>  
>  /**
> + * dma_map_single_nobarrier - map a single buffer for streaming DMA
> + * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
> + * @cpu_addr: CPU direct mapped address of buffer
> + * @size: size of buffer to map
> + * @dir: DMA transfer direction
> + *
> + * Ensure that any data held in the cache is appropriately discarded
> + * or written back.
> + *
> + * The device owns this memory once this call has completed and a dsb is
> + * executed.  The CPU
> + * can regain ownership by calling dma_unmap_single() or
> + * dma_map_single_nobarrier followed by dsb() or
> + * dma_sync_single_for_cpu().
> + */
> +static inline dma_addr_t dma_map_single_nobarrier(struct device *dev,
> +		void *cpu_addr, size_t size, enum dma_data_direction dir)
> +{
> +	BUG_ON(!valid_dma_direction(dir));
> +
> +	if (!arch_is_coherent())
> +		dma_cache_maint(cpu_addr, size, dir, 0);
> +
> +	return virt_to_dma(dev, cpu_addr);
> +}
> +
> +
> +/**
>   * dma_map_page - map a portion of a page for streaming DMA
>   * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
>   * @page: page that buffer resides in
> @@ -356,6 +386,26 @@ static inline void dma_unmap_single(struct device *dev, dma_addr_t handle,
>  }
>  
>  /**
> + * dma_unmap_single_nobarrier - unmap a single buffer previously mapped
> + * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
> + * @handle: DMA address of buffer
> + * @size: size of buffer (same as passed to dma_map_single)
> + * @dir: DMA transfer direction (same as passed to dma_map_single)
> + *
> + * Unmap a single streaming mode DMA translation.  The handle and size
> + * must match what was provided in the previous dma_map_single() call.
> + * All other usages are undefined.
> + *
> + * After this call, and a dsb(), reads by the CPU to the buffer are
> + * guaranteed to see  whatever the device wrote there.
> + */
> +static inline void dma_unmap_single_nobarrier(struct device *dev,
> +		dma_addr_t handle, size_t size, enum dma_data_direction dir)
> +{
> +	/* nothing to do */
> +}
> +
> +/**
>   * dma_unmap_page - unmap a buffer previously mapped through dma_map_page()
>   * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
>   * @handle: DMA address of buffer
> @@ -413,7 +463,8 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
>  		return;
>  
>  	if (!arch_is_coherent())
> -		dma_cache_maint(dma_to_virt(dev, handle) + offset, size, dir);
> +		dma_cache_maint(dma_to_virt(dev, handle) + offset,
> +							size, dir, 1);
>  }
>  
>  static inline void dma_sync_single_for_cpu(struct device *dev,
> diff --git a/arch/arm/mm/cache-v6.S b/arch/arm/mm/cache-v6.S
> index 4ba0a24..a88ab56 100644
> --- a/arch/arm/mm/cache-v6.S
> +++ b/arch/arm/mm/cache-v6.S
> @@ -186,7 +186,7 @@ ENTRY(v6_flush_kern_dcache_area)
>  
> 
>  /*
> - *	v6_dma_inv_range(start,end)
> + *	v6_dma_inv_range(start,end,barrier)
>   *
>   *	Invalidate the data cache within the specified region; we will
>   *	be performing a DMA operation in this region and we want to
> @@ -220,11 +220,12 @@ ENTRY(v6_dma_inv_range)
>  	cmp	r0, r1
>  	blo	1b
>  	mov	r0, #0
> -	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
> +	cmp	r2, #1
> +	mcreq	p15, 0, r0, c7, c10, 4		@ drain write buffer
>  	mov	pc, lr
>  
>  /*
> - *	v6_dma_clean_range(start,end)
> + *	v6_dma_clean_range(start,end,barrier)
>   *	- start   - virtual start address of region
>   *	- end     - virtual end address of region
>   */
> @@ -240,11 +241,12 @@ ENTRY(v6_dma_clean_range)
>  	cmp	r0, r1
>  	blo	1b
>  	mov	r0, #0
> -	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
> +	cmp	r2, #1
> +	mcreq	p15, 0, r0, c7, c10, 4		@ drain write buffer
>  	mov	pc, lr
>  
>  /*
> - *	v6_dma_flush_range(start,end)
> + *	v6_dma_flush_range(start,end,barrier)
>   *	- start   - virtual start address of region
>   *	- end     - virtual end address of region
>   */
> @@ -260,7 +262,8 @@ ENTRY(v6_dma_flush_range)
>  	cmp	r0, r1
>  	blo	1b
>  	mov	r0, #0
> -	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
> +	cmp	r2, #1
> +	mcreq	p15, 0, r0, c7, c10, 4		@ drain write buffer
>  	mov	pc, lr
>  
>  	__INITDATA
> diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
> index 9073db8..147a325 100644
> --- a/arch/arm/mm/cache-v7.S
> +++ b/arch/arm/mm/cache-v7.S
> @@ -217,6 +217,7 @@ ENDPROC(v7_flush_kern_dcache_area)
>   *	- end     - virtual end address of region
>   */
>  ENTRY(v7_dma_inv_range)
> +	str r2,[sp, #-4]!
>  	dcache_line_size r2, r3
>  	sub	r3, r2, #1
>  	tst	r0, r3
> @@ -231,16 +232,21 @@ ENTRY(v7_dma_inv_range)
>  	add	r0, r0, r2
>  	cmp	r0, r1
>  	blo	1b
> +	ldr r2, [sp], #4
> +	cmp r2, #1
> +	bne 2f
>  	dsb
> +2:
>  	mov	pc, lr
>  ENDPROC(v7_dma_inv_range)
>  
>  /*
> - *	v7_dma_clean_range(start,end)
> + *	v7_dma_clean_range(start,end,barrier)
>   *	- start   - virtual start address of region
>   *	- end     - virtual end address of region
>   */
>  ENTRY(v7_dma_clean_range)
> +	str r2,[sp, #-4]!
>  	dcache_line_size r2, r3
>  	sub	r3, r2, #1
>  	bic	r0, r0, r3
> @@ -249,16 +255,21 @@ ENTRY(v7_dma_clean_range)
>  	add	r0, r0, r2
>  	cmp	r0, r1
>  	blo	1b
> +	ldr r2, [sp], #4
> +	cmp r2, #1
> +	bne 2f
>  	dsb
> +2:
>  	mov	pc, lr
>  ENDPROC(v7_dma_clean_range)
>  
>  /*
> - *	v7_dma_flush_range(start,end)
> + *	v7_dma_flush_range(start,end,barrier)
>   *	- start   - virtual start address of region
>   *	- end     - virtual end address of region
>   */
>  ENTRY(v7_dma_flush_range)
> +	str r2,[sp, #-4]!
>  	dcache_line_size r2, r3
>  	sub	r3, r2, #1
>  	bic	r0, r0, r3
> @@ -267,7 +278,11 @@ ENTRY(v7_dma_flush_range)
>  	add	r0, r0, r2
>  	cmp	r0, r1
>  	blo	1b
> +	ldr r2, [sp], #4
> +	cmp r2, #1
> +	bne 2f
>  	dsb
> +2:
>  	mov	pc, lr
>  ENDPROC(v7_dma_flush_range)
>  
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 26325cb..c9e3124 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -106,7 +106,7 @@ static struct page *__dma_alloc_buffer(struct device *dev, size_t size, gfp_t gf
>  	 */
>  	ptr = page_address(page);
>  	memset(ptr, 0, size);
> -	dmac_flush_range(ptr, ptr + size);
> +	dmac_flush_range(ptr, ptr + size, 1);
>  	outer_flush_range(__pa(ptr), __pa(ptr) + size);
>  
>  	return page;
> @@ -404,10 +404,11 @@ EXPORT_SYMBOL(dma_free_coherent);
>   * platforms with CONFIG_DMABOUNCE.
>   * Use the driver DMA support - see dma-mapping.h (dma_sync_*)
>   */
> -void dma_cache_maint(const void *start, size_t size, int direction)
> +void dma_cache_maint(const void *start, size_t size, int direction,
> +						unsigned long barrier)
>  {
> -	void (*inner_op)(const void *, const void *);
> -	void (*outer_op)(unsigned long, unsigned long);
> +	void (*inner_op)(const void *, const void *, unsigned long);
> +	void (*outer_op)(unsigned long, unsigned long, unsigned long);
>  
>  	BUG_ON(!virt_addr_valid(start) || !virt_addr_valid(start + size - 1));
>  
> @@ -428,7 +429,7 @@ void dma_cache_maint(const void *start, size_t size, int direction)
>  		BUG();
>  	}
>  
> -	inner_op(start, start + size);
> +	inner_op(start, start + size, barrier);
>  	outer_op(__pa(start), __pa(start) + size);
>  }
>  EXPORT_SYMBOL(dma_cache_maint);
> @@ -438,7 +439,7 @@ static void dma_cache_maint_contiguous(struct page *page, unsigned long offset,
>  {
>  	void *vaddr;
>  	unsigned long paddr;
> -	void (*inner_op)(const void *, const void *);
> +	void (*inner_op)(const void *, const void *, unsigned long);
>  	void (*outer_op)(unsigned long, unsigned long);
>  
>  	switch (direction) {
> @@ -460,12 +461,12 @@ static void dma_cache_maint_contiguous(struct page *page, unsigned long offset,
>  
>  	if (!PageHighMem(page)) {
>  		vaddr = page_address(page) + offset;
> -		inner_op(vaddr, vaddr + size);
> +		inner_op(vaddr, vaddr + size, 1);
>  	} else {
>  		vaddr = kmap_high_get(page);
>  		if (vaddr) {
>  			vaddr += offset;
> -			inner_op(vaddr, vaddr + size);
> +			inner_op(vaddr, vaddr + size, 1);
>  			kunmap_high(page);
>  		}
>  	}
> diff --git a/drivers/staging/dream/pmem.c b/drivers/staging/dream/pmem.c
> index def6468..1b24945 100644
> --- a/drivers/staging/dream/pmem.c
> +++ b/drivers/staging/dream/pmem.c
> @@ -802,7 +802,7 @@ void flush_pmem_file(struct file *file, unsigned long offset, unsigned long len)
>  	vaddr = pmem_start_vaddr(id, data);
>  	/* if this isn't a submmapped file, flush the whole thing */
>  	if (unlikely(!(data->flags & PMEM_FLAGS_CONNECTED))) {
> -		dmac_flush_range(vaddr, vaddr + pmem_len(id, data));
> +		dmac_flush_range(vaddr, vaddr + pmem_len(id, data), 1);
>  		goto end;
>  	}
>  	/* otherwise, flush the region of the file we are drawing */
> @@ -813,7 +813,7 @@ void flush_pmem_file(struct file *file, unsigned long offset, unsigned long len)
>  			region_node->region.len))) {
>  			flush_start = vaddr + region_node->region.offset;
>  			flush_end = flush_start + region_node->region.len;
> -			dmac_flush_range(flush_start, flush_end);
> +			dmac_flush_range(flush_start, flush_end, 1);
>  			break;
>  		}
>  	}


