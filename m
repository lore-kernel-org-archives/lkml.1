Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbXEIUdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbXEIUdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbXEIUdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:33:10 -0400
Received: from [198.99.130.12] ([198.99.130.12]:40439 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758595AbXEIUdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:33:08 -0400
Date: Wed, 9 May 2007 16:27:20 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/6] UML - Use UM_THREAD_SIZE in userspace code
Message-ID: <20070509202720.GA22449@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have UM_THREAD_SIZE, we can replace the calculations in
user-space code (an earlier patch took care of the kernel side of the
house).

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/init_task.c      |    3 +--
 arch/um/os-Linux/skas/process.c |    7 +++----
 2 files changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6.21-mm/arch/um/kernel/init_task.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/init_task.c	2007-05-07 15:01:10.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/init_task.c	2007-05-08 10:06:07.000000000 -0400
@@ -44,8 +44,7 @@ __attribute__((__section__(".data.init_t
 
 void unprotect_stack(unsigned long stack)
 {
-	os_protect_memory((void *) stack, (1 << CONFIG_KERNEL_STACK_ORDER) * PAGE_SIZE,
-		       1, 1, 0);
+	os_protect_memory((void *) stack, THREAD_SIZE, 1, 1, 0);
 }
 
 /*
Index: linux-2.6.21-mm/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/skas/process.c	2007-05-07 15:35:31.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/skas/process.c	2007-05-08 10:06:07.000000000 -0400
@@ -490,8 +490,8 @@ void map_stub_pages(int fd, unsigned lon
 void new_thread(void *stack, jmp_buf *buf, void (*handler)(void))
 {
 	(*buf)[0].JB_IP = (unsigned long) handler;
-	(*buf)[0].JB_SP = (unsigned long) stack +
-		(PAGE_SIZE << UML_CONFIG_KERNEL_STACK_ORDER) - sizeof(void *);
+	(*buf)[0].JB_SP = (unsigned long) stack + UM_THREAD_SIZE -
+		sizeof(void *);
 }
 
 #define INIT_JMP_NEW_THREAD 0
@@ -533,8 +533,7 @@ int start_idle_thread(void *stack, jmp_b
 	case INIT_JMP_NEW_THREAD:
 		(*switch_buf)[0].JB_IP = (unsigned long) new_thread_handler;
 		(*switch_buf)[0].JB_SP = (unsigned long) stack +
-			(PAGE_SIZE << UML_CONFIG_KERNEL_STACK_ORDER) -
-			sizeof(void *);
+			UM_THREAD_SIZE - sizeof(void *);
 		break;
 	case INIT_JMP_CALLBACK:
 		(*cb_proc)(cb_arg);
