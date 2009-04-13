Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbZDMChi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbZDMChi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 22:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZDMCha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 22:37:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60431 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbZDMCh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 22:37:29 -0400
Message-ID: <49E2A594.4060306@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 10:38:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tracing/filters: allow user-input to be integer-like
 string
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
we check it in filter_add_pred().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 9f8ecca..a63f965 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -229,6 +229,7 @@ static int is_string_field(const char *type)
 int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
 {
 	struct ftrace_event_field *field;
+	unsigned long long val;
 
 	field = find_event_field(call, pred->field_name);
 	if (!field)
@@ -237,14 +238,14 @@ int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
 	pred->offset = field->offset;
 
 	if (is_string_field(field->type)) {
-		if (!pred->str_val)
-			return -EINVAL;
 		pred->fn = filter_pred_string;
 		pred->str_len = field->size;
 		return __filter_add_pred(call, pred);
 	} else {
-		if (pred->str_val)
+		if (strict_strtoull(pred->str_val, 0, &val))
 			return -EINVAL;
+		pred->val = val;
+		kfree(pred->str_val);
 	}
 
 	switch (field->size) {
@@ -351,12 +352,16 @@ oom:
 	return -ENOMEM;
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
@@ -419,15 +424,10 @@ int filter_parse(char **pbuf, struct filter_pred *pred)
 	if (!pred->field_name)
 		return -ENOMEM;
 
-	pred->val = simple_strtoull(val_str, &tmp, 0);
-	if (tmp == val_str) {
-		pred->str_val = kstrdup(val_str, GFP_KERNEL);
-		if (!pred->str_val)
-			return -ENOMEM;
-	} else if (*tmp != '\0')
-		return -EINVAL;
+	pred->str_val = kstrdup(val_str, GFP_KERNEL);
+	if (!pred->str_val)
+		return -ENOMEM;
 
 	return 0;
 }
 
-
-- 
1.5.4.rc3

