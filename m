Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYI3QrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYI3QrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYI3QrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:47:11 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:22857 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbYI3QrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:47:10 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 2/4] traps: i386: factor out lazy io-bitmap copy
Date: Tue, 30 Sep 2008 18:41:35 +0200
Message-Id: <1222792897-5691-3-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1222792897-5691-2-git-send-email-heukelum@fastmail.fm>
References: <1222792897-5691-1-git-send-email-heukelum@fastmail.fm>
 <1222792897-5691-2-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Tue, 30 Sep 2008 18:46:51 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.231; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 does not do the lazy io-bitmap dance. Putting it in
its own function makes i386's do_general_protection look
much more like x86_64's.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |   76 +++++++++++++++++++++++++-------------------
 1 files changed, 43 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index dd183a2..78113d3 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -96,6 +96,47 @@ die_if_kernel(const char *str, struct pt_regs *regs, long err)
 		die(str, regs, err);
 }
 
+/*
+ * Perform the lazy TSS's I/O bitmap copy. If the TSS has an
+ * invalid offset set (the LAZY one) and the faulting thread has
+ * a valid I/O bitmap pointer, we copy the I/O bitmap in the TSS,
+ * we set the offset field correctly and return 1.
+ */
+static int lazy_iobitmap_copy(void)
+{
+	struct thread_struct *thread;
+	struct tss_struct *tss;
+	int cpu;
+
+	cpu = get_cpu();
+	tss = &per_cpu(init_tss, cpu);
+	thread = &current->thread;
+
+	if (tss->x86_tss.io_bitmap_base == INVALID_IO_BITMAP_OFFSET_LAZY &&
+	    thread->io_bitmap_ptr) {
+		memcpy(tss->io_bitmap, thread->io_bitmap_ptr,
+		       thread->io_bitmap_max);
+		/*
+		 * If the previously set map was extending to higher ports
+		 * than the current one, pad extra space with 0xff (no access).
+		 */
+		if (thread->io_bitmap_max < tss->io_bitmap_max) {
+			memset((char *) tss->io_bitmap +
+				thread->io_bitmap_max, 0xff,
+				tss->io_bitmap_max - thread->io_bitmap_max);
+		}
+		tss->io_bitmap_max = thread->io_bitmap_max;
+		tss->x86_tss.io_bitmap_base = IO_BITMAP_OFFSET;
+		tss->io_bitmap_owner = thread;
+		put_cpu();
+
+		return 1;
+	}
+	put_cpu();
+
+	return 0;
+}
+
 static void __kprobes
 do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	long error_code, siginfo_t *info)
@@ -188,44 +229,13 @@ void __kprobes
 do_general_protection(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk;
-	struct thread_struct *thread;
-	struct tss_struct *tss;
-	int cpu;
 
 	conditional_sti(regs);
 
-	cpu = get_cpu();
-	tss = &per_cpu(init_tss, cpu);
-	thread = &current->thread;
-
-	/*
-	 * Perform the lazy TSS's I/O bitmap copy. If the TSS has an
-	 * invalid offset set (the LAZY one) and the faulting thread has
-	 * a valid I/O bitmap pointer, we copy the I/O bitmap in the TSS
-	 * and we set the offset field correctly. Then we let the CPU to
-	 * restart the faulting instruction.
-	 */
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
+	if (lazy_iobitmap_copy()) {
+		/* restart the faulting instruction */
 		return;
 	}
-	put_cpu();
 
 	if (regs->flags & X86_VM_MASK)
 		goto gp_in_vm86;
-- 
1.5.4.3

