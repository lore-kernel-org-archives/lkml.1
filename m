Return-Path: <linux-kernel-owner+w=401wt.eu-S1761936AbYFDSLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761936AbYFDSLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761547AbYFDSLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:11:08 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:43427 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758326AbYFDSK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:10:58 -0400
Date: Tue, 3 Jun 2008 20:31:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc4: RIP __call_for_each_cic+0x20/0x50
Message-ID: <20080604033118.GA10171@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080504190811.GP12774@kernel.dk> <20080504201542.GA1040@martell.zuzino.mipt.ru> <20080510103719.GA4967@martell.zuzino.mipt.ru> <20080527052740.GB28301@martell.zuzino.mipt.ru> <20080527133510.GV7712@kernel.dk> <20080527151809.GA14296@linux.vnet.ibm.com> <20080528100721.GQ25504@kernel.dk> <20080528103026.GE8255@linux.vnet.ibm.com> <20080528124423.GV25504@kernel.dk> <20080530183428.GA24449@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080530183428.GA24449@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 10:34:28PM +0400, Alexey Dobriyan wrote:
> 	[test patch]
> 
> Ha-ha! Posting full dmesg just in case something important is missed.
> 
> I checked that .version and number in uname match, timestamps between
> vmlinux and vmlinuz are within 20 seconds, there is call to
> __rcu_read_lock at the beginning of cfq_cic_lookup(), MD5 of vmlinuz and
> vmliniz after reinstalling match so I'm pretty sure I booted right kernel.
> 
> Kernel is 2.6.24 with the following patch (one fix for my NIC, one
> debugging for Oleg, one for you:

Interesting...

> [4300003.945984] RIP: 0010:[<ffffffff80304b10>]  [<ffffffff80304b10>] __call_for_each_cic+0x20/0x50
> [4300003.946943] Call Trace:
> [4300003.947037]  [<ffffffff80304b50>] cfq_free_io_context+0x10/0x20
> [4300003.947037]  [<ffffffff802fffdb>] put_io_context+0x7b/0x90
> [4300003.947037]  [<ffffffff803000af>] exit_io_context+0x8f/0xb0
> [4300003.947037]  [<ffffffff80235f28>] do_exit+0x558/0x770
> [4300003.947037]  [<ffffffff80236181>] do_group_exit+0x41/0xb0
> [4300003.947037]  [<ffffffff80236202>] sys_exit_group+0x12/0x20
> [4300003.947037]  [<ffffffff8020b68b>] system_call_after_swapgs+0x7b/0x80

The fact that put_io_context() was called from exit_io_context() means
that this is the last thread of a process exiting.  The fact that
cfq_free_io_context() was called (via cfq_dtor()) from put_io_context()
means that this was the last reference to the io_context.  Yet when
we traverse the cic_list, part of it is corrupted -- ascii "k"s through
RAX and RBX.

In other news, I have been hammering preemptable RCU with rcutorture, and
will be making rcutorture more aggressive.  When I get back home, I will
try reproducing this test workload.

							Thanx, Paul

> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index b399c62..8cdb821 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1142,6 +1142,9 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
>  	kmem_cache_free(cfq_pool, cfqq);
>  }
> 
> +/*
> + * Must always be called with the rcu_read_lock() held
> + */
>  static void
>  __call_for_each_cic(struct io_context *ioc,
>  		    void (*func)(struct io_context *, struct cfq_io_context *))
> @@ -1197,6 +1200,11 @@ static void cic_free_func(struct io_context *ioc, struct cfq_io_context *cic)
>  	cfq_cic_free(cic);
>  }
> 
> +/*
> + * Must be called with rcu_read_lock() held or preemption otherwise disabled.
> + * Only two callers of this - ->dtor() which is called with the rcu_read_lock(),
> + * and ->trim() which is called with the task lock held
> + */
>  static void cfq_free_io_context(struct io_context *ioc)
>  {
>  	/*
> @@ -1502,20 +1510,24 @@ static struct cfq_io_context *
>  cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
>  {
>  	struct cfq_io_context *cic;
> +	unsigned long flags;
>  	void *k;
> 
>  	if (unlikely(!ioc))
>  		return NULL;
> 
> +	rcu_read_lock();
> +
>  	/*
>  	 * we maintain a last-hit cache, to avoid browsing over the tree
>  	 */
>  	cic = rcu_dereference(ioc->ioc_data);
> -	if (cic && cic->key == cfqd)
> +	if (cic && cic->key == cfqd) {
> +		rcu_read_unlock();
>  		return cic;
> +	}
> 
>  	do {
> -		rcu_read_lock();
>  		cic = radix_tree_lookup(&ioc->radix_root, (unsigned long) cfqd);
>  		rcu_read_unlock();
>  		if (!cic)
> @@ -1524,10 +1536,13 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
>  		k = cic->key;
>  		if (unlikely(!k)) {
>  			cfq_drop_dead_cic(cfqd, ioc, cic);
> +			rcu_read_lock();
>  			continue;
>  		}
> 
> +		spin_lock_irqsave(&ioc->lock, flags);
>  		rcu_assign_pointer(ioc->ioc_data, cic);
> +		spin_unlock_irqrestore(&ioc->lock, flags);
>  		break;
>  	} while (1);
> 
> @@ -2134,6 +2149,10 @@ static void *cfq_init_queue(struct request_queue *q)
> 
>  static void cfq_slab_kill(void)
>  {
> +	/*
> +	 * Caller already ensured that pending RCU callbacks are completed,
> +	 * so we should have no busy allocations at this point.
> +	 */
>  	if (cfq_pool)
>  		kmem_cache_destroy(cfq_pool);
>  	if (cfq_ioc_pool)
> @@ -2292,6 +2311,11 @@ static void __exit cfq_exit(void)
>  	ioc_gone = &all_gone;
>  	/* ioc_gone's update must be visible before reading ioc_count */
>  	smp_wmb();
> +
> +	/*
> +	 * this also protects us from entering cfq_slab_kill() with
> +	 * pending RCU callbacks
> +	 */
>  	if (elv_ioc_count_read(ioc_count))
>  		wait_for_completion(ioc_gone);
>  	cfq_slab_kill();
> diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
> index 6e4c80d..6ddc911 100644
> --- a/drivers/net/atlx/atl1.c
> +++ b/drivers/net/atlx/atl1.c
> @@ -2023,6 +2023,7 @@ rrd_ok:
>  		/* Good Receive */
>  		pci_unmap_page(adapter->pdev, buffer_info->dma,
>  			       buffer_info->length, PCI_DMA_FROMDEVICE);
> +		buffer_info->dma = 0;
>  		skb = buffer_info->skb;
>  		length = le16_to_cpu(rrd->xsz.xsum_sz.pkt_size);
> 
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 20d59fa..a9d6010 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -209,6 +209,15 @@ void put_pid(struct pid *pid)
>  	ns = pid->numbers[pid->level].ns;
>  	if ((atomic_read(&pid->count) == 1) ||
>  	     atomic_dec_and_test(&pid->count)) {
> +		int type = PIDTYPE_MAX;
> +		while (--type >= 0) {
> +			if (!hlist_empty(&pid->tasks[type])) {
> +				printk("%s: not empty pid = %p, type = %d\n",
> +					__func__, pid, type);
> +				WARN_ON(1);
> +				return;
> +			}
> +		}
>  		kmem_cache_free(ns->pid_cachep, pid);
>  		put_pid_ns(ns);
>  	}
> 
> 
> [    0.000000] Linux version 2.6.26-rc4 (ad@martell) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #5 SMP PREEMPT Wed May 28 22:22:37 MSD 2008
> [    0.000000] Command line: root=/dev/sda2 netconsole=@192.168.0.1/eth0,9353@192.168.0.42/00:1b:38:af:22:49 ignore_loglevel
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
> [    0.000000]  BIOS-e820: 000000007ff90000 - 000000007ff9e000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000007ff9e000 - 000000007ffe0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000180000000 (usable)
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
> [    0.000000] Entering add_active_range(0, 256, 524176) 1 entries of 256 used
> [    0.000000] Entering add_active_range(0, 1048576, 1572864) 2 entries of 256 used
> [    0.000000] max_pfn_mapped = 1572864
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] init_memory_mapping
> [    0.000000] DMI 2.4 present.
> [    0.000000] ACPI: RSDP 000FA980, 0024 (r2 ACPIAM)
> [    0.000000] ACPI: XSDT 7FF90100, 0054 (r1 KOZIRO FRONTIER  2000707 MSFT       97)
> [    0.000000] ACPI: FACP 7FF90290, 00F4 (r3 MSTEST OEMFACP   2000707 MSFT       97)
> [    0.000000] ACPI: DSDT 7FF905C0, 8FA9 (r1  A0637 A0637000        0 INTL 20060113)
> [    0.000000] ACPI: FACS 7FF9E000, 0040
> [    0.000000] ACPI: APIC 7FF90390, 006C (r1 MSTEST OEMAPIC   2000707 MSFT       97)
> [    0.000000] ACPI: MCFG 7FF90400, 003C (r1 MSTEST OEMMCFG   2000707 MSFT       97)
> [    0.000000] ACPI: SLIC 7FF90440, 0176 (r1 KOZIRO FRONTIER  2000707 MSFT       97)
> [    0.000000] ACPI: OEMB 7FF9E040, 007B (r1 MSTEST AMI_OEM   2000707 MSFT       97)
> [    0.000000] ACPI: HPET 7FF99570, 0038 (r1 MSTEST OEMHPET   2000707 MSFT       97)
> [    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
> [    0.000000] Entering add_active_range(0, 256, 524176) 1 entries of 256 used
> [    0.000000] Entering add_active_range(0, 1048576, 1572864) 2 entries of 256 used
> [    0.000000]   early res: 0 [0-fff] BIOS data page
> [    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
> [    0.000000]   early res: 2 [200000-af2207] TEXT DATA BSS
> [    0.000000]   early res: 3 [9fc00-fffff] BIOS reserved
> [    0.000000]   early res: 4 [8000-dfff] PGTABLE
> [    0.000000]  [ffffe20000000000-ffffe200053fffff] PMD -> [ffff81000c200000-ffff8100115fffff] on node 0
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA             0 ->     4096
> [    0.000000]   DMA32        4096 ->  1048576
> [    0.000000]   Normal    1048576 ->  1572864
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[3] active PFN ranges
> [    0.000000]     0:        0 ->      159
> [    0.000000]     0:      256 ->   524176
> [    0.000000]     0:  1048576 ->  1572864
> [    0.000000] On node 0 totalpages: 1048367
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 2397 pages reserved
> [    0.000000]   DMA zone: 1546 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 14280 pages used for memmap
> [    0.000000]   DMA32 zone: 505800 pages, LIFO batch:31
> [    0.000000]   Normal zone: 7168 pages used for memmap
> [    0.000000]   Normal zone: 517120 pages, LIFO batch:31
> [    0.000000]   Movable zone: 0 pages used for memmap
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Setting APIC routing to flat
> [    0.000000] ACPI: HPET id: 0x8086a202 base: 0xfed00000
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:7ee00000)
> [    0.000000] PERCPU: Allocating 33732 bytes of per cpu data
> [    0.000000] NR_CPUS: 2, nr_cpu_ids: 2
> [4294014.506571] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1024466
> [4294014.506571] Kernel command line: root=/dev/sda2 netconsole=@192.168.0.1/eth0,9353@192.168.0.42/00:1b:38:af:22:49 ignore_loglevel
> [4294014.506571] Initializing CPU#0
> [4294014.506571] Preemptible RCU implementation.
> [4294014.506571] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [4294014.506571] Extended CMOS year: 2000
> [4294014.506571] TSC calibrated against PM_TIMER
> [4294014.506571] time.c: Detected 2135.039 MHz processor.
> [4294014.506571] Console: colour VGA+ 80x25
> [4294014.506571] console [tty0] enabled
> [4294014.506571] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [4294014.506571] ... MAX_LOCKDEP_SUBCLASSES:    8
> [4294014.506571] ... MAX_LOCK_DEPTH:          48
> [4294014.506571] ... MAX_LOCKDEP_KEYS:        2048
> [4294014.506571] ... CLASSHASH_SIZE:           1024
> [4294014.506571] ... MAX_LOCKDEP_ENTRIES:     8192
> [4294014.506571] ... MAX_LOCKDEP_CHAINS:      16384
> [4294014.506571] ... CHAINHASH_SIZE:          8192
> [4294014.506571]  memory used by lock dependency info: 1648 kB
> [4294014.506571]  per task-struct memory footprint: 2688 bytes
> [4294014.506571] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [4294014.506571] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [4294014.506571] Checking aperture...
> [4294014.506571] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [4294014.506571] Placing software IO TLB between 0x161d000 - 0x561d000
> [4294014.506571] Memory: 4025184k/6291456k available (2445k kernel code, 167852k reserved, 1415k data, 240k init)
> [4294014.506571] CPA: page pool initialized 64 of 64 pages preallocated
> [4294014.506571] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [4294014.506571] hpet clockevent registered
> [4294014.566487] Calibrating delay using timer specific routine.. 4273.61 BogoMIPS (lpj=2136806)
> [4294014.566561] Mount-cache hash table entries: 256
> [4294014.567488] CPU: L1 I cache: 32K, L1 D cache: 32K
> [4294014.567561] CPU: L2 cache: 2048K
> [4294014.567561] CPU: Physical Processor ID: 0
> [4294014.567561] CPU: Processor Core ID: 0
> [4294014.567561] CPU0: Thermal monitoring enabled (TM2)
> [4294014.567561] using mwait in idle threads.
> [4294014.567561] debug: unmapping init memory ffffffff805df000..ffffffff805e4000
> [4294014.567561] ACPI: Core revision 20080321
> [4294014.607912] CPU0: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 02
> [4294014.608114] Using local APIC timer interrupts.
> [4294014.609555] APIC timer calibration result 16679992
> [4294014.609555] Detected 16.679 MHz APIC timer.
> [4294014.609555] lockdep: fixing up alternatives.
> [4294014.609555] Booting processor 1/1 ip 6000
> [4294014.619023] Initializing CPU#1
> [4294014.619023] Calibrating delay using timer specific routine.. 4269.89 BogoMIPS (lpj=2134946)
> [4294014.619023] CPU: L1 I cache: 32K, L1 D cache: 32K
> [4294014.619023] CPU: L2 cache: 2048K
> [4294014.619023] CPU: Physical Processor ID: 0
> [4294014.619023] CPU: Processor Core ID: 1
> [4294014.619023] CPU1: Thermal monitoring enabled (TM2)
> [4294014.619023] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> [4294014.681144] CPU1: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 02
> [4294014.682127] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> [4294014.682650] Brought up 2 CPUs
> [4294014.682733] Total of 2 processors activated (8543.50 BogoMIPS).
> [4294014.684543] net_namespace: 1040 bytes
> [4294014.684543] NET: Registered protocol family 16
> [4294014.685543] No dock devices found.
> [4294014.685592] ACPI: bus type pci registered
> [4294014.685683] PCI: Using configuration type 1 for base access
> [4294014.692161] ACPI: EC: Look up EC in DSDT
> [4294014.745403] ACPI: Interpreter enabled
> [4294014.745489] ACPI: (supports S0 S5)
> [4294014.745671] ACPI: Using IOAPIC for interrupt routing
> [4294014.783888] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [4294014.785059] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
> [4294014.785224] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
> [4294014.786302] PCI: Transparent bridge - 0000:00:1e.0
> [4294014.786438] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [4294014.789050] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
> [4294014.790048] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> [4294014.791455] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
> [4294014.792085] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
> [4294014.792699] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
> [4294014.851947] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [4294014.852880] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> [4294014.853755] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
> [4294014.854612] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [4294014.855025] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [4294014.855955] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [4294014.856884] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
> [4294014.859254] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
> [4294014.861041] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 08, should be 03 [20080321]
> [4294014.861041] Linux Plug and Play Support v0.97 (c) Adam Belay
> [4294014.861041] pnp: PnP ACPI init
> [4294014.861041] ACPI: bus type pnp registered
> [4294014.876545] pnp: PnP ACPI: found 15 devices
> [4294014.876616] ACPI: ACPI bus type pnp unregistered
> [4294014.877616] SCSI subsystem initialized
> [4294014.877616] libata version 3.00 loaded.
> [4294014.878616] PCI: Using ACPI for IRQ routing
> [4294014.885252] PCI-GART: No AMD northbridge found.
> [4294014.897373] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
> [4294014.897532] system 00:07: ioport range 0x290-0x297 has been reserved
> [4294014.897657] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
> [4294014.897755] system 00:08: ioport range 0x800-0x87f has been reserved
> [4294014.898307] system 00:08: ioport range 0x480-0x4bf has been reserved
> [4294014.898356] system 00:08: iomem range 0xffafe000-0xffb0cbff could not be reserved
> [4294014.898356] system 00:08: iomem range 0xffb00000-0xffbfffff could not be reserved
> [4294014.898356] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
> [4294014.898493] system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
> [4294014.898628] system 00:08: iomem range 0xfff00000-0xfffffffe could not be reserved
> [4294014.898762] system 00:08: iomem range 0xfebfe000-0xfebfec00 has been reserved
> [4294014.899305] system 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
> [4294014.899440] system 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
> [4294014.899585] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
> [4294014.899729] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
> [4294014.899811] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
> [4294014.899915] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
> [4294014.900017] system 00:0e: iomem range 0x100000-0x7fffffff could not be reserved
> [4294014.900152] system 00:0e: iomem range 0x0-0xffffffffffffffff could not be reserved
> [4294014.901942] PCI: Bridge: 0000:00:01.0
> [4294014.902028]   IO window: 9000-9fff
> [4294014.902113]   MEM window: 0xf8700000-0xfe7fffff
> [4294014.902202]   PREFETCH window: 0x00000000bfe00000-0x00000000dfdfffff
> [4294014.902730] PCI: Bridge: 0000:00:1c.0
> [4294014.902814]   IO window: disabled.
> [4294014.902900]   MEM window: disabled.
> [4294014.902985]   PREFETCH window: 0x00000000dfe00000-0x00000000dfefffff
> [4294014.903085] PCI: Bridge: 0000:00:1c.3
> [4294014.903168]   IO window: disabled.
> [4294014.903192]   MEM window: 0xfe900000-0xfe9fffff
> [4294014.903192]   PREFETCH window: disabled.
> [4294014.903286] PCI: Bridge: 0000:00:1c.4
> [4294014.903370]   IO window: a000-afff
> [4294014.903456]   MEM window: 0xfe800000-0xfe8fffff
> [4294014.903546]   PREFETCH window: disabled.
> [4294014.903637] PCI: Bridge: 0000:00:1e.0
> [4294014.903728]   IO window: b000-bfff
> [4294014.903814]   MEM window: 0xfea00000-0xfeafffff
> [4294014.903903]   PREFETCH window: 0x0000000088000000-0x00000000880fffff
> [4294014.904021] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
> [4294014.904191] PCI: Setting latency timer of device 0000:00:01.0 to 64
> [4294014.904311] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
> [4294014.904480] PCI: Setting latency timer of device 0000:00:1c.0 to 64
> [4294014.904725] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
> [4294014.904895] PCI: Setting latency timer of device 0000:00:1c.3 to 64
> [4294014.905010] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
> [4294014.905180] PCI: Setting latency timer of device 0000:00:1c.4 to 64
> [4294014.905284] PCI: Setting latency timer of device 0000:00:1e.0 to 64
> [4294014.905423] NET: Registered protocol family 2
> [4294014.939148] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [4294014.939721] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> [4294014.941766] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
> [4294014.946760] TCP: Hash tables configured (established 262144 bind 65536)
> [4294014.946894] TCP reno registered
> [4294014.958451] NET: Registered protocol family 1
> [4294014.976123] msgmni has been set to 7862 for ipc namespace ffffffff80572380
> [4294014.976123] io scheduler noop registered
> [4294014.977031] io scheduler cfq registered (default)
> [4294014.977031] pci 0000:01:00.0: Boot video device
> [4294014.986266] Real Time Clock Driver v1.12ac
> [4294014.986266] Linux agpgart interface v0.103
> [4294014.986470] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 19 (level, low) -> IRQ 19
> [4294014.986470] PCI: Setting latency timer of device 0000:03:00.0 to 64
> [4294014.986470] atl1 0000:03:00.0: version 2.1.3
> [4294015.012034] Switched to high resolution mode on CPU 1
> [4294015.012878] Switched to high resolution mode on CPU 0
> [4294015.023188] 8139too Fast Ethernet driver 0.9.28
> [4294015.023188] ACPI: PCI Interrupt 0000:05:02.0[A] -> GSI 23 (level, low) -> IRQ 23
> [4294015.024187] eth1: RealTek RTL8139 at 0xb800, 00:80:48:2e:06:2e, IRQ 23
> [4294015.024187] eth1:  Identified 8139 chip type 'RTL-8100B/8139D'
> [4294015.024187] netconsole: local port 6665
> [4294015.024273] netconsole: local IP 192.168.0.1
> [4294015.024273] netconsole: interface eth0
> [4294015.024273] netconsole: remote port 9353
> [4294015.024276] netconsole: remote IP 192.168.0.42
> [4294015.025888] netconsole: remote ethernet address 00:1b:38:af:22:49
> [4294015.025992] netconsole: device eth0 not up yet, forcing it
> [4294017.099102] atl1 0000:03:00.0: eth0 link is up 1000 Mbps full duplex
> [4294017.111214] console [netcon0] enabled
> [4294017.139758] netconsole: network logging started
> [4294017.140754] Driver 'sd' needs updating - please use bus_type methods
> [4294017.141147] ahci 0000:02:00.0: version 3.0
> [4294017.141147] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> [4294018.140956] ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
> [4294018.141102] ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
> [4294018.141249] PCI: Setting latency timer of device 0000:02:00.0 to 64
> [4294018.142241] scsi0 : ahci
> [4294018.143147] scsi1 : ahci
> [4294018.143147] ata1: SATA max UDMA/133 abar m8192@0xfe8fe000 port 0xfe8fe100 irq 16
> [4294018.143345] ata2: SATA max UDMA/133 abar m8192@0xfe8fe000 port 0xfe8fe180 irq 16
> [4294018.448110] ata1: SATA link down (SStatus 0 SControl 300)
> [4294018.753109] ata2: SATA link down (SStatus 0 SControl 300)
> [4294018.754706] ata_piix 0000:00:1f.2: version 2.12
> [4294018.754817] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
> [4294018.754995] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
> [4294018.755342] PCI: Setting latency timer of device 0000:00:1f.2 to 64
> [4294018.755342] scsi2 : ata_piix
> [4294018.756173] scsi3 : ata_piix
> [4294018.770890] ata3: SATA max UDMA/133 cmd 0xec00 ctl 0xe880 bmdma 0xe400 irq 19
> [4294018.771029] ata4: SATA max UDMA/133 cmd 0xe800 ctl 0xe480 bmdma 0xe408 irq 19
> [4294019.226141] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [4294019.232666] ata3.00: ATA-8: ST3750330AS, SD15, max UDMA/133
> [4294019.232767] ata3.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [4294019.266037] ata3.01: ATA-7: ST3160811AS, 3.AAE, max UDMA/133
> [4294019.266037] ata3.01: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [4294019.272668] ata3.00: configured for UDMA/133
> [4294019.324047] ata3.01: configured for UDMA/133
> [4294019.780119] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [4294019.816037] ata4.00: ATA-7: ST3250620AS, 3.AAE, max UDMA/133
> [4294019.816037] ata4.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [4294019.891046] ata4.00: configured for UDMA/133
> [4294019.891046] scsi 2:0:0:0: Direct-Access     ATA      ST3750330AS      SD15 PQ: 0 ANSI: 5
> [4294019.893307] sd 2:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
> [4294019.893459] sd 2:0:0:0: [sda] Write Protect is off
> [4294019.893459] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [4294019.893513] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [4294019.894080] sd 2:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
> [4294019.894305] sd 2:0:0:0: [sda] Write Protect is off
> [4294019.894305] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [4294019.894362] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [4294019.894527]  sda: sda1 sda2
> [4294019.931316] sd 2:0:0:0: [sda] Attached SCSI disk
> [4294019.931316] scsi 2:0:1:0: Direct-Access     ATA      ST3160811AS      3.AA PQ: 0 ANSI: 5
> [4294019.932060] sd 2:0:1:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
> [4294019.932234] sd 2:0:1:0: [sdb] Write Protect is off
> [4294019.932307] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [4294019.932307] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [4294019.932307] sd 2:0:1:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
> [4294019.932487] sd 2:0:1:0: [sdb] Write Protect is off
> [4294019.932581] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [4294019.932749] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [4294019.932896]  sdb: unknown partition table
> [4294019.955303] sd 2:0:1:0: [sdb] Attached SCSI disk
> [4294019.957296] scsi 3:0:0:0: Direct-Access     ATA      ST3250620AS      3.AA PQ: 0 ANSI: 5
> [4294019.957296] sd 3:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
> [4294019.957481] sd 3:0:0:0: [sdc] Write Protect is off
> [4294019.957575] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [4294019.957750] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [4294019.958022] sd 3:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
> [4294019.958202] sd 3:0:0:0: [sdc] Write Protect is off
> [4294019.958300] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [4294019.958479] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [4294019.958625]  sdc: sdc1
> [4294019.974297] sd 3:0:0:0: [sdc] Attached SCSI disk
> [4294019.974297] ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 19 (level, low) -> IRQ 19
> [4294019.974297] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
> [4294019.974519] PCI: Setting latency timer of device 0000:00:1f.5 to 64
> [4294019.975300] scsi4 : ata_piix
> [4294019.975301] scsi5 : ata_piix
> [4294019.984287] ata5: SATA max UDMA/133 cmd 0xd400 ctl 0xd080 bmdma 0xc880 irq 19
> [4294019.984287] ata6: SATA max UDMA/133 cmd 0xd000 ctl 0xcc00 bmdma 0xc888 irq 19
> [4294020.298796] ata5: SATA link down (SStatus 0 SControl 300)
> [4294020.613795] ata6: SATA link down (SStatus 0 SControl 300)
> [4294020.614953] ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 17 (level, low) -> IRQ 17
> [4294020.615172] PCI: Setting latency timer of device 0000:02:00.1 to 64
> [4294020.615408] scsi6 : pata_jmicron
> [4294020.615408] scsi7 : pata_jmicron
> [4294020.619409] ata7: PATA max UDMA/100 cmd 0xac00 ctl 0xa880 bmdma 0xa400 irq 17
> [4294020.619409] ata8: PATA max UDMA/100 cmd 0xa800 ctl 0xa480 bmdma 0xa408 irq 17
> [4294020.924351] ata7.01: ATAPI: _NEC DV-5800C, D9S2, max UDMA/33
> [4294020.924889] ata7.01: configured for UDMA/33
> [4294021.233785] scsi 6:0:1:0: CD-ROM            _NEC     DV-5800C         D9S2 PQ: 0 ANSI: 5
> [4294021.235400] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> [4294021.235400] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
> [4294021.236404] serio: i8042 KBD port at 0x60,0x64 irq 1
> [4294021.236404] mice: PS/2 mouse device common for all mice
> [4294021.237401] Advanced Linux Sound Architecture Driver Version 1.0.16.
> [4294021.238436] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
> [4294021.240156] PCI: Setting latency timer of device 0000:00:1b.0 to 64
> [4294021.253726] input: AT Translated Set 2 keyboard as /class/input/input0
> [4294021.623063] ALSA device list:
> [4294021.623063]   #0: HDA Intel at 0xfebf8000 irq 22
> [4294021.623179] TCP cubic registered
> [4294021.660774] kjournald starting.  Commit interval 5 seconds
> [4294021.656982] EXT3-fs: mounted filesystem with ordered data mode.
> [4294021.656982] VFS: Mounted root (ext3 filesystem) readonly.
> [4294021.656982] debug: unmapping init memory ffffffff805e4000..ffffffff80620000
> [4294021.661096] Write protecting the kernel read-only data: 3412k
> [4294021.661314] Testing CPA: undo ffffffff8046e000-ffffffff8055e000
> [4294021.661445] Testing CPA: again
> [4294023.534235] Driver 'sr' needs updating - please use bus_type methods
> [4294023.546361] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
> [4294023.546473] Uniform CD-ROM driver Revision: 3.20
> [4294023.546816] sr 6:0:1:0: Attached scsi CD-ROM sr0
> [4294023.570726] usbcore: registered new interface driver usbfs
> [4294023.570898] usbcore: registered new interface driver hub
> [4294023.576263] usbcore: registered new device driver usb
> [4294023.579267] USB Universal Host Controller Interface driver v3.0
> [4294023.579998] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
> [4294023.580193] PCI: Setting latency timer of device 0000:00:1a.0 to 64
> [4294023.580300] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [4294023.580725] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
> [4294023.580905] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000dc00
> [4294023.581598] usb usb1: configuration #1 chosen from 1 choice
> [4294023.581862] hub 1-0:1.0: USB hub found
> [4294023.582035] hub 1-0:1.0: 2 ports detected
> [4294023.683559] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
> [4294023.683670] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [4294023.683809] usb usb1: Product: UHCI Host Controller
> [4294023.683809] usb usb1: Manufacturer: Linux 2.6.26-rc4 uhci_hcd
> [4294023.683809] usb usb1: SerialNumber: 0000:00:1a.0
> [4294023.683809] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
> [4294023.684033] PCI: Setting latency timer of device 0000:00:1a.1 to 64
> [4294023.684134] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [4294023.684594] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
> [4294023.684765] uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000e000
> [4294023.685097] usb usb2: configuration #1 chosen from 1 choice
> [4294023.685295] hub 2-0:1.0: USB hub found
> [4294023.685400] hub 2-0:1.0: 2 ports detected
> [4294023.786278] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> [4294023.786389] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [4294023.786593] usb usb2: Product: UHCI Host Controller
> [4294023.786691] usb usb2: Manufacturer: Linux 2.6.26-rc4 uhci_hcd
> [4294023.786787] usb usb2: SerialNumber: 0000:00:1a.1
> [4294023.786967] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
> [4294023.787162] PCI: Setting latency timer of device 0000:00:1a.7 to 64
> [4294023.787287] ehci_hcd 0000:00:1a.7: EHCI Host Controller
> [4294023.787593] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 3
> [4294023.791704] ehci_hcd 0000:00:1a.7: debug port 1
> [4294023.791816] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
> [4294023.791972] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfebffc00
> [4294023.801337] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> [4294023.801820] usb usb3: configuration #1 chosen from 1 choice
> [4294023.802010] hub 3-0:1.0: USB hub found
> [4294023.802189] hub 3-0:1.0: 4 ports detected
> [4294023.903972] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [4294023.904439] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [4294023.904591] usb usb3: Product: EHCI Host Controller
> [4294023.904685] usb usb3: Manufacturer: Linux 2.6.26-rc4 ehci_hcd
> [4294023.904787] usb usb3: SerialNumber: 0000:00:1a.7
> [4294023.904931] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
> [4294023.905127] PCI: Setting latency timer of device 0000:00:1d.0 to 64
> [4294023.905236] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [4294023.905436] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
> [4294023.905625] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d480
> [4294023.906151] usb usb4: configuration #1 chosen from 1 choice
> [4294023.906369] hub 4-0:1.0: USB hub found
> [4294023.906481] hub 4-0:1.0: 2 ports detected
> [4294024.007354] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [4294024.007875] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [4294024.008024] usb usb4: Product: UHCI Host Controller
> [4294024.008122] usb usb4: Manufacturer: Linux 2.6.26-rc4 uhci_hcd
> [4294024.008220] usb usb4: SerialNumber: 0000:00:1d.0
> [4294024.008395] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
> [4294024.008581] PCI: Setting latency timer of device 0000:00:1d.7 to 64
> [4294024.008704] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [4294024.008872] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
> [4294024.013011] ehci_hcd 0000:00:1d.7: debug port 1
> [4294024.013126] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
> [4294024.013272] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfebff800
> [4294024.022630] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> [4294024.023099] usb usb5: configuration #1 chosen from 1 choice
> [4294024.023303] hub 5-0:1.0: USB hub found
> [4294024.023419] hub 5-0:1.0: 6 ports detected
> [4294024.123981] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
> [4294024.124094] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [4294024.124242] usb usb5: Product: EHCI Host Controller
> [4294024.124340] usb usb5: Manufacturer: Linux 2.6.26-rc4 ehci_hcd
> [4294024.124436] usb usb5: SerialNumber: 0000:00:1d.7
> [4294024.124567] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
> [4294024.124759] PCI: Setting latency timer of device 0000:00:1d.1 to 64
> [4294024.124867] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [4294024.125862] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
> [4294024.125862] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d800
> [4294024.125862] usb usb6: configuration #1 chosen from 1 choice
> [4294024.126053] hub 6-0:1.0: USB hub found
> [4294024.126158] hub 6-0:1.0: 2 ports detected
> [4294024.227783] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [4294024.227783] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [4294024.227783] usb usb6: Product: UHCI Host Controller
> [4294024.227783] usb usb6: Manufacturer: Linux 2.6.26-rc4 uhci_hcd
> [4294024.227783] usb usb6: SerialNumber: 0000:00:1d.1
> [4294024.227783] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
> [4294024.227783] PCI: Setting latency timer of device 0000:00:1d.2 to 64
> [4294024.227888] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [4294024.234787] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
> [4294024.234958] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d880
> [4294024.235390] usb usb7: configuration #1 chosen from 1 choice
> [4294024.235641] hub 7-0:1.0: USB hub found
> [4294024.235783] hub 7-0:1.0: 2 ports detected
> [4294024.336777] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
> [4294024.337631] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [4294024.337631] usb usb7: Product: UHCI Host Controller
> [4294024.337631] usb usb7: Manufacturer: Linux 2.6.26-rc4 uhci_hcd
> [4294024.337631] usb usb7: SerialNumber: 0000:00:1d.2
> [4294025.275801] EXT3 FS on sda2, internal journal
> [4294025.576923] usbcore: registered new interface driver usblp
> [4294025.699206] Adding 9775512k swap on /dev/sda1.  Priority:-1 extents:1 across:9775512k
> [4294034.064415] ip_tables: (C) 2000-2006 Netfilter Core Team
> [4294034.072599] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [4294036.120084] eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
> [4294045.749739] CPA self-test:
> [4294045.752254]  4k 16384 large 2528 gb 0 x 0[0-0] miss 262144
> [4294045.761417]  4k 187392 large 2194 gb 0 x 0[0-0] miss 262144
> [4294045.768378]  4k 187392 large 2194 gb 0 x 0[0-0] miss 262144
> [4294045.768608] ok.
> [4294376.517131] warning: `capget01' uses 32-bit capabilities (legacy support in use)
> [4294665.514678] Adding 65528k swap on ./swapfile01.  Priority:-2 extents:27 across:91612k
> [4294667.501075] Adding 65528k swap on ./swapfile01.  Priority:-3 extents:40 across:157332k
> [4294669.395350] Adding 65528k swap on ./swapfile01.  Priority:-4 extents:21 across:108832k
> [4294669.504418] Unable to find swap-space signature
> [4294669.548523] Adding 32k swap on alreadyused.  Priority:-5 extents:1 across:32k
> [4294669.594260] Adding 32k swap on swapfile02.  Priority:-6 extents:3 across:56k
> [4294669.657350] Adding 32k swap on swapfile03.  Priority:-7 extents:1 across:32k
> [4294669.697470] Adding 32k swap on swapfile04.  Priority:-8 extents:2 across:76k
> [4294669.711497] Adding 32k swap on swapfile05.  Priority:-9 extents:1 across:32k
> [4294669.757754] Adding 32k swap on swapfile06.  Priority:-10 extents:2 across:48k
> [4294669.772201] Adding 32k swap on swapfile07.  Priority:-11 extents:1 across:32k
> [4294669.792286] Adding 32k swap on swapfile08.  Priority:-12 extents:2 across:1820k
> [4294669.817947] Adding 32k swap on swapfile09.  Priority:-13 extents:1 across:32k
> [4294669.839671] Adding 32k swap on swapfile10.  Priority:-14 extents:1 across:32k
> [4294669.856414] Adding 32k swap on swapfile11.  Priority:-15 extents:2 across:36k
> [4294669.898118] Adding 32k swap on swapfile12.  Priority:-16 extents:1 across:32k
> [4294669.918366] Adding 32k swap on swapfile13.  Priority:-17 extents:1 across:32k
> [4294669.932981] Adding 32k swap on swapfile14.  Priority:-18 extents:1 across:32k
> [4294669.981569] Adding 32k swap on swapfile15.  Priority:-19 extents:1 across:32k
> [4294670.016775] Adding 32k swap on swapfile16.  Priority:-20 extents:1 across:32k
> [4294670.031717] Adding 32k swap on swapfile17.  Priority:-21 extents:1 across:32k
> [4294670.080750] Adding 32k swap on swapfile18.  Priority:-22 extents:1 across:32k
> [4294670.095724] Adding 32k swap on swapfile19.  Priority:-23 extents:1 across:32k
> [4294670.141188] Adding 32k swap on swapfile20.  Priority:-24 extents:1 across:32k
> [4294670.174754] Adding 32k swap on swapfile21.  Priority:-25 extents:1 across:32k
> [4294670.228986] Adding 32k swap on swapfile22.  Priority:-26 extents:1 across:32k
> [4294670.277409] Adding 32k swap on swapfile23.  Priority:-27 extents:1 across:32k
> [4294670.331498] Adding 32k swap on swapfile24.  Priority:-28 extents:2 across:32k
> [4294670.364858] Adding 32k swap on swapfile25.  Priority:-29 extents:1 across:32k
> [4294670.401739] Adding 32k swap on swapfile26.  Priority:-30 extents:1 across:32k
> [4294670.416923] Adding 32k swap on swapfile27.  Priority:-31 extents:1 across:32k
> [4294670.470795] Adding 32k swap on swapfile28.  Priority:-32 extents:1 across:32k
> [4294670.524872] Adding 32k swap on swapfile29.  Priority:-33 extents:1 across:32k
> [4294670.538548] Adding 32k swap on swapfile30.  Priority:-34 extents:1 across:32k
> [4294670.678744] Adding 32k swap on firstswapfile.  Priority:-35 extents:1 across:32k
> [4294670.679127] Adding 32k swap on secondswapfile.  Priority:-36 extents:1 across:32k
> [4294671.175248] warning: process `sysctl01' used the deprecated sysctl system call with 1.1.
> [4294671.175336] warning: process `sysctl01' used the deprecated sysctl system call with 1.2.
> [4294671.199132] warning: process `sysctl03' used the deprecated sysctl system call with 1.1.
> [4294671.200735] warning: process `sysctl03' used the deprecated sysctl system call with 1.1.
> [4294671.237127] warning: process `sysctl04' used the deprecated sysctl system call with 
> [4295759.981152] eth1: link down
> [4300003.945097] general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
> [4300003.945187] CPU 0 
> [4300003.945984] Modules linked in: ext2 nf_conntrack_irc xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables usblp ehci_hcd uhci_hcd usbcore sr_mod cdrom
> [4300003.945984] Pid: 5929, comm: cc1 Not tainted 2.6.26-rc4 #5
> [4300003.945984] RIP: 0010:[<ffffffff80304b10>]  [<ffffffff80304b10>] __call_for_each_cic+0x20/0x50
> [4300003.945984] RSP: 0018:ffff810074d77e58  EFLAGS: 00010202
> [4300003.945984] RAX: 6b6b6b6b6b6b6b6b RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000000
> [4300003.945984] RDX: 0000000000005f5e RSI: 0000000000000000 RDI: ffff81005a1cc500
> [4300003.945984] RBP: ffff810074d77e78 R08: 0000000000000000 R09: 0000000000000000
> [4300003.945984] R10: 0000000000000000 R11: 0000000000000001 R12: ffff81011058e0c0
> [4300003.945984] R13: ffffffff80304b80 R14: ffff81017fcc0000 R15: ffff81005a1cc668
> [4300003.946943] FS:  00002b1c6a49f6f0(0000) GS:ffffffff805c6000(0000) knlGS:0000000000000000
> [4300003.946943] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [4300003.946943] CR2: 00002aeeefeb5000 CR3: 000000005a8a6000 CR4: 00000000000006e0
> [4300003.946943] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [4300003.946943] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [4300003.946943] Process cc1 (pid: 5929, threadinfo ffff810074d76000, task ffff81005a1cc500)
> [4300003.946943] Stack:  ffff810074d77e88 ffff81011058e0c0 0000000000000010 ffff81005a1cc600
> [4300003.946943]  ffff810074d77e88 ffffffff80304b50 ffff810074d77ea8 ffffffff802fffdb
> [4300003.946943]  ffff81005a1cc600 ffff81011058e0c0 ffff810074d77ec8 ffffffff803000af
> [4300003.946943] Call Trace:
> [4300003.947037]  [<ffffffff80304b50>] cfq_free_io_context+0x10/0x20
> [4300003.947037]  [<ffffffff802fffdb>] put_io_context+0x7b/0x90
> [4300003.947037]  [<ffffffff803000af>] exit_io_context+0x8f/0xb0
> [4300003.947037]  [<ffffffff80235f28>] do_exit+0x558/0x770
> [4300003.947037]  [<ffffffff80236181>] do_group_exit+0x41/0xb0
> [4300003.947037]  [<ffffffff80236202>] sys_exit_group+0x12/0x20
> [4300003.947037]  [<ffffffff8020b68b>] system_call_after_swapgs+0x7b/0x80
> [4300003.947037] 
> [4300003.947037] 
> [4300003.947037] Code: 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 55 49 89 f5 41 54 49 89 fc 53 48 83 ec 08 48 8b 47 68 48 85 c0 74 1f 48 89 c3 90 <48> 8b 03 48 8d 73 88 4c 89 e7 0f 18 08 41 ff d5 48 8b 03 48 85 
> [4300003.948942] RIP  [<ffffffff80304b10>] __call_for_each_cic+0x20/0x50
> [4300003.948942]  RSP <ffff810074d77e58>
> [4300004.868942] ---[ end trace 823782cee637f8c8 ]---
> [4300004.869038] Fixing recursive fault but reboot is needed!
> [4303375.170511] general protection fault: 0000 [2] PREEMPT SMP DEBUG_PAGEALLOC
> [4303375.170600] CPU 1 
> [4303375.170649] Modules linked in: ext2 nf_conntrack_irc xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables usblp ehci_hcd uhci_hcd usbcore sr_mod cdrom
> [4303375.170915] Pid: 4564, comm: cc1 Tainted: G      D   2.6.26-rc4 #5
> [4303375.170982] RIP: 0010:[<ffffffff802a38dc>]  [<ffffffff802a38dc>] __d_lookup+0x8c/0x160
> [4303375.171090] RSP: 0018:ffff81005a24bbc8  EFLAGS: 00010202
> [4303375.171153] RAX: ffff81006361eee0 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000013
> [4303375.171255] RDX: ffff81000100c120 RSI: 0187320a548baac5 RDI: ffff81012873b4e0
> [4303375.171348] RBP: ffff81005a24bc18 R08: 0000000953ed9e00 R09: ffff81000b59000e
> [4303375.171348] R10: ffffffff802a3901 R11: 0000000000000001 R12: 6b6b6b6b6b6b6b2b
> [4303375.171348] R13: 0000000053ed9e00 R14: ffff81012873b4e0 R15: ffff81005a24bcc8
> [4303375.171348] FS:  00002b005628b6f0(0000) GS:ffff81017fc44320(0000) knlGS:0000000000000000
> [4303375.171348] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [4303375.171348] CR2: 00002ac106d23000 CR3: 000000012db71000 CR4: 00000000000006e0
> [4303375.171348] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [4303375.171348] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [4303375.171348] Process cc1 (pid: 4564, threadinfo ffff81005a24a000, task ffff81007f100000)
> [4303375.171348] Stack:  000000005a24bbe8 ffff81012873b4e8 0000000000000007 0000000700000002
> [4303375.171348]  ffff81000b59000e ffff81000b590015 ffff81005a24bcc8 ffff81005a24be48
> [4303375.171348]  ffff81005a24bcc8 ffff81005a24bcd8 ffff81005a24bc68 ffffffff802990c5
> [4303375.171348] Call Trace:
> [4303375.171348]  [<ffffffff802990c5>] do_lookup+0x35/0x200
> [4303375.171348]  [<ffffffff8029aa17>] __link_path_walk+0x8b7/0xea0
> [4303375.171348]  [<ffffffff8028a8d3>] ? check_object+0x223/0x250
> [4303375.171348]  [<ffffffff8029b062>] path_walk+0x62/0xd0
> [4303375.171348]  [<ffffffff8029b2fd>] do_path_lookup+0x8d/0x1d0
> [4303375.171348]  [<ffffffff8029c237>] __path_lookup_intent_open+0x67/0xc0
> [4303375.171348]  [<ffffffff8029c31c>] path_lookup_open+0xc/0x10
> [4303375.171348]  [<ffffffff8029c638>] do_filp_open+0x98/0x8d0
> [4303375.171348]  [<ffffffff80289fff>] ? init_object+0x4f/0x90
> [4303375.171348]  [<ffffffff8028b2e6>] ? __slab_alloc+0xa6/0x660
> [4303375.171348]  [<ffffffff8028e663>] ? get_unused_fd_flags+0x103/0x130
> [4303375.171348]  [<ffffffff8028e6e8>] do_sys_open+0x58/0xb0
> [4303375.171348]  [<ffffffff8028e76b>] sys_open+0x1b/0x20
> [4303375.171348]  [<ffffffff8020b68b>] system_call_after_swapgs+0x7b/0x80
> [4303375.171348] 
> [4303375.171348] 
> [4303375.171348] Code: 51 33 00 e8 27 16 fc ff 48 8b 03 48 89 c3 8b 45 cc 48 85 db 48 89 45 c0 75 0d eb 4c 0f 1f 00 48 8b 1b 48 85 db 74 41 4c 8d 63 c0 <48> 8b 03 45 3b 6c 24 58 0f 18 08 75 e7 4d 3b 74 24 50 75 e0 49 
> [4303375.171348] RIP  [<ffffffff802a38dc>] __d_lookup+0x8c/0x160
> [4303375.171348]  RSP <ffff81005a24bbc8>
> [4303375.537819] ---[ end trace 823782cee637f8c8 ]---
> [4315843.874439] Adding 65528k swap on ./swapfile01.  Priority:-37 extents:25 across:78684k
> [4315896.606972] Adding 65528k swap on ./swapfile01.  Priority:-38 extents:39 across:110892k
> [4315945.905293] Adding 65528k swap on ./swapfile01.  Priority:-39 extents:27 across:120716k
> [4315946.328798] Unable to find swap-space signature
> [4315947.971412] Adding 32k swap on alreadyused.  Priority:-40 extents:1 across:32k
> [4315949.363720] Adding 32k swap on swapfile02.  Priority:-41 extents:2 across:32k
> [4315950.569903] Adding 32k swap on swapfile03.  Priority:-42 extents:2 across:64k
> [4315951.765296] Adding 32k swap on swapfile04.  Priority:-43 extents:4 across:108k
> [4315952.875703] Adding 32k swap on swapfile05.  Priority:-44 extents:2 across:1816k
> [4315954.078312] Adding 32k swap on swapfile06.  Priority:-45 extents:1 across:32k
> [4315955.321904] Adding 32k swap on swapfile07.  Priority:-46 extents:2 across:96k
> [4315956.603960] Adding 32k swap on swapfile08.  Priority:-47 extents:1 across:32k
> [4315957.703750] Adding 32k swap on swapfile09.  Priority:-48 extents:2 across:44k
> [4315958.868482] Adding 32k swap on swapfile10.  Priority:-49 extents:1 across:32k
> [4315960.118592] Adding 32k swap on swapfile11.  Priority:-50 extents:1 across:32k
> [4315961.177483] Adding 32k swap on swapfile12.  Priority:-51 extents:1 across:32k
> [4315962.383246] Adding 32k swap on swapfile13.  Priority:-52 extents:1 across:32k
> [4315963.502439] Adding 32k swap on swapfile14.  Priority:-53 extents:1 across:32k
> [4315964.841896] Adding 32k swap on swapfile15.  Priority:-54 extents:2 across:32k
> [4315966.076074] Adding 32k swap on swapfile16.  Priority:-55 extents:1 across:32k
> [4315967.312097] Adding 32k swap on swapfile17.  Priority:-56 extents:1 across:32k
> [4315968.520294] Adding 32k swap on swapfile18.  Priority:-57 extents:2 across:44k
> [4315970.568662] Adding 32k swap on swapfile19.  Priority:-58 extents:2 across:32k
> [4315971.745911] Adding 32k swap on swapfile20.  Priority:-59 extents:2 across:168k
> [4315972.889984] Adding 32k swap on swapfile21.  Priority:-60 extents:2 across:1972k
> [4315974.133342] Adding 32k swap on swapfile22.  Priority:-61 extents:3 across:80k
> [4315975.349761] Adding 32k swap on swapfile23.  Priority:-62 extents:2 across:128k
> [4315976.507355] Adding 32k swap on swapfile24.  Priority:-63 extents:1 across:32k
> [4315977.705342] Adding 32k swap on swapfile25.  Priority:-64 extents:1 across:32k
> [4315978.734944] Adding 32k swap on swapfile26.  Priority:-65 extents:2 across:44k
> [4315979.838154] Adding 32k swap on swapfile27.  Priority:-66 extents:2 across:40k
> [4315981.418786] Adding 32k swap on swapfile28.  Priority:-67 extents:1 across:32k
> [4315982.727733] Adding 32k swap on swapfile29.  Priority:-68 extents:2 across:76k
> [4315983.849257] Adding 32k swap on swapfile30.  Priority:-69 extents:1 across:32k
> [4315987.520587] Adding 32k swap on firstswapfile.  Priority:-70 extents:1 across:32k
> [4315987.520978] Adding 32k swap on secondswapfile.  Priority:-71 extents:1 across:32k
> [4323489.250419] Adding 65528k swap on ./swapfile01.  Priority:-72 extents:33 across:91720k
> [4323499.912624] Adding 65528k swap on ./swapfile01.  Priority:-73 extents:21 across:108164k
> [4323509.465260] Adding 65528k swap on ./swapfile01.  Priority:-74 extents:22 across:135344k
> [4323509.902961] Unable to find swap-space signature
> [4323510.351682] Adding 32k swap on alreadyused.  Priority:-75 extents:3 across:56k
> [4323510.543041] Adding 32k swap on swapfile02.  Priority:-76 extents:2 across:48k
> [4323510.707738] Adding 32k swap on swapfile03.  Priority:-77 extents:2 across:32k
> [4323510.972613] Adding 32k swap on swapfile04.  Priority:-78 extents:1 across:32k
> [4323511.245119] Adding 32k swap on swapfile05.  Priority:-79 extents:2 across:32k
> [4323511.461175] Adding 32k swap on swapfile06.  Priority:-80 extents:1 across:32k
> [4323511.674829] Adding 32k swap on swapfile07.  Priority:-81 extents:1 across:32k
> [4323511.936764] Adding 32k swap on swapfile08.  Priority:-82 extents:1 across:32k
> [4323512.117014] Adding 32k swap on swapfile09.  Priority:-83 extents:1 across:32k
> [4323512.312200] Adding 32k swap on swapfile10.  Priority:-84 extents:1 across:32k
> [4323512.508573] Adding 32k swap on swapfile11.  Priority:-85 extents:2 across:32k
> [4323512.710991] Adding 32k swap on swapfile12.  Priority:-86 extents:1 across:32k
> [4323512.971457] Adding 32k swap on swapfile13.  Priority:-87 extents:1 across:32k
> [4323513.157480] Adding 32k swap on swapfile14.  Priority:-88 extents:2 across:32k
> [4323513.415857] Adding 32k swap on swapfile15.  Priority:-89 extents:1 across:32k
> [4323513.667773] Adding 32k swap on swapfile16.  Priority:-90 extents:3 across:56k
> [4323513.862025] Adding 32k swap on swapfile17.  Priority:-91 extents:1 across:32k
> [4323514.117461] Adding 32k swap on swapfile18.  Priority:-92 extents:1 across:32k
> [4323514.359461] Adding 32k swap on swapfile19.  Priority:-93 extents:1 across:32k
> [4323514.591493] Adding 32k swap on swapfile20.  Priority:-94 extents:1 across:32k
> [4323514.828623] Adding 32k swap on swapfile21.  Priority:-95 extents:1 across:32k
> [4323515.062932] Adding 32k swap on swapfile22.  Priority:-96 extents:2 across:1816k
> [4323515.207700] Adding 32k swap on swapfile23.  Priority:-97 extents:2 across:32k
> [4323515.471581] Adding 32k swap on swapfile24.  Priority:-98 extents:1 across:32k
> [4323515.703335] Adding 32k swap on swapfile25.  Priority:-99 extents:1 across:32k
> [4323515.969844] Adding 32k swap on swapfile26.  Priority:-100 extents:1 across:32k
> [4323516.237519] Adding 32k swap on swapfile27.  Priority:-101 extents:1 across:32k
> [4323516.448421] Adding 32k swap on swapfile28.  Priority:-102 extents:1 across:32k
> [4323516.662276] Adding 32k swap on swapfile29.  Priority:-103 extents:1 across:32k
> [4323517.011638] Adding 32k swap on swapfile30.  Priority:-104 extents:1 across:32k
> [4323517.691915] Adding 32k swap on firstswapfile.  Priority:-105 extents:2 across:36k
> [4323517.692095] Adding 32k swap on secondswapfile.  Priority:-106 extents:1 across:32k
> [4327950.912409] Adding 65528k swap on ./swapfile01.  Priority:-107 extents:25 across:84528k
> [4327957.079710] Adding 65528k swap on ./swapfile01.  Priority:-108 extents:31 across:157044k
> [4327963.890758] Adding 65528k swap on ./swapfile01.  Priority:-109 extents:34 across:108204k
> [4327964.096327] Unable to find swap-space signature
> [4327964.398296] Adding 32k swap on alreadyused.  Priority:-110 extents:2 across:36k
> [4327964.736523] Adding 32k swap on swapfile02.  Priority:-111 extents:1 across:32k
> [4327964.886182] Adding 32k swap on swapfile03.  Priority:-112 extents:2 across:136k
> [4327965.024481] Adding 32k swap on swapfile04.  Priority:-113 extents:2 across:1816k
> [4327965.176555] Adding 32k swap on swapfile05.  Priority:-114 extents:1 across:32k
> [4327965.288691] Adding 32k swap on swapfile06.  Priority:-115 extents:1 across:32k
> [4327965.422738] Adding 32k swap on swapfile07.  Priority:-116 extents:2 across:44k
> [4327965.558104] Adding 32k swap on swapfile08.  Priority:-117 extents:1 across:32k
> [4327965.722730] Adding 32k swap on swapfile09.  Priority:-118 extents:1 across:32k
> [4327965.908405] Adding 32k swap on swapfile10.  Priority:-119 extents:2 across:60k
> [4327966.064049] Adding 32k swap on swapfile11.  Priority:-120 extents:1 across:32k
> [4327966.182639] Adding 32k swap on swapfile12.  Priority:-121 extents:1 across:32k
> [4327966.308008] Adding 32k swap on swapfile13.  Priority:-122 extents:1 across:32k
> [4327966.441889] Adding 32k swap on swapfile14.  Priority:-123 extents:2 across:36k
> [4327966.545185] Adding 32k swap on swapfile15.  Priority:-124 extents:1 across:32k
> [4327966.731191] Adding 32k swap on swapfile16.  Priority:-125 extents:2 across:40k
> [4327966.908109] Adding 32k swap on swapfile17.  Priority:-126 extents:1 across:32k
> [4327967.067012] Adding 32k swap on swapfile18.  Priority:-127 extents:1 across:32k
> [4327967.270205] Adding 32k swap on swapfile19.  Priority:-128 extents:1 across:32k
> [4327967.448180] Adding 32k swap on swapfile20.  Priority:-129 extents:1 across:32k
> [4327967.640517] Adding 32k swap on swapfile21.  Priority:-130 extents:1 across:32k
> [4327967.780410] Adding 32k swap on swapfile22.  Priority:-131 extents:1 across:32k
> [4327967.923915] Adding 32k swap on swapfile23.  Priority:-132 extents:1 across:32k
> [4327968.076929] Adding 32k swap on swapfile24.  Priority:-133 extents:1 across:32k
> [4327968.224444] Adding 32k swap on swapfile25.  Priority:-134 extents:1 across:32k
> [4327968.386681] Adding 32k swap on swapfile26.  Priority:-135 extents:1 across:32k
> [4327968.635164] Adding 32k swap on swapfile27.  Priority:-136 extents:1 across:32k
> [4327968.820812] Adding 32k swap on swapfile28.  Priority:-137 extents:1 across:32k
> [4327969.067842] Adding 32k swap on swapfile29.  Priority:-138 extents:1 across:32k
> [4327969.207317] Adding 32k swap on swapfile30.  Priority:-139 extents:1 across:32k
> [4327969.683050] Adding 32k swap on firstswapfile.  Priority:-140 extents:1 across:32k
> [4327969.683433] Adding 32k swap on secondswapfile.  Priority:-141 extents:1 across:32k
> [4331997.664608] Adding 65528k swap on ./swapfile01.  Priority:-142 extents:32 across:89684k
> [4332003.732463] Adding 65528k swap on ./swapfile01.  Priority:-143 extents:29 across:149088k
> [4332010.354281] Adding 65528k swap on ./swapfile01.  Priority:-144 extents:21 across:140068k
> [4332010.563304] Unable to find swap-space signature
> [4332010.812699] Adding 32k swap on alreadyused.  Priority:-145 extents:1 across:32k
> [4332011.114655] Adding 32k swap on swapfile02.  Priority:-146 extents:1 across:32k
> [4332011.230734] Adding 32k swap on swapfile03.  Priority:-147 extents:2 across:1836k
> [4332011.405992] Adding 32k swap on swapfile04.  Priority:-148 extents:1 across:32k
> [4332011.629046] Adding 32k swap on swapfile05.  Priority:-149 extents:1 across:32k
> [4332011.824376] Adding 32k swap on swapfile06.  Priority:-150 extents:1 across:32k
> [4332011.956780] Adding 32k swap on swapfile07.  Priority:-151 extents:2 across:44k
> [4332012.084015] Adding 32k swap on swapfile08.  Priority:-152 extents:1 across:32k
> [4332012.382590] Adding 32k swap on swapfile09.  Priority:-153 extents:1 across:32k
> [4332012.600051] Adding 32k swap on swapfile10.  Priority:-154 extents:2 across:32k
> [4332012.739848] Adding 32k swap on swapfile11.  Priority:-155 extents:1 across:32k
> [4332012.951230] Adding 32k swap on swapfile12.  Priority:-156 extents:2 across:36k
> [4332013.027178] Adding 32k swap on swapfile13.  Priority:-157 extents:2 across:32k
> [4332013.157294] Adding 32k swap on swapfile14.  Priority:-158 extents:1 across:32k
> [4332013.324306] Adding 32k swap on swapfile15.  Priority:-159 extents:1 across:32k
> [4332013.478009] Adding 32k swap on swapfile16.  Priority:-160 extents:1 across:32k
> [4332013.691345] Adding 32k swap on swapfile17.  Priority:-161 extents:2 across:32k
> [4332013.758417] Adding 32k swap on swapfile18.  Priority:-162 extents:1 across:32k
> [4332013.856159] Adding 32k swap on swapfile19.  Priority:-163 extents:1 across:32k
> [4332013.988999] Adding 32k swap on swapfile20.  Priority:-164 extents:1 across:32k
> [4332014.108171] Adding 32k swap on swapfile21.  Priority:-165 extents:1 across:32k
> [4332014.191106] Adding 32k swap on swapfile22.  Priority:-166 extents:1 across:32k
> [4332014.304206] Adding 32k swap on swapfile23.  Priority:-167 extents:1 across:32k
> [4332014.502539] Adding 32k swap on swapfile24.  Priority:-168 extents:1 across:32k
> [4332014.684369] Adding 32k swap on swapfile25.  Priority:-169 extents:1 across:32k
> [4332014.853736] Adding 32k swap on swapfile26.  Priority:-170 extents:2 across:36k
> [4332014.973318] Adding 32k swap on swapfile27.  Priority:-171 extents:1 across:32k
> [4332015.091161] Adding 32k swap on swapfile28.  Priority:-172 extents:1 across:32k
> [4332015.201008] Adding 32k swap on swapfile29.  Priority:-173 extents:2 across:36k
> [4332015.324404] Adding 32k swap on swapfile30.  Priority:-174 extents:1 across:32k
> [4332015.752082] Adding 32k swap on firstswapfile.  Priority:-175 extents:1 across:32k
> [4332015.752424] Adding 32k swap on secondswapfile.  Priority:-176 extents:1 across:32k
> [4335684.679409] Adding 65528k swap on ./swapfile01.  Priority:-177 extents:31 across:91752k
> [4335691.057909] Adding 65528k swap on ./swapfile01.  Priority:-178 extents:22 across:114500k
> [4335696.822115] Adding 65528k swap on ./swapfile01.  Priority:-179 extents:24 across:148172k
> [4335696.993393] Unable to find swap-space signature
> [4335697.283173] Adding 32k swap on alreadyused.  Priority:-180 extents:1 across:32k
> [4335697.422398] Adding 32k swap on swapfile02.  Priority:-181 extents:1 across:32k
> [4335697.527172] Adding 32k swap on swapfile03.  Priority:-182 extents:1 across:32k
> [4335697.658520] Adding 32k swap on swapfile04.  Priority:-183 extents:1 across:32k
> [4335697.745190] Adding 32k swap on swapfile05.  Priority:-184 extents:2 across:32k
> [4335697.846964] Adding 32k swap on swapfile06.  Priority:-185 extents:1 across:32k
> [4335697.957268] Adding 32k swap on swapfile07.  Priority:-186 extents:1 across:32k
> [4335698.126923] Adding 32k swap on swapfile08.  Priority:-187 extents:1 across:32k
> [4335698.337237] Adding 32k swap on swapfile09.  Priority:-188 extents:1 across:32k
> [4335698.450537] Adding 32k swap on swapfile10.  Priority:-189 extents:1 across:32k
> [4335698.611428] Adding 32k swap on swapfile11.  Priority:-190 extents:1 across:32k
> [4335698.767599] Adding 32k swap on swapfile12.  Priority:-191 extents:1 across:32k
> [4335698.898005] Adding 32k swap on swapfile13.  Priority:-192 extents:1 across:32k
> [4335699.030925] Adding 32k swap on swapfile14.  Priority:-193 extents:2 across:44k
> [4335699.150021] Adding 32k swap on swapfile15.  Priority:-194 extents:1 across:32k
> [4335699.322725] Adding 32k swap on swapfile16.  Priority:-195 extents:1 across:32k
> [4335699.500086] Adding 32k swap on swapfile17.  Priority:-196 extents:1 across:32k
> [4335699.574431] Adding 32k swap on swapfile18.  Priority:-197 extents:1 across:32k
> [4335699.750988] Adding 32k swap on swapfile19.  Priority:-198 extents:1 across:32k
> [4335699.915901] Adding 32k swap on swapfile20.  Priority:-199 extents:1 across:32k
> [4335700.088262] Adding 32k swap on swapfile21.  Priority:-200 extents:1 across:32k
> [4335700.230728] Adding 32k swap on swapfile22.  Priority:-201 extents:1 across:32k
> [4335700.317745] Adding 32k swap on swapfile23.  Priority:-202 extents:1 across:32k
> [4335700.495246] Adding 32k swap on swapfile24.  Priority:-203 extents:1 across:32k
> [4335700.641937] Adding 32k swap on swapfile25.  Priority:-204 extents:1 across:32k
> [4335700.754225] Adding 32k swap on swapfile26.  Priority:-205 extents:1 across:32k
> [4335700.868226] Adding 32k swap on swapfile27.  Priority:-206 extents:1 across:32k
> [4335701.081225] Adding 32k swap on swapfile28.  Priority:-207 extents:1 across:32k
> [4335701.306849] Adding 32k swap on swapfile29.  Priority:-208 extents:1 across:32k
> [4335701.409447] Adding 32k swap on swapfile30.  Priority:-209 extents:1 across:32k
> [4335701.792262] Adding 32k swap on firstswapfile.  Priority:-210 extents:1 across:32k
> [4335701.792621] Adding 32k swap on secondswapfile.  Priority:-211 extents:1 across:32k
> [4337797.781556] eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
> 
