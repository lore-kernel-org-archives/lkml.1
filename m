Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZDUJL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZDUJL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbZDUJLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:11:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61636 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbZDUJLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:11:15 -0400
Message-ID: <49ED8DEB.6000700@cn.fujitsu.com>
Date: Tue, 21 Apr 2009 17:12:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] tracing/filters: allow user-input to be integer-like
 string
References: <49ED8DD2.2070700@cn.fujitsu.com>
In-Reply-To: <49ED8DD2.2070700@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppose we would like to trace all tasks named '123', but this
will fail:
 # echo 'parent_comm == 123' > events/sched/sched_process_fork/filter
 bash: echo: write error: Invalid argument

Don't guess the type of the filter pred in filter_parse(), but instead
we check it in __filter_add_pred().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index e0fcfd2..6541828 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -313,6 +313,7 @@ static int __filter_add_pred(struct ftrace_event_call *call,
 {
 	struct ftrace_event_field *field;
 	filter_pred_fn_t fn;
+	unsigned long long val;
 
 	field = find_event_field(call, pred->field_name);
 	if (!field)
@@ -322,14 +323,13 @@ static int __filter_add_pred(struct ftrace_event_call *call,
 	pred->offset = field->offset;
 
 	if (is_string_field(field->type)) {
-		if (!pred->str_len)
-			return -EINVAL;
 		fn = filter_pred_string;
 		pred->str_len = field->size;
 		return filter_add_pred_fn(call, pred, fn);
 	} else {
-		if (pred->str_len)
+		if (strict_strtoull(pred->str_val, 0, &val))
 			return -EINVAL;
+		pred->val = val;
 	}
 
 	switch (field->size) {
@@ -413,12 +413,16 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
 	return 0;
 }
 
+/*
+ * The filter format can be
+ *   - 0, which means remove all filter preds
+ *   - [||/&&] <field> ==/!= <val>
+ */
 int filter_parse(char **pbuf, struct filter_pred *pred)
 {
-	char *tmp, *tok, *val_str = NULL;
+	char *tok, *val_str = NULL;
 	int tok_n = 0;
 
-	/* field ==/!= number, or/and field ==/!= number, number */
 	while ((tok = strsep(pbuf, " \n"))) {
 		if (tok_n == 0) {
 			if (!strcmp(tok, "0")) {
@@ -478,19 +482,13 @@ int filter_parse(char **pbuf, struct filter_pred *pred)
 		return -EINVAL;
 	}
 
+	strcpy(pred->str_val, val_str);
+	pred->str_len = strlen(val_str);
+
 	pred->field_name = kstrdup(pred->field_name, GFP_KERNEL);
 	if (!pred->field_name)
 		return -ENOMEM;
 
-	pred->str_len = 0;
-	pred->val = simple_strtoull(val_str, &tmp, 0);
-	if (tmp == val_str) {
-		strncpy(pred->str_val, val_str, MAX_FILTER_STR_VAL);
-		pred->str_len = strlen(val_str);
-		pred->str_val[pred->str_len] = '\0';
-	} else if (*tmp != '\0')
-		return -EINVAL;
-
 	return 0;
 }
 
-- 
1.5.4.rc3

