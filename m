Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbZLJABe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbZLJABe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758925AbZLJABc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:01:32 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55764 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758813AbZLJAB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:01:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ib6KExSeTCrtR05CT5Hh0RZXQJB3pKS7Anze6Gk1qRpdReAfPfG+lHrbbTxrerxogL
         NH7YkYT2ODEPtwXIJuWEXcKtehifhPDyBsIQhvtDf+EJtfadNqwfLDsLhQ+miVKtK2fq
         8lAdq+iXkJeDH8g6FeAs8TJSdKZPUgxG9okCg=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, torvalds@linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] x86, 32-bit: Add new pt_regs stubs
Date: Wed,  9 Dec 2009 19:01:51 -0500
Message-Id: <1260403316-5679-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1260403316-5679-1-git-send-email-brgerst@gmail.com>
References: <1260403316-5679-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new stubs which add the pt_regs pointer as the last arg, matching
64-bit.  This will allow these syscalls to be easily merged.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/entry_32.S |   49 ++++++++++++++++++++++++++++++++++---------
 1 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 50b9c22..34dbfa9 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -725,22 +725,49 @@ END(syscall_badsys)
 /*
  * System calls that need a pt_regs pointer.
  */
-#define PTREGSCALL(name) \
+#define PTREGSCALL0(name) \
 	ALIGN; \
 ptregs_##name: \
 	leal 4(%esp),%eax; \
 	jmp sys_##name;
 
-PTREGSCALL(iopl)
-PTREGSCALL(fork)
-PTREGSCALL(clone)
-PTREGSCALL(vfork)
-PTREGSCALL(execve)
-PTREGSCALL(sigaltstack)
-PTREGSCALL(sigreturn)
-PTREGSCALL(rt_sigreturn)
-PTREGSCALL(vm86)
-PTREGSCALL(vm86old)
+#define PTREGSCALL1(name) \
+	ALIGN; \
+ptregs_##name: \
+	leal 4(%esp),%edx; \
+	movl PT_EBX(%edx),%eax; \
+	jmp sys_##name;
+
+#define PTREGSCALL2(name) \
+	ALIGN; \
+ptregs_##name: \
+	leal 4(%esp),%ecx; \
+	movl PT_ECX(%ecx),%edx; \
+	movl PT_EBX(%ecx),%eax; \
+	jmp sys_##name;
+
+#define PTREGSCALL3(name) \
+	ALIGN; \
+ptregs_##name: \
+	leal 4(%esp),%eax; \
+	pushl %eax; \
+	movl PT_EDX(%eax),%ecx; \
+	movl PT_ECX(%eax),%edx; \
+	movl PT_EBX(%eax),%eax; \
+	call sys_##name; \
+	addl $4,%esp; \
+	ret
+
+PTREGSCALL0(iopl)
+PTREGSCALL0(fork)
+PTREGSCALL0(clone)
+PTREGSCALL0(vfork)
+PTREGSCALL0(execve)
+PTREGSCALL0(sigaltstack)
+PTREGSCALL0(sigreturn)
+PTREGSCALL0(rt_sigreturn)
+PTREGSCALL0(vm86)
+PTREGSCALL0(vm86old)
 
 .macro FIXUP_ESPFIX_STACK
 /*
-- 
1.6.5.2

