Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbZAaM7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbZAaM7E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 07:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZAaM6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 07:58:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44961 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbZAaM6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 07:58:54 -0500
Subject: Re: Out of memory error
From: Peter Zijlstra <peterz@infradead.org>
To: Cliffe <cliffe@ii.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <49844F4D.3010006@ii.net>
References: <m2eiz06iav.fsf@ssh.synack.fr>
	 <200901291025.36076.paul.moore@hp.com>
	 <1233267347.13812.22.camel@sp-laptop3.sp-local>
	 <200901291738.36148.paul.moore@hp.com>
	 <1233275267.13812.31.camel@sp-laptop3.sp-local>
	 <m2ocxpzhs2.fsf@ssh.synack.fr>  <49844F4D.3010006@ii.net>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 13:58:50 +0100
Message-Id: <1233406730.4787.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 21:17 +0800, Cliffe wrote:
> Hello,
> 
> I get the following error messages from code I am working on. It works 
> fine in userspace.

its very very unlikely you'll ever experience malloc() failing in
userspace.

> I suspect it may be due to the kernel's limited stack size as it uses a 
> recursive algorithm. If this is the cause, how can I provide the (lsm) 
> module with more memory?

You cannot, you'll have to rewrite your code to be iterative and use an
allocated traversal stack.

>  This is for a research project so it is ok if 
> the solution is not quite kosher.

And here you shatter my illusion that science is careful work ;-)

> Thank you, any help will be appreciated. Please CC me in on any replies.

Its simply a case of you using kmalloc(GFP_ATOMIC) and that's failing.
Furthermore, it appears to me you're not using frame pointers for your
kernel builds, please ammend that, it gives far more readable output.

> The following is only an harmless informational message.
> Unless you get a _continuous_flood_ of these messages it means
> everything is working fine. Allocations from irqs cannot be
> perfectly reliable and the kernel is designed to handle that.
> bash: page allocation failure. order:0, mode:0x20
>  [<c015846a>] __alloc_pages+0x2c5/0x2d6
>  [<c016de72>] cache_alloc_refill+0x2ae/0x4c1
>  [<c0129640>] irq_exit+0x53/0x6b
>  [<c016e0fc>] __kmalloc+0x77/0x8f
>  [<e1060c01>] mem_alloc+0x19/0x5f [fbac_lsm]
>  [<e1069b14>] copy_to_new_to_send_recursive+0x22/0x91 [fbac_lsm]
>  [<e1069cf3>] copy_to_new_func_recursive+0xde/0x11d [fbac_lsm]
>  [<e1069ce3>] copy_to_new_func_recursive+0xce/0x11d [fbac_lsm]
>  [<e1069ce3>] copy_to_new_func_recursive+0xce/0x11d [fbac_lsm]
>  [<e1069ce3>] copy_to_new_func_recursive+0xce/0x11d [fbac_lsm]
>  [<e10633fc>] build_task_tree_found_application+0x82/0x144 [fbac_lsm]
>  [<e10635d7>] build_task_tree_find_application+0x9d/0x1a5 [fbac_lsm]
>  [<e106381c>] build_task_tree+0x13d/0x1a1 [fbac_lsm]
>  [<e1064ca9>] start_task+0x32/0x175 [fbac_lsm]
>  [<e1060a6a>] fbac_lsm_bprm_set_security+0x124/0x1f1 [fbac_lsm]
>  [<c017449f>] prepare_binprm+0xa7/0xd0
>  [<c0173f27>] count+0x14/0x3f
>  [<c017597f>] do_execve+0xef/0x1e1
>  [<c01036fe>] sys_execve+0x2f/0x78
>  [<c0104e22>] sysenter_past_esp+0x6b/0xa9
>  =======================
> Mem-info:
> DMA per-cpu:
> CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 
> usd:   0
> Normal per-cpu:
> CPU    0: Hot: hi:  186, btch:  31 usd:  22   Cold: hi:   62, btch:  15 
> usd:  12
> Active:50484 inactive:64525 dirty:108 writeback:0 unstable:0
>  free:761 slab:10659 mapped:10607 pagetables:421 bounce:0
> DMA free:2000kB min:88kB low:108kB high:132kB active:392kB 
> inactive:8332kB present:16256kB pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 492 492
> Normal free:1044kB min:2792kB low:3488kB high:4188kB active:201544kB 
> inactive:249768kB present:503936kB pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 0 0
> DMA: 0*4kB 0*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 
> 0*2048kB 0*4096kB = 2000kB
> Normal: 1*4kB 0*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 
> 1*1024kB 0*2048kB 0*4096kB = 1044kB
> Swap cache: add 0, delete 0, find 0/0, race 0+0
> Free swap  = 0kB
> Total swap = 0kB
> Free swap:            0kB
> 131072 pages of RAM
> 0 pages of HIGHMEM
> 2092 reserved pages
> 92964 pages shared
> 0 pages swap cached
> 108 pages dirty
> 0 pages writeback
> 10607 pages mapped
> 10659 pages slab
> 421 pages pagetables
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

