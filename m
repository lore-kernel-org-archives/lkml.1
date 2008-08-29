Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbYH2SGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbYH2SGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 14:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYH2SGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 14:06:13 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:37984
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751526AbYH2SGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 14:06:12 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RT PATCH v2] seqlock: serialize against writers
To: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com, andi@firstfloor.org, shemminger@vyatta.com
Date: Fri, 29 Aug 2008 14:03:51 -0400
Message-ID: <20080829180135.22450.54780.stgit@dev.haskins.net>
In-Reply-To: <20080829154237.1196.66825.stgit@dev.haskins.net>
References: <20080829154237.1196.66825.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*Patch submitted for inclusion in PREEMPT_RT 26-rt4.  Applies to 2.6.26.3-rt3*

Hi Ingo, Steven, Thomas,
  Please consider for -rt4.  This fixes a nasty deadlock on my systems under
  heavy load.

[
Changelog:
	v2: only touch seqlock_t because raw_seqlock_t doesn't require
	    serialization and userspace cannot modify data during a read

	v1: initial release
]

-Greg

----
seqlock: serialize against writers

Seqlocks have always advertised that readers do not "block", but this was
never really true.  Readers have always logically blocked at the head of
the critical section under contention with writers, regardless of whether
they were allowed to run code or not.

Recent changes in this space (88a411c07b6fedcfc97b8dc51ae18540bd2beda0)
have turned this into a more explicit blocking operation in mainline.
However, this change highlights a short-coming in -rt because the
normal seqlock_ts are preemptible.  This means that we can potentially
deadlock should a reader spin waiting for a write critical-section to end
while the writer is preempted.

This patch changes the internal implementation to use a rwlock and forces
the readers to serialize with the writers under contention.  This will
have the advantage that -rt seqlocks_t will sleep the reader if deadlock
were imminent, and it will pi-boost the writer to prevent inversion.

This fixes a deadlock discovered under testing where all high prioritiy
readers were hogging the cpus and preventing a writer from releasing the
lock.

Since seqlocks are designed to be used as rarely-write locks, this should
not affect the performance in the fast-path

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/seqlock.h |   51 +++++++++++++++++++++++------------------------
 1 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 345d726..605fcdb 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -3,9 +3,11 @@
 /*
  * Reader/writer consistent mechanism without starving writers. This type of
  * lock for data where the reader wants a consistent set of information
- * and is willing to retry if the information changes.  Readers never
- * block but they may have to retry if a writer is in
- * progress. Writers do not wait for readers. 
+ * and is willing to retry if the information changes. Readers block
+ * on write contention (and where applicable, pi-boost the writer).
+ * Readers without contention on entry acquire the critical section
+ * without any atomic operations, but they may have to retry if a writer
+ * enters before the critical section ends. Writers do not wait for readers.
  *
  * This is not as cache friendly as brlock. Also, this will not work
  * for data that contains pointers, because any writer could
@@ -24,6 +26,8 @@
  *
  * Based on x86_64 vsyscall gettimeofday 
  * by Keith Owens and Andrea Arcangeli
+ *
+ * Priority inheritance and live-lock avoidance by Gregory Haskins
  */
 
 #include <linux/spinlock.h>
@@ -31,7 +35,7 @@
 
 typedef struct {
 	unsigned sequence;
-	spinlock_t lock;
+	rwlock_t lock;
 } __seqlock_t;
 
 typedef struct {
@@ -57,7 +61,7 @@ typedef __raw_seqlock_t raw_seqlock_t;
 		{ 0, RAW_SPIN_LOCK_UNLOCKED(lockname) }
 
 #ifdef CONFIG_PREEMPT_RT
-# define __SEQLOCK_UNLOCKED(lockname) { 0, __SPIN_LOCK_UNLOCKED(lockname) }
+# define __SEQLOCK_UNLOCKED(lockname) { 0, __RW_LOCK_UNLOCKED(lockname) }
 #else
 # define __SEQLOCK_UNLOCKED(lockname) __RAW_SEQLOCK_UNLOCKED(lockname)
 #endif
@@ -69,7 +73,7 @@ typedef __raw_seqlock_t raw_seqlock_t;
 	do { *(x) = (raw_seqlock_t) __RAW_SEQLOCK_UNLOCKED(x); spin_lock_init(&(x)->lock); } while (0)
 
 #define seqlock_init(x) \
-		do { *(x) = (seqlock_t) __SEQLOCK_UNLOCKED(x); spin_lock_init(&(x)->lock); } while (0)
+		do { *(x) = (seqlock_t) __SEQLOCK_UNLOCKED(x); rwlock_init(&(x)->lock); } while (0)
 
 #define DEFINE_SEQLOCK(x) \
 		seqlock_t x = __SEQLOCK_UNLOCKED(x)
@@ -85,7 +89,7 @@ typedef __raw_seqlock_t raw_seqlock_t;
  */
 static inline void __write_seqlock(seqlock_t *sl)
 {
-	spin_lock(&sl->lock);
+	write_lock(&sl->lock);
 	++sl->sequence;
 	smp_wmb();
 }
@@ -103,14 +107,14 @@ static inline void __write_sequnlock(seqlock_t *sl)
 {
 	smp_wmb();
 	sl->sequence++;
-	spin_unlock(&sl->lock);
+	write_unlock(&sl->lock);
 }
 
 #define __write_sequnlock_irqrestore(sl, flags)	__write_sequnlock(sl)
 
 static inline int __write_tryseqlock(seqlock_t *sl)
 {
-	int ret = spin_trylock(&sl->lock);
+	int ret = write_trylock(&sl->lock);
 
 	if (ret) {
 		++sl->sequence;
@@ -120,18 +124,25 @@ static inline int __write_tryseqlock(seqlock_t *sl)
 }
 
 /* Start of read calculation -- fetch last complete writer token */
-static __always_inline unsigned __read_seqbegin(const seqlock_t *sl)
+static __always_inline unsigned __read_seqbegin(seqlock_t *sl)
 {
 	unsigned ret;
 
-repeat:
 	ret = sl->sequence;
 	smp_rmb();
 	if (unlikely(ret & 1)) {
-		cpu_relax();
-		goto repeat;
+		/*
+		 * Serialze with the writer which will ensure they are
+		 * pi-boosted if necessary and prevent us from starving
+		 * them.
+		 */
+		read_lock(&sl->lock);
+		ret = sl->sequence;
+		read_unlock(&sl->lock);
 	}
 
+	BUG_ON(ret & 1);
+
 	return ret;
 }
 
@@ -142,20 +153,8 @@ repeat:
  */
 static inline int __read_seqretry(seqlock_t *sl, unsigned iv)
 {
-	int ret;
-
 	smp_rmb();
-	ret = (sl->sequence != iv);
-	/*
-	 * If invalid then serialize with the writer, to make sure we
-	 * are not livelocking it:
-	 */
-	if (unlikely(ret)) {
-		unsigned long flags;
-		spin_lock_irqsave(&sl->lock, flags);
-		spin_unlock_irqrestore(&sl->lock, flags);
-	}
-	return ret;
+	return (sl->sequence != iv);
 }
 
 static __always_inline void __write_seqlock_raw(raw_seqlock_t *sl)

