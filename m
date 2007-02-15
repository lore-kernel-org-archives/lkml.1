Return-Path: <linux-kernel-owner+w=401wt.eu-S1161249AbXBOX4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161249AbXBOX4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:56:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161652AbXBOX4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:56:07 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:40114 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161249AbXBOX4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:56:06 -0500
Message-id: <25269175172137025681@wsc.cz>
In-reply-to: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
Subject: [PATCH 1/1] unify queue_delayed_work and queue_delayed_work_on fix
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Date: Fri, 16 Feb 2007 00:56:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.20-mm1/
[...]
> +unify-queue_delayed_work-and-queue_delayed_work_on.patch

I'm getting oops in delayed_work_timer_fn, since cwq->wq is NULL and accessed
there. The patch below fixes the problem for me.

--

unify queue_delayed_work and queue_delayed_work_on fix

Since cwq->wq is unset for other than singlethread_cpu when singlethread
workqueue was created, an oops occurs during bootup. Fix it by setting
correct private value for workqueue.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 7bc281be5811f9b1dd01c25eaf492f4765737fd0
tree 7795008066bb89e7489384cde95e63260602d5af
parent 61c2024a2dd044e32747542cfbf4b22251df3bc2
author Jiri Slaby <jirislaby@gmail.com> Fri, 16 Feb 2007 00:49:15 +0100
committer Jiri Slaby <jirislaby@gmail.com> Fri, 16 Feb 2007 00:49:15 +0100

 kernel/workqueue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f2089bf..af5e597 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -210,7 +210,8 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 
 		/* This stores cwq for the moment, for the timer_fn */
 		set_wq_data(work,
-			per_cpu_ptr(wq->cpu_wq, raw_smp_processor_id()));
+			per_cpu_ptr(wq->cpu_wq, wq->singlethread ?
+				singlethread_cpu : raw_smp_processor_id()));
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
