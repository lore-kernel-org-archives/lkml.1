Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZECBvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZECBvA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 21:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbZECBuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 21:50:39 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:61475 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbZECBui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 21:50:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H1/uPQFOkWD7ZOmzTS18vvPqHytaFHJ3qsxj9krlJJrcP8LXKwaCkLbmXQAI45X3s/
         yyvFXYzaftTDYj/yXGv8gOEXDDl2X61pjtXlPnXZrBbkwFe4YA8VfGOzLWVQlqvhw3fm
         4vdEexCbZ89BFYl+zycWfKwWI5eKlBLkVvTQc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/2] tracing/filters: support for filters of dynamic sized arrays
Date: Sun,  3 May 2009 03:50:32 +0200
Message-Id: <1241315433-7225-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241315433-7225-1-git-send-email-fweisbec@gmail.com>
References: <1241315433-7225-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the filtering infrastructure supports well the
numeric types and fixed sized array types.

But the recently added __string() field uses a specific
indirect offset mechanism which requires a specific
predicate. Until now it wasn't supported.

This patch adds this support and implies very few changes,
only a new predicate is needed, the management of this specific
field can be done through the usual string helpers in the
filtering infrastructure.

[ Impact: support all kinds of strings in the tracing filters ]

Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_events_filter.c |   44 +++++++++++++++++++++++++++++++++--
 1 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index f494866..4f0a128 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -151,6 +151,7 @@ static int filter_pred_or(struct filter_pred *pred __attribute((unused)),
 	return val1 || val2;
 }
 
+/* Filter predicate for fixed sized arrays of characters */
 static int filter_pred_string(struct filter_pred *pred, void *event,
 			      int val1, int val2)
 {
@@ -164,6 +165,30 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
 	return match;
 }
 
+/*
+ * Filter predicate for dynamic sized arrays of characters.
+ * These are implemented through a list of strings at the end
+ * of the entry.
+ * Also each of these strings have a field in the entry which
+ * contains its offset from the beginning of the entry.
+ * We have then first to get this field, dereference it
+ * and add it to the address of the entry, and at last we have
+ * the address of the string.
+ */
+static int filter_pred_strloc(struct filter_pred *pred, void *event,
+			      int val1, int val2)
+{
+	int str_loc = *(int *)(event + pred->offset);
+	char *addr = (char *)(event + str_loc);
+	int cmp, match;
+
+	cmp = strncmp(addr, pred->str_val, pred->str_len);
+
+	match = (!cmp) ^ pred->not;
+
+	return match;
+}
+
 static int filter_pred_none(struct filter_pred *pred, void *event,
 			    int val1, int val2)
 {
@@ -436,10 +461,18 @@ static int filter_add_pred_fn(struct filter_parse_state *ps,
 	return 0;
 }
 
+enum {
+	FILTER_STATIC_STRING = 1,
+	FILTER_DYN_STRING
+};
+
 static int is_string_field(const char *type)
 {
 	if (strchr(type, '[') && strstr(type, "char"))
-		return 1;
+		return FILTER_STATIC_STRING;
+
+	if (!strcmp(type, "__str_loc"))
+		return FILTER_DYN_STRING;
 
 	return 0;
 }
@@ -502,6 +535,7 @@ static int filter_add_pred(struct filter_parse_state *ps,
 	struct ftrace_event_field *field;
 	filter_pred_fn_t fn;
 	unsigned long long val;
+	int string_type;
 
 	pred->fn = filter_pred_none;
 
@@ -526,8 +560,12 @@ static int filter_add_pred(struct filter_parse_state *ps,
 		return -EINVAL;
 	}
 
-	if (is_string_field(field->type)) {
-		fn = filter_pred_string;
+	string_type = is_string_field(field->type);
+	if (string_type) {
+		if (string_type == FILTER_STATIC_STRING)
+			fn = filter_pred_string;
+		else
+			fn = filter_pred_strloc;
 		pred->str_len = field->size;
 		if (pred->op == OP_NE)
 			pred->not = 1;
-- 
1.6.2.3

