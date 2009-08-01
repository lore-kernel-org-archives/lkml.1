Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbZHAHXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbZHAHXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 03:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZHAHXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 03:23:39 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:41469 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbZHAHXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 03:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CZCzbv6OH/FKJwkLD7f5BQPSWuw78dJgjwyrk4oDyPgp4PAP0hdF7TM/n3FIBBmjAs
         NcKXx4MoKCLN+tJRrhcUQodcgfJ0g7qiS3hFg0j6w1VxrG5UlVw4qQGzV78r7OeYcUb6
         KZ2//TFPLOcBG6Jmlbd0NzxGMBHpLVQiSupcE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 5/5] tracing/filters: Provide support for char * pointers
Date: Sat,  1 Aug 2009 09:23:28 +0200
Message-Id: <1249111408-8657-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1249111408-8657-1-git-send-email-fweisbec@gmail.com>
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide support for char * pointers in the filtering framework.
Usually, char * entries are dangerous in traces because the string
can be released whereas a pointer to it can still wait to be read from
the ring buffer. But sometimes we can assume it's safe, like in case
of RO data (eg: __file__ or __line__, used in bkl trace event). If
these RO data are in a module and so is the call to the trace event,
then it's safe, because the ring buffer will be flushed once this
module get unloaded.

Now the bkl events becomes more useful. Say that you want to trace
only the bkl use in reiserfs:

cd /debug/tracing/events/bkl/lock_kernel
echo "file == fs/reiserfs*" > filter_regex
cat /debug/tracing/trace

syslogd-3658  [001]  1874.661878: lock_kernel: depth: 1, fs/reiserfs/super.c:563 reiserfs_dirty_inode()
syslogd-3658  [001]  1874.662266: lock_kernel: depth: 0, fs/reiserfs/inode.c:2695 reiserfs_write_end()
syslogd-3658  [001]  1874.662268: lock_kernel: depth: 1, fs/reiserfs/super.c:563 reiserfs_dirty_inode()
syslogd-3658  [001]  1874.662291: lock_kernel: depth: 0, fs/reiserfs/inode.c:2695 reiserfs_write_end()

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |   34 +++++++++++++++++++++++++++++-----
 1 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 51b4e24..071c93e 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -160,6 +160,20 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
 	return match;
 }
 
+/* Filter predicate for char * pointers */
+static int filter_pred_pchar(struct filter_pred *pred, void *event,
+			      int val1, int val2)
+{
+	char **addr = (char **)(event + pred->offset);
+	int cmp, match;
+
+	cmp = pred->regex.match(*addr, &pred->regex);
+
+	match = (!!cmp) ^ pred->not;
+
+	return match;
+}
+
 /*
  * Filter predicate for dynamic sized arrays of characters.
  * These are implemented through a list of strings at the end
@@ -547,6 +561,7 @@ static int filter_add_pred_fn(struct filter_parse_state *ps,
 enum {
 	FILTER_STATIC_STRING = 1,
 	FILTER_DYN_STRING,
+	FILTER_PTR_STRING
 };
 
 static int is_string_field(const char *type)
@@ -557,6 +572,9 @@ static int is_string_field(const char *type)
 	if (strchr(type, '[') && strstr(type, "char"))
 		return FILTER_STATIC_STRING;
 
+	if (strstr(type, "char *"))
+		return FILTER_PTR_STRING;
+
 	return 0;
 }
 
@@ -646,12 +664,18 @@ static int filter_add_pred(struct filter_parse_state *ps,
 
 	string_type = is_string_field(field->type);
 	if (string_type) {
-		if (string_type == FILTER_DYN_STRING)
-			fn = filter_pred_strloc;
-		else
-			fn = filter_pred_string;
+		if (string_type == FILTER_PTR_STRING) {
+			fn = filter_pred_pchar;
+			pred->regex.len = strlen(pred->regex.pattern);
+		} else {
+			pred->regex.len = field->size;
+
+			if (string_type == FILTER_DYN_STRING)
+				fn = filter_pred_strloc;
+			else
+				fn = filter_pred_string;
+		}
 
-		pred->regex.len = field->size;
 		if (pred->op == OP_NE)
 			pred->not = 1;
 
-- 
1.6.2.3

