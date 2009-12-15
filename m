Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbZLOHrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbZLOHrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZLOHrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:47:12 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:24392 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZLOHrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:47:11 -0500
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADvOJkurR7Hu/2dsb2JhbADAdZcOhCsEgWI
X-IronPort-AV: E=Sophos;i="4.47,399,1257120000"; 
   d="scan'208";a="205607691"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: bisected crash due to "x86: Move swiotlb initialization before dma32_free_bootmem"
X-Message-Flag: Warning: May contain useful information
Date: Mon, 14 Dec 2009 23:47:07 -0800
Message-ID: <ada8wd4brwk.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Dec 2009 07:47:07.0490 (UTC) FILETIME=[CD17D420:01CA7D5A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomonori-san:

I have a big box (64 threads, 256GB memory) that is crashing early in
boot as below.  I bisected it down to f4780ca0 ("x86: Move swiotlb
initialization before dma32_free_bootmem"); reverting just this commit
from the latest git (3ea6b3d0 is what I tested) fixes things.

I haven't tried to debug this yet, but I guess on such a huge box there
is not enough memory below 4GB for swiotlb if we don't free the DMA32
stuff allocated earlier?  I don't know why that would be, since the
bootmem is grabbing 512MB and I have pretty close to 4GB below 4GB.
Anyway, I'm going to go to bed soon, but if you need more information or
have anything you want me to try, I will do it tomorrow morning.

Thanks,
 Roland


Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x04080000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000001 -> 0x0000009b
    0: 0x00000100 -> 0x00078c74
    0: 0x00100000 -> 0x04080000

... snip ... 

PERCPU: Embedded 29 pages/cpu @ffff880172400000 s90008 r8192 d20584 u131072
pcpu-alloc: s90008 r8192 d20584 u131072 alloc=1*2097152
pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15
pcpu-alloc: [0] 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
pcpu-alloc: [0] 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
pcpu-alloc: [0] 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 66154133
Policy zone: Normal
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.30-2-amd64 root=UUID=c32babd2-b320-48e5-bdd4-350d659b07a5 ro console=ttyS0,115200n8 earlyprintk=ttyS0,115200
PID hash table entries: 4096 (order: 3, 32768 bytes)
bootmem alloc of 67108864 bytes failed!
Kernel panic - not syncing: Out of memory
Pid: 0, comm: swapper Not tainted 2.6.32 #19
Call Trace:
 [<ffffffff81342c82>] ? panic+0x86/0x141
 [<ffffffff816f0e00>] ? ___alloc_bootmem_nopanic+0x89/0xc7
 [<ffffffff813477b6>] ? _etext+0x0/0x38d84a
 [<ffffffff816f0e6d>] ? ___alloc_bootmem_node+0x0/0x59
 [<ffffffff816f98a7>] ? swiotlb_init_with_default_size+0x3f/0x126
 [<ffffffff816e6669>] ? pci_swiotlb_init+0x50/0x63
 [<ffffffff816d5140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816dbd2a>] ? pci_iommu_alloc+0xb/0x73
 [<ffffffff816d5140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816e9e70>] ? mem_init+0x15/0xe5
 [<ffffffff816d5ad2>] ? start_kernel+0x1bd/0x39e
 [<ffffffff816d53b2>] ? x86_64_start_kernel+0xf9/0x106
