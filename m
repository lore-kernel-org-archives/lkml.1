Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbYEAGE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbYEAGE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 02:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYEAGEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 02:04:46 -0400
Received: from ozlabs.org ([203.10.76.45]:51586 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbYEAGEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 02:04:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18457.23905.318625.552927@cargo.ozlabs.ibm.com>
Date: Thu, 1 May 2008 16:04:17 +1000
From: Paul Mackerras <paulus@samba.org>
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: [POWERPC] Bolt in SLB entry for kernel stack on secondary cpus
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a regression reported by Kamalesh Bulabel where a POWER4
machine would crash because of an SLB miss at a point where the SLB
miss exception was unrecoverable.  This regression is tracked at:

http://bugzilla.kernel.org/show_bug.cgi?id=10082

SLB misses at such points shouldn't happen because the kernel stack is
the only memory accessed other than things in the first segment of the
linear mapping (which is mapped at all times by entry 0 of the SLB).
The context switch code ensures that SLB entry 2 covers the kernel
stack, if it is not already covered by entry 0.  None of entries 0
to 2 are ever replaced by the SLB miss handler.

Where this went wrong is that the context switch code assumes it
doesn't have to write to SLB entry 2 if the new kernel stack is in the
same segment as the old kernel stack, since entry 2 should already be
correct.  However, when we start up a secondary cpu, it calls
slb_initialize, which doesn't set up entry 2.  This is correct for
the boot cpu, where we will be using a stack in the kernel BSS at this
point (i.e. init_thread_union), but not necessarily for secondary
cpus, whose initial stack can be allocated anywhere.  This doesn't
cause any immediate problem since the SLB miss handler will just
create an SLB entry somewhere else to cover the initial stack.

In fact it's possible for the cpu to go quite a long time without SLB
entry 2 being valid.  Eventually, though, the entry created by the SLB
miss handler will get overwritten by some other entry, and if the next
access to the stack is at an unrecoverable point, we get the crash.

This fixes the problem by making slb_initialize create a suitable
entry for the kernel stack, if we are on a secondary cpu and the stack
isn't covered by SLB entry 0.  This requires initializing the
get_paca()->kstack field earlier, so I do that in smp_create_idle
where the current field is initialized.  This also abstracts a bit of
the computation that mk_esid_data in slb.c does so that it can be used
in slb_initialize.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index be35ffa..1457aa0 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -386,6 +386,8 @@ static void __init smp_create_idle(unsigned int cpu)
 		panic("failed fork for CPU %u: %li", cpu, PTR_ERR(p));
 #ifdef CONFIG_PPC64
 	paca[cpu].__current = p;
+	paca[cpu].kstack = (unsigned long) task_thread_info(p)
+		+ THREAD_SIZE - STACK_FRAME_OVERHEAD;
 #endif
 	current_set[cpu] = task_thread_info(p);
 	task_thread_info(p)->cpu = cpu;
diff --git a/arch/powerpc/mm/slb.c b/arch/powerpc/mm/slb.c
index 906daed..b2c43d0 100644
--- a/arch/powerpc/mm/slb.c
+++ b/arch/powerpc/mm/slb.c
@@ -44,13 +44,13 @@ static void slb_allocate(unsigned long ea)
 	slb_allocate_realmode(ea);
 }
 
+#define slb_esid_mask(ssize)	\
+	(((ssize) == MMU_SEGSIZE_256M)? ESID_MASK: ESID_MASK_1T)
+
 static inline unsigned long mk_esid_data(unsigned long ea, int ssize,
 					 unsigned long slot)
 {
-	unsigned long mask;
-
-	mask = (ssize == MMU_SEGSIZE_256M)? ESID_MASK: ESID_MASK_1T;
-	return (ea & mask) | SLB_ESID_V | slot;
+	return (ea & slb_esid_mask(ssize)) | SLB_ESID_V | slot;
 }
 
 #define slb_vsid_shift(ssize)	\
@@ -301,11 +301,16 @@ void slb_initialize(void)
 
 	create_shadowed_slbe(VMALLOC_START, mmu_kernel_ssize, vflags, 1);
 
+	/* For the boot cpu, we're running on the stack in init_thread_union,
+	 * which is in the first segment of the linear mapping, and also
+	 * get_paca()->kstack hasn't been initialized yet.
+	 * For secondary cpus, we need to bolt the kernel stack entry now.
+	 */
 	slb_shadow_clear(2);
+	if (raw_smp_processor_id() > 0 &&
+	    (get_paca()->kstack & slb_esid_mask(mmu_kernel_ssize)) > PAGE_OFFSET)
+		create_shadowed_slbe(get_paca()->kstack,
+				     mmu_kernel_ssize, lflags, 2);
 
-	/* We don't bolt the stack for the time being - we're in boot,
-	 * so the stack is in the bolted segment.  By the time it goes
-	 * elsewhere, we'll call _switch() which will bolt in the new
-	 * one. */
 	asm volatile("isync":::"memory");
 }
