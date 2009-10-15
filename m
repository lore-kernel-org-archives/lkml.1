Return-Path: <linux-kernel-owner+w=401wt.eu-S933406AbZJODxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406AbZJODxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 23:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932972AbZJODxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 23:53:02 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57364 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408AbZJODxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 23:53:00 -0400
Message-Id: <200910150352.n9F3q7QU008739@www262.sakura.ne.jp>
Subject: Re: [2.6.32-rc3 kmemleak] WARNING: at kernel/lockdep.c:3161 check_flags+0xbe/0x180()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: catalin.marinas@arm.com
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 15 Oct 2009 12:52:07 +0900
References: <200910130317.n9D3HTOH055400@www262.sakura.ne.jp> <1255435201.9987.22.camel@pc1117.cambridge.arm.com> <200910140025.CAJ82820.MOtOFOLVFFSHJQ@I-love.SAKURA.ne.jp> <200910142055.HJH56741.FLOFSJOQHtFVMO@I-love.SAKURA.ne.jp> <1255522972.15103.8.camel@pc1117.cambridge.arm.com> <200910142212.IEI69780.MOtQOJHVSLOFFF@I-love.SAKURA.ne.jp> <1255532113.15103.36.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1255532113.15103.36.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 15102009 #2763109, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> Could you check the object_cache->obj_size/buffer_size and
> scan_area_cache->obj_size/buffer_size in mm/kmemleak.c? The first
> impression is that these somehow are too big when they shouldn't.
> 
> From your .config, you have DEBUG_PAGEALLOC enabled which may set
> buffer_size to a full PAGE_SIZE. This size also enables the off slab
> mgmt data.

Yes. object_cache->buffer_size was set to PAGE_SIZE.

[    0.000000] ***** object_cache->obj_size = 200 *****
[    0.000000] ***** object_cache->buffer_size = 4096 *****
[    0.000000] ***** scan_area_cache->obj_size = 16 *****
[    0.000000] ***** scan_area_cache->buffer_size = 40 *****



I thought we should also pass SLAB_PANIC flag to

	object_cache = KMEM_CACHE(kmemleak_object, SLAB_NOLEAKTRACE);
	scan_area_cache = KMEM_CACHE(kmemleak_scan_area, SLAB_NOLEAKTRACE);

although it unlikely fails.



Don't we need to disable kmemleak routine (call kmemleak_disable()?)
when early_alloc() failed in order to avoid false positives?

I got below entries.
(Similar entries are posted at http://lkml.org/lkml/2009/10/14/571 )

# cat /sys/kernel/debug/kmemleak
unreferenced object 0xf703d460 (size 24):
  comm "swapper", pid 0, jiffies 4294892296
  hex dump (first 24 bytes):
    00 00 00 00 e8 97 c7 c1 02 00 00 00 1c 1e 21 d5  ..............!.
    0c 93 4c c1 00 00 00 00                          ..L.....
  backtrace:
    [<c10d3944>] create_object+0xe4/0x220
    [<c13226b3>] kmemleak_alloc+0x83/0xd0
    [<c10cff55>] kmem_cache_alloc+0x185/0x1d0
    [<c11b8d7d>] debug_objects_replace_static_objects+0x2d/0x1a0
    [<c1518e34>] debug_objects_mem_init+0x64/0x70
    [<c14f9974>] start_kernel+0x194/0x290
    [<c14f9095>] i386_start_kernel+0x65/0xa0
    [<ffffffff>] 0xffffffff
unreferenced object 0xf703d9a0 (size 24):
  comm "swapper", pid 0, jiffies 4294892296
  hex dump (first 24 bytes):
    c0 8d d4 f6 c0 87 d4 f6 03 00 00 00 d4 fc 40 d2  ..............@.
    24 88 4c c1 00 00 00 00                          $.L.....
  backtrace:
    [<c10d3944>] create_object+0xe4/0x220
    [<c13226b3>] kmemleak_alloc+0x83/0xd0
    [<c10cff55>] kmem_cache_alloc+0x185/0x1d0
    [<c11b8d7d>] debug_objects_replace_static_objects+0x2d/0x1a0
    [<c1518e34>] debug_objects_mem_init+0x64/0x70
    [<c14f9974>] start_kernel+0x194/0x290
    [<c14f9095>] i386_start_kernel+0x65/0xa0
    [<ffffffff>] 0xffffffff
unreferenced object 0xf703d970 (size 24):
  comm "swapper", pid 0, jiffies 4294892296
  hex dump (first 24 bytes):
    00 00 00 00 60 c5 cc c1 02 00 00 00 1c 7e cd f5  ....`........~..
    0c 93 4c c1 00 00 00 00                          ..L.....
  backtrace:
    [<c10d3944>] create_object+0xe4/0x220
    [<c13226b3>] kmemleak_alloc+0x83/0xd0
    [<c10cff55>] kmem_cache_alloc+0x185/0x1d0
    [<c11b8d7d>] debug_objects_replace_static_objects+0x2d/0x1a0
    [<c1518e34>] debug_objects_mem_init+0x64/0x70
    [<c14f9974>] start_kernel+0x194/0x290
    [<c14f9095>] i386_start_kernel+0x65/0xa0
    [<ffffffff>] 0xffffffff
unreferenced object 0xf703d8e0 (size 24):
  comm "swapper", pid 0, jiffies 4294892296
  hex dump (first 24 bytes):
    00 00 00 00 20 ee cf c1 02 00 00 00 64 a9 89 d7  .... .......d...
    24 88 4c c1 00 00 00 00                          $.L.....
  backtrace:
    [<c10d3944>] create_object+0xe4/0x220
    [<c13226b3>] kmemleak_alloc+0x83/0xd0
    [<c10cff55>] kmem_cache_alloc+0x185/0x1d0
    [<c11b8d7d>] debug_objects_replace_static_objects+0x2d/0x1a0
    [<c1518e34>] debug_objects_mem_init+0x64/0x70
    [<c14f9974>] start_kernel+0x194/0x290
    [<c14f9095>] i386_start_kernel+0x65/0xa0
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6d48dc0 (size 24):
  comm "getty", pid 2567, jiffies 4294904897
  hex dump (first 24 bytes):
    00 00 00 00 a0 d9 03 f7 03 00 00 00 90 fc 40 d2  ..............@.
    24 88 4c c1 00 00 00 00                          $.L.....
  backtrace:
    [<c10d3944>] create_object+0xe4/0x220
    [<c13226b3>] kmemleak_alloc+0x83/0xd0
    [<c10cff55>] kmem_cache_alloc+0x185/0x1d0
    [<c11b80ec>] fill_pool+0x3c/0xa0
    [<c11b856c>] __debug_object_init+0x1c/0xf0
    [<c11b867a>] debug_object_init_on_stack+0x1a/0x20
    [<c105e0a6>] hrtimer_init_on_stack+0x26/0x40
    [<c105ec0f>] hrtimer_nanosleep+0x3f/0x100
    [<c105ed27>] sys_nanosleep+0x57/0x60
    [<c1002f59>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6d487c0 (size 24):
  comm "getty", pid 2563, jiffies 4294904897
  hex dump (first 24 bytes):
    a0 d9 03 f7 88 67 c6 c1 03 00 00 00 50 fb 40 d2  .....g......P.@.
    24 88 4c c1 00 00 00 00                          $.L.....
  backtrace:
    [<c10d3944>] create_object+0xe4/0x220
    [<c13226b3>] kmemleak_alloc+0x83/0xd0
    [<c10cff55>] kmem_cache_alloc+0x185/0x1d0
    [<c11b80ec>] fill_pool+0x3c/0xa0
    [<c11b856c>] __debug_object_init+0x1c/0xf0
    [<c11b867a>] debug_object_init_on_stack+0x1a/0x20
    [<c105e0a6>] hrtimer_init_on_stack+0x26/0x40
    [<c105ec0f>] hrtimer_nanosleep+0x3f/0x100
    [<c105ed27>] sys_nanosleep+0x57/0x60
    [<c1002f59>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff

However, after doing

  # echo scan > /sys/kernel/debug/kmemleak

/sys/kernel/debug/kmemleak became empty.
Does this mean that above entries were not memory leak?

Regards.
