Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbZEMRAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbZEMRAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 13:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759402AbZEMRAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 13:00:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58599 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602AbZEMRAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 13:00:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <a24804730905130931g6acbe0b1t6a6656d51c937624@mail.gmail.com>
References: <a24804730905130931g6acbe0b1t6a6656d51c937624@mail.gmail.com> <alpine.DEB.2.00.0905100336130.27219@ubuntu-desktop> <alpine.DEB.2.00.0905101959070.2913@ubuntu-desktop> <5083.1242215914@redhat.com>
To: Chris Peterson <cpeterso@cpeterso.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] use round_jiffies() for slow work thread pool's 5 second cull timer
Date: Wed, 13 May 2009 18:00:09 +0100
Message-ID: <14605.1242234009@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


How about this modified version of your patch?

David
---
From: Chris Peterson <cpeterso@cpeterso.com>
Subject: [PATCH] Use round_jiffies() for slow work thread pool's cull and OOM timers

Round the slow work queue's cull and OOM timeouts to whole second boundary with
round_jiffies().  The slow work queue uses a pair of timers to cull idle
threads and, after OOM, to delay new thread creation.

This patch also extracts the mod_timer() logic for the cull timer into a
separate helper function.

By rounding non-time-critical timers such as these to whole seconds, they will
be batched up to fire at the same time rather than being spread out.  This
allows the CPU wake up less, which saves power.

Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/slow-work.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)


diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index 96e418d..a3ce6cf 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -319,6 +319,15 @@ cant_get_ref:
 EXPORT_SYMBOL(slow_work_enqueue);
 
 /*
+ * Schedule a cull of the thread pool at some time in the near future
+ */
+static void slow_work_schedule_cull(void)
+{
+	mod_timer(&slow_work_cull_timer,
+		  round_jiffies(jiffies + SLOW_WORK_CULL_TIMEOUT));
+}
+
+/*
  * Worker thread culling algorithm
  */
 static bool slow_work_cull_thread(void)
@@ -335,8 +344,7 @@ static bool slow_work_cull_thread(void)
 		    list_empty(&vslow_work_queue) &&
 		    atomic_read(&slow_work_thread_count) >
 		    slow_work_min_threads) {
-			mod_timer(&slow_work_cull_timer,
-				  jiffies + SLOW_WORK_CULL_TIMEOUT);
+			slow_work_schedule_cull();
 			do_cull = true;
 		}
 	}
@@ -394,8 +402,7 @@ static int slow_work_thread(void *_data)
 			    list_empty(&vslow_work_queue) &&
 			    atomic_read(&slow_work_thread_count) >
 			    slow_work_min_threads)
-				mod_timer(&slow_work_cull_timer,
-					  jiffies + SLOW_WORK_CULL_TIMEOUT);
+				slow_work_schedule_cull();
 			continue;
 		}
 
@@ -460,7 +467,7 @@ static void slow_work_new_thread_execute(struct slow_work *work)
 		if (atomic_dec_and_test(&slow_work_thread_count))
 			BUG(); /* we're running on a slow work thread... */
 		mod_timer(&slow_work_oom_timer,
-			  jiffies + SLOW_WORK_OOM_TIMEOUT);
+			  round_jiffies(jiffies + SLOW_WORK_OOM_TIMEOUT));
 	} else {
 		/* ratelimit the starting of new threads */
 		mod_timer(&slow_work_oom_timer, jiffies + 1);
@@ -504,8 +511,7 @@ static int slow_work_min_threads_sysctl(struct ctl_table *table, int write,
 			if (n < 0 && !slow_work_may_not_start_new_thread)
 				slow_work_enqueue(&slow_work_new_thread);
 			else if (n > 0)
-				mod_timer(&slow_work_cull_timer,
-					  jiffies + SLOW_WORK_CULL_TIMEOUT);
+				slow_work_schedule_cull();
 		}
 		mutex_unlock(&slow_work_user_lock);
 	}
@@ -531,8 +537,7 @@ static int slow_work_max_threads_sysctl(struct ctl_table *table, int write,
 				atomic_read(&slow_work_thread_count);
 
 			if (n < 0)
-				mod_timer(&slow_work_cull_timer,
-					  jiffies + SLOW_WORK_CULL_TIMEOUT);
+				slow_work_schedule_cull();
 		}
 		mutex_unlock(&slow_work_user_lock);
 	}
