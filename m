Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbXHBVFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbXHBVFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760829AbXHBVFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:05:00 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:43963 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758602AbXHBVE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:04:59 -0400
Date: Thu, 2 Aug 2007 17:04:38 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/6] UML - Stop specially protecting kernel stacks
Message-ID: <20070802210438.GA11184@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Map all of physical memory as executable to avoid having to change
stack protections during fork and exit.

unprotect_stack is now called only from MODE_TT code, so it is marked
as such.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/kern_util.h |    2 ++
 arch/um/kernel/init_task.c  |    2 ++
 arch/um/kernel/physmem.c    |    2 +-
 arch/um/kernel/process.c    |    5 ++---
 4 files changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6.21-mm/arch/um/kernel/physmem.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/physmem.c	2007-08-02 16:43:17.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/physmem.c	2007-08-02 16:43:25.000000000 -0400
@@ -105,7 +105,7 @@ void __init setup_physmem(unsigned long 
 
 	offset = uml_reserved - uml_physmem;
 	err = os_map_memory((void *) uml_reserved, physmem_fd, offset,
-			    len - offset, 1, 1, 0);
+			    len - offset, 1, 1, 1);
 	if(err < 0){
 		os_print_error(err, "Mapping memory");
 		exit(1);
Index: linux-2.6.21-mm/arch/um/kernel/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/process.c	2007-08-02 16:43:17.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/process.c	2007-08-02 16:43:25.000000000 -0400
@@ -82,9 +82,9 @@ unsigned long alloc_stack(int order, int
 	if (atomic)
 		flags = GFP_ATOMIC;
 	page = __get_free_pages(flags, order);
-	if(page == 0)
+	if (page == 0)
 		return 0;
-	stack_protections(page);
+
 	return page;
 }
 
@@ -141,7 +141,6 @@ void release_thread(struct task_struct *
 
 void exit_thread(void)
 {
-	unprotect_stack((unsigned long) current_thread);
 }
 
 void *get_current(void)
Index: linux-2.6.21-mm/arch/um/include/kern_util.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/kern_util.h	2007-08-02 16:43:17.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/kern_util.h	2007-08-02 16:43:25.000000000 -0400
@@ -82,7 +82,9 @@ extern void check_stack_overflow(void *p
 extern void relay_signal(int sig, union uml_pt_regs *regs);
 extern int user_context(unsigned long sp);
 extern void timer_irq(union uml_pt_regs *regs);
+#ifdef CONFIG_MODE_TT
 extern void unprotect_stack(unsigned long stack);
+#endif
 extern void do_uml_exitcalls(void);
 extern int attach_debugger(int idle_pid, int pid, int stop);
 extern int config_gdb(char *str);
Index: linux-2.6.21-mm/arch/um/kernel/init_task.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/init_task.c	2007-08-02 16:43:17.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/init_task.c	2007-08-02 16:43:25.000000000 -0400
@@ -47,7 +47,9 @@ union thread_union cpu0_irqstack
 	__attribute__((__section__(".data.init_irqstack"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
+#ifdef CONFIG_MODE_TT
 void unprotect_stack(unsigned long stack)
 {
 	os_protect_memory((void *) stack, THREAD_SIZE, 1, 1, 0);
 }
+#endif
