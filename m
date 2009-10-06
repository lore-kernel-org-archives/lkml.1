Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbZJFGKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbZJFGKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbZJFGKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:10:51 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:57832 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469AbZJFGKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:10:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IKpTU6igZDkWg13k0uIxt0ej2fY2+dWXPTvqwiwBO5CZhMxpvd60auZ+HyAMP1X5SC
         DK8F2lPWVjaCMWVxpigyM5WFARUuc64pPWzDjR4HL42MKfOqr8gA72WAau4qs7ZhEriP
         KW8uWdusm6tGSkT/qnSjhrQIUi/QRybzb0hBQ=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
Subject: [RFC][PATCH 4/9] perf trace: Add trace scripting ops
Date: Tue,  6 Oct 2009 01:09:53 -0500
Message-Id: <1254809398-8078-5-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support any number of scripting languages for trace stream processing
by adding a set of functions, trace_scripting_operations, that can be
implemented to support a given language.

- start_script() - initialize e.g. create and initialize the interpreter
- stop_script() - clean up e.g. destroy the interpreter
- process_event() - send each event and its data to the interpreter

Support for a given language should also modify setup_scripting() to
replace the do-nothing default_scripting_ops with the
language-specific scripting ops for that language.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c    |   53 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/trace-event.h |    7 +++++
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 5d4c84d..a654a5a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -27,6 +27,37 @@ static struct thread	*last_match;
 static struct perf_header *header;
 static u64		sample_type;
 
+static char		const *script_name;
+
+static int default_start_script(const char *script __attribute((unused)))
+{
+	return 0;
+}
+
+static int default_stop_script(void)
+{
+	return 0;
+}
+
+static struct trace_scripting_operations default_scripting_ops = {
+	.start_script = default_start_script,
+	.stop_script = default_stop_script,
+	.process_event = print_event,
+};
+
+static struct trace_scripting_operations *scripting_ops;
+
+static int setup_scripting(const char *script __attribute((unused)))
+{
+	scripting_ops = &default_scripting_ops;
+
+	return 0;
+}
+
+static int cleanup_scripting(void)
+{
+	return scripting_ops->stop_script();
+}
 
 static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
@@ -105,7 +136,8 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		 * field, although it should be the same than this perf
 		 * event pid
 		 */
-		print_event(cpu, raw->data, raw->size, timestamp, thread->comm);
+		scripting_ops->process_event(cpu, raw->data, raw->size,
+					     timestamp, thread->comm);
 	}
 	total += period;
 
@@ -239,11 +271,15 @@ static const struct option options[] = {
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
+	OPT_STRING('s', "script", &script_name, "file",
+		    "script file name"),
 	OPT_END()
 };
 
 int cmd_trace(int argc, const char **argv, const char *prefix __used)
 {
+	int err;
+
 	symbol__init();
 	page_size = getpagesize();
 
@@ -259,5 +295,18 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 
 	setup_pager();
 
-	return __cmd_trace();
+	err = setup_scripting(script_name);
+	if (err)
+		goto out;
+
+	if (script_name) {
+		err = scripting_ops->start_script(script_name);
+		goto out;
+	}
+
+	err = __cmd_trace();
+
+	cleanup_scripting();
+out:
+	return err;
 }
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 5f59a39..449c23d 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -246,4 +246,11 @@ void *raw_field_ptr(struct event *event, const char *name, void *data);
 
 void read_tracing_data(struct perf_event_attr *pattrs, int nb_events);
 
+struct trace_scripting_operations {
+	int (*start_script) (const char *);
+	int (*stop_script) (void);
+	void (*process_event) (int cpu, void *data, int size,
+			       unsigned long long nsecs, char *comm);
+};
+
 #endif /* __PERF_TRACE_EVENTS_H */
-- 
1.6.4.GIT

