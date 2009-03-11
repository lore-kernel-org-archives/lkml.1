Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbZCKB0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbZCKB0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 21:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbZCKB0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 21:26:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39271 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZCKB0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 21:26:45 -0400
Date: Tue, 10 Mar 2009 21:26:41 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL] tracing: use raw spinlocks for trace_vprintk
Message-ID: <alpine.DEB.2.00.0903102125250.16494@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (1):
      tracing: use raw spinlocks for trace_vprintk

----
 kernel/trace/trace.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)
---------------------------
commit 80370cb758e7ca2692cd9fb5e413d970b1f4b2b2
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Mar 10 17:16:35 2009 -0400

    tracing: use raw spinlocks for trace_vprintk
    
    Impact: prevent locking up by lockdep tracer
    
    The lockdep tracer uses trace_vprintk and thus trace_vprintk can not
    call back into lockdep without locking up.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8c6a902..4c97947 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1176,7 +1176,8 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
  */
 int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 {
-	static DEFINE_SPINLOCK(trace_buf_lock);
+	static raw_spinlock_t trace_buf_lock =
+		(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	static u32 trace_buf[TRACE_BUF_SIZE];
 
 	struct ring_buffer_event *event;
@@ -1201,7 +1202,9 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 	if (unlikely(atomic_read(&data->disabled)))
 		goto out;
 
-	spin_lock_irqsave(&trace_buf_lock, flags);
+	/* Lockdep uses trace_printk for lock tracing */
+	local_irq_save(flags);
+	__raw_spin_lock(&trace_buf_lock);
 	len = vbin_printf(trace_buf, TRACE_BUF_SIZE, fmt, args);
 
 	if (len > TRACE_BUF_SIZE || len < 0)
@@ -1220,7 +1223,8 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 	ring_buffer_unlock_commit(tr->buffer, event);
 
 out_unlock:
-	spin_unlock_irqrestore(&trace_buf_lock, flags);
+	__raw_spin_unlock(&trace_buf_lock);
+	local_irq_restore(flags);
 
 out:
 	ftrace_preempt_enable(resched);

