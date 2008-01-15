Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbYAOUzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbYAOUzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757401AbYAOUus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:50:48 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:63798 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbYAOUuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:35 -0500
Message-Id: <20080115205023.081474130@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:18 -0500
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
Subject: [RFC PATCH 11/30 v3] Reset the tracer when started
Content-Disposition: inline; filename=mcount-tracer-clear-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch resets the trace when it is started by the user.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/tracer.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-compile.git/lib/tracing/tracer.c
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.c	2008-01-14 13:14:13.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.c	2008-01-14 14:57:54.000000000 -0500
@@ -88,6 +88,16 @@ static struct mcount_ops trace_ops __rea
 	.func = trace_function,
 };
 
+static notrace void mctracer_reset(struct mctracer_trace *tr)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		tr->trace_idx[cpu] = 0;
+		atomic_set(&tr->underrun[cpu], 0);
+	}
+}
+
 #ifdef CONFIG_DEBUG_FS
 enum trace_iterator {
 	TRACE_ITER_SYM_ONLY	= 1,
@@ -334,6 +344,10 @@ static ssize_t mctracer_ctrl_write(struc
 
 	val = !!simple_strtoul(buf, NULL, 10);
 
+	/* When starting a new trace, reset the buffers */
+	if (val)
+		mctracer_reset(tr);
+
 	if (tr->ctrl ^ val) {
 		if (val)
 			trace_enabled = 1;

-- 
