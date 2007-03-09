Return-Path: <linux-kernel-owner+w=401wt.eu-S2993080AbXCIIQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993080AbXCIIQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993081AbXCIIQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:16:59 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44308 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993080AbXCIIQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:16:57 -0500
Date: Fri, 9 Mar 2007 10:16:56 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       serue@us.ibm.com
Subject: [PATCH 7/7] revoke: wire up s390 system calls
Message-ID: <Pine.LNX.4.64.0703091016340.32320@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>

Make revokeat and frevoke system calls available to user-space on s390.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/s390/kernel/compat_wrapper.S |   11 +++++++++++
 arch/s390/kernel/syscalls.S       |    2 ++
 include/asm-s390/unistd.h         |    4 +++-
 3 files changed, 16 insertions(+), 1 deletion(-)

Index: uml-2.6/arch/s390/kernel/compat_wrapper.S
===================================================================
--- uml-2.6.orig/arch/s390/kernel/compat_wrapper.S	2007-03-08 10:24:23.000000000 +0200
+++ uml-2.6/arch/s390/kernel/compat_wrapper.S	2007-03-08 10:24:34.000000000 +0200
@@ -1665,3 +1665,14 @@
 	llgtr	%r3,%r3			# unsigned *
 	llgtr	%r4,%r4			# struct getcpu_cache *
 	jg	sys_getcpu
+
+	.globl sys_revokeat_wrapper
+sys_revokeat_wrapper:
+	lgfr	%r2,%r2			# int
+	llgtr	%r3,%r3			# const char *
+	jg	sys_revokeat
+
+	.globl sys_frevoke_wrapper
+sys_frevoke_wrapper:
+	llgfr	%r2,%r2			# unsigned int
+	jg	sys_frevoke
Index: uml-2.6/arch/s390/kernel/syscalls.S
===================================================================
--- uml-2.6.orig/arch/s390/kernel/syscalls.S	2007-03-08 10:24:23.000000000 +0200
+++ uml-2.6/arch/s390/kernel/syscalls.S	2007-03-08 10:24:34.000000000 +0200
@@ -321,3 +321,5 @@
 NI_SYSCALL							/* 310 sys_move_pages */
 SYSCALL(sys_getcpu,sys_getcpu,sys_getcpu_wrapper)
 SYSCALL(sys_epoll_pwait,sys_epoll_pwait,sys_ni_syscall)
+SYSCALL(sys_revokeat,sys_revokeat,sys_revokeat_wrapper)
+SYSCALL(sys_frevoke,sys_frevoke,sys_frevoke_wrapper)
Index: uml-2.6/include/asm-s390/unistd.h
===================================================================
--- uml-2.6.orig/include/asm-s390/unistd.h	2007-03-08 10:24:23.000000000 +0200
+++ uml-2.6/include/asm-s390/unistd.h	2007-03-08 10:24:34.000000000 +0200
@@ -250,8 +250,10 @@
 /* Number 310 is reserved for new sys_move_pages */
 #define __NR_getcpu		311
 #define __NR_epoll_pwait	312
+#define __NR_revokeat		313
+#define __NR_frevoke		314
 
-#define NR_syscalls 313
+#define NR_syscalls 315
 
 /* 
  * There are some system calls that are not present on 64 bit, some
