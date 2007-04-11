Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbXDKQGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbXDKQGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 12:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbXDKQGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 12:06:39 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:46126 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbXDKQGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 12:06:37 -0400
Date: Wed, 11 Apr 2007 12:01:26 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/4] UML - Dump core on panic
Message-ID: <20070411160126.GA6329@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dump core after a panic.  This will provide better debugging
information than is currently available.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/os.h     |    1 +
 arch/um/kernel/um_arch.c |    2 +-
 arch/um/os-Linux/util.c  |    6 ++++++
 3 files changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.21-mm/arch/um/include/os.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/os.h	2007-04-06 10:36:33.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/os.h	2007-04-06 10:38:54.000000000 -0400
@@ -281,6 +281,7 @@ extern void setup_machinename(char *mach
 extern void setup_hostinfo(char *buf, int len);
 extern int setjmp_wrapper(void (*proc)(void *, void *), ...);
 extern void os_log_info(char *fmt, va_list ap);
+extern void os_dump_core(void);
 
 /* time.c */
 #define BILLION (1000 * 1000 * 1000)
Index: linux-2.6.21-mm/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/um_arch.c	2007-04-06 10:37:48.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/um_arch.c	2007-04-06 10:38:05.000000000 -0400
@@ -474,7 +474,7 @@ static int panic_exit(struct notifier_bl
 	show_regs(&(current->thread.regs));
 	bust_spinlocks(0);
 	uml_exitcode = 1;
-	machine_halt();
+	os_dump_core();
 	return 0;
 }
 
Index: linux-2.6.21-mm/arch/um/os-Linux/util.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/util.c	2007-04-05 13:25:28.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/util.c	2007-04-06 10:57:55.000000000 -0400
@@ -148,3 +148,9 @@ void os_log_info(char *fmt, va_list ap)
 	vsnprintf(&logging_buf[len], sizeof(logging_buf) - len, fmt, ap);
 	write(logging_fd, logging_buf, strlen(logging_buf));
 }
+
+void os_dump_core(void)
+{
+	signal(SIGSEGV, SIG_DFL);
+	abort();
+}
