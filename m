Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbYBIMDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbYBIMDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 07:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYBIMDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 07:03:11 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:43816 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYBIMDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:03:09 -0500
Message-Id: <20080209120304.414077471@de.ibm.com>
References: <20080209120157.885371603@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Sat, 09 Feb 2008 13:01:59 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 02/11] Wire up new timerfd syscalls.
Content-Disposition: inline; filename=002-timerfd.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/compat_wrapper.S |   20 ++++++++++++++++++++
 arch/s390/kernel/syscalls.S       |    3 +++
 include/asm-s390/unistd.h         |    5 ++++-
 3 files changed, 27 insertions(+), 1 deletion(-)

Index: quilt-2.6/arch/s390/kernel/compat_wrapper.S
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/compat_wrapper.S
+++ quilt-2.6/arch/s390/kernel/compat_wrapper.S
@@ -1712,3 +1712,23 @@ sys_fallocate_wrapper:
 	sllg	%r5,%r6,32		# get high word of 64bit loff_t
 	l	%r5,164(%r15)		# get low word of 64bit loff_t
 	jg	sys_fallocate
+
+	.globl	sys_timerfd_create_wrapper
+sys_timerfd_create_wrapper:
+	lgfr	%r2,%r2			# int
+	lgfr	%r3,%r3			# int
+	jg	sys_timerfd_create
+
+	.globl	compat_sys_timerfd_settime_wrapper
+compat_sys_timerfd_settime_wrapper:
+	lgfr	%r2,%r2			# int
+	lgfr	%r3,%r3			# int
+	llgtr	%r4,%r4			# struct compat_itimerspec *
+	llgtr	%r5,%r5			# struct compat_itimerspec *
+	jg	compat_sys_timerfd_settime
+
+	.globl	compat_sys_timerfd_gettime_wrapper
+compat_sys_timerfd_gettime_wrapper:
+	lgfr	%r2,%r2			# int
+	llgtr	%r3,%r3			# struct compat_itimerspec *
+	jg	compat_sys_timerfd_gettime
Index: quilt-2.6/arch/s390/kernel/syscalls.S
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/syscalls.S
+++ quilt-2.6/arch/s390/kernel/syscalls.S
@@ -327,3 +327,6 @@ SYSCALL(sys_utimensat,sys_utimensat,comp
 SYSCALL(sys_signalfd,sys_signalfd,compat_sys_signalfd_wrapper)
 NI_SYSCALL						/* 317 old sys_timer_fd */
 SYSCALL(sys_eventfd,sys_eventfd,sys_eventfd_wrapper)
+SYSCALL(sys_timerfd_create,sys_timerfd_create,sys_timerfd_create_wrapper)
+SYSCALL(sys_timerfd_settime,sys_timerfd_settime,compat_sys_timerfd_settime_wrapper) /* 320 */
+SYSCALL(sys_timerfd_gettime,sys_timerfd_gettime,compat_sys_timerfd_gettime_wrapper)
Index: quilt-2.6/include/asm-s390/unistd.h
===================================================================
--- quilt-2.6.orig/include/asm-s390/unistd.h
+++ quilt-2.6/include/asm-s390/unistd.h
@@ -256,7 +256,10 @@
 #define __NR_signalfd		316
 #define __NR_timerfd		317
 #define __NR_eventfd		318
-#define NR_syscalls 319
+#define __NR_timerfd_create	319
+#define __NR_timerfd_settime	320
+#define __NR_timerfd_gettime	321
+#define NR_syscalls 322
 
 /* 
  * There are some system calls that are not present on 64 bit, some

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

