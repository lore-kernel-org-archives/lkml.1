Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbZGJKnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbZGJKnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbZGJKnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:43:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:53569 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130AbZGJKnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:43:31 -0400
Date: Fri, 10 Jul 2009 10:42:46 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <4A51B16A.6020708@cn.fujitsu.com>
References: <4A51B16A.6020708@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/stat: Add stat_release() callback
Message-ID: <tip-d8ea37d5de58d35a39d0b4e7d209751aaa1b8174@git.kernel.org>
Git-Commit-ID: d8ea37d5de58d35a39d0b4e7d209751aaa1b8174
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:42:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8ea37d5de58d35a39d0b4e7d209751aaa1b8174
Gitweb:     http://git.kernel.org/tip/d8ea37d5de58d35a39d0b4e7d209751aaa1b8174
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Mon, 6 Jul 2009 16:10:18 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 12:14:05 +0200

tracing/stat: Add stat_release() callback

Add stat_release() callback to struct tracer_stat, so a stat tracer
can release it's entries after the stat file has been read out.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A51B16A.6020708@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
