Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZBIKSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZBIKSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZBIKSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:18:03 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:43710 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbZBIKR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:17:58 -0500
Date: Mon, 9 Feb 2009 11:17:55 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fastboot: keep at least one thread per cpu during boot
Message-ID: <20090209111755.6bc2b93e@gondolin>
In-Reply-To: <20090208212748.4b7569b5@infradead.org>
References: <20090209034826.GA4768@nowhere>
	<20090208212748.4b7569b5@infradead.org>
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

On Sun, 8 Feb 2009 21:27:48 -0800,
Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 9 Feb 2009 04:48:27 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Async threads are created and destroyed depending on the number of
> > jobs in queue. It means that several async threads can be created for
> > a specific batch of work, then the threads will die after the
> > completion of this batch, but they could be needed just after this
> > completion for another batch of work. During the boot, such
> > repetitive thread creations can be wasteful, that's why this patch
> > proposes to keep at least one thread per cpu (if they already have
> > been created once). Such a threshold of threads kept alive will
> > prevent from a part of the thread creation overhead. This threshold
> > will be dropped one the system_state switches from SYSTEM_BOOTING to
> > SYSTEM_RUNNING.
> 
> I'm not very fond of this to be honest;
> at least during boot there's enough activity, and the time is so short
> (that's the point of the parallel stuff!) that this will not kick in to
> make a difference; specifically, every boot I've seen the number of
> threads is highest near the end, and also the total kernel boot time is
> below 1.5 seconds or so, not long enough for the threads to die.
> 
> Creating a thread is *CHEAP*. Really really cheap. You can do 100
> thousands/second on even a modest CPU. If you have a high frequency of
> events, you don't want this, sure, and that is why there is a one
> second delay to give opportunity for reuse... but really....

Agreed.

> 
> 
> Now, if async function calls get used more, I can see the point of
> always keeping one thread alive, just for both performance and VM low
> memory issues; but that's not what your patch is doing.

I'd argue that the ability to _schedule_ async stuff without memory
allocation would help more with low memory situations - after all, the
work has been scheduled for later.

(For that, I have hacked up the following completely untested patch,
but I'm not yet completely happy with it.)

---
 include/linux/async.h |   19 +++++++++
 kernel/async.c        |  105 +++++++++++++++++++++++++++++++++-----------------
 2 files changed, 89 insertions(+), 35 deletions(-)

--- linux-2.6.orig/include/linux/async.h
+++ linux-2.6/include/linux/async.h
@@ -16,9 +16,28 @@
 typedef u64 async_cookie_t;
 typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
 
+/**
+ * struct async_entry - entry for asynchronous scheduling
+ * @list: anchor for internal lists
+ * @cookie: cookie for checkpointing
+ * @func: asynchronous function to execute
+ * @data: data to pass to the function
+ * @running: synchronization domain to use
+ * @persistent: 1 if the entry must not be deleted by the core
+ */
+struct async_entry {
+	struct list_head list;
+	async_cookie_t   cookie;
+	async_func_ptr	 *func;
+	void             *data;
+	struct list_head *running;
+	int              *persistent;
+};
+
 extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
 extern async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
 					    struct list_head *list);
+extern async_cookie_t async_schedule_prealloc(struct async_entry *entry);
 extern void async_synchronize_full(void);
 extern void async_synchronize_full_domain(struct list_head *list);
 extern void async_synchronize_cookie(async_cookie_t cookie);
--- linux-2.6.orig/kernel/async.c
+++ linux-2.6/kernel/async.c
@@ -68,14 +68,6 @@ static DEFINE_SPINLOCK(async_lock);
 
 static int async_enabled = 0;
 
-struct async_entry {
-	struct list_head list;
-	async_cookie_t   cookie;
-	async_func_ptr	 *func;
-	void             *data;
-	struct list_head *running;
-};
-
 static DECLARE_WAIT_QUEUE_HEAD(async_done);
 static DECLARE_WAIT_QUEUE_HEAD(async_new);
 
@@ -157,7 +149,8 @@ static void run_one_entry(void)
 	list_del(&entry->list);
 
 	/* 5) free the entry  */
-	kfree(entry);
+	if (!entry->persistent)
+		kfree(entry);
 	atomic_dec(&entry_count);
 
 	spin_unlock_irqrestore(&async_lock, flags);
@@ -170,34 +163,24 @@ out:
 	spin_unlock_irqrestore(&async_lock, flags);
 }
 
-
-static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct list_head *running)
+static async_cookie_t __async_run_sync(async_func_ptr *ptr, void *data)
 {
-	struct async_entry *entry;
-	unsigned long flags;
 	async_cookie_t newcookie;
-	
+	unsigned long flags;
 
-	/* allow irq-off callers */
-	entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
+	spin_lock_irqsave(&async_lock, flags);
+	newcookie = next_cookie++;
+	spin_unlock_irqrestore(&async_lock, flags);
 
-	/*
-	 * If we're out of memory or if there's too much work
-	 * pending already, we execute synchronously.
-	 */
-	if (!async_enabled || !entry || atomic_read(&entry_count) > MAX_WORK) {
-		kfree(entry);
-		spin_lock_irqsave(&async_lock, flags);
-		newcookie = next_cookie++;
-		spin_unlock_irqrestore(&async_lock, flags);
-
-		/* low on memory.. run synchronously */
-		ptr(data, newcookie);
-		return newcookie;
-	}
-	entry->func = ptr;
-	entry->data = data;
-	entry->running = running;
+	/* Run synchronously */
+	ptr(data, newcookie);
+	return newcookie;
+}
+
+static async_cookie_t __async_schedule(struct async_entry *entry)
+{
+	unsigned long flags;
+	async_cookie_t newcookie;
 
 	spin_lock_irqsave(&async_lock, flags);
 	newcookie = entry->cookie = next_cookie++;
@@ -208,6 +191,24 @@ static async_cookie_t __async_schedule(a
 	return newcookie;
 }
 
+static struct async_entry *__async_generate_entry(async_func_ptr *ptr,
+						  void *data,
+						  struct list_head *running)
+{
+	struct async_entry *entry;
+
+	if (!async_enabled || atomic_read(&entry_count) > MAX_WORK)
+		return NULL;
+	/* allow irq-off callers */
+	entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
+	if (entry) {
+		entry->func = ptr;
+		entry->data = data;
+		entry->running = running;
+	}
+	return entry;
+}
+
 /**
  * async_schedule - schedule a function for asynchronous execution
  * @ptr: function to execute asynchronously
@@ -218,7 +219,13 @@ static async_cookie_t __async_schedule(a
  */
 async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
 {
-	return __async_schedule(ptr, data, &async_running);
+	struct async_entry *entry;
+
+	entry = __async_generate_entry(ptr, data, &async_running);
+	if (entry)
+		return __async_schedule(entry);
+	else
+		return __async_run_sync(ptr, data);
 }
 EXPORT_SYMBOL_GPL(async_schedule);
 
@@ -237,11 +244,39 @@ EXPORT_SYMBOL_GPL(async_schedule);
 async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
 				     struct list_head *running)
 {
-	return __async_schedule(ptr, data, running);
+	struct async_entry *entry;
+
+	entry = __async_generate_entry(ptr, data, running);
+	if (entry)
+		return __async_schedule(entry);
+	else
+		return __async_run_sync(ptr, data);
 }
 EXPORT_SYMBOL_GPL(async_schedule_domain);
 
 /**
+ * async_schedule_prealloc - schedule a preallocated asynchronous entry
+ * @entry: pointer to asynchronous entry
+ *
+ * Returns an async_cookie_t that may be used for checkpointing later.
+ * The caller must have setup @entry before calling this function
+ * (especially @entry->func) and must make sure an entry is not scheduled
+ * multiple times simultaneously. @entry->running may be left blank to
+ * use the default synchronization domain.
+ * Note: This function may be called from atomic or non-atomic contexts.
+ */
+async_cookie_t async_schedule_prealloc(struct async_entry *entry)
+{
+	if (!entry->running)
+		entry->running = &async_running;
+	if (async_enabled && atomic_read(&entry_count) <= MAX_WORK)
+		return __async_schedule(entry);
+	else
+		return __async_run_sync(entry->func, entry->data);
+}
+EXPORT_SYMBOL_GPL(async_schedule_prealloc);
+
+/**
  * async_synchronize_full - synchronize all asynchronous function calls
  *
  * This function waits until all asynchronous function calls have been done.
