Return-Path: <linux-kernel-owner+w=401wt.eu-S1761954AbZD3A3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761954AbZD3A3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbZD3A1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:27:35 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48086 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760190AbZD3A1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:27:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EtDU/J+SQZ9cS1ZQPA8KEu1QhoAdMDUqC0XPt22QgxzU00dHLGgqhWHGffq4y1l6iR
         /bLkg1gkXYfbJMbuIpw1xkkLzi+mSwpf7YCs4apNwPOoh8P13lM/lBTFcupqrMIaUcbz
         wndX+ZFPWjh4rF+GSahUVMlv0RwU7wueaoz4I=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhao Lei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 06/19] tracing/workqueue: turn cpu_workqueue_stats::inserted into unsigned int
Date: Thu, 30 Apr 2009 02:27:07 +0200
Message-Id: <1241051240-4280-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct cpu_workqueue_stats used an atomic_t to protect against
concurrent incrementation of inserted worklets. But
trace_workqueue_insertion() is already inside a section protected
by the cpu workqueue lock.

Then we can safely convert it into an unsigned int.

[ Impact: cleanup ]

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/trace/trace_workqueue.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 1a68b5a..7c632b9 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -20,7 +20,7 @@ struct workfunc_stats {
 
 	/* Addr of worklet's callback function */
 	work_func_t			func;
-	/* Can be inserted from interrupt or user context, need to be atomic */
+	/* Can be inserted on different workqueues, need to be atomic */
 	atomic_t			inserted;
 	/*
 	 * Don't need to be atomic, works are serialized in a single workqueue
@@ -34,8 +34,8 @@ struct cpu_workqueue_stats {
 	struct list_head            list;
 	int		            cpu;
 	pid_t			    pid;
-	/* Refer to comments of struct workfunc_stats for detail */
-	atomic_t	            inserted;
+	/* Protected by cpu workqueue lock */
+	unsigned int	            inserted;
 	unsigned int		    executed;
 	/* list of struct workfunc_stats in this workqueue */
 	struct list_head            workfunclist;
@@ -62,7 +62,7 @@ int do_workqueue_insertion(struct cpu_workqueue_stats *cws,
 {
 	struct workfunc_stats *wfstat;
 
-	atomic_inc(&cws->inserted);
+	cws->inserted++;
 
 	list_for_each_entry(wfstat, &cws->workfunclist, list)
 		if (wfstat->func == work->func)
@@ -311,7 +311,7 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 			if (tsk) {
 				seq_printf(s, "%3d %6d     %6u       %s:%d\n",
 					   cws->cpu,
-					   atomic_read(&cws->inserted),
+					   cws->inserted,
 					   cws->executed,
 					   tsk->comm,
 					   cws->pid);
-- 
1.6.2.3

