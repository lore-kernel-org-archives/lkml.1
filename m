Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbZEJHke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbZEJHke (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 03:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZEJHk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 03:40:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:25789 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbZEJHkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 03:40:25 -0400
Date: Sun, 10 May 2009 03:40:16 -0400 (EDT)
From: Chris Peterson <cpeterso@cpeterso.com>
X-X-Sender: user@ubuntu-desktop
To: dhowells@redhat.com
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] use round_jiffies() for slow work thread pool's 5 second
 cull timer
Message-ID: <alpine.DEB.2.00.0905100336130.27219@ubuntu-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The slow work thread pool culls its idle threads after 5 seconds without any work requests. Also, the slow work thread pool waits 5 seconds before starting new threads after OOM.

This patch uses round_jiffies() to round these 5 second timers to whole seconds. In this case, the actual timer wait would be between 4.75 and 5.75 seconds (because round_jiffies() rounds < 0.25 seconds down and > 0.25 seconds up). This patch also refactors the mod_timer() logic into a separate helper function.

Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>
---
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index b28d191..9bfcb53 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -318,6 +318,12 @@ cant_get_ref:
 }
 EXPORT_SYMBOL(slow_work_enqueue);
 
+static void slow_work_defer_cull_time(void)
+{
+	mod_timer(&slow_work_cull_timer,
+			  round_jiffies_relative(SLOW_WORK_CULL_TIMEOUT));
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
+				round_jiffies_relative(SLOW_WORK_OOM_TIMEOUT));
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
