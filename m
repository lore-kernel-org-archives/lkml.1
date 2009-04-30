Return-Path: <linux-kernel-owner+w=401wt.eu-S1762316AbZD3Ac7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762316AbZD3Ac7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760846AbZD3A1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:27:55 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47689 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761506AbZD3A1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:27:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iSzzP0miBGb2touyFtcSVP50HSzTF0xUFtbRVIQi0cDRLr5jlfQnfwNSShKo4mcTOJ
         WYZy8dmB9/JGnJSTdvOep8/CXhD07pzM8m0hOWhrMcbJeQOxpuE9gkiax79zpPR/JiSl
         AQ1CV1Y8PI6QVIfuUScbptfxleekdT8z+A1XI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhao Lei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 15/19] tracing/workqueue: add execution time average column
Date: Thu, 30 Apr 2009 02:27:16 +0200
Message-Id: <1241051240-4280-16-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We recently got a new column on the stats which shows the maximum execution
time of a worklet. This field is useful to find the worst latency
case a worklet can induce and propagate to the tasks waiting for pending
worklets on the queue.

To complete this worst case information, it's also useful to get
the time execution average of a worklet so that we also get the typical
case of latency it causes.

The header M_EXECus is also turned into "MAX us", so that we can have
a pair of MAX us / AVG us which can reflect more easily the role
of these columns.

Example of the new trace:

 # CPU INSERTED EXECUTED    MAX us   AVG us   TASKNAME:PID
 #  |     |        |           |      ` |     -WORKFUNC
 #  |     |        |           |        |          |
    0     1254     1332                     events/0:9
    0        1        1       39       39   |-hpet_work+0x0/0x340
    0        3        2      275      233   |-rt_worker_func+0x0/0x400
    0      167      166       69        9   |-vmstat_update+0x0/0x40
    0      776      776   106345      255   |-fb_flashcursor+0x0/0x3c0
    0      142      142      504       14   |-console_callback+0x0/0x1e0
    0       80       80   46941155   1340510   |-test_work+0x0/0x64
    0        3        2        0        0   |-lru_add_drain_per_cpu+0x0/0x10
    0        1        1        3        3   |-sync_cmos_clock+0x0/0x140
    0       81       81      179       60   `-flush_to_ldisc+0x0/0x2f0
    0        0        0                     cpuset:11
    0     1354     1354                     khelper:12
    0     1354     1354   143449      365   `-__call_usermodehelper+0x0/0xe0
    0        0        0                     kintegrityd/0:174
    0       39       39                     kblockd/0:180
    0       26       26      170       42   |-blk_unplug_work+0x0/0x110
    0       13       13       70       14   `-cfq_kick_queue+0x0/0x50
    0        0        0                     kacpid:186
    0        0        0                     kacpi_notify:187
    0        0        0                     tifm:498
    0      312      312                     ata/0:507
    0      312      312       29       23   `-ata_pio_task+0x0/0x280
    0        0        0                     ata_aux:512
    0        0        0                     aio/0:867
    0        0        0                     crypto/0:897
    0        0        0                     scsi_tgtd/0:2367
    0        0        0                     iscsi_eh:2387
    0        0        0                     kpsmoused:2521
    0        0        0                     hd-audio0:2714
    0        0        0                     krxrpcd/0:2734
    0        5        5                     reiserfs/0:2896
    0        5        5   268602    53724   `-flush_async_commits+0x0/0x90
    1      510      580                     events/1:10
    1        1        1       67       67   |-hpet_work+0x0/0x340
    1      168      167       79       11   |-vmstat_update+0x0/0x40
    1        1        1      441      441   |-power_supply_changed_work+0x0/0x60
    1        1        1      836      836   |-sysfs_add_func+0x0/0xb0
    1       80       80   46940792   1346733   |-test_work+0x0/0x64
    1        1        0        0        0   |-rekey_seq_generator+0x0/0x70
    1        3        3        0        0   |-lru_add_drain_per_cpu+0x0/0x10
    1      164      164     7065       57   |-console_callback+0x0/0x1e0
    1       91       91      315       69   `-flush_to_ldisc+0x0/0x2f0
    1        0        0                     kintegrityd/1:177
    1       44       44                     kblockd/1:181
    1       30       30       59       36   |-blk_unplug_work+0x0/0x110
    1       14       14      167       20   `-cfq_kick_queue+0x0/0x50
    1      258      258                     ata/1:509
    1      258      258    12968      119   `-ata_pio_task+0x0/0x280
    1        0        0                     aio/1:870
    1        0        0                     crypto/1:898
    1        0        0                     scsi_tgtd/1:2370
    1        0        0                     krxrpcd/1:2757
    1        3        3                     reiserfs/1:2897
    1        3        3        4        4   `-flush_async_commits+0x0/0x90

[ Impact: report the typical latency case caused by a worklet ]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/trace/trace_workqueue.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 798a738..1c6555d 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -35,6 +35,7 @@ struct workfunc_stats {
 	/* save execution time temporarily for calculate executed time */
 	u64				start_time;
 	u64				max_executed_time;
+	u64				total_time;
 };
 
 /* A cpu workqueue thread */
@@ -191,6 +192,7 @@ found_wq:
 			continue;
 
 		executed_time = trace_clock_global() - wfnode->start_time;
+		wfnode->total_time += executed_time;
 		if (executed_time > wfnode->max_executed_time)
 			wfnode->max_executed_time = executed_time;
 		goto found_wf;
@@ -366,7 +368,7 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 
 	if (!wfstat->func) {
 		/* It is first dummy node, need to print workqueue info */
-		seq_printf(s, "  %3d   %6d   %6u          %s:%d\n",
+		seq_printf(s, "  %3d   %6d   %6u                     %s:%d\n",
 			   cws->cpu,
 			   cws->inserted,
 			   cws->executed,
@@ -375,11 +377,13 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 	} else {
 		/* It is effect node, need to print workfunc info */
 		int lastwf = list_is_last(&wfstat->list, &cws->workfunclist);
-		seq_printf(s, "  %3d   %6d   %6u   %6llu  %c-%pF\n",
+		seq_printf(s, "  %3d   %6d   %6u   %6llu   %6llu   %c-%pF\n",
 			cws->cpu,
 			wfstat->inserted,
 			wfstat->executed,
 			ns2usecs(wfstat->max_executed_time),
+			!wfstat->executed ? 0 :
+				ns2usecs(wfstat->total_time / wfstat->executed),
 			lastwf ? '`' : '|',
 			wfstat->func);
 	}
@@ -389,9 +393,11 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 
 static int workqueue_stat_headers(struct seq_file *s)
 {
-	seq_printf(s, "# CPU INSERTED EXECUTED M_EXECus	 TASKNAME:PID\n");
-	seq_printf(s, "#  |     |        |        |      `-WORKFUNC\n");
-	seq_printf(s, "#  |     |        |        |        |\n");
+	seq_printf(s, "# CPU INSERTED EXECUTED    MAX us   AVG us"
+			"   TASKNAME:PID\n");
+	seq_printf(s, "#  |     |        |           |      ` |"
+			"     -WORKFUNC\n");
+	seq_printf(s, "#  |     |        |           |        |          |\n");
 	return 0;
 }
 
-- 
1.6.2.3

