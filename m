Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbYAIXhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbYAIXhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbYAIXbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:31:16 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:53984 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbYAIXax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:30:53 -0500
Message-Id: <20080109233045.251234302@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jan 2008 18:29:33 -0500
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
Subject: [RFC PATCH 19/22 -v2] speed up the output of the tracer
Content-Disposition: inline; filename=mcount-tracer-speed-output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current method of printing out the trace is on every
read, do a linear search for the next entry to print.
This patch remembers the next entry to look at in the
iterator, and if the next read is sequential, it can
start reading from the next location.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/tracer.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

Index: linux-compile-i386.git/lib/tracing/tracer.c
===================================================================
--- linux-compile-i386.git.orig/lib/tracing/tracer.c	2008-01-09 14:37:13.000000000 -0500
+++ linux-compile-i386.git/lib/tracing/tracer.c	2008-01-09 15:17:24.000000000 -0500
@@ -105,6 +105,7 @@ enum trace_iterator {
 struct mctracer_iterator {
 	struct mctracer_trace *tr;
 	struct mctracer_entry *ent;
+	loff_t pos;
 	unsigned long next_idx[NR_CPUS];
 	int cpu;
 	int idx;
@@ -176,6 +177,8 @@ static void *s_next(struct seq_file *m, 
 	while (ent && iter->idx < i)
 		ent = find_next_entry(iter);
 
+	iter->pos = *pos;
+
 	return ent;
 }
 
@@ -186,19 +189,25 @@ static void *s_start(struct seq_file *m,
 	loff_t l = 0;
 	int i;
 
-	iter->ent = NULL;
-	iter->cpu = 0;
-	iter->idx = -1;
-
-	for (i = 0; i < NR_CPUS; i++)
-		iter->next_idx[i] = 0;
-
 	/* stop the trace while dumping */
 	if (iter->tr->ctrl)
 		clear_mcount_function();
 
-	for (p = iter; p && l < *pos; p = s_next(m, p, &l))
-		;
+	if (*pos != iter->pos) {
+		iter->ent = NULL;
+		iter->cpu = 0;
+		iter->idx = -1;
+
+		for (i = 0; i < NR_CPUS; i++)
+			iter->next_idx[i] = 0;
+
+		for (p = iter; p && l < *pos; p = s_next(m, p, &l))
+			;
+
+	} else {
+		l = *pos;
+		p = s_next(m, p, &l);
+	}
 
 	return p;
 }
@@ -286,6 +295,7 @@ static int mctrace_open(struct inode *in
 		return -ENOMEM;
 
 	iter->tr = &mctracer_trace;
+	iter->pos = -1;
 
 	/* TODO stop tracer */
 	ret = seq_open(file, &mctrace_seq_ops);

-- 
