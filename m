Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187Ab0AKV1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab0AKV1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684Ab0AKV1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:13 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:60356 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab0AKV1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=krbQUmq9bYzGyyn6alh+Jy7N51wtWvLvBa7rKGO/uU4AvpIEdoKhEYg6srDCCgYLlR
         NVO4Bi8B4j87y4iVKUG250nVFPmtPRm5pbREpspKd0eEFcgvgRDR1LLqTgO1OjDvf5T7
         pAgx/jitvPdXjoAHTwcFxY5tfCnAj1P1DZyIg=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 02/26] seqlock: Create raw_seqlock
Date: Mon, 11 Jan 2010 22:26:32 +0100
Message-Id: <1263245216-14754-3-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-2-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

raw_seqlock_t will be used to annotate seqlocks which can not be
converted to sleeping locks in preempt-rt

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

The original patch 09e46c7a86b2e81f97bd93f588b62c2d36cff58e used atomic_locks
I converted this patch to raw_locks.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 include/linux/seqlock.h |   86 ++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 82 insertions(+), 4 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 632205c..6f2685c 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -31,6 +31,11 @@
 
 typedef struct {
 	unsigned sequence;
+	raw_spinlock_t lock;
+} raw_seqlock_t;
+
+typedef struct {
+	unsigned sequence;
 	spinlock_t lock;
 } seqlock_t;
 
@@ -38,11 +43,23 @@ typedef struct {
  * These macros triggered gcc-3.x compile-time problems.  We think these are
  * OK now.  Be cautious.
  */
+#define __RAW_SEQLOCK_UNLOCKED(lockname) \
+	{ 0, __RAW_SPIN_LOCK_UNLOCKED(lockname) }
+
+#define seqlock_raw_init(x)				\
+	do {						\
+		(x)->sequence = 0;			\
+		raw_spin_lock_init(&(x)->lock);	\
+	} while (0)
+
+#define DEFINE_RAW_SEQLOCK(x) \
+	raw_seqlock_t x = __RAW_SEQLOCK_UNLOCKED(x)
+
 #define __SEQLOCK_UNLOCKED(lockname) \
-		 { 0, __SPIN_LOCK_UNLOCKED(lockname) }
+	{ 0, __SPIN_LOCK_UNLOCKED(lockname) }
 
 #define SEQLOCK_UNLOCKED \
-		 __SEQLOCK_UNLOCKED(old_style_seqlock_init)
+	__SEQLOCK_UNLOCKED(old_style_seqlock_init)
 
 #define seqlock_init(x)					\
 	do {						\
@@ -51,12 +68,19 @@ typedef struct {
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
@@ -64,6 +88,13 @@ static inline void write_seqlock(seqlock_t *sl)
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
@@ -83,6 +114,21 @@ static inline int write_tryseqlock(seqlock_t *sl)
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
@@ -103,6 +149,14 @@ repeat:
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
@@ -170,12 +224,36 @@ static inline void write_seqcount_end(seqcount_t *s)
 /*
  * Possible sw/hw IRQ protected versions of the interfaces.
  */
+#define write_raw_seqlock_irqsave(lock, flags)			\
+	do { local_irq_save(flags); write_raw_seqlock(lock); } while (0)
+#define write_raw_seqlock_irq(lock)					\
+	do { local_irq_disable();   write_raw_seqlock(lock); } while (0)
+#define write_raw_seqlock_bh(lock)					\
+	do { local_bh_disable();    write_raw_seqlock(lock); } while (0)
+
+#define write_raw_sequnlock_irqrestore(lock, flags)			\
+	do { write_raw_sequnlock(lock); local_irq_restore(flags); } while(0)
+#define write_raw_sequnlock_irq(lock)				\
+	do { write_raw_sequnlock(lock); local_irq_enable(); } while(0)
+#define write_raw_sequnlock_bh(lock)					\
+	do { write_raw_sequnlock(lock); local_bh_enable(); } while(0)
+
+#define read_raw_seqbegin_irqsave(lock, flags)			\
+	({ local_irq_save(flags);   read_raw_seqbegin(lock); })
+
+#define read_raw_seqretry_irqrestore(lock, iv, flags)		\
+	({								\
+		int ret = read_raw_seqretry(lock, iv);		\
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
-- 
1.6.5.2

