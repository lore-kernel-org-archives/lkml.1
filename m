Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbXGGVLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbXGGVLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 17:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbXGGVKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 17:10:55 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53831 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755234AbXGGVKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 17:10:54 -0400
Date: Sat, 7 Jul 2007 23:11:24 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Arnd Bergmann <arnd@arndb.de>, Miles Bader <miles@gnu.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] re-add required code to include/asm-v850/unistd.h
Message-ID: <20070707211124.GN3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f5738ceed46782aea7663d62cb6398eb05fc4ce0 removed a bit too much, 
resulting in the following compile error:

<--  snip  -->

...
  CC      arch/v850/kernel/process.o
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c: In function 'kernel_thread':
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c:77: error: syntax error before 'SYSCALL_NUM'
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c:78: error: syntax error before 'SYSCALL_ARG0'
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c:79: error: syntax error before 'SYSCALL_RET'
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c:86: error: 'arg0' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c:86: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c:86: error: for each function it appears in.)
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c:87: error: 'syscall' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c:88: error: syntax error before 'SYSCALL_SHORT_TRAP'
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c:93: error: 'ret' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c:97: error: syntax error before 'SYSCALL_SHORT_TRAP'
make[2]: *** [arch/v850/kernel/process.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 include/asm-v850/unistd.h |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- linux-2.6.22-rc6-mm1/include/asm-v850/unistd.h.old	2007-07-07 22:30:01.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-v850/unistd.h	2007-07-07 22:31:55.000000000 +0200
@@ -206,6 +206,36 @@
 
 #ifdef __KERNEL__
 
+/* Syscall protocol:
+   Syscall number in r12, args in r6-r9, r13-r14
+   Return value in r10
+   Trap 0 for `short' syscalls, where all the args can fit in function
+   call argument registers, and trap 1 when there are additional args in
+   r13-r14.  */
+
+#define SYSCALL_NUM    "r12"
+#define SYSCALL_ARG0   "r6"
+#define SYSCALL_ARG1   "r7"
+#define SYSCALL_ARG2   "r8"
+#define SYSCALL_ARG3   "r9"
+#define SYSCALL_ARG4   "r13"
+#define SYSCALL_ARG5   "r14"
+#define SYSCALL_RET    "r10"
+
+#define SYSCALL_SHORT_TRAP     "0"
+#define SYSCALL_LONG_TRAP      "1"
+
+/* Registers clobbered by any syscall.  This _doesn't_ include the syscall
+   number (r12) or the `extended arg' registers (r13, r14), even though
+   they are actually clobbered too (this is because gcc's `asm' statement
+   doesn't allow a clobber to be used as an input or output).  */
+#define SYSCALL_CLOBBERS       "r1", "r5", "r11", "r15", "r16", \
+                               "r17", "r18", "r19"
+
+/* Registers clobbered by a `short' syscall.  This includes all clobbers
+   except the syscall number (r12).  */
+#define SYSCALL_SHORT_CLOBBERS SYSCALL_CLOBBERS, "r13", "r14"
+
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64

