Return-Path: <linux-kernel-owner+w=401wt.eu-S933630AbZINUsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbZINUsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbZINUsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:48:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933567AbZINUsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:48:01 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes 5/6] tracing/kprobes: Fix profiling alignment
	for perf_counter buffer
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>
Date: Mon, 14 Sep 2009 16:49:28 -0400
Message-ID: <20090914204928.18779.60029.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix *probe_profile_func() to align buffer size, since pref_counter requires.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
