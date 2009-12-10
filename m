Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbZLJAqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbZLJAqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759221AbZLJAqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:46:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:59229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759213AbZLJAqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:46:05 -0500
Date: Thu, 10 Dec 2009 00:45:45 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1260403316-5679-2-git-send-email-brgerst@gmail.com>
References: <1260403316-5679-2-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-32: Add new pt_regs stubs
Message-ID: <tip-e258e4e0b495e6ecbd073d6bef1eafb62a58919a@git.kernel.org>
Git-Commit-ID: e258e4e0b495e6ecbd073d6bef1eafb62a58919a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e258e4e0b495e6ecbd073d6bef1eafb62a58919a
Gitweb:     http://git.kernel.org/tip/e258e4e0b495e6ecbd073d6bef1eafb62a58919a
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Wed, 9 Dec 2009 19:01:51 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 9 Dec 2009 16:27:49 -0800

x86-32: Add new pt_regs stubs

Add new stubs which add the pt_regs pointer as the last arg, matching
64-bit.  This will allow these syscalls to be easily merged.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1260403316-5679-2-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
