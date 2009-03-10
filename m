Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbZCJA5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbZCJA5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 20:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZCJA5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 20:57:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43193 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbZCJA5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 20:57:07 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ftrace: Don't use tracing_record_cmdline() in workqueue tracer
Cc: kosaki.motohiro@jp.fujitsu.com, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090309092817.GA2184@elte.hu>
References: <20090309175330.CF63.A69D9226@jp.fujitsu.com> <20090309092817.GA2184@elte.hu>
Message-Id: <20090310090828.A46F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 10 Mar 2009 09:57:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Currently, /sys/kernel/debug/tracing/trace_stat/workqueues can 
> > display wrong and strang thread name.
> > 
> > Why?
> > 
> > Currently, ftrace has 
> > tracing_record_cmdline()/trace_find_cmdline() convinience 
> > function. they implement task->comm string cache. it can avoid 
> > unnecessary memcpy overhead. and workqueue tracer use it.
> > 
> > However, in general, any trace stastics feature shouldn't use 
> > tracing_record_cmdline(). A trace stastics can display very 
> > old process. then comm cache can return wrong string because 
> > recent process override the cache.
> > 
> > Fortunately, workqueue trace gerantee to live displayed 
> > process. Then, we can search comm string from pid at display 
> > time.
> 
> Applied, thanks!
> 
> We might need to improve the comm-cache - i've seen frequent 
> artifacts due to it. Displaying <...> is _far_ better than an 
> outright misleading string displayed.
> 
> I.e. the cache should be improved to be properly coherent with 
> reality.
> 
> 	Ingo

Doh!
My last mail's cc list didn't include lkml. that's unintensional silly 
my mistake. very sorry.

and Yes, memcpy(buf, task->comm, 16) mean two movq instruction.
that is worthless for caching. I think we can remove this cache completely.


and, I find my last patch has one race window. fixing below.

================================
Subject: [PATCH] tracing: Don't use tracing_record_cmdline() in workqueue tracer fix

last "Don't use tracing_record_cmdline() in workqueue tracer" patch have
a race window.

find_task_by_vpid() require task_list_lock(). but the patch doesn't.

fixing here.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/trace/trace_workqueue.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 46c8dc8..e6c4d00 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -193,12 +193,20 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 	struct cpu_workqueue_stats *cws = p;
 	unsigned long flags;
 	int cpu = cws->cpu;
-	struct task_struct *tsk = find_task_by_vpid(cws->pid);
-
-	seq_printf(s, "%3d %6d     %6u       %s\n", cws->cpu,
-		   atomic_read(&cws->inserted),
-		   cws->executed,
-		   tsk ? tsk->comm : "<...>");
+	struct pid *pid;
+	struct task_struct *tsk;
+
+	pid = find_get_pid(cws->pid);
+	if (pid) {
+		tsk = get_pid_task(pid, PIDTYPE_PID);
+		if (tsk) {
+			seq_printf(s, "%3d %6d     %6u       %s\n", cws->cpu,
+				   atomic_read(&cws->inserted), cws->executed,
+				   tsk->comm);
+			put_task_struct(tsk);
+		}
+		put_pid(pid);
+	}
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
 	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
-- 
1.6.1.2




