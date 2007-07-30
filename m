Return-Path: <linux-kernel-owner+w=401wt.eu-S966719AbXG3Ctv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966719AbXG3Ctv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 22:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966293AbXG3Crg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 22:47:36 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:41616 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936595AbXG3CrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 22:47:23 -0400
Message-Id: <20070730024721.274774887@mvista.com>
References: <20070730024534.369897977@mvista.com>
User-Agent: quilt/0.46-1
Date: Sun, 29 Jul 2007 19:45:43 -0700
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Content-Disposition: inline; filename=pickop-seqlocks.patch
Subject: [PATCH -rt 9/9] seqlocks: use PICK_FUNCTION
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the old PICK_OP style macros with PICK_FUNCTION. Although,
seqlocks has some alien code, which I also replaced as can be seen
from the line count below.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 include/linux/seqlock.h |  234 +++++++++++++++++++++++++++---------------------
 1 file changed, 134 insertions(+), 100 deletions(-)

Index: linux-2.6.22/include/linux/seqlock.h
===================================================================
--- linux-2.6.22.orig/include/linux/seqlock.h
+++ linux-2.6.22/include/linux/seqlock.h
@@ -90,6 +90,12 @@ static inline void __write_seqlock(seqlo
 	smp_wmb();
 }
 
+static __always_inline unsigned long __write_seqlock_irqsave(seqlock_t *sl)
+{
+	__write_seqlock(sl);
+	return 0;
+}
+
 static inline void __write_sequnlock(seqlock_t *sl)
 {
 	smp_wmb();
@@ -97,6 +103,8 @@ static inline void __write_sequnlock(seq
 	spin_unlock(&sl->lock);
 }
 
+#define __write_sequnlock_irqrestore(sl, flags)	__write_sequnlock(sl)
+
 static inline int __write_tryseqlock(seqlock_t *sl)
 {
 	int ret = spin_trylock(&sl->lock);
@@ -149,6 +157,28 @@ static __always_inline void __write_seql
 	smp_wmb();
 }
 
+static __always_inline unsigned long
+__write_seqlock_irqsave_raw(raw_seqlock_t *sl)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__write_seqlock_raw(sl);
+	return flags;
+}
+
+static __always_inline void __write_seqlock_irq_raw(raw_seqlock_t *sl)
+{
+	local_irq_disable();
+	__write_seqlock_raw(sl);
+}
+
+static __always_inline void __write_seqlock_bh_raw(raw_seqlock_t *sl)
+{
+	local_bh_disable();
+	__write_seqlock_raw(sl);
+}
+
 static __always_inline void __write_sequnlock_raw(raw_seqlock_t *sl)
 {
 	smp_wmb();
@@ -156,6 +186,27 @@ static __always_inline void __write_sequ
 	spin_unlock(&sl->lock);
 }
 
+static __always_inline void
+__write_sequnlock_irqrestore_raw(raw_seqlock_t *sl, unsigned long flags)
+{
+	__write_sequnlock_raw(sl);
+	local_irq_restore(flags);
+	preempt_check_resched();
+}
+
+static __always_inline void __write_sequnlock_irq_raw(raw_seqlock_t *sl)
+{
+	__write_sequnlock_raw(sl);
+	local_irq_enable();
+	preempt_check_resched();
+}
+
+static __always_inline void __write_sequnlock_bh_raw(raw_seqlock_t *sl)
+{
+	__write_sequnlock_raw(sl);
+	local_bh_enable();
+}
+
 static __always_inline int __write_tryseqlock_raw(raw_seqlock_t *sl)
 {
 	int ret = spin_trylock(&sl->lock);
@@ -182,60 +233,92 @@ static __always_inline int __read_seqret
 
 extern int __bad_seqlock_type(void);
 
-#define PICK_SEQOP(op, lock)					\
+/*
+ * PICK_SEQ_OP() is a small redirector to allow less typing of the lock
+ * types raw_seqlock_t, seqlock_t, at the front of the PICK_FUNCTION
+ * macro.
+ */
+#define PICK_SEQ_OP(...) PICK_FUNCTION(raw_seqlock_t, seqlock_t, ##__VA_ARGS__)
+#define PICK_SEQ_OP_RET(...) \
+	PICK_FUNCTION_RET(raw_seqlock_t, seqlock_t, ##__VA_ARGS__)
+
+#define write_seqlock(sl) PICK_SEQ_OP(__write_seqlock_raw, __write_seqlock, sl)
+
+#define write_sequnlock(sl)	\
+	PICK_SEQ_OP(__write_sequnlock_raw, __write_sequnlock, sl)
+
+#define write_tryseqlock(sl)	\
+	PICK_SEQ_OP_RET(__write_tryseqlock_raw, __write_tryseqlock, sl)
+
+#define read_seqbegin(sl) 	\
+	PICK_SEQ_OP_RET(__read_seqbegin_raw, __read_seqbegin, sl)
+
+#define read_seqretry(sl, iv)	\
+	PICK_SEQ_OP_RET(__read_seqretry_raw, __read_seqretry, sl, iv)
+
+#define write_seqlock_irqsave(lock, flags)			\
 do {								\
-	if (TYPE_EQUAL((lock), raw_seqlock_t))			\
-		op##_raw((raw_seqlock_t *)(lock));		\
-	else if (TYPE_EQUAL((lock), seqlock_t))			\
-		op((seqlock_t *)(lock));			\
-	else __bad_seqlock_type();				\
+	flags = PICK_SEQ_OP_RET(__write_seqlock_irqsave_raw,	\
+		__write_seqlock_irqsave, lock);			\
 } while (0)
 
-#define PICK_SEQOP_RET(op, lock)				\
-({								\
-	unsigned long __ret;					\
-								\
-	if (TYPE_EQUAL((lock), raw_seqlock_t))			\
-		__ret = op##_raw((raw_seqlock_t *)(lock));	\
-	else if (TYPE_EQUAL((lock), seqlock_t))			\
-		__ret = op((seqlock_t *)(lock));		\
-	else __ret = __bad_seqlock_type();			\
-								\
-	__ret;							\
-})
-
-#define PICK_SEQOP_CONST_RET(op, lock)				\
-({								\
-	unsigned long __ret;					\
-								\
-	if (TYPE_EQUAL((lock), raw_seqlock_t))			\
-		__ret = op##_raw((const raw_seqlock_t *)(lock));\
-	else if (TYPE_EQUAL((lock), seqlock_t))			\
-		__ret = op((seqlock_t *)(lock));		\
-	else __ret = __bad_seqlock_type();			\
-								\
-	__ret;							\
-})
-
-#define PICK_SEQOP2_CONST_RET(op, lock, arg)				\
- ({									\
-	unsigned long __ret;						\
-									\
-	if (TYPE_EQUAL((lock), raw_seqlock_t))				\
-		__ret = op##_raw((const raw_seqlock_t *)(lock), (arg));	\
-	else if (TYPE_EQUAL((lock), seqlock_t))				\
-		__ret = op((seqlock_t *)(lock), (arg));			\
-	else __ret = __bad_seqlock_type();				\
-									\
-	__ret;								\
-})
-
-
-#define write_seqlock(sl)	PICK_SEQOP(__write_seqlock, sl)
-#define write_sequnlock(sl)	PICK_SEQOP(__write_sequnlock, sl)
-#define write_tryseqlock(sl)	PICK_SEQOP_RET(__write_tryseqlock, sl)
-#define read_seqbegin(sl)	PICK_SEQOP_CONST_RET(__read_seqbegin, sl)
-#define read_seqretry(sl, iv)	PICK_SEQOP2_CONST_RET(__read_seqretry, sl, iv)
+#define write_seqlock_irq(lock)	\
+	PICK_SEQ_OP(__write_seqlock_irq_raw, __write_seqlock, lock)
+
+#define write_seqlock_bh(lock)	\
+	PICK_SEQ_OP(__write_seqlock_bh_raw, __write_seqlock, lock)
+
+#define write_sequnlock_irqrestore(lock, flags)		\
+	PICK_SEQ_OP(__write_sequnlock_irqrestore_raw,	\
+		__write_sequnlock_irqrestore, lock, flags)
+
+#define write_sequnlock_bh(lock)	\
+	PICK_SEQ_OP(__write_sequnlock_bh_raw, __write_sequnlock, lock)
+
+#define write_sequnlock_irq(lock)	\
+	PICK_SEQ_OP(__write_sequnlock_irq_raw, __write_sequnlock, lock)
+
+static __always_inline
+unsigned long __read_seqbegin_irqsave_raw(raw_seqlock_t *sl)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__read_seqbegin_raw(sl);
+	return flags;
+}
+
+static __always_inline unsigned long __read_seqbegin_irqsave(seqlock_t *sl)
+{
+	__read_seqbegin(sl);
+	return 0;
+}
+
+#define read_seqbegin_irqsave(lock, flags)			\
+do {								\
+	flags = PICK_SEQ_OP_RET(__read_seqbegin_irqsave_raw,	\
+		__read_seqbegin_irqsave, lock);			\
+} while (0)
+
+static __always_inline int
+__read_seqretry_irqrestore(seqlock_t *sl, unsigned iv, unsigned long flags)
+{
+	return __read_seqretry(sl, iv);
+}
+
+static __always_inline int
+__read_seqretry_irqrestore_raw(raw_seqlock_t *sl, unsigned iv,
+			       unsigned long flags)
+{
+	int ret = read_seqretry(sl, iv);
+	local_irq_restore(flags);
+	preempt_check_resched();
+	return ret;
+}
+
+#define read_seqretry_irqrestore(lock, iv, flags)			\
+	PICK_SEQ_OP_RET(__read_seqretry_irqrestore_raw, 		\
+		__read_seqretry_irqrestore, lock, iv, flags)
 
 /*
  * Version using sequence counter only.
@@ -286,53 +369,4 @@ static inline void write_seqcount_end(se
 	smp_wmb();
 	s->sequence++;
 }
-
-#define PICK_IRQOP(op, lock)					\
-do {								\
-	if (TYPE_EQUAL((lock), raw_seqlock_t))			\
-		op();						\
-	else if (TYPE_EQUAL((lock), seqlock_t))			\
-		{ /* nothing */ }				\
-	else __bad_seqlock_type();				\
-} while (0)
-
-#define PICK_IRQOP2(op, arg, lock)				\
-do {								\
-	if (TYPE_EQUAL((lock), raw_seqlock_t))			\
-		op(arg);					\
-	else if (TYPE_EQUAL(lock, seqlock_t))			\
-		{ /* nothing */ }				\
-	else __bad_seqlock_type();				\
-} while (0)
-
-
-
-/*
- * Possible sw/hw IRQ protected versions of the interfaces.
- */
-#define write_seqlock_irqsave(lock, flags)				\
-	do { PICK_IRQOP2(local_irq_save, flags, lock); write_seqlock(lock); } while (0)
-#define write_seqlock_irq(lock)						\
-	do { PICK_IRQOP(local_irq_disable, lock); write_seqlock(lock); } while (0)
-#define write_seqlock_bh(lock)						\
-        do { PICK_IRQOP(local_bh_disable, lock); write_seqlock(lock); } while (0)
-
-#define write_sequnlock_irqrestore(lock, flags)				\
-	do { write_sequnlock(lock); PICK_IRQOP2(local_irq_restore, flags, lock); preempt_check_resched(); } while(0)
-#define write_sequnlock_irq(lock)					\
-	do { write_sequnlock(lock); PICK_IRQOP(local_irq_enable, lock); preempt_check_resched(); } while(0)
-#define write_sequnlock_bh(lock)					\
-	do { write_sequnlock(lock); PICK_IRQOP(local_bh_enable, lock); } while(0)
-
-#define read_seqbegin_irqsave(lock, flags)				\
-	({ PICK_IRQOP2(local_irq_save, flags, lock); read_seqbegin(lock); })
-
-#define read_seqretry_irqrestore(lock, iv, flags)			\
-	({								\
-		int ret = read_seqretry(lock, iv);			\
-		PICK_IRQOP2(local_irq_restore, flags, lock);		\
-		preempt_check_resched(); 				\
-		ret;							\
-	})
-
 #endif /* __LINUX_SEQLOCK_H */

-- 
