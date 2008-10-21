Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbYJUQnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbYJUQnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYJUQnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:43:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43258 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYJUQnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:43:05 -0400
Message-Id: <20081021164302.575069241@goodmis.org>
References: <20081021164018.889518687@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 21 Oct 2008 12:40:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ftrace: release functions from hash
Content-Disposition: inline; filename=ftrace-release-funcs-from-hash.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 architecture uses a static recording of mcount caller locations
and is not affected by this patch.

For architectures still using the dynamic ftrace daemon, this patch is
critical. It removes the race between the recording of a function that
calls mcount, the unloading of a module, and the ftrace daemon updating
the call sites.

This patch adds the releasing of the hash functions that the daemon uses
to update the mcount call sites. When a module is unloaded, not only
are the replaced call site table update, but now so is the hash recorded
functions that the ftrace daemon will use.

Again, architectures that implement MCOUNT_RECORD are not affected by
this (which currently only x86 has).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

Index: linux-compile.git/kernel/trace/ftrace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/ftrace.c	2008-10-21 09:34:51.000000000 -0400
+++ linux-compile.git/kernel/trace/ftrace.c	2008-10-21 10:31:24.000000000 -0400
@@ -164,10 +164,14 @@ static DEFINE_SPINLOCK(ftrace_hash_lock)
 #define ftrace_hash_lock(flags)	  spin_lock_irqsave(&ftrace_hash_lock, flags)
 #define ftrace_hash_unlock(flags) \
 			spin_unlock_irqrestore(&ftrace_hash_lock, flags)
+static void ftrace_release_hash(unsigned long start, unsigned long end);
 #else
 /* This is protected via the ftrace_lock with MCOUNT_RECORD. */
 #define ftrace_hash_lock(flags)   do { (void)(flags); } while (0)
 #define ftrace_hash_unlock(flags) do { } while(0)
+static inline void ftrace_release_hash(unsigned long start, unsigned long end)
+{
+}
 #endif
 
 /*
@@ -354,6 +358,8 @@ void ftrace_release(void *start, unsigne
 		}
 	}
 	spin_unlock(&ftrace_lock);
+
+	ftrace_release_hash(s, e);
 }
 
 static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
@@ -1686,6 +1692,44 @@ void __init ftrace_init(void)
 	ftrace_disabled = 1;
 }
 #else /* CONFIG_FTRACE_MCOUNT_RECORD */
+
+static void ftrace_release_hash(unsigned long start, unsigned long end)
+{
+	struct dyn_ftrace *rec;
+	struct hlist_node *t, *n;
+	struct hlist_head *head, temp_list;
+	unsigned long flags;
+	int i, cpu;
+
+	preempt_disable_notrace();
+
+	/* disable incase we call something that calls mcount */
+	cpu = raw_smp_processor_id();
+	per_cpu(ftrace_shutdown_disable_cpu, cpu)++;
+
+	ftrace_hash_lock(flags);
+
+	for (i = 0; i < FTRACE_HASHSIZE; i++) {
+		INIT_HLIST_HEAD(&temp_list);
+		head = &ftrace_hash[i];
+
+		/* all CPUS are stopped, we are safe to modify code */
+		hlist_for_each_entry_safe(rec, t, n, head, node) {
+			if (rec->flags & FTRACE_FL_FREE)
+				continue;
+
+			if ((rec->ip >= start) && (rec->ip < end))
+				ftrace_free_rec(rec);
+		}
+	}
+
+	ftrace_hash_unlock(flags);
+
+	per_cpu(ftrace_shutdown_disable_cpu, cpu)--;
+	preempt_enable_notrace();
+
+}
+
 static int ftraced(void *ignore)
 {
 	unsigned long usecs;

-- 
