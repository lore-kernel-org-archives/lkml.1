Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424Ab0AVJhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0AVJhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 04:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135Ab0AVJZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 04:25:24 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53846 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab0AVJZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 04:25:20 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 22 Jan 2010 01:24:09 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v5 0/38] x86: not use  bootmem for x86
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1264152287-13866-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check the patches regarding with early_res and bootmem

it will use early_res instead of bootmem with x86 code.
but still can use CONFIG_NO_BOOMEM to use bootmem or not
so could make transistion more smoothly

-v2: allocate vmemmap on one node together, and also seperate early_res
-v3: make x86 32 bit support early_res to use bootmem too
     move related early_res to kernel/
     sparse vmemmap together: address Ingo.
-v4: some patches could go with tip with acked-by Jesse
     radix and logical flat etc
-v5: put back to 2 patches into this patch to make it consistent
     as linus pointed out that some place should replace size_t
     with resource_size_t, and acctually that is done already in
     those patches in pci/linux-next.

------------------------
http://lkml.indiana.edu/hypermail/linux/kernel/0910.3/01432.html
Ingo said:
" I think we could remove the bootmem allocator middle man altogether.

This can be done by initializing the page allocator sooner and by
extending (already existing) 'reserve memory early on' mechanisms in
architecture code. (the reserve_early*() APIs in x86 for example)

Right now we have 5 memory allocation models on x86, initialized
gradually:

- allocator (buddy) [generic]
- early allocator (bootmem) [generic]
- very early allocator (reserve_early*()) [x86]
- very very early allocator (early brk model) [x86]
- very very very early allocator (build time .data/.bss) [generic]

Seems excessive.

The reserve_early() method is list/range based and can handle vast
amounts of not very fragmented memory - perfect for basically all the
real bootmem purposes (which is to bootstrap the buddy).

reserve_early() allocated memory could be freed into the buddy later on
as well. The main reason why bootmem is 'destroyed' during free-to-buddy
is because it has excessive internal bitmaps we want to free. With a
list/range based reserve_early() mechanism there's no such problem -
they can linger indefinitely and there's near zero allocation management
overhead. "


--------x86 early_res related-------------
6177dab: x86: move range related operation to one file
286b89f: x86: check range in update range
533fe49: x86/pci: use resource_size_t in update_res
8cbccb6: x86/pci: amd one chain system to use pci read out res
468ee0f: x86/pci: use u64 instead of size_t in amd_bus.c
a172402: x86/pci: add cap_resource
b413799: x86/pci: enable pci root res read out for 32bit too
c468433: x86: call early_res_to_bootmem one time
12f337a: x86: introduce max_early_res and early_res_count
d5c865f: x86: dynamic increase early_res array size
5f01502: x86: print bootmem free before pci_iommu_alloc and free_all_bootmem -v2
40f0e84: x86: make early_node_mem get mem > 4g if possible
ce55404: x86: only call dma32_reserve_bootmem 64bit !CONFIG_NUMA
204800e: x86: make 64 bit use early_res instead of bootmem before slab
72baf8f: sparsemem: put usemap for one node together
b7c8e11: sparsemem: put mem map for one node together.
85b21ab: x86: change range end to start+size
a273204: x86: move bios page reserve early to head32/64.c
3bd2a608: x86: seperate early_res related code from e820.c
a585c37: x86: add find_early_area_size
e7ab98a: x86: move back find_e820_area to e820.c
c1c9ac5: early_res: enhance check_and_double_early_res
379a00d: x86: make 32bit support NO_BOOTMEM
08e88ed: move round_up/down to kernel.h
6aaa2f6: x86: add find_fw_memmap_area
6feb12b: core: move early_res
3ef2c47: x86: print out for RAM buffer
37d0914: x86: remove bios data range from e820
c2ca100: x86/pci: add mmconf range into e820 for when it is from MSR with amd faml0h

---------spareirq radix tree related ----------------
7b4e03a: irq: remove not need bootmem code
a52a59f: radix: move radix init early
dae4819: sparseirq: change irq_desc_ptrs to static
8dba1e8: sparseirq: use radix_tree instead of ptrs array
99e4f33: x86: remove arch_probe_nr_irqs

---------------x86 logical flat related -----------
8f5be57: use nr_cpus= to set nr_cpu_ids early
52db1e9: x86: according to nr_cpu_ids to decide if need to leave logical flat
289c6fc: x86: make 32bit apic flat to physflat switch like 64bit
4e5585b: x86: use num_processors for possible cpus

Thanks

Yinghai
