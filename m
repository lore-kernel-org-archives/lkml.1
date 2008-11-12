Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYKLVsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYKLVsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYKLVsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:48:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:49778 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbYKLVsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:48:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=oRMV14Q+SRQNHJahzh0BKa8vJXzKuo32PYnq8yatefRPTJUrqPGwEEuhVRgIf65+yN
         noV5uuPGRU/LXopGgc51Z0iYDF7bC/HWbjkOxBE2NYRcseQlJ71rkQ+aHDwfWziuhG4o
         mLD9VcgAODiTlcyBDYy9ePIHRsWdAvL+HpWdY=
Message-ID: <491B4F0A.3080901@gmail.com>
Date: Wed, 12 Nov 2008 22:47:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] tracing/function-return-tracer: Make the function return
 tracer lockless
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: remove spinlocks and irq disabling in function return tracer.

I've tried to figure out all of the race condition that could happen when
the tracer pushes or pops a return address trace to/from the current
thread_info.

Theory:

_ One thread can only execute on one cpu at a time. So this code doesn't need
  to be SMP-safe. Just drop the spinlock.
_ The only race could happen between the current thread and an interrupt. If an
  interrupt is raised, it will increase the index of the return stack storage and
  then execute until the end of the tracing to finally free the index it used.
  We don't need to disable irqs.

This is theorical. In practice, I've tested it with a two-core SMP and had no
problem at all. Perhaps -tip testing could confirm it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c |   43 +++++--------------------------------------
 1 files changed, 5 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 16a571d..1db0e12 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -44,62 +44,37 @@ void ftrace_nmi_exit(void)
 	atomic_dec(&in_nmi);
 }
 
-/*
- * Synchronize accesses to return adresses stack with
- * interrupts.
- */
-static raw_spinlock_t ret_stack_lock;
-
 /* Add a function return address to the trace stack on thread info.*/
 static int push_return_trace(unsigned long ret, unsigned long long time,
 				unsigned long func)
 {
 	int index;
-	struct thread_info *ti;
-	unsigned long flags;
-	int err = 0;
-
-	raw_local_irq_save(flags);
-	__raw_spin_lock(&ret_stack_lock);
+	struct thread_info *ti = current_thread_info();
 
-	ti = current_thread_info();
 	/* The return trace stack is full */
-	if (ti->curr_ret_stack == FTRACE_RET_STACK_SIZE - 1) {
-		err = -EBUSY;
-		goto out;
-	}
+	if (ti->curr_ret_stack == FTRACE_RET_STACK_SIZE - 1)
+		return -EBUSY;
 
 	index = ++ti->curr_ret_stack;
 	ti->ret_stack[index].ret = ret;
 	ti->ret_stack[index].func = func;
 	ti->ret_stack[index].calltime = time;
 
-out:
-	__raw_spin_unlock(&ret_stack_lock);
-	raw_local_irq_restore(flags);
-	return err;
+	return 0;
 }
 
 /* Retrieve a function return address to the trace stack on thread info.*/
 static void pop_return_trace(unsigned long *ret, unsigned long long *time,
 				unsigned long *func)
 {
-	struct thread_info *ti;
 	int index;
-	unsigned long flags;
-
-	raw_local_irq_save(flags);
-	__raw_spin_lock(&ret_stack_lock);
 
-	ti = current_thread_info();
+	struct thread_info *ti = current_thread_info();
 	index = ti->curr_ret_stack;
 	*ret = ti->ret_stack[index].ret;
 	*func = ti->ret_stack[index].func;
 	*time = ti->ret_stack[index].calltime;
 	ti->curr_ret_stack--;
-
-	__raw_spin_unlock(&ret_stack_lock);
-	raw_local_irq_restore(flags);
 }
 
 /*
@@ -175,14 +150,6 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		*parent = old;
 }
 
-static int __init init_ftrace_function_return(void)
-{
-	ret_stack_lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-	return 0;
-}
-device_initcall(init_ftrace_function_return);
-
-
 #endif
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-- 
1.5.2.5
