Return-Path: <linux-kernel-owner+w=401wt.eu-S932219AbZJLOSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbZJLOSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756662AbZJLOSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:18:48 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:57030 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbZJLOSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NV6y/vslIlsAkGNzykKxnHnaRI5cS58zyEv8bz1iHRVUzT+PThVxEf0Hi5RIXvRjwE
         rjAw6H3tbxFuoMBCCPEqoQzLiNr3zq+p/+Lmdd3QWuRIy9uqAxM37mzna0kU/ns5RsnA
         3KZKMpUJ8nRChiCLpPfQWFIEhVjsP2/kygzjQ=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86-64: Move K8 B step iret fixup to fault entry asm.
Date: Mon, 12 Oct 2009 10:18:23 -0400
Message-Id: <1255357103-5418-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the handling of truncated %rip from an iret fault to the fault
entry path.  This allows x86-64 to use the standard search_extable
function.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
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
-- 
1.6.2.5

