Return-Path: <linux-kernel-owner+w=401wt.eu-S1750878AbXCOTQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878AbXCOTQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932848AbXCOTQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:16:31 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:42519 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbXCOTQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:16:21 -0400
From: Eric Dumazet <dada1@cosmosbay.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/3] FUTEX : introduce private hashtables
Date: Thu, 15 Mar 2007 20:16:25 +0100
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
References: <20060808070708.GA3931@localhost.localdomain> <200608090826.28249.dada1@cosmosbay.com> <200608090843.52893.dada1@cosmosbay.com>
In-Reply-To: <200608090843.52893.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JuZ+FJFI+qZHeXB"
Message-Id: <200703152016.25703.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_JuZ+FJFI+qZHeXB
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[PATCH 2/3] FUTEX : introduce private hashtables

This patch introduces a separate hashtable per process to store _PRIVATE 
futexes.
This hashtable is dynamically allocated on the first _PRIVATE futex syscall.
If memory cannot be allocated, the process will use the global hashtable.

Using a separate hashtable has the advantage of lowering the contention on the 
global hashtable. NUMA should benefits of this separation because the 
allocation should respect the mm policy of the process.

Code is using kmalloc()/vmalloc() depending on the size of spinlocks. For 
normal setup, size of the private hashtable should be 768 bytes on 32bit 
arches, 1536 bytes on 64bit arches.

Private hashtable is freed() when process exits.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 include/linux/futex.h |    4 +
 include/linux/sched.h |    7 ++
 kernel/fork.c         |    1 
 kernel/futex.c        |  112 ++++++++++++++++++++++++++++++++++++++--
 4 files changed, 120 insertions(+), 4 deletions(-)

--Boundary-00=_JuZ+FJFI+qZHeXB
Content-Type: text/plain;
  charset="utf-8";
  name="futex_p2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="futex_p2.patch"

--- linux-2.6.21-rc3/kernel/futex.c	2007-03-15 18:30:15.000000000 +0100
+++ linux-2.6.21-rc3-ed/kernel/futex.c	2007-03-15 18:54:47.000000000 +0100
@@ -51,11 +51,11 @@
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/signal.h>
+#include <linux/vmalloc.h>
 #include <asm/futex.h>
 
 #include "rtmutex_common.h"
 
-#define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
 
 /*
  * Futexes are matched on equal values of this key.
@@ -147,11 +147,96 @@ struct futex_hash_bucket {
        struct list_head       chain;
 };
 
-static struct futex_hash_bucket futex_queues[1<<FUTEX_HASHBITS];
+
+#if CONFIG_BASE_SMALL
+# define FUTEX_HASH_SLOTS	16
+# define FUTEX_NOPRIVHASH	/* no private hashtable, only one global */
+#else
+# define FUTEX_HASH_SLOTS	256
+# define FUTEX_PRIVHASH_SLOTS	64
+#endif
+
+#define FUTEX_PRIVHASH_SIZE \
+	(FUTEX_PRIVHASH_SLOTS * sizeof(struct futex_hash_bucket))
+/*
+ * futex_queues[] : global hash table
+ *
+ * PTHREAD_PROCESS_SHARED futexes are hashed into this table
+ *
+ * PTHREAD_PROCESS_PRIVATE futexes may be hashed into this table too if the 
+ * owner process failed to allocate its private hashtable (or CONFIG_BASE_SMALL)
+ *
+ */
+static struct futex_hash_bucket futex_queues[FUTEX_HASH_SLOTS];
 
 /* Futex-fs vfsmount entry: */
 static struct vfsmount *futex_mnt;
 
+
+/*
+ * private futexes are hashed into a process private table.
+ * As this table is dynamically allocated, it might be in fact
+ * the global table in case of memory stress.
+ * A pointer to this table is kept in mm_struct.
+ */
+#ifndef FUTEX_NOPRIVHASH
+static void mm_priv_queues_alloc(struct mm_struct *mm)
+{
+	unsigned int ui;
+	struct futex_hash_bucket *queues;
+
+	/*
+	 * FUTEX_PRIVHASH_SIZE is a constant, compiler should choose
+	 * either vmalloc()/kmalloc()  :)
+	 */
+	if (FUTEX_PRIVHASH_SIZE > PAGE_SIZE)
+		queues = vmalloc(FUTEX_PRIVHASH_SIZE);
+	else
+		queues = kmalloc(FUTEX_PRIVHASH_SIZE, GFP_KERNEL);
+
+	if (queues) {
+		for (ui = 0; ui < FUTEX_PRIVHASH_SLOTS; ui++) {
+			spin_lock_init(&queues[ui].lock);
+			INIT_LIST_HEAD(&queues[ui].chain);
+		}
+		spin_lock(&mm->page_table_lock);
+		/*
+		 * check if another thread installed a table before me
+		 */
+		if (mm->mm_priv_futex_queues) {
+			if (FUTEX_PRIVHASH_SIZE > PAGE_SIZE)
+				vfree(queues);
+			else
+				kfree(queues);
+		}
+		else
+			mm->mm_priv_futex_queues = queues;
+	}
+	else {
+		spin_lock(&mm->page_table_lock);
+		if (!mm->mm_priv_futex_queues)
+			mm->mm_priv_futex_queues = futex_queues;
+	}
+	spin_unlock(&mm->page_table_lock);
+}
+#endif
+
+/*
+ * Called from __mmdrop()/mm_free_futex() to eventually free private futexes
+ * hash table attached to mm
+ */
+void __mm_free_futex(struct mm_struct *mm)
+{
+#ifndef FUTEX_NOPRIVHASH
+	if (mm->mm_priv_futex_queues != futex_queues) {
+		if (FUTEX_PRIVHASH_SIZE > PAGE_SIZE)
+			vfree(mm->mm_priv_futex_queues);
+		else
+			kfree(mm->mm_priv_futex_queues);
+	}
+#endif
+}
+
 /*
  * We hash on the keys returned from get_futex_key (see below).
  */
@@ -159,8 +244,27 @@ static struct futex_hash_bucket *hash_fu
 {
 	u32 hash = jhash2((u32*)&key->both.word,
 			  (sizeof(key->both.word)+sizeof(key->both.ptr))/4,
-			  key->both.offset);
-	return &futex_queues[hash & ((1 << FUTEX_HASHBITS)-1)];
+			  key->both.offset) % FUTEX_HASH_SLOTS;
+
+#ifdef FUTEX_NOPRIVHASH
+	return &futex_queues[hash];
+#else
+	struct mm_struct *mm;
+	/*
+	 * PROCESS_SHARED futexes are hashed into futex_queues[]
+	 */
+	if (key->both.offset & (OFF_INODE|OFF_MMSHARED))
+		return &futex_queues[hash];
+
+	if (FUTEX_PRIVHASH_SLOTS < FUTEX_HASH_SLOTS)
+		hash %= FUTEX_PRIVHASH_SLOTS;
+
+	mm = current->mm;
+	if (unlikely(!mm->mm_priv_futex_queues))
+		mm_priv_queues_alloc(mm);
+
+	return &mm->mm_priv_futex_queues[hash];
+#endif
 }
 
 /*
--- linux-2.6.21-rc3/include/linux/futex.h	2007-03-15 18:08:37.000000000 +0100
+++ linux-2.6.21-rc3-ed/include/linux/futex.h	2007-03-15 18:31:40.000000000 +0100
@@ -115,6 +115,7 @@ handle_futex_death(u32 __user *uaddr, st
 #ifdef CONFIG_FUTEX
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);
+extern void __mm_free_futex(struct mm_struct *mm);
 #else
 static inline void exit_robust_list(struct task_struct *curr)
 {
@@ -122,6 +123,9 @@ static inline void exit_robust_list(stru
 static inline void exit_pi_state_list(struct task_struct *curr)
 {
 }
+static inline void __mm_free_futex(struct mm_struct *mm)
+{
+}
 #endif
 #endif /* __KERNEL__ */
 
--- linux-2.6.21-rc3/include/linux/sched.h	2007-03-15 18:32:08.000000000 +0100
+++ linux-2.6.21-rc3-ed/include/linux/sched.h	2007-03-15 18:31:40.000000000 +0100
@@ -373,6 +373,8 @@ struct mm_struct {
 	/* aio bits */
 	rwlock_t		ioctx_list_lock;
 	struct kioctx		*ioctx_list;
+	/* private futexes */
+	struct futex_hash_bucket *mm_priv_futex_queues;
 };
 
 struct sighand_struct {
@@ -1374,6 +1376,11 @@ static inline int sas_ss_flags(unsigned 
  * Routines for handling mm_structs
  */
 extern struct mm_struct * mm_alloc(void);
+static inline void mm_free_futex(struct mm_struct * mm)
+{
+	if (mm->mm_priv_futex_queues)
+		__mm_free_futex(mm);
+}
 
 /* mmdrop drops the mm and the page tables */
 extern void FASTCALL(__mmdrop(struct mm_struct *));
--- linux-2.6.21-rc3/kernel/fork.c	2007-03-15 18:32:08.000000000 +0100
+++ linux-2.6.21-rc3-ed/kernel/fork.c	2007-03-15 18:31:40.000000000 +0100
@@ -374,6 +374,7 @@ void fastcall __mmdrop(struct mm_struct 
 	BUG_ON(mm == &init_mm);
 	mm_free_pgd(mm);
 	destroy_context(mm);
+	mm_free_futex(mm);
 	free_mm(mm);
 }
 

--Boundary-00=_JuZ+FJFI+qZHeXB--
