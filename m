Return-Path: <linux-kernel-owner+w=401wt.eu-S1762533AbZD3Aef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762533AbZD3Aef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761592AbZD3A2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:28:07 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48086 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761578AbZD3A2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:28:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OaM+ssygygHBgEIKu6cNUfkuj3WJeSwwD4ev9b9p2mkDUvkzJHDHBHAMPZFNi4KijL
         LWl53jxZB/wQV0T+1LMnQYRylzGEuCx8+Z/eDDsFgE/w1+nZ6fJ7IwVT72cw6oyjRPz1
         j1woZ8ygkjR+g3oCzSp5U9CKyZ4EE2ofX+Cvg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhao Lei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 19/19] tracing/workqueue: provide documentation for the workqueue tracer
Date: Thu, 30 Apr 2009 02:27:20 +0200
Message-Id: <1241051240-4280-20-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a quick documentation for both stat and event tracing with
the workqueue tracer.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 Documentation/trace/workqueue.txt |  114 +++++++++++++++++++++++++++++++++++++
 1 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/workqueue.txt b/Documentation/trace/workqueue.txt
new file mode 100644
index 0000000..4019a8a
--- /dev/null
+++ b/Documentation/trace/workqueue.txt
@@ -0,0 +1,114 @@
+The workqueue tracer is a tool that can provide informations
+about worklets execution frequency, latency and worklets/workqueues
+lifecycle.
+
+== A statistical/histogram tracer ==
+
+This tracer provides a snapshot of the workqueues and worklets
+current state.
+
+Eg:
+
+# CPU INSERTED EXECUTED    MAX us   AVG us   TASKNAME:PID
+#  |     |        |           |      ` |     -WORKFUNC
+#  |     |        |           |        |          |
+    0     5903     5977                     events/0:9
+    0        1        1       38       38   |-hpet_work
+    0       49       48      295      224   |-rt_worker_func
+    0     2934     2933       73       11   |-vmstat_update
+    0      935      935    13143      264   |-console_callback
+    0       80       80   1634632587   45804402   |-test_work
+    0       10        9      239       85   |-rekey_seq_generator
+    0       10       10        0        0   |-lru_add_drain_per_cpu
+    0        1        1        4        4   |-sync_cmos_clock
+    0      651      651      366       65   |-flush_to_ldisc
+    0     1105     1105    13171      256   |-fb_flashcursor
+    0      127      120      213       18   `-dst_gc_task
+    0        0        0                     cpuset:11
+    0     1409     1409                     khelper:12
+    0     1409     1409   124030      754   `-__call_usermodehelper
+    0        0        0                     kintegrityd/0:174
+    0     5823     5823                     kblockd/0:179
+    0      336      336      176       40   |-blk_unplug_work
+    0     5487     5487      141       21   `-cfq_kick_queue
+    0        0        0                     kacpid:186
+    0        0        0                     kacpi_notify:187
+    0        0        0                     tifm:498
+    0    19505    19505                     ata/0:508
+    0    19505    19505      114       24   `-ata_pio_task
+    0        0        0                     ata_aux:511
+    0        0        0                     aio/0:871
+    0        0        0                     crypto/0:897
+    0        0        0                     scsi_tgtd/0:2368
+    0        0        0                     iscsi_eh:2386
+    0        0        0                     kpsmoused:2525
+    0        0        0                     hd-audio0:2714
+    0        0        0                     krxrpcd/0:2752
+    0      242      242                     reiserfs/0:2896
+    0      242      242   4563280    21918   `-flush_async_commits
+    1        0        0                     reiserfs/1:6438
+    1        0        0                     krxrpcd/1:6439
+    1        0        0                     scsi_tgtd/1:6440
+    1        0        0                     crypto/1:6441
+    1        0        0                     aio/1:6442
+    1       62       62                     ata/1:6443
+    1       62       62       28       24   `-ata_pio_task
+    1        9        9                     kblockd/1:6444
+    1        9        9      102       54   `-blk_unplug_work
+    1        0        0                     kintegrityd/1:6445
+    1     2544     2545                     events/1:6446
+    1     2541     2540       22       11   |-vmstat_update
+    1        1        1       15       15   |-hpet_work
+    1        2        2       10        6   `-lru_add_drain_per_cpu
+
+For each worklet, you can find how much it has been enqueued
+and executed. Also the MAX us and AVG us give you respectively
+the maximum and average time of execution in microseconds
+for a given worklet.
+
+A series of worklets is grouped under a workqueue using the
+following pattern:
+
+cpu_workqueue_thread[/cpu_nr]:pid
+|-work1
+|-work2
+...
+`-last_work
+
+If cpu_nr is not given, then the workqueue thread is
+a singlethread workqueue, bound to every possible cpu.
+
+Use the following commands to read a snapshot:
+
+mount -t debugfs debug /sys/kernel/debug/
+cat /sys/kernel/debug/tracing/trace_stat/workqueues
+
+
+== An event tracer ==
+
+The workqueue tracer also uses a set of events tracepoints which
+can be used to trace each key event from every workqueues or worklets.
+
+You can refer to Documentation/trace/events.txt for a detailed
+use of the events tracepoints. How to individually toggle them, how
+to use filters, which field is what, etc...
+
+For a simple capture of all workqueues events:
+
+# mount -t debugfs debug /sys/kernel/debug/
+# cd /sys/kernel/debug/tracing/events/workqueue
+# ls
+filter          worklet_complete  worklet_enqueue_delayed  workqueue_creation     workqueue_flush
+worklet_cancel  worklet_enqueue   worklet_execute          workqueue_destruction
+# for e in $(ls); do echo 1 > $e/enable; done
+# cat /sys/kernel/debug/tracing/trace
+
+ #
+ # TASK-PID    CPU#    TIMESTAMP  FUNCTION
+ #   | |       |          |         |
+
+<...>-5627  [000]  4597.858645: worklet_enqueue: thread=ata/0:508 func=ata_pio_task+0x0/0x280 cpu=0
+<...>-508   [000]  4597.858660: worklet_execute: thread=ata/0:508 work=ffff88007e9e67b8 func=ata_pio_task+0x0/0x280
+<...>-508   [000]  4597.858684: worklet_complete: thread=ata/0:508 work=ffff88007e9e67b8
+<...>-2437  [000]  4597.861259: worklet_cancel: func=ata_pio_task+0x0/0x280
+[...]
-- 
1.6.2.3

