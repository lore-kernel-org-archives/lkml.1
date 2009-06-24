Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbZFXJrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbZFXJrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758580AbZFXJqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:46:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:59721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758581AbZFXJqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:46:46 -0400
Date: Wed, 24 Jun 2009 09:46:15 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, liming.wang@windriver.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, liming.wang@windriver.com, mingo@elte.hu
In-Reply-To: <4A418728.5020506@cn.fujitsu.com>
References: <4A418728.5020506@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing: Reset iterator in t_start()
Message-ID: <tip-f129e965bef40c6153e4fe505f1e408286213424@git.kernel.org>
Git-Commit-ID: f129e965bef40c6153e4fe505f1e408286213424
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 09:46:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f129e965bef40c6153e4fe505f1e408286213424
Gitweb:     http://git.kernel.org/tip/f129e965bef40c6153e4fe505f1e408286213424
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 24 Jun 2009 09:53:44 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 24 Jun 2009 11:02:51 +0200

tracing: Reset iterator in t_start()

The iterator is m->private, but it's not reset to trace_types in
t_start(). If the output is larger than PAGE_SIZE and t_start()
is called the 2nd time, things will go wrong.

Reviewed-by: Liming Wang <liming.wang@windriver.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A418728.5020506@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 076fa6f..3bb3100 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2053,25 +2053,23 @@ static int tracing_open(struct inode *inode, struct file *file)
 static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct tracer *t = m->private;
+	struct tracer *t = v;
 
 	(*pos)++;
 
 	if (t)
 		t = t->next;
 
-	m->private = t;
-
 	return t;
 }
 
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
-	struct tracer *t = m->private;
+	struct tracer *t;
 	loff_t l = 0;
 
 	mutex_lock(&trace_types_lock);
-	for (; t && l < *pos; t = t_next(m, t, &l))
+	for (t = trace_types; t && l < *pos; t = t_next(m, t, &l))
 		;
 
 	return t;
@@ -2107,18 +2105,10 @@ static struct seq_operations show_traces_seq_ops = {
 
 static int show_traces_open(struct inode *inode, struct file *file)
 {
-	int ret;
-
 	if (tracing_disabled)
 		return -ENODEV;
 
-	ret = seq_open(file, &show_traces_seq_ops);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		m->private = trace_types;
-	}
-
-	return ret;
+	return seq_open(file, &show_traces_seq_ops);
 }
 
 static ssize_t
