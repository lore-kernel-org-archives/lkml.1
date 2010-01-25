Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869Ab0AYPxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0AYPxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 10:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183Ab0AYPxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 10:53:06 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:40281 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab0AYPxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 10:53:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=p8ePHMVGBjF7ydqxgPt5XH65/itmBOPTNRq//yr0PLwK3HV5VTYmsOxGeoEjUdWLD+
         jpiyOXL2B0Cxa4DaA4/W1HmBF7b13qOPlZDj5CcvS3/WD+hBWEqJ21qDbcB8RqD9Q7OS
         edIApelFRBtuYdB+8C5aMqdJfWQR03/DXTADM=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86-64: Use normal ptregs stub for execve
Date: Mon, 25 Jan 2010 10:47:33 -0500
Message-Id: <1264434453-2204-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Execve historically passed regs by value, so it had a seperate stub.
This is no longer true, so change it to use a normal PTREGSCALL stub.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
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
-- 
1.6.6

