Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbZAWA21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbZAWA21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 19:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758818AbZAWA2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 19:28:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230AbZAWA2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 19:28:00 -0500
Date: Thu, 22 Jan 2009 19:27:58 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace, lockdep: manual preempt count adding for
 local_bh_disable
In-Reply-To: <alpine.DEB.1.10.0901221714030.5838@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0901221926540.5838@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901221523400.5838@gandalf.stny.rr.com> <1232658518.4739.3.camel@laptop> <alpine.DEB.1.10.0901221714030.5838@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (1):
      trace, lockdep: manual preempt count adding for local_bh_disable

----
 include/linux/sched.h |    2 ++
 kernel/sched.c        |    8 ++++----
 kernel/softirq.c      |   13 ++++++++++++-
 3 files changed, 18 insertions(+), 5 deletions(-)
---------------------------
commit f635d8460f544ffa64c8456f53356c28960ee46f
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Jan 22 19:01:40 2009 -0500

    trace, lockdep: manual preempt count adding for local_bh_disable
    
    Impact: fix to preempt trace triggering lockdep check_flag failure
    
    In local_bh_disable, the use of add_preempt_count causes the
    preempt tracer to start recording the time preemption is off.
    But because it already modified the preempt_count to show
    softirqs disabled, and before it called the lockdep code to
    handle this, it causes a state that lockdep can not handle.
    
    The preempt tracer will reset the ring buffer on start of a trace,
    and the ring buffer reset code does a spin_lock_irqsave. This
    calls into lockdep and lockdep will fail when it detects the
    invalid state of having softirqs disabled but the internal
    current->softirqs_enabled is still set.
    
    The fix is to manually add the SOFTIRQ_OFFSET to preempt count
    and call the preempt tracer code outside the lockdep critical
    area.
    
    Thanks to Peter Zijlstra for suggesting this solution.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5305e61..8545057 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -138,6 +138,8 @@ extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_active(void);
 extern unsigned long nr_iowait(void);
 
+extern unsigned long get_parent_ip(unsigned long addr);
+
 struct seq_file;
 struct cfs_rq;
 struct task_group;
diff --git a/kernel/sched.c b/kernel/sched.c
index d7ae5f4..440a6b1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4559,10 +4559,7 @@ void scheduler_tick(void)
 #endif
 }
 
-#if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
-				defined(CONFIG_PREEMPT_TRACER))
-
-static inline unsigned long get_parent_ip(unsigned long addr)
+unsigned long get_parent_ip(unsigned long addr)
 {
 	if (in_lock_functions(addr)) {
 		addr = CALLER_ADDR2;
@@ -4572,6 +4569,9 @@ static inline unsigned long get_parent_ip(unsigned long addr)
 	return addr;
 }
 
+#if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
+				defined(CONFIG_PREEMPT_TRACER))
+
 void __kprobes add_preempt_count(int val)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7e93870..3dd0d13 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -21,6 +21,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/rcupdate.h>
+#include <linux/ftrace.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
 
@@ -79,13 +80,23 @@ static void __local_bh_disable(unsigned long ip)
 	WARN_ON_ONCE(in_irq());
 
 	raw_local_irq_save(flags);
-	add_preempt_count(SOFTIRQ_OFFSET);
+	/*
+	 * The preempt tracer hooks into add_preempt_count and will break
+	 * lockdep because it calls back into lockdep after SOFTIRQ_OFFSET
+	 * is set and before current->softirq_enabled is cleared.
+	 * We must manually increment preempt_count here and manually
+	 * call the trace_preempt_off later.
+	 */
+	preempt_count() += SOFTIRQ_OFFSET;
 	/*
 	 * Were softirqs turned off above:
 	 */
 	if (softirq_count() == SOFTIRQ_OFFSET)
 		trace_softirqs_off(ip);
 	raw_local_irq_restore(flags);
+
+	if (preempt_count() == SOFTIRQ_OFFSET)
+		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 }
 #else /* !CONFIG_TRACE_IRQFLAGS */
 static inline void __local_bh_disable(unsigned long ip)


