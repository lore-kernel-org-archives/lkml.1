Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0BIThO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:37:14 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54586 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab0BITdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:33:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 09 Feb 2010 11:32:11 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v6 0/35] x86: not use  bootmem for x86
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
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
-v6: updated about intel_bus.c removal

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





a06bb22: x86: fix sci on ioapic 1

-----------------early_res to replace bootmem---
aa0a11b: x86: move range related operation to one file
c4b3117: x86/pci: use resource_size_t in update_res
e058bd0: x86/pci: amd one chain system to use pci read out res
d26795f: x86/pci: use u64 instead of size_t in amd_bus.c
5f8e15f: x86/pci: add cap_resource
3d35ae5: x86/pci: enable pci root res read out for 32bit too
81d88a0: x86: change range end to start+size
6579bec: x86: print out for RAM buffer
728cbde: x86: call early_res_to_bootmem one time
628a00a: x86: introduce max_early_res and early_res_count
d3b8276: x86: dynamic increase early_res array size
5bd2f97: x86: make early_node_mem get mem > 4g if possible
67cb2e2: x86: only call dma32_reserve_bootmem 64bit !CONFIG_NUMA
b103b00: x86: make 64 bit use early_res instead of bootmem before slab
ce3fcbd: sparsemem: put usemap for one node together
8b114f3: sparsemem: put mem map for one node together.
34ab079: x86: move bios page reserve early to head32/64.c
7488456: x86: seperate early_res related code from e820.c
bdd2487: x86: add find_early_area_size
678f2b2: x86: move back find_e820_area to e820.c
a1139c4: early_res: enhance check_and_double_early_res
139a7ce: x86: make 32bit support NO_BOOTMEM
2307d29: move round_up/down to kernel.h
4f26f0a: x86: add find_fw_memmap_area
efcffa6: core: move early_res

---------spareirq radix tree related ----------------
8311fab: irq: remove not need bootmem code
2216c85: radix: move radix init early
17abde7: sparseirq: change irq_desc_ptrs to static
3a86f81: sparseirq: use radix_tree instead of ptrs array
30afe2e: x86: remove arch_probe_nr_irqs

---------------x86 logical flat related -----------
b0be8be: use nr_cpus= to set nr_cpu_ids early
9676ccf: x86: according to nr_cpu_ids to decide if need to leave logical flat
f4f0989: x86: make 32bit apic flat to physflat switch like 64bit
0fa2815: x86: use num_processors for possible cpus




Yinghai
