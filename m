Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbYAIXdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbYAIXdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbYAIXa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:30:58 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:57461 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866AbYAIXaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:30:52 -0500
Message-Id: <20080109233045.092952789@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jan 2008 18:29:32 -0500
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
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 18/22 -v2] Sort trace by timestamp
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

Index: linux-compile-i386.git/lib/tracing/tracer.c
===================================================================
--- linux-compile-i386.git.orig/lib/tracing/tracer.c	2008-01-09 14:35:58.000000000 -0500
+++ linux-compile-i386.git/lib/tracing/tracer.c	2008-01-09 15:17:25.000000000 -0500
@@ -59,7 +59,6 @@ mctracer_add_trace_entry(struct mctracer
 		atomic_inc(&data->underrun);
 
 	entry = data->trace + idx * MCTRACER_ENTRY_SIZE;
-	entry->idx	 = atomic_inc_return(&tr->cnt);
 	entry->ip	 = ip;
 	entry->parent_ip = parent_ip;
 	entry->pid	 = tsk->pid;
@@ -142,7 +141,7 @@ static void *find_next_entry(struct mctr
 		if (!tr->data[i]->trace)
 			continue;
 		ent = mctracer_entry_idx(tr, iter->next_idx[i], i);
-		if (ent && (!next || next->idx > ent->idx)) {
+		if (ent && (!next || next->t > ent->t)) {
 			next = ent;
 			next_i = i;
 		}
Index: linux-compile-i386.git/lib/tracing/tracer.h
===================================================================
--- linux-compile-i386.git.orig/lib/tracing/tracer.h	2008-01-09 14:35:11.000000000 -0500
+++ linux-compile-i386.git/lib/tracing/tracer.h	2008-01-09 15:17:24.000000000 -0500
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
