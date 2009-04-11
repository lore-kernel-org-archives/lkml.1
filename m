Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbZDKHxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbZDKHxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbZDKHwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:52:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56569 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757088AbZDKHwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:52:21 -0400
Message-ID: <49E04C61.10209@cn.fujitsu.com>
Date: Sat, 11 Apr 2009 15:53:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] tracing/filters: allow user to specify a filter val to
 be string
References: <49E04C22.4040608@cn.fujitsu.com>
In-Reply-To: <49E04C22.4040608@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppose we would like to trace all tasks named '123', but this
will fail:
 # echo 'parent_comm == 123' > events/sched/sched_process_fork/filter
 bash: echo: write error: Invalid argument

With this patch, we allow it by:
 # echo 'parent_comm == \123' > events/sched/sched_process_fork/filter
 # cat events/sched/sched_process_fork/filter
 parent_comm == 123

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 49b3ef5..2bf4481 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -351,12 +351,19 @@ oom:
 	return -ENOMEM;
 }
 
+/*
+ * The filter format can be
+ *   - 0, which means remove all filter preds
+ *   - [||/&&] <field> ==/!= [\]<val>
+ *
+ * Note: '\' prevent a string type value beginning with a digit to
+ *       be treated as a number
+ */
 int filter_parse(char **pbuf, struct filter_pred *pred)
 {
 	char *tmp, *tok, *val_str = NULL;
 	int tok_n = 0;
 
-	/* field ==/!= number, or/and field ==/!= number, number */
 	while ((tok = strsep(pbuf, " \n"))) {
 		if (tok_n == 0) {
 			if (!strcmp(tok, "0")) {
@@ -421,6 +428,8 @@ int filter_parse(char **pbuf, struct filter_pred *pred)
 
 	pred->val = simple_strtoull(val_str, &tmp, 0);
 	if (tmp == val_str) {
+		if (*val_str == '\\')
+			val_str++;
 		pred->str_val = kstrdup(val_str, GFP_KERNEL);
 		if (!pred->str_val)
 			return -ENOMEM;
-- 
1.5.4.rc3

