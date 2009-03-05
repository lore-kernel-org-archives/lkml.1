Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbZCEXZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbZCEXZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbZCEXZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:25:24 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:33347 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329AbZCEXZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:25:22 -0500
Message-Id: <20090305225520.225493443@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:48:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 38/41] Markers examples API update
Content-Disposition: inline; filename=markers-examples-api-update.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 samples/markers/marker-example.c |    4 ++--
 samples/markers/probe-example.c  |   10 ++++++----
 samples/markers/test-multi.c     |    4 ++--
 3 files changed, 10 insertions(+), 8 deletions(-)

Index: linux-2.6-lttng/samples/markers/marker-example.c
===================================================================
--- linux-2.6-lttng.orig/samples/markers/marker-example.c	2009-02-06 14:45:12.000000000 -0500
+++ linux-2.6-lttng/samples/markers/marker-example.c	2009-02-06 15:40:05.000000000 -0500
@@ -19,10 +19,10 @@ static int my_open(struct inode *inode, 
 {
 	int i;
 
-	trace_mark(subsystem_event, "integer %d string %s", 123,
+	trace_mark(samples, subsystem_event, "integer %d string %s", 123,
 		"example string");
 	for (i = 0; i < 10; i++)
-		trace_mark(subsystem_eventb, MARK_NOARGS);
+		trace_mark(samples, subsystem_eventb, MARK_NOARGS);
 	return -EPERM;
 }
 
Index: linux-2.6-lttng/samples/markers/probe-example.c
===================================================================
--- linux-2.6-lttng.orig/samples/markers/probe-example.c	2009-02-06 14:45:12.000000000 -0500
+++ linux-2.6-lttng/samples/markers/probe-example.c	2009-02-06 15:40:05.000000000 -0500
@@ -20,7 +20,8 @@ struct probe_data {
 	marker_probe_func *probe_func;
 };
 
-void probe_subsystem_event(void *probe_data, void *call_data,
+void probe_subsystem_event(const struct marker *mdata,
+	void *probe_data, void *call_data,
 	const char *format, va_list *args)
 {
 	/* Declare args */
@@ -39,7 +40,8 @@ void probe_subsystem_event(void *probe_d
 
 atomic_t eventb_count = ATOMIC_INIT(0);
 
-void probe_subsystem_eventb(void *probe_data, void *call_data,
+void probe_subsystem_eventb(const struct marker *mdata,
+	void *probe_data, void *call_data,
 	const char *format, va_list *args)
 {
 	/* Increment counter */
@@ -62,7 +64,7 @@ static int __init probe_init(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
-		result = marker_probe_register(probe_array[i].name,
+		result = marker_probe_register("samples", probe_array[i].name,
 				probe_array[i].format,
 				probe_array[i].probe_func, &probe_array[i]);
 		if (result)
@@ -77,7 +79,7 @@ static void __exit probe_fini(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(probe_array); i++)
-		marker_probe_unregister(probe_array[i].name,
+		marker_probe_unregister("samples", probe_array[i].name,
 			probe_array[i].probe_func, &probe_array[i]);
 	printk(KERN_INFO "Number of event b : %u\n",
 			atomic_read(&eventb_count));
Index: linux-2.6-lttng/samples/markers/test-multi.c
===================================================================
--- linux-2.6-lttng.orig/samples/markers/test-multi.c	2009-02-06 15:39:59.000000000 -0500
+++ linux-2.6-lttng/samples/markers/test-multi.c	2009-02-06 15:40:05.000000000 -0500
@@ -81,7 +81,7 @@ static int __init probe_init(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
-		result = marker_probe_register(probe_array[i].name,
+		result = marker_probe_register("samples", probe_array[i].name,
 				probe_array[i].format,
 				probe_array[i].probe_func, (void*)(long)i);
 		if (result)
@@ -97,7 +97,7 @@ static void __exit probe_fini(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
-		result = marker_probe_unregister(probe_array[i].name,
+		result = marker_probe_unregister("samples", probe_array[i].name,
 			probe_array[i].probe_func, (void*)(long)i);
 		if (result)
 			printk(KERN_INFO "Unable to unregister probe %s\n",

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
