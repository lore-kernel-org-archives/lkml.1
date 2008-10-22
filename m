Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbYJVVh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbYJVVh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbYJVVf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:35:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64418 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760AbYJVVfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:35:53 -0400
Message-Id: <20081022213551.548023022@goodmis.org>
References: <20081022212721.167005680@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 17:27:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 03/13 v2] ftrace: return error on failed modified text.
Content-Disposition: inline; filename=ftrace-return-error-on-mod-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have the ftrace_modify_code return error values:

  -EFAULT on error of reading the address

  -EINVAL if what is read does not match what it expected

  -EPERM  if the write fails to update after a successful match.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |   12 +++++++-----
 include/linux/ftrace.h   |   24 ++++++++++++++++++++++--
 kernel/trace/ftrace.c    |   21 +++++++++++++++------
 3 files changed, 44 insertions(+), 13 deletions(-)

Index: linux-compile.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/ftrace.c	2008-10-22 16:30:39.000000000 -0400
+++ linux-compile.git/arch/x86/kernel/ftrace.c	2008-10-22 16:30:45.000000000 -0400
@@ -71,14 +71,16 @@ ftrace_modify_code(unsigned long ip, uns
 	 * No real locking needed, this code is run through
 	 * kstop_machine, or before SMP starts.
 	 */
-	if (__copy_from_user_inatomic(replaced, (char __user *)ip, MCOUNT_INSN_SIZE))
-		return 1;
+	if (__copy_from_user_inatomic(replaced, (char __user *)ip,
+				      MCOUNT_INSN_SIZE))
+		return -EFAULT;
 
 	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
-		return 2;
+		return -EINVAL;
 
-	WARN_ON_ONCE(__copy_to_user_inatomic((char __user *)ip, new_code,
-				    MCOUNT_INSN_SIZE));
+	if (__copy_to_user_inatomic((char __user *)ip, new_code,
+				    MCOUNT_INSN_SIZE))
+		return -EPERM;
 
 	sync_core();
 
Index: linux-compile.git/kernel/trace/ftrace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/ftrace.c	2008-10-22 16:30:39.000000000 -0400
+++ linux-compile.git/kernel/trace/ftrace.c	2008-10-22 16:30:45.000000000 -0400
@@ -591,22 +591,22 @@ ftrace_code_disable(struct dyn_ftrace *r
 {
 	unsigned long ip;
 	unsigned char *nop, *call;
-	int failed;
+	int ret;
 
 	ip = rec->ip;
 
 	nop = ftrace_nop_replace();
 	call = ftrace_call_replace(ip, mcount_addr);
 
-	failed = ftrace_modify_code(ip, call, nop);
-	if (failed) {
-		switch (failed) {
-		case 1:
+	ret = ftrace_modify_code(ip, call, nop);
+	if (ret) {
+		switch (ret) {
+		case -EFAULT:
 			WARN_ON_ONCE(1);
 			pr_info("ftrace faulted on modifying ");
 			print_ip_sym(ip);
 			break;
-		case 2:
+		case -EINVAL:
 			WARN_ON_ONCE(1);
 			pr_info("ftrace failed to modify ");
 			print_ip_sym(ip);
@@ -615,6 +615,15 @@ ftrace_code_disable(struct dyn_ftrace *r
 			print_ip_ins(" replace: ", nop);
 			printk(KERN_CONT "\n");
 			break;
+		case -EPERM:
+			WARN_ON_ONCE(1);
+			pr_info("ftrace faulted on writing ");
+			print_ip_sym(ip);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			pr_info("ftrace faulted on unknown error ");
+			print_ip_sym(ip);
 		}
 
 		rec->flags |= FTRACE_FL_FAILED;
Index: linux-compile.git/include/linux/ftrace.h
===================================================================
--- linux-compile.git.orig/include/linux/ftrace.h	2008-10-22 16:30:39.000000000 -0400
+++ linux-compile.git/include/linux/ftrace.h	2008-10-22 16:31:37.000000000 -0400
@@ -72,13 +72,33 @@ extern unsigned char *ftrace_nop_replace
 extern unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr);
 extern int ftrace_dyn_arch_init(void *data);
 extern int ftrace_mcount_set(unsigned long *data);
-extern int ftrace_modify_code(unsigned long ip, unsigned char *old_code,
-			      unsigned char *new_code);
 extern int ftrace_update_ftrace_func(ftrace_func_t func);
 extern void ftrace_caller(void);
 extern void ftrace_call(void);
 extern void mcount_call(void);
 
+/**
+ * ftrace_modify_code - modify code segment
+ * @ip: the address of the code segment
+ * @old_code: the contents of what is expected to be there
+ * @new_code: the code to patch in
+ *
+ * This is a very sensitive operatation and great care needs
+ * to be taken by the arch.  The operation should carefully
+ * read the location, check to see if what is read is indeed
+ * what we expect it to be, and then on success of the compare,
+ * it should write to the location.
+ *
+ * Return must be:
+ *  0 on success
+ *  -EFAULT on error reading the location
+ *  -EINVAL on a failed compare of the contents
+ *  -EPERM  on error writing to the location
+ * Any other value will be considered a failure.
+ */
+extern int ftrace_modify_code(unsigned long ip, unsigned char *old_code,
+			      unsigned char *new_code);
+
 extern int skip_trace(unsigned long ip);
 
 extern void ftrace_release(void *start, unsigned long size);

-- 
