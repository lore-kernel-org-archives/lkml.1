Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZBQFTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZBQFTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbZBQFOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:14:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42053 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZBQFOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:14:10 -0500
Message-Id: <20090217051405.772028305@goodmis.org>
References: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 04/15] ftrace: break up ftrace_match_records into smaller components
Content-Disposition: inline; filename=0004-ftrace-break-up-ftrace_match_records-into-smaller-c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

ftrace_match_records does a lot of things that other features
can use. This patch breaks up ftrace_match_records and pulls
out ftrace_setup_glob and ftrace_match_record.

ftrace_setup_glob prepares a simple glob expression for use with
ftrace_match_record. ftrace_match_record compares a single record
with a glob type.

Breaking this up will allow for more features to run on individual
records.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |  115 ++++++++++++++++++++++++++++++++-----------------
 1 files changed, 75 insertions(+), 40 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f397d7a..fcec313 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1053,79 +1053,114 @@ enum {
 	MATCH_END_ONLY,
 };
 
-static void
-ftrace_match_records(unsigned char *buff, int len, int enable)
+/*
+ * (static function - no need for kernel doc)
+ *
+ * Pass in a buffer containing a glob and this function will
+ * set search to point to the search part of the buffer and
+ * return the type of search it is (see enum above).
+ * This does modify buff.
+ *
+ * Returns enum type.
+ *  search returns the pointer to use for comparison.
+ *  not returns 1 if buff started with a '!'
+ *     0 otherwise.
+ */
+static int
+ftrace_setup_glob(unsigned char *buff, int len, char **search, int *not)
 {
-	char str[KSYM_SYMBOL_LEN];
-	char *search = NULL;
-	struct ftrace_page *pg;
-	struct dyn_ftrace *rec;
 	int type = MATCH_FULL;
-	unsigned long flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
-	unsigned i, match = 0, search_len = 0;
-	int not = 0;
+	int i;
 
 	if (buff[0] == '!') {
-		not = 1;
+		*not = 1;
 		buff++;
 		len--;
-	}
+	} else
+		*not = 0;
+
+	*search = buff;
 
 	for (i = 0; i < len; i++) {
 		if (buff[i] == '*') {
 			if (!i) {
-				search = buff + i + 1;
+				*search = buff + 1;
 				type = MATCH_END_ONLY;
-				search_len = len - (i + 1);
 			} else {
-				if (type == MATCH_END_ONLY) {
+				if (type == MATCH_END_ONLY)
 					type = MATCH_MIDDLE_ONLY;
-				} else {
-					match = i;
+				else
 					type = MATCH_FRONT_ONLY;
-				}
 				buff[i] = 0;
 				break;
 			}
 		}
 	}
 
+	return type;
+}
+
+static int
+ftrace_match_record(struct dyn_ftrace *rec, char *regex, int len, int type)
+{
+	char str[KSYM_SYMBOL_LEN];
+	int matched = 0;
+	char *ptr;
+
+	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
+	switch (type) {
+	case MATCH_FULL:
+		if (strcmp(str, regex) == 0)
+			matched = 1;
+		break;
+	case MATCH_FRONT_ONLY:
+		if (strncmp(str, regex, len) == 0)
+			matched = 1;
+		break;
+	case MATCH_MIDDLE_ONLY:
+		if (strstr(str, regex))
+			matched = 1;
+		break;
+	case MATCH_END_ONLY:
+		ptr = strstr(str, regex);
+		if (ptr && (ptr[len] == 0))
+			matched = 1;
+		break;
+	}
+
+	return matched;
+}
+
+static void ftrace_match_records(char *buff, int len, int enable)
+{
+	char *search;
+	struct ftrace_page *pg;
+	struct dyn_ftrace *rec;
+	int type;
+	unsigned long flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
+	unsigned search_len;
+	int not;
+
+	type = ftrace_setup_glob(buff, len, &search, &not);
+
+	search_len = strlen(search);
+
 	/* should not be called from interrupt context */
 	spin_lock(&ftrace_lock);
 	if (enable)
 		ftrace_filtered = 1;
 	do_for_each_ftrace_rec(pg, rec) {
-		int matched = 0;
-		char *ptr;
 
 		if (rec->flags & FTRACE_FL_FAILED)
 			continue;
-		kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
-		switch (type) {
-		case MATCH_FULL:
-			if (strcmp(str, buff) == 0)
-				matched = 1;
-			break;
-		case MATCH_FRONT_ONLY:
-			if (memcmp(str, buff, match) == 0)
-				matched = 1;
-			break;
-		case MATCH_MIDDLE_ONLY:
-			if (strstr(str, search))
-				matched = 1;
-			break;
-		case MATCH_END_ONLY:
-			ptr = strstr(str, search);
-			if (ptr && (ptr[search_len] == 0))
-				matched = 1;
-			break;
-		}
-		if (matched) {
+
+		if (ftrace_match_record(rec, search, search_len, type)) {
 			if (not)
 				rec->flags &= ~flag;
 			else
 				rec->flags |= flag;
 		}
+
 	} while_for_each_ftrace_rec();
 	spin_unlock(&ftrace_lock);
 }
-- 
1.5.6.5

-- 
