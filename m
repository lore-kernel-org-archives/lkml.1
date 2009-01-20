Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbZATObo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbZATObo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZATObe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:31:34 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:44988 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbZATObd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:31:33 -0500
Date: Tue, 20 Jan 2009 15:31:31 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] async: Rename _special -> _domain for clarity.
Message-ID: <20090120153131.71aa32f1@gondolin>
In-Reply-To: <20090119045242.73ba210f@infradead.org>
References: <20090113174306.0f620476@gondolin>
	<20090114024952.GS8071@disturbed>
	<20090114112450.1a1af271@gondolin>
	<20090118163912.55f835a0@infradead.org>
	<20090119044045.GA6654@disturbed>
	<20090119132744.0beee067@gondolin>
	<20090119045242.73ba210f@infradead.org>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the async_*_special() functions to async_*_domain(), which
describes the purpose of these functions much better.
[Broke up long lines to silence checkpatch]

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 fs/super.c            |    4 ++--
 include/linux/async.h |    8 +++++---
 kernel/async.c        |   41 ++++++++++++++++++++++-------------------
 3 files changed, 29 insertions(+), 24 deletions(-)

--- linux-2.6.orig/include/linux/async.h
+++ linux-2.6/include/linux/async.h
@@ -17,9 +17,11 @@ typedef u64 async_cookie_t;
 typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
 
 extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
-extern async_cookie_t async_schedule_special(async_func_ptr *ptr, void *data, struct list_head *list);
+extern async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
+					    struct list_head *list);
 extern void async_synchronize_full(void);
-extern void async_synchronize_full_special(struct list_head *list);
+extern void async_synchronize_full_domain(struct list_head *list);
 extern void async_synchronize_cookie(async_cookie_t cookie);
-extern void async_synchronize_cookie_special(async_cookie_t cookie, struct list_head *list);
+extern void async_synchronize_cookie_domain(async_cookie_t cookie,
+					    struct list_head *list);
 
--- linux-2.6.orig/kernel/async.c
+++ linux-2.6/kernel/async.c
@@ -221,22 +221,23 @@ async_cookie_t async_schedule(async_func
 EXPORT_SYMBOL_GPL(async_schedule);
 
 /**
- * async_schedule_special - schedule a function for asynchronous execution with a special running queue
+ * async_schedule_domain - schedule a function for asynchronous execution within a certain domain
  * @ptr: function to execute asynchronously
  * @data: data pointer to pass to the function
- * @running: list head to add to while running
+ * @running: running list for the domain
  *
  * Returns an async_cookie_t that may be used for checkpointing later.
- * @running may be used in the async_synchronize_*_special() functions
- * to wait on a special running queue rather than on the global running
- * queue.
+ * @running may be used in the async_synchronize_*_domain() functions
+ * to wait within a certain synchronization domain rather than globally.
+ * A synchronization domain is specified via the running queue @running to use.
  * Note: This function may be called from atomic or non-atomic contexts.
  */
-async_cookie_t async_schedule_special(async_func_ptr *ptr, void *data, struct list_head *running)
+async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
+				     struct list_head *running)
 {
 	return __async_schedule(ptr, data, running);
 }
-EXPORT_SYMBOL_GPL(async_schedule_special);
+EXPORT_SYMBOL_GPL(async_schedule_domain);
 
 /**
  * async_synchronize_full - synchronize all asynchronous function calls
@@ -252,27 +253,29 @@ void async_synchronize_full(void)
 EXPORT_SYMBOL_GPL(async_synchronize_full);
 
 /**
- * async_synchronize_full_special - synchronize all asynchronous function calls for a running list
+ * async_synchronize_full_domain - synchronize all asynchronous function within a certain domain
  * @list: running list to synchronize on
  *
- * This function waits until all asynchronous function calls for the running
- * list @list have been done.
+ * This function waits until all asynchronous function calls for the
+ * synchronization domain specified by the running list @list have been done.
  */
-void async_synchronize_full_special(struct list_head *list)
+void async_synchronize_full_domain(struct list_head *list)
 {
-	async_synchronize_cookie_special(next_cookie, list);
+	async_synchronize_cookie_domain(next_cookie, list);
 }
-EXPORT_SYMBOL_GPL(async_synchronize_full_special);
+EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 
 /**
- * async_synchronize_cookie_special - synchronize asynchronous function calls on a running list with cookie checkpointing
+ * async_synchronize_cookie_domain - synchronize asynchronous function calls within a certain domain with cookie checkpointing
  * @cookie: async_cookie_t to use as checkpoint
  * @running: running list to synchronize on
  *
- * This function waits until all asynchronous function calls for the running
- * list @list submitted prior to @cookie have been done.
+ * This function waits until all asynchronous function calls for the
+ * synchronization domain specified by the running list @list submitted
+ * prior to @cookie have been done.
  */
-void async_synchronize_cookie_special(async_cookie_t cookie, struct list_head *running)
+void async_synchronize_cookie_domain(async_cookie_t cookie,
+				     struct list_head *running)
 {
 	ktime_t starttime, delta, endtime;
 
@@ -291,7 +294,7 @@ void async_synchronize_cookie_special(as
 			task_pid_nr(current), ktime_to_ns(delta) >> 10);
 	}
 }
-EXPORT_SYMBOL_GPL(async_synchronize_cookie_special);
+EXPORT_SYMBOL_GPL(async_synchronize_cookie_domain);
 
 /**
  * async_synchronize_cookie - synchronize asynchronous function calls with cookie checkpointing
@@ -302,7 +305,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_cook
  */
 void async_synchronize_cookie(async_cookie_t cookie)
 {
-	async_synchronize_cookie_special(cookie, &async_running);
+	async_synchronize_cookie_domain(cookie, &async_running);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_cookie);
 
--- linux-2.6.orig/fs/super.c
+++ linux-2.6/fs/super.c
@@ -301,7 +301,7 @@ void generic_shutdown_super(struct super
 		/*
 		 * wait for asynchronous fs operations to finish before going further
 		 */
-		async_synchronize_full_special(&sb->s_async_list);
+		async_synchronize_full_domain(&sb->s_async_list);
 
 		/* bad name - it should be evict_inodes() */
 		invalidate_inodes(sb);
@@ -470,7 +470,7 @@ restart:
 		sb->s_count++;
 		spin_unlock(&sb_lock);
 		down_read(&sb->s_umount);
-		async_synchronize_full_special(&sb->s_async_list);
+		async_synchronize_full_domain(&sb->s_async_list);
 		if (sb->s_root && (wait || sb->s_dirt))
 			sb->s_op->sync_fs(sb, wait);
 		up_read(&sb->s_umount);
