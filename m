Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZFXBwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZFXBwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 21:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZFXBwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 21:52:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62404 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbZFXBwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 21:52:30 -0400
Message-ID: <4A418716.90209@cn.fujitsu.com>
Date: Wed, 24 Jun 2009 09:53:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Liming Wang <liming.wang@windriver.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] trace_stat: don't increment @pos in seq start()
References: <4A4186C6.9090706@cn.fujitsu.com>
In-Reply-To: <4A4186C6.9090706@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's wrong to increment @pos in stat_seq_start(). It causes some
stat entries lost when reading stat file, if the output of the file
is larger than PAGE_SIZE.

[ Impact: fix missing entries when reading stat file ]

Reviewed-by: Liming Wang <liming.wang@windriver.com>
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

