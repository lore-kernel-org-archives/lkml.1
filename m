Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZCYI3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZCYI3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZCYI2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:28:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51904 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbZCYI2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:28:52 -0400
Message-ID: <49C9EAE5.5070202@cn.fujitsu.com>
Date: Wed, 25 Mar 2009 16:27:17 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace_stat: don't call seq_printf() in seq_operation->start()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Fix incorrect way using seq_file's API

Use SEQ_START_TOKEN instead of calling ->stat_headers()
int seq_operation->start().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 39310e3..5fe73b6 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -160,7 +160,7 @@ static void *stat_seq_start(struct seq_file *s, loff_t *pos)
 
 	/* If we are in the beginning of the file, print the headers */
 	if (!*pos && session->ts->stat_headers)
-		session->ts->stat_headers(s);
+		return SEQ_START_TOKEN;
 
 	return seq_list_start(&session->stat_list, *pos);
 }
@@ -169,6 +169,9 @@ static void *stat_seq_next(struct seq_file *s, void *p, loff_t *pos)
 {
 	struct tracer_stat_session *session = s->private;
 
+	if (p == SEQ_START_TOKEN)
+		return seq_list_start(&session->stat_list, *pos);
+
 	return seq_list_next(p, &session->stat_list, pos);
 }
 
@@ -183,6 +186,9 @@ static int stat_seq_show(struct seq_file *s, void *v)
 	struct tracer_stat_session *session = s->private;
 	struct trace_stat_list *l = list_entry(v, struct trace_stat_list, list);
 
+	if (v == SEQ_START_TOKEN)
+		return session->ts->stat_headers(s);
+
 	return session->ts->stat_show(s, l->stat);
 }
 


