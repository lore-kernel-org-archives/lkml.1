Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbZE0Dlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbZE0Dlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbZE0Dlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:41:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65510 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756291AbZE0Dlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:41:31 -0400
Message-ID: <4A1CB6B6.2070607@cn.fujitsu.com>
Date: Wed, 27 May 2009 11:42:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3 -v2] tracing/stat: do some cleanups
References: <4A1CADBA.7000707@cn.fujitsu.com> <4A1CADE5.2090508@cn.fujitsu.com>
In-Reply-To: <4A1CADE5.2090508@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove duplicate code in stat_seq_init()
- update comments to reflect the change from stat list to stat rbtree

[ Impact: clean up ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

Please ignore the previous patch. I fixed compile errors but forgot
to "git-add && git-commit --amend"

---
 kernel/trace/trace_stat.c |   54 +++++++++++++++++---------------------------
 1 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index a80d947..e8b50f3 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -93,10 +93,15 @@ static void destroy_session(struct stat_session *session)
 
 typedef int (*cmp_stat_t)(void *, void *);
 
-static void
-insert_stat(struct rb_root *root, struct stat_node *data, cmp_stat_t cmp)
+static int insert_stat(struct rb_root *root, void *stat, cmp_stat_t cmp)
 {
 	struct rb_node **new = &(root->rb_node), *parent = NULL;
+	struct stat_node *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+	data->stat = stat;
 
 	/*
 	 * Figure out where to put new node
@@ -118,12 +123,13 @@ insert_stat(struct rb_root *root, struct stat_node *data, cmp_stat_t cmp)
 
 	rb_link_node(&data->node, parent, new);
 	rb_insert_color(&data->node, root);
+	return 0;
 }
 
 /*
  * For tracers that don't provide a stat_cmp callback.
- * This one will force an immediate insertion on tail of
- * the list.
+ * This one will force an insertion as right-most node
+ * in the rbtree.
  */
 static int dummy_cmp(void *p1, void *p2)
 {
@@ -131,15 +137,14 @@ static int dummy_cmp(void *p1, void *p2)
 }
 
 /*
- * Initialize the stat list at each trace_stat file opening.
+ * Initialize the stat rbtree at each trace_stat file opening.
  * All of these copies and sorting are required on all opening
  * since the stats could have changed between two file sessions.
  */
 static int stat_seq_init(struct stat_session *session)
 {
 	struct tracer_stat *ts = session->ts;
-	struct stat_node *new_entry;
-	struct rb_root *root;
+	struct rb_root *root = &session->stat_root;
 	void *stat;
 	int ret = 0;
 	int i;
@@ -154,23 +159,12 @@ static int stat_seq_init(struct stat_session *session)
 	if (!stat)
 		goto exit;
 
-	/*
-	 * The first entry. Actually this is the second, but the first
-	 * one (the stat_list head) is pointless.
-	 */
-	new_entry = kzalloc(sizeof(*new_entry), GFP_KERNEL);
-	if (!new_entry) {
-		ret = -ENOMEM;
+	ret = insert_stat(root, stat, ts->stat_cmp);
+	if (ret)
 		goto exit;
-	}
-	root = &session->stat_root;
-	insert_stat(root, new_entry, dummy_cmp);
-
-	new_entry->stat = stat;
 
 	/*
-	 * Iterate over the tracer stat entries and store them in a sorted
-	 * list.
+	 * Iterate over the tracer stat entries and store them in an rbtree.
 	 */
 	for (i = 1; ; i++) {
 		stat = ts->stat_next(stat, i);
@@ -179,22 +173,16 @@ static int stat_seq_init(struct stat_session *session)
 		if (!stat)
 			break;
 
-		new_entry = kzalloc(sizeof(*new_entry), GFP_KERNEL);
-		if (!new_entry) {
-			ret = -ENOMEM;
-			goto exit_free_list;
-		}
-
-		new_entry->stat = stat;
-
-		insert_stat(root, new_entry, ts->stat_cmp);
+		ret = insert_stat(root, stat, ts->stat_cmp);
+		if (ret)
+			goto exit_free_rbtree;
 	}
 
 exit:
 	mutex_unlock(&session->stat_mutex);
 	return ret;
 
-exit_free_list:
+exit_free_rbtree:
 	reset_stat_session(session);
 	mutex_unlock(&session->stat_mutex);
 	return ret;
@@ -207,7 +195,7 @@ static void *stat_seq_start(struct seq_file *s, loff_t *pos)
 	struct rb_node *node;
 	int i;
 
-	/* Prevent from tracer switch or stat_list modification */
+	/* Prevent from tracer switch or rbtree modification */
 	mutex_lock(&session->stat_mutex);
 
 	/* If we are in the beginning of the file, print the headers */
@@ -285,7 +273,7 @@ static int tracing_stat_open(struct inode *inode, struct file *file)
 }
 
 /*
- * Avoid consuming memory with our now useless list.
+ * Avoid consuming memory with our now useless rbtree.
  */
 static int tracing_stat_release(struct inode *i, struct file *f)
 {
-- 
1.5.4.rc3

