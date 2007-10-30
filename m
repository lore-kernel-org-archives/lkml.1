Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbXJ3R34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbXJ3R34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbXJ3R3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:29:36 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:43043 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbXJ3R3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:29:34 -0400
Date: Tue, 30 Oct 2007 13:28:49 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/4] UML - Implement get_wchan
Message-ID: <20071030172849.GA8367@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement get_wchan - the algorithm is similar to x86.  It starts with
the stack pointer of the process in question and looks above that for
addresses that are kernel text.  The second one which isn't in the
scheduler is the one that's returned.  The first one is ignored
because that will be UML's own context switching routine.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/process.c           |   37 +++++++++++++++++++++++++++++++++++++
 include/asm-um/processor-generic.h |    2 +-
 2 files changed, 38 insertions(+), 1 deletion(-)

Index: linux-2.6.22/arch/um/kernel/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/process.c	2007-10-29 15:28:25.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/process.c	2007-10-29 15:49:43.000000000 -0400
@@ -459,3 +459,40 @@ unsigned long arch_align_stack(unsigned 
 	return sp & ~0xf;
 }
 #endif
+
+unsigned long get_wchan(struct task_struct *p)
+{
+	unsigned long stack_page, sp, ip, count = 0;
+
+	if ((p == NULL) || (p == current) || (p->state == TASK_RUNNING))
+		return 0;
+
+	stack_page = (unsigned long) task_stack_page(p);
+	/* Bail if the process has no kernel stack for some reason */
+	if (stack_page == 0)
+		return 0;
+
+	sp = p->thread.switch_buf->JB_SP;
+	/*
+	 * Bail if the stack pointer is below the bottom of the kernel
+	 * stack for some reason
+	 */
+	if (sp < stack_page)
+		return 0;
+
+	while (sp < stack_page + THREAD_SIZE) {
+		ip = *((unsigned long *) sp);
+		if (kernel_text_address(ip) && !in_sched_functions(ip)) {
+			/*
+			 * Skip one valid IP, which will be the low-level UML
+			 * context switcher.
+			 */
+			if (count++ == 1)
+				return ip;
+		}
+
+		sp += sizeof(unsigned long);
+	}
+
+	return 0;
+}
Index: linux-2.6.22/include/asm-um/processor-generic.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/processor-generic.h	2007-10-29 15:28:25.000000000 -0400
+++ linux-2.6.22/include/asm-um/processor-generic.h	2007-10-29 15:28:57.000000000 -0400
@@ -128,6 +128,6 @@ extern struct cpuinfo_um cpu_data[];
 
 
 #define KSTK_REG(tsk, reg) get_thread_reg(reg, &tsk->thread.switch_buf)
-#define get_wchan(p) (0)
+extern unsigned long get_wchan(struct task_struct *p);
 
 #endif
