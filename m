Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbXJVMSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbXJVMSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXJVMSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:18:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48593 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbXJVMSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:18:42 -0400
Subject: [RFC/PATCH 5/3] rt: PI-workqueue: fixup the barrier prio
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Daniel Walker <dwalker@mvista.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <1193053713.27435.172.camel@twins>
References: <20071022095054.393085000@chello.nl>
	 <20071022095659.005996000@chello.nl>  <1193053713.27435.172.camel@twins>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 14:18:33 +0200
Message-Id: <1193055513.27435.179.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven is right in that I did over-user normal_prio a bit.
the barriers should use the boosted prio.

---

Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c
+++ linux-2.6/kernel/workqueue.c
@@ -387,7 +387,7 @@ static void insert_wq_barrier(struct cpu
 
 	init_completion(&barr->done);
 
-	insert_work(cwq, &barr->work, 0, current->normal_prio, tail);
+	insert_work(cwq, &barr->work, 0, current->prio, tail);
 }
 
 static void wq_full_barrier_func(struct work_struct *work)
@@ -418,9 +418,9 @@ static void insert_wq_full_barrier(struc
 	plist_head_splice(&cwq->worklist, &barr->worklist);
 	barr->cwq = cwq;
 	init_completion(&barr->done);
-	barr->waiter_prio = current->normal_prio;
+	barr->waiter_prio = current->prio;
 
-	insert_work(cwq, &barr->work, 0, current->normal_prio, 1);
+	insert_work(cwq, &barr->work, 0, current->prio, 1);
 }
 
 static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)


