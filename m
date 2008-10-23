Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbYJXJpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbYJXJpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbYJXJp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:45:29 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:54267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYJXJp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:45:28 -0400
Subject: [PATCH 1/2] lockdep: implement full check without irq checking
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1224790541.6002.53.camel@johannes.berg>
References: <1224790541.6002.53.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 21:44:32 +0200
Message-Id: <1224791072.6002.63.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a new check type "3" which means "full validation
but without irq tracing" in order to allow some certain fake locks that
are only added for deadlock detection to not cause inconsistent state
warnings which would be inappropriate for them.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/lockdep.h |    4 ++++
 kernel/lockdep.c        |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/linux/lockdep.h	2008-10-23 21:06:25.837224864 +0200
+++ wireless-testing/include/linux/lockdep.h	2008-10-23 21:32:09.889809433 +0200
@@ -301,6 +301,7 @@ extern void lockdep_init_map(struct lock
  *   0: disabled
  *   1: simple checks (freeing, held-at-exit-time, etc.)
  *   2: full validation
+ *   3: full validation without irq tracing
  */
 extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			 int trylock, int read, int check,
@@ -471,12 +472,15 @@ static inline void print_irqtrace_events
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
 #  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_)
+#  define lock_map_acquire_noirq(l)	lock_acquire(l, 0, 0, 0, 3, NULL, _THIS_IP_)
 # else
 #  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
+#  define lock_map_acquire_noirq(l)	lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
 # endif
 # define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
 #else
 # define lock_map_acquire(l)			do { } while (0)
+# define lock_map_acquire_noirq(l)		do { } while (0)
 # define lock_map_release(l)			do { } while (0)
 #endif
 
--- wireless-testing.orig/kernel/lockdep.c	2008-10-23 21:06:25.881976762 +0200
+++ wireless-testing/kernel/lockdep.c	2008-10-23 21:13:43.460100511 +0200
@@ -1695,7 +1695,7 @@ static int validate_chain(struct task_st
 	 * (If lookup_chain_cache() returns with 1 it acquires
 	 * graph_lock for us)
 	 */
-	if (!hlock->trylock && (hlock->check == 2) &&
+	if (!hlock->trylock && (hlock->check >= 2) &&
 	    lookup_chain_cache(curr, hlock, chain_key)) {
 		/*
 		 * Check whether last held lock:


