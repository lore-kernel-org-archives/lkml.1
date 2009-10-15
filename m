Return-Path: <linux-kernel-owner+w=401wt.eu-S933174AbZJOIqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbZJOIqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932127AbZJOIqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:46:35 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:53562 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932109AbZJOIqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:46:33 -0400
Subject: Re: [2.6.32-rc3 kmemleak] WARNING: at kernel/lockdep.c:3161
	check_flags+0xbe/0x180()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <200910150352.n9F3q7QU008739@www262.sakura.ne.jp>
References: <200910130317.n9D3HTOH055400@www262.sakura.ne.jp>
	 <1255435201.9987.22.camel@pc1117.cambridge.arm.com>
	 <200910140025.CAJ82820.MOtOFOLVFFSHJQ@I-love.SAKURA.ne.jp>
	 <200910142055.HJH56741.FLOFSJOQHtFVMO@I-love.SAKURA.ne.jp>
	 <1255522972.15103.8.camel@pc1117.cambridge.arm.com>
	 <200910142212.IEI69780.MOtQOJHVSLOFFF@I-love.SAKURA.ne.jp>
	 <1255532113.15103.36.camel@pc1117.cambridge.arm.com>
	 <200910150352.n9F3q7QU008739@www262.sakura.ne.jp>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 15 Oct 2009 09:45:50 +0100
Message-Id: <1255596350.10164.11.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2009 08:45:52.0204 (UTC) FILETIME=[E6C9C0C0:01CA4D73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-15 at 12:52 +0900, Tetsuo Handa wrote:
> Catalin Marinas wrote:
> > Could you check the object_cache->obj_size/buffer_size and
> > scan_area_cache->obj_size/buffer_size in mm/kmemleak.c? The first
> > impression is that these somehow are too big when they shouldn't.
> > 
> > From your .config, you have DEBUG_PAGEALLOC enabled which may set
> > buffer_size to a full PAGE_SIZE. This size also enables the off slab
> > mgmt data.
> 
> Yes. object_cache->buffer_size was set to PAGE_SIZE.
> 
> [    0.000000] ***** object_cache->obj_size = 200 *****
> [    0.000000] ***** object_cache->buffer_size = 4096 *****
> [    0.000000] ***** scan_area_cache->obj_size = 16 *****
> [    0.000000] ***** scan_area_cache->buffer_size = 40 *****
> 
> I thought we should also pass SLAB_PANIC flag to
> 
> 	object_cache = KMEM_CACHE(kmemleak_object, SLAB_NOLEAKTRACE);
> 	scan_area_cache = KMEM_CACHE(kmemleak_scan_area, SLAB_NOLEAKTRACE);

I think it would be better to disable kmemleak than panicking.

> Don't we need to disable kmemleak routine (call kmemleak_disable()?)
> when early_alloc() failed in order to avoid false positives?

This is already done in create_object() via kmemleak_stop().

> I got below entries.
> (Similar entries are posted at http://lkml.org/lkml/2009/10/14/571 )

As a general rule with kmemleak, it would be useful to run a few "echo
scan > /sys/kernel/debug/kmemleak" to make sure they are not just
transient false positives.

> unreferenced object 0xf703d460 (size 24):
>   comm "swapper", pid 0, jiffies 4294892296
>   hex dump (first 24 bytes):
>     00 00 00 00 e8 97 c7 c1 02 00 00 00 1c 1e 21 d5  ..............!.
>     0c 93 4c c1 00 00 00 00                          ..L.....
>   backtrace:
>     [<c10d3944>] create_object+0xe4/0x220
>     [<c13226b3>] kmemleak_alloc+0x83/0xd0
>     [<c10cff55>] kmem_cache_alloc+0x185/0x1d0
>     [<c11b8d7d>] debug_objects_replace_static_objects+0x2d/0x1a0
>     [<c1518e34>] debug_objects_mem_init+0x64/0x70
>     [<c14f9974>] start_kernel+0x194/0x290
>     [<c14f9095>] i386_start_kernel+0x65/0xa0
>     [<ffffffff>] 0xffffffff

I get these reports as well and I think they are false positives. I
looked at the code in question and couldn't figure out why kmemleak is
confused.

> However, after doing
> 
>   # echo scan > /sys/kernel/debug/kmemleak
> 
> /sys/kernel/debug/kmemleak became empty.
> Does this mean that above entries were not memory leak?

Yes, they are just some transient memory leaks. This is usually caused
by the fact that kmemleak doesn't stop the allocations when scanning
(many garbage collectors do this). There are very few cases of false
positives left and debug_objects is one of them

Thanks.

-- 
Catalin

