Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbYJXJqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbYJXJqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYJXJqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:46:46 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:54339 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYJXJqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:46:45 -0400
Subject: [PATCH 3/2] tasklet: implement lockdep deadlock detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1224790541.6002.53.camel@johannes.berg>
References: <1224790541.6002.53.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 22:37:14 +0200
Message-Id: <1224794234.6002.70.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tasklet code can deadlock when you try to disable a tasklet
under a lock that the tasklet requires. This patch implements
lockdep checking for this situation.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I don't have an actual instance of this in the kernel either, but my
test case triggers correctly.

This was easy, but I think it's probably unlikely that somebody will do
this mistake.

 include/linux/interrupt.h |   41 ++++++++++++++++++++++++++++++++++++-----
 kernel/softirq.c          |   10 +++++++---
 2 files changed, 43 insertions(+), 8 deletions(-)

--- wireless-testing.orig/include/linux/interrupt.h	2008-10-23 21:42:58.495547519 +0200
+++ wireless-testing/include/linux/interrupt.h	2008-10-23 22:09:18.911743812 +0200
@@ -299,13 +299,31 @@ struct tasklet_struct
 	atomic_t count;
 	void (*func)(unsigned long);
 	unsigned long data;
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map lock_map;
+#endif
 };
 
-#define DECLARE_TASKLET(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
+#ifdef CONFIG_LOCKDEP
+#define __TASKLET_LOCK_INIT(n, k) .lock_map = STATIC_LOCKDEP_MAP_INIT(n, k),
+#else
+#define __TASKLET_LOCK_INIT(n, k)
+#endif
 
+#define __DECLARE_TASKLET(name, _func, _data, c)\
+struct tasklet_struct name = {			\
+	.next = NULL,				\
+	.state = 0,				\
+	.count = ATOMIC_INIT(c),		\
+	.func = _func,				\
+	.data = _data,				\
+	__TASKLET_LOCK_INIT(#name, &name)	\
+}
+
+#define DECLARE_TASKLET(name, func, data)	\
+	__DECLARE_TASKLET(name, func, data, 0)
 #define DECLARE_TASKLET_DISABLED(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func, data }
+	__DECLARE_TASKLET(name, func, data, 1)
 
 
 enum
@@ -328,6 +346,8 @@ static inline void tasklet_unlock(struct
 
 static inline void tasklet_unlock_wait(struct tasklet_struct *t)
 {
+	lock_map_acquire_noirq(&t->lock_map);
+	lock_map_release(&t->lock_map);
 	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) { barrier(); }
 }
 #else
@@ -380,8 +400,19 @@ static inline void tasklet_hi_enable(str
 
 extern void tasklet_kill(struct tasklet_struct *t);
 extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
-extern void tasklet_init(struct tasklet_struct *t,
-			 void (*func)(unsigned long), unsigned long data);
+extern void tasklet_init_key(struct tasklet_struct *t,
+			     const char *name, struct lock_class_key *key,
+			     void (*func)(unsigned long), unsigned long data);
+
+#ifdef CONFIG_LOCKDEP
+#define tasklet_init(t, f, d)					\
+	do {							\
+		static struct lock_class_key __key;		\
+		tasklet_init_key((t), #t, &__key, (f), (d));	\
+	} while (0)
+#else
+#define tasklet_init(t, f, d) tasklet_init_key((t), NULL, NULL, (f), (d))
+#endif
 
 /*
  * Autoprobing for irqs:
--- wireless-testing.orig/kernel/softirq.c	2008-10-23 21:46:26.808921693 +0200
+++ wireless-testing/kernel/softirq.c	2008-10-23 22:01:34.382734952 +0200
@@ -383,7 +383,9 @@ static void tasklet_action(struct softir
 			if (!atomic_read(&t->count)) {
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
 					BUG();
+				lock_map_acquire_noirq(&t->lock_map);
 				t->func(t->data);
+				lock_map_release(&t->lock_map);
 				tasklet_unlock(t);
 				continue;
 			}
@@ -435,17 +437,19 @@ static void tasklet_hi_action(struct sof
 }
 
 
-void tasklet_init(struct tasklet_struct *t,
-		  void (*func)(unsigned long), unsigned long data)
+void tasklet_init_key(struct tasklet_struct *t,
+		      const char *name, struct lock_class_key *key,
+		      void (*func)(unsigned long), unsigned long data)
 {
 	t->next = NULL;
 	t->state = 0;
 	atomic_set(&t->count, 0);
 	t->func = func;
 	t->data = data;
+	lockdep_init_map(&t->lock_map, name, key, 0);
 }
 
-EXPORT_SYMBOL(tasklet_init);
+EXPORT_SYMBOL(tasklet_init_key);
 
 void tasklet_kill(struct tasklet_struct *t)
 {


