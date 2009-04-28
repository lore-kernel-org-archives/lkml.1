Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbZD1Kxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbZD1Kxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbZD1Kxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:53:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58307 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbZD1Kx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:53:29 -0400
Message-ID: <49F6E004.3000309@cn.fujitsu.com>
Date: Tue, 28 Apr 2009 18:52:52 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Zhaolei <zhaolei@cn.fujitsu.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] tracing/workqueue: turn workfunc_stats::inserted into
 unsigned int
References: <49F6DFB5.2040901@cn.fujitsu.com>
In-Reply-To: <49F6DFB5.2040901@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct workfunc_stats is belong to per_cpu struct of cpu_workqueue_stats,
which means we only need to serialize its accessing from one cpu.

And because trace_workqueue_insertion() is already inside a section
protected by the cpu workqueue lock, we can safely convert it into an
unsigned int.

[ Impact: cleanup ]

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace_workqueue.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 69ae4aa..7a07d17 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -20,12 +20,9 @@ struct workfunc_stats {
 
 	/* Addr of worklet's callback function */
 	work_func_t			func;
-	/* Can be inserted on different workqueues, need to be atomic */
-	atomic_t			inserted;
-	/*
-	 * Don't need to be atomic, works are serialized in a single workqueue
-	 * thread on a single CPU.
-	 */
+
+	/* Protected by cpu workqueue lock */
+	unsigned int			inserted;
 	unsigned int			executed;
 };
 
@@ -80,7 +77,7 @@ int do_worklet_enqueue(struct cpu_workqueue_stats *cws,
 
 	list_add_tail(&wfstat->list, &cws->workfunclist);
 found:
-	atomic_inc(&wfstat->inserted);
+	wfstat->inserted++;
 
 	return 0;
 }
@@ -331,7 +328,7 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 		int lastwf = list_is_last(&wfstat->list, &cws->workfunclist);
 		seq_printf(s, "%3d %6d     %6u        %c-%pF\n",
 			cws->cpu,
-			atomic_read(&wfstat->inserted),
+			wfstat->inserted,
 			wfstat->executed,
 			lastwf ? '`' : '|',
 			wfstat->func);
-- 
1.5.5.3


