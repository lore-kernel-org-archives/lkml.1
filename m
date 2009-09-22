Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbZIVTkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbZIVTkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZIVTkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:40:10 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:39120 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbZIVTjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:39:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TWpVmk15zPuFHwyYiiNqFQ6utoORFgg+uzjtDCxPILCNSP9T9zbZAmjq8o+MiwulbK
         QqOxrnj2u5V7Sihl9PIL3oEm9CAiHTbGQRIZzcSSrAzVkB1AP2nwm2U3odghqCUvmw++
         6pMwBuG4L53teB+CFaZ5wQjvyzgNHOdJmV63E=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 22/24] tracing/kprobes: Fix profiling alignment for perf_counter buffer
Date: Tue, 22 Sep 2009 21:38:20 +0200
Message-Id: <1253648302-5771-23-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

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
-- 
1.6.2.3

