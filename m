Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbYDVDpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbYDVDpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 23:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbYDVDp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 23:45:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbYDVDp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 23:45:26 -0400
Message-ID: <480D5F27.1030101@redhat.com>
Date: Mon, 21 Apr 2008 22:44:39 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] use canary at end of stack to indicate overruns at oops time
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a canary at the end of the stack to clearly indicate
at oops time whether the stack has ever overflowed.

This is a very simple implementation with a couple of
drawbacks:

1) a thread may legitimately use exactly up to the last 
   word on the stack

 -- but the chances of doing this and then oopsing later seem slim

2) it's possible that the stack usage isn't dense enough
   that the canary location could get skipped over

 -- but the worst that happens is that we don't flag the overrun

With the code in place, an intentionally-bloated stack oops does:

BUG: unable to handle kernel paging request at ffff8103f84cc680
IP: [<ffffffff810253df>] update_curr+0x9a/0xa8
PGD 8063 PUD 0 
Thread overran stack or stack corrupted
Oops: 0000 [1] SMP 
CPU 0 
...


Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


Index: linux-2.6.25/arch/x86/mm/fault.c
===================================================================
--- linux-2.6.25.orig/arch/x86/mm/fault.c	2008-04-20 22:30:36.000000000 -0500
+++ linux-2.6.25/arch/x86/mm/fault.c	2008-04-21 16:58:18.913885442 -0500
@@ -25,6 +25,7 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
+#include <linux/magic.h>
 
 #include <asm/system.h>
 #include <asm/desc.h>
@@ -581,6 +582,8 @@ void __kprobes do_page_fault(struct pt_r
 	unsigned long address;
 	int write, si_code;
 	int fault;
+	unsigned long *stackend;
+
 #ifdef CONFIG_X86_64
 	unsigned long flags;
 #endif
@@ -850,6 +853,10 @@ no_context:
 
 	show_fault_oops(regs, error_code, address);
 
+	stackend = end_of_stack(tsk);
+	if (*stackend != STACK_END_MAGIC)
+		printk(KERN_ALERT "Thread overran stack or stack corrupted\n");
+
 	tsk->thread.cr2 = address;
 	tsk->thread.trap_no = 14;
 	tsk->thread.error_code = error_code;
Index: linux-2.6.25/include/linux/magic.h
===================================================================
--- linux-2.6.25.orig/include/linux/magic.h	2008-01-24 16:58:37.000000000 -0600
+++ linux-2.6.25/include/linux/magic.h	2008-04-21 16:53:47.838406992 -0500
@@ -42,4 +42,5 @@
 #define FUTEXFS_SUPER_MAGIC	0xBAD1DEA
 #define INOTIFYFS_SUPER_MAGIC	0x2BAD1DEA
 
+#define STACK_END_MAGIC		0x57AC6E9D
 #endif /* __LINUX_MAGIC_H__ */
Index: linux-2.6.25/kernel/fork.c
===================================================================
--- linux-2.6.25.orig/kernel/fork.c	2008-04-21 16:49:49.000000000 -0500
+++ linux-2.6.25/kernel/fork.c	2008-04-21 16:54:22.039406916 -0500
@@ -53,6 +53,7 @@
 #include <linux/tty.h>
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
+#include <linux/magic.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -167,6 +168,8 @@ static struct task_struct *dup_task_stru
 {
 	struct task_struct *tsk;
 	struct thread_info *ti;
+	unsigned long *stackend;
+
 	int err;
 
 	prepare_to_copy(orig);
@@ -192,6 +195,8 @@ static struct task_struct *dup_task_stru
 	}
 
 	setup_thread_stack(tsk, orig);
+	stackend = end_of_stack(tsk);
+	*stackend = STACK_END_MAGIC;	/* for overflow detection */
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 	tsk->stack_canary = get_random_int();



