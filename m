Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbZGZI0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbZGZI0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZGZI0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:26:10 -0400
Received: from www.tglx.de ([62.245.132.106]:41584 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbZGZI0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:26:06 -0400
Message-Id: <20090726081558.233749061@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:20:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [Patch RFC 37/37] semaphore: Remove mutex emulation
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline; filename=semaphore-remove-mutex-emulation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Semaphores used as mutexes have been deprecated for years. Now that
all users are either converted to real semaphores or to mutexes remove
the cruft.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/semaphore.h |    6 ------
 scripts/checkpatch.pl     |    9 +++------
 2 files changed, 3 insertions(+), 12 deletions(-)

Index: linux-2.6-tip/include/linux/semaphore.h
===================================================================
--- linux-2.6-tip.orig/include/linux/semaphore.h
+++ linux-2.6-tip/include/linux/semaphore.h
@@ -29,9 +29,6 @@ struct semaphore {
 #define DEFINE_SEMAPHORE(name)	\
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
 
-#define DECLARE_MUTEX(name)	\
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
-
 static inline void sema_init(struct semaphore *sem, int val)
 {
 	static struct lock_class_key __key;
@@ -53,9 +50,6 @@ static inline void __deprecated semaphor
 	sema_init(sem, 0);
 }
 
-#define init_MUTEX(sem)		sema_init(sem, 1)
-#define init_MUTEX_LOCKED(sem)	sema_init(sem, 0)
-
 extern void down(struct semaphore *sem);
 extern int __must_check down_interruptible(struct semaphore *sem);
 extern int __must_check down_killable(struct semaphore *sem);
Index: linux-2.6-tip/scripts/checkpatch.pl
===================================================================
--- linux-2.6-tip.orig/scripts/checkpatch.pl
+++ linux-2.6-tip/scripts/checkpatch.pl
@@ -2512,14 +2512,11 @@ sub process {
 			WARN("__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
 		}
 
-# check for semaphores used as mutexes
-		if ($line =~ /^.\s*(DECLARE_MUTEX|init_MUTEX)\s*\(/) {
-			WARN("mutexes are preferred for single holder semaphores\n" . $herecurr);
-		}
-# check for semaphores used as mutexes
-		if ($line =~ /^.\s*init_MUTEX_LOCKED\s*\(/) {
+# check for semaphores initialized locked
+		if ($line =~ /^.\s*semaphore_init_locked\s*\(/) {
 			WARN("consider using a completion\n" . $herecurr);
 		}
+
 # recommend strict_strto* over simple_strto*
 		if ($line =~ /\bsimple_(strto.*?)\s*\(/) {
 			WARN("consider using strict_$1 in preference to simple_$1\n" . $herecurr);


