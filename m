Return-Path: <linux-kernel-owner+w=401wt.eu-S1030759AbXAZQqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030759AbXAZQqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030758AbXAZQqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:46:22 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:25411 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030642AbXAZQqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:46:21 -0500
Date: Fri, 26 Jan 2007 17:46:13 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] Move init_irq_proc to the other irq related functions.
Message-ID: <20070126164613.GA11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] Move init_irq_proc to the other irq related functions.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/Makefile  |    2 +-
 arch/s390/kernel/irq.c     |   15 ++++++++++++---
 arch/s390/kernel/profile.c |   20 --------------------
 3 files changed, 13 insertions(+), 24 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/irq.c linux-2.6-patched/arch/s390/kernel/irq.c
--- linux-2.6/arch/s390/kernel/irq.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/irq.c	2007-01-26 17:27:45.000000000 +0100
@@ -1,9 +1,9 @@
 /*
  *  arch/s390/kernel/irq.c
  *
- *  S390 version
- *    Copyright (C) 2004 IBM Deutschland Entwicklung GmbH, IBM Corporation
+ *    Copyright IBM Corp. 2004,2007
  *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com),
+ *		 Thomas Spatzier (tspat@de.ibm.com)
  *
  * This file contains interrupt related functions.
  */
@@ -14,6 +14,8 @@
 #include <linux/interrupt.h>
 #include <linux/seq_file.h>
 #include <linux/cpu.h>
+#include <linux/proc_fs.h>
+#include <linux/profile.h>
 
 /*
  * show_interrupts is needed by /proc/interrupts.
@@ -93,5 +95,12 @@ asmlinkage void do_softirq(void)
 
 	local_irq_restore(flags);
 }
-
 EXPORT_SYMBOL(do_softirq);
+
+void init_irq_proc(void)
+{
+	struct proc_dir_entry *root_irq_dir;
+
+	root_irq_dir = proc_mkdir("irq", NULL);
+	create_prof_cpu_mask(root_irq_dir);
+}
diff -urpN linux-2.6/arch/s390/kernel/Makefile linux-2.6-patched/arch/s390/kernel/Makefile
--- linux-2.6/arch/s390/kernel/Makefile	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/Makefile	2007-01-26 17:27:45.000000000 +0100
@@ -6,7 +6,7 @@ EXTRA_AFLAGS	:= -traditional
 
 obj-y	:=  bitmap.o traps.o time.o process.o reset.o \
             setup.o sys_s390.o ptrace.o signal.o cpcmd.o ebcdic.o \
-	    semaphore.o s390_ext.o debug.o profile.o irq.o ipl.o
+	    semaphore.o s390_ext.o debug.o irq.o ipl.o
 
 obj-y	+= $(if $(CONFIG_64BIT),entry64.o,entry.o)
 obj-y	+= $(if $(CONFIG_64BIT),reipl64.o,reipl.o)
diff -urpN linux-2.6/arch/s390/kernel/profile.c linux-2.6-patched/arch/s390/kernel/profile.c
--- linux-2.6/arch/s390/kernel/profile.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/profile.c	1970-01-01 01:00:00.000000000 +0100
@@ -1,20 +0,0 @@
-/*
- * arch/s390/kernel/profile.c
- *
- * Copyright (C) 2003 IBM Deutschland Entwicklung GmbH, IBM Corporation
- * Author(s): Thomas Spatzier (tspat@de.ibm.com)
- *
- */
-#include <linux/proc_fs.h>
-#include <linux/profile.h>
-
-static struct proc_dir_entry * root_irq_dir;
-
-void init_irq_proc(void)
-{
-	/* create /proc/irq */
-	root_irq_dir = proc_mkdir("irq", NULL);
-
-	/* create /proc/irq/prof_cpu_mask */
-	create_prof_cpu_mask(root_irq_dir);
-}
