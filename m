Return-Path: <linux-kernel-owner+w=401wt.eu-S1762100AbZLKAqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762100AbZLKAqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762092AbZLKAqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:46:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:44585 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762082AbZLKAqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:46:07 -0500
Date: Fri, 11 Dec 2009 00:46:05 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1260380084-3707-4-git-send-email-brgerst@gmail.com>
References: <1260380084-3707-4-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, 32-bit: Use same regs as 64-bit for kernel_thread_helper
Message-ID: <tip-e840227c141116171c89ab1abb5cc9fee6fdb488@git.kernel.org>
Git-Commit-ID: e840227c141116171c89ab1abb5cc9fee6fdb488
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e840227c141116171c89ab1abb5cc9fee6fdb488
Gitweb:     http://git.kernel.org/tip/e840227c141116171c89ab1abb5cc9fee6fdb488
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Wed, 9 Dec 2009 12:34:42 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 10 Dec 2009 15:55:36 -0800

x86, 32-bit: Use same regs as 64-bit for kernel_thread_helper

The arg should be in %eax, but that is clobbered by the return value
of clone.  The function pointer can be in any register.  Also, don't
push args onto the stack, since regparm(3) is the normal calling
convention now.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1260380084-3707-4-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/entry_32.S   |    8 ++------
 arch/x86/kernel/process_32.c |    8 ++++----
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index cb12b9b..44a8e0d 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1047,12 +1047,8 @@ END(spurious_interrupt_bug)
 ENTRY(kernel_thread_helper)
 	pushl $0		# fake return address for unwinder
 	CFI_STARTPROC
-	movl %edx,%eax
-	push %edx
-	CFI_ADJUST_CFA_OFFSET 4
-	call *%ebx
-	push %eax
-	CFI_ADJUST_CFA_OFFSET 4
+	movl %edi,%eax
+	call *%esi
 	call do_exit
 	ud2			# padding for call trace
 	CFI_ENDPROC
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 506d5a7..bd874d2 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -193,8 +193,8 @@ void show_regs(struct pt_regs *regs)
 }
 
 /*
- * This gets run with %bx containing the
- * function to call, and %dx containing
+ * This gets run with %si containing the
+ * function to call, and %di containing
  * the "args".
  */
 extern void kernel_thread_helper(void);
@@ -208,8 +208,8 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 
 	memset(&regs, 0, sizeof(regs));
 
-	regs.bx = (unsigned long) fn;
-	regs.dx = (unsigned long) arg;
+	regs.si = (unsigned long) fn;
+	regs.di = (unsigned long) arg;
 
 	regs.ds = __USER_DS;
 	regs.es = __USER_DS;
