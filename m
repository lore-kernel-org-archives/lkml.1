Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbZLJAqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbZLJAqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759227AbZLJAqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:46:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:59238 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759244AbZLJAqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:46:18 -0500
Date: Thu, 10 Dec 2009 00:45:59 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1260403316-5679-3-git-send-email-brgerst@gmail.com>
References: <1260403316-5679-3-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Merge sys_iopl
Message-ID: <tip-27f59559d63375a4d59e7c720a439d9f0b47edad@git.kernel.org>
Git-Commit-ID: 27f59559d63375a4d59e7c720a439d9f0b47edad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27f59559d63375a4d59e7c720a439d9f0b47edad
Gitweb:     http://git.kernel.org/tip/27f59559d63375a4d59e7c720a439d9f0b47edad
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Wed, 9 Dec 2009 19:01:52 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 9 Dec 2009 16:28:10 -0800

x86: Merge sys_iopl

Change 32-bit sys_iopl to PTREGSCALL1, and merge with 64-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1260403316-5679-3-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/syscalls.h |    6 +-----
 arch/x86/kernel/entry_32.S      |    2 +-
 arch/x86/kernel/ioport.c        |   28 +++++-----------------------
 3 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 372b76e..4b694cd 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -18,6 +18,7 @@
 /* Common in X86_32 and X86_64 */
 /* kernel/ioport.c */
 asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
+long sys_iopl(unsigned int, struct pt_regs *);
 
 /* kernel/process.c */
 int sys_fork(struct pt_regs *);
@@ -35,8 +36,6 @@ asmlinkage int sys_get_thread_area(struct user_desc __user *);
 
 /* X86_32 only */
 #ifdef CONFIG_X86_32
-/* kernel/ioport.c */
-long sys_iopl(struct pt_regs *);
 
 /* kernel/process_32.c */
 int sys_clone(struct pt_regs *);
@@ -70,9 +69,6 @@ int sys_vm86(struct pt_regs *);
 #else /* CONFIG_X86_32 */
 
 /* X86_64 only */
-/* kernel/ioport.c */
-asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
-
 /* kernel/process_64.c */
 asmlinkage long sys_clone(unsigned long, unsigned long,
 			  void __user *, void __user *,
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 34dbfa9..ab7fcef 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -758,7 +758,7 @@ ptregs_##name: \
 	addl $4,%esp; \
 	ret
 
-PTREGSCALL0(iopl)
+PTREGSCALL1(iopl)
 PTREGSCALL0(fork)
 PTREGSCALL0(clone)
 PTREGSCALL0(vfork)
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 99c4d30..85ecc7c 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -103,9 +103,10 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
  * on system-call entry - see also fork() and the signal handling
  * code.
  */
-static int do_iopl(unsigned int level, struct pt_regs *regs)
+long sys_iopl(unsigned int level, struct pt_regs *regs)
 {
 	unsigned int old = (regs->flags >> 12) & 3;
+	struct thread_struct *t = &current->thread;
 
 	if (level > 3)
 		return -EINVAL;
@@ -115,29 +116,10 @@ static int do_iopl(unsigned int level, struct pt_regs *regs)
 			return -EPERM;
 	}
 	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | (level << 12);
-
-	return 0;
-}
-
 #ifdef CONFIG_X86_32
-long sys_iopl(struct pt_regs *regs)
-{
-	unsigned int level = regs->bx;
-	struct thread_struct *t = &current->thread;
-	int rc;
-
-	rc = do_iopl(level, regs);
-	if (rc < 0)
-		goto out;
-
 	t->iopl = level << 12;
 	set_iopl_mask(t->iopl);
-out:
-	return rc;
-}
-#else
-asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs)
-{
-	return do_iopl(level, regs);
-}
 #endif
+
+	return 0;
+}
