Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbYJVSwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbYJVSwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758014AbYJVSvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:51:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55329 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953AbYJVSvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:51:38 -0400
Message-Id: <20081022185135.952553961@goodmis.org>
References: <20081022184313.179487464@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 14:43:16 -0400
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
Subject: [PATCH 03/11] ftrace: return error on failed modified text.
Content-Disposition: inline; filename=ftrace-return-error-on-mod-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -1 on failed modified text.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |   12 +++++++-----
 kernel/trace/ftrace.c    |   29 ++++++++++-------------------
 2 files changed, 17 insertions(+), 24 deletions(-)

Index: linux-compile.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/ftrace.c	2008-10-22 13:10:58.000000000 -0400
+++ linux-compile.git/arch/x86/kernel/ftrace.c	2008-10-22 13:15:36.000000000 -0400
@@ -71,14 +71,16 @@ ftrace_modify_code(unsigned long ip, uns
 	 * No real locking needed, this code is run through
 	 * kstop_machine, or before SMP starts.
 	 */
-	if (__copy_from_user_inatomic(replaced, (char __user *)ip, MCOUNT_INSN_SIZE))
-		return 1;
+	if (__copy_from_user_inatomic(replaced, (char __user *)ip,
+				      MCOUNT_INSN_SIZE))
+		return -1;
 
 	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
-		return 2;
+		return -1;
 
-	WARN_ON_ONCE(__copy_to_user_inatomic((char __user *)ip, new_code,
-				    MCOUNT_INSN_SIZE));
+	if (__copy_to_user_inatomic((char __user *)ip, new_code,
+				    MCOUNT_INSN_SIZE))
+		return -1;
 
 	sync_core();
 
Index: linux-compile.git/kernel/trace/ftrace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/ftrace.c	2008-10-22 13:10:58.000000000 -0400
+++ linux-compile.git/kernel/trace/ftrace.c	2008-10-22 13:14:04.000000000 -0400
@@ -591,31 +591,22 @@ ftrace_code_disable(struct dyn_ftrace *r
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
-			WARN_ON_ONCE(1);
-			pr_info("ftrace faulted on modifying ");
-			print_ip_sym(ip);
-			break;
-		case 2:
-			WARN_ON_ONCE(1);
-			pr_info("ftrace failed to modify ");
-			print_ip_sym(ip);
-			print_ip_ins(" expected: ", call);
-			print_ip_ins(" actual: ", (unsigned char *)ip);
-			print_ip_ins(" replace: ", nop);
-			printk(KERN_CONT "\n");
-			break;
-		}
+	ret = ftrace_modify_code(ip, call, nop);
+	if (ret) {
+		WARN_ON_ONCE(1);
+		pr_info("ftrace failed to modify ");
+		print_ip_sym(ip);
+		print_ip_ins(" expected: ", call);
+		print_ip_ins(" replace: ", nop);
+		printk(KERN_CONT "\n");
+		break;
 
 		rec->flags |= FTRACE_FL_FAILED;
 		return 0;

-- 
