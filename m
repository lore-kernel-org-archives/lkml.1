Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbXLFRHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbXLFRHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 12:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbXLFRHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 12:07:00 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:32907 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbXLFRG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 12:06:59 -0500
Date: Thu, 6 Dec 2007 12:06:41 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Karol Swietlicki <magotari@gmail.com>
Subject: [PATCH 2/6] UML - Remove duplicate config symbol and unused file and variables
Message-ID: <20071206170641.GA7425@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karol Swietlicki <magotari@gmail.com>

This patch fixes the repetition of the NET symbol. It was once in UML
specific options and once in networking. I removed the first
occurrence, as it makes more sense to me to keep it only in
networking.

It also removes a mostly empty file which is not used anymore and some
unused variables.

Compile and run tested.

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/Kconfig                 |   17 -----------------
 arch/um/Makefile-tt             |    5 -----
 arch/um/drivers/mconsole_kern.c |    3 ---
 arch/um/kernel/process.c        |    4 ++--
 4 files changed, 2 insertions(+), 27 deletions(-)

Index: linux-2.6-git/arch/um/Kconfig
===================================================================
--- linux-2.6-git.orig/arch/um/Kconfig	2007-12-06 10:32:01.000000000 -0500
+++ linux-2.6-git/arch/um/Kconfig	2007-12-06 10:33:28.000000000 -0500
@@ -95,23 +95,6 @@ config LD_SCRIPT_DYN
 	default y
 	depends on !LD_SCRIPT_STATIC
 
-config NET
-	bool "Networking support"
-	help
-	  Unless you really know what you are doing, you should say Y here.
-	  The reason is that some programs need kernel networking support even
-	  when running on a stand-alone machine that isn't connected to any
-	  other computer. If you are upgrading from an older kernel, you
-	  should consider updating your networking tools too because changes
-	  in the kernel and the tools often go hand in hand. The tools are
-	  contained in the package net-tools, the location and version number
-	  of which are given in <file:Documentation/Changes>.
-
-	  For a general introduction to Linux networking, it is highly
-	  recommended to read the NET-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-
 source "fs/Kconfig.binfmt"
 
 config HOSTFS
Index: linux-2.6-git/arch/um/Makefile-tt
===================================================================
--- linux-2.6-git.orig/arch/um/Makefile-tt	2007-11-28 13:01:17.000000000 -0500
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,5 +0,0 @@
-# 
-# Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
-# Licensed under the GPL
-#
-
Index: linux-2.6-git/arch/um/kernel/process.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/process.c	2007-12-06 10:32:11.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/process.c	2007-12-06 10:33:28.000000000 -0500
@@ -30,7 +30,7 @@
  */
 struct cpu_task cpu_tasks[NR_CPUS] = { [0 ... NR_CPUS - 1] = { -1, NULL } };
 
-static inline int external_pid(struct task_struct *task)
+static inline int external_pid(void)
 {
 	/* FIXME: Need to look up userspace_pid by cpu */
 	return userspace_pid[0];
@@ -78,7 +78,7 @@ int kernel_thread(int (*fn)(void *), voi
 static inline void set_current(struct task_struct *task)
 {
 	cpu_tasks[task_thread_info(task)->cpu] = ((struct cpu_task)
-		{ external_pid(task), task });
+		{ external_pid(), task });
 }
 
 extern void arch_switch_to(struct task_struct *to);
Index: linux-2.6-git/arch/um/drivers/mconsole_kern.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/mconsole_kern.c	2007-12-03 23:56:34.000000000 -0500
+++ linux-2.6-git/arch/um/drivers/mconsole_kern.c	2007-12-06 10:33:28.000000000 -0500
@@ -741,7 +741,6 @@ void mconsole_stack(struct mc_request *r
 {
 	char *ptr = req->request.data;
 	int pid_requested= -1;
-	struct task_struct *from = NULL;
 	struct task_struct *to = NULL;
 
 	/*
@@ -763,8 +762,6 @@ void mconsole_stack(struct mc_request *r
 		return;
 	}
 
-	from = current;
-
 	to = find_task_by_pid(pid_requested);
 	if ((to == NULL) || (pid_requested == 0)) {
 		mconsole_reply(req, "Couldn't find that pid", 1, 0);
