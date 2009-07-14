Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbZGNJjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbZGNJjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbZGNJjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:39:22 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:59569 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753968AbZGNJjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:39:21 -0400
Subject: Re: 60 memory leaks.. or is it some thing wrong with kmemleak?
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A5C41C8.7040904@fisher-privat.net>
References: <4A5C20E5.6010203@fisher-privat.net>
	 <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com>
	 <4A5C41C8.7040904@fisher-privat.net>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 14 Jul 2009 10:39:16 +0100
Message-Id: <1247564356.28240.30.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2009 09:39:17.0450 (UTC) FILETIME=[F4D8BAA0:01CA0466]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On Tue, 2009-07-14 at 10:28 +0200, Alexey Fisher wrote:
> i updated now to git 2.6.31-rc3 and now i have
> "kmemleak: 76 new suspected memory leaks"
> 
> ext4 and control group still there.
[...]
> > On Tue, Jul 14, 2009 at 9:08 AM, Alexey
> > Fisher<bug-track@fisher-privat.net> wrote:
> >> unreferenced object 0xffff880133c63800 (size 1024):
> >>  comm "exe", pid 1521, jiffies 4294894652
> >>  backtrace:
> >>    [<ffffffff810f8f36>] create_object+0x126/0x2b0
> >>    [<ffffffff810f91d5>] kmemleak_alloc+0x25/0x60
> >>    [<ffffffff810f32a3>] __kmalloc+0x113/0x200
> >>    [<ffffffff811aa061>] ext4_mb_init+0x1b1/0x570
> >>    [<ffffffff8119b3d2>] ext4_fill_super+0x1de2/0x26d0
> >>    [<ffffffff810fe40f>] get_sb_bdev+0x16f/0x1b0
> >>    [<ffffffff811912f3>] ext4_get_sb+0x13/0x20
> >>    [<ffffffff810fdee6>] vfs_kern_mount+0x76/0x180
> >>    [<ffffffff810fe05d>] do_kern_mount+0x4d/0x120
> >>    [<ffffffff81115e17>] do_mount+0x307/0x880
> >>    [<ffffffff8111641f>] sys_mount+0x8f/0xe0
> >>    [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
> >>    [<ffffffffffffffff>] 0xffffffffffffffff
> >> unreferenced object 0xffff8801334db0c0 (size 192):
> >>  comm "exe", pid 1521, jiffies 4294894652
> >>  backtrace:
> >>    [<ffffffff810f8f36>] create_object+0x126/0x2b0
> >>    [<ffffffff810f91d5>] kmemleak_alloc+0x25/0x60
> >>    [<ffffffff810f32a3>] __kmalloc+0x113/0x200
> >>    [<ffffffff811aa061>] ext4_mb_init+0x1b1/0x570
> >>    [<ffffffff8119b3d2>] ext4_fill_super+0x1de2/0x26d0
> >>    [<ffffffff810fe40f>] get_sb_bdev+0x16f/0x1b0
> >>    [<ffffffff811912f3>] ext4_get_sb+0x13/0x20
> >>    [<ffffffff810fdee6>] vfs_kern_mount+0x76/0x180
> >>    [<ffffffff810fe05d>] do_kern_mount+0x4d/0x120
> >>    [<ffffffff81115e17>] do_mount+0x307/0x880
> >>    [<ffffffff8111641f>] sys_mount+0x8f/0xe0
> >>    [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
> >>    [<ffffffffffffffff>] 0xffffffffffffffff

It looks more like a leak than a false positive to me but I'm not
familiar with this code. Are any of the super_block or ext4_sb_info
structure present in the reported leaks?

To prove either way, one needs to see where the reported pointers are
stored and, if they are not overwritten, why kmemleak doesn't scan the
corresponding memory (it starts from stack, data and bss sections and
any referred block is subsequently scanned).

My approach to checking whether it is a real leak or not:

     1. Run "echo scan > /sys/kernel/debug/kmemleak" a few times and
        check the debug/kmemleak file. If they are still there, it is
        not just a transient report
     2. Check the function that allocated the memory, probably
        ext4_mb_init() in this case (but there is also
        ext4_mb_init_backend which may be inlined into ext4_mb_init and
        not shown in the trace). Assuming the former, the pointers to
        the two kmalloc'ed blocks are stored in the ext4_sb_info
        structure. If there is no obvious leak on an error path, go to
        the next point
     3. Check the block that should store the pointers reported as
        leaks. If such block isn't reported as leak, it means that it is
        either scanned (and it doesn't contain those pointers - probably
        real leak) or kmemleak doesn't know about it (usually
        alloc_pages and friends since kmemleak doesn't track these). In
        the above case, both ext4_sb_info and super_block structures are
        allocated with kzalloc
     4. If one of the parent blocks is reported as a leak, start from
        point 1 with this new block (note that kmemleak always lists the
        possible leaks in the order they were allocated)
     5. Add printk("%p...") to the kernel to see exactly which block was
        suspected to be a leak. Use gdb vmlinux /proc/kcore to see the
        contents of those blocks. In my kmemleak branch
        (http://www.linux-arm.org/git?p=linux-2.6.git;a=shortlog;h=kmemleak but planned for the next merging window) I have a feature to support "echo dump=0x.... > /sys/kernel/debug/kmemleak" so that you get what information kmemleak has about such block (in the above case, the parent ext4_sb_info)

There is also a separate class of false positive caused by pointer
masquerading (not storing the real pointer) but AFAIK there was only one
case in the past which was now reworked.

> >> unreferenced object 0xffff88013b852440 (size 544):
> >>  comm "swapper", pid 0, jiffies 4294892296
> >>  backtrace:
> >>    [<ffffffff810f8f36>] create_object+0x126/0x2b0
> >>    [<ffffffff810f91d5>] kmemleak_alloc+0x25/0x60
> >>    [<ffffffff810f24f3>] kmem_cache_alloc+0xf3/0x170
> >>    [<ffffffff8121deff>] idr_pre_get+0x5f/0x90
> >>    [<ffffffff810898c5>] get_new_cssid+0x65/0x120
> >>    [<ffffffff8174f7a3>] cgroup_init+0x6f/0x109
> >>    [<ffffffff8173ad21>] start_kernel+0x3a6/0x3ca
> >>    [<ffffffff8173a315>] x86_64_start_reservations+0x125/0x129
> >>    [<ffffffff8173a3fd>] x86_64_start_kernel+0xe4/0xeb
> >>    [<ffffffffffffffff>] 0xffffffffffffffff

I get some these as well but via drm_gem_handle_create() but I couldn't
figure out whether they are real or not.

I noticed on x86_64 that the vmlinux.lds.S file that the _edata is
defined before .data.read_mostly and a few others. In this case, the
__read_mostly and cache aligned variables wouldn't be scanned. Could you
try the patch below?

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 367e878..59f31d2 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -112,11 +112,6 @@ SECTIONS
 		_sdata = .;
 		DATA_DATA
 		CONSTRUCTORS
-
-#ifdef CONFIG_X86_64
-		/* End of data section */
-		_edata = .;
-#endif
 	} :data
 
 #ifdef CONFIG_X86_32
@@ -156,10 +151,8 @@ SECTIONS
 	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
 		*(.data.read_mostly)
 
-#ifdef CONFIG_X86_32
 		/* End of data section */
 		_edata = .;
-#endif
 	}
 
 #ifdef CONFIG_X86_64


Thanks.

-- 
Catalin

