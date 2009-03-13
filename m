Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbZCMLC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbZCMLC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758632AbZCMLCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:02:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:39017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758625AbZCMLCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:02:04 -0400
Date: Fri, 13 Mar 2009 11:01:15 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313104218.A30096@sedona.ch.intel.com>
References: <20090313104218.A30096@sedona.ch.intel.com>
Subject: [tip:tracing/hw-branch-tracing] x86, bts: cleanups
Message-ID: <tip-e9a22d1fb94050b7d600019c32e6b672d539054b@git.kernel.org>
Git-Commit-ID: e9a22d1fb94050b7d600019c32e6b672d539054b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 11:01:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9a22d1fb94050b7d600019c32e6b672d539054b
Gitweb:     http://git.kernel.org/tip/e9a22d1fb94050b7d600019c32e6b672d539054b
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 13 Mar 2009 11:54:40 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 11:57:22 +0100

x86, bts: cleanups

Impact: cleanup, no code changed

Cc: Markus Metzger <markus.t.metzger@intel.com>
LKML-Reference: <20090313104218.A30096@sedona.ch.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds.c             |  142 +++++++++++++++++++++-----------------
 arch/x86/kernel/ds_selftest.h    |    2 +-
 kernel/trace/trace_hw_branches.c |    6 +-
 kernel/trace/trace_selftest.c    |    5 +-
 4 files changed, 87 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index d9cab71..7363e01 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -19,43 +19,52 @@
  * Markus Metzger <markus.t.metzger@intel.com>, 2007-2009
  */
 
-
-#include <asm/ds.h>
-
-#include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/slab.h>
+#include <linux/errno.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/kernel.h>
+
+#include <asm/ds.h>
 
 #include "ds_selftest.h"
 
 /*
- * The configuration for a particular DS hardware implementation.
+ * The configuration for a particular DS hardware implementation:
  */
 struct ds_configuration {
-	/* The name of the configuration. */
-	const char *name;
-	/* The size of pointer-typed fields in DS, BTS, and PEBS. */
-	unsigned char  sizeof_ptr_field;
-	/* The size of a BTS/PEBS record in bytes. */
-	unsigned char  sizeof_rec[2];
-	/* Control bit-masks indexed by enum ds_feature. */
-	unsigned long ctl[dsf_ctl_max];
+	/* The name of the configuration: */
+	const char		*name;
+
+	/* The size of pointer-typed fields in DS, BTS, and PEBS: */
+	unsigned char		sizeof_ptr_field;
+
+	/* The size of a BTS/PEBS record in bytes: */
+	unsigned char		sizeof_rec[2];
+
+	/* Control bit-masks indexed by enum ds_feature: */
+	unsigned long		ctl[dsf_ctl_max];
 };
 static DEFINE_PER_CPU(struct ds_configuration, ds_cfg_array);
 
 #define ds_cfg per_cpu(ds_cfg_array, smp_processor_id())
 
-#define MAX_SIZEOF_DS (12 * 8)	/* Maximal size of a DS configuration. */
-#define MAX_SIZEOF_BTS (3 * 8)	/* Maximal size of a BTS record. */
-#define DS_ALIGNMENT (1 << 3)	/* BTS and PEBS buffer alignment. */
+/* Maximal size of a DS configuration: */
+#define MAX_SIZEOF_DS		(12 * 8)
 
-#define BTS_CONTROL \
- (ds_cfg.ctl[dsf_bts] | ds_cfg.ctl[dsf_bts_kernel] | ds_cfg.ctl[dsf_bts_user] |\
-  ds_cfg.ctl[dsf_bts_overflow])
+/* Maximal size of a BTS record: */
+#define MAX_SIZEOF_BTS		(3 * 8)
 
+/* BTS and PEBS buffer alignment: */
+#define DS_ALIGNMENT		(1 << 3)
+
+/* Mask of control bits in the DS MSR register: */
+#define BTS_CONTROL				  \
+	( ds_cfg.ctl[dsf_bts]			| \
+	  ds_cfg.ctl[dsf_bts_kernel]		| \
+	  ds_cfg.ctl[dsf_bts_user]		| \
+	  ds_cfg.ctl[dsf_bts_overflow] )
 
 /*
  * A BTS or PEBS tracer.
@@ -65,28 +74,32 @@ static DEFINE_PER_CPU(struct ds_configuration, ds_cfg_array);
  */
 struct ds_tracer {
 	/* The DS context (partially) owned by this tracer. */
-	struct ds_context *context;
+	struct ds_context	*context;
 	/* The buffer provided on ds_request() and its size in bytes. */
-	void *buffer;
-	size_t size;
+	void			*buffer;
+	size_t			size;
 };
 
 struct bts_tracer {
-	/* The common DS part. */
-	struct ds_tracer ds;
-	/* The trace including the DS configuration. */
-	struct bts_trace trace;
-	/* Buffer overflow notification function. */
-	bts_ovfl_callback_t ovfl;
+	/* The common DS part: */
+	struct ds_tracer	ds;
+
+	/* The trace including the DS configuration: */
+	struct bts_trace	trace;
+
+	/* Buffer overflow notification function: */
+	bts_ovfl_callback_t	ovfl;
 };
 
 struct pebs_tracer {
-	/* The common DS part. */
-	struct ds_tracer ds;
-	/* The trace including the DS configuration. */
-	struct pebs_trace trace;
-	/* Buffer overflow notification function. */
-	pebs_ovfl_callback_t ovfl;
+	/* The common DS part: */
+	struct ds_tracer	ds;
+
+	/* The trace including the DS configuration: */
+	struct pebs_trace	trace;
+
+	/* Buffer overflow notification function: */
+	pebs_ovfl_callback_t	ovfl;
 };
 
 /*
@@ -95,6 +108,7 @@ struct pebs_tracer {
  *
  * The DS configuration consists of the following fields; different
  * architetures vary in the size of those fields.
+ *
  * - double-word aligned base linear address of the BTS buffer
  * - write pointer into the BTS buffer
  * - end linear address of the BTS buffer (one byte beyond the end of
@@ -133,19 +147,20 @@ enum ds_field {
 };
 
 enum ds_qualifier {
-	ds_bts  = 0,
+	ds_bts = 0,
 	ds_pebs
 };
 
-static inline unsigned long ds_get(const unsigned char *base,
-				   enum ds_qualifier qual, enum ds_field field)
+static inline unsigned long
+ds_get(const unsigned char *base, enum ds_qualifier qual, enum ds_field field)
 {
 	base += (ds_cfg.sizeof_ptr_field * (field + (4 * qual)));
 	return *(unsigned long *)base;
 }
 
-static inline void ds_set(unsigned char *base, enum ds_qualifier qual,
-			  enum ds_field field, unsigned long value)
+static inline void
+ds_set(unsigned char *base, enum ds_qualifier qual, enum ds_field field,
+       unsigned long value)
 {
 	base += (ds_cfg.sizeof_ptr_field * (field + (4 * qual)));
 	(*(unsigned long *)base) = value;
@@ -157,7 +172,6 @@ static inline void ds_set(unsigned char *base, enum ds_qualifier qual,
  */
 static DEFINE_SPINLOCK(ds_lock);
 
-
 /*
  * We either support (system-wide) per-cpu or per-thread allocation.
  * We distinguish the two based on the task_struct pointer, where a
@@ -211,17 +225,21 @@ static inline int check_tracer(struct task_struct *task)
  * deallocated when the last user puts the context.
  */
 struct ds_context {
-	/* The DS configuration; goes into MSR_IA32_DS_AREA. */
-	unsigned char ds[MAX_SIZEOF_DS];
-	/* The owner of the BTS and PEBS configuration, respectively. */
-	struct bts_tracer *bts_master;
-	struct pebs_tracer *pebs_master;
-	/* Use count. */
+	/* The DS configuration; goes into MSR_IA32_DS_AREA: */
+	unsigned char		ds[MAX_SIZEOF_DS];
+
+	/* The owner of the BTS and PEBS configuration, respectively: */
+	struct bts_tracer	*bts_master;
+	struct pebs_tracer	*pebs_master;
+
+	/* Use count: */
 	unsigned long count;
-	/* Pointer to the context pointer field. */
-	struct ds_context **this;
-	/* The traced task; NULL for current cpu. */
-	struct task_struct *task;
+
+	/* Pointer to the context pointer field: */
+	struct ds_context	**this;
+
+	/* The traced task; NULL for current cpu: */
+	struct task_struct	*task;
 };
 
 static DEFINE_PER_CPU(struct ds_context *, system_context_array);
@@ -328,9 +346,9 @@ static void ds_overflow(struct ds_context *context, enum ds_qualifier qual)
  * The remainder of any partially written record is zeroed out.
  *
  * context: the DS context
- * qual: the buffer type
- * record: the data to write
- * size: the size of the data
+ * qual:    the buffer type
+ * record:  the data to write
+ * size:    the size of the data
  */
 static int ds_write(struct ds_context *context, enum ds_qualifier qual,
 		    const void *record, size_t size)
@@ -429,12 +447,12 @@ enum bts_field {
 	bts_to,
 	bts_flags,
 
-	bts_qual = bts_from,
-	bts_jiffies = bts_to,
-	bts_pid = bts_flags,
+	bts_qual		= bts_from,
+	bts_jiffies		= bts_to,
+	bts_pid			= bts_flags,
 
-	bts_qual_mask = (bts_qual_max - 1),
-	bts_escape = ((unsigned long)-1 & ~bts_qual_mask)
+	bts_qual_mask		= (bts_qual_max - 1),
+	bts_escape		= ((unsigned long)-1 & ~bts_qual_mask)
 };
 
 static inline unsigned long bts_get(const char *base, enum bts_field field)
@@ -461,8 +479,8 @@ static inline void bts_set(char *base, enum bts_field field, unsigned long val)
  *
  * return: bytes read/written on success; -Eerrno, otherwise
  */
-static int bts_read(struct bts_tracer *tracer, const void *at,
-		    struct bts_struct *out)
+static int
+bts_read(struct bts_tracer *tracer, const void *at, struct bts_struct *out)
 {
 	if (!tracer)
 		return -EINVAL;
diff --git a/arch/x86/kernel/ds_selftest.h b/arch/x86/kernel/ds_selftest.h
index 0e6e19d..2ba8745 100644
--- a/arch/x86/kernel/ds_selftest.h
+++ b/arch/x86/kernel/ds_selftest.h
@@ -12,4 +12,4 @@ extern int ds_selftest_pebs(void);
 #else
 static inline int ds_selftest_bts(void) { return 0; }
 static inline int ds_selftest_pebs(void) { return 0; }
-#endif /* CONFIG_X86_DS_SELFTEST */
+#endif
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index 4ca8270..8b2109a 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -1,5 +1,5 @@
 /*
- * h/w branch tracer for x86 based on bts
+ * h/w branch tracer for x86 based on BTS
  *
  * Copyright (C) 2008-2009 Intel Corporation.
  * Markus Metzger <markus.t.metzger@gmail.com>, 2008-2009
@@ -15,8 +15,8 @@
 
 #include <asm/ds.h>
 
-#include "trace.h"
 #include "trace_output.h"
+#include "trace.h"
 
 
 #define BTS_BUFFER_SIZE (1 << 13)
@@ -197,10 +197,10 @@ static void bts_trace_print_header(struct seq_file *m)
 
 static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
 {
+	unsigned long symflags = TRACE_ITER_SYM_OFFSET;
 	struct trace_entry *entry = iter->ent;
 	struct trace_seq *seq = &iter->seq;
 	struct hw_branch_entry *it;
-	unsigned long symflags = TRACE_ITER_SYM_OFFSET;
 
 	trace_assign_type(it, entry);
 
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 3c7b797..b910912 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -189,6 +189,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 #else
 # define trace_selftest_startup_dynamic_tracing(trace, tr, func) ({ 0; })
 #endif /* CONFIG_DYNAMIC_FTRACE */
+
 /*
  * Simple verification test of ftrace function tracer.
  * Enable ftrace, sleep 1/10 second, and then read the trace
@@ -698,10 +699,10 @@ int
 trace_selftest_startup_hw_branches(struct tracer *trace,
 				   struct trace_array *tr)
 {
-	unsigned long count;
-	int ret;
 	struct trace_iterator iter;
 	struct tracer tracer;
+	unsigned long count;
+	int ret;
 
 	if (!trace->open) {
 		printk(KERN_CONT "missing open function...");
