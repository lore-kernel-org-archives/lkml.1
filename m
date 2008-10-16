Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbYJPNbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbYJPNbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 09:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYJPNba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 09:31:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52934 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYJPNba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 09:31:30 -0400
Date: Thu, 16 Oct 2008 09:31:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ftrace: release functions from hash
Message-ID: <alpine.DEB.1.10.0810160930350.8868@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
 kernel/trace/ftrace.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-10-16 08:52:36.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-10-16 08:52:54.000000000 -0400
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
@@ -347,6 +351,7 @@ void ftrace_release(void *start, unsigne
 	}
 	spin_unlock(&ftrace_lock);
 
+	ftrace_release_hash(s, e);
 }
 
 static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
@@ -1659,6 +1664,44 @@ void __init ftrace_init(void)
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

