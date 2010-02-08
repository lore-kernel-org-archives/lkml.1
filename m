Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab0BHWE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:04:58 -0500
Received: from smtp-out.google.com ([216.239.44.51]:8748 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab0BHWE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:04:56 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:message-id:date:from:to:x-system-of-record;
	b=wM3Io4R9fTM6fxPOLSThrk3JTdE+upuo5U3mtdKBruk32xf2IAiWSCquCGKEKVWm/
	TM4bq5oP0Cjnm5AD1zY4Q==
Subject: Race in ptrace.
Message-Id: <20100208220420.CD7189B33B@bumblebee1.mtv.corp.google.com>
Date: Mon,  8 Feb 2010 14:04:20 -0800 (PST)
From: sqazi@google.com (Salman Qazi)
To: undisclosed-recipients:;
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

A race in ptrace was pointed to us by a fellow Google engineer, Tavis
Ormandy.  The race involves interaction between a tracer, a tracee and 
an antagonist.  The tracer is tracing the tracee with PTRACE_SYSCALL and
waits on the tracee.  In the mean time, an antagonist blasts the tracee
with SIGCONTs.

The observed issue is that sometimes when the tracer attempts to continue the tracee
with PTRACE_SYSCALL, it gets a return value of -ESRCH, indicating that the tracee is already
running (or not being traced).  It turns out that a SIGCONT wakes up the
tracee in kernel mode, and for a moment the tracee's state is TASK_RUNNING
then in ptrace_stop we hit the condition where the tracee is found to be running (and thus
not traced).  If the syscall is repeated, the second time it usually 
succeeds (because by that time, the tracee has been put into TASK_TRACED).

Below is a quick and dirty fix for the one instance that I did
figure out.  Note that this doesn't completely close the race on 
2.6.33-rc6.  But on 2.6.26 it appears to be sufficient.  I suspect there 
are other code paths with similar issues:

    Fix a race in ptrace.
    
    Race description:
    
    The traced process is running for a small duration
    of time between when it is sent a SIGCONT and when it realizes that it needs
    to be asleep in order to get traced.  If during this time the tracer calls
    ptrace with PTRACE_SYSCALL, it recieves an errno value of -ESRCH.
    
    Solution:
    
    We add a new bit to the ptrace field of task_struct.  We call this PT_WAKING.
    When the process is being awoken for a SIGCONT signal, we set this bit before
    state changes to TASK_RUNNING.  When the process is about to go to sleep, we
    reset this bit after we change the state to TASK_TRACED.

Signed-off-by: Salman Qazi <sqazi@google.com>

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 56f2d63..6c6771a 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -67,8 +67,9 @@
 #define PT_TRACE_EXEC	0x00000080
 #define PT_TRACE_VFORK_DONE	0x00000100
 #define PT_TRACE_EXIT	0x00000200
+#define PT_WAKING	0x00000400
 
-#define PT_TRACE_MASK	0x000003f4
+#define PT_TRACE_MASK	0x000007f4
 
 /* single stepping state bits (used on ARM and PA-RISC) */
 #define PT_SINGLESTEP_BIT	31
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 23bd09c..32157f8 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -104,7 +104,8 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 		spin_lock_irq(&child->sighand->siglock);
 		if (task_is_stopped(child))
 			child->state = TASK_TRACED;
-		else if (!task_is_traced(child) && !kill)
+		else if (!task_is_traced(child) && !kill &&
+				(!(child->ptrace & PT_WAKING)))
 			ret = -ESRCH;
 		spin_unlock_irq(&child->sighand->siglock);
 	}
diff --git a/kernel/signal.c b/kernel/signal.c
index 934ae5e..095507e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -697,6 +697,10 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		 * and wake all threads.
 		 */
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
+		if (p->ptrace & PT_PTRACED) {
+			p->ptrace |= PT_WAKING;
+			mb();
+		}
 		t = p;
 		do {
 			unsigned int state;
@@ -1626,6 +1630,10 @@ static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
 
 	/* Let the debugger run.  */
 	__set_current_state(TASK_TRACED);
+	if (current->ptrace & PT_PTRACED) {
+		mb();
+		current->ptrace &= ~PT_WAKING;
+	}
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
 	if (may_ptrace_stop()) {
