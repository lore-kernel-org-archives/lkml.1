Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936055Ab0BZMPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:15:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:43531 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936025Ab0BZMPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:15:09 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 40/43] fscache: drop references to slow-work
Date: Fri, 26 Feb 2010 21:23:17 +0900
Message-Id: <1267187000-18791-41-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fscache no longer uses slow-work.  Drop references to it.

NOT_SIGNED_OFF_YET
Cc: David Howells <dhowells@redhat.com>
---
 fs/fscache/Kconfig            |    1 -
 fs/fscache/main.c             |    7 -------
 include/linux/fscache-cache.h |    1 -
 3 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/fs/fscache/Kconfig b/fs/fscache/Kconfig
index 864dac2..526245a 100644
--- a/fs/fscache/Kconfig
+++ b/fs/fscache/Kconfig
@@ -2,7 +2,6 @@
 config FSCACHE
 	tristate "General filesystem local caching manager"
 	depends on EXPERIMENTAL
-	select SLOW_WORK
 	help
 	  This option enables a generic filesystem caching manager that can be
 	  used by various network and other filesystems to cache data locally.
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 9250470..7404b0e 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -138,10 +138,6 @@ static int __init fscache_init(void)
 	unsigned int cpu;
 	int ret;
 
-	ret = slow_work_register_user(THIS_MODULE);
-	if (ret < 0)
-		goto error_slow_work;
-
 	fscache_object_max_active =
 		clamp_val(nr_cpus, fscache_object_max_active, WQ_MAX_ACTIVE);
 
@@ -213,8 +209,6 @@ error_proc:
 error_op_wq:
 	destroy_workqueue(fscache_object_wq);
 error_object_wq:
-	slow_work_unregister_user(THIS_MODULE);
-error_slow_work:
 	return ret;
 }
 
@@ -233,7 +227,6 @@ static void __exit fscache_exit(void)
 	fscache_proc_cleanup();
 	destroy_workqueue(fscache_op_wq);
 	destroy_workqueue(fscache_object_wq);
-	slow_work_unregister_user(THIS_MODULE);
 	printk(KERN_NOTICE "FS-Cache: Unloaded\n");
 }
 
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index aed1cf5..5816e56 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -20,7 +20,6 @@
 
 #include <linux/fscache.h>
 #include <linux/sched.h>
-#include <linux/slow-work.h>
 #include <linux/workqueue.h>
 
 #define NR_MAXCACHES BITS_PER_LONG
-- 
1.6.4.2

