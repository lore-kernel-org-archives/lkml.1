Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbZHQIz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbZHQIz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbZHQIzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:55:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60991 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757443AbZHQIzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:55:55 -0400
Message-ID: <4A891A65.70009@cn.fujitsu.com>
Date: Mon, 17 Aug 2009 16:52:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] trace_stat: Fix missing entry in stat file
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One entry is missing in the output of a stat file.

The cause is, when stat_seq_start() is called the 2nd time, we should
start from the (pos-1)th elem in the rbtree but not pos, because
pos == 0 is the header.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.6.3
