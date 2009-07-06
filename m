Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbZGFIKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbZGFIKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZGFIKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:10:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53276 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZGFIKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:10:24 -0400
Message-ID: <4A51B16A.6020708@cn.fujitsu.com>
Date: Mon, 06 Jul 2009 16:10:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] tracing/stat: add stat_release() callback
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Add stat_release() callback to struct tracer_stat, so a stat tracer
can release it's entries after the stat file has been read out.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_stat.c |    7 +++++--
 kernel/trace/trace_stat.h |    2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index e66f5e4..f069461 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -49,7 +49,8 @@ static struct dentry		*stat_dir;
  * but it will at least advance closer to the next one
  * to be released.
  */
-static struct rb_node *release_next(struct rb_node *node)
+static struct rb_node *release_next(struct tracer_stat *ts,
+				    struct rb_node *node)
 {
 	struct stat_node *snode;
 	struct rb_node *parent = rb_parent(node);
@@ -67,6 +68,8 @@ static struct rb_node *release_next(struct rb_node *node)
 			parent->rb_right = NULL;
 
 		snode = container_of(node, struct stat_node, node);
+		if (ts->stat_release)
+			ts->stat_release(snode->stat);
 		kfree(snode);
 
 		return parent;
@@ -78,7 +81,7 @@ static void reset_stat_session(struct stat_session *session)
 	struct rb_node *node = session->stat_root.rb_node;
 
 	while (node)
-		node = release_next(node);
+		node = release_next(session->ts, node);
 
 	session->stat_root = RB_ROOT;
 }
diff --git a/kernel/trace/trace_stat.h b/kernel/trace/trace_stat.h
index f3546a2..8f03914 100644
--- a/kernel/trace/trace_stat.h
+++ b/kernel/trace/trace_stat.h
@@ -18,6 +18,8 @@ struct tracer_stat {
 	int			(*stat_cmp)(void *p1, void *p2);
 	/* Print a stat entry */
 	int			(*stat_show)(struct seq_file *s, void *p);
+	/* Release an entry */
+	void			(*stat_release)(void *stat);
 	/* Print the headers of your stat entries */
 	int			(*stat_headers)(struct seq_file *s);
 };
-- 
1.5.4.rc3




