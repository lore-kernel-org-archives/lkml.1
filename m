Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbZFXBxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbZFXBxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 21:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbZFXBx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 21:53:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60562 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbZFXBx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 21:53:26 -0400
Message-ID: <4A41874B.4090507@cn.fujitsu.com>
Date: Wed, 24 Jun 2009 09:54:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Liming Wang <liming.wang@windriver.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] ftrace: don't manipulate @pos in t_start()
References: <4A4186C6.9090706@cn.fujitsu.com>
In-Reply-To: <4A4186C6.9090706@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

[ Impact: show selected functions when filter is on ]

Reviewed-by: Liming Wang <liming.wang@windriver.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c06e9ab..7946938 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1466,8 +1466,6 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 			iter->pg = iter->pg->next;
 			iter->idx = 0;
 			goto retry;
-		} else {
-			iter->idx = -1;
 		}
 	} else {
 		rec = &iter->pg->records[iter->idx++];
@@ -1496,6 +1494,7 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 {
 	struct ftrace_iterator *iter = m->private;
 	void *p = NULL;
+	loff_t l;
 
 	mutex_lock(&ftrace_lock);
 	/*
@@ -1507,23 +1506,21 @@ static void *t_start(struct seq_file *m, loff_t *pos)
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
-- 
1.5.4.rc3

