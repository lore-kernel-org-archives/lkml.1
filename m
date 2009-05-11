Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZEKABs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZEKABs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 20:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbZEKABj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 20:01:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:57338 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbZEKABj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 20:01:39 -0400
Date: Sun, 10 May 2009 20:01:18 -0400 (EDT)
From: Chris Peterson <cpeterso@cpeterso.com>
X-X-Sender: user@ubuntu-desktop
To: dhowells@redhat.com
cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] use round_jiffies() for slow work thread pool's 5 second
 cull timer
In-Reply-To: <alpine.DEB.2.00.0905100336130.27219@ubuntu-desktop>
Message-ID: <alpine.DEB.2.00.0905101959070.2913@ubuntu-desktop>
References: <alpine.DEB.2.00.0905100336130.27219@ubuntu-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a revised patch to round the slow work queue's 5 second timers to 
whole seconds with round_jiffies(). The slow work queue uses 5 second 
timers to cull idle threads and, after OOM, to delay new thread 
creation.This patch also refactors the mod_timer() logic into a separate 
helper function.

Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>
---
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index b28d191..0ef9bf9 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -318,6 +318,12 @@ cant_get_ref:
 }
 EXPORT_SYMBOL(slow_work_enqueue);
 
+static void slow_work_defer_cull_time(void)
+{
+	mod_timer(&slow_work_cull_timer,
+			  round_jiffies(jiffies + SLOW_WORK_CULL_TIMEOUT));
+}
+
 /*
  * Worker thread culling algorithm
  */
@@ -335,8 +341,7 @@ static bool slow_work_cull_thread(void)
 		    list_empty(&vslow_work_queue) &&
 		    atomic_read(&slow_work_thread_count) >
 		    slow_work_min_threads) {
-			mod_timer(&slow_work_cull_timer,
-				  jiffies + SLOW_WORK_CULL_TIMEOUT);
+			slow_work_defer_cull_time();
 			do_cull = true;
 		}
 	}
@@ -393,8 +398,7 @@ static int slow_work_thread(void *_data)
 			    list_empty(&vslow_work_queue) &&
 			    atomic_read(&slow_work_thread_count) >
 			    slow_work_min_threads)
-				mod_timer(&slow_work_cull_timer,
-					  jiffies + SLOW_WORK_CULL_TIMEOUT);
+				slow_work_defer_cull_time();
 			continue;
 		}
 
@@ -458,7 +462,7 @@ static void slow_work_new_thread_execute(struct slow_work *work)
 		if (atomic_dec_and_test(&slow_work_thread_count))
 			BUG(); /* we're running on a slow work thread... */
 		mod_timer(&slow_work_oom_timer,
-			  jiffies + SLOW_WORK_OOM_TIMEOUT);
+				round_jiffies(jiffies + SLOW_WORK_OOM_TIMEOUT));
 	} else {
 		/* ratelimit the starting of new threads */
 		mod_timer(&slow_work_oom_timer, jiffies + 1);
@@ -502,8 +506,7 @@ static int slow_work_min_threads_sysctl(struct ctl_table *table, int write,
 			if (n < 0 && !slow_work_may_not_start_new_thread)
 				slow_work_enqueue(&slow_work_new_thread);
 			else if (n > 0)
-				mod_timer(&slow_work_cull_timer,
-					  jiffies + SLOW_WORK_CULL_TIMEOUT);
+				slow_work_defer_cull_time();
 		}
 		mutex_unlock(&slow_work_user_lock);
 	}
@@ -529,8 +532,7 @@ static int slow_work_max_threads_sysctl(struct ctl_table *table, int write,
 				atomic_read(&slow_work_thread_count);
 
 			if (n < 0)
-				mod_timer(&slow_work_cull_timer,
-					  jiffies + SLOW_WORK_CULL_TIMEOUT);
+				slow_work_defer_cull_time();
 		}
 		mutex_unlock(&slow_work_user_lock);
 	}
