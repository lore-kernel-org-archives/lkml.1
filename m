Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbXCEJ01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbXCEJ01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 04:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbXCEJ01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 04:26:27 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:42176 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbXCEJ0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 04:26:25 -0500
Date: Mon, 5 Mar 2007 18:23:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Wu, Bryan" <bryan.wu@analog.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
Message-ID: <20070305092346.GB11664@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Wu, Bryan" <bryan.wu@analog.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1172722480.5264.75.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172722480.5264.75.camel@roc-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 12:14:40PM +0800, Wu, Bryan wrote:
> Here is the update version of blackfin-arch.patch in -mm tree.
> simply add support to utrace and it was tested on blackfin STAMP board
> as well as other following patches.
> 
> The whole patch is located at URL:
> https://blackfin.uclinux.org/gf/download/frsrelease/39/2583/blackfin-arch.patch

It would be nice if this could be split and posted incrementally for
review. It's a bit of a pain reading through the entire thing in one
shot.

Anyways..

> Index: linux-2.6/arch/blackfin/Kconfig
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/arch/blackfin/Kconfig	2007-03-01 10:30:27.000000000 +0800
[snip]
> +config ZONE_DMA
> +	bool
> +	default y 
> +
You don't need this, just get rid of it and shove everything in
ZONE_NORMAL.

> +config BLACKFIN
> +	bool
> +	default y
> +
> +config BFIN
> +	bool
> +	default y
> +
Why are there two of these?

> +config GENERIC_IRQ_PROBE
> +        bool
> +	default y
> +
Whitespace damage.

> +config UCLINUX
> +	bool
> +	default y
> +
Dead symbol.

> +comment "Memory Optimizations"
> +
> +config I_ENTRY_L1
> +	bool "Locate interrupt entry code in L1 Memory"
> +	default y
> +	help
> +	  If enabled interrupt entry code (STORE/RESTORE CONTEXT) is linked
> +	  into L1 instruction memory.(less latency)
> +
Wow, this is really crying out for a special linker section with slightly
more intelligent relocation logic. You should flag the performance
critical parts to be located in L1 memory directly with a section
attribute, rather than making everything selectable. If you overflow you
can simply spill in to main memory.

> +choice
> +	prompt "Uncached SDRAM region"
> +	default DMA_UNCACHED_1M
> +	depends BFIN_DMA_5XX
> +config DMA_UNCACHED_2M
> +	bool "Enable 2M DMA Zone"
> +config DMA_UNCACHED_1M
> +	bool "Enable 1M DMA Zone"
> +config DMA_UNCACHED_NONE
> +	bool "Disable DMA Zone"
> +endchoice
> +
Contrary to the comment, this is not a zone.

> +config DEBUG_HUNT_FOR_ZERO
> +	bool "Catch NULL pointer reads/writes"
> +	default y
> +	help
> +	  Say Y here to catch reads/writes to anywhere in the memory range
> +	  from 0x0000 - 0x0FFF (the first 4k) of memory.  This is useful in
> +	  catching common programming errors such as NULL pointer dereferences.
> +
> +	  Misbehaving applications will be killed (generate a SEGV) while the
> +	  kernel will trigger a panic.
> +
> +	  Enabling this option will take up an extra entry in CPLB table.
> +	  Otherwise, there is no extra overhead.
> +
Is this sane to have conditional?

> +config BOOTPARAM
> +	bool "Compiled-in Kernel Boot Parameter"
> +
> +config BOOTPARAM_STRING
> +	string "Kernel Boot Parameter"
> +	default "console=ttyS0,57600"
> +	depends on BOOTPARAM
> +
Any reason not to use CMDLINE_BOOL/CMDLINE like every other platform?

> +config NO_KERNEL_MSG
> +	bool "Suppress Kernel BUG Messages"
> +	help
> +	  Do not output any debug BUG messages within the kernel.
> +
This is useless. For starters, CONFIG_BUG already does this. Secondly,
this isn't used anywhere.

> +int __init blackfin_dma_init(void)
> +{
> +	int i;
> +
> +	printk(KERN_INFO "Blackfin DMA Controller\n");
> +
> +	for (i = 0; i < MAX_BLACKFIN_DMA_CHANNEL; i++) {
> +		dma_ch[i].chan_status = DMA_CHANNEL_FREE;
> +		dma_ch[i].regs = base_addr[i];
> +		init_MUTEX(&(dma_ch[i].dmalock));

The dmalock is only ever used as a mutex, use that instead.

> +void dma_alloc_init(unsigned long start, unsigned long end)
> +{
> +	spin_lock_init(&dma_page_lock);
> +	dma_initialized = 0;
> +
> +	dma_page = (unsigned int *)__get_free_page(GFP_KERNEL);
> +	memset(dma_page, 0, PAGE_SIZE);
> +	dma_base = PAGE_ALIGN(start);
> +	dma_size = PAGE_ALIGN(end) - PAGE_ALIGN(start);
> +	dma_pages = dma_size >> PAGE_SHIFT;
> +	memset((void *)dma_base, 0, DMA_UNCACHED_REGION);
> +	dma_initialized = 1;
> +
> +	printk(KERN_INFO "%s: dma_page @ 0x%p - %d pages at 0x%08lx\n", __FUNCTION__,
> +	       dma_page, dma_pages, dma_base);
> +}

That's an "interesting" way of doing a bitmap. Please use a proper bitmap
for dma_page, there's infrastructure for all of this already without
having to come up with new schemes. dma_declare_coherent() is a good
example.

> +void *dma_alloc_coherent(struct device *dev, size_t size,
> +			 dma_addr_t * dma_handle, gfp_t gfp)
> +{
> +	void *ret;
> +
> +	ret = (void *)__alloc_dma_pages(get_pages(size));
> +
> +	if (ret) {
> +		memset(ret, 0, size);
> +		*dma_handle = virt_to_phys(ret);
> +	}
> +
No dcache write-back?

> +dma_addr_t
> +dma_map_single(struct device *dev, void *ptr, size_t size,
> +	       enum dma_data_direction direction)
> +{
> +	BUG_ON(direction == DMA_NONE);
> +
> +	blackfin_dcache_invalidate_range((unsigned long)ptr,
> +					 (unsigned long)ptr + size);
> +
> +	return (dma_addr_t) ptr;
> +}
> +
> +int
> +dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
> +	   enum dma_data_direction direction)
> +{
> +	int i;
> +
> +	BUG_ON(direction == DMA_NONE);
> +
> +	for (i = 0; i < nents; i++)
> +		invalidate_dcache_range(sg_dma_address(&sg[i]),
> +					sg_dma_address(&sg[i]) +
> +					sg_dma_len(&sg[i]));
> +

Why are you using the different flushing routines here?

> +#ifdef DEBUG_SERIAL_EARLY_INIT
> +	bfin_console_init();	/* early console registration */
> +	/* this give a chance to get printk() working before crash. */
> +#endif
> +
Why not expose this as a sensible early_printk implementation?

> +#ifdef CONFIG_CONSOLE
> +#ifdef CONFIG_FRAMEBUFFER
> +	conswitchp = &fb_con;
> +#else
> +	conswitchp = 0;
> +#endif
> +#endif
> +
Can't you do this in the defconfig?

> +	/* check the size of the l1 area */
> +	l1_length = _etext_l1 - _stext_l1;
> +	if (l1_length > L1_CODE_LENGTH)
> +		panic("L1 memory overflow\n");
> +
> +	l1_length = _ebss_l1 - _sdata_l1;
> +	if (l1_length > L1_DATA_A_LENGTH)
> +		panic("L1 memory overflow\n");
> +
That's not very nice. You can figure this out already at link time.

> +void do_gettimeofday(struct timeval *tv)
> +int do_settimeofday(struct timespec *tv)

These can use CONFIG_GENERIC_TIME.

> +static struct platform_device *cm_bf533_devices[] __initdata = {
> +#if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
> +	&bfin_uart_device,
> +#endif
> +
Why? You'll already free this up if nothing claims it.

One of the benefits of having the driver model is that we're able to get
rid of this sort of ifdef abortion.

> +	/*
> +	 * initialize the bad page table and bad page to point
> +	 * to a couple of allocated pages
> +	 */
> +	empty_bad_page_table = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
> +	empty_bad_page = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
> +	empty_zero_page = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
> +	memset((void *)empty_zero_page, 0, PAGE_SIZE);
> +
dcache handling?

> +	tmp = (unsigned long)l1sram_alloc(sizeof(struct l1_scratch_task_info));
> +	if (tmp != (unsigned long)L1_SCRATCH_TASK_INFO) {
> +		printk(KERN_EMERG "mem_init(): Did not get the right address from l1sram_alloc: %08lx != %08lx\n",
> +			tmp, (unsigned long)L1_SCRATCH_TASK_INFO);
> +		panic("No L1, time to give up\n");
> +	}

This platform seems to really want to panic() at the first sign of
trouble. This is not a good policy, especially for something that's only
a micro-optimization.

> Index: linux-2.6/arch/blackfin/mm/kmap.c

All of this can be inlined in io.h, there's nothing noteworthy here.

> +static struct semaphore pfmon_sem;
> +
Use a mutex.

> +int __init oprofile_arch_init(struct oprofile_operations *ops)
> +{
> +#ifdef CONFIG_HARDWARE_PM
[snip]
> +#else
> +	return -1;
> +#endif
> +}
> +
Uh.. fix your dependencies.

> +unsigned curr_pfctl, curr_count[2];
> +
Globals?

> Index: linux-2.6/include/asm-blackfin/bug.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/include/asm-blackfin/bug.h	2007-03-01 10:30:27.000000000 +0800
> @@ -0,0 +1,15 @@
> +#ifndef _BLACKFIN_BUG_H
> +#define _BLACKFIN_BUG_H
> +
> +#ifdef CONFIG_BUG
> +#define HAVE_ARCH_BUG
> +#define BUG() do { \
> +	dump_stack(); \
> +	printk(KERN_WARNING "\nkernel BUG at %s:%d!\n",\
> +		 __FILE__, __LINE__); \
> +	panic("BUG!"); \
> +} while (0)
> +#endif
> +
> +#include <asm-generic/bug.h>
> +#endif

What do you need HAVE_ARCH_BUG for? You're not doing anything with it..

> +#ifndef __ARCH_BLACKFIN_CACHE_H
> +#define __ARCH_BLACKFIN_CACHE_H
> +
> +/* bytes per L1 cache line */
> +#define        L1_CACHE_SHIFT  5	/* BlackFin loads 32 bytes for cache */
> +#define        L1_CACHE_BYTES  (1 << L1_CACHE_SHIFT)
> +
> +/* For speed we do need to align these ...MaTed---*/
> +/*  But include/linux/cache.h does this for us if we DO not define ...MaTed---*/
> +#define __cacheline_aligned	/***** maybe no need this   Tony *****/
> +#define ____cacheline_aligned
> +
What the hell?

> +static inline void flush_icache_range(unsigned start, unsigned end)
> +{
> +#if defined(CONFIG_BLKFIN_DCACHE) && defined(CONFIG_BLKFIN_CACHE)
> +
> +# if defined(CONFIG_BLKFIN_WT)
> +	blackfin_icache_flush_range((start), (end));
> +# else
> +	blackfin_icache_dcache_flush_range((start), (end));
> +# endif
> +
> +#else
> +
> +# if defined(CONFIG_BLKFIN_CACHE)
> +	blackfin_icache_flush_range((start), (end));
> +# endif
> +# if defined(CONFIG_BLKFIN_DCACHE)
> +	blackfin_dcache_flush_range((start), (end));
> +# endif
> +
> +#endif
> +}
> +
This would probably be cleaner out-of-line, you can hide most of this
ugliness in your Makefile instead.

> +#pragma pack(2)
> +struct dmasg_t {
> +	unsigned long next_desc_addr;
> +	unsigned long start_addr;
> +	unsigned short cfg;
> +	unsigned short x_count;
> +	short x_modify;
> +	unsigned short y_count;
> +	short y_modify;
> +};
> +#pragma pack()
> +
Do you really need to use pragma?

> +struct dma_register_t {

Why is there a _t here?

> +#define STR(X) STR1(X)
> +#define STR1(X) #X

You can use __stringify() for this if you feel you must.

> +static inline unsigned long bfin_get_addr_from_rp(unsigned long *ptr,
> +						  unsigned long relval,
> +						  unsigned long flags,
> +						  unsigned long *persistent)
> +{

Some of these look frighteningly large to be inlined..

> +#define dma_cache_inv(_start,_size) do { blkfin_inv_cache_all();} while (0)
> +#define dma_cache_wback(_start,_size) do { } while (0)
> +#define dma_cache_wback_inv(_start,_size) do { blkfin_inv_cache_all();} while (0)

What's the point of having selective flushing if you're 1) going to blow
it all away, and 2) not use these in the dma-mapping cases?

> +/* Clock and System Control (0xFFC0 0400-0xFFC0 07FF) */
> +#define bfin_read_PLL_CTL()                  bfin_read16(PLL_CTL)
> +#define bfin_write_PLL_CTL(val)              bfin_write16(PLL_CTL,val)
> +#define bfin_read_PLL_STAT()                 bfin_read16(PLL_STAT)
> +#define bfin_write_PLL_STAT(val)             bfin_write16(PLL_STAT,val)
> +#define bfin_read_PLL_LOCKCNT()              bfin_read16(PLL_LOCKCNT)
> +#define bfin_write_PLL_LOCKCNT(val)          bfin_write16(PLL_LOCKCNT,val)

What sort of magical abstraction is this? Is there some reason you can't
just read and write the registers directly rather than having a wrapper
for _every_ possible register?

There are literally _thousands_ of lines of this stuff, and I imagine
that careful auditing would reveal that not even 5% of them are actually
used by the port. Presumably you have a processor manual, use that when
you need it, rather than inlining this crap in the kernel.
