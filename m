Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbXKBPlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbXKBPlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756621AbXKBPlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:41:11 -0400
Received: from [198.99.130.12] ([198.99.130.12]:60093 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbXKBPlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:41:08 -0400
Date: Fri, 2 Nov 2007 11:40:15 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 5/6] UML - Further bugs.c tidying
Message-ID: <20071102154015.GA10283@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

bugs.c, for both i386 and x86_64, can undergo further cleaning -
	The i386 arch_check_bugs only does one thing, so we might as
well inline the cmov checking.
	The i386 includes can be trimmed down a bit.
	arch_init_thread wasn't used, so it is deleted.
	The panics in arch_handle_signal are turned into printks
because the process is about to get segfaulted anyway, so something is
dying no matter what happens here.  Also, the return value was always
the same, so it contained no information, so it can be void instead.
The name is changed to arch_examine_signal because it doesn't handle
anything.
	The caller of arch_handle_signal, relay_signal, does things in
a different order.  The kernel-mode signal check is now first, which
puts everything else together, making things a bit clearer conceptually.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/arch.h    |    2 +-
 arch/um/kernel/trap.c     |    5 ++---
 arch/um/sys-i386/bugs.c   |   45 +++++++++++++++++++--------------------------
 arch/um/sys-x86_64/bugs.c |    7 +------
 4 files changed, 23 insertions(+), 36 deletions(-)

Index: linux-2.6.22/arch/um/sys-i386/bugs.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-i386/bugs.c	2007-10-31 12:23:33.000000000 -0400
+++ linux-2.6.22/arch/um/sys-i386/bugs.c	2007-10-31 12:33:07.000000000 -0400
@@ -3,14 +3,12 @@
  * Licensed under the GPL
  */
 
-#include <errno.h>
 #include <signal.h>
-#include <string.h>
 #include "kern_constants.h"
-#include "os.h"
+#include "longjmp.h"
 #include "task.h"
 #include "user.h"
-#include "sysdep/archsetjmp.h"
+#include "sysdep/ptrace.h"
 
 /* Set during early boot */
 int host_has_cmov = 1;
@@ -22,7 +20,7 @@ static void cmov_sigill_test_handler(int
 	longjmp(cmov_test_return, 1);
 }
 
-static void test_for_host_cmov(void)
+void arch_check_bugs(void)
 {
 	struct sigaction old, new;
 
@@ -45,16 +43,7 @@ static void test_for_host_cmov(void)
 	sigaction(SIGILL, &old, &new);
 }
 
-void arch_init_thread(void)
-{
-}
-
-void arch_check_bugs(void)
-{
-	test_for_host_cmov();
-}
-
-int arch_handle_signal(int sig, struct uml_pt_regs *regs)
+void arch_examine_signal(int sig, struct uml_pt_regs *regs)
 {
 	unsigned char tmp[2];
 
@@ -63,20 +52,24 @@ int arch_handle_signal(int sig, struct u
 	 * SIGILL in init.
 	 */
 	if ((sig != SIGILL) || (TASK_PID(get_current()) != 1))
-		return 0;
+		return;
+
+	if (copy_from_user_proc(tmp, (void *) UPT_IP(regs), 2)) {
+		printk(UM_KERN_ERR "SIGILL in init, could not read "
+		       "instructions!\n");
+		return;
+	}
 
-	if (copy_from_user_proc(tmp, (void *) UPT_IP(regs), 2))
-		panic("SIGILL in init, could not read instructions!\n");
 	if ((tmp[0] != 0x0f) || ((tmp[1] & 0xf0) != 0x40))
-		return 0;
+		return;
 
 	if (host_has_cmov == 0)
-		panic("SIGILL caused by cmov, which this processor doesn't "
-		      "implement, boot a filesystem compiled for older "
-		      "processors");
+		printk(UM_KERN_ERR "SIGILL caused by cmov, which this "
+		       "processor doesn't implement.  Boot a filesystem "
+		       "compiled for older processors");
 	else if (host_has_cmov == 1)
-		panic("SIGILL caused by cmov, which this processor claims to "
-		      "implement");
-	else panic("Bad value for host_has_cmov (%d)", host_has_cmov);
-	return 0;
+		printk(UM_KERN_ERR "SIGILL caused by cmov, which this "
+		       "processor claims to implement");
+	else printk(UM_KERN_ERR "Bad value for host_has_cmov (%d)",
+		    host_has_cmov);
 }
Index: linux-2.6.22/arch/um/sys-x86_64/bugs.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-x86_64/bugs.c	2007-10-31 12:18:46.000000000 -0400
+++ linux-2.6.22/arch/um/sys-x86_64/bugs.c	2007-10-31 12:28:27.000000000 -0400
@@ -6,15 +6,10 @@
 
 #include "sysdep/ptrace.h"
 
-void arch_init_thread(void)
-{
-}
-
 void arch_check_bugs(void)
 {
 }
 
-int arch_handle_signal(int sig, struct uml_pt_regs *regs)
+void arch_examine_signal(int sig, struct uml_pt_regs *regs)
 {
-	return 0;
 }
Index: linux-2.6.22/arch/um/include/arch.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/arch.h	2007-10-12 12:09:00.000000000 -0400
+++ linux-2.6.22/arch/um/include/arch.h	2007-10-31 12:28:55.000000000 -0400
@@ -10,6 +10,6 @@
 
 extern void arch_check_bugs(void);
 extern int arch_fixup(unsigned long address, struct uml_pt_regs *regs);
-extern int arch_handle_signal(int sig, struct uml_pt_regs *regs);
+extern void arch_examine_signal(int sig, struct uml_pt_regs *regs);
 
 #endif
Index: linux-2.6.22/arch/um/kernel/trap.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/trap.c	2007-10-25 23:33:16.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/trap.c	2007-10-31 12:24:22.000000000 -0400
@@ -216,9 +216,6 @@ unsigned long segv(struct faultinfo fi, 
 
 void relay_signal(int sig, struct uml_pt_regs *regs)
 {
-	if (arch_handle_signal(sig, regs))
-		return;
-
 	if (!UPT_IS_USER(regs)) {
 		if (sig == SIGBUS)
 			printk(KERN_ERR "Bus error - the host /dev/shm or /tmp "
@@ -226,6 +223,8 @@ void relay_signal(int sig, struct uml_pt
 		panic("Kernel mode signal %d", sig);
 	}
 
+	arch_examine_signal(sig, regs);
+
 	current->thread.arch.faultinfo = *UPT_FAULTINFO(regs);
 	force_sig(sig, current);
 }
