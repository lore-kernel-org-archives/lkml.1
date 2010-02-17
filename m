Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab0BQSs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:48:29 -0500
Received: from www.tglx.de ([62.245.132.106]:42314 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab0BQSsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:48:19 -0500
Message-Id: <20100217184155.846155918@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 17 Feb 2010 18:47:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: [patch 3/5] seqlock: Create raw_seqlock
References: <20100217183740.486724334@linutronix.de>
Content-Disposition: inline; filename=seqlock-create-raw-seqlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

raw_seqlock_t will be used to annotate seqlocks (e.g. xtime_lock)
which can not be converted to sleeping locks in preempt-rt.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/seqlock.h |   81 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 79 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/include/linux/seqlock.h
===================================================================
--- linux-2.6-tip.orig/include/linux/seqlock.h
+++ linux-2.6-tip/include/linux/seqlock.h
@@ -31,9 +31,29 @@
 
 typedef struct {
 	unsigned sequence;
+	raw_spinlock_t lock;
+} raw_seqlock_t;
+
+typedef struct {
+	unsigned sequence;
 	spinlock_t lock;
 } seqlock_t;
 
+#define __RAW_SEQLOCK_UNLOCKED(lockname) \
+	{ 0, __RAW_SPIN_LOCK_UNLOCKED(lockname) }
+
+#define raw_seqlock_init(x)				\
+	do {						\
+		(x)->sequence = 0;			\
+		raw_spin_lock_init(&(x)->lock);		\
+	} while (0)
+
+#define DEFINE_RAW_SEQLOCK(x) \
+	raw_seqlock_t x = __RAW_SEQLOCK_UNLOCKED(x)
+
+#define __SEQLOCK_UNLOCKED(lockname) \
+	{ 0, __SPIN_LOCK_UNLOCKED(lockname) }
+
 /*
  * These macros triggered gcc-3.x compile-time problems.  We think these are
  * OK now.  Be cautious.
@@ -48,12 +68,19 @@ typedef struct {
 	} while (0)
 
 #define DEFINE_SEQLOCK(x) \
-		seqlock_t x = __SEQLOCK_UNLOCKED(x)
+	seqlock_t x = __SEQLOCK_UNLOCKED(x)
 
 /* Lock out other writers and update the count.
  * Acts like a normal spin_lock/unlock.
  * Don't need preempt_disable() because that is in the spin_lock already.
  */
+static inline void write_raw_seqlock(raw_seqlock_t *sl)
+{
+	raw_spin_lock(&sl->lock);
+	++sl->sequence;
+	smp_wmb();
+}
+
 static inline void write_seqlock(seqlock_t *sl)
 {
 	spin_lock(&sl->lock);
@@ -61,6 +88,13 @@ static inline void write_seqlock(seqlock
 	smp_wmb();
 }
 
+static inline void write_raw_sequnlock(raw_seqlock_t *sl)
+{
+	smp_wmb();
+	sl->sequence++;
+	raw_spin_unlock(&sl->lock);
+}
+
 static inline void write_sequnlock(seqlock_t *sl)
 {
 	smp_wmb();
@@ -80,6 +114,21 @@ static inline int write_tryseqlock(seqlo
 }
 
 /* Start of read calculation -- fetch last complete writer token */
+static __always_inline unsigned read_raw_seqbegin(const raw_seqlock_t *sl)
+{
+	unsigned ret;
+
+repeat:
+	ret = sl->sequence;
+	smp_rmb();
+	if (unlikely(ret & 1)) {
+		cpu_relax();
+		goto repeat;
+	}
+
+	return ret;
+}
+
 static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
 {
 	unsigned ret;
@@ -100,6 +149,14 @@ repeat:
  *
  * If sequence value changed then writer changed data while in section.
  */
+static __always_inline int
+read_raw_seqretry(const raw_seqlock_t *sl, unsigned start)
+{
+	smp_rmb();
+
+	return (sl->sequence != start);
+}
+
 static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
 {
 	smp_rmb();
@@ -167,12 +224,32 @@ static inline void write_seqcount_end(se
 /*
  * Possible sw/hw IRQ protected versions of the interfaces.
  */
+#define write_raw_seqlock_irqsave(lock, flags)				\
+	do { local_irq_save(flags); write_raw_seqlock(lock); } while (0)
+#define write_raw_seqlock_irq(lock)					\
+	do { local_irq_disable();   write_raw_seqlock(lock); } while (0)
+
+#define write_raw_sequnlock_irqrestore(lock, flags)			\
+	do { write_raw_sequnlock(lock); local_irq_restore(flags); } while(0)
+#define write_raw_sequnlock_irq(lock)					\
+	do { write_raw_sequnlock(lock); local_irq_enable(); } while(0)
+
+#define read_raw_seqbegin_irqsave(lock, flags)				\
+	({ local_irq_save(flags);   read_raw_seqbegin(lock); })
+
+#define read_raw_seqretry_irqrestore(lock, iv, flags)			\
+	({								\
+		int ret = read_raw_seqretry(lock, iv);			\
+		local_irq_restore(flags);				\
+		ret;							\
+	})
+
 #define write_seqlock_irqsave(lock, flags)				\
 	do { local_irq_save(flags); write_seqlock(lock); } while (0)
 #define write_seqlock_irq(lock)						\
 	do { local_irq_disable();   write_seqlock(lock); } while (0)
 #define write_seqlock_bh(lock)						\
-        do { local_bh_disable();    write_seqlock(lock); } while (0)
+	do { local_bh_disable();    write_seqlock(lock); } while (0)
 
 #define write_sequnlock_irqrestore(lock, flags)				\
 	do { write_sequnlock(lock); local_irq_restore(flags); } while(0)


