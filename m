Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197Ab0AUG26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab0AUG26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 01:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877Ab0AUG25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 01:28:57 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36010 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab0AUG24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 01:28:56 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 20 Jan 2010 22:27:47 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v4 0/36] x86: not use  bootmem for x86
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1264055303-15123-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check the patches regarding with early_res and bootmem

and at last it will use early_res instead of bootmem with x86 64bits

-v2: allocate vmemmap on one node together, and also seperate early_res
-v3: make x86 32 bit support early_res to use bootmem too
     move related early_res to kernel/
     sparse vmemmap together: address Ingo.
-v4: some patches could go with tip with acked-by Jesse
     radix and logical flat etc

http://lkml.indiana.edu/hypermail/linux/kernel/0910.3/01432.html
Ingo said:
------------------------
I think we could remove the bootmem allocator middle man altogether.

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
overhead.

reserve_early() might need some small amount of extra work before it can
be used as a generic early allocator - like adding a node field to it
(so that the buddy can then pick those ranges up in a NUMA aware
fashion) - but nothing very complex.


--------x86 early_res related-------------
277f661: x86: move range related operation to one file
77f283c: x86: check range in update range
897f4ba: x86/pci: use u64 instead of size_t in amd_bus.c
84431bb: x86/pci: add cap_resource
48d49e8: x86/pci: enable pci root res read out for 32bit too
5255621: x86: call early_res_to_bootmem one time
0925f47: x86: introduce max_early_res and early_res_count
0c97b47: x86: dynamic increase early_res array size
f910ca6: x86: print bootmem free before pci_iommu_alloc and free_all_bootmem -v2
cfe85c0: x86: make early_node_mem get mem > 4g if possible
1d61d6c: x86: only call dma32_reserve_bootmem 64bit !CONFIG_NUMA
311f90d: x86: make 64 bit use early_res instead of bootmem before slab
788c828: sparsemem: put usemap for one node together
c1bb314: sparsemem: put mem map for one node together.
6e61ad7: x86: change range end to start+size
2a25d29: x86: move bios page reserve early to head32/64.c
36f0ad3: x86: seperate early_res related code from e820.c
ef1540b: x86: add find_early_area_size
fdd6fc1: x86: move back find_e820_area to e820.c
bedba96: early_res: enhance check_and_double_early_res
5c40d2d: x86: make 32bit support NO_BOOTMEM
c7987c9: move round_up/down to kernel.h
b047971: x86: add find_fw_memmap_area
a7ea42c: core: move early_res
5c972f9: x86: print out for RAM buffer
1267c07: x86: remove bios data range from e820
4826805: x86/pci: add mmconf range into e820 for when it is from MSR with amd faml0h

---------spareirq radix tree related ----------------
eba3887: irq: remove not need bootmem code
4c0d053: radix: move radix init early
5026493: sparseirq: change irq_desc_ptrs to static
e74a8ce: sparseirq: use radix_tree instead of ptrs array

---------------x86 logical flat related -----------
fa2bb9e: x86: remove arch_probe_nr_irqs
50f2e29: use nr_cpus= to set nr_cpu_ids early
2792a41: x86: according to nr_cpu_ids to decide if need to leave logical flat
c36a2f3: x86: make 32bit apic flat to physflat switch like 64bit
3f2e18b: x86: use num_processors for possible cpus

Thanks

Yinghai
