Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbYG2QTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbYG2QTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYG2QTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:19:30 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33842 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbYG2QT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:19:29 -0400
Date: Tue, 29 Jul 2008 20:22:46 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] workqueues: add comments to __create_workqueue_key()
Message-ID: <20080729162246.GB412@tv-sign.ru>
References: <1217277694.20627.9.camel@earth>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217277694.20627.9.camel@earth>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko pointed out that the error handling in
__create_workqueue_key() is not clear, add the comment.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- LINUS/kernel/workqueue.c~	2008-07-29 17:59:48.000000000 +0400
+++ LINUS/kernel/workqueue.c	2008-07-29 18:41:06.000000000 +0400
@@ -830,10 +830,21 @@ struct workqueue_struct *__create_workqu
 		start_workqueue_thread(cwq, -1);
 	} else {
 		cpu_maps_update_begin();
+		/*
+		 * We must place this wq on list even if the code below fails.
+		 * cpu_down(cpu) can remove cpu from cpu_populated_map before
+		 * destroy_workqueue() takes the lock, in that case we leak
+		 * cwq[cpu]->thread.
+		 */
 		spin_lock(&workqueue_lock);
 		list_add(&wq->list, &workqueues);
 		spin_unlock(&workqueue_lock);
-
+		/*
+		 * We must initialize cwqs for each possible cpu even if we
+		 * are going to call destroy_workqueue() finally. Otherwise
+		 * cpu_up() can hit the uninitialized cwq once we drop the
+		 * lock.
+		 */
 		for_each_possible_cpu(cpu) {
 			cwq = init_cpu_workqueue(wq, cpu);
 			if (err || !cpu_online(cpu))

