Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbXFUUnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbXFUUnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbXFUUm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:42:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41632 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbXFUUmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:42:55 -0400
Date: Thu, 21 Jun 2007 22:42:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: [patch] spinlock debug: make looping nicer
Message-ID: <20070621204234.GA1510@elte.hu>
References: <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org> <alpine.LFD.0.98.0706211230130.3593@woody.linux-foundation.org> <20070621200941.GB22303@elte.hu> <alpine.LFD.0.98.0706211311350.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706211311350.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Anybody who ever waits for a lock by busy-looping over it is BUGGY, 
> dammit!

btw., back then we also tried a spin_is_locked() based inner loop but it 
didnt help the ->tree_lock lockups either. In any case i very much agree 
that the 'nicer' looping should be added again - the patch below does 
that. (build and boot tested)

and the reason that this didnt help the ->tree_lock lockup is likely the 
same why wait_task_inactive() broke _independently_ of the 'niceness' of 
the spin-lock operation: there were too few instructions between 
releasing the lock and re-acquiring it again can cause permanent 
starvation of another CPU. No amount of logic on the spinning side can 
overcome this, if acquire/release critical sections are following each 
other too fast.

	Ingo

------------------------------>
Subject: [patch] spinlock debug: make looping nicer
From: Ingo Molnar <mingo@elte.hu>

make the spin-trylock loops nicer - and reactive the read and
write loops as well.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/spinlock_debug.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

Index: linux/lib/spinlock_debug.c
===================================================================
--- linux.orig/lib/spinlock_debug.c
+++ linux/lib/spinlock_debug.c
@@ -106,9 +106,14 @@ static void __spin_lock_debug(spinlock_t
 
 	for (;;) {
 		for (i = 0; i < loops; i++) {
+			/*
+			 * Ugly: we do the __delay() so that we know how
+			 * long to loop before printing a debug message:
+			 */
+			while (spin_is_locked(lock))
+				__delay(1);
 			if (__raw_spin_trylock(&lock->raw_lock))
 				return;
-			__delay(1);
 		}
 		/* lockup suspected: */
 		if (print_once) {
@@ -167,7 +172,6 @@ static void rwlock_bug(rwlock_t *lock, c
 
 #define RWLOCK_BUG_ON(cond, lock, msg) if (unlikely(cond)) rwlock_bug(lock, msg)
 
-#if 0		/* __write_lock_debug() can lock up - maybe this can too? */
 static void __read_lock_debug(rwlock_t *lock)
 {
 	u64 i;
@@ -176,9 +180,10 @@ static void __read_lock_debug(rwlock_t *
 
 	for (;;) {
 		for (i = 0; i < loops; i++) {
+			while (!read_can_lock(lock))
+				__delay(1);
 			if (__raw_read_trylock(&lock->raw_lock))
 				return;
-			__delay(1);
 		}
 		/* lockup suspected: */
 		if (print_once) {
@@ -191,12 +196,11 @@ static void __read_lock_debug(rwlock_t *
 		}
 	}
 }
-#endif
 
 void _raw_read_lock(rwlock_t *lock)
 {
 	RWLOCK_BUG_ON(lock->magic != RWLOCK_MAGIC, lock, "bad magic");
-	__raw_read_lock(&lock->raw_lock);
+	__read_lock_debug(lock);
 }
 
 int _raw_read_trylock(rwlock_t *lock)
@@ -242,7 +246,6 @@ static inline void debug_write_unlock(rw
 	lock->owner_cpu = -1;
 }
 
-#if 0		/* This can cause lockups */
 static void __write_lock_debug(rwlock_t *lock)
 {
 	u64 i;
@@ -251,9 +254,10 @@ static void __write_lock_debug(rwlock_t 
 
 	for (;;) {
 		for (i = 0; i < loops; i++) {
+			while (!write_can_lock(lock))
+				__delay(1);
 			if (__raw_write_trylock(&lock->raw_lock))
 				return;
-			__delay(1);
 		}
 		/* lockup suspected: */
 		if (print_once) {
@@ -266,12 +270,11 @@ static void __write_lock_debug(rwlock_t 
 		}
 	}
 }
-#endif
 
 void _raw_write_lock(rwlock_t *lock)
 {
 	debug_write_lock_before(lock);
-	__raw_write_lock(&lock->raw_lock);
+	__write_lock_debug(lock);
 	debug_write_lock_after(lock);
 }
 
