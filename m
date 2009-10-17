Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZJQKC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZJQKC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbZJQKC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:02:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:36487 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbZJQKCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:02:25 -0400
Date: Sat, 17 Oct 2009 10:01:41 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <20090914204928.18779.60029.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090914204928.18779.60029.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] tracing/kprobes: Fix profiling alignment for perf_counter buffer
Message-ID: <tip-74ebb63e7cd25f6fb02a45fc2ea7735bce1217c9@git.kernel.org>
Git-Commit-ID: 74ebb63e7cd25f6fb02a45fc2ea7735bce1217c9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:01:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74ebb63e7cd25f6fb02a45fc2ea7735bce1217c9
Gitweb:     http://git.kernel.org/tip/74ebb63e7cd25f6fb02a45fc2ea7735bce1217c9
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 14 Sep 2009 16:49:28 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 17 Sep 2009 04:03:57 +0200

tracing/kprobes: Fix profiling alignment for perf_counter buffer

Fix *probe_profile_func() to align buffer size, since perf_counter
requires its buffer entries to be 8 bytes aligned.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20090914204928.18779.60029.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_kprobe.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 70b632c..d8db935 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1149,18 +1149,23 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kprobe_trace_entry *entry;
-	int size, i, pc;
+	int size, __size, i, pc;
 	unsigned long irq_flags;
 
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
+	__size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
+	size = ALIGN(__size + sizeof(u32), sizeof(u64));
+	size -= sizeof(u32);
 
 	do {
 		char raw_data[size];
 		struct trace_entry *ent;
-
+		/*
+		 * Zero dead bytes from alignment to avoid stack leak
+		 * to userspace
+		 */
 		*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
 		entry = (struct kprobe_trace_entry *)raw_data;
 		ent = &entry->ent;
@@ -1183,13 +1188,15 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kretprobe_trace_entry *entry;
-	int size, i, pc;
+	int size, __size, i, pc;
 	unsigned long irq_flags;
 
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	size = SIZEOF_KRETPROBE_TRACE_ENTRY(tp->nr_args);
+	__size = SIZEOF_KRETPROBE_TRACE_ENTRY(tp->nr_args);
+	size = ALIGN(__size + sizeof(u32), sizeof(u64));
+	size -= sizeof(u32);
 
 	do {
 		char raw_data[size];
