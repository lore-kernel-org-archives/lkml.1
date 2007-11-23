Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbXKWVw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbXKWVw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 16:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbXKWVvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 16:51:48 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:39365 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612AbXKWVvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 16:51:45 -0500
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Nov 2007 13:51:41 -0800
Subject: [patch 3/4] Timerfd v2 - wire the new timerfd API to the x86 family
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.6855.1195854704.3>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wires up the new timerfd API to the x86 family.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 arch/x86/ia32/ia32entry.S          |    4 +++-
 arch/x86/kernel/syscall_table_32.S |    4 +++-
 include/asm-x86/unistd_32.h        |    6 ++++--
 include/asm-x86/unistd_64.h        |    9 +++++++--
 4 files changed, 17 insertions(+), 6 deletions(-)

Index: linux-2.6.mod/include/asm-x86/unistd_32.h
===================================================================
--- linux-2.6.mod.orig/include/asm-x86/unistd_32.h	2007-11-23 13:13:18.000000000 -0800
+++ linux-2.6.mod/include/asm-x86/unistd_32.h	2007-11-23 13:36:40.000000000 -0800
@@ -327,13 +327,15 @@
 #define __NR_epoll_pwait	319
 #define __NR_utimensat		320
 #define __NR_signalfd		321
-#define __NR_timerfd		322
+#define __NR_timerfd_create	322
 #define __NR_eventfd		323
 #define __NR_fallocate		324
+#define __NR_timerfd_settime	325
+#define __NR_timerfd_gettime	326
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 325
+#define NR_syscalls 327
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6.mod/include/asm-x86/unistd_64.h
===================================================================
--- linux-2.6.mod.orig/include/asm-x86/unistd_64.h	2007-11-23 13:13:18.000000000 -0800
+++ linux-2.6.mod/include/asm-x86/unistd_64.h	2007-11-23 13:36:40.000000000 -0800
@@ -629,12 +629,17 @@
 __SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
 #define __NR_signalfd				282
 __SYSCALL(__NR_signalfd, sys_signalfd)
-#define __NR_timerfd				283
-__SYSCALL(__NR_timerfd, sys_timerfd)
+#define __NR_timerfd_create			283
+__SYSCALL(__NR_timerfd_create, sys_timerfd_create)
 #define __NR_eventfd				284
 __SYSCALL(__NR_eventfd, sys_eventfd)
 #define __NR_fallocate				285
 __SYSCALL(__NR_fallocate, sys_fallocate)
+#define __NR_timerfd_settime			286
+__SYSCALL(__NR_timerfd_settime, sys_timerfd_settime)
+#define __NR_timerfd_gettime			287
+__SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
+
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6.mod/arch/x86/kernel/syscall_table_32.S
===================================================================
--- linux-2.6.mod.orig/arch/x86/kernel/syscall_table_32.S	2007-11-23 13:13:18.000000000 -0800
+++ linux-2.6.mod/arch/x86/kernel/syscall_table_32.S	2007-11-23 13:36:40.000000000 -0800
@@ -321,6 +321,8 @@
 	.long sys_epoll_pwait
 	.long sys_utimensat		/* 320 */
 	.long sys_signalfd
-	.long sys_timerfd
+	.long sys_timerfd_create
 	.long sys_eventfd
 	.long sys_fallocate
+	.long sys_timerfd_settime	/* 325 */
+	.long sys_timerfd_gettime
Index: linux-2.6.mod/arch/x86/ia32/ia32entry.S
===================================================================
--- linux-2.6.mod.orig/arch/x86/ia32/ia32entry.S	2007-11-23 13:13:18.000000000 -0800
+++ linux-2.6.mod/arch/x86/ia32/ia32entry.S	2007-11-23 13:36:40.000000000 -0800
@@ -723,7 +723,9 @@
 	.quad sys_epoll_pwait
 	.quad compat_sys_utimensat	/* 320 */
 	.quad compat_sys_signalfd
-	.quad compat_sys_timerfd
+	.quad sys_timerfd_create
 	.quad sys_eventfd
 	.quad sys32_fallocate
+	.quad compat_sys_timerfd_settime	/* 325 */
+	.quad compat_sys_timerfd_gettime
 ia32_syscall_end:

