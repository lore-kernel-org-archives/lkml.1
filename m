Return-Path: <linux-kernel-owner+w=401wt.eu-S1763989AbZCYSob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763989AbZCYSob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZCYSoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:44:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:55478 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbZCYSoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:44:20 -0400
Subject: [PATCH -tip] x86: signal.c cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 00:13:37 +0530
Message-Id: <1238006617.2500.57.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Thu, 26 Mar 2009 00:11:46 +0530
Subject: [PATCH] x86: signal.c cleanup

Impact: cleanup

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/signal.c |   46 +++++++++++++++++++---------------------------
 1 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 62f2164..249b7bc 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -7,35 +7,30 @@
  *  2000-2002   x86-64 support by Andi Kleen
  */
 #include <linux/perf_counter.h>
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
+#include <linux/personality.h>
+#include <linux/tracehook.h>
+#include <linux/uaccess.h>
 #include <linux/kernel.h>
+#include <linux/ptrace.h>
 #include <linux/signal.h>
+#include <linux/stddef.h>
+#include <linux/unistd.h>
 #include <linux/errno.h>
+#include <linux/sched.h>
 #include <linux/wait.h>
-#include <linux/ptrace.h>
-#include <linux/tracehook.h>
-#include <linux/unistd.h>
-#include <linux/stddef.h>
-#include <linux/personality.h>
-#include <linux/uaccess.h>
+#include <linux/smp.h>
+#include <linux/mm.h>
 
+#include <asm/ia32_unistd.h>
 #include <asm/processor.h>
+#include <asm/sigframe.h>
+#include <asm/syscalls.h>
 #include <asm/ucontext.h>
+#include <asm/syscall.h>
+#include <asm/proto.h>
 #include <asm/i387.h>
 #include <asm/vdso.h>
-
-#ifdef CONFIG_X86_64
-#include <asm/proto.h>
-#include <asm/ia32_unistd.h>
 #include <asm/mce.h>
-#endif /* CONFIG_X86_64 */
-
-#include <asm/syscall.h>
-#include <asm/syscalls.h>
-
-#include <asm/sigframe.h>
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
@@ -100,17 +95,14 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 		COPY(r13);
 		COPY(r14);
 		COPY(r15);
-#endif /* CONFIG_X86_64 */
-
-#ifdef CONFIG_X86_32
-		COPY_SEG_CPL3(cs);
-		COPY_SEG_CPL3(ss);
-#else /* !CONFIG_X86_32 */
 		/* Kernel saves and restores only the CS segment register on signals,
 		 * which is the bare minimum needed to allow mixed 32/64-bit code.
 		 * App's signal handler can save/restore other segments if needed. */
 		COPY_SEG_CPL3(cs);
-#endif /* CONFIG_X86_32 */
+#else
+		COPY_SEG_CPL3(cs);
+		COPY_SEG_CPL3(ss);
+#endif
 
 		get_user_ex(tmpflags, &sc->flags);
 		regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
@@ -887,7 +879,7 @@ void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
 	struct task_struct *me = current;
 
 	if (show_unhandled_signals && printk_ratelimit()) {
-		printk("%s"
+		printk(KERN_INFO "%s"
 		       "%s[%d] bad frame in %s frame:%p ip:%lx sp:%lx orax:%lx",
 		       task_pid_nr(current) > 1 ? KERN_INFO : KERN_EMERG,
 		       me->comm, me->pid, where, frame,
-- 
1.6.0.6



