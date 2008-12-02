Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYLBVwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYLBVwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYLBVwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:52:14 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:50430 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYLBVwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:52:09 -0500
Date: Tue, 02 Dec 2008 16:51:55 -0500
From: Jody McIntyre <scjody@sun.com>
Subject: [PATCH] Fix compile error in arch/x86/kernel/syscall_64.c
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, mingo@redhat.com
Message-id: <20081202215154.GL29919@clouds>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1965aae3c98397aad957412413c07e97b1bd4e64 broke compilation on one of my
systems:

  CC      arch/x86/kernel/syscall_64.o
arch/x86/kernel/syscall_64.c:27: error: array index in initializer exceeds array bounds
arch/x86/kernel/syscall_64.c:27: error: (near initialization for ‘sys_call_table’)
arch/x86/kernel/syscall_64.c:27: warning: excess elements in array initializer
arch/x86/kernel/syscall_64.c:27: warning: (near initialization for ‘sys_call_table’)
make[1]: *** [arch/x86/kernel/syscall_64.o] Error 1
make: *** [arch/x86/kernel/syscall_64.o] Error 2

Reverting only the parts of the commit that change ASM_X86__UNISTD_64_H
to _ASM_X86_UNISTD_64_H fixes the problem.  Patch below.

I have no idea what's going on here.  Compiler bug?

root@vm1:~/linux-2.6# gcc --version
gcc (Ubuntu 4.3.2-1ubuntu11) 4.3.2

Signed-off-by: Jody McIntyre <scjody@sun.com>
---
 arch/um/sys-x86_64/syscall_table.c |    4 ++--
 arch/x86/include/asm/unistd_64.h   |    6 +++---
 arch/x86/kernel/asm-offsets_64.c   |    2 +-
 arch/x86/kernel/syscall_64.c       |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)
diff --git a/arch/um/sys-x86_64/syscall_table.c b/arch/um/sys-x86_64/syscall_table.c
index dd21d69..ef42ec0 100644
--- a/arch/um/sys-x86_64/syscall_table.c
+++ b/arch/um/sys-x86_64/syscall_table.c
@@ -41,12 +41,12 @@
 #define stub_rt_sigreturn sys_rt_sigreturn
 
 #define __SYSCALL(nr, sym) extern asmlinkage void sym(void) ;
-#undef _ASM_X86_UNISTD_64_H
+#undef ASM_X86__UNISTD_64_H
 #include "../../x86/include/asm/unistd_64.h"
 
 #undef __SYSCALL
 #define __SYSCALL(nr, sym) [ nr ] = sym,
-#undef _ASM_X86_UNISTD_64_H
+#undef ASM_X86__UNISTD_64_H
 
 typedef void (*sys_call_ptr_t)(void);
 
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index d2e415e..26a7432 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_X86_UNISTD_64_H
-#define _ASM_X86_UNISTD_64_H
+#ifndef ASM_X86__UNISTD_64_H
+#define ASM_X86__UNISTD_64_H
 
 #ifndef __SYSCALL
 #define __SYSCALL(a, b)
@@ -690,4 +690,4 @@ __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
 #define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
 #endif	/* __KERNEL__ */
 
-#endif /* _ASM_X86_UNISTD_64_H */
+#endif /* ASM_X86__UNISTD_64_H */
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 7fcf63d..505543a 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -22,7 +22,7 @@
 
 #define __NO_STUBS 1
 #undef __SYSCALL
-#undef _ASM_X86_UNISTD_64_H
+#undef ASM_X86__UNISTD_64_H
 #define __SYSCALL(nr, sym) [nr] = 1,
 static char syscalls[] = {
 #include <asm/unistd.h>
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index de87d60..3d1be4f 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -8,12 +8,12 @@
 #define __NO_STUBS
 
 #define __SYSCALL(nr, sym) extern asmlinkage void sym(void) ;
-#undef _ASM_X86_UNISTD_64_H
+#undef ASM_X86__UNISTD_64_H
 #include <asm/unistd_64.h>
 
 #undef __SYSCALL
 #define __SYSCALL(nr, sym) [nr] = sym,
-#undef _ASM_X86_UNISTD_64_H
+#undef ASM_X86__UNISTD_64_H
 
 typedef void (*sys_call_ptr_t)(void);
 
