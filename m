Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbZJTREN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbZJTREN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 13:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbZJTREM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 13:04:12 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:35243 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643AbZJTREL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 13:04:11 -0400
Subject: Re: Leaks in trace reported by kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <c4e36d110910200258q7c1d6b4uf74b6d365ffb3f40@mail.gmail.com>
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
	 <1255690674.3008.24.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160632y4448475dp1ae66dfc01ff8448@mail.gmail.com>
	 <tnxbpk7a0ok.fsf@pc1117.cambridge.arm.com>
	 <c4e36d110910160728n5ceefaa8u6b9989aec0564628@mail.gmail.com>
	 <c4e36d110910160807i2298dacp7d37289ca3ad25f@mail.gmail.com>
	 <1255711285.3008.59.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910190215j129e61ey5e20634a4bc19292@mail.gmail.com>
	 <1255953605.31096.26.camel@pc1117.cambridge.arm.com>
	 <1255958422.31096.33.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910200258q7c1d6b4uf74b6d365ffb3f40@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 20 Oct 2009 18:03:49 +0100
Message-Id: <1256058229.32578.36.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2009 17:03:50.0790 (UTC) FILETIME=[4BE0EA60:01CA51A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-20 at 11:58 +0200, Zdenek Kabelac wrote:
> I've tested your git with updates - and here is my experience:
> 
> I'm still able to get FP leaks printed even with the print of
> more-then-once appearanc.
> 
> i.e. here is output of dump=
> 
> kmemleak: Object 0xffff8801390fd300 (size 192):
> kmemleak:   comm "swapper", pid 1, jiffies 4294877823
> kmemleak:   min_count = 1
> kmemleak:   count = 0
> kmemleak:   flags = 0xb
> kmemleak:   backtrace:
>      [<ffffffff8140e986>] kmemleak_alloc+0x26/0x50
>      [<ffffffff811269f1>] kmem_cache_alloc_notrace+0xc1/0x140
>      [<ffffffff8127243a>] dma_debug_init+0x23a/0x3a0
>      [<ffffffff81864a37>] pci_iommu_init+0xe/0x28
>      [<ffffffff8100904c>] do_one_initcall+0x3c/0x1d0
>      [<ffffffff8185f4e6>] kernel_init+0x150/0x1a6
>      [<ffffffff8100d21a>] child_rip+0xa/0x20
>      [<ffffffffffffffff>] 0xffffffffffffffff

I investigated this a bit more (similar to the debug_objects false
positives, they behave similarly). I can reproduce the debug_objects
false positive by running ltp in parallel with "echo scan".

Basically, there is a free list of debug objects with the hlist_head
usually in the data section (obj_pool) and scanned by kmemleak. The
kernel retrieves one element from the top of the list when required to
allocate one. The scenario is something like below:

     1. kmemleak scans the data section and the free_entries variable
        points to an object A (which also points to object B). The
        object A is added to the gray list for scanning (object A not a
        leak)
     2. kernel removes object A from the list also modifying (maybe
        zeroing) the hlist_node structure inside object A. The
        hlist_head now points to object B
     3. kmemleak eventually reaches object A during scanning but it
        doesn't point to object B anymore, hence B becomes a suspected
        leak

The scenario above can happen during more than one consecutive scans for
the same objects at the tail of the list, especially when objects at the
head of the list are removed and added frequently. While it is harder to
show false positive if we require a minimum number of consecutive scans,
it is still possible to show them.

I'll have to think about other ways to avoid this kind of false
positives than requiring a minimum number of scans (and not locking the
system during a scan).

> Also jiffies might be eventually more readable via data/time - but
> this can be preprocessed via script.

I think that would be useful as well. I'll keep it in mind.

> Anyway here are few leaks from i915 -
> 
> unreferenced object 0xffff8800bf15fba0 (size 544):
>   comm "X", pid 2014, jiffies 4299475327
>   hex dump (first 32 bytes):
>     ff ff ff ff ff ff ff ff 40 db aa ba 00 88 ff ff  ........@.......
>     00 df aa ba 00 88 ff ff c0 d0 aa ba 00 88 ff ff  ................
>   backtrace:
>     [<ffffffff8140e986>] kmemleak_alloc+0x26/0x50
>     [<ffffffff81126c73>] kmem_cache_alloc+0x133/0x1c0
>     [<ffffffff8125f43f>] idr_pre_get+0x5f/0x90
>     [<ffffffffa03374cd>] drm_gem_handle_create+0x3d/0xb0 [drm]
>     [<ffffffffa0379815>] i915_gem_create_ioctl+0x65/0xc0 [i915]
>     [<ffffffffa0335f76>] drm_ioctl+0x176/0x390 [drm]
>     [<ffffffff81143b9c>] vfs_ioctl+0x7c/0xa0
>     [<ffffffff81143ce4>] do_vfs_ioctl+0x84/0x590
>     [<ffffffff81144271>] sys_ioctl+0x81/0xa0
>     [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Those are present also after i915 removal:
> 
> unreferenced object 0xffff880132f31760 (size 544):
>   comm "X", pid 2014, jiffies 4294899254
>   hex dump (first 32 bytes):
>     ff ff ff df fe dd f5 9a 40 4e 34 30 01 88 ff ff  ........@N40....
>     80 41 34 30 01 88 ff ff c0 46 34 30 01 88 ff ff  .A40.....F40....
>   backtrace:
>     [<ffffffff8140e986>] kmemleak_alloc+0x26/0x50
>     [<ffffffff81126c73>] kmem_cache_alloc+0x133/0x1c0
>     [<ffffffff8125f43f>] idr_pre_get+0x5f/0x90
>     [<ffffffffa03374cd>] 0xffffffffa03374cd
>     [<ffffffffa0379815>] 0xffffffffa0379815
>     [<ffffffffa0335f76>] 0xffffffffa0335f76
>     [<ffffffff81143b9c>] vfs_ioctl+0x7c/0xa0
>     [<ffffffff81143ce4>] do_vfs_ioctl+0x84/0x590
>     [<ffffffff81144271>] sys_ioctl+0x81/0xa0
>     [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b
>     [<ffffffffffffffff>] 0xffffffffffffffff

I got this as well even without removing modules. IIRC, I reported it on
the list some time ago.

-- 
Catalin

