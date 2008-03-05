Return-Path: <linux-kernel-owner+w=401wt.eu-S934054AbYCEMBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054AbYCEMBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765982AbYCEL5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 06:57:38 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:2775 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760550AbYCEL5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 06:57:20 -0500
Message-Id: <20080305115713.586405448@de.ibm.com>
References: <20080305115432.691030908@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 05 Mar 2008 12:54:35 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Bastian Blank <bastian@waldi.eu.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 03/10] Get rid of memcpy gcc warning workaround.
Content-Disposition: inline; filename=003-memcpy-warning.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Compile smp.o with -Wno-nonnull so gcc stops warning about memcpy
being used with a null parameter. Also remove the workaround code
and use a char * cast instead of a void * cast to do computations.

Cc: Bastian Blank <bastian@waldi.eu.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/Makefile |    5 +++++
 arch/s390/kernel/smp.c    |   10 ++--------
 2 files changed, 7 insertions(+), 8 deletions(-)

Index: quilt-2.6/arch/s390/kernel/Makefile
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/Makefile
+++ quilt-2.6/arch/s390/kernel/Makefile
@@ -4,6 +4,11 @@
 
 EXTRA_AFLAGS	:= -traditional
 
+#
+# Passing null pointers is ok for smp code, since we access the lowcore here.
+#
+CFLAGS_smp.o	:= -Wno-nonnull
+
 obj-y	:=  bitmap.o traps.o time.o process.o base.o early.o \
             setup.o sys_s390.o ptrace.o signal.o cpcmd.o ebcdic.o \
 	    semaphore.o s390_ext.o debug.o irq.o ipl.o dis.o diag.o
Index: quilt-2.6/arch/s390/kernel/smp.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/smp.c
+++ quilt-2.6/arch/s390/kernel/smp.c
@@ -629,14 +629,8 @@ static int __cpuinit smp_alloc_lowcore(i
 	panic_stack = __get_free_page(GFP_KERNEL);
 	if (!panic_stack || !async_stack)
 		goto out;
-	/*
-	 * Only need to copy the first 512 bytes from address 0. But since
-	 * the compiler emits a warning if src == NULL for memcpy use copy_page
-	 * instead. Copies more than needed but this code is not performance
-	 * critical.
-	 */
-	copy_page(lowcore, &S390_lowcore);
-	memset((void *)lowcore + 512, 0, sizeof(*lowcore) - 512);
+	memcpy(lowcore, &S390_lowcore, 512);
+	memset((char *)lowcore + 512, 0, sizeof(*lowcore) - 512);
 	lowcore->async_stack = async_stack + ASYNC_SIZE;
 	lowcore->panic_stack = panic_stack + PAGE_SIZE;
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

