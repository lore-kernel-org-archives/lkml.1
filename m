Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbZHDPiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbZHDPiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbZHDPiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:38:00 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40305 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271AbZHDPh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:37:57 -0400
Date: Tue, 4 Aug 2009 08:37:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Add diagnostic check for a possible
	CPU-hotplug race
Message-ID: <20090804153755.GC6893@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-7256cf0e83bf018be8a81806593aaef7f2437f0b@git.kernel.org> <20090802202720.GA32360@elte.hu> <20090802221324.GP6854@linux.vnet.ibm.com> <20090803070458.GA27581@elte.hu> <20090804081850.GA21474@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804081850.GA21474@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 01:48:50PM +0530, Gautham R Shenoy wrote:
> On Mon, Aug 03, 2009 at 09:04:58AM +0200, Ingo Molnar wrote:
> > [    0.010000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> > [    0.010000] ... MAX_LOCKDEP_SUBCLASSES:  8
> > [    0.010000] ... MAX_LOCK_DEPTH:          48
> > [    0.010000] ... MAX_LOCKDEP_KEYS:        8191
> > [    0.010000] ... CLASSHASH_SIZE:          4096
> > [    0.010000] ... MAX_LOCKDEP_ENTRIES:     16384
> > [    0.010000] ... MAX_LOCKDEP_CHAINS:      32768
> > [    0.010000] ... CHAINHASH_SIZE:          16384
> > [    0.010000]  memory used by lock dependency info: 5823 kB
> > [    0.010000]  per task-struct memory footprint: 1920 bytes
> > [    0.010000] ------------------------
> > [    0.010000] | Locking API testsuite:
> > [    0.010000] ----------------------------------------------------------------------------
> > [    0.010000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> > [    0.010000]   --------------------------------------------------------------------------
> > [    0.010000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
> > [    0.010000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
> > [    0.010000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
> > [    0.010000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
> > [    0.010000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> > [    0.010000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> > [    0.010000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> > [    0.010000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> > [    0.010000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> > [    0.010000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> > [    0.010000]   --------------------------------------------------------------------------
> > [    0.010000]               recursive read-lock:             |  ok  |             |failed|
> > [    0.010000]            recursive read-lock #2:             |  ok  |             |failed|
> > [    0.010000]             mixed read-write-lock:             |failed|             |failed|
> > [    0.010000]             mixed write-read-lock:             |failed|             |failed|
> > [    0.010000]   --------------------------------------------------------------------------
> > [    0.010000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
> > [    0.010000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
> > [    0.010000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
> > [    0.010000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
> > [    0.010000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
> > [    0.010000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
> > [    0.010000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
> > [    0.010000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
> > [    0.010000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
> > [    0.010000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
> > [    0.010000]       hard-irq lock-inversion/123:failed|failed|  ok  |
> > [    0.010000]       soft-irq lock-inversion/123:failed|failed|  ok  |
> > [    0.010000]       hard-irq lock-inversion/132:failed|failed|  ok  |
> > [    0.010000]       soft-irq lock-inversion/132:failed|failed|  ok  |
> > [    0.010000]       hard-irq lock-inversion/213:failed|failed|  ok  |
> > [    0.010000]       soft-irq lock-inversion/213:failed|failed|  ok  |
> > [    0.010000]       hard-irq lock-inversion/231:failed|failed|  ok  |
> > [    0.010000]       soft-irq lock-inversion/231:failed|failed|  ok  |
> > [    0.010000]       hard-irq lock-inversion/312:failed|failed|  ok  |
> > [    0.010000]       soft-irq lock-inversion/312:failed|failed|  ok  |
> > [    0.010000]       hard-irq lock-inversion/321:failed|failed|  ok  |
> > [    0.010000]       soft-irq lock-inversion/321:failed|failed|  ok  |
> > [    0.010000]       hard-irq read-recursion/123:  ok  |
> > [    0.010000]       soft-irq read-recursion/123:  ok  |
> > [    0.010000]       hard-irq read-recursion/132:  ok  |
> > [    0.010000]       soft-irq read-recursion/132:  ok  |
> > [    0.010000]       hard-irq read-recursion/213:  ok  |
> > [    0.010000]       soft-irq read-recursion/213:  ok  |
> > [    0.010000]       hard-irq read-recursion/231:  ok  |
> > [    0.010000]       soft-irq read-recursion/231:  ok  |
> > [    0.010000]       hard-irq read-recursion/312:  ok  |
> > [    0.010000]       soft-irq read-recursion/312:  ok  |
> > [    0.010000]       hard-irq read-recursion/321:  ok  |
> > [    0.010000]       soft-irq read-recursion/321:  ok  |
> > [    0.010000] --------------------------------------------------------
> > [    0.010000] 133 out of 218 testcases failed, as expected. |
> > [    0.010000] ----------------------------------------------------
> 
> Hmm.. I tried to reproduce this on a similar 2 CPU machine running
> linux-2.6.31-rc5-tip. However, I couldn't reproduce this WARN_ON.
> 
> That aside, in my case, all the 218 lockdep test cases passed,
> while this bootlog shows quite a few failures.
> So, wondering if I am testing the right kernel version.
> 
> Appending the patch, bootup log and the config.

I like this patch, one small comment below.

							Thanx, Paul

> /*************** Patch ******************************/
> 
> rcu: Check if the cpu has been initialized before handling callbacks
> 
> From: Gautham R Shenoy <ego@in.ibm.com>
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> ---
>  kernel/rcutree.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 0e40e61..1809cc8 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1137,6 +1137,8 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
>  {
>  	unsigned long flags;
> 
> +	WARN_ON_ONCE(rdp->beenonline == 0);
> +
>  	/*
>  	 * If an RCU GP has gone long enough, go check for dyntick
>  	 * idle CPUs and, if needed, send resched IPIs.
> @@ -1351,6 +1353,8 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
>  	struct rcu_data *rdp = rsp->rda[cpu];
>  	struct rcu_node *rnp = rcu_get_root(rsp);
> 
> +	printk(KERN_INFO "Initializing RCU for cpu %d\n", cpu);

Suggest:

	printk(KERN_INFO "Initializing RCU for cpu %d, structure %p\n",
	       cpu, rsp);

Just to avoid people being confused by RCU initializing twice per CPU.
Or three times with the new preemptable RCU.  ;-)

> +
>  	/* Set up local state, ensuring consistent view of global state. */
>  	spin_lock_irqsave(&rnp->lock, flags);
>  	lastcomp = rsp->completed;
> 
> 
> /*************** Boot Log ******************************/
> root  (hd0,0)
>  Filesystem type is ext2fs, partition type 0x83
> kernel  /boot/vmlinuz-autobench console=tty0 console=ttyS0,9600 autobench_args:
>  root=/dev/sda2 ABAT:1249362544
>    [Linux-bzImage, setup=0x3000, size=0x334830]
> initrd /boot/initrd-autobench.img
>    [Linux-initrd @ 0x37de8000, 0x2077cb bytes]
> boot
> Linux version 2.6.31-rc5-autokern1-tip (root@elm3b165) (gcc version 4.0.3 (Ubuntu 4.0.3-1ubuntu5)) #1 SMP Tue Aug 4 05:08:45 UTC 2009
> Command line: console=tty0 console=ttyS0,9600 autobench_args: root=/dev/sda2 ABAT:1249362544
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   Centaur CentaurHauls
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009ac00 (usable)
>  BIOS-e820: 000000000009ac00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000d4000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000dff70000 (usable)
>  BIOS-e820: 00000000dff70000 - 00000000dff7b000 (ACPI data)
>  BIOS-e820: 00000000dff7b000 - 00000000dff80000 (ACPI NVS)
>  BIOS-e820: 00000000dff80000 - 00000000e0000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 0000000400000000 (usable)
> DMI 2.3 present.
> last_pfn = 0x400000 max_arch_pfn = 0x400000000
> last_pfn = 0xdff70 max_arch_pfn = 0x400000000
> init_memory_mapping: 0000000000000000-00000000dff70000
> init_memory_mapping: 0000000100000000-0000000400000000
> RAMDISK: 37de8000 - 37fef7cb
> ACPI: RSDP 00000000000f7560 00024 (v02 PTLTD )
> ACPI: XSDT 00000000dff78a5b 0004C (v01 PTLTD     XSDT   06040000  LTP 00000000)
> ACPI: FACP 00000000dff7ac02 000F4 (v03 AMD    HAMMER   06040000 PTEC 000F4240)
> ACPI: DSDT 00000000dff78aa7 020E7 (v01 AMD-K8  AMDACPI 06040000 MSFT 0100000E)
> ACPI: FACS 00000000dff7bfc0 00040
> ACPI: SSDT 00000000dff7acf6 0020C (v01 PTLTD  POWERNOW 06040000  LTP 00000001)
> ACPI: HPET 00000000dff7af02 00038 (v01 AMD    HAMMER   06040000 PTEC 00000000)
> ACPI: APIC 00000000dff7af3a 00076 (v01 PTLTD     APIC   06040000  LTP 00000000)
> ACPI: SPCR 00000000dff7afb0 00050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
> Scanning NUMA topology in Northbridge 24
> Number of nodes 2
> Node 0 MemBase 0000000000000000 Limit 0000000200000000
> Node 1 MemBase 0000000200000000 Limit 0000000400000000
> Using node hash shift of 33
> found SMP MP-table at [ffff8800000f75e0] f75e0
> Bootmem setup node 0 0000000000000000-0000000200000000
>   NODE_DATA [0000000000001000 - 0000000000005fff]
>   bootmap [0000000000018000 -  0000000000057fff] pages 40
> (8 early reservations) ==> bootmem [0000000000 - 0200000000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
>   #2 [0001000000 - 00022fbea8]    TEXT DATA BSS ==> [0001000000 - 00022fbea8]
>   #3 [0037de8000 - 0037fef7cb]          RAMDISK ==> [0037de8000 - 0037fef7cb]
>   #4 [000009ac00 - 0000100000]    BIOS reserved ==> [000009ac00 - 0000100000]
>   #5 [00022fc000 - 00022fc108]              BRK ==> [00022fc000 - 00022fc108]
>   #6 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
>   #7 [000000c000 - 0000018000]          PGTABLE ==> [000000c000 - 0000018000]
> Bootmem setup node 1 0000000200000000-0000000400000000
>   NODE_DATA [0000000200000000 - 0000000200004fff]
>   bootmap [0000000200005000 -  0000000200044fff] pages 40
> (8 early reservations) ==> bootmem [0200000000 - 0400000000]
>   #0 [0000000000 - 0000001000]   BIOS data page
>   #1 [0000006000 - 0000008000]       TRAMPOLINE
>   #2 [0001000000 - 00022fbea8]    TEXT DATA BSS
>   #3 [0037de8000 - 0037fef7cb]          RAMDISK
>   #4 [000009ac00 - 0000100000]    BIOS reserved
>   #5 [00022fc000 - 00022fc108]              BRK
>   #6 [0000008000 - 000000c000]          PGTABLE
>   #7 [000000c000 - 0000018000]          PGTABLE
> found SMP MP-table at [ffff8800000f75e0] f75e0
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00001000
>   DMA32    0x00001000 -> 0x00100000
>   Normal   0x00100000 -> 0x00400000
> Movable zone start PFN for each node
> early_node_map[4] active PFN ranges
>     0: 0x00000000 -> 0x0000009a
>     0: 0x00000100 -> 0x000dff70
>     0: 0x00100000 -> 0x00200000
>     1: 0x00200000 -> 0x00400000
> Detected use of extended apic ids on hypertransport bus
> Detected use of extended apic ids on hypertransport bus
> ACPI: PM-Timer IO Port: 0x8008
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
> ACPI: IOAPIC (id[0x03] address[0xe8000000] gsi_base[24])
> IOAPIC[1]: apic_id 3, version 17, address 0xe8000000, GSI 24-27
> ACPI: IOAPIC (id[0x04] address[0xe8001000] gsi_base[28])
> IOAPIC[2]: apic_id 4, version 17, address 0xe8001000, GSI 28-31
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
> Using ACPI (MADT) for SMP configuration information
> ACPI: HPET id: 0x102282a0 base: 0xfed00000
> SMP: Allowing 2 CPUs, 0 hotplug CPUs
> Allocating PCI resources starting at e0000000 (gap: e0000000:1ec00000)
> NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:2
> PERCPU: Remapped at ffffc90000000000 with large pages, static data 1914656 bytes
> Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 3956370
> Policy zone: Normal
> Kernel command line: console=tty0 console=ttyS0,9600 autobench_args: root=/dev/sda2 ABAT:1249362544
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> Initializing CPU#0
> Checking aperture...
> No AGP bridge found
> Node 0: aperture @ 0 size 32 MB
> Your BIOS doesn't leave a aperture memory hole
> Please enable the IOMMU option in the BIOS setup
> This costs you 64 MB of RAM
> Mapping aperture over 65536 KB of RAM @ 20000000
> Memory: 15746208k/16777216k available (4270k kernel code, 525272k absent, 505736k reserved, 3005k data, 2396k init)
> Hierarchical RCU implementation.
> RCU-based detection of stalled CPUs is enabled.
> Initializing RCU for cpu 0
> Initializing RCU for cpu 0
> NR_IRQS:1280
> Extended CMOS year: 2000
> Fast TSC calibration using PIT
> Detected 2392.251 MHz processor.
> Console: colour VGA+ 80x25
> console [tty0] enabled
> console [ttyS0] enabled
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> ... MAX_LOCKDEP_SUBCLASSES:  8
> ... MAX_LOCK_DEPTH:          48
> ... MAX_LOCKDEP_KEYS:        8191
> ... CLASSHASH_SIZE:          4096
> ... MAX_LOCKDEP_ENTRIES:     16384
> ... MAX_LOCKDEP_CHAINS:      32768
> ... CHAINHASH_SIZE:          16384
>  memory used by lock dependency info: 6367 kB
>  per task-struct memory footprint: 2688 bytes
> ------------------------
> | Locking API testsuite:
> ----------------------------------------------------------------------------
>                                  | spin |wlock |rlock |mutex | wsem | rsem |
>   --------------------------------------------------------------------------
>                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>   --------------------------------------------------------------------------
>               recursive read-lock:             |  ok  |             |  ok  |
>            recursive read-lock #2:             |  ok  |             |  ok  |
>             mixed read-write-lock:             |  ok  |             |  ok  |
>             mixed write-read-lock:             |  ok  |             |  ok  |
>   --------------------------------------------------------------------------
>      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
>      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
>      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
>      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
>        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
>        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
>          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
>          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
>          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
>          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
>       hard-irq read-recursion/123:  ok  |
>       soft-irq read-recursion/123:  ok  |
>       hard-irq read-recursion/132:  ok  |
>       soft-irq read-recursion/132:  ok  |
>       hard-irq read-recursion/213:  ok  |
>       soft-irq read-recursion/213:  ok  |
>       hard-irq read-recursion/231:  ok  |
>       soft-irq read-recursion/231:  ok  |
>       hard-irq read-recursion/312:  ok  |
>       soft-irq read-recursion/312:  ok  |
>       hard-irq read-recursion/321:  ok  |
>       soft-irq read-recursion/321:  ok  |
> -------------------------------------------------------
> Good, all 218 testcases passed! |
> ---------------------------------
> HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> Calibrating delay loop (skipped), value calculated using timer frequency.. 4784.50 BogoMIPS (lpj=9569004)
> Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
> Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> Mount-cache hash table entries: 256
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 0/0x0 -> Node 0
> mce: CPU supports 5 MCE banks
> Performance Counters: AMD PMU driver.
> ... version:                 0
> ... bit width:               48
> ... generic counters:        4
> ... value mask:              0000ffffffffffff
> ... max period:              00007fffffffffff
> ... fixed-purpose counters:  0
> ... counter mask:            000000000000000f
> ACPI: Core revision 20090521
> Setting APIC routing to flat
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
> CPU0: AMD Opteron(tm) Processor 250 stepping 0a
> Initializing RCU for cpu 1
> Initializing RCU for cpu 1
> lockdep: fixing up alternatives.
> Booting processor 1 APIC 0x1 ip 0x6000
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 4785.02 BogoMIPS (lpj=9570044)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 1/0x1 -> Node 1
> mce: CPU supports 5 MCE banks
> CPU1: AMD Opteron(tm) Processor 250 stepping 0a
> Brought up 2 CPUs
> Total of 2 processors activated (9569.52 BogoMIPS).
> NET: Registered protocol family 16
> TOM: 00000000e0000000 aka 3584M
> TOM2: 0000000400000000 aka 16384M
> ACPI: bus type pci registered
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
> ACPI: Interpreter enabled
> ACPI: (supports S0 S1 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: No dock devices found.
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> pci 0000:02:01.0: PME# supported from D3hot D3cold
> pci 0000:02:01.0: PME# disabled
> pci 0000:02:01.1: PME# supported from D3hot D3cold
> pci 0000:02:01.1: PME# disabled
> pci 0000:03:03.0: PME# supported from D0 D3hot D3cold
> pci 0000:03:03.0: PME# disabled
> ACPI: PCI Interrupt Link [LNKA] (IRQs 3 5 10 11) *7
> ACPI: PCI Interrupt Link [LNKB] (IRQs 3 5 *10 11)
> ACPI: PCI Interrupt Link [LNKC] (IRQs *3 5 10 11)
> ACPI: PCI Interrupt Link [LNKD] (IRQs 3 5 10 *11)
> SCSI subsystem initialized
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> PCI-DMA: Disabling AGP.
> PCI-DMA: aperture base @ 20000000 size 65536 KB
> PCI-DMA: using GART IOMMU.
> PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> hpet0: 3 comparators, 32-bit 14.318180 MHz counter
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp 00:00: mem resource (0x0-0x9ffff) overlaps 0000:02:02.0 BAR 6 (0x0-0xfffff), disabling
> pnp 00:00: mem resource (0xe0000-0xfffff) overlaps 0000:02:02.0 BAR 6 (0x0-0xfffff), disabling
> pnp 00:06: mem resource (0xc0000-0xc7fff) overlaps 0000:02:02.0 BAR 6 (0x0-0xfffff), disabling
> pnp: PnP ACPI: found 8 devices
> ACPI: ACPI bus type pnp unregistered
> system 00:00: iomem range 0x100000-0xdfffffff could not be reserved
> system 00:00: iomem range 0xfec00000-0xfec00fff could not be reserved
> system 00:00: iomem range 0xffc00000-0xfff7ffff has been reserved
> system 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
> system 00:00: iomem range 0xfff80000-0xffffffff has been reserved
> system 00:06: ioport range 0x4d0-0x4d1 has been reserved
> system 00:06: ioport range 0x1100-0x117f has been reserved
> system 00:06: ioport range 0x1180-0x11ff has been reserved
> system 00:06: ioport range 0x300-0x307 has been reserved
> system 00:06: ioport range 0x421-0x42f has been reserved
> system 00:06: ioport range 0xca2-0xca3 has been reserved
> pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
> pci 0000:00:06.0:   IO window: 0x2000-0x2fff
> pci 0000:00:06.0:   MEM window: 0xe8100000-0xe81fffff
> pci 0000:00:06.0:   PREFETCH window: 0xe0000000-0xe00fffff
> pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
> pci 0000:00:0a.0:   IO window: 0x3000-0x3fff
> pci 0000:00:0a.0:   MEM window: 0xe8200000-0xe82fffff
> pci 0000:00:0a.0:   PREFETCH window: 0xe0100000-0xe01fffff
> pci 0000:00:0b.0: PCI bridge, secondary bus 0000:03
> pci 0000:00:0b.0:   IO window: 0x4000-0x4fff
> pci 0000:00:0b.0:   MEM window: 0xe8300000-0xe83fffff
> pci 0000:00:0b.0:   PREFETCH window: 0x000000f0000000-0x000000f7ffffff
> NET: Registered protocol family 2
> IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
> TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
> TCP: Hash tables configured (established 524288 bind 65536)
> TCP reno registered
> NET: Registered protocol family 1
> Trying to unpack rootfs image as initramfs...
> Freeing initrd memory: 2077k freed
> HugeTLB registered 2 MB page size, pre-allocated 0 pages
> Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> msgmni has been set to 30758
> io scheduler noop registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> boot interrupts on PCI device 0x1022:0x746b already disabled
> pci 0000:00:0a.0: MSI quirk detected; subordinate MSI disabled
> disabled boot interrupts on PCI device 0x1022:0x7450
> pci 0000:00:0a.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
> pci 0000:00:0b.0: MSI quirk detected; subordinate MSI disabled
> disabled boot interrupts on PCI device 0x1022:0x7450
> pci 0000:00:0b.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> ACPI: Power Button [PWRF]
> input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> ACPI: Power Button [PWRB]
> processor LNXCPU:00: registered as cooling_device0
> processor LNXCPU:01: registered as cooling_device1
> Real Time Clock Driver v1.12b
> AMD768 RNG detected
> Linux agpgart interface v0.103
> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Platform driver 'serial8250' needs updating - please use dev_pm_ops
> 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Platform driver 'floppy' needs updating - please use dev_pm_ops
> floppy0: no floppy controllers found
> brd: module loaded
> loop: module loaded
> Uniform Multi-Platform E-IDE driver
> amd74xx 0000:00:07.1: UDMA133 controller
> amd74xx 0000:00:07.1: IDE controller (0x1022:0x7469 rev 0x03)
> amd74xx 0000:00:07.1: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0x1020-0x1027
>     ide1: BM-DMA at 0x1028-0x102f
> hdc: LG CD-ROM CRN-8245B, ATAPI CD/DVD-ROM drive
> hdc: UDMA/33 mode selected
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> ide1 at 0x170-0x177,0x376 on irq 15
> ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> ide-gd driver 1.18
> ide-cd driver 5.00
> ide-cd: hdc: ATAPI 24X CD-ROM drive, 128kB Cache
> Uniform CD-ROM driver Revision: 3.20
> sata_sil 0000:01:06.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> scsi0 : sata_sil
> scsi1 : sata_sil
> ata1: SATA max UDMA/100 mmio m512@0xe8102000 tf 0xe8102080 irq 17
> ata2: SATA max UDMA/100 mmio m512@0xe8102000 tf 0xe81020c0 irq 17
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> ata1.00: ATA-6: ST380013AS, 3.25, max UDMA/133
> ata1.00: 156312576 sectors, multi 16: LBA48 
> ata1.00: configured for UDMA/100
> scsi 0:0:0:0: Direct-Access     ATA      ST380013AS       3.25 PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 156312576 512-byte logical blocks: (80.0 GB/74.5 GiB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
> sd 0:0:0:0: [sda] Attached SCSI disk
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> ata2: SATA link down (SStatus 0 SControl 310)
> Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
> Copyright (c) 1999-2006 Intel Corporation.
> e1000 0000:03:03.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
> e1000: 0000:03:03.0: e1000_probe: (PCI:66MHz:64-bit) 00:02:b3:9b:20:ef
> e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
> e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
> e100: Copyright(c) 1999-2006 Intel Corporation
> tg3.c:v3.99 (April 20, 2009)
> tg3 0000:02:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
> tg3 0000:02:01.0: PME# disabled
> eth1: Tigon3 [partno(BCM95704A6) rev 2003] (PCIX:100MHz:64-bit) MAC address 00:0d:60:14:bf:64
> eth1: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1])
> eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[0]
> eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
> tg3 0000:02:01.1: PCI INT B -> GSI 25 (level, low) -> IRQ 25
> tg3 0000:02:01.1: PME# disabled
> eth2: Tigon3 [partno(BCM95704A6) rev 2003] (PCIX:100MHz:64-bit) MAC address 00:0d:60:14:bf:65
> eth2: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1])
> eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
> eth2: dma_rwctrl[769f4000] dma_mask[64-bit]
> tun: Universal TUN/TAP device driver, 1.6
> tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> console [netcon0] enabled
> netconsole: network logging started
> Fusion MPT base driver 3.04.10
> Copyright (c) 1999-2008 LSI Corporation
> Fusion MPT SPI Host driver 3.04.10
> mptspi 0000:02:02.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
> mptbase: ioc0: Initiating bringup
> ioc0: LSI53C1030 B2: Capabilities={Initiator}
> scsi2 : ioc0: LSI53C1030 B2, FwRev=01032316h, Ports=1, MaxQ=222, IRQ=26
> Fusion MPT SAS Host driver 3.04.10
> ieee1394: raw1394: /dev/raw1394 device initialized
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> ohci_hcd 0000:01:00.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> ohci_hcd 0000:01:00.0: OHCI Host Controller
> ohci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 1
> ohci_hcd 0000:01:00.0: irq 19, io mem 0xe8100000
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 3 ports detected
> ohci_hcd 0000:01:00.1: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> ohci_hcd 0000:01:00.1: OHCI Host Controller
> ohci_hcd 0000:01:00.1: new USB bus registered, assigned bus number 2
> ohci_hcd 0000:01:00.1: irq 19, io mem 0xe8101000
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 3 ports detected
> uhci_hcd: USB Universal Host Controller Interface driver
> usbcore: registered new interface driver usblp
> Initializing USB Mass Storage driver...
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> PNP: No PS/2 controller found. Probing ports directly.
> Platform driver 'i8042' needs updating - please use dev_pm_ops
> usb 1-1: new full speed USB device using ohci_hcd and address 2
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
> cpuidle: using governor ladder
> usbcore: registered new interface driver usbhid
> usbhid: v2.6:USB HID core driver
> oprofile: using NMI interrupt.
> TCP cubic registered
> NET: Registered protocol family 10
> IPv6 over IPv4 tunneling driver
> NET: Registered protocol family 17
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> powernow-k8: Found 2 AMD Opteron(tm) Processor 250 processors (2 cpu cores) (version 2.20.00)
> powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0x2
> powernow-k8:    1 : fid 0xe (2200 MHz), vid 0x6
> powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xa
> powernow-k8:    3 : fid 0xa (1800 MHz), vid 0xc
> usb 1-1: configuration #1 chosen from 1 choice
> input: IBM PPC I/F as /devices/pci0000:00/0000:00:06.0/0000:01:00.0/usb1/1-1/1-1:1.0/input/input2
> generic-usb 0003:04B3:4001.0001: input: USB HID v1.10 Keyboard [IBM PPC I/F] on usb-0000:01:00.0-1/input0
> input: IBM PPC I/F as /devices/pci0000:00/0000:00:06.0/0000:01:00.0/usb1/1-1/1-1:1.1/input/input3
> generic-usb 0003:04B3:4001.0002: input: USB HID v1.10 Mouse [IBM PPC I/F] on usb-0000:01:00.0-1/input1
> powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0xe
> powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0x2
> powernow-k8:    1 : fid 0xe (2200 MHz), vid 0x6
> powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xa
> powernow-k8:    3 : fid 0xa (1800 MHz), vid 0xc
> powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0xe
> Freeing unused kernel memory: 2396k freed
> Begin: Loading essential drivers... ...
> Done.
> Begin: Running /scripts/init-premount ...
> ata_id[1419]: main: unable to open '/dev/.tmp-0-0'
> ata_id[1461]: main: unable to open '/dev/.tmp-0-0'
> Done.
> Begin: Mounting root file system... ...
> Begin: Running /scripts/local-top ...
> Done.
> Begin: Waiting for root file system... ...
> 
> 
> -- 
> Thanks and Regards
> gautham


