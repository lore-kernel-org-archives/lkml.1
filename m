Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbXEFXtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbXEFXtm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 19:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbXEFXtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 19:49:23 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1671 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbXEFXtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 19:49:18 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Date: Sun, 06 May 2007 16:49:15 -0700
Subject: [patch 3/4] KMON - kmon scheduler instrumentation ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.27461.1178495357.3>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hooks the kmon interface to the scheduler operations.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


Index: linux-2.6.21.scdev/kernel/sched.c
===================================================================
--- linux-2.6.21.scdev.orig/kernel/sched.c	2007-05-06 14:10:29.000000000 -0700
+++ linux-2.6.21.scdev/kernel/sched.c	2007-05-06 14:10:30.000000000 -0700
@@ -52,6 +52,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/kprobes.h>
 #include <linux/delayacct.h>
+#include <linux/kmon-stats.h>
 #include <asm/tlb.h>
 
 #include <asm/unistd.h>
@@ -691,10 +692,12 @@
 	list_del(&p->run_list);
 	if (list_empty(array->queue + p->prio))
 		__clear_bit(p->prio, array->bitmap);
+	kmon_st_task_dequeue(p);
 }
 
 static void enqueue_task(struct task_struct *p, struct prio_array *array)
 {
+	kmon_st_task_enqueue(p);
 	sched_info_queued(p);
 	list_add_tail(&p->run_list, array->queue + p->prio);
 	__set_bit(p->prio, array->bitmap);
@@ -1417,6 +1420,8 @@
 	int new_cpu;
 #endif
 
+	kmon_st_task_wakeup(in_interrupt() ? NULL: current, p);
+
 	rq = task_rq_lock(p, &flags);
 	old_state = p->state;
 	if (!(old_state & state))
@@ -3412,6 +3417,7 @@
 	prev->timestamp = prev->last_ran = now;
 
 	sched_info_switch(prev, next);
+	kmon_st_task_switch(prev, next);
 	if (likely(prev != next)) {
 		next->timestamp = next->last_ran = now;
 		rq->nr_switches++;

