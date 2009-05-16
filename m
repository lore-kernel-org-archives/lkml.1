Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbZEPFTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbZEPFTU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 01:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZEPFSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 01:18:49 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34901 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZEPFSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 01:18:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SxbSkUDSw/1DMw2vlnwcZiSWQ4Fda1A00jeuycGH4/t2tXOXT5Vo1QZ5IIhW3g344F
         nb8bqM3LqADNWB3HKKE4CJyCr7/VJ+rV5F6pXsQdueAd3XFmbMEpTqnsIa6/xkQDGnAf
         Ign1D7gD+npyS+ZBfAynMePNNlu5XdpwfCR+M=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/2] tracing/stat: replace trace_stat_session by stat_session
Date: Sat, 16 May 2009 07:18:43 +0200
Message-Id: <1242451124-5466-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1242451124-5466-1-git-send-email-fweisbec@gmail.com>
References: <1242451124-5466-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "trace" prefix in struct trace_stat_session type is annoying while
reading the trace_stat.c file. It makes the lines longer, and
is not that much useful to explain the sense of this type.

Just keep "struct stat_session" for this type.

[ Impact: make the code a bit more readable ]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_stat.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index fdde3a4..3b6816b 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -22,7 +22,7 @@ struct trace_stat_list {
 };
 
 /* A stat session is the stats output in one file */
-struct tracer_stat_session {
+struct stat_session {
 	struct list_head	session_list;
 	struct tracer_stat	*ts;
 	struct list_head	stat_list;
@@ -38,7 +38,7 @@ static DEFINE_MUTEX(all_stat_sessions_mutex);
 static struct dentry		*stat_dir;
 
 
-static void reset_stat_session(struct tracer_stat_session *session)
+static void reset_stat_session(struct stat_session *session)
 {
 	struct trace_stat_list *node, *next;
 
@@ -48,7 +48,7 @@ static void reset_stat_session(struct tracer_stat_session *session)
 	INIT_LIST_HEAD(&session->stat_list);
 }
 
-static void destroy_session(struct tracer_stat_session *session)
+static void destroy_session(struct stat_session *session)
 {
 	debugfs_remove(session->file);
 	reset_stat_session(session);
@@ -71,7 +71,7 @@ static int dummy_cmp(void *p1, void *p2)
  * All of these copies and sorting are required on all opening
  * since the stats could have changed between two file sessions.
  */
-static int stat_seq_init(struct tracer_stat_session *session)
+static int stat_seq_init(struct stat_session *session)
 {
 	struct trace_stat_list *iter_entry, *new_entry;
 	struct tracer_stat *ts = session->ts;
@@ -154,7 +154,7 @@ exit_free_list:
 
 static void *stat_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct tracer_stat_session *session = s->private;
+	struct stat_session *session = s->private;
 
 	/* Prevent from tracer switch or stat_list modification */
 	mutex_lock(&session->stat_mutex);
@@ -168,7 +168,7 @@ static void *stat_seq_start(struct seq_file *s, loff_t *pos)
 
 static void *stat_seq_next(struct seq_file *s, void *p, loff_t *pos)
 {
-	struct tracer_stat_session *session = s->private;
+	struct stat_session *session = s->private;
 
 	if (p == SEQ_START_TOKEN)
 		return seq_list_start(&session->stat_list, *pos);
@@ -178,13 +178,13 @@ static void *stat_seq_next(struct seq_file *s, void *p, loff_t *pos)
 
 static void stat_seq_stop(struct seq_file *s, void *p)
 {
-	struct tracer_stat_session *session = s->private;
+	struct stat_session *session = s->private;
 	mutex_unlock(&session->stat_mutex);
 }
 
 static int stat_seq_show(struct seq_file *s, void *v)
 {
-	struct tracer_stat_session *session = s->private;
+	struct stat_session *session = s->private;
 	struct trace_stat_list *l = list_entry(v, struct trace_stat_list, list);
 
 	if (v == SEQ_START_TOKEN)
@@ -205,7 +205,7 @@ static int tracing_stat_open(struct inode *inode, struct file *file)
 {
 	int ret;
 
-	struct tracer_stat_session *session = inode->i_private;
+	struct stat_session *session = inode->i_private;
 
 	ret = seq_open(file, &trace_stat_seq_ops);
 	if (!ret) {
@@ -222,7 +222,7 @@ static int tracing_stat_open(struct inode *inode, struct file *file)
  */
 static int tracing_stat_release(struct inode *i, struct file *f)
 {
-	struct tracer_stat_session *session = i->i_private;
+	struct stat_session *session = i->i_private;
 
 	mutex_lock(&session->stat_mutex);
 	reset_stat_session(session);
@@ -251,7 +251,7 @@ static int tracing_stat_init(void)
 	return 0;
 }
 
-static int init_stat_file(struct tracer_stat_session *session)
+static int init_stat_file(struct stat_session *session)
 {
 	if (!stat_dir && tracing_stat_init())
 		return -ENODEV;
@@ -266,7 +266,7 @@ static int init_stat_file(struct tracer_stat_session *session)
 
 int register_stat_tracer(struct tracer_stat *trace)
 {
-	struct tracer_stat_session *session, *node, *tmp;
+	struct stat_session *session, *node, *tmp;
 	int ret;
 
 	if (!trace)
@@ -286,7 +286,7 @@ int register_stat_tracer(struct tracer_stat *trace)
 	mutex_unlock(&all_stat_sessions_mutex);
 
 	/* Init the session */
-	session = kmalloc(sizeof(struct tracer_stat_session), GFP_KERNEL);
+	session = kmalloc(sizeof(struct stat_session), GFP_KERNEL);
 	if (!session)
 		return -ENOMEM;
 
@@ -312,7 +312,7 @@ int register_stat_tracer(struct tracer_stat *trace)
 
 void unregister_stat_tracer(struct tracer_stat *trace)
 {
-	struct tracer_stat_session *node, *tmp;
+	struct stat_session *node, *tmp;
 
 	mutex_lock(&all_stat_sessions_mutex);
 	list_for_each_entry_safe(node, tmp, &all_stat_sessions, session_list) {
-- 
1.6.2.3

