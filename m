Return-Path: <linux-kernel-owner+w=401wt.eu-S932784AbZJLQiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784AbZJLQiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932369AbZJLQiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:38:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:54329 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305AbZJLQh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:37:59 -0400
Date: Mon, 12 Oct 2009 16:36:47 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, torvalds@linux-foundation.org, brgerst@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, torvalds@linux-foundation.org, jbeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1255357103-5418-1-git-send-email-brgerst@gmail.com>
References: <1255357103-5418-1-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, 64-bit: Move K8 B step iret fixup to fault entry asm
Message-ID: <tip-ae24ffe5ecec17c956ac25371d7c2e12b4b36e53@git.kernel.org>
Git-Commit-ID: ae24ffe5ecec17c956ac25371d7c2e12b4b36e53
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 16:36:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae24ffe5ecec17c956ac25371d7c2e12b4b36e53
Gitweb:     http://git.kernel.org/tip/ae24ffe5ecec17c956ac25371d7c2e12b4b36e53
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Mon, 12 Oct 2009 10:18:23 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Oct 2009 18:29:46 +0200

x86, 64-bit: Move K8 B step iret fixup to fault entry asm

Move the handling of truncated %rip from an iret fault to the fault
entry path.

This allows x86-64 to use the standard search_extable() function.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <1255357103-5418-1-git-send-email-brgerst@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uaccess.h |    1 -
 arch/x86/kernel/entry_64.S     |   11 ++++++++---
 arch/x86/mm/extable.c          |   31 -------------------------------
 3 files changed, 8 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index d2c6c93..abd3e0e 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -570,7 +570,6 @@ extern struct movsl_mask {
 #ifdef CONFIG_X86_32
 # include "uaccess_32.h"
 #else
-# define ARCH_HAS_SEARCH_EXTABLE
 # include "uaccess_64.h"
 #endif
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b5c061f..af0f4b2 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1491,12 +1491,17 @@ error_kernelspace:
 	leaq irq_return(%rip),%rcx
 	cmpq %rcx,RIP+8(%rsp)
 	je error_swapgs
-	movl %ecx,%ecx	/* zero extend */
-	cmpq %rcx,RIP+8(%rsp)
-	je error_swapgs
+	movl %ecx,%eax	/* zero extend */
+	cmpq %rax,RIP+8(%rsp)
+	je bstep_iret
 	cmpq $gs_change,RIP+8(%rsp)
 	je error_swapgs
 	jmp error_sti
+
+bstep_iret:
+	/* Fix truncated RIP */
+	movq %rcx,RIP+8(%rsp)
+	je error_swapgs
 END(error_entry)
 
 
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 61b41ca..d0474ad 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -35,34 +35,3 @@ int fixup_exception(struct pt_regs *regs)
 
 	return 0;
 }
-
-#ifdef CONFIG_X86_64
-/*
- * Need to defined our own search_extable on X86_64 to work around
- * a B stepping K8 bug.
- */
-const struct exception_table_entry *
-search_extable(const struct exception_table_entry *first,
-	       const struct exception_table_entry *last,
-	       unsigned long value)
-{
-	/* B stepping K8 bug */
-	if ((value >> 32) == 0)
-		value |= 0xffffffffUL << 32;
-
-	while (first <= last) {
-		const struct exception_table_entry *mid;
-		long diff;
-
-		mid = (last - first) / 2 + first;
-		diff = mid->insn - value;
-		if (diff == 0)
-			return mid;
-		else if (diff < 0)
-			first = mid+1;
-		else
-			last = mid-1;
-	}
-	return NULL;
-}
-#endif
