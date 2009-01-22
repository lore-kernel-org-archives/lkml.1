Return-Path: <linux-kernel-owner+w=401wt.eu-S1752320AbZAVP3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbZAVP3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 10:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbZAVP3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 10:29:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:39265 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbZAVP3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 10:29:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RNvbvx6LYZxQa5s42aBkGh8pB87wZNZP2M8yhCAnholADcWo6YF/0sJfo3KrlAkFx4
         BM1nWlXTf29XTn1IORkjG9Z8XWhddY0rdzC5D/oYU1oflrUiC6J1sc4prllwRmL97Vvz
         aNJ0/rpeuQNmGdeq9fFlTzlC6B7gsGkvzrLoU=
Message-ID: <497890C2.1040206@gmail.com>
Date: Thu, 22 Jan 2009 16:29:06 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>
CC: uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] x86, um: fix EXECUTE_SYSCALL macros
References: <49773C2E.9090608@gmail.com>
In-Reply-To: <49773C2E.9090608@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> When these macros aren't called with regs, e.g. with foo
> this will incorectly expand to foo->foo.gp[*]
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> My other patch should probably as well have been sent to this list:
> http://lkml.org/lkml/2009/1/21/203
> 
there were more

Fix EXECUTE_SYSCALL macros. When called with a variable named other
than regs as second argument, this will result in a build failure.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/um/sys-i386/shared/sysdep/syscalls.h b/arch/um/sys-i386/shared/sysdep/syscalls.h
index 9056981..1cab192 100644
--- a/arch/um/sys-i386/shared/sysdep/syscalls.h
+++ b/arch/um/sys-i386/shared/sysdep/syscalls.h
@@ -17,9 +17,9 @@ extern syscall_handler_t old_mmap_i386;
 
 extern syscall_handler_t *sys_call_table[];
 
-#define EXECUTE_SYSCALL(syscall, regs) \
+#define EXECUTE_SYSCALL(syscall, _regs) \
 	((long (*)(struct syscall_args)) \
-	 (*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
+	 (*sys_call_table[syscall]))(SYSCALL_ARGS(&_regs->regs))
 
 extern long sys_mmap2(unsigned long addr, unsigned long len,
 		      unsigned long prot, unsigned long flags,
diff --git a/arch/um/sys-x86_64/shared/sysdep/syscalls.h b/arch/um/sys-x86_64/shared/sysdep/syscalls.h
index 7cfb0b0..a5be219 100644
--- a/arch/um/sys-x86_64/shared/sysdep/syscalls.h
+++ b/arch/um/sys-x86_64/shared/sysdep/syscalls.h
@@ -15,14 +15,14 @@ typedef long syscall_handler_t(void);
 
 extern syscall_handler_t *sys_call_table[];
 
-#define EXECUTE_SYSCALL(syscall, regs) \
+#define EXECUTE_SYSCALL(syscall, _regs) \
 	(((long (*)(long, long, long, long, long, long)) \
-	  (*sys_call_table[syscall]))(UPT_SYSCALL_ARG1(&regs->regs), \
-		 		      UPT_SYSCALL_ARG2(&regs->regs), \
-				      UPT_SYSCALL_ARG3(&regs->regs), \
-				      UPT_SYSCALL_ARG4(&regs->regs), \
-				      UPT_SYSCALL_ARG5(&regs->regs), \
-				      UPT_SYSCALL_ARG6(&regs->regs)))
+	  (*sys_call_table[syscall]))(UPT_SYSCALL_ARG1(&_regs->regs), \
+		 		      UPT_SYSCALL_ARG2(&_regs->regs), \
+				      UPT_SYSCALL_ARG3(&_regs->regs), \
+				      UPT_SYSCALL_ARG4(&_regs->regs), \
+				      UPT_SYSCALL_ARG5(&_regs->regs), \
+				      UPT_SYSCALL_ARG6(&_regs->regs)))
 
 extern long old_mmap(unsigned long addr, unsigned long len,
 		     unsigned long prot, unsigned long flags,

