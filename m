Return-Path: <linux-kernel-owner+w=401wt.eu-S1761268AbXEUVSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268AbXEUVSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 17:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbXEUVSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 17:18:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132AbXEUVSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 17:18:38 -0400
Date: Mon, 21 May 2007 16:58:45 -0400 (EDT)
From: Jason Baron <jbaron@redhat.com>
X-X-Sender: jbaron@dhcp83-20.boston.redhat.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Bill Huey <billh@gnuppy.monkey.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] lockdep: lock contention tracking
In-Reply-To: <1179657026.5915.10.camel@lappy>
Message-ID: <Pine.LNX.4.64.0705211655010.23384@dhcp83-20.boston.redhat.com>
References: <1179657026.5915.10.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 20 May 2007, Peter Zijlstra wrote:

> 
> Add lock contention tracking to lockdep
> 

looks really nice to me.

To me, in addition to the number of times the lock is contended we also 
need the total number of times the lock was acquired, to make the 
statistics significant. I've included one such patch below, which also 
introduces a 'event', thiking of things like lock timings that were 
mentioned, but this is not necessary.

thanks,

-Jason


Signed-off-by: Jason Baron <jbaron@redhat.com>

--- linux-2.6.22-rc2-lockdep/include/linux/lockdep.h.bak	2007-05-21 15:55:30.000000000 -0400
+++ linux-2.6.22-rc2-lockdep/include/linux/lockdep.h	2007-05-21 16:30:13.000000000 -0400
@@ -36,6 +36,17 @@
 };
 
 /*
+ * lock contention types
+ */
+
+enum lock_contention_event
+{
+	LOCK_CONTENTION_WRITE = 0,
+	LOCK_CONTENTION_READ,
+	LOCK_CONTENTION_TOTAL
+};
+
+/*
  * Usage-state bitmasks:
  */
 #define LOCKF_USED			(1 << LOCK_USED)
@@ -121,6 +132,7 @@
 	const char			*name;
 	int				name_version;
 
+	atomic_t			total;
 	atomic_t			read_contentions;
 	atomic_t			write_contentions;
 	struct lockdep_contention_point	contention_point[4];
@@ -253,7 +265,7 @@
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
 
-extern void lock_contended(struct lockdep_map *lock, int read,
+extern void lock_contended(struct lockdep_map *lock, enum lock_contention_event,
 			   unsigned long ip);
 
 # define INIT_LOCKDEP				.lockdep_recursion = 0,
--- linux-2.6.22-rc2-lockdep/kernel/lockdep_proc.c.bak	2007-05-21 16:10:12.000000000 -0400
+++ linux-2.6.22-rc2-lockdep/kernel/lockdep_proc.c	2007-05-21 16:11:38.000000000 -0400
@@ -348,16 +348,17 @@
 	struct lock_class *class;
 
 	list_for_each_entry(class, &all_lock_classes, lock_entry) {
-		int r, w;
+		int r, w, t;
 
 		r = atomic_read(&class->read_contentions);
 		w = atomic_read(&class->write_contentions);
+		t = atomic_read(&class->total);
 
 		if (r || w) {
 			int i;
 			char sym[KSYM_SYMBOL_LEN];
 
-			seq_printf(m, "%s: %d %d", class->name, w, r);
+			seq_printf(m, "%s: %d %d %d", class->name, w, r, t);
 			for (i = 0; i < ARRAY_SIZE(class->contention_point);
 					i++) {
 				struct lockdep_contention_point *cp =
--- linux-2.6.22-rc2-lockdep/kernel/lockdep.c.bak	2007-05-21 16:02:05.000000000 -0400
+++ linux-2.6.22-rc2-lockdep/kernel/lockdep.c	2007-05-21 16:29:35.000000000 -0400
@@ -2429,7 +2429,7 @@
 }
 
 static void
-__lock_contended(struct lockdep_map *lock, int read, unsigned long ip)
+__lock_contended(struct lockdep_map *lock, enum lock_contention_event event, unsigned long ip)
 {
 	struct task_struct *curr = current;
 	struct held_lock *hlock, *prev_hlock;
@@ -2463,10 +2463,17 @@
 	return;
 
 found_it:
-	if (read)
+	switch (event) {
+	case LOCK_CONTENTION_READ:
 		atomic_inc(&class->read_contentions);
-	else
+		break;
+	case LOCK_CONTENTION_WRITE:
 		atomic_inc(&class->write_contentions);
+		break;
+	case LOCK_CONTENTION_TOTAL:
+		atomic_inc(&class->total);
+		return;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(class->contention_point); i++) {
 		if (class->contention_point[i].ip == 0) {
@@ -2530,6 +2537,7 @@
 	current->lockdep_recursion = 1;
 	__lock_acquire(lock, subclass, trylock, read, check,
 		       irqs_disabled_flags(flags), ip);
+	__lock_contended(lock, LOCK_CONTENTION_TOTAL, 0);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
@@ -2553,7 +2561,7 @@
 
 EXPORT_SYMBOL_GPL(lock_release);
 
-void lock_contended(struct lockdep_map *lock, int read, unsigned long ip)
+void lock_contended(struct lockdep_map *lock, enum lock_contention_event event, unsigned long ip)
 {
 	unsigned long flags;
 
@@ -2563,7 +2571,7 @@
 	raw_local_irq_save(flags);
 	check_flags(flags);
 	current->lockdep_recursion = 1;
-	__lock_contended(lock, read, ip);
+	__lock_contended(lock, event, ip);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }


