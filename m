Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbZASMqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbZASMqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759906AbZASMq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:46:27 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:45323 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759580AbZASMq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:46:26 -0500
Date: Mon, 19 Jan 2009 13:45:33 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] async: Add some documentation.
Message-ID: <20090119134533.0c86d2d5@gondolin>
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

Add some kerneldoc to the async interface.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 kernel/async.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

--- linux-2.6.orig/kernel/async.c
+++ linux-2.6/kernel/async.c
@@ -206,18 +206,43 @@ static async_cookie_t __async_schedule(a
 	return newcookie;
 }
 
+/**
+ * async_schedule - schedule a function for asynchronous execution
+ * @ptr: function to execute asynchronously
+ * @data: data pointer to pass to the function
+ *
+ * Returns an async_cookie_t that may be used for checkpointing later.
+ * Note: This function may be called from atomic or non-atomic contexts.
+ */
 async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
 {
 	return __async_schedule(ptr, data, &async_running);
 }
 EXPORT_SYMBOL_GPL(async_schedule);
 
+/**
+ * async_schedule_special - schedule a function for asynchronous execution with a special running queue
+ * @ptr: function to execute asynchronously
+ * @data: data pointer to pass to the function
+ * @running: list head to add to while running
+ *
+ * Returns an async_cookie_t that may be used for checkpointing later.
+ * @running may be used in the async_synchronize_*_special() functions
+ * to wait on a special running queue rather than on the global running
+ * queue.
+ * Note: This function may be called from atomic or non-atomic contexts.
+ */
 async_cookie_t async_schedule_special(async_func_ptr *ptr, void *data, struct list_head *running)
 {
 	return __async_schedule(ptr, data, running);
 }
 EXPORT_SYMBOL_GPL(async_schedule_special);
 
+/**
+ * async_synchronize_full - synchronize all asynchronous function calls
+ *
+ * This function waits until all asynchronous function calls have been done.
+ */
 void async_synchronize_full(void)
 {
 	do {
@@ -226,12 +251,27 @@ void async_synchronize_full(void)
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full);
 
+/**
+ * async_synchronize_full_special - synchronize all asynchronous function calls for a running list
+ * @list: running list to synchronize on
+ *
+ * This function waits until all asynchronous function calls for the running
+ * list @list have been done.
+ */
 void async_synchronize_full_special(struct list_head *list)
 {
 	async_synchronize_cookie_special(next_cookie, list);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full_special);
 
+/**
+ * async_synchronize_cookie_special - synchronize asynchronous function calls on a running list with cookie checkpointing
+ * @cookie: async_cookie_t to use as checkpoint
+ * @running: running list to synchronize on
+ *
+ * This function waits until all asynchronous function calls for the running
+ * list @list submitted prior to @cookie have been done.
+ */
 void async_synchronize_cookie_special(async_cookie_t cookie, struct list_head *running)
 {
 	ktime_t starttime, delta, endtime;
@@ -253,6 +293,13 @@ void async_synchronize_cookie_special(as
 }
 EXPORT_SYMBOL_GPL(async_synchronize_cookie_special);
 
+/**
+ * async_synchronize_cookie - synchronize asynchronous function calls with cookie checkpointing
+ * @cookie: async_cookie_t to use as checkpoint
+ *
+ * This function waits until all asynchronous function calls prior to @cookie
+ * have been done.
+ */
 void async_synchronize_cookie(async_cookie_t cookie)
 {
 	async_synchronize_cookie_special(cookie, &async_running);
