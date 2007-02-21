Return-Path: <linux-kernel-owner+w=401wt.eu-S1423103AbXBUUdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423103AbXBUUdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423104AbXBUUdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:33:41 -0500
Received: from [198.99.130.12] ([198.99.130.12]:59699 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1423103AbXBUUdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:33:39 -0500
Message-Id: <200702212025.l1LKPKeG006784@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 3/4] UML - host_info tidying
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 21 Feb 2007 15:25:20 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the host_info string from util.c to um_arch.c, where it is
actually initialized and used.  Also document its lack of locking.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/include/os.h        |    2 +-
 arch/um/include/user_util.h |    2 --
 arch/um/kernel/um_arch.c    |    6 +++++-
 arch/um/os-Linux/util.c     |    8 +++-----
 4 files changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6.17/arch/um/include/os.h
===================================================================
--- linux-2.6.17.orig/arch/um/include/os.h	2007-02-19 11:39:11.000000000 -0500
+++ linux-2.6.17/arch/um/include/os.h	2007-02-19 12:55:11.000000000 -0500
@@ -273,7 +273,7 @@ extern void stack_protections(unsigned l
 extern void task_protections(unsigned long address);
 extern int raw(int fd);
 extern void setup_machinename(char *machine_out);
-extern void setup_hostinfo(void);
+extern void setup_hostinfo(char *buf, int len);
 extern int setjmp_wrapper(void (*proc)(void *, void *), ...);
 
 /* time.c */
Index: linux-2.6.17/arch/um/include/user_util.h
===================================================================
--- linux-2.6.17.orig/arch/um/include/user_util.h	2007-02-19 12:52:22.000000000 -0500
+++ linux-2.6.17/arch/um/include/user_util.h	2007-02-19 12:55:36.000000000 -0500
@@ -36,8 +36,6 @@ extern unsigned long end_vm;
 extern unsigned long start_vm;
 extern unsigned long long highmem;
 
-extern char host_info[];
-
 extern char saved_command_line[];
 
 extern unsigned long _stext, _etext, _sdata, _edata, __bss_start, _end;
Index: linux-2.6.17/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6.17.orig/arch/um/kernel/um_arch.c	2007-02-19 12:53:54.000000000 -0500
+++ linux-2.6.17/arch/um/kernel/um_arch.c	2007-02-19 12:55:11.000000000 -0500
@@ -17,6 +17,7 @@
 #include "linux/seq_file.h"
 #include "linux/delay.h"
 #include "linux/module.h"
+#include "linux/utsname.h"
 #include "asm/page.h"
 #include "asm/pgtable.h"
 #include "asm/ptrace.h"
@@ -68,6 +69,9 @@ unsigned long thread_saved_pc(struct tas
 					      task));
 }
 
+/* Changed in setup_arch, which is called in early boot */
+static char host_info[(__NEW_UTS_LEN + 1) * 5];
+
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
 	int index = 0;
@@ -483,7 +487,7 @@ void __init setup_arch(char **cmdline_p)
 	paging_init();
         strlcpy(saved_command_line, command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
-	setup_hostinfo();
+	setup_hostinfo(host_info, sizeof host_info);
 }
 
 void __init check_bugs(void)
Index: linux-2.6.17/arch/um/os-Linux/util.c
===================================================================
--- linux-2.6.17.orig/arch/um/os-Linux/util.c	2007-02-19 11:39:09.000000000 -0500
+++ linux-2.6.17/arch/um/os-Linux/util.c	2007-02-19 12:55:11.000000000 -0500
@@ -96,15 +96,13 @@ void setup_machinename(char *machine_out
 	strcpy(machine_out, host.machine);
 }
 
-char host_info[(_UTSNAME_LENGTH + 1) * 4 + _UTSNAME_NODENAME_LENGTH + 1];
-
-void setup_hostinfo(void)
+void setup_hostinfo(char *buf, int len)
 {
 	struct utsname host;
 
 	uname(&host);
-	sprintf(host_info, "%s %s %s %s %s", host.sysname, host.nodename,
-		host.release, host.version, host.machine);
+	snprintf(buf, len, "%s %s %s %s %s", host.sysname, host.nodename,
+		 host.release, host.version, host.machine);
 }
 
 int setjmp_wrapper(void (*proc)(void *, void *), ...)

