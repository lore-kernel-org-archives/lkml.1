Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbZHQJcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbZHQJcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932557AbZHQJcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:32:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:44548 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932553AbZHQJcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:32:16 -0400
Date: Mon, 17 Aug 2009 09:31:08 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A891A65.70009@cn.fujitsu.com>
References: <4A891A65.70009@cn.fujitsu.com>
Subject: [tip:tracing/core] trace_stat: Fix missing entry in stat file
Message-ID: <tip-97d53202a5670a08b79c8ef2e4fff1c1ee21317c@git.kernel.org>
Git-Commit-ID: 97d53202a5670a08b79c8ef2e4fff1c1ee21317c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 09:31:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97d53202a5670a08b79c8ef2e4fff1c1ee21317c
Gitweb:     http://git.kernel.org/tip/97d53202a5670a08b79c8ef2e4fff1c1ee21317c
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 17 Aug 2009 16:52:53 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 17 Aug 2009 11:25:09 +0200

trace_stat: Fix missing entry in stat file

One entry is missing in the output of a stat file.

The cause is, when stat_seq_start() is called the 2nd time, we
should start from the (pos-1)th elem in the rbtree but not pos,
because pos == 0 is the header.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A891A65.70009@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_stat.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 07c60b0..a4bb239 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -203,17 +203,21 @@ static void *stat_seq_start(struct seq_file *s, loff_t *pos)
 {
 	struct stat_session *session = s->private;
 	struct rb_node *node;
+	int n = *pos;
 	int i;
 
 	/* Prevent from tracer switch or rbtree modification */
 	mutex_lock(&session->stat_mutex);
 
 	/* If we are in the beginning of the file, print the headers */
-	if (!*pos && session->ts->stat_headers)
-		return SEQ_START_TOKEN;
+	if (session->ts->stat_headers) {
+		if (n == 0)
+			return SEQ_START_TOKEN;
+		n--;
+	}
 
 	node = rb_first(&session->stat_root);
-	for (i = 0; node && i < *pos; i++)
+	for (i = 0; node && i < n; i++)
 		node = rb_next(node);
 
 	return node;
