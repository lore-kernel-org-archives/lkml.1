Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790Ab0ARBDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab0ARBDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 20:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229Ab0ARBC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 20:02:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:54209 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab0ARAxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:53:05 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 37/40] fscache: drop references to slow-work
Date: Mon, 18 Jan 2010 09:57:49 +0900
Message-Id: <1263776272-382-38-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fscache no longer uses slow-work.  Drop references to it.

NOT_SIGNED_OFF_YET
Cc: David Howells <dhowells@redhat.com>
---
 fs/fscache/Kconfig            |    1 -
 fs/fscache/main.c             |   10 +---------
 include/linux/fscache-cache.h |    8 --------
 3 files changed, 1 insertions(+), 18 deletions(-)

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
index 908803c..3fb53e2 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -48,13 +48,8 @@ struct workqueue_struct *fscache_op_wq;
  */
 static int __init fscache_init(void)
 {
-	int ret;
+	int ret = -ENOMEM;
 
-	ret = slow_work_register_user(THIS_MODULE);
-	if (ret < 0)
-		goto error_slow_work;
-
-	ret = -ENOMEM;
 	fscache_object_wq =
 		__create_workqueue("fscache_object", WQ_SINGLE_CPU, 99);
 	if (!fscache_object_wq)
@@ -97,8 +92,6 @@ error_proc:
 error_op_wq:
 	destroy_workqueue(fscache_object_wq);
 error_object_wq:
-	slow_work_unregister_user(THIS_MODULE);
-error_slow_work:
 	return ret;
 }
 
@@ -116,7 +109,6 @@ static void __exit fscache_exit(void)
 	fscache_proc_cleanup();
 	destroy_workqueue(fscache_op_wq);
 	destroy_workqueue(fscache_object_wq);
-	slow_work_unregister_user(THIS_MODULE);
 	printk(KERN_NOTICE "FS-Cache: Unloaded\n");
 }
 
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 7791f2c..803c8a5 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -20,7 +20,6 @@
 
 #include <linux/fscache.h>
 #include <linux/sched.h>
-#include <linux/slow-work.h>
 #include <linux/workqueue.h>
 
 #define NR_MAXCACHES BITS_PER_LONG
@@ -102,15 +101,8 @@ struct fscache_operation {
 	/* operation releaser */
 	fscache_operation_release_t release;
 
-#ifdef CONFIG_SLOW_WORK_PROC
-	const char *name;		/* operation name */
-	const char *state;		/* operation state */
-#define fscache_set_op_name(OP, N)	do { (OP)->name  = (N); } while(0)
-#define fscache_set_op_state(OP, S)	do { (OP)->state = (S); } while(0)
-#else
 #define fscache_set_op_name(OP, N)	do { } while(0)
 #define fscache_set_op_state(OP, S)	do { } while(0)
-#endif
 };
 
 extern atomic_t fscache_op_debug_id;
-- 
1.6.4.2

