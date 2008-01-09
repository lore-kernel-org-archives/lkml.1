Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbYAIXfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbYAIXfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbYAIXbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:31:09 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:37804 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbYAIXay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:30:54 -0500
Message-Id: <20080109233043.974444280@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jan 2008 18:29:25 -0500
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
Subject: [RFC PATCH 11/22 -v2] Reset the tracer when started
Content-Disposition: inline; filename=mcount-tracer-clear-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch resets the trace when it is started by the user.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/tracer.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-compile-i386.git/lib/tracing/tracer.c
===================================================================
--- linux-compile-i386.git.orig/lib/tracing/tracer.c	2008-01-09 14:14:02.000000000 -0500
+++ linux-compile-i386.git/lib/tracing/tracer.c	2008-01-09 15:17:36.000000000 -0500
@@ -78,6 +78,16 @@ static notrace void trace_function(const
 	raw_local_irq_restore(flags);
 }
 
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
@@ -324,6 +334,10 @@ static ssize_t mctracer_ctrl_write(struc
 
 	val = !!simple_strtoul(buf, NULL, 10);
 
+	/* When starting a new trace, reset the buffers */
+	if (val)
+		mctracer_reset(tr);
+
 	if (tr->ctrl ^ val) {
 		if (val)
 			register_mcount_function(trace_function);

-- 
