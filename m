Return-Path: <linux-kernel-owner+w=401wt.eu-S1763466AbZLQAeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763466AbZLQAeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763455AbZLQAeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:34:10 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47324 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762854AbZLQAeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:34:07 -0500
Message-ID: <4B297C79.2090004@us.ibm.com>
Date: Wed, 16 Dec 2009 16:34:01 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       "lkml, " <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] Use opaque record type in pevent accessor functions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 35c283e97c16525bbebae6f9937a1ccd0f3b8da9 Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Wed, 16 Dec 2009 15:40:31 -0800
Subject: [PATCH 1/2] Use opaque record type in pevent accessor functions

The caller of the pevent accessor functions:

	pevent_data_pid(pevent, data) for example

Already have a struct record. Let them send that directly:

	pevent_data_pid(pevent, record)

This decouples the API from the struct implementation and facilitates
language bindings which use opaque pointers for passing the C structs
around.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 parse-events.c |   14 +++++++-------
 parse-events.h |   12 ++++++++++--
 trace-cmd.h    |    8 --------
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 7112eb8..1a2c7ca 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -3081,13 +3081,13 @@ void pevent_data_lat_fmt(struct pevent *pevent,
 /**
  * pevent_data_type - parse out the given event type
  * @pevent: a handle to the pevent
- * @data: the raw data to read from
+ * @rec: the record to read from
  *
- * This returns the event id from the raw @data.
+ * This returns the event id from the @rec.
  */
-int pevent_data_type(struct pevent *pevent, void *data)
+int pevent_data_type(struct pevent *pevent, struct record *rec)
 {
-	return trace_parse_common_type(pevent, data);
+	return trace_parse_common_type(pevent, rec->data);
 }
 
 /**
@@ -3105,13 +3105,13 @@ struct event *pevent_data_event_from_type(struct pevent *pevent, int type)
 /**
  * pevent_data_pid - parse the PID from raw data
  * @pevent: a handle to the pevent
- * @data: the raw data to parse
+ * @rec: the record to parse
  *
  * This returns the PID from a raw data.
  */
-int pevent_data_pid(struct pevent *pevent, void *data)
+int pevent_data_pid(struct pevent *pevent, struct record *rec)
 {
-	return parse_common_pid(pevent, data);
+	return parse_common_pid(pevent, rec->data);
 }
 
 /**
diff --git a/parse-events.h b/parse-events.h
index 9b5ba0d..e6f5806 100644
--- a/parse-events.h
+++ b/parse-events.h
@@ -14,6 +14,14 @@
 #define TRACE_SEQ_SIZE 4096
 #endif
 
+struct record {
+	unsigned long long ts;
+	unsigned long long offset;
+	int record_size;		/* size of binary record */
+	int size;			/* size of data */
+	void *data;
+};
+
 /*
  * Trace sequences are used to allow a function to call several other functions
  * to create a string of data to use (up to a max of PAGE_SIZE).
@@ -368,9 +376,9 @@ pevent_find_event_by_name(struct pevent *pevent, const char *sys, const char *na
 
 void pevent_data_lat_fmt(struct pevent *pevent,
 			 struct trace_seq *s, void *data, int size __unused);
-int pevent_data_type(struct pevent *pevent, void *data);
+int pevent_data_type(struct pevent *pevent, struct record *rec);
 struct event *pevent_data_event_from_type(struct pevent *pevent, int type);
-int pevent_data_pid(struct pevent *pevent, void *data);
+int pevent_data_pid(struct pevent *pevent, struct record *rec);
 const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid);
 void pevent_event_info(struct trace_seq *s, struct event *event,
 		       int cpu, void *data, int size, unsigned long long nsecs);
diff --git a/trace-cmd.h b/trace-cmd.h
index d6e4db0..1c4d359 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -28,14 +28,6 @@ enum {
 #define TS_SHIFT		27
 #endif
 
-struct record {
-	unsigned long long ts;
-	unsigned long long offset;
-	int record_size;		/* size of binary record */
-	int size;			/* size of data */
-	void *data;
-};
-
 static inline void free_record(struct record *record)
 {
 	free(record);
-- 
1.6.3.3
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
