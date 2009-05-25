Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbZEYIpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbZEYIpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbZEYIo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:44:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53275 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbZEYIo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:44:56 -0400
Message-ID: <4A1A5AD1.3070804@cn.fujitsu.com>
Date: Mon, 25 May 2009 16:46:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tracing/stat: sort in ascending order
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the output of trace_stat/workqueues is totally reversed:

 # cat /debug/tracing/trace_stat/workqueues
    ...
    1       17       17      210       37   `-blk_unplug_work+0x0/0x57
    1     3779     3779      181       11   |-cfq_kick_queue+0x0/0x2f
    1     3796     3796                     kblockd/1:120
    ...

The correct output should be:

    1     3796     3796                     kblockd/1:120
    1     3779     3779      181       11   |-cfq_kick_queue+0x0/0x2f
    1       17       17      210       37   `-blk_unplug_work+0x0/0x57

It's caused by "tracing/stat: replace linked list by an rbtree for sorting"
(53059c9b67a62a3dc8c80204d3da42b9267ea5a0).

Though we can simply change dummy_cmp() to return -1 instead of 1, IMO
it's better to always do ascending sorting in trace_stat.c, and leave each
stat tracer to decide whether to sort in descending or ascending order.

[ Impact: fix the output of trace_stat/workqueue ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c       |   12 ++++++------
 kernel/trace/trace_branch.c |    5 +++--
 kernel/trace/trace_stat.c   |    6 +-----
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 140699a..3dd16bd 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -315,29 +315,29 @@ static void *function_stat_start(struct tracer_stat *trace)
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-/* function graph compares on total time */
+/* function graph compares on total time in reverse order */
 static int function_stat_cmp(void *p1, void *p2)
 {
 	struct ftrace_profile *a = p1;
 	struct ftrace_profile *b = p2;
 
-	if (a->time < b->time)
-		return -1;
 	if (a->time > b->time)
+		return -1;
+	if (a->time < b->time)
 		return 1;
 	else
 		return 0;
 }
 #else
-/* not function graph compares against hits */
+/* not function graph compares against hits in reverse order */
 static int function_stat_cmp(void *p1, void *p2)
 {
 	struct ftrace_profile *a = p1;
 	struct ftrace_profile *b = p2;
 
-	if (a->counter < b->counter)
-		return -1;
 	if (a->counter > b->counter)
+		return -1;
+	if (a->counter < b->counter)
 		return 1;
 	else
 		return 0;
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 7a7a9fd..df58411 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -301,9 +301,10 @@ static int annotated_branch_stat_cmp(void *p1, void *p2)
 	percent_a = get_incorrect_percent(a);
 	percent_b = get_incorrect_percent(b);
 
-	if (percent_a < percent_b)
-		return -1;
+	/* sort in descending order */
 	if (percent_a > percent_b)
+		return -1;
+	if (percent_a < percent_b)
 		return 1;
 	else
 		return 0;
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 2e849b5..6efbcb4 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -98,10 +98,6 @@ insert_stat(struct rb_root *root, struct stat_node *data, cmp_stat_t cmp)
 {
 	struct rb_node **new = &(root->rb_node), *parent = NULL;
 
-	/*
-	 * Figure out where to put new node
-	 * This is a descendent sorting
-	 */
 	while (*new) {
 		struct stat_node *this;
 		int result;
@@ -110,7 +106,7 @@ insert_stat(struct rb_root *root, struct stat_node *data, cmp_stat_t cmp)
 		result = cmp(data->stat, this->stat);
 
 		parent = *new;
-		if (result >= 0)
+		if (result < 0)
 			new = &((*new)->rb_left);
 		else
 			new = &((*new)->rb_right);
-- 
1.5.4.rc3

