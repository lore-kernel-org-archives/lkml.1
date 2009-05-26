Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbZEZIXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbZEZIXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbZEZIXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:23:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59716 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbZEZIXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:23:08 -0400
Message-ID: <4A1BA696.9090404@cn.fujitsu.com>
Date: Tue, 26 May 2009 16:21:42 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] tracing/workqueue: make events sort in ascending order
References: <4A1BA322.9060505@cn.fujitsu.com>
In-Reply-To: <4A1BA322.9060505@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Events in workqueue tracer need to be sorted in ascending order to make user
clear.
But now it is reversed by "tracing/stat: replace linked list by an rbtree
for sorting"(53059c9b67a62a3dc8c80204d3da42b9267ea5a0).
We need to define a custom cmp() callback to make sorting correct.

Before patch:
 # CPU INSERTED EXECUTED   MAX us   AVG us   TASKNAME:PID
 #  |     |        |         |        |      `-WORKFUNC
 #  |     |        |         |        |           |
     0        1        1     1155     1155   `-xprt_autoclose
     0       19       19      864      143   |-xs_udp_connect_worker4
 ...
     0        1        1     4825     4825   |-reg_todo
     0      443      515                     events/0:5

After patch:
 # CPU INSERTED EXECUTED   MAX us   AVG us   TASKNAME:PID
 #  |     |        |         |        |      `-WORKFUNC
 #  |     |        |         |        |           |
     0      443      515                     events/0:5
     0        1        1     4825     4825   |-reg_todo
 ...
     0       19       19      797      134   |-xs_udp_connect_worker4
     0        1        1     8359     8359   `-xprt_autoclose

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace_workqueue.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 53fe43e..7fa0d23 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -383,6 +383,12 @@ static void *workqueue_stat_next(void *prev, int idx)
 	return ret;
 }
 
+/* To make events sort in ascending order */
+static int workqueue_stat_cmp(void *p1, void *p2)
+{
+	return -1;
+}
+
 static int workqueue_stat_show(struct seq_file *s, void *p)
 {
 	struct workfunc_stats *wfstat = p;
@@ -470,6 +476,7 @@ static struct tracer_stat workqueue_stats __read_mostly = {
 	.name		= "workqueues",
 	.stat_start	= workqueue_stat_start,
 	.stat_next	= workqueue_stat_next,
+	.stat_cmp	= workqueue_stat_cmp,
 	.stat_show	= workqueue_stat_show,
 	.stat_headers	= workqueue_stat_headers,
 	.file_open	= workqueue_stat_file_open,
-- 
1.5.5.3

