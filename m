Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbZJNL4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbZJNL4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 07:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758662AbZJNL4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 07:56:35 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:49974 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758370AbZJNL4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 07:56:34 -0400
To: catalin.marinas@arm.com
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.32-rc3 kmemleak] WARNING: atkernel/lockdep.c:3161check_flags+0xbe/0x180()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200910082134.EJD35962.HLFSQVFOOFMJOt@I-love.SAKURA.ne.jp>
	<1255005738.6715.6.camel@pc1117.cambridge.arm.com>
	<200910130317.n9D3HTOH055400@www262.sakura.ne.jp>
	<1255435201.9987.22.camel@pc1117.cambridge.arm.com>
	<200910140025.CAJ82820.MOtOFOLVFFSHJQ@I-love.SAKURA.ne.jp>
In-Reply-To: <200910140025.CAJ82820.MOtOFOLVFFSHJQ@I-love.SAKURA.ne.jp>
Message-Id: <200910142055.HJH56741.FLOFSJOQHtFVMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 14 Oct 2009 20:55:56 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> > This is the "DEBUG_LOCKS_WARN_ON(current->softirqs_enabled)" warning.
> > I'm not sure why this happens but from the trace it seems that kmemleak
> > is being called recursively via alloc_slabmgmt() which is caused by
> > kmem_cache_alloc() called from create_object() in kmemleak.c.
> If what my guess shown below is correct,
> (object_cache->slabp_cache->flags & SLAB_NOLEAKTRACE) == 0
> is triggering recursive calls.

I applied below patch

--- linux-2.6.32-rc4/mm/slab.c	2009-10-14 16:22:44.962007072 +0900
+++ linux-2.6.32-rc4-ccs/mm/slab.c	2009-10-14 16:08:14.000000000 +0900
@@ -2573,6 +2573,8 @@
 	struct slab *slabp;
 
 	if (OFF_SLAB(cachep)) {
+		BUG_ON((cachep->flags & SLAB_NOLEAKTRACE) &&
+		       !(cachep->slabp_cache->flags & SLAB_NOLEAKTRACE));
 		/* Slab management obj is off-slab. */
 		slabp = kmem_cache_alloc_node(cachep->slabp_cache,
 					      local_flags, nodeid);

and verified that (cachep->slabp_cache->flags & SLAB_NOLEAKTRACE) == 0 is
triggering recursive call.
This is not locking related problem. This is stack overflow problem.

[    0.000000] Linux version 2.6.32-rc4-ccs (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #2 SMP Wed Oct 14 16:09:02 JST 2009
(...snipped...)
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ------------[ cut here ]------------
[    0.000000] kernel BUG at mm/slab.c:2577!
[    0.000000] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[    0.000000] last sysfs file: 
[    0.000000] Modules linked in:
[    0.000000] 
[    0.000000] Pid: 0, comm: swapper Not tainted (2.6.32-rc4-ccs #2) VMware Virtual Platform
[    0.000000] EIP: 0060:[<c10cf0b1>] EFLAGS: 00010046 CPU: 0
[    0.000000] EIP is at alloc_slabmgmt+0x81/0xa0
[    0.000000] EAX: cf800200 EBX: 00000020 ECX: 00000000 EDX: 00800000
[    0.000000] ESI: 00000000 EDI: cf837000 EBP: c14c4ec0 ESP: c14c4eb0
[    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.000000] Process swapper (pid: 0, ti=c14c4000 task=c14d7700 task.ti=c14c4000)
[    0.000000] Stack:
[    0.000000]  00000000 00000020 cf832bc0 cf804f30 c14c4ef0 c10cf4ee 00000020 00000000
[    0.000000] <0> 00000000 cf804f54 00000020 00000000 00000000 00000000 cf832bc0 cf804f40
[    0.000000] <0> c14c4f1c c10cfb0b cf837000 cf804f54 cf833f30 cf804f30 0000000c 00000020
[    0.000000] Call Trace:
[    0.000000]  [<c10cf4ee>] ? cache_grow+0xae/0x170
[    0.000000]  [<c10cfb0b>] ? cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10d016a>] ? kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10d3a79>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3a79>] ? create_object+0x29/0x220
[    0.000000]  [<c10d409a>] ? early_alloc+0x3a/0xe0
[    0.000000]  [<c10d40dc>] ? early_alloc+0x7c/0xe0
[    0.000000]  [<c10d409a>] ? early_alloc+0x3a/0xe0
[    0.000000]  [<c106e077>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c152ae62>] ? kmemleak_init+0xf2/0x180
[    0.000000]  [<c151096f>] ? start_kernel+0x18f/0x290
[    0.000000]  [<c15102c0>] ? unknown_bootoption+0x0/0x150
[    0.000000]  [<c1510095>] ? i386_start_kernel+0x65/0xa0
[    0.000000] Code: 36 0f 00 00 89 c3 31 d2 8b 45 08 b9 08 00 00 00 89 04 24 89 d8 e8 60 66 26 00 31 c0 85 db 75 ab eb c9 8b 40 34 f6 40 1e 80 75 d1 <0f> 0b 8d b6 00 00 00 00 8d bc 27 00 00 00 00 eb fe 8d b4 26 00 
[    0.000000] EIP: [<c10cf0b1>] alloc_slabmgmt+0x81/0xa0 SS:ESP 0068:c14c4eb0
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] Pid: 0, comm: swapper Tainted: G      D    2.6.32-rc4-ccs #2
[    0.000000] Call Trace:
[    0.000000]  [<c10417ed>] ? printk+0x1d/0x30
[    0.000000]  [<c1040948>] panic+0x48/0x110
[    0.000000]  [<c1043f12>] do_exit+0x2b2/0x2d0
[    0.000000]  [<c1040cef>] ? print_oops_end_marker+0x2f/0x40
[    0.000000]  [<c1007508>] oops_end+0xb8/0xc0
[    0.000000]  [<c1007670>] die+0x60/0x80
[    0.000000]  [<c1003b63>] do_trap+0xb3/0xc0
[    0.000000]  [<c1003d10>] ? do_invalid_op+0x0/0xb0
[    0.000000]  [<c1003da0>] do_invalid_op+0x90/0xb0
[    0.000000]  [<c10cf0b1>] ? alloc_slabmgmt+0x81/0xa0
[    0.000000]  [<c10aa189>] ? get_page_from_freelist+0x139/0x2b0
[    0.000000]  [<c1349897>] ? error_code+0x67/0x70
[    0.000000]  [<c1003d10>] ? do_invalid_op+0x0/0xb0
[    0.000000]  [<c11bd82c>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.000000]  [<c134989b>] error_code+0x6b/0x70
[    0.000000]  [<c1003d10>] ? do_invalid_op+0x0/0xb0
[    0.000000]  [<c10cf0b1>] ? alloc_slabmgmt+0x81/0xa0
[    0.000000]  [<c10cf4ee>] cache_grow+0xae/0x170
[    0.000000]  [<c10cfb0b>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10d016a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10d3a79>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3a79>] create_object+0x29/0x220
[    0.000000]  [<c10d409a>] ? early_alloc+0x3a/0xe0
[    0.000000]  [<c10d40dc>] early_alloc+0x7c/0xe0
[    0.000000]  [<c10d409a>] ? early_alloc+0x3a/0xe0
[    0.000000]  [<c106e077>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c152ae62>] kmemleak_init+0xf2/0x180
[    0.000000]  [<c151096f>] start_kernel+0x18f/0x290
[    0.000000]  [<c15102c0>] ? unknown_bootoption+0x0/0x150
[    0.000000]  [<c1510095>] i386_start_kernel+0x65/0xa0
