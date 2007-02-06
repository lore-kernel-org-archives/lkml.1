Return-Path: <linux-kernel-owner+w=401wt.eu-S1030575AbXBFXax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030575AbXBFXax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030583AbXBFXax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:30:53 -0500
Received: from mail.screens.ru ([213.234.233.54]:58456 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030575AbXBFXab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:30:31 -0500
Date: Wed, 7 Feb 2007 02:30:34 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] workqueue: introduce workqueue_struct->singlethread
Message-ID: <20070206233034.GA114@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add explicit workqueue_struct->singlethread flag. This lessens .text a little,
but most importantly this allows us to manipulate wq->list without changine the
meaning of is_single_threaded().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 6.20-rc6-mm3/kernel/workqueue.c~5_is_ss	2007-02-07 00:44:52.000000000 +0300
+++ 6.20-rc6-mm3/kernel/workqueue.c	2007-02-07 02:02:06.000000000 +0300
@@ -58,8 +58,9 @@ struct cpu_workqueue_struct {
  */
 struct workqueue_struct {
 	struct cpu_workqueue_struct *cpu_wq;
+	struct list_head list;
 	const char *name;
-	struct list_head list; 	/* Empty if single thread */
+	int singlethread;
 	int freezeable;		/* Freeze threads during suspend */
 };
 
@@ -76,7 +77,7 @@ static cpumask_t cpu_populated_map __rea
 /* If it's single threaded, it isn't in the list of workqueues. */
 static inline int is_single_threaded(struct workqueue_struct *wq)
 {
-	return list_empty(&wq->list);
+	return wq->singlethread;
 }
 
 static const cpumask_t *wq_cpu_map(struct workqueue_struct *wq)
@@ -691,10 +692,11 @@ struct workqueue_struct *__create_workqu
 	}
 
 	wq->name = name;
+	wq->singlethread = singlethread;
 	wq->freezeable = freezeable;
+	INIT_LIST_HEAD(&wq->list);
 
 	if (singlethread) {
-		INIT_LIST_HEAD(&wq->list);
 		cwq = init_cpu_workqueue(wq, singlethread_cpu);
 		err = create_workqueue_thread(cwq, singlethread_cpu);
 	} else {

