Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbZBIDsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbZBIDsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 22:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZBIDsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 22:48:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:47720 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbZBIDsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 22:48:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=d/xp04txSZ9FeKUDVxUcYev/LAJL1/QSMDMWidK623CQkoswOUQMhDuOZq13DxPRqT
         CD0yt94sHFVcoO4+pd9RLFYkwray4Lv9x3szFFWnrQ+yaREqSDXWBMsBaKi2FFOrm7/5
         nYbnRhle+dbARkZ6dZxL8xqpj+WtnlGvE/894=
Date: Mon, 9 Feb 2009 04:48:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] fastboot: keep at least one thread per cpu during boot
Message-ID: <20090209034826.GA4768@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Async threads are created and destroyed depending on the number of jobs in queue.
It means that several async threads can be created for a specific batch of work,
then the threads will die after the completion of this batch, but they could be
needed just after this completion for another batch of work.
During the boot, such repetitive thread creations can be wasteful, that's why
this patch proposes to keep at least one thread per cpu (if they already have
been created once). Such a threshold of threads kept alive will prevent from
a part of the thread creation overhead.
This threshold will be dropped one the system_state switches from SYSTEM_BOOTING
to SYSTEM_RUNNING.

Note:
_ If this patch is accepted, I will try to extend it to modules loading on boot
_ One thread per cpu could sound a bit arbitrary here. Actually this is compromize
between memory saving (if we just created lots of async thread for a large batch
of jobs) and task creation overhead.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/async.h |    2 +
 init/main.c           |    1 +
 kernel/async.c        |   52 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/include/linux/async.h b/include/linux/async.h
index 68a9530..71a09e2 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -25,3 +25,5 @@ extern void async_synchronize_cookie(async_cookie_t cookie);
 extern void async_synchronize_cookie_domain(async_cookie_t cookie,
 					    struct list_head *list);
 
+extern void async_finish_boot(void);
+
diff --git a/init/main.c b/init/main.c
index 36de89b..fa99928 100644
--- a/init/main.c
+++ b/init/main.c
@@ -806,6 +806,7 @@ static noinline int init_post(void)
 	unlock_kernel();
 	mark_rodata_ro();
 	system_state = SYSTEM_RUNNING;
+	async_finish_boot();
 	numa_default_policy();
 
 	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
diff --git a/kernel/async.c b/kernel/async.c
index f565891..25c12d0 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -176,7 +176,7 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct l
 	struct async_entry *entry;
 	unsigned long flags;
 	async_cookie_t newcookie;
-	
+
 
 	/* allow irq-off callers */
 	entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
@@ -313,6 +313,54 @@ void async_synchronize_cookie(async_cookie_t cookie)
 EXPORT_SYMBOL_GPL(async_synchronize_cookie);
 
 
+/**
+ * async_finish_boot - wake up the async thread which stayed alive only to keep
+ * the minimum threshold of async threads on boot.
+ */
+void async_finish_boot(void)
+{
+	wake_up(&async_new);
+}
+
+/**
+ * Adaptive wait function for the async threads.
+ * While booting, we want to keep about one thread per
+ * cpu to avoid wasteful threads creations/deletions.
+ * We return in the normal async thread creation/deletion mode once
+ * the boot is finished, since async is most used during the boot.
+ *
+ * @return: 0 if we assume the thread should be destroyed
+ */
+static int async_thread_sleep(int timeout)
+{
+	static atomic_t nb_sleeping = ATOMIC_INIT(-1);
+	int tc;
+	int ret;
+
+	/*
+	 * If several async threads come here together and if we are in the
+	 * boot stage, those which overlap the number of boot thread threshold
+	 * will sleep and then assume they have to die...
+	 */
+	tc = atomic_read(&thread_count) - atomic_inc_return(&nb_sleeping);
+
+	if (system_state == SYSTEM_BOOTING && tc <= num_online_cpus()) {
+		schedule();
+		if (system_state == SYSTEM_RUNNING)
+			/* We may have been awoken by async_finish_boot() */
+			ret = 0;
+		else
+			/* We may have a job to handle */
+			ret = timeout;
+	} else {
+		ret = schedule_timeout(timeout);
+	}
+
+	atomic_dec(&nb_sleeping);
+
+	return ret;
+}
+
 static int async_thread(void *unused)
 {
 	DECLARE_WAITQUEUE(wq, current);
@@ -330,7 +378,7 @@ static int async_thread(void *unused)
 		if (!list_empty(&async_pending))
 			run_one_entry();
 		else
-			ret = schedule_timeout(HZ);
+			ret = async_thread_sleep(ret);
 
 		if (ret == 0) {
 			/*

