Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYDFPEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYDFPEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 11:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbYDFPE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 11:04:28 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:37862 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbYDFPEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:04:25 -0400
Message-ID: <47F8E64C.9030104@panasas.com>
Date: Sun, 06 Apr 2008 18:03:40 +0300
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-arch <linux-arch@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       heukelum@fastmail.fm
Subject: Re: [0/3] Improve generic fls64 for 64-bit machines
References: <20080315172913.GA21648@mailshack.com> <47F511BF.8090506@panasas.com> <20080404142214.GA8322@mailshack.com>
In-Reply-To: <20080404142214.GA8322@mailshack.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr. 04, 2008, 17:22 +0300, Alexander van Heukelum <heukelum@mailshack.com> wrote:
> On Thu, Apr 03, 2008 at 08:19:59PM +0300, Benny Halevy wrote:
>> On Mar. 15, 2008, 19:29 +0200, Alexander van Heukelum <heukelum@mailshack.com> wrote:
>>> This series of patches:
>>>
>>> [1/3] adds __fls.h to asm-generic
>>> [2/3] modifies asm-*/bitops.h for 64-bit archs to implement __fls
>>> [3/3] modifies asm-generic/fls64.h to make use of __fls
>> I strongly support this.
>>
>> I wish we'd also have a consistent naming convention for all
>> the bitops functions so it will be clearer what data type the
>> function is working on and is the result 0 or 1 based.
>>
>> It seems like what we currently have is:
>>
>> name	type	first bit#
>> ----	----	----------
>> ffs	int	1
>> fls	int	1
>> __ffs	ulong	0
>> __fls	ulong	0	# in your proposal
>> ffz	ulong	0
>> fls64	__u64	1
>>
>> so it seems like
>> - ffz is misnamed and is rather confusing.
>>   Apprently is should be renamed to __ffz.
>>
>> - (new) ffz(x) can be defined to ffs(~(x))
>>
>> - It'd be nice to have ffs64, and maybe ffz64.
>>
>> Benny
> 
> I think every programmer who thinks in terms of bits realises
> that ffz(x) == __ffs(~x) and ffz(~x) == __ffs(x) etc... so I
> would rather get rid of ffz entirely by converting all uses
> to __ffs. Patch (against current linus) below. After that all
> implementations of ffz could be removed.

Yeah, very few architectures have an optimized version of ffz
that will perform noticeably better than __ffs(~x).
(e.g. h8300, sh)

> 
> ffs64 would be a good addition to complete the set of functions,
> but that would be the same as glibc's (and gcc-builtin) ffsll.
> 
> Looking into that... the relevant gcc builtins are __builtin_ffs
> (find first set bit), __builtin_clz (count leading zeroes),
> __builtin_ctz (count trailing zeroes), __builtin_popcount, maybe
> __builtin_parity and their -l and -ll variants. Maybe the kernel
> should be changed to use those names instead of the current
> ones? ffs would stay as it is. __ffs would become ctz, __fls
> would become something like 31-clz, and hweight would become
> popcount.

Interesting idea.  ctz much better than __ffs with regards to the
return value's first bit number, but unless you expose clz
and convert the code how do you get rid of the __fls vs. fls
confusion?
(BTW for __fls, I'd use BITS_PER_LONG - 1, not 31 :)

I think that adopting libc's convention might make more sense,
i.e., define ffs, ffsl, ffsll, and fls, flsl, flsll, and have *all*
be 1-based.

Benny

> 
> Greetings,
> 	Alexander
> 
> 
> [RFC] how about getting rid of ffz?
> 
> The patch is not tested, but the conversion should be completely
> trivial.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> ---
> 
>  arch/alpha/kernel/irq_i8259.c     |    2 +-
>  arch/alpha/kernel/irq_pyxis.c     |    2 +-
>  arch/alpha/kernel/sys_alcor.c     |    2 +-
>  arch/alpha/kernel/sys_cabriolet.c |    2 +-
>  arch/alpha/kernel/sys_dp264.c     |    2 +-
>  arch/alpha/kernel/sys_eb64p.c     |    2 +-
>  arch/alpha/kernel/sys_mikasa.c    |    2 +-
>  arch/alpha/kernel/sys_noritake.c  |    2 +-
>  arch/alpha/kernel/sys_rx164.c     |    2 +-
>  arch/arm/kernel/smp.c             |    2 +-
>  arch/ia64/hp/common/sba_iommu.c   |    2 +-
>  arch/ia64/kernel/perfmon.c        |    2 +-
>  arch/ia64/kernel/smp.c            |    2 +-
>  arch/ia64/mm/init.c               |    2 +-
>  arch/mips/kernel/irixelf.c        |    2 +-
>  arch/parisc/kernel/smp.c          |    2 +-
>  arch/sh/kernel/cpu/irq/imask.c    |    2 +-
>  block/blk-barrier.c               |    2 +-
>  crypto/lrw.c                      |    2 +-
>  drivers/ieee1394/pcilynx.c        |    2 +-
>  drivers/input/keyboard/hilkbd.c   |    2 +-
>  drivers/md/bitmap.c               |    4 ++--
>  drivers/md/md.c                   |    2 +-
>  drivers/md/raid0.c                |    2 +-
>  drivers/md/raid10.c               |    2 +-
>  drivers/net/wan/cycx_x25.c        |    2 +-
>  drivers/scsi/NCR_Q720.c           |    2 +-
>  fs/adfs/map.c                     |    4 ++--
>  fs/binfmt_elf.c                   |    2 +-
>  fs/binfmt_elf_fdpic.c             |    2 +-
>  fs/ntfs/mft.c                     |    2 +-
>  fs/udf/balloc.c                   |    2 +-
>  fs/xfs/xfs_bit.c                  |    2 +-
>  include/asm-m68knommu/bitops.h    |    4 ++--
>  include/linux/inetdevice.h        |    2 +-
>  include/linux/signal.h            |    2 +-
>  kernel/signal.c                   |    6 +++---
>  lib/find_next_bit.c               |    6 +++---
>  mm/page_alloc.c                   |    2 +-
>  net/sched/sch_cbq.c               |    4 ++--
>  net/sched/sch_htb.c               |   10 +++++-----
>  sound/core/oss/mixer_oss.c        |    2 +-
>  42 files changed, 54 insertions(+), 54 deletions(-)
> 
> diff --git a/arch/alpha/kernel/irq_i8259.c b/arch/alpha/kernel/irq_i8259.c
> index 9405bee..f54afc8 100644
> --- a/arch/alpha/kernel/irq_i8259.c
> +++ b/arch/alpha/kernel/irq_i8259.c
> @@ -174,7 +174,7 @@ isa_no_iack_sc_device_interrupt(unsigned long vector)
>  	pic &= 0xFFFB;				/* mask out cascade & hibits */
>  
>  	while (pic) {
> -		int j = ffz(~pic);
> +		int j = __ffs(pic);
>  		pic &= pic - 1;
>  		handle_irq(j);
>  	}
> diff --git a/arch/alpha/kernel/irq_pyxis.c b/arch/alpha/kernel/irq_pyxis.c
> index d53edbc..272339d 100644
> --- a/arch/alpha/kernel/irq_pyxis.c
> +++ b/arch/alpha/kernel/irq_pyxis.c
> @@ -95,7 +95,7 @@ pyxis_device_interrupt(unsigned long vector)
>  	 * the appropriate interrupt handler.
>  	 */
>  	while (pld) {
> -		i = ffz(~pld);
> +		i = __ffs(pld);
>  		pld &= pld - 1; /* clear least bit set */
>  		if (i == 7)
>  			isa_device_interrupt(vector);
> diff --git a/arch/alpha/kernel/sys_alcor.c b/arch/alpha/kernel/sys_alcor.c
> index d187d01..4747c89 100644
> --- a/arch/alpha/kernel/sys_alcor.c
> +++ b/arch/alpha/kernel/sys_alcor.c
> @@ -113,7 +113,7 @@ alcor_device_interrupt(unsigned long vector)
>  	 * the appropriate interrupt handler.
>  	 */
>  	while (pld) {
> -		i = ffz(~pld);
> +		i = __ffs(pld);
>  		pld &= pld - 1; /* clear least bit set */
>  		if (i == 31) {
>  			isa_device_interrupt(vector);
> diff --git a/arch/alpha/kernel/sys_cabriolet.c b/arch/alpha/kernel/sys_cabriolet.c
> index ace475c..e0f73b0 100644
> --- a/arch/alpha/kernel/sys_cabriolet.c
> +++ b/arch/alpha/kernel/sys_cabriolet.c
> @@ -95,7 +95,7 @@ cabriolet_device_interrupt(unsigned long v)
>  	 * the appropriate interrupt handler.
>  	 */
>  	while (pld) {
> -		i = ffz(~pld);
> +		i = __ffs(pld);
>  		pld &= pld - 1;	/* clear least bit set */
>  		if (i == 4) {
>  			isa_device_interrupt(v);
> diff --git a/arch/alpha/kernel/sys_dp264.c b/arch/alpha/kernel/sys_dp264.c
> index c71b0fd..d7efd02 100644
> --- a/arch/alpha/kernel/sys_dp264.c
> +++ b/arch/alpha/kernel/sys_dp264.c
> @@ -233,7 +233,7 @@ dp264_device_interrupt(unsigned long vector)
>  	 * the appropriate interrupt handler.
>  	 */
>  	while (pld) {
> -		i = ffz(~pld);
> +		i = __ffs(pld);
>  		pld &= pld - 1; /* clear least bit set */
>  		if (i == 55)
>  			isa_device_interrupt(vector);
> diff --git a/arch/alpha/kernel/sys_eb64p.c b/arch/alpha/kernel/sys_eb64p.c
> index 9c5a306..4713aab 100644
> --- a/arch/alpha/kernel/sys_eb64p.c
> +++ b/arch/alpha/kernel/sys_eb64p.c
> @@ -93,7 +93,7 @@ eb64p_device_interrupt(unsigned long vector)
>  	 * them and call the appropriate interrupt handler.
>  	 */
>  	while (pld) {
> -		i = ffz(~pld);
> +		i = __ffs(pld);
>  		pld &= pld - 1;	/* clear least bit set */
>  
>  		if (i == 5) {
> diff --git a/arch/alpha/kernel/sys_mikasa.c b/arch/alpha/kernel/sys_mikasa.c
> index 8d3e942..26e1ad8 100644
> --- a/arch/alpha/kernel/sys_mikasa.c
> +++ b/arch/alpha/kernel/sys_mikasa.c
> @@ -94,7 +94,7 @@ mikasa_device_interrupt(unsigned long vector)
>  	 * the appropriate interrupt handler.
>  	 */
>  	while (pld) {
> -		i = ffz(~pld);
> +		i = __ffs(pld);
>  		pld &= pld - 1; /* clear least bit set */
>  		if (i < 16) {
>  			isa_device_interrupt(vector);
> diff --git a/arch/alpha/kernel/sys_noritake.c b/arch/alpha/kernel/sys_noritake.c
> index eb2a1d6..a7fcc10 100644
> --- a/arch/alpha/kernel/sys_noritake.c
> +++ b/arch/alpha/kernel/sys_noritake.c
> @@ -100,7 +100,7 @@ noritake_device_interrupt(unsigned long vector)
>  	 * the appropriate interrupt handler.
>  	 */
>  	while (pld) {
> -		i = ffz(~pld);
> +		i = __ffs(pld);
>  		pld &= pld - 1; /* clear least bit set */
>  		if (i < 16) {
>  			isa_device_interrupt(vector);
> diff --git a/arch/alpha/kernel/sys_rx164.c b/arch/alpha/kernel/sys_rx164.c
> index ce1faa6..c91ad0b 100644
> --- a/arch/alpha/kernel/sys_rx164.c
> +++ b/arch/alpha/kernel/sys_rx164.c
> @@ -99,7 +99,7 @@ rx164_device_interrupt(unsigned long vector)
>  	 * the appropriate interrupt handler.
>  	 */
>  	while (pld) {
> -		i = ffz(~pld);
> +		i = __ffs(pld);
>  		pld &= pld - 1; /* clear least bit set */
>  		if (i == 20) {
>  			isa_no_iack_sc_device_interrupt(vector);
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index eefae1d..dd372e0 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -596,7 +596,7 @@ asmlinkage void __exception do_IPI(struct pt_regs *regs)
>  
>  			nextmsg = msgs & -msgs;
>  			msgs &= ~nextmsg;
> -			nextmsg = ffz(~nextmsg);
> +			nextmsg = __ffs(nextmsg);
>  
>  			switch (nextmsg) {
>  			case IPI_TIMER:
> diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
> index 523eae6..4d21931 100644
> --- a/arch/ia64/hp/common/sba_iommu.c
> +++ b/arch/ia64/hp/common/sba_iommu.c
> @@ -502,7 +502,7 @@ sba_search_bitmap(struct ioc *ioc, unsigned long bits_wanted, int use_hint)
>  		unsigned int bitshiftcnt;
>  		for(; res_ptr < res_end ; res_ptr++) {
>  			if (likely(*res_ptr != ~0UL)) {
> -				bitshiftcnt = ffz(*res_ptr);
> +				bitshiftcnt = __ffs(~(*res_ptr));
>  				*res_ptr |= (1UL << bitshiftcnt);
>  				pide = ((unsigned long)res_ptr - (unsigned long)ioc->res_map);
>  				pide <<= 3;	/* convert to bit address */
> diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
> index a2aabfd..abebeba 100644
> --- a/arch/ia64/kernel/perfmon.c
> +++ b/arch/ia64/kernel/perfmon.c
> @@ -6683,7 +6683,7 @@ pfm_init(void)
>  	       pmu_conf->num_pmcs,
>  	       pmu_conf->num_pmds,
>  	       pmu_conf->num_counters,
> -	       ffz(pmu_conf->ovfl_val));
> +	       __ffs(~(pmu_conf->ovfl_val)));
>  
>  	/* sanity check */
>  	if (pmu_conf->num_pmds >= PFM_NUM_PMD_REGS || pmu_conf->num_pmcs >= PFM_NUM_PMC_REGS) {
> diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
> index 4e446aa..6f303c0 100644
> --- a/arch/ia64/kernel/smp.c
> +++ b/arch/ia64/kernel/smp.c
> @@ -134,7 +134,7 @@ handle_IPI (int irq, void *dev_id)
>  		do {
>  			unsigned long which;
>  
> -			which = ffz(~ops);
> +			which = __ffs(ops);
>  			ops &= ~(1 << which);
>  
>  			switch (which) {
> diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
> index a4ca657..d9c910a 100644
> --- a/arch/ia64/mm/init.c
> +++ b/arch/ia64/mm/init.c
> @@ -333,7 +333,7 @@ ia64_mmu_init (void *my_cpu_data)
>  #	define vmlpt_bits		(impl_va_bits - PAGE_SHIFT + pte_bits)
>  #	define POW2(n)			(1ULL << (n))
>  
> -	impl_va_bits = ffz(~(local_cpu_data->unimpl_va_mask | (7UL << 61)));
> +	impl_va_bits = __ffs(local_cpu_data->unimpl_va_mask | (7UL << 61));
>  
>  	if (impl_va_bits < 51 || impl_va_bits > 61)
>  		panic("CPU has bogus IMPL_VA_MSB value of %lu!\n", impl_va_bits - 1);
> diff --git a/arch/mips/kernel/irixelf.c b/arch/mips/kernel/irixelf.c
> index 290d8e3..7a82960 100644
> --- a/arch/mips/kernel/irixelf.c
> +++ b/arch/mips/kernel/irixelf.c
> @@ -1207,7 +1207,7 @@ static int irix_core_dump(long signr, struct pt_regs *regs, struct file *file, u
>  	notes[1].type = NT_PRPSINFO;
>  	notes[1].datasz = sizeof(psinfo);
>  	notes[1].data = &psinfo;
> -	i = current->state ? ffz(~current->state) + 1 : 0;
> +	i = current->state ? __ffs(current->state) + 1 : 0;
>  	psinfo.pr_state = i;
>  	psinfo.pr_sname = (i < 0 || i > 5) ? '.' : "RSDZTD"[i];
>  	psinfo.pr_zomb = psinfo.pr_sname == 'Z';
> diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
> index 85fc775..992d3c6 100644
> --- a/arch/parisc/kernel/smp.c
> +++ b/arch/parisc/kernel/smp.c
> @@ -168,7 +168,7 @@ ipi_interrupt(int irq, void *dev_id)
>  		    break;
>  
>  		while (ops) {
> -			unsigned long which = ffz(~ops);
> +			unsigned long which = __ffs(ops);
>  
>  			ops &= ~(1 << which);
>  
> diff --git a/arch/sh/kernel/cpu/irq/imask.c b/arch/sh/kernel/cpu/irq/imask.c
> index 301b505..240fc63 100644
> --- a/arch/sh/kernel/cpu/irq/imask.c
> +++ b/arch/sh/kernel/cpu/irq/imask.c
> @@ -84,7 +84,7 @@ static void disable_imask_irq(unsigned int irq)
>  static void enable_imask_irq(unsigned int irq)
>  {
>  	set_bit(irq, &imask_mask);
> -	interrupt_priority = IMASK_PRIORITY - ffz(imask_mask);
> +	interrupt_priority = IMASK_PRIORITY - __ffs(~imask_mask);
>  
>  	set_interrupt_registers(interrupt_priority);
>  }
> diff --git a/block/blk-barrier.c b/block/blk-barrier.c
> index 55c5f1f..45937d9 100644
> --- a/block/blk-barrier.c
> +++ b/block/blk-barrier.c
> @@ -57,7 +57,7 @@ inline unsigned blk_ordered_cur_seq(struct request_queue *q)
>  {
>  	if (!q->ordseq)
>  		return 0;
> -	return 1 << ffz(q->ordseq);
> +	return 1 << __ffs(~(q->ordseq));
>  }
>  
>  unsigned blk_ordered_req_seq(struct request *rq)
> diff --git a/crypto/lrw.c b/crypto/lrw.c
> index 9d52e58..ddf6303 100644
> --- a/crypto/lrw.c
> +++ b/crypto/lrw.c
> @@ -115,7 +115,7 @@ static inline int get_index128(be128 *block)
>  		if (!~val)
>  			continue;
>  
> -		return x + ffz(val);
> +		return x + __ffs(~val);
>  	}
>  
>  	return x;
> diff --git a/drivers/ieee1394/pcilynx.c b/drivers/ieee1394/pcilynx.c
> index 8af01ab..0b9e3d1 100644
> --- a/drivers/ieee1394/pcilynx.c
> +++ b/drivers/ieee1394/pcilynx.c
> @@ -141,7 +141,7 @@ static pcl_t alloc_pcl(struct ti_lynx *lynx)
>          int i, j;
>  
>          spin_lock(&lynx->lock);
> -        /* FIXME - use ffz() to make this readable */
> +        /* FIXME - use __ffs() to make this readable */
>          for (i = 0; i < (LOCALRAM_SIZE / 1024); i++) {
>                  m = lynx->pcl_bmap[i];
>                  for (j = 0; j < 8; j++) {
> diff --git a/drivers/input/keyboard/hilkbd.c b/drivers/input/keyboard/hilkbd.c
> index 50d80ec..94b6bfb 100644
> --- a/drivers/input/keyboard/hilkbd.c
> +++ b/drivers/input/keyboard/hilkbd.c
> @@ -254,7 +254,7 @@ hil_keyb_init(void)
>  		kbid = -1;
>  		printk(KERN_WARNING "HIL: no keyboard present\n");
>  	} else {
> -		kbid = ffz(~c);
> +		kbid = __ffs(c);
>  		printk(KERN_INFO "HIL: keyboard found at id %d\n", kbid);
>  	}
>  
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index c14dacd..7b0d5f7 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -538,7 +538,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
>  		reason = "unrecognized superblock version";
>  	else if (chunksize < PAGE_SIZE)
>  		reason = "bitmap chunksize too small";
> -	else if ((1 << ffz(~chunksize)) != chunksize)
> +	else if ((1 << __ffs(chunksize)) != chunksize)
>  		reason = "bitmap chunksize not a power of 2";
>  	else if (daemon_sleep < 1 || daemon_sleep > MAX_SCHEDULE_TIMEOUT / HZ)
>  		reason = "daemon sleep period out of range";
> @@ -1540,7 +1540,7 @@ int bitmap_create(mddev_t *mddev)
>  	if (err)
>  		goto error;
>  
> -	bitmap->chunkshift = ffz(~bitmap->chunksize);
> +	bitmap->chunkshift = __ffs(bitmap->chunksize);
>  
>  	/* now that chunksize and chunkshift are set, we can use these macros */
>   	chunks = (blocks + CHUNK_BLOCK_RATIO(bitmap) - 1) /
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 61ccbd2..a963235 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3316,7 +3316,7 @@ static int do_md_run(mddev_t * mddev)
>  		/*
>  		 * chunk-size has to be a power of 2 and multiples of PAGE_SIZE
>  		 */
> -		if ( (1 << ffz(~chunk_size)) != chunk_size) {
> +		if ( (1 << __ffs(chunk_size)) != chunk_size) {
>  			printk(KERN_ERR "chunk_size of %d not valid\n", chunk_size);
>  			return -EINVAL;
>  		}
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 818b482..e680472 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -407,7 +407,7 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
>  
>  	chunk_size = mddev->chunk_size >> 10;
>  	chunk_sects = mddev->chunk_size >> 9;
> -	chunksize_bits = ffz(~chunk_size);
> +	chunksize_bits = __ffs(chunk_size);
>  	block = bio->bi_sector >> 1;
>  	
>  
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 32389d2..0f876b3 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2029,7 +2029,7 @@ static int run(mddev_t *mddev)
>  	conf->copies = nc*fc;
>  	conf->far_offset = fo;
>  	conf->chunk_mask = (sector_t)(mddev->chunk_size>>9)-1;
> -	conf->chunk_shift = ffz(~mddev->chunk_size) - 9;
> +	conf->chunk_shift = __ffs(mddev->chunk_size) - 9;
>  	size = mddev->size >> (conf->chunk_shift-1);
>  	sector_div(size, fc);
>  	size = size * conf->raid_disks;
> diff --git a/drivers/net/wan/cycx_x25.c b/drivers/net/wan/cycx_x25.c
> index d3b28b0..8d66031 100644
> --- a/drivers/net/wan/cycx_x25.c
> +++ b/drivers/net/wan/cycx_x25.c
> @@ -1207,7 +1207,7 @@ static int x25_place_call(struct cycx_device *card,
>  		return -EAGAIN;
>  	}
>  
> -	key = ffz(card->u.x.connection_keys);
> +	key = __ffs(~(card->u.x.connection_keys));
>  	set_bit(key, (void*)&card->u.x.connection_keys);
>  	++key;
>  	dprintk(1, KERN_INFO "%s:x25_place_call:key=%d\n", card->devname, key);
> diff --git a/drivers/scsi/NCR_Q720.c b/drivers/scsi/NCR_Q720.c
> index a8bbdc2..768d2c6 100644
> --- a/drivers/scsi/NCR_Q720.c
> +++ b/drivers/scsi/NCR_Q720.c
> @@ -66,7 +66,7 @@ NCR_Q720_intr(int irq, void *data)
>  		return IRQ_NONE;
>  
>  
> -	while((siop = ffz(sir)) < p->siops) {
> +	while((siop = __ffs(~sir)) < p->siops) {
>  		sir |= 1<<siop;
>  		ncr53c8xx_intr(irq, p->hosts[siop]);
>  	}
> diff --git a/fs/adfs/map.c b/fs/adfs/map.c
> index 92ab4fb..74002c7 100644
> --- a/fs/adfs/map.c
> +++ b/fs/adfs/map.c
> @@ -101,7 +101,7 @@ lookup_zone(const struct adfs_discmap *dm, const unsigned int idlen,
>  				v = le32_to_cpu(_map[mapptr >> 5]);
>  			}
>  
> -			mapptr += 1 + ffz(~v);
> +			mapptr += 1 + __ffs(v);
>  		}
>  
>  		if (frag == frag_id)
> @@ -179,7 +179,7 @@ scan_free_map(struct adfs_sb_info *asb, struct adfs_discmap *dm)
>  				v = le32_to_cpu(_map[mapptr >> 5]);
>  			}
>  
> -			mapptr += 1 + ffz(~v);
> +			mapptr += 1 + __ffs(v);
>  		}
>  
>  		total += mapptr - start;
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 5e1a4fb..c97c169 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1383,7 +1383,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
>  	psinfo->pr_pgrp = task_pgrp_vnr(p);
>  	psinfo->pr_sid = task_session_vnr(p);
>  
> -	i = p->state ? ffz(~p->state) + 1 : 0;
> +	i = p->state ? __ffs(p->state) + 1 : 0;
>  	psinfo->pr_state = i;
>  	psinfo->pr_sname = (i > 5) ? '.' : "RSDTZW"[i];
>  	psinfo->pr_zomb = psinfo->pr_sname == 'Z';
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index 32649f2..5fd6707 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -1396,7 +1396,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
>  	psinfo->pr_pgrp = task_pgrp_vnr(p);
>  	psinfo->pr_sid = task_session_vnr(p);
>  
> -	i = p->state ? ffz(~p->state) + 1 : 0;
> +	i = p->state ? __ffs(p->state) + 1 : 0;
>  	psinfo->pr_state = i;
>  	psinfo->pr_sname = (i > 5) ? '.' : "RSDTZW"[i];
>  	psinfo->pr_zomb = psinfo->pr_sname == 'Z';
> diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
> index 2ad5c8b..df7a352 100644
> --- a/fs/ntfs/mft.c
> +++ b/fs/ntfs/mft.c
> @@ -1207,7 +1207,7 @@ static int ntfs_mft_bitmap_find_and_alloc_free_rec_nolock(ntfs_volume *vol,
>  				byte = buf + (bit >> 3);
>  				if (*byte == 0xff)
>  					continue;
> -				b = ffz((unsigned long)*byte);
> +				b = __ffs(~((unsigned long)*byte));
>  				if (b < 8 && b >= (bit & 7)) {
>  					ll = data_pos + (bit & ~7ull) + b;
>  					if (unlikely(ll > (1ll << 32))) {
> diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
> index f855dcb..f021023 100644
> --- a/fs/udf/balloc.c
> +++ b/fs/udf/balloc.c
> @@ -75,7 +75,7 @@ static inline int find_next_one_bit(void *addr, int size, int offset)
>  found_first:
>  	tmp &= ~0UL >> (BITS_PER_LONG - size);
>  found_middle:
> -	return result + ffz(~tmp);
> +	return result + __ffs(tmp);
>  }
>  
>  #define find_first_one_bit(addr, size)\
> diff --git a/fs/xfs/xfs_bit.c b/fs/xfs/xfs_bit.c
> index fab0b6d..d09991d 100644
> --- a/fs/xfs/xfs_bit.c
> +++ b/fs/xfs/xfs_bit.c
> @@ -179,7 +179,7 @@ xfs_contig_bits(uint *map, uint	size, uint start_bit)
>  	}
>  	return result - start_bit;
>  found:
> -	return result + ffz(tmp) - start_bit;
> +	return result + __ffs(~tmp) - start_bit;
>  }
>  
>  /*
> diff --git a/include/asm-m68knommu/bitops.h b/include/asm-m68knommu/bitops.h
> index c142fbf..476ad9f 100644
> --- a/include/asm-m68knommu/bitops.h
> +++ b/include/asm-m68knommu/bitops.h
> @@ -289,9 +289,9 @@ found_first:
>  	 * see above. But then we have to swab tmp below for ffz, so
>  	 * we might as well do this here.
>  	 */
> -	return result + ffz(__swab32(tmp) | (~0UL << size));
> +	return result + __ffs(~(__swab32(tmp) | (~0UL << size)));
>  found_middle:
> -	return result + ffz(__swab32(tmp));
> +	return result + __ffs(~(__swab32(tmp)));
>  }
>  
>  #define ext2_find_next_bit(addr, size, off) \
> diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
> index fc4e3db..306d62f 100644
> --- a/include/linux/inetdevice.h
> +++ b/include/linux/inetdevice.h
> @@ -217,7 +217,7 @@ static __inline__ int inet_mask_len(__be32 mask)
>  	__u32 hmask = ntohl(mask);
>  	if (!hmask)
>  		return 0;
> -	return 32 - ffz(~hmask);
> +	return 32 - __ffs(hmask);
>  }
>  
>  
> diff --git a/include/linux/signal.h b/include/linux/signal.h
> index 42d2e0a..5cce0a4 100644
> --- a/include/linux/signal.h
> +++ b/include/linux/signal.h
> @@ -64,7 +64,7 @@ static inline int sigismember(sigset_t *set, int _sig)
>  
>  static inline int sigfindinword(unsigned long word)
>  {
> -	return ffz(~word);
> +	return __ffs(word);
>  }
>  
>  #endif /* __HAVE_ARCH_SIG_BITOPS */
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 6af1210..8814bce 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -142,7 +142,7 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
>  	default:
>  		for (i = 0; i < _NSIG_WORDS; ++i, ++s, ++m)
>  			if ((x = *s &~ *m) != 0) {
> -				sig = ffz(~x) + i*_NSIG_BPW + 1;
> +				sig = __ffs(x) + i*_NSIG_BPW + 1;
>  				break;
>  			}
>  		break;
> @@ -153,11 +153,11 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
>  			sig = _NSIG_BPW + 1;
>  		else
>  			break;
> -		sig += ffz(~x);
> +		sig += __ffs(x);
>  		break;
>  
>  	case 1: if ((x = *s &~ *m) != 0)
> -			sig = ffz(~x) + 1;
> +			sig = __ffs(x) + 1;
>  		break;
>  	}
>  	
> diff --git a/lib/find_next_bit.c b/lib/find_next_bit.c
> index 78ccd73..173359c 100644
> --- a/lib/find_next_bit.c
> +++ b/lib/find_next_bit.c
> @@ -103,7 +103,7 @@ found_first:
>  	if (tmp == ~0UL)	/* Are any bits zero? */
>  		return result + size;	/* Nope. */
>  found_middle:
> -	return result + ffz(tmp);
> +	return result + __ffs(~tmp);
>  }
>  
>  EXPORT_SYMBOL(find_next_zero_bit);
> @@ -170,10 +170,10 @@ found_first:
>  	if (tmp == ~0UL)	/* Are any bits zero? */
>  		return result + size; /* Nope. Skip ffz */
>  found_middle:
> -	return result + ffz(tmp);
> +	return result + __ffs(~tmp);
>  
>  found_middle_swap:
> -	return result + ffz(ext2_swab(tmp));
> +	return result + __ffs(~(ext2_swab(tmp)));
>  }
>  
>  EXPORT_SYMBOL(generic_find_next_zero_le_bit);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 402a504..a98e344 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2447,7 +2447,7 @@ static inline unsigned long wait_table_hash_nr_entries(unsigned long pages)
>   */
>  static inline unsigned long wait_table_bits(unsigned long size)
>  {
> -	return ffz(~size);
> +	return __ffs(size);
>  }
>  
>  #define LONG_ALIGN(x) (((x)+(sizeof(long))-1)&~((sizeof(long))-1))
> diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
> index 09969c1..df8b935 100644
> --- a/net/sched/sch_cbq.c
> +++ b/net/sched/sch_cbq.c
> @@ -637,7 +637,7 @@ static enum hrtimer_restart cbq_undelay(struct hrtimer *timer)
>  	q->pmask = 0;
>  
>  	while (pmask) {
> -		int prio = ffz(~pmask);
> +		int prio = __ffs(pmask);
>  		psched_tdiff_t tmp;
>  
>  		pmask &= ~(1<<prio);
> @@ -961,7 +961,7 @@ cbq_dequeue_1(struct Qdisc *sch)
>  
>  	activemask = q->activemask&0xFF;
>  	while (activemask) {
> -		int prio = ffz(~activemask);
> +		int prio = __ffs(activemask);
>  		activemask &= ~(1<<prio);
>  		skb = cbq_dequeue_prio(sch, prio);
>  		if (skb)
> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> index 66148cc..848053a 100644
> --- a/net/sched/sch_htb.c
> +++ b/net/sched/sch_htb.c
> @@ -343,7 +343,7 @@ static inline void htb_add_class_to_row(struct htb_sched *q,
>  {
>  	q->row_mask[cl->level] |= mask;
>  	while (mask) {
> -		int prio = ffz(~mask);
> +		int prio = __ffs(mask);
>  		mask &= ~(1 << prio);
>  		htb_add_to_id_tree(q->row[cl->level] + prio, cl, prio);
>  	}
> @@ -373,7 +373,7 @@ static inline void htb_remove_class_from_row(struct htb_sched *q,
>  	int m = 0;
>  
>  	while (mask) {
> -		int prio = ffz(~mask);
> +		int prio = __ffs(mask);
>  
>  		mask &= ~(1 << prio);
>  		if (q->ptr[cl->level][prio] == cl->node + prio)
> @@ -401,7 +401,7 @@ static void htb_activate_prios(struct htb_sched *q, struct htb_class *cl)
>  	while (cl->cmode == HTB_MAY_BORROW && p && mask) {
>  		m = mask;
>  		while (m) {
> -			int prio = ffz(~m);
> +			int prio = __ffs(m);
>  			m &= ~(1 << prio);
>  
>  			if (p->un.inner.feed[prio].rb_node)
> @@ -436,7 +436,7 @@ static void htb_deactivate_prios(struct htb_sched *q, struct htb_class *cl)
>  		m = mask;
>  		mask = 0;
>  		while (m) {
> -			int prio = ffz(~m);
> +			int prio = __ffs(m);
>  			m &= ~(1 << prio);
>  
>  			if (p->un.inner.ptr[prio] == cl->node + prio) {
> @@ -925,7 +925,7 @@ static struct sk_buff *htb_dequeue(struct Qdisc *sch)
>  
>  		m = ~q->row_mask[level];
>  		while (m != (int)(-1)) {
> -			int prio = ffz(m);
> +			int prio = __ffs(~m);
>  			m |= 1 << prio;
>  			skb = htb_dequeue_tree(q, prio, level);
>  			if (likely(skb != NULL)) {
> diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
> index 75daed2..70535d8 100644
> --- a/sound/core/oss/mixer_oss.c
> +++ b/sound/core/oss/mixer_oss.c
> @@ -217,7 +217,7 @@ static int snd_mixer_oss_set_recsrc(struct snd_mixer_oss_file *fmixer, int recsr
>  	if (mixer->get_recsrc && mixer->put_recsrc) {	/* exclusive input */
>  		if (recsrc & ~mixer->oss_recsrc)
>  			recsrc &= ~mixer->oss_recsrc;
> -		mixer->put_recsrc(fmixer, ffz(~recsrc));
> +		mixer->put_recsrc(fmixer, __ffs(recsrc));
>  		mixer->get_recsrc(fmixer, &result);
>  		result = 1 << result;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

