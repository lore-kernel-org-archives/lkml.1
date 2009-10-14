Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbZJNGFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbZJNGFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbZJNGFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:05:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:58666 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480AbZJNGDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:31 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/16] percpu: make percpu symbols in oprofile unique
Date: Wed, 14 Oct 2009 15:01:55 +0900
Message-Id: <1255500125-3210-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates percpu related symbols in oprofile such that percpu
symbols are unique and don't clash with local symbols.  This serves
two purposes of decreasing the possibility of global percpu symbol
collision and allowing dropping per_cpu__ prefix from percpu symbols.

* drivers/oprofile/cpu_buffer.c: s/cpu_buffer/op_cpu_buffer/

Partly based on Rusty Russell's "alloc_percpu: rename percpu vars
which cause name clashes" patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Robert Richter <robert.richter@amd.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/oprofile/cpu_buffer.c     |   19 +++++++++----------
 drivers/oprofile/cpu_buffer.h     |    4 ++--
 drivers/oprofile/oprofile_stats.c |    4 ++--
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index a7aae24..166b67e 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -47,7 +47,7 @@
  */
 static struct ring_buffer *op_ring_buffer_read;
 static struct ring_buffer *op_ring_buffer_write;
-DEFINE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
+DEFINE_PER_CPU(struct oprofile_cpu_buffer, op_cpu_buffer);
 
 static void wq_sync_buffer(struct work_struct *work);
 
@@ -61,8 +61,7 @@ unsigned long oprofile_get_cpu_buffer_size(void)
 
 void oprofile_cpu_buffer_inc_smpl_lost(void)
 {
-	struct oprofile_cpu_buffer *cpu_buf
-		= &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
 
 	cpu_buf->sample_lost_overflow++;
 }
@@ -95,7 +94,7 @@ int alloc_cpu_buffers(void)
 		goto fail;
 
 	for_each_possible_cpu(i) {
-		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
+		struct oprofile_cpu_buffer *b = &per_cpu(op_cpu_buffer, i);
 
 		b->last_task = NULL;
 		b->last_is_kernel = -1;
@@ -122,7 +121,7 @@ void start_cpu_work(void)
 	work_enabled = 1;
 
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
+		struct oprofile_cpu_buffer *b = &per_cpu(op_cpu_buffer, i);
 
 		/*
 		 * Spread the work by 1 jiffy per cpu so they dont all
@@ -139,7 +138,7 @@ void end_cpu_work(void)
 	work_enabled = 0;
 
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
+		struct oprofile_cpu_buffer *b = &per_cpu(op_cpu_buffer, i);
 
 		cancel_delayed_work(&b->work);
 	}
@@ -330,7 +329,7 @@ static inline void
 __oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 			  unsigned long event, int is_kernel)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
 	unsigned long backtrace = oprofile_backtrace_depth;
 
 	/*
@@ -375,7 +374,7 @@ oprofile_write_reserve(struct op_entry *entry, struct pt_regs * const regs,
 {
 	struct op_sample *sample;
 	int is_kernel = !user_mode(regs);
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
 
 	cpu_buf->sample_received++;
 
@@ -430,13 +429,13 @@ int oprofile_write_commit(struct op_entry *entry)
 
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
 	log_sample(cpu_buf, pc, 0, is_kernel, event);
 }
 
 void oprofile_add_trace(unsigned long pc)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
 
 	if (!cpu_buf->tracing)
 		return;
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index 272995d..68ea16a 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -50,7 +50,7 @@ struct oprofile_cpu_buffer {
 	struct delayed_work work;
 };
 
-DECLARE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
+DECLARE_PER_CPU(struct oprofile_cpu_buffer, op_cpu_buffer);
 
 /*
  * Resets the cpu buffer to a sane state.
@@ -60,7 +60,7 @@ DECLARE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
  */
 static inline void op_cpu_buffer_reset(int cpu)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);
+	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(op_cpu_buffer, cpu);
 
 	cpu_buf->last_is_kernel = -1;
 	cpu_buf->last_task = NULL;
diff --git a/drivers/oprofile/oprofile_stats.c b/drivers/oprofile/oprofile_stats.c
index 61689e8..917d28e 100644
--- a/drivers/oprofile/oprofile_stats.c
+++ b/drivers/oprofile/oprofile_stats.c
@@ -23,7 +23,7 @@ void oprofile_reset_stats(void)
 	int i;
 
 	for_each_possible_cpu(i) {
-		cpu_buf = &per_cpu(cpu_buffer, i);
+		cpu_buf = &per_cpu(op_cpu_buffer, i);
 		cpu_buf->sample_received = 0;
 		cpu_buf->sample_lost_overflow = 0;
 		cpu_buf->backtrace_aborted = 0;
@@ -51,7 +51,7 @@ void oprofile_create_stats_files(struct super_block *sb, struct dentry *root)
 		return;
 
 	for_each_possible_cpu(i) {
-		cpu_buf = &per_cpu(cpu_buffer, i);
+		cpu_buf = &per_cpu(op_cpu_buffer, i);
 		snprintf(buf, 10, "cpu%d", i);
 		cpudir = oprofilefs_mkdir(sb, dir, buf);
 
-- 
1.6.4.2

