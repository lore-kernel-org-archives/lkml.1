Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0BJJVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:21:51 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60019 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab0BJJVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:21:47 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 10 Feb 2010 01:20:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v7 0/35] tip related: not use  bootmem for x86
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-------for 2.6.33? ---------------
7aabd8a: x86: fix sci on ioapic 1
24b26ba: x86: keep chip_data in create_irq_nr and destroy_irq

---------spareirq radix tree related ----------------
52060b4: irq: remove not need bootmem code
24a2254: radix: move radix init early
1b88442: sparseirq: change irq_desc_ptrs to static
592e479: sparseirq: use radix_tree instead of ptrs array
7b1947e: x86: remove arch_probe_nr_irqs

---------------x86 logical flat related -----------
afded12: use nr_cpus= to set nr_cpu_ids early
c0cae89: x86: use num_processors for possible cpus
ee9c461: x86: make 32bit apic flat to physflat switch like 64bit

-----------------early_res to replace bootmem---
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
-v7: address Andrew comments
     update change after logical flat change from Suresh.

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


d182b42: x86: move range related operation to one file
483ba54: x86/pci: use resource_size_t in update_res
390a654: x86/pci: amd one chain system to use pci read out res
d7092a9: x86/pci: use u64 instead of size_t in amd_bus.c
12d6055: x86/pci: add cap_resource
91963da: x86/pci: enable pci root res read out for 32bit too
f3399ba: x86: change range end to start+size
6a81be4: x86: print out for RAM buffer
878a861: x86: call early_res_to_bootmem one time
0c42e60: x86: introduce max_early_res and early_res_count
562294f: x86: dynamic increase early_res array size
7909d81: x86: make early_node_mem get mem > 4g if possible
3b64a9e: x86: only call dma32_reserve_bootmem 64bit !CONFIG_NUMA
28fd5da: x86: make 64 bit use early_res instead of bootmem before slab
8f08dc5: sparsemem: put usemap for one node together
fde44d7: sparsemem: put mem map for one node together.
096f978: x86: move bios page reserve early to head32/64.c
cfd3bbb: x86: seperate early_res related code from e820.c
ccc26e4: x86: add find_early_area_size
3a49dd4: x86: move back find_e820_area to e820.c
a3065c2: early_res: enhance check_and_double_early_res
8f8c07c: x86: make 32bit support NO_BOOTMEM
f8dc288: move round_up/down to kernel.h
de709d3: x86: add find_fw_memmap_area
41263b6: core: move early_res

Thanks

Yinghai
