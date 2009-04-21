Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbZDUKJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbZDUKJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbZDUKJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:09:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:42157 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbZDUKJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:09:24 -0400
Date: Tue, 21 Apr 2009 10:08:23 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49ED8DEB.6000700@cn.fujitsu.com>
References: <49ED8DEB.6000700@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/filters: allow user-input to be integer-like string
Message-ID: <tip-f66578a7637b87810cbb9041c4e3a77fd2fa4706@git.kernel.org>
Git-Commit-ID: f66578a7637b87810cbb9041c4e3a77fd2fa4706
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 10:08:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f66578a7637b87810cbb9041c4e3a77fd2fa4706
Gitweb:     http://git.kernel.org/tip/f66578a7637b87810cbb9041c4e3a77fd2fa4706
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 21 Apr 2009 17:12:11 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Apr 2009 11:58:28 +0200

tracing/filters: allow user-input to be integer-like string

Suppose we would like to trace all tasks named '123', but this
will fail:

 # echo 'parent_comm == 123' > events/sched/sched_process_fork/filter
 bash: echo: write error: Invalid argument

Don't guess the type of the filter pred in filter_parse(), but instead
we check it in __filter_add_pred().

[ Impact: extend allowed filter field string values ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49ED8DEB.6000700@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
 
