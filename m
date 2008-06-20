Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbYFTWvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbYFTWvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 18:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbYFTWvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 18:51:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45949
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754357AbYFTWvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 18:51:39 -0400
Date: Fri, 20 Jun 2008 15:51:39 -0700 (PDT)
Message-Id: <20080620.155139.224032701.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: kernel-testers@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
From: David Miller <davem@davemloft.net>
In-Reply-To: <a4423d670806201542o5415cad7p6b9a38b67252cee1@mail.gmail.com>
References: <a4423d670806201419i2f0c0982j69eb423f9ecd239d@mail.gmail.com>
	<20080620.142137.242155859.davem@davemloft.net>
	<a4423d670806201542o5415cad7p6b9a38b67252cee1@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alexander Beregalov" <a.beregalov@gmail.com>
Date: Sat, 21 Jun 2008 02:42:36 +0400

> I can not see such messages in lockdep output:
> 
> [   17.960404] Console: colour dummy device 80x25
> [   18.060543] console handover: boot [earlyprom0] -> real [tty0]
> [   18.169062] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,
> Ingo Molnar
> [   18.169180] ... MAX_LOCKDEP_SUBCLASSES:    8
> [   18.169246] ... MAX_LOCK_DEPTH:          48
> [   18.169310] ... MAX_LOCKDEP_KEYS:        2048
> [   18.169376] ... CLASSHASH_SIZE:           1024
> [   18.169444] ... MAX_LOCKDEP_ENTRIES:     8192
> [   18.169509] ... MAX_LOCKDEP_CHAINS:      16384
> [   18.169577] ... CHAINHASH_SIZE:          8192
> [   18.169643]  memory used by lock dependency info: 1648 kB
> [   18.169722]  per task-struct memory footprint: 2688 bytes
> [   18.169798] ------------------------
> [   18.169855] | Locking API testsuite:

Something is screwey here... Hmmm...

When I added the changeset in question, it fixed a problem in that
any backtrace of a kernel thread would loop forever at the end.
Any stack backtrace would hang or reach a safety limit (such as
the one imposed by lockdep).

Please double check that you are precisely reverting this patch
below _before_ doing these tests:

commit a051bc5bb1ac6dc138d529077fa20cbbc6622d95
Author: David S. Miller <davem@davemloft.net>
Date:   Wed May 21 18:14:28 2008 -0700

    sparc64: Fix kernel thread stack termination.
    
    Because of the silly way I set up the initial stack for
    new kernel threads, there is a loop at the top of the
    stack.
    
    To fix this, properly add another stack frame that is copied
    from the parent and terminate it in the child by setting
    the frame pointer in that frame to zero.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc64/kernel/process.c b/arch/sparc64/kernel/process.c
index 0a0c05f..2084f81 100644
--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -657,20 +657,39 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 		struct task_struct *p, struct pt_regs *regs)
 {
 	struct thread_info *t = task_thread_info(p);
+	struct sparc_stackf *parent_sf;
+	unsigned long child_stack_sz;
 	char *child_trap_frame;
+	int kernel_thread;
 
-	/* Calculate offset to stack_frame & pt_regs */
-	child_trap_frame = task_stack_page(p) + (THREAD_SIZE - (TRACEREG_SZ+STACKFRAME_SZ));
-	memcpy(child_trap_frame, (((struct sparc_stackf *)regs)-1), (TRACEREG_SZ+STACKFRAME_SZ));
+	kernel_thread = (regs->tstate & TSTATE_PRIV) ? 1 : 0;
+	parent_sf = ((struct sparc_stackf *) regs) - 1;
 
-	t->flags = (t->flags & ~((0xffUL << TI_FLAG_CWP_SHIFT) | (0xffUL << TI_FLAG_CURRENT_DS_SHIFT))) |
+	/* Calculate offset to stack_frame & pt_regs */
+	child_stack_sz = ((STACKFRAME_SZ + TRACEREG_SZ) +
+			  (kernel_thread ? STACKFRAME_SZ : 0));
+	child_trap_frame = (task_stack_page(p) +
+			    (THREAD_SIZE - child_stack_sz));
+	memcpy(child_trap_frame, parent_sf, child_stack_sz);
+
+	t->flags = (t->flags & ~((0xffUL << TI_FLAG_CWP_SHIFT) |
+				 (0xffUL << TI_FLAG_CURRENT_DS_SHIFT))) |
 		(((regs->tstate + 1) & TSTATE_CWP) << TI_FLAG_CWP_SHIFT);
 	t->new_child = 1;
 	t->ksp = ((unsigned long) child_trap_frame) - STACK_BIAS;
-	t->kregs = (struct pt_regs *)(child_trap_frame+sizeof(struct sparc_stackf));
+	t->kregs = (struct pt_regs *) (child_trap_frame +
+				       sizeof(struct sparc_stackf));
 	t->fpsaved[0] = 0;
 
-	if (regs->tstate & TSTATE_PRIV) {
+	if (kernel_thread) {
+		struct sparc_stackf *child_sf = (struct sparc_stackf *)
+			(child_trap_frame + (STACKFRAME_SZ + TRACEREG_SZ));
+
+		/* Zero terminate the stack backtrace.  */
+		child_sf->fp = NULL;
+		t->kregs->u_regs[UREG_FP] =
+		  ((unsigned long) child_sf) - STACK_BIAS;
+
 		/* Special case, if we are spawning a kernel thread from
 		 * a userspace task (via KMOD, NFS, or similar) we must
 		 * disable performance counters in the child because the
@@ -681,12 +700,7 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 			t->pcr_reg = 0;
 			t->flags &= ~_TIF_PERFCTR;
 		}
-		t->kregs->u_regs[UREG_FP] = t->ksp;
 		t->flags |= ((long)ASI_P << TI_FLAG_CURRENT_DS_SHIFT);
-		flush_register_windows();
-		memcpy((void *)(t->ksp + STACK_BIAS),
-		       (void *)(regs->u_regs[UREG_FP] + STACK_BIAS),
-		       sizeof(struct sparc_stackf));
 		t->kregs->u_regs[UREG_G6] = (unsigned long) t;
 		t->kregs->u_regs[UREG_G4] = (unsigned long) t->task;
 	} else {
