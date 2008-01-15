Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbYAOUwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbYAOUwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757065AbYAOUui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:50:38 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:56879 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbYAOUuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:32 -0500
Message-Id: <20080115205025.368627544@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 21/30 v3] Sort trace by timestamp
Content-Disposition: inline; filename=mcount-tracer-sort-by-time.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that each entry has a reliable timestamp, we can
use the timestamp as the source of sorting the trace and
remove the atomic increment.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/tracer.c |    3 +--
 lib/tracing/tracer.h |    2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

Index: linux-compile.git/lib/tracing/tracer.c
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.c	2008-01-14 13:14:14.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.c	2008-01-14 14:57:40.000000000 -0500
@@ -60,7 +60,6 @@ mctracer_add_trace_entry(struct mctracer
 		atomic_inc(&data->underrun);
 
 	entry = data->trace + idx * MCTRACER_ENTRY_SIZE;
-	entry->idx	 = atomic_inc_return(&tr->cnt);
 	entry->ip	 = ip;
 	entry->parent_ip = parent_ip;
 	entry->pid	 = tsk->pid;
@@ -152,7 +151,7 @@ static void *find_next_entry(struct mctr
 		if (!tr->data[i]->trace)
 			continue;
 		ent = mctracer_entry_idx(tr, iter->next_idx[i], i);
-		if (ent && (!next || next->idx > ent->idx)) {
+		if (ent && (!next || next->t > ent->t)) {
 			next = ent;
 			next_i = i;
 		}
Index: linux-compile.git/lib/tracing/tracer.h
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.h	2008-01-14 13:14:14.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.h	2008-01-14 14:57:38.000000000 -0500
@@ -6,7 +6,6 @@
 
 struct mctracer_entry {
 	unsigned long long t;
-	unsigned long idx;
 	unsigned long ip;
 	unsigned long parent_ip;
 	char comm[TASK_COMM_LEN];
@@ -24,7 +23,6 @@ struct mctracer_trace {
 	unsigned long entries;
 	long	      ctrl;
 	unsigned long iter_flags;
-	atomic_t      cnt;
 	struct mctracer_trace_cpu *data[NR_CPUS];
 };
 

-- 
