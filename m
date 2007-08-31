Return-Path: <linux-kernel-owner+w=401wt.eu-S1763495AbXHaF2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763495AbXHaF2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 01:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbXHaF2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 01:28:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbXHaF2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 01:28:47 -0400
Message-ID: <46D7A71A.7050800@redhat.com>
Date: Fri, 31 Aug 2007 00:28:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] detect & print stack overruns at oops time
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In thinking about the 4KSTACKS + STACKOVERFLOW problems, I thought
about this - if an oops occurs, explicitly print whether the current
esp is now overrunning the stack, whether the thread has ever overrun
the stack, else print the max stack excursion for the oopsing thread,
if DEBUG_STACK_USAGE is enabled.

1) maybe printing the info for a non-blown stack is not useful..
2) current esp past end of stack can already be deduced, but this
   makes it more plain...
3) if the initialization of end_of_stack is problematic for
   any reason, it could be removed and the "did we ever overrun"
   test could be moved under the DEBUG_STACK_USAGE ifdef

Thoughts?  This is a separate problem from the piggy dump_stack()
path, but it seems to me it might be useful in looking at stack-related
oopses when they do occur.  With this change, it seems feasible
to turn off DEBUG_STACKOVERFLOW, turn on DEBUG_STACK_USAGE, and just
get the bad news when it's actually happened.  :) 

Thanks,
-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.22-rc4/arch/i386/mm/fault.c
===================================================================
--- linux-2.6.22-rc4.orig/arch/i386/mm/fault.c
+++ linux-2.6.22-rc4/arch/i386/mm/fault.c
@@ -525,6 +525,8 @@ no_context:
 
 	if (oops_may_print()) {
 		__typeof__(pte_val(__pte(0))) page;
+		unsigned long *stackend = end_of_stack(tsk);
+		int overrun;
 
 #ifdef CONFIG_X86_PAE
 		if (error_code & 16) {
@@ -543,6 +545,27 @@ no_context:
 			printk(KERN_ALERT "BUG: unable to handle kernel paging"
 					" request");
 		printk(" at virtual address %08lx\n",address);
+
+		overrun = (unsigned long)stackend - (unsigned long)(&regs->esp);
+		if (overrun > 0) {
+			printk(KERN_ALERT "Thread overrunning stack by %d "
+							"bytes\n", overrun);
+		} else {
+#ifdef CONFIG_DEBUG_STACK_USAGE
+			int free;
+			unsigned long *n = stackend;
+			while (!*n)
+				n++;
+			free = (unsigned long)n - (unsigned long)stackend;
+			if (free)
+				printk(KERN_ALERT "Thread used within %d bytes"
+					" of stack end\n", free);
+#endif
+			/* won't catch 100% - stack may have 0s here by chance */
+			if (*stackend)  /* was init'd to 0 */
+				printk(KERN_ALERT "Thread overran the stack?\n");
+		}
+
 		printk(KERN_ALERT " printing eip:\n");
 		printk("%08lx\n", regs->eip);
 
Index: linux-2.6.22-rc4/kernel/fork.c
===================================================================
--- linux-2.6.22-rc4.orig/kernel/fork.c
+++ linux-2.6.22-rc4/kernel/fork.c
@@ -163,6 +163,7 @@ static struct task_struct *dup_task_stru
 {
 	struct task_struct *tsk;
 	struct thread_info *ti;
+	unsigned long *stackend;
 
 	prepare_to_copy(orig);
 
@@ -179,6 +180,8 @@ static struct task_struct *dup_task_stru
 	*tsk = *orig;
 	tsk->stack = ti;
 	setup_thread_stack(tsk, orig);
+	stackend = end_of_stack(tsk);
+	*stackend = 0;	/* for overflow detection */
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 	tsk->stack_canary = get_random_int();

