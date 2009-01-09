Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbZAIKpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbZAIKpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZAIKpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:45:34 -0500
Received: from ozlabs.org ([203.10.76.45]:44259 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbZAIKpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:45:33 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18791.10951.466371.793369@cargo.ozlabs.ibm.com>
Date: Fri, 9 Jan 2009 21:45:27 +1100
From: Paul Mackerras <paulus@samba.org>
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/9] perf_counter: Fix the cpu_clock software counter
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bug fix

Currently if you do (e.g.) timec -e -1 ls, it will report 0 for the
value of the cpu_clock counter.  The reason is that the core assumes
that a counter's count field is up-to-date when the counter is inactive,
and doesn't call the counter's read function.  However, the cpu_clock
counter code only updates the count in the read function.

This fixes it by making both the read and disable functions update the
count.  It also makes the counter ignore time passing while the counter
is disabled, by making the enable function update the hw.prev_count field.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 4be1a8d..b7a027a 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -928,18 +928,32 @@ static const struct file_operations perf_fops = {
 
 static int cpu_clock_perf_counter_enable(struct perf_counter *counter)
 {
+	int cpu = raw_smp_processor_id();
+
+	atomic64_set(&counter->hw.prev_count, cpu_clock(cpu));
 	return 0;
 }
 
+static void cpu_clock_perf_counter_update(struct perf_counter *counter)
+{
+	int cpu = raw_smp_processor_id();
+	s64 prev;
+	u64 now;
+
+	now = cpu_clock(cpu);
+	prev = atomic64_read(&counter->hw.prev_count);
+	atomic64_set(&counter->hw.prev_count, now);
+	atomic64_add(now - prev, &counter->count);
+}
+
 static void cpu_clock_perf_counter_disable(struct perf_counter *counter)
 {
+	cpu_clock_perf_counter_update(counter);
 }
 
 static void cpu_clock_perf_counter_read(struct perf_counter *counter)
 {
-	int cpu = raw_smp_processor_id();
-
-	atomic64_set(&counter->count, cpu_clock(cpu));
+	cpu_clock_perf_counter_update(counter);
 }
 
 static const struct hw_perf_counter_ops perf_ops_cpu_clock = {
