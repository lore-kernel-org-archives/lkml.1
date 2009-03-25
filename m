Return-Path: <linux-kernel-owner+w=401wt.eu-S1763523AbZCYReV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763523AbZCYReV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758585AbZCYReN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:34:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:56820 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758209AbZCYReM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:34:12 -0400
Date: Wed, 25 Mar 2009 17:33:27 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       srostedt@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
       adobriyan@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       srostedt@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
       adobriyan@gmail.com, mingo@elte.hu
In-Reply-To: <49C9EAE5.5070202@cn.fujitsu.com>
References: <49C9EAE5.5070202@cn.fujitsu.com>
Subject: [tip:tracing/ftrace] trace_stat: don't call seq_printf() in seq_operation->start()
Message-ID: <tip-e6f489013b985b58d096a3091ece0ed579367232@git.kernel.org>
Git-Commit-ID: e6f489013b985b58d096a3091ece0ed579367232
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 17:33:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6f489013b985b58d096a3091ece0ed579367232
Gitweb:     http://git.kernel.org/tip/e6f489013b985b58d096a3091ece0ed579367232
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Wed, 25 Mar 2009 16:27:17 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 18:32:34 +0100

trace_stat: don't call seq_printf() in seq_operation->start()

Impact: Fix incorrect way using seq_file's API

Use SEQ_START_TOKEN instead of calling ->stat_headers()
int seq_operation->start().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Steven Rostedt <srostedt@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
LKML-Reference: <49C9EAE5.5070202@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_stat.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index f71b85b..8c129dd 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -163,7 +163,7 @@ static void *stat_seq_start(struct seq_file *s, loff_t *pos)
 
 	/* If we are in the beginning of the file, print the headers */
 	if (!*pos && session->ts->stat_headers)
-		session->ts->stat_headers(s);
+		return SEQ_START_TOKEN;
 
 	return seq_list_start(&session->stat_list, *pos);
 }
@@ -172,6 +172,9 @@ static void *stat_seq_next(struct seq_file *s, void *p, loff_t *pos)
 {
 	struct tracer_stat_session *session = s->private;
 
+	if (p == SEQ_START_TOKEN)
+		return seq_list_start(&session->stat_list, *pos);
+
 	return seq_list_next(p, &session->stat_list, pos);
 }
 
@@ -186,6 +189,9 @@ static int stat_seq_show(struct seq_file *s, void *v)
 	struct tracer_stat_session *session = s->private;
 	struct trace_stat_list *l = list_entry(v, struct trace_stat_list, list);
 
+	if (v == SEQ_START_TOKEN)
+		return session->ts->stat_headers(s);
+
 	return session->ts->stat_show(s, l->stat);
 }
 
