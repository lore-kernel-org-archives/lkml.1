Return-Path: <linux-kernel-owner+w=401wt.eu-S1760189AbYELJnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189AbYELJnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 05:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYELJmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 05:42:52 -0400
Received: from www.tglx.de ([62.245.132.106]:45212 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbYELJmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 05:42:51 -0400
Date: Mon, 12 May 2008 11:42:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@qumranet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
In-Reply-To: <c4e36d110805070703s63c2426csd795d0e953a6e7bb@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0805121043010.3514@apollo.tec.linutronix.de>
References: <c4e36d110805070703s63c2426csd795d0e953a6e7bb@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Zdenek Kabelac wrote:
> RIP: 0010:[kernel_map_pages+158/368]  [kernel_map_pages+158/368]
> kernel_map_pages+0x9e/0x170
> RSP: 0018:ffff81007db45c28  EFLAGS: 00010206
> RAX: 0000000000000660 RBX: 0000000000000001 RCX: ffff81007db45c28
> RDX: 00000000000006e0 RSI: ffff81007db45be4 RDI: ffffffff81000000
> RBP: ffff81007db45c78 R08: 000000007cb6b000 R09: ffff810000000000
> R10: 0000000000000001 R11: 0000000000000001 R12: ffffe20002e467c0
> R13: 0000000000000002 R14: ffff81007ca74920 R15: 0000000000000282
> FS:  00007f5eb4aef780(0000) GS:ffffffff81494000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007fffbcb28ef0 CR3: 000000007d88e000 CR4: 0000000000002660
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process udevd (pid: 608, threadinfo ffff81007db44000, task ffff81007ca74920)
> Stack:  ffff81007b66c000 0000000000000003 0000000000000000 0000000100000001
>  000000000007b66b 0000000000000000 ffff81007db45c78 0000000000000005
>  ffffe20002e467c0 0000000000000000 ffff81007db45d38 ffffffff810923b9
> Call Trace:
>  [get_page_from_freelist+1161/1632] get_page_from_freelist+0x489/0x660
>  [__alloc_pages_internal+271/1408] __alloc_pages_internal+0x10f/0x580
>  [kmem_cache_alloc+168/208] ? kmem_cache_alloc+0xa8/0xd0
>  [__alloc_pages+11/16] __alloc_pages+0xb/0x10
>  [__get_free_pages+28/96] __get_free_pages+0x1c/0x60
>  [copy_process+187/5184] copy_process+0xbb/0x1440
>  [put_lock_stats+14/48] ? put_lock_stats+0xe/0x30
>  [do_fork+116/816] do_fork+0x74/0x330
>  [trace_hardirqs_on+305/400] ? trace_hardirqs_on+0x131/0x190
>  [_spin_unlock_irqrestore+69/144] ? _spin_unlock_irqrestore+0x45/0x90
>  [__up_write+208/304] ? __up_write+0xd0/0x130
>  [trace_hardirqs_on_thunk+53/58] ? trace_hardirqs_on_thunk+0x35/0x3a
>  [system_call_after_swapgs+123/128] ? system_call_after_swapgs+0x7b/0x80
>  [sys_clone+35/48] sys_clone+0x23/0x30
>  [ptregscall_common+103/176] ptregscall_common+0x67/0xb0
> 
> 
> Code: 7d b0 48 0f af c2 48 ba 00 00 00 00 00 81 ff ff 48 c1 e0 0c 48
> 01 d0 48 89 45 b0 e8 2d f6 ff ff 0f 20 e2 48 89 d0 24 7f 0f 22 e0 <0f>
> 22 e2 31 ff e8 18 f5 ff ff 48 8b 5d e8 4c 8b 65 f0 4c 8b 6d

This is failing in: mov %rdx, cr4

The full code sequence is:

    mov cr4, %rdx
    mov %rdx, %rax
    and $0x7f, %al
    mov %rax, %cr4
    mov %rdx, %cr4

So looking at the register contents:

   RDX: 00000000000006e0
   RAX: 0000000000000660

makes sense so far, as this is the PGE bit manipulation in
__native_flush_tlb_global(), but the CR4 register content is:

   CR4: 0000000000002660

which has the X86_CR4_VMXE bit set. Looking deeper it turns out that
KVM uses smp_function_call to manipulate the X86_CR4_VMXE bit either
from the CPU hotplug code or from the kvm_init call. This means that
we need to protect the CR4 manipulation in __native_flush_tlb_global()
from both interrupts and preemption.

This is a hard to trigger race which happened to show once on Zdeneks
system. The patch below should fix it.

Thanks,
	tglx

------------>
Subject: x86: prevent PGE flush from interruption/preemption
From: Ingo Molnar <mingo@elte.hu>
Date: Mon May 12 10:11:19 CEST 2008

CR4 manipulation is not protected against interrupts and preemption,
but KVM uses smp_function_call to manipulate the X86_CR4_VMXE bit
either from the CPU hotplug code or from the kvm_init call.

We need to protect the CR4 manipulation from both interrupts and
preemption.

Original bug report: http://lkml.org/lkml/2008/5/7/48
Bugzilla entry: http://bugzilla.kernel.org/show_bug.cgi?id=10642

This is not a regression from 2.6.25, it's a long standing and hard to
trigger bug.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-x86/tlbflush.h |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6/include/asm-x86/tlbflush.h
===================================================================
--- linux-2.6.orig/include/asm-x86/tlbflush.h
+++ linux-2.6/include/asm-x86/tlbflush.h
@@ -22,12 +22,22 @@ static inline void __native_flush_tlb(vo
 
 static inline void __native_flush_tlb_global(void)
 {
-	unsigned long cr4 = read_cr4();
+	unsigned long cr4, flags;
 
+	/*
+	 * Read-modify-write to CR4 - protect it from preemption and
+	 * from interrupts. (Use the raw variant because this code can
+	 * be called from deep inside debugging code.)
+	 */
+	raw_local_irq_save(flags);
+
+	cr4 = read_cr4();
 	/* clear PGE */
 	write_cr4(cr4 & ~X86_CR4_PGE);
 	/* write old PGE again and flush TLBs */
 	write_cr4(cr4);
+
+	raw_local_irq_restore(flags);
 }
 
 static inline void __native_flush_tlb_single(unsigned long addr)

