Return-Path: <linux-kernel-owner+w=401wt.eu-S1763107AbZE1Qmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763107AbZE1Qmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763518AbZE1QmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 12:42:21 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:64406 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763164AbZE1QmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 12:42:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uCppbeplNrplDmR7ZIYR7HKMP4/mIVJiJdzpqt88fRCm+B9xXTX5OzLdGsnqnpSr5q
         20uUvddEU72Z2tAoNRjk9Zbp/s/Gyvqs0XjrpNetKKkmXnckQ5xIu6NRs0ihSX71qT/l
         m7MB/mvO/e/5xN4zZkChD/bYNCVdNOBau5YA0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/3] tracing/stat: do some cleanups
Date: Thu, 28 May 2009 18:42:10 +0200
Message-Id: <1243528930-5318-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243528930-5318-1-git-send-email-fweisbec@gmail.com>
References: <1243528930-5318-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

- remove duplicate code in stat_seq_init()
- update comments to reflect the change from stat list to stat rbtree

[ Impact: clean up ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
1.6.2.3

