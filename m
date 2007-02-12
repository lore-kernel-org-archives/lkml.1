Return-Path: <linux-kernel-owner+w=401wt.eu-S932955AbXBLDns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955AbXBLDns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 22:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932956AbXBLDnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 22:43:47 -0500
Received: from ozlabs.org ([203.10.76.45]:50969 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932955AbXBLDnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 22:43:46 -0500
Subject: [PATCH 2/2] lguest preparation: expose futex infrastructure:
	get_futex_key, get_key_refs and drop_key_refs
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1171251698.10409.20.camel@localhost.localdomain>
References: <1171251120.10409.2.camel@localhost.localdomain>
	 <1171251185.10409.4.camel@localhost.localdomain>
	 <1171251258.10409.7.camel@localhost.localdomain>
	 <1171251335.10409.10.camel@localhost.localdomain>
	 <1171251406.10409.13.camel@localhost.localdomain>
	 <1171251471.10409.15.camel@localhost.localdomain>
	 <1171251578.10409.17.camel@localhost.localdomain>
	 <1171251698.10409.20.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 14:42:50 +1100
Message-Id: <1171251770.10409.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lguest uses the convenient futex infrastructure for inter-domain I/O,
so expose get_futex_key, get_key_refs (renamed get_futex_key_refs) and
drop_key_refs (renamed drop_futex_key_refs).  Also means we need to
expose the union that these use.

No code changes.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

===================================================================
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -100,6 +100,35 @@ extern int
 extern int
 handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi);
 
+/*
+ * Futexes are matched on equal values of this key.
+ * The key type depends on whether it's a shared or private mapping.
+ * Don't rearrange members without looking at hash_futex().
+ *
+ * offset is aligned to a multiple of sizeof(u32) (== 4) by definition.
+ * We set bit 0 to indicate if it's an inode-based key.
+ */
+union futex_key {
+	struct {
+		unsigned long pgoff;
+		struct inode *inode;
+		int offset;
+	} shared;
+	struct {
+		unsigned long address;
+		struct mm_struct *mm;
+		int offset;
+	} private;
+	struct {
+		unsigned long word;
+		void *ptr;
+		int offset;
+	} both;
+};
+int get_futex_key(u32 __user *uaddr, union futex_key *key);
+void get_futex_key_refs(union futex_key *key);
+void drop_futex_key_refs(union futex_key *key);
+
 #ifdef CONFIG_FUTEX
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);
===================================================================
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -48,37 +48,12 @@
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/signal.h>
+#include <linux/module.h>
 #include <asm/futex.h>
 
 #include "rtmutex_common.h"
 
 #define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
-
-/*
- * Futexes are matched on equal values of this key.
- * The key type depends on whether it's a shared or private mapping.
- * Don't rearrange members without looking at hash_futex().
- *
- * offset is aligned to a multiple of sizeof(u32) (== 4) by definition.
- * We set bit 0 to indicate if it's an inode-based key.
- */
-union futex_key {
-	struct {
-		unsigned long pgoff;
-		struct inode *inode;
-		int offset;
-	} shared;
-	struct {
-		unsigned long address;
-		struct mm_struct *mm;
-		int offset;
-	} private;
-	struct {
-		unsigned long word;
-		void *ptr;
-		int offset;
-	} both;
-};
 
 /*
  * Priority Inheritance state:
@@ -175,7 +150,7 @@ static inline int match_futex(union fute
  *
  * Should be called with &current->mm->mmap_sem but NOT any spinlocks.
  */
-static int get_futex_key(u32 __user *uaddr, union futex_key *key)
+int get_futex_key(u32 __user *uaddr, union futex_key *key)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
@@ -246,6 +221,7 @@ static int get_futex_key(u32 __user *uad
 	}
 	return err;
 }
+EXPORT_SYMBOL_GPL(get_futex_key);
 
 /*
  * Take a reference to the resource addressed by a key.
@@ -254,7 +230,7 @@ static int get_futex_key(u32 __user *uad
  * NOTE: mmap_sem MUST be held between get_futex_key() and calling this
  * function, if it is called at all.  mmap_sem keeps key->shared.inode valid.
  */
-static inline void get_key_refs(union futex_key *key)
+inline void get_futex_key_refs(union futex_key *key)
 {
 	if (key->both.ptr != 0) {
 		if (key->both.offset & 1)
@@ -263,12 +239,13 @@ static inline void get_key_refs(union fu
 			atomic_inc(&key->private.mm->mm_count);
 	}
 }
+EXPORT_SYMBOL_GPL(get_futex_key_refs);
 
 /*
  * Drop a reference to the resource addressed by a key.
  * The hash bucket spinlock must not be held.
  */
-static void drop_key_refs(union futex_key *key)
+void drop_futex_key_refs(union futex_key *key)
 {
 	if (key->both.ptr != 0) {
 		if (key->both.offset & 1)
@@ -277,6 +254,7 @@ static void drop_key_refs(union futex_ke
 			mmdrop(key->private.mm);
 	}
 }
+EXPORT_SYMBOL_GPL(drop_futex_key_refs);
 
 static inline int get_futex_value_locked(u32 *dest, u32 __user *from)
 {
@@ -871,7 +849,7 @@ static int futex_requeue(u32 __user *uad
 				this->lock_ptr = &hb2->lock;
 			}
 			this->key = key2;
-			get_key_refs(&key2);
+			get_futex_key_refs(&key2);
 			drop_count++;
 
 			if (ret - nr_wake >= nr_requeue)
@@ -884,9 +862,9 @@ out_unlock:
 	if (hb1 != hb2)
 		spin_unlock(&hb2->lock);
 
-	/* drop_key_refs() must be called outside the spinlocks. */
+	/* drop_futex_key_refs() must be called outside the spinlocks. */
 	while (--drop_count >= 0)
-		drop_key_refs(&key1);
+		drop_futex_key_refs(&key1);
 
 out:
 	up_read(&current->mm->mmap_sem);
@@ -904,7 +882,7 @@ queue_lock(struct futex_q *q, int fd, st
 
 	init_waitqueue_head(&q->waiters);
 
-	get_key_refs(&q->key);
+	get_futex_key_refs(&q->key);
 	hb = hash_futex(&q->key);
 	q->lock_ptr = &hb->lock;
 
@@ -923,7 +901,7 @@ queue_unlock(struct futex_q *q, struct f
 queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
 {
 	spin_unlock(&hb->lock);
-	drop_key_refs(&q->key);
+	drop_futex_key_refs(&q->key);
 }
 
 /*
@@ -978,7 +956,7 @@ static int unqueue_me(struct futex_q *q)
 		ret = 1;
 	}
 
-	drop_key_refs(&q->key);
+	drop_futex_key_refs(&q->key);
 	return ret;
 }
 
@@ -997,7 +975,7 @@ static void unqueue_me_pi(struct futex_q
 
 	spin_unlock(&hb->lock);
 
-	drop_key_refs(&q->key);
+	drop_futex_key_refs(&q->key);
 }
 
 static int futex_wait(u32 __user *uaddr, u32 val, unsigned long time)



