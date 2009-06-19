Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbZFSGph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbZFSGph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 02:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbZFSGpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 02:45:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57013 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbZFSGpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 02:45:12 -0400
Message-ID: <4A3B3460.5090303@cn.fujitsu.com>
Date: Fri, 19 Jun 2009 14:46:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] trace_stat: don't increment @pos in stat_seq_start()
References: <4A3B3372.4040608@cn.fujitsu.com>
In-Reply-To: <4A3B3372.4040608@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's wrong to increment @pos in stat_seq_start(). It causes some
stat entries lost when reading stat file, if the output of the file
is large than PAGE_SIZE.

[ Impact: fix missing entries when reading a stat file ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_stat.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index c006437..e66f5e4 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -199,17 +199,13 @@ static void *stat_seq_start(struct seq_file *s, loff_t *pos)
 	mutex_lock(&session->stat_mutex);
 
 	/* If we are in the beginning of the file, print the headers */
-	if (!*pos && session->ts->stat_headers) {
-		(*pos)++;
+	if (!*pos && session->ts->stat_headers)
 		return SEQ_START_TOKEN;
-	}
 
 	node = rb_first(&session->stat_root);
 	for (i = 0; node && i < *pos; i++)
 		node = rb_next(node);
 
-	(*pos)++;
-
 	return node;
 }
 
-- 
1.5.4.rc3




