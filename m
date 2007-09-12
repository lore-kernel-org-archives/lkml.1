Return-Path: <linux-kernel-owner+w=401wt.eu-S933819AbXILVR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819AbXILVR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762887AbXILVQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:16:58 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55957 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761126AbXILVQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:16:57 -0400
Date: Wed, 12 Sep 2007 17:16:45 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/11] UML - tidy set_interval
Message-ID: <20070912211645.GA10242@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

set_interval took a timer type as an argument, but it always specified
a virtual timer.  So, it is not needed, and it is gone, and
set_interval is simplified appropriately.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/os.h            |    2 +-
 arch/um/kernel/time.c           |    2 +-
 arch/um/os-Linux/skas/process.c |    2 +-
 arch/um/os-Linux/time.c         |    5 ++---
 4 files changed, 5 insertions(+), 6 deletions(-)

Index: linux-2.6.22/arch/um/include/os.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/os.h	2007-08-30 16:30:49.000000000 -0400
+++ linux-2.6.22/arch/um/include/os.h	2007-08-30 16:31:15.000000000 -0400
@@ -252,7 +252,7 @@ extern void os_dump_core(void);
 
 extern int switch_timers(int to_real);
 extern void idle_sleep(int secs);
-extern int set_interval(int is_virtual);
+extern int set_interval(void);
 extern void disable_timer(void);
 extern void uml_idle_timer(void);
 extern unsigned long long os_nsecs(void);
Index: linux-2.6.22/arch/um/kernel/time.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/time.c	2007-08-30 16:30:13.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/time.c	2007-08-30 16:31:15.000000000 -0400
@@ -102,7 +102,7 @@ static void register_timer(void)
 		printk(KERN_ERR "register_timer : request_irq failed - "
 		       "errno = %d\n", -err);
 
-	err = set_interval(1);
+	err = set_interval();
 	if (err != 0)
 		printk(KERN_ERR "register_timer : set_interval failed - "
 		       "errno = %d\n", -err);
Index: linux-2.6.22/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/skas/process.c	2007-08-30 16:30:13.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/skas/process.c	2007-08-30 16:31:15.000000000 -0400
@@ -178,7 +178,7 @@ static int userspace_tramp(void *stack)
 	ptrace(PTRACE_TRACEME, 0, 0, 0);
 
 	init_new_thread_signals();
-	err = set_interval(1);
+	err = set_interval();
 	if (err)
 		panic("userspace_tramp - setting timer failed, errno = %d\n",
 		      err);
Index: linux-2.6.22/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/time.c	2007-08-30 16:30:49.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/time.c	2007-08-30 16:31:15.000000000 -0400
@@ -14,14 +14,13 @@
 
 static int is_real_timer = 0;
 
-int set_interval(int is_virtual)
+int set_interval(void)
 {
 	int usec = 1000000/UM_HZ;
-	int timer_type = is_virtual ? ITIMER_VIRTUAL : ITIMER_REAL;
 	struct itimerval interval = ((struct itimerval) { { 0, usec },
 							  { 0, usec } });
 
-	if (setitimer(timer_type, &interval, NULL) == -1)
+	if (setitimer(ITIMER_VIRTUAL, &interval, NULL) == -1)
 		return -errno;
 
 	return 0;
