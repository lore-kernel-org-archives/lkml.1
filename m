Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab0APDIX (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 22:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828Ab0APDIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 22:08:20 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33847 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758752Ab0APDIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 22:08:18 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 15 Jan 2010 19:06:31 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v4 0/37] x86: not use  bootmem for x86
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
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


early_res related:
6f632c9: x86: move range related operation to one file
b62d592: x86: check range in update range
2a49dba: x86/pci: use u64 instead of size_t in amd_bus.c
b9406c1: x86/pci: add cap_resource
84dd3b2: x86/pci: enable pci root res read out for 32bit too
e9a7f12: x86: call early_res_to_bootmem one time
c3685a1: x86: introduce max_early_res and early_res_count
4b951ed: x86: dynamic increase early_res array size
5a84eb6: x86: print bootmem free before pci_iommu_alloc and free_all_bootmem -v2
f00c3bb: x86: make early_node_mem get mem > 4g if possible
e3e7efe: x86: only call dma32_reserve_bootmem 64bit !CONFIG_NUMA
9bee1a1: x86: make 64 bit use early_res instead of bootmem before slab
453b0be: sparsemem: put usemap for one node together
5f01a21: sparsemem: put mem map for one node together.
ef6e006: x86: change range end to start+size
480085b: x86: move bios page reserve early to head32/64.c
95630e9: x86: seperate early_res related code from e820.c
a91ebdc: x86: add find_early_area_size
8e98a3a: x86: move back find_e820_area to e820.c
98f958f: early_res: enhance check_and_double_early_res
0e5b16a: x86: make 32bit support NO_BOOTMEM
59cca3b: move round_up/down to kernel.h
27911e4: x86: add find_fw_memmap_area
7809f98: core: move early_res
46afde8: ram_buffer_extend_print
1f32abd: x86: remove bios data range from e820
d1bbc62: irq: remove not need bootmem code

------------------------------------
radix_tree for spare irq:
3ac5b09: radix: move radix init early
3b862ce: sparseirq: change irq_desc_ptrs to static
9d32b70: sparseirq: use radix_tree instead of ptrs array
ff0c3de: x86: remove arch_probe_nr_irqs

--------------------------------------
logical flat cleanup:
1a8b97c: x86, apic: Use logical flat on intel with <= 8 logical cpus
eaf5895: use nr_cpus= to set nr_cpu_ids early
6efca5a: x86: using logical flat for amd cpu too.
4607ec4: x86: according to nr_cpu_ids to decide if need to leave logical flat
d2e2375: x86: make 32bit apic flat to physflat switch like 64bit
99ec7c7: x86: use num_processors for possible cpus

Thanks

Yinghai
