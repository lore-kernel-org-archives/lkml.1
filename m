Return-Path: <linux-kernel-owner+w=401wt.eu-S1762670AbYD2NDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762670AbYD2NDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYD2NDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:03:09 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:41273 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbYD2NDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:03:07 -0400
Date: Tue, 29 Apr 2008 18:32:54 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: [PATCH 6/8] lockdep: annotate cpu_hotplug
Message-ID: <20080429130254.GG23562@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080429125659.GA23562@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429125659.GA23562@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: lockdep: annotate cpu_hotplug

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Annotate the cpu_hotplug lock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 include/linux/lockdep.h |   15 +++++++++++++++
 kernel/cpu.c            |   16 ++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 36e254f..424db2f 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -458,4 +458,19 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 # define rwsem_release(l, n, i)			do { } while (0)
 #endif
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# ifdef CONFIG_PROVE_LOCKING
+#  define cpu_hotplug_acquire(l, s, t, i)	lock_acquire(l, s, t, 0, 2, i)
+#  define cpu_hotplug_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 3, 2, i)
+# else
+#  define cpu_hotplug_acquire(l, s, t, i)	lock_acquire(l, s, t, 0, 1, i)
+#  define cpu_hotplug_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 3, 1, i)
+# endif
+# define cpu_hotplug_release(l, n, i)		lock_release(l, n, i)
+#else
+# define cpu_hotplug_acquire(l, s, t, i)	do { } while (0)
+# define cpu_hotplug_acquire_read(l, s, t, i)	do { } while (0)
+# define cpu_hotplug_release(l, n, i)		do { } while (0)
+#endif
+
 #endif /* __LINUX_LOCKDEP_H */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index e856c22..8f1718f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -35,12 +35,20 @@ static struct {
 	int refcount;
 	wait_queue_head_t reader_queue;
 	wait_queue_head_t writer_queue;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+#endif
 } cpu_hotplug;
 
 #define writer_exists() (cpu_hotplug.active_writer != NULL)
 
 void __init cpu_hotplug_init(void)
 {
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	static struct lock_class_key __key;
+
+	lockdep_init_map(&cpu_hotplug.dep_map, "cpu_hotplug", &__key, 0);
+#endif
 	cpu_hotplug.active_writer = NULL;
 	spin_lock_init(&cpu_hotplug.lock);
 	cpu_hotplug.refcount = 0;
@@ -54,6 +62,8 @@ void get_online_cpus(void)
 {
 	might_sleep();
 
+	cpu_hotplug_acquire_read(&cpu_hotplug.dep_map, 0, 0, _THIS_IP_);
+
 	spin_lock(&cpu_hotplug.lock);
 	if (cpu_hotplug.active_writer == current)
 		goto unlock;
@@ -80,6 +90,8 @@ EXPORT_SYMBOL_GPL(get_online_cpus);
 
 void put_online_cpus(void)
 {
+	cpu_hotplug_release(&cpu_hotplug.dep_map, 1, _THIS_IP_);
+
 	spin_lock(&cpu_hotplug.lock);
 	if (cpu_hotplug.active_writer == current)
 		goto unlock;
@@ -119,6 +131,8 @@ static void cpu_hotplug_begin(void)
 {
 	might_sleep();
 
+	cpu_hotplug_acquire(&cpu_hotplug.dep_map, 0, 0, _THIS_IP_);
+
 	spin_lock(&cpu_hotplug.lock);
 	if (cpu_hotplug.refcount || cpu_hotplug.active_writer) {
 		DEFINE_WAIT(wait);
@@ -140,6 +154,8 @@ static void cpu_hotplug_begin(void)
 
 static void cpu_hotplug_done(void)
 {
+	cpu_hotplug_release(&cpu_hotplug.dep_map, 1, _THIS_IP_);
+
 	spin_lock(&cpu_hotplug.lock);
 	cpu_hotplug.active_writer = NULL;
 	if (!list_empty(&cpu_hotplug.writer_queue.task_list))
-- 
Thanks and Regards
gautham
