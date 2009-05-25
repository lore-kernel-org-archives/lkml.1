Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbZEYIpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbZEYIpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZEYIpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:45:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54535 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbZEYIpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:45:38 -0400
Message-ID: <4A1A5B02.6070605@cn.fujitsu.com>
Date: Mon, 25 May 2009 16:46:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] tracing/stat: do some cleanups
References: <4A1A5AD1.3070804@cn.fujitsu.com>
In-Reply-To: <4A1A5AD1.3070804@cn.fujitsu.com>
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
 kernel/trace/trace_stat.c |   56 +++++++++++++++++---------------------------
 1 files changed, 22 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index ed18701..abf2ba1 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -8,7 +8,6 @@
  *
  */
 
-
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <linux/debugfs.h>
@@ -64,10 +63,15 @@ static void destroy_session(struct stat_session *session)
 
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
 
 	while (*new) {
 		struct stat_node *this;
@@ -85,12 +89,13 @@ insert_stat(struct rb_root *root, struct stat_node *data, cmp_stat_t cmp)
 
 	rb_link_node(&data->node, parent, new);
 	rb_insert_color(&data->node, root);
+	return 0;
 }
 
 /*
  * For tracers that don't provide a stat_cmp callback.
- * This one will force an immediate insertion on tail of
- * the list.
+ * This one will force an insertion on rightmost node
+ * of the tree.
  */
 static int dummy_cmp(void *p1, void *p2)
 {
@@ -98,15 +103,14 @@ static int dummy_cmp(void *p1, void *p2)
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
@@ -121,23 +125,13 @@ static int stat_seq_init(struct stat_session *session)
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
+	 * Iterate over the tracer stat entries and store them
+	 * in an rbtree.
 	 */
 	for (i = 1; ; i++) {
 		stat = ts->stat_next(stat, i);
@@ -146,22 +140,16 @@ static int stat_seq_init(struct stat_session *session)
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
@@ -174,7 +162,7 @@ static void *stat_seq_start(struct seq_file *s, loff_t *pos)
 	struct rb_node *node;
 	int i;
 
-	/* Prevent from tracer switch or stat_list modification */
+	/* Prevent from tracer switch or rbtree modification */
 	mutex_lock(&session->stat_mutex);
 
 	/* If we are in the beginning of the file, print the headers */
@@ -252,7 +240,7 @@ static int tracing_stat_open(struct inode *inode, struct file *file)
 }
 
 /*
- * Avoid consuming memory with our now useless list.
+ * Avoid consuming memory with our now useless rbtree.
  */
 static int tracing_stat_release(struct inode *i, struct file *f)
 {
-- 
1.5.4.rc3

