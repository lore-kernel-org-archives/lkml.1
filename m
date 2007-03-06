Return-Path: <linux-kernel-owner+w=401wt.eu-S966012AbXCFSl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966012AbXCFSl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966010AbXCFSl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:41:26 -0500
Received: from [198.99.130.12] ([198.99.130.12]:53050 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965997AbXCFSlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:41:24 -0500
Message-Id: <200703061832.l26IW6Ua006554@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 2/5] UML - print coredump limits
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 06 Mar 2007 13:32:06 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Print out core dump limits at boot time.  This is to allow core dumps
to be collected if something goes very wrong and to tell if a core
dump isn't going to happen because of a resource limit.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/os-Linux/start_up.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

Index: test/arch/um/os-Linux/start_up.c
===================================================================
--- test.orig/arch/um/os-Linux/start_up.c	2007-03-06 10:21:43.000000000 -0500
+++ test/arch/um/os-Linux/start_up.c	2007-03-06 10:43:02.000000000 -0500
@@ -17,6 +17,7 @@
 #include <sys/time.h>
 #include <sys/wait.h>
 #include <sys/mman.h>
+#include <sys/resource.h>
 #include <asm/unistd.h>
 #include <asm/page.h>
 #include <sys/types.h>
@@ -329,8 +330,32 @@ static void __init check_ptrace(void)
 
 extern void check_tmpexec(void);
 
+static void check_coredump_limit(void)
+{
+	struct rlimit lim;
+	int err = getrlimit(RLIMIT_CORE, &lim);
+
+	if(err){
+		perror("Getting core dump limit");
+		return;
+	}
+
+	printf("Core dump limits :\n\tsoft - ");
+	if(lim.rlim_cur == RLIM_INFINITY)
+		printf("NONE\n");
+	else printf("%lu\n", lim.rlim_cur);
+
+	printf("\thard - ");
+	if(lim.rlim_max == RLIM_INFINITY)
+		printf("NONE\n");
+	else printf("%lu\n", lim.rlim_max);
+}
+
 void os_early_checks(void)
 {
+	/* Print out the core dump limits early */
+	check_coredump_limit();
+
 	check_ptrace();
 
 	/* Need to check this early because mmapping happens before the

