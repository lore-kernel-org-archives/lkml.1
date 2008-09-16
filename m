Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYIPS44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYIPS44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbYIPS4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:56:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:24538 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbYIPS4r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:56:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=opHQjSg5/u1fhfPWJuXfzIexIYWhkGNwNSxQRum7lcO9/3vOG9YlEpGJweuifsOYkq
         rGMBhHANUFsrhmte1pgvzVDlS+MPNp3GyUQsTIRdxXnYvKnck3/1GqQmcoAQ/Mbk282I
         +i7pLJLCLSGbh8JGnN6SOgv1iQ35gaNWkmsSY=
Date: Tue, 16 Sep 2008 21:56:41 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       Pavel Roskin <proski@gnu.org>
Subject: [PATCH 2/7] ftrace: move mmiotrace functions out of trace.c.
Message-ID: <20080916215641.767840d7@daedalus.pq.iki.fi>
In-Reply-To: <20080916215416.16aee2dd@daedalus.pq.iki.fi>
References: <48B1D5CA.8000607@gmail.com>
	<c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	<20080827212130.4b8365a8@daedalus.pq.iki.fi>
	<c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	<20080828214256.296e34ec@daedalus.pq.iki.fi>
	<c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
	<20080904203058.7e57729e@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com>
	<20080915224707.76b2cca0@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809151556260.22620@gandalf.stny.rr.com>
	<20080916215416.16aee2dd@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 743cab2763d3e8d9f4d3b82a02fcdc5ad8a13c04 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sun, 14 Sep 2008 16:53:05 +0300
Subject: [PATCH] ftrace: move mmiotrace functions out of trace.c.

Moves the mmiotrace specific functions from trace.c to
trace_mmiotrace.c. Functions trace_wake_up(), tracing_get_trace_entry(),
and tracing_generic_entry_update() are therefore made available outside
trace.c.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 kernel/trace/trace.c           |   46 +--------------------------------------
 kernel/trace/trace.h           |   15 +++++-------
 kernel/trace/trace_mmiotrace.c |   42 ++++++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 53 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7e6cb4f..d372bc5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -785,7 +785,7 @@ trace_next_page(struct trace_array_cpu *data, void *addr)
 	return page_address(page);
 }
 
-static inline struct trace_entry *
+struct trace_entry *
 tracing_get_trace_entry(struct trace_array *tr, struct trace_array_cpu *data)
 {
 	unsigned long idx, idx_next;
@@ -821,7 +821,7 @@ tracing_get_trace_entry(struct trace_array *tr, struct trace_array_cpu *data)
 	return entry;
 }
 
-static inline void
+void
 tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags)
 {
 	struct task_struct *tsk = current;
@@ -865,48 +865,6 @@ ftrace(struct trace_array *tr, struct trace_array_cpu *data,
 		trace_function(tr, data, ip, parent_ip, flags);
 }
 
-#ifdef CONFIG_MMIOTRACE
-void __trace_mmiotrace_rw(struct trace_array *tr, struct trace_array_cpu *data,
-						struct mmiotrace_rw *rw)
-{
-	struct trace_entry *entry;
-	unsigned long irq_flags;
-
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-
-	entry				= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, 0);
-	entry->type			= TRACE_MMIO_RW;
-	entry->field.mmiorw		= *rw;
-
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
-
-	trace_wake_up();
-}
-
-void __trace_mmiotrace_map(struct trace_array *tr, struct trace_array_cpu *data,
-						struct mmiotrace_map *map)
-{
-	struct trace_entry *entry;
-	unsigned long irq_flags;
-
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-
-	entry				= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, 0);
-	entry->type			= TRACE_MMIO_MAP;
-	entry->field.mmiomap		= *map;
-
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
-
-	trace_wake_up();
-}
-#endif
-
 void __trace_stack(struct trace_array *tr,
 		   struct trace_array_cpu *data,
 		   unsigned long flags,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 77c265f..9d39aa0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -213,11 +213,17 @@ struct trace_iterator {
 	long			idx;
 };
 
+void trace_wake_up(void);
 void tracing_reset(struct trace_array_cpu *data);
 int tracing_open_generic(struct inode *inode, struct file *filp);
 struct dentry *tracing_init_dentry(void);
 void init_tracer_sysprof_debugfs(struct dentry *d_tracer);
 
+struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
+						struct trace_array_cpu *data);
+void tracing_generic_entry_update(struct trace_entry *entry,
+						unsigned long flags);
+
 void ftrace(struct trace_array *tr,
 			    struct trace_array_cpu *data,
 			    unsigned long ip,
@@ -291,15 +297,6 @@ extern unsigned long ftrace_update_tot_cnt;
 extern int DYN_FTRACE_TEST_NAME(void);
 #endif
 
-#ifdef CONFIG_MMIOTRACE
-extern void __trace_mmiotrace_rw(struct trace_array *tr,
-				struct trace_array_cpu *data,
-				struct mmiotrace_rw *rw);
-extern void __trace_mmiotrace_map(struct trace_array *tr,
-				struct trace_array_cpu *data,
-				struct mmiotrace_map *map);
-#endif
-
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 #ifdef CONFIG_FTRACE
 extern int trace_selftest_startup_function(struct tracer *trace,
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 9b7a936..ef02747 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -276,6 +276,27 @@ __init static int init_mmio_trace(void)
 }
 device_initcall(init_mmio_trace);
 
+static void __trace_mmiotrace_rw(struct trace_array *tr,
+				struct trace_array_cpu *data,
+				struct mmiotrace_rw *rw)
+{
+	struct trace_entry *entry;
+	unsigned long irq_flags;
+
+	raw_local_irq_save(irq_flags);
+	__raw_spin_lock(&data->lock);
+
+	entry				= tracing_get_trace_entry(tr, data);
+	tracing_generic_entry_update(entry, 0);
+	entry->type			= TRACE_MMIO_RW;
+	entry->field.mmiorw		= *rw;
+
+	__raw_spin_unlock(&data->lock);
+	raw_local_irq_restore(irq_flags);
+
+	trace_wake_up();
+}
+
 void mmio_trace_rw(struct mmiotrace_rw *rw)
 {
 	struct trace_array *tr = mmio_trace_array;
@@ -283,6 +304,27 @@ void mmio_trace_rw(struct mmiotrace_rw *rw)
 	__trace_mmiotrace_rw(tr, data, rw);
 }
 
+static void __trace_mmiotrace_map(struct trace_array *tr,
+				struct trace_array_cpu *data,
+				struct mmiotrace_map *map)
+{
+	struct trace_entry *entry;
+	unsigned long irq_flags;
+
+	raw_local_irq_save(irq_flags);
+	__raw_spin_lock(&data->lock);
+
+	entry				= tracing_get_trace_entry(tr, data);
+	tracing_generic_entry_update(entry, 0);
+	entry->type			= TRACE_MMIO_MAP;
+	entry->field.mmiomap		= *map;
+
+	__raw_spin_unlock(&data->lock);
+	raw_local_irq_restore(irq_flags);
+
+	trace_wake_up();
+}
+
 void mmio_trace_mapping(struct mmiotrace_map *map)
 {
 	struct trace_array *tr = mmio_trace_array;
-- 
1.5.6.4

