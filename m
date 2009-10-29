Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbZJ2WWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbZJ2WWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbZJ2WWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:22:43 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:35623 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721AbZJ2WWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:22:42 -0400
Date: Fri, 30 Oct 2009 03:52:40 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [RFC Patch 5/5] PERF-HW_HBKPT: Display kernel symbol-name along
	with perf output
Message-ID: <20091029222240.GF14906@in.ibm.com>
References: <20091029220551.166918079@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=perf_hbkpt_ksymname_05
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the kernel symbol to be shown when perf statistics are reported. This
enables the user to quickly recognise the hit counter with the symbol to which
it corresponds to.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 tools/perf/builtin-report.c    |    4 ++--
 tools/perf/util/parse-events.c |   18 +++++++++++-------
 tools/perf/util/parse-events.h |    2 +-
 3 files changed, 14 insertions(+), 10 deletions(-)

Index: linux-2.6-tip.perf_hbkpt/tools/perf/util/parse-events.c
===================================================================
--- linux-2.6-tip.perf_hbkpt.orig/tools/perf/util/parse-events.c
+++ linux-2.6-tip.perf_hbkpt/tools/perf/util/parse-events.c
@@ -285,15 +285,14 @@ static char *event_cache_name(u8 cache_t
 
 const char *event_name(int counter)
 {
-	u64 config = attrs[counter].config;
-	int type = attrs[counter].type;
-
-	return __event_name(type, config);
+	return __event_name(&attrs[counter]);
 }
 
-const char *__event_name(int type, u64 config)
+const char *__event_name(const struct perf_event_attr *attr)
 {
-	static char buf[32];
+	int type = attr->type;
+	u64 config = attr->config;
+	static char buf[256];
 
 	if (type == PERF_TYPE_RAW) {
 		sprintf(buf, "raw 0x%llx", config);
@@ -336,7 +335,12 @@ const char *__event_name(int type, u64 c
 		return tracepoint_id_to_name(config);
 
 	case PERF_TYPE_BREAKPOINT:
-		return hbp_event_names[config];
+		/*
+		 * Separate the breakpoint event from the kernel symbol
+		 * using a ":" symbol
+		 */
+		sprintf(buf, "%s:%s", hbp_event_names[config], attr->ksym_name);
+			return buf;
 
 	default:
 		break;
Index: linux-2.6-tip.perf_hbkpt/tools/perf/util/parse-events.h
===================================================================
--- linux-2.6-tip.perf_hbkpt.orig/tools/perf/util/parse-events.h
+++ linux-2.6-tip.perf_hbkpt/tools/perf/util/parse-events.h
@@ -20,7 +20,7 @@ extern struct perf_event_attr attrs[MAX_
 extern char *filters[MAX_COUNTERS];
 
 extern const char *event_name(int ctr);
-extern const char *__event_name(int type, u64 config);
+extern const char *__event_name(const struct perf_event_attr *attr);
 
 extern int parse_events(const struct option *opt, const char *str, int unset);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
Index: linux-2.6-tip.perf_hbkpt/tools/perf/builtin-report.c
===================================================================
--- linux-2.6-tip.perf_hbkpt.orig/tools/perf/builtin-report.c
+++ linux-2.6-tip.perf_hbkpt/tools/perf/builtin-report.c
@@ -849,7 +849,7 @@ process_read_event(event_t *event, unsig
 	attr = perf_header__find_attr(event->read.id, header);
 
 	if (show_threads) {
-		const char *name = attr ? __event_name(attr->type, attr->config)
+		const char *name = attr ? __event_name(attr)
 				   : "unknown";
 		perf_read_values_add_value(&show_threads_values,
 					   event->read.pid, event->read.tid,
@@ -863,7 +863,7 @@ process_read_event(event_t *event, unsig
 			(void *)(long)(event->header.size),
 			event->read.pid,
 			event->read.tid,
-			attr ? __event_name(attr->type, attr->config)
+			attr ? __event_name(attr)
 			     : "FAIL",
 			event->read.value);
 

