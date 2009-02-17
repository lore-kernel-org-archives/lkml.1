Return-Path: <linux-kernel-owner+w=401wt.eu-S1750791AbZBQFQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750791AbZBQFQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZBQFOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:14:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbZBQFOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:14:07 -0500
Message-Id: <20090217051405.389608160@goodmis.org>
References: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 02/15] ftrace: add do_for_each_ftrace_rec and while_for_each_ftrace_rec
Content-Disposition: inline; filename=0002-ftrace-add-do_for_each_ftrace_rec-and-while_for_eac.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

To iterate over all the functions that dynamic trace knows about
it requires two for loops. One to iterate over the pages and the
other to iterate over the records within the page.

There are several duplications of these loops in ftrace.c. This
patch creates the macros do_for_each_ftrace_rec and
while_for_each_ftrace_rec to handle this logic, and removes the
duplicate code.

While making this change, I also discovered and fixed a small
bug that one of the iterations should exit the loop after it found the
record it was searching for. This used a break when it should have
used a goto, since there were two loops it needed to break out
from.  No real harm was done by this bug since it would only continue
to search the other records, and the code was in a slow path anyway.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |  208 ++++++++++++++++++++++++-------------------------
 1 files changed, 101 insertions(+), 107 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 369fb78..fed1ebc 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -297,6 +297,19 @@ static struct ftrace_page	*ftrace_pages;
 
 static struct dyn_ftrace *ftrace_free_records;
 
+/*
+ * This is a double for. Do not use 'break' to break out of the loop,
+ * you must use a goto.
+ */
+#define do_for_each_ftrace_rec(pg, rec)					\
+	for (pg = ftrace_pages_start; pg; pg = pg->next) {		\
+		int _____i;						\
+		for (_____i = 0; _____i < pg->index; _____i++) {	\
+			rec = &pg->records[_____i];
+
+#define while_for_each_ftrace_rec()		\
+		}				\
+	}
 
 #ifdef CONFIG_KPROBES
 
@@ -341,7 +354,6 @@ void ftrace_release(void *start, unsigned long size)
 	struct ftrace_page *pg;
 	unsigned long s = (unsigned long)start;
 	unsigned long e = s + size;
-	int i;
 
 	if (ftrace_disabled || !start)
 		return;
@@ -349,14 +361,11 @@ void ftrace_release(void *start, unsigned long size)
 	/* should not be called from interrupt context */
 	spin_lock(&ftrace_lock);
 
-	for (pg = ftrace_pages_start; pg; pg = pg->next) {
-		for (i = 0; i < pg->index; i++) {
-			rec = &pg->records[i];
+	do_for_each_ftrace_rec(pg, rec) {
+		if ((rec->ip >= s) && (rec->ip < e))
+			ftrace_free_rec(rec);
+	} while_for_each_ftrace_rec();
 
-			if ((rec->ip >= s) && (rec->ip < e))
-				ftrace_free_rec(rec);
-		}
-	}
 	spin_unlock(&ftrace_lock);
 }
 
@@ -523,41 +532,37 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 
 static void ftrace_replace_code(int enable)
 {
-	int i, failed;
+	int failed;
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
 
-	for (pg = ftrace_pages_start; pg; pg = pg->next) {
-		for (i = 0; i < pg->index; i++) {
-			rec = &pg->records[i];
-
-			/*
-			 * Skip over free records and records that have
-			 * failed.
-			 */
-			if (rec->flags & FTRACE_FL_FREE ||
-			    rec->flags & FTRACE_FL_FAILED)
-				continue;
-
-			/* ignore updates to this record's mcount site */
-			if (get_kprobe((void *)rec->ip)) {
-				freeze_record(rec);
-				continue;
-			} else {
-				unfreeze_record(rec);
-			}
+	do_for_each_ftrace_rec(pg, rec) {
+		/*
+		 * Skip over free records and records that have
+		 * failed.
+		 */
+		if (rec->flags & FTRACE_FL_FREE ||
+		    rec->flags & FTRACE_FL_FAILED)
+			continue;
 
-			failed = __ftrace_replace_code(rec, enable);
-			if (failed && (rec->flags & FTRACE_FL_CONVERTED)) {
-				rec->flags |= FTRACE_FL_FAILED;
-				if ((system_state == SYSTEM_BOOTING) ||
-				    !core_kernel_text(rec->ip)) {
-					ftrace_free_rec(rec);
-				} else
-					ftrace_bug(failed, rec->ip);
-			}
+		/* ignore updates to this record's mcount site */
+		if (get_kprobe((void *)rec->ip)) {
+			freeze_record(rec);
+			continue;
+		} else {
+			unfreeze_record(rec);
 		}
-	}
+
+		failed = __ftrace_replace_code(rec, enable);
+		if (failed && (rec->flags & FTRACE_FL_CONVERTED)) {
+			rec->flags |= FTRACE_FL_FAILED;
+			if ((system_state == SYSTEM_BOOTING) ||
+			    !core_kernel_text(rec->ip)) {
+				ftrace_free_rec(rec);
+			} else
+				ftrace_bug(failed, rec->ip);
+		}
+	} while_for_each_ftrace_rec();
 }
 
 static int
@@ -956,22 +961,17 @@ static void ftrace_filter_reset(int enable)
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
 	unsigned long type = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
-	unsigned i;
 
 	/* should not be called from interrupt context */
 	spin_lock(&ftrace_lock);
 	if (enable)
 		ftrace_filtered = 0;
-	pg = ftrace_pages_start;
-	while (pg) {
-		for (i = 0; i < pg->index; i++) {
-			rec = &pg->records[i];
-			if (rec->flags & FTRACE_FL_FAILED)
-				continue;
-			rec->flags &= ~type;
-		}
-		pg = pg->next;
-	}
+	do_for_each_ftrace_rec(pg, rec) {
+		if (rec->flags & FTRACE_FL_FAILED)
+			continue;
+		rec->flags &= ~type;
+	} while_for_each_ftrace_rec();
+
 	spin_unlock(&ftrace_lock);
 }
 
@@ -1094,44 +1094,39 @@ ftrace_match(unsigned char *buff, int len, int enable)
 	spin_lock(&ftrace_lock);
 	if (enable)
 		ftrace_filtered = 1;
-	pg = ftrace_pages_start;
-	while (pg) {
-		for (i = 0; i < pg->index; i++) {
-			int matched = 0;
-			char *ptr;
-
-			rec = &pg->records[i];
-			if (rec->flags & FTRACE_FL_FAILED)
-				continue;
-			kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
-			switch (type) {
-			case MATCH_FULL:
-				if (strcmp(str, buff) == 0)
-					matched = 1;
-				break;
-			case MATCH_FRONT_ONLY:
-				if (memcmp(str, buff, match) == 0)
-					matched = 1;
-				break;
-			case MATCH_MIDDLE_ONLY:
-				if (strstr(str, search))
-					matched = 1;
-				break;
-			case MATCH_END_ONLY:
-				ptr = strstr(str, search);
-				if (ptr && (ptr[search_len] == 0))
-					matched = 1;
-				break;
-			}
-			if (matched) {
-				if (not)
-					rec->flags &= ~flag;
-				else
-					rec->flags |= flag;
-			}
+	do_for_each_ftrace_rec(pg, rec) {
+		int matched = 0;
+		char *ptr;
+
+		if (rec->flags & FTRACE_FL_FAILED)
+			continue;
+		kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
+		switch (type) {
+		case MATCH_FULL:
+			if (strcmp(str, buff) == 0)
+				matched = 1;
+			break;
+		case MATCH_FRONT_ONLY:
+			if (memcmp(str, buff, match) == 0)
+				matched = 1;
+			break;
+		case MATCH_MIDDLE_ONLY:
+			if (strstr(str, search))
+				matched = 1;
+			break;
+		case MATCH_END_ONLY:
+			ptr = strstr(str, search);
+			if (ptr && (ptr[search_len] == 0))
+				matched = 1;
+			break;
 		}
-		pg = pg->next;
-	}
+		if (matched) {
+			if (not)
+				rec->flags &= ~flag;
+			else
+				rec->flags |= flag;
+		}
+	} while_for_each_ftrace_rec();
 	spin_unlock(&ftrace_lock);
 }
 
@@ -1452,7 +1447,7 @@ ftrace_set_func(unsigned long *array, int idx, char *buffer)
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
 	int found = 0;
-	int i, j;
+	int j;
 
 	if (ftrace_disabled)
 		return -ENODEV;
@@ -1460,27 +1455,26 @@ ftrace_set_func(unsigned long *array, int idx, char *buffer)
 	/* should not be called from interrupt context */
 	spin_lock(&ftrace_lock);
 
-	for (pg = ftrace_pages_start; pg; pg = pg->next) {
-		for (i = 0; i < pg->index; i++) {
-			rec = &pg->records[i];
-
-			if (rec->flags & (FTRACE_FL_FAILED | FTRACE_FL_FREE))
-				continue;
-
-			kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
-			if (strcmp(str, buffer) == 0) {
-				found = 1;
-				for (j = 0; j < idx; j++)
-					if (array[j] == rec->ip) {
-						found = 0;
-						break;
-					}
-				if (found)
-					array[idx] = rec->ip;
-				break;
-			}
+	do_for_each_ftrace_rec(pg, rec) {
+
+		if (rec->flags & (FTRACE_FL_FAILED | FTRACE_FL_FREE))
+			continue;
+
+		kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
+		if (strcmp(str, buffer) == 0) {
+			/* Return 1 if we add it to the array */
+			found = 1;
+			for (j = 0; j < idx; j++)
+				if (array[j] == rec->ip) {
+					found = 0;
+					break;
+				}
+			if (found)
+				array[idx] = rec->ip;
+			goto out;
 		}
-	}
+	} while_for_each_ftrace_rec();
+ out:
 	spin_unlock(&ftrace_lock);
 
 	return found ? 0 : -EINVAL;
-- 
1.5.6.5

-- 
