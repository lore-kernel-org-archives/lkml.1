Return-Path: <linux-kernel-owner+w=401wt.eu-S1760844AbZB0VZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbZB0VZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbZB0VZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:25:41 -0500
Received: from gw.goop.org ([64.81.55.164]:39996 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469AbZB0VZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:25:40 -0500
Message-ID: <49A85A41.9000605@goop.org>
Date: Fri, 27 Feb 2009 13:25:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86-32: use non-lazy io bitmap context switching
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86-32 and -64 differ in the way they context-switch tasks
with io permission bitmaps.  x86-64 simply copies the next
tasks io bitmap into place (if any) on context switch.  x86-32
invalidates the bitmap on context switch, so that the next
IO instruction will fault; at that point it installs the
appropriate IO bitmap.

This makes context switching IO-bitmap-using tasks a bit more
less expensive, at the cost of making the next IO instruction
slower due to the extra fault.  This tradeoff only makes sense
if IO-bitmap-using processes are relatively common, but they
don't actually use IO instructions very often.

However, in a typical desktop system, the only process likely
to be using IO bitmaps is the X server, and nothing at all on
a server.  Therefore the lazy context switch doesn't really win
all that much, and its just a gratuitious difference from
64-bit code.

This patch removes the lazy context switch, with a view to
unifying this code in a later change.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c7a98f7..7613950 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -248,7 +248,6 @@ struct x86_hw_tss {
 #define IO_BITMAP_LONGS			(IO_BITMAP_BYTES/sizeof(long))
 #define IO_BITMAP_OFFSET		offsetof(struct tss_struct, io_bitmap)
 #define INVALID_IO_BITMAP_OFFSET	0x8000
-#define INVALID_IO_BITMAP_OFFSET_LAZY	0x9000
 
 struct tss_struct {
 	/*
@@ -263,11 +262,6 @@ struct tss_struct {
 	 * be within the limit.
 	 */
 	unsigned long		io_bitmap[IO_BITMAP_LONGS + 1];
-	/*
-	 * Cache the current maximum and the last task that used the bitmap:
-	 */
-	unsigned long		io_bitmap_max;
-	struct thread_struct	*io_bitmap_owner;
 
 	/*
 	 * .. and then another 0x100 bytes for the emergency kernel stack:
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index e41980a..99c4d30 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -85,19 +85,8 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 
 	t->io_bitmap_max = bytes;
 
-#ifdef CONFIG_X86_32
-	/*
-	 * Sets the lazy trigger so that the next I/O operation will
-	 * reload the correct bitmap.
-	 * Reset the owner so that a process switch will not set
-	 * tss->io_bitmap_base to IO_BITMAP_OFFSET.
-	 */
-	tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET_LAZY;
-	tss->io_bitmap_owner = NULL;
-#else
 	/* Update the TSS: */
 	memcpy(tss->io_bitmap, t->io_bitmap_ptr, bytes_updated);
-#endif
 
 	put_cpu();
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 31ec4e8..01ff913 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -246,11 +246,8 @@ void exit_thread(void)
 		/*
 		 * Careful, clear this in the TSS too:
 		 */
-		memset(tss->io_bitmap, 0xff, tss->io_bitmap_max);
+		memset(tss->io_bitmap, 0xff, t->io_bitmap_max);
 		t->io_bitmap_max = 0;
-		tss->io_bitmap_owner = NULL;
-		tss->io_bitmap_max = 0;
-		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
 		put_cpu();
 	}
 
@@ -456,34 +453,19 @@ __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 			hard_enable_TSC();
 	}
 
-	if (!test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
+	if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
 		/*
-		 * Disable the bitmap via an invalid offset. We still cache
-		 * the previous bitmap owner and the IO bitmap contents:
+		 * Copy the relevant range of the IO bitmap.
+		 * Normally this is 128 bytes or less:
 		 */
-		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
-		return;
-	}
-
-	if (likely(next == tss->io_bitmap_owner)) {
+		memcpy(tss->io_bitmap, next->io_bitmap_ptr,
+		       max(prev->io_bitmap_max, next->io_bitmap_max));
+	} else if (test_tsk_thread_flag(prev_p, TIF_IO_BITMAP)) {
 		/*
-		 * Previous owner of the bitmap (hence the bitmap content)
-		 * matches the next task, we dont have to do anything but
-		 * to set a valid offset in the TSS:
+		 * Clear any possible leftover bits:
 		 */
-		tss->x86_tss.io_bitmap_base = IO_BITMAP_OFFSET;
-		return;
+		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
 	}
-	/*
-	 * Lazy TSS's I/O bitmap copy. We set an invalid offset here
-	 * and we let the task to get a GPF in case an I/O instruction
-	 * is performed.  The handler of the GPF will verify that the
-	 * faulting task has a valid I/O bitmap and, it true, does the
-	 * real copy and restart the instruction.  This will save us
-	 * redundant copies when the currently switched task does not
-	 * perform any I/O during its timeslice.
-	 */
-	tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET_LAZY;
 }
 
 /*
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 3d05abf..e447aa8 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -119,47 +119,6 @@ die_if_kernel(const char *str, struct pt_regs *regs, long err)
 	if (!user_mode_vm(regs))
 		die(str, regs, err);
 }
-
-/*
- * Perform the lazy TSS's I/O bitmap copy. If the TSS has an
- * invalid offset set (the LAZY one) and the faulting thread has
- * a valid I/O bitmap pointer, we copy the I/O bitmap in the TSS,
- * we set the offset field correctly and return 1.
- */
-static int lazy_iobitmap_copy(void)
-{
-	struct thread_struct *thread;
-	struct tss_struct *tss;
-	int cpu;
-
-	cpu = get_cpu();
-	tss = &per_cpu(init_tss, cpu);
-	thread = &current->thread;
-
-	if (tss->x86_tss.io_bitmap_base == INVALID_IO_BITMAP_OFFSET_LAZY &&
-	    thread->io_bitmap_ptr) {
-		memcpy(tss->io_bitmap, thread->io_bitmap_ptr,
-		       thread->io_bitmap_max);
-		/*
-		 * If the previously set map was extending to higher ports
-		 * than the current one, pad extra space with 0xff (no access).
-		 */
-		if (thread->io_bitmap_max < tss->io_bitmap_max) {
-			memset((char *) tss->io_bitmap +
-				thread->io_bitmap_max, 0xff,
-				tss->io_bitmap_max - thread->io_bitmap_max);
-		}
-		tss->io_bitmap_max = thread->io_bitmap_max;
-		tss->x86_tss.io_bitmap_base = IO_BITMAP_OFFSET;
-		tss->io_bitmap_owner = thread;
-		put_cpu();
-
-		return 1;
-	}
-	put_cpu();
-
-	return 0;
-}
 #endif
 
 static void __kprobes
@@ -310,11 +269,6 @@ do_general_protection(struct pt_regs *regs, long error_code)
 	conditional_sti(regs);
 
 #ifdef CONFIG_X86_32
-	if (lazy_iobitmap_copy()) {
-		/* restart the faulting instruction */
-		return;
-	}
-
 	if (regs->flags & X86_VM_MASK)
 		goto gp_in_vm86;
 #endif


