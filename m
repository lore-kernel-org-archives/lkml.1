Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZIXTtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZIXTtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbZIXTtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:49:51 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:54837 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbZIXTtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:49:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QeIfhXpZu5/P0tF3DN2hiQV/dWwWpQsNfYa74yJsM2uaZnbX3OYxTS5uPVbD83IeLT
         qN0z6ZlPy0OMLOuLj2ZZm7msKaihsTh8RtM2FnJNxS6PEdi0wDVDEHW1r/tZVJ95rWrh
         xcWzJK/+X1H1NeD6IEHYvAYQF2SDHnj+ofEQ8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 5/5] tracing/filters: Unify the regex parsing helpers
Date: Thu, 24 Sep 2009 21:49:35 +0200
Message-Id: <1253821775-8618-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The filter code has stolen the regex parsing function from ftrace to
get the regex support.
We have duplicated this code, so factorize it in the filter area and
make it generally available, as the filter code is the most suited to
host this feature.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c              |   64 +++---------------------------------
 kernel/trace/trace.h               |    9 +++++
 kernel/trace/trace_events_filter.c |   20 +++++------
 3 files changed, 23 insertions(+), 70 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cc615f8..ddf23a2 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1655,60 +1655,6 @@ ftrace_regex_lseek(struct file *file, loff_t offset, int origin)
 	return ret;
 }
 
-enum {
-	MATCH_FULL,
-	MATCH_FRONT_ONLY,
-	MATCH_MIDDLE_ONLY,
-	MATCH_END_ONLY,
-};
-
-/*
- * (static function - no need for kernel doc)
- *
- * Pass in a buffer containing a glob and this function will
- * set search to point to the search part of the buffer and
- * return the type of search it is (see enum above).
- * This does modify buff.
- *
- * Returns enum type.
- *  search returns the pointer to use for comparison.
- *  not returns 1 if buff started with a '!'
- *     0 otherwise.
- */
-static int
-ftrace_setup_glob(char *buff, int len, char **search, int *not)
-{
-	int type = MATCH_FULL;
-	int i;
-
-	if (buff[0] == '!') {
-		*not = 1;
-		buff++;
-		len--;
-	} else
-		*not = 0;
-
-	*search = buff;
-
-	for (i = 0; i < len; i++) {
-		if (buff[i] == '*') {
-			if (!i) {
-				*search = buff + 1;
-				type = MATCH_END_ONLY;
-			} else {
-				if (type == MATCH_END_ONLY)
-					type = MATCH_MIDDLE_ONLY;
-				else
-					type = MATCH_FRONT_ONLY;
-				buff[i] = 0;
-				break;
-			}
-		}
-	}
-
-	return type;
-}
-
 static int ftrace_match(char *str, char *regex, int len, int type)
 {
 	int matched = 0;
@@ -1757,7 +1703,7 @@ static void ftrace_match_records(char *buff, int len, int enable)
 	int not;
 
 	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
-	type = ftrace_setup_glob(buff, len, &search, &not);
+	type = filter_parse_regex(buff, len, &search, &not);
 
 	search_len = strlen(search);
 
@@ -1825,7 +1771,7 @@ static void ftrace_match_module_records(char *buff, char *mod, int enable)
 	}
 
 	if (strlen(buff)) {
-		type = ftrace_setup_glob(buff, strlen(buff), &search, &not);
+		type = filter_parse_regex(buff, strlen(buff), &search, &not);
 		search_len = strlen(search);
 	}
 
@@ -1990,7 +1936,7 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	int count = 0;
 	char *search;
 
-	type = ftrace_setup_glob(glob, strlen(glob), &search, &not);
+	type = filter_parse_regex(glob, strlen(glob), &search, &not);
 	len = strlen(search);
 
 	/* we do not support '!' for function probes */
@@ -2067,7 +2013,7 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	else if (glob) {
 		int not;
 
-		type = ftrace_setup_glob(glob, strlen(glob), &search, &not);
+		type = filter_parse_regex(glob, strlen(glob), &search, &not);
 		len = strlen(search);
 
 		/* we do not support '!' for function probes */
@@ -2520,7 +2466,7 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 		return -ENODEV;
 
 	/* decode regex */
-	type = ftrace_setup_glob(buffer, strlen(buffer), &search, &not);
+	type = filter_parse_regex(buffer, strlen(buffer), &search, &not);
 	if (not)
 		return -EINVAL;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8d0db60..db6b83e 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -709,6 +709,13 @@ typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event,
 
 typedef int (*regex_match_func)(char *str, struct regex *r, int len);
 
+enum regex_type {
+	MATCH_FULL,
+	MATCH_FRONT_ONLY,
+	MATCH_MIDDLE_ONLY,
+	MATCH_END_ONLY,
+};
+
 struct regex {
 	char			pattern[MAX_FILTER_STR_VAL];
 	int			len;
@@ -727,6 +734,8 @@ struct filter_pred {
 	int 			pop_n;
 };
 
+extern enum regex_type
+filter_parse_regex(char *buff, int len, char **search, int *not);
 extern void print_event_filter(struct ftrace_event_call *call,
 			       struct trace_seq *s);
 extern int apply_event_filter(struct ftrace_event_call *call,
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index d3c94c1..8c194de 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -279,15 +279,14 @@ static int regex_match_end(char *str, struct regex *r, int len)
 	return 0;
 }
 
-enum regex_type {
-	MATCH_FULL,
-	MATCH_FRONT_ONLY,
-	MATCH_MIDDLE_ONLY,
-	MATCH_END_ONLY,
-};
-
-/*
- * Pass in a buffer containing a regex and this function will
+/**
+ * filter_parse_regex - parse a basic regex
+ * @buff:   the raw regex
+ * @len:    length of the regex
+ * @search: will point to the beginning of the string to compare
+ * @not:    tell whether the match will have to be inverted
+ *
+ * This passes in a buffer containing a regex and this function will
  * set search to point to the search part of the buffer and
  * return the type of search it is (see enum above).
  * This does modify buff.
@@ -297,8 +296,7 @@ enum regex_type {
  *  not returns 1 if buff started with a '!'
  *     0 otherwise.
  */
-static enum regex_type
-filter_parse_regex(char *buff, int len, char **search, int *not)
+enum regex_type filter_parse_regex(char *buff, int len, char **search, int *not)
 {
 	int type = MATCH_FULL;
 	int i;
-- 
1.6.2.3

