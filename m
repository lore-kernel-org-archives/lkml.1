Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbYLDIAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbYLDIAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYLDIAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:00:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:33132 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYLDIAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:00:22 -0500
Subject: Re: Lockdep warning for iprune_mutex at shrink_icache_memory
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Dan =?ISO-8859-1?Q?No=E9?= <dpn@isomerica.net>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1227773115.4454.1208.camel@twins>
References: <20081125064357.5a4f1420@tuna> <20081126072625.GH6291@disturbed>
	 <1227711779.4454.184.camel@twins>  <20081126213454.GI6291@disturbed>
	 <1227773115.4454.1208.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Dec 2008 09:00:17 +0100
Message-Id: <1228377618.19569.949.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 09:05 +0100, Peter Zijlstra wrote:
> On Thu, 2008-11-27 at 08:34 +1100, Dave Chinner wrote:
> > Is changing the lock class dynamically possible/allowed?
> 
> Currently, no, but I'll see what I can do, it requires a bit of trickery
> to make that happen..
> 
> I'll let you know when I've sorted that out.

Ok, that wasn't hard at all..

Dave, Christoph, can you have a play with this and post this patch along
with a potential user - I think it best if we don't merge this without
at least one user in tree :-)

---
Subject: lockdep: change a held lock's class
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Dec 04 08:34:56 CET 2008

Impact: introduce new lockdep API

Allow to change a held lock's class. Basically the same as the existing
code to change a subclass therefore reuse all that.

The XFS code will be able to use this to annotate their inode locking.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/lockdep.h |   12 ++++++++++--
 kernel/lockdep.c        |   24 +++++++++---------------
 2 files changed, 19 insertions(+), 17 deletions(-)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -314,8 +314,15 @@ extern void lock_acquire(struct lockdep_
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
 
-extern void lock_set_subclass(struct lockdep_map *lock, unsigned int subclass,
-			      unsigned long ip);
+extern void lock_set_class(struct lockdep_map *lock, const char *name,
+			   struct lock_class_key *key, unsigned int subclass,
+			   unsigned long ip);
+
+static inline void lock_set_subclass(struct lockdep_map *lock,
+		unsigned int subclass, unsigned long ip)
+{
+	lock_set_class(lock, lock->name, lock->key, subclass, ip);
+}
 
 # define INIT_LOCKDEP				.lockdep_recursion = 0,
 
@@ -333,6 +340,7 @@ static inline void lockdep_on(void)
 
 # define lock_acquire(l, s, t, r, c, n, i)	do { } while (0)
 # define lock_release(l, n, i)			do { } while (0)
+# define lock_set_class(l, n, k, s, i)		do { } while (0)
 # define lock_set_subclass(l, s, i)		do { } while (0)
 # define lockdep_init()				do { } while (0)
 # define lockdep_info()				do { } while (0)
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -292,14 +292,12 @@ void lockdep_off(void)
 {
 	current->lockdep_recursion++;
 }
-
 EXPORT_SYMBOL(lockdep_off);
 
 void lockdep_on(void)
 {
 	current->lockdep_recursion--;
 }
-
 EXPORT_SYMBOL(lockdep_on);
 
 /*
@@ -2514,7 +2512,6 @@ void lockdep_init_map(struct lockdep_map
 	if (subclass)
 		register_lock_class(lock, subclass, 1);
 }
-
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
 /*
@@ -2695,8 +2692,9 @@ static int check_unlock(struct task_stru
 }
 
 static int
-__lock_set_subclass(struct lockdep_map *lock,
-		    unsigned int subclass, unsigned long ip)
+__lock_set_class(struct lockdep_map *lock, const char *name,
+		 struct lock_class_key *key, unsigned int subclass,
+		 unsigned long ip)
 {
 	struct task_struct *curr = current;
 	struct held_lock *hlock, *prev_hlock;
@@ -2723,6 +2721,7 @@ __lock_set_subclass(struct lockdep_map *
 	return print_unlock_inbalance_bug(curr, lock, ip);
 
 found_it:
+	lockdep_init_map(lock, name, key, 0);
 	class = register_lock_class(lock, subclass, 0);
 	hlock->class_idx = class - lock_classes + 1;
 
@@ -2907,9 +2906,9 @@ static void check_flags(unsigned long fl
 #endif
 }
 
-void
-lock_set_subclass(struct lockdep_map *lock,
-		  unsigned int subclass, unsigned long ip)
+void lock_set_class(struct lockdep_map *lock, const char *name,
+		    struct lock_class_key *key, unsigned int subclass,
+		    unsigned long ip)
 {
 	unsigned long flags;
 
@@ -2919,13 +2918,12 @@ lock_set_subclass(struct lockdep_map *lo
 	raw_local_irq_save(flags);
 	current->lockdep_recursion = 1;
 	check_flags(flags);
-	if (__lock_set_subclass(lock, subclass, ip))
+	if (__lock_set_class(lock, name, key, subclass, ip))
 		check_chain_key(current);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
-
-EXPORT_SYMBOL_GPL(lock_set_subclass);
+EXPORT_SYMBOL_GPL(lock_set_class);
 
 /*
  * We are not always called with irqs disabled - do that here,
@@ -2949,7 +2947,6 @@ void lock_acquire(struct lockdep_map *lo
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
-
 EXPORT_SYMBOL_GPL(lock_acquire);
 
 void lock_release(struct lockdep_map *lock, int nested,
@@ -2967,7 +2964,6 @@ void lock_release(struct lockdep_map *lo
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
-
 EXPORT_SYMBOL_GPL(lock_release);
 
 #ifdef CONFIG_LOCK_STAT
@@ -3452,7 +3448,6 @@ retry:
 	if (unlock)
 		read_unlock(&tasklist_lock);
 }
-
 EXPORT_SYMBOL_GPL(debug_show_all_locks);
 
 /*
@@ -3473,7 +3468,6 @@ void debug_show_held_locks(struct task_s
 {
 		__debug_show_held_locks(task);
 }
-
 EXPORT_SYMBOL_GPL(debug_show_held_locks);
 
 void lockdep_sys_exit(void)

