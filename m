Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab0BKVMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:12:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:52381 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034Ab0BKVMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:12:07 -0500
Message-ID: <4B747239.4070907@kernel.org>
Date: Thu, 11 Feb 2010 13:10:17 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH -v7 0/35] tip related: not use  bootmem for x86
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org> <20100211161414.GA16194@elte.hu>
In-Reply-To: <20100211161414.GA16194@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2010 08:14 AM, Ingo Molnar wrote:
> 
> i've done some testing of the bits Peter has merged into x86/bootmem in -tip, 
> and it crashes during early bootup with:
> 
> [    0.000000]   #8 [0000012000 - 000001a000]          BOOTMAP ==> [0000012000 - 000001a000]
> [    0.000000] bootmem alloc of 4194304 bytes failed!
> [    0.000000] Kernel panic - not syncing: Out of memory
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc7-tip-00770-g525df42-dirty #16566
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff8167410b>] panic+0x75/0x146
> [    0.000000]  [<ffffffff832b0a04>] ___alloc_bootmem_node+0x0/0x60
> [    0.000000]  [<ffffffff832b0c27>] __alloc_bootmem+0xb/0xd
> [    0.000000]  [<ffffffff832b2d7b>] sparse_init+0x34/0x2d9
> [    0.000000]  [<ffffffff832b0dc9>] ? reserve_bootmem+0x20/0x22
> [    0.000000]  [<ffffffff832aac44>] paging_init+0x43/0x52
> [    0.000000]  [<ffffffff8329fb2e>] setup_arch+0x583/0x615
> [    0.000000]  [<ffffffff8105e794>] ? clockevents_register_notifier+0x3e/0x4a
> [    0.000000]  [<ffffffff8329db07>] start_kernel+0xf3/0x349
> [    0.000000]  [<ffffffff8329d276>] x86_64_start_reservations+0x7d/0x81
> [    0.000000]  [<ffffffff8329d3c6>] x86_64_start_kernel+0x14c/0x15b
> [    0.000000] Rebooting in 1 seconds..Press any key to enter the menu

sorry, i deleted one line by mistake...

please check

Subject: [PATCH] x86: fix bootmem with non numa after early_res change

Ingo found early_res replacing bootmem code broke original bootmem code for non numa
it crashes during early bootup with:

[    0.000000]   #8 [0000012000 - 000001a000]          BOOTMAP ==> [0000012000 - 000001a000]
[    0.000000] bootmem alloc of 4194304 bytes failed!
[    0.000000] Kernel panic - not syncing: Out of memory
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc7-tip-00770-g525df42-dirty #16566
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8167410b>] panic+0x75/0x146
[    0.000000]  [<ffffffff832b0a04>] ___alloc_bootmem_node+0x0/0x60
[    0.000000]  [<ffffffff832b0c27>] __alloc_bootmem+0xb/0xd
[    0.000000]  [<ffffffff832b2d7b>] sparse_init+0x34/0x2d9
[    0.000000]  [<ffffffff832b0dc9>] ? reserve_bootmem+0x20/0x22
[    0.000000]  [<ffffffff832aac44>] paging_init+0x43/0x52
[    0.000000]  [<ffffffff8329fb2e>] setup_arch+0x583/0x615
[    0.000000]  [<ffffffff8105e794>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8329db07>] start_kernel+0xf3/0x349
[    0.000000]  [<ffffffff8329d276>] x86_64_start_reservations+0x7d/0x81
[    0.000000]  [<ffffffff8329d3c6>] x86_64_start_kernel+0x14c/0x15b
[    0.000000] Rebooting in 1 seconds..Press any key to enter the menu

it turns out that one line should not be deleted...

need to be folded into

| commit	29a79bb1f526e506b97c7e2e794be16f8af16a01
| x86: Make 64 bit use early_res instead of bootmem before slab

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 7ff9cee..276c4ea 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -584,6 +584,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 	/* don't touch min_low_pfn */
 	bootmap_size = init_bootmem_node(NODE_DATA(0), bootmap >> PAGE_SHIFT,
 					 0, end_pfn);
+	e820_register_active_regions(0, start_pfn, end_pfn);
 	free_bootmem_with_active_regions(0, end_pfn);
 #else
 	e820_register_active_regions(0, start_pfn, end_pfn);
