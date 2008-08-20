Return-Path: <linux-kernel-owner+w=401wt.eu-S1760356AbYHTQzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356AbYHTQzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbYHTQzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:55:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42755 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbYHTQzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:55:08 -0400
Date: Wed, 20 Aug 2008 12:55:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] ftrace: x86 use copy to and from user functions
Message-ID: <alpine.DEB.1.10.0808201253330.494@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The modification of code is performed either by kstop_machine, before
SMP starts, or on module code before the module is executed. There is
no reason to do the modifications from assembly. The copy to and from
user functions are sufficient and produces cleaner and easier to read
code.

Thanks to Benjamin Herrenschmidt for suggesting the idea.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |   38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

Index: linux-tip.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/ftrace.c	2008-08-20 12:39:41.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/ftrace.c	2008-08-20 12:40:17.000000000 -0400
@@ -11,6 +11,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
+#include <linux/uaccess.h>
 #include <linux/ftrace.h>
 #include <linux/percpu.h>
 #include <linux/init.h>
@@ -60,11 +61,7 @@ notrace int
 ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		   unsigned char *new_code)
 {
-	unsigned replaced;
-	unsigned old = *(unsigned *)old_code; /* 4 bytes */
-	unsigned new = *(unsigned *)new_code; /* 4 bytes */
-	unsigned char newch = new_code[4];
-	int faulted = 0;
+	unsigned char replaced[MCOUNT_INSN_SIZE];
 
 	/*
 	 * Note: Due to modules and __init, code can
@@ -72,29 +69,20 @@ ftrace_modify_code(unsigned long ip, uns
 	 *  as well as code changing.
 	 *
 	 * No real locking needed, this code is run through
-	 * kstop_machine.
+	 * kstop_machine, or before SMP starts.
 	 */
-	asm volatile (
-		"1: lock\n"
-		"   cmpxchg %3, (%2)\n"
-		"   jnz 2f\n"
-		"   movb %b4, 4(%2)\n"
-		"2:\n"
-		".section .fixup, \"ax\"\n"
-		"3:	movl $1, %0\n"
-		"	jmp 2b\n"
-		".previous\n"
-		_ASM_EXTABLE(1b, 3b)
-		: "=r"(faulted), "=a"(replaced)
-		: "r"(ip), "r"(new), "c"(newch),
-		  "0"(faulted), "a"(old)
-		: "memory");
-	sync_core();
+	if (__copy_from_user(replaced, (char __user *)ip, MCOUNT_INSN_SIZE))
+		return 1;
 
-	if (replaced != old && replaced != new)
-		faulted = 2;
+	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
+		return 2;
 
-	return faulted;
+	WARN_ON_ONCE(__copy_to_user((char __user *)ip, new_code,
+				    MCOUNT_INSN_SIZE));
+
+	sync_core();
+
+	return 0;
 }
 
 notrace int ftrace_update_ftrace_func(ftrace_func_t func)

