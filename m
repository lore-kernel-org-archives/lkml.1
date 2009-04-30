Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbZD3Ab1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbZD3Ab1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761161AbZD3A1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:27:47 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47689 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761435AbZD3A1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OElxilwJl1y7G1bemHpYevEMrMzwGhbtvZvS8Azs1TbMjUu3pjSb+m+gnik+ICX4wL
         AGmsz0S0rY40HEux1pm2COQYOlY+9Jd4NkWqJ4zRWWpYmhqzAx84puu1fMPUiXg04DRE
         KrNYNrJymaByF42M90rTt0jq+8+As+wn3aQrg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 11/19] tracing/workqueue: turn workfunc_stats::inserted into unsigned int
Date: Thu, 30 Apr 2009 02:27:12 +0200
Message-Id: <1241051240-4280-12-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

struct workfunc_stats belongs to per_cpu struct of cpu_workqueue_stats,
which means we only need to serialize its access from one cpu.

And because trace_workqueue_insertion() is already inside a section
protected by the cpu workqueue lock, we can safely convert it into an
unsigned int.

[ Impact: locking cleanup]

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
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
1.6.2.3

