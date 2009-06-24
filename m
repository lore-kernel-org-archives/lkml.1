Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbZFXJrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbZFXJrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758756AbZFXJrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:47:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:59768 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758746AbZFXJrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:47:21 -0400
Date: Wed, 24 Jun 2009 09:46:41 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, liming.wang@windriver.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, liming.wang@windriver.com, mingo@elte.hu
In-Reply-To: <4A41874B.4090507@cn.fujitsu.com>
References: <4A41874B.4090507@cn.fujitsu.com>
Subject: [tip:tracing/urgent] ftrace: Don't manipulate @pos in t_start()
Message-ID: <tip-694ce0a544fba37a60025a6803ee6265be8a2a22@git.kernel.org>
Git-Commit-ID: 694ce0a544fba37a60025a6803ee6265be8a2a22
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 09:46:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  694ce0a544fba37a60025a6803ee6265be8a2a22
Gitweb:     http://git.kernel.org/tip/694ce0a544fba37a60025a6803ee6265be8a2a22
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 24 Jun 2009 09:54:19 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 24 Jun 2009 11:02:53 +0200

ftrace: Don't manipulate @pos in t_start()

It's rather confusing that in t_start(), in some cases @pos is
incremented, and in some cases it's decremented and then incremented.

This patch rewrites t_start() in a much more general way.

Thus we fix a bug that if ftrace_filtered == 1, functions have tracer
hooks won't be printed, because the branch is always unreachable:

static void *t_start(...)
{
	...
	if (!p)
		return t_hash_start(m, pos);
	return p;
}

Before:
  # echo 'sys_open' > /mnt/tracing/set_ftrace_filter
  # echo 'sys_write:traceon:4' >> /mnt/tracing/set_ftrace_filter
  sys_open

After:
  # echo 'sys_open' > /mnt/tracing/set_ftrace_filter
  # echo 'sys_write:traceon:4' >> /mnt/tracing/set_ftrace_filter
  sys_open
  sys_write:traceon:count=4

Reviewed-by: Liming Wang <liming.wang@windriver.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A41874B.4090507@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cde74b9..dc81020 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1467,8 +1467,6 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 			iter->pg = iter->pg->next;
 			iter->idx = 0;
 			goto retry;
-		} else {
-			iter->idx = -1;
 		}
 	} else {
 		rec = &iter->pg->records[iter->idx++];
@@ -1497,6 +1495,7 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 {
 	struct ftrace_iterator *iter = m->private;
 	void *p = NULL;
+	loff_t l;
 
 	mutex_lock(&ftrace_lock);
 	/*
@@ -1508,23 +1507,21 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 		if (*pos > 0)
 			return t_hash_start(m, pos);
 		iter->flags |= FTRACE_ITER_PRINTALL;
-		(*pos)++;
 		return iter;
 	}
 
 	if (iter->flags & FTRACE_ITER_HASH)
 		return t_hash_start(m, pos);
 
-	if (*pos > 0) {
-		if (iter->idx < 0)
-			return p;
-		(*pos)--;
-		iter->idx--;
+	iter->pg = ftrace_pages_start;
+	iter->idx = 0;
+	for (l = 0; l <= *pos; ) {
+		p = t_next(m, p, &l);
+		if (!p)
+			break;
 	}
 
-	p = t_next(m, p, pos);
-
-	if (!p)
+	if (!p && iter->flags & FTRACE_ITER_FILTER)
 		return t_hash_start(m, pos);
 
 	return p;
