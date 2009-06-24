Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbZFXJqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbZFXJqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758347AbZFXJqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:46:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:37582 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758301AbZFXJqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:46:35 -0400
Date: Wed, 24 Jun 2009 09:46:02 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, liming.wang@windriver.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, liming.wang@windriver.com, mingo@elte.hu
In-Reply-To: <4A418716.90209@cn.fujitsu.com>
References: <4A418716.90209@cn.fujitsu.com>
Subject: [tip:tracing/urgent] trace_stat: Don't increment @pos in seq start()
Message-ID: <tip-2961bf345fd1b736c3db46cad0f69855f67fbe9c@git.kernel.org>
Git-Commit-ID: 2961bf345fd1b736c3db46cad0f69855f67fbe9c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 09:46:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2961bf345fd1b736c3db46cad0f69855f67fbe9c
Gitweb:     http://git.kernel.org/tip/2961bf345fd1b736c3db46cad0f69855f67fbe9c
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 24 Jun 2009 09:53:26 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 24 Jun 2009 11:02:51 +0200

trace_stat: Don't increment @pos in seq start()

It's wrong to increment @pos in stat_seq_start(). It causes some
stat entries lost when reading stat file, if the output of the file
is larger than PAGE_SIZE.

Reviewed-by: Liming Wang <liming.wang@windriver.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A418716.90209@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
 
