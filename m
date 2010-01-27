Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138Ab0A0Ij7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab0A0Ij7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919Ab0A0Ij6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:39:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:38333 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab0A0Ij5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:39:57 -0500
Date: Wed, 27 Jan 2010 08:39:34 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1264434453-2204-1-git-send-email-brgerst@gmail.com>
References: <1264434453-2204-1-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Use normal ptregs stub for execve
Message-ID: <tip-f19a25c872b20ae4357f72687cf3e7b0da220ee2@git.kernel.org>
Git-Commit-ID: f19a25c872b20ae4357f72687cf3e7b0da220ee2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jan 2010 08:39:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f19a25c872b20ae4357f72687cf3e7b0da220ee2
Gitweb:     http://git.kernel.org/tip/f19a25c872b20ae4357f72687cf3e7b0da220ee2
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Mon, 25 Jan 2010 10:47:33 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 26 Jan 2010 23:38:14 -0800

x86-64: Use normal ptregs stub for execve

Execve historically passed regs by value, so it had a seperate stub.
This is no longer true, so change it to use a normal PTREGSCALL stub.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1264434453-2204-1-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/entry_64.S |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 0697ff1..0c31502 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -696,6 +696,7 @@ END(\label)
 	PTREGSCALL stub_clone, sys_clone, %r8
 	PTREGSCALL stub_fork, sys_fork, %rdi
 	PTREGSCALL stub_vfork, sys_vfork, %rdi
+	PTREGSCALL stub_execve, sys_execve, %rcx
 	PTREGSCALL stub_sigaltstack, sys_sigaltstack, %rdx
 	PTREGSCALL stub_iopl, sys_iopl, %rsi
 
@@ -712,22 +713,6 @@ ENTRY(ptregscall_common)
 	CFI_ENDPROC
 END(ptregscall_common)
 
-ENTRY(stub_execve)
-	CFI_STARTPROC
-	popq %r11
-	CFI_ADJUST_CFA_OFFSET -8
-	CFI_REGISTER rip, r11
-	SAVE_REST
-	FIXUP_TOP_OF_STACK %r11
-	movq %rsp, %rcx
-	call sys_execve
-	RESTORE_TOP_OF_STACK %r11
-	movq %rax,RAX(%rsp)
-	RESTORE_REST
-	jmp int_ret_from_sys_call
-	CFI_ENDPROC
-END(stub_execve)
-
 /*
  * sigreturn is special because it needs to restore all registers on return.
  * This cannot be done with SYSRET, so use the IRET return path instead.
