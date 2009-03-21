Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZCUEq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZCUEq5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 00:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbZCUEqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 00:46:46 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:54813 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZCUEqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 00:46:45 -0400
Date: Fri, 20 Mar 2009 21:46:37 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, shai@scalex86.org
Subject: [rfc] [patch 1/2 ] Process private hash tables for private futexes
Message-ID: <20090321044637.GA7278@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to have a process private hash table for 'PRIVATE' futexes.

On large core count systems running multiple threaded processes causes
false sharing on the global futex hash table.  The global futex hash
table is an array of struct futex_hash_bucket which is defined as:

struct futex_hash_bucket {
        spinlock_t lock;
        struct plist_head chain;
};

static struct futex_hash_bucket futex_queues[1<<FUTEX_HASHBITS];

Needless to say this will cause multiple spinlocks to reside on the
same cacheline which is very bad when multiple un-related process
hash onto adjacent hash buckets.  The probability of unrelated futexes
ending on adjacent hash buckets increase with the number of cores in the
system (more cores available translates to more processes/more threads
being run on a system).  The effects of false sharing are tangible on
machines with more than 32 cores.  We have noticed this with  workload
of a certain multiple threaded FEA (Finite Element Analysis) solvers.
We reported this problem couple of years ago which eventually resulted in
a new api for private futexes to avoid mmap_sem.  The false sharing on
the global futex hash was put off pending glibc changes to accomodate
the futex private apis.  Now that the glibc changes are in, and
multicore is more prevalent, maybe it is time to fix this problem.

The root cause of the problem is a global futex hash table even for process
private futexes.  Process private futexes can be hashed on process private
hash tables, avoiding the global hash and a longer hash table walk when
there are a lot more futexes in the workload.  However, this results in an
addition of one extra pointer to the mm_struct.  Hence, this implementation
of a process private hash table is based off a config option, which can be
turned off for smaller core count systems.  Furthermore, a subsequent patch
will introduce a sysctl to dynamically turn on private futex hash tables.

We found this patch to improve the runtime of a certain FEA solver by about
15% on a 32 core vSMP system.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Shai Fultheim <shai@scalex86.org>

Index: linux-2.6.28.6/include/linux/mm_types.h
===================================================================
--- linux-2.6.28.6.orig/include/linux/mm_types.h	2009-03-11 16:52:06.000000000 -0800
+++ linux-2.6.28.6/include/linux/mm_types.h	2009-03-11 16:52:23.000000000 -0800
@@ -256,6 +256,10 @@ struct mm_struct {
 #ifdef CONFIG_MMU_NOTIFIER
 	struct mmu_notifier_mm *mmu_notifier_mm;
 #endif
+#ifdef CONFIG_PROCESS_PRIVATE_FUTEX
+	/* Process private futex hash table */
+	struct futex_hash_bucket *htb;
+#endif
 };
 
 #endif /* _LINUX_MM_TYPES_H */
Index: linux-2.6.28.6/init/Kconfig
===================================================================
--- linux-2.6.28.6.orig/init/Kconfig	2009-03-11 16:52:06.000000000 -0800
+++ linux-2.6.28.6/init/Kconfig	2009-03-18 17:06:23.000000000 -0800
@@ -672,6 +672,14 @@ config FUTEX
 	  support for "fast userspace mutexes".  The resulting kernel may not
 	  run glibc-based applications correctly.
 
+config PROCESS_PRIVATE_FUTEX
+	bool "Process private futexes" if FUTEX
+	default n
+	help
+	  This option enables ability to have per-process hashtables for private
+	  futexes.  This makes sense on large core-count systems (more than
+	  32 cores)
+
 config ANON_INODES
 	bool
 
Index: linux-2.6.28.6/kernel/fork.c
===================================================================
--- linux-2.6.28.6.orig/kernel/fork.c	2009-02-17 09:29:27.000000000 -0800
+++ linux-2.6.28.6/kernel/fork.c	2009-03-12 17:12:40.000000000 -0800
@@ -424,6 +424,7 @@ static struct mm_struct * mm_init(struct
 		return mm;
 	}
 
+	free_futex_htb(mm);
 	free_mm(mm);
 	return NULL;
 }
Index: linux-2.6.28.6/kernel/futex.c
===================================================================
--- linux-2.6.28.6.orig/kernel/futex.c	2009-03-11 16:52:13.000000000 -0800
+++ linux-2.6.28.6/kernel/futex.c	2009-03-18 17:36:04.000000000 -0800
@@ -140,15 +140,84 @@ static inline void futex_unlock_mm(struc
 		up_read(fshared);
 }
 
+#ifdef CONFIG_PROCESS_PRIVATE_FUTEX
+static void free_htb(struct futex_hash_bucket *htb)
+{
+	if (htb != futex_queues)
+		kfree(htb);
+}
+
+void free_futex_htb(struct mm_struct *mm)
+{
+	free_htb(mm->htb);
+}
+
+static void alloc_htb(struct mm_struct *mm)
+{
+	struct futex_hash_bucket *htb;
+	int i;
+	/*
+	 * Allocate and install a private hash table of the
+	 * same size as the global hash table.  We fall
+	 * back onto the global hash on allocation failure
+	 */
+	htb = kmalloc(sizeof(futex_queues), GFP_KERNEL);
+	if (!htb)
+		htb = futex_queues;
+	else {
+		 for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
+			plist_head_init(&htb[i].chain, &htb[i].lock);
+			spin_lock_init(&htb[i].lock);
+		}
+	}
+	/* Install the hash table */
+	spin_lock(&mm->page_table_lock);
+	if (mm->htb) {
+		/* Another thread installed the hash table */
+		spin_unlock(&mm->page_table_lock);
+		free_htb(htb);
+	} else {
+		mm->htb = htb;
+		spin_unlock(&mm->page_table_lock);
+	}
+
+}
+
+static struct futex_hash_bucket *get_futex_hashtable(union futex_key *key)
+{
+	struct mm_struct *mm;
+	if (key->both.offset & FUT_OFF_INODE)
+		/* Shared inode based mapping uses global hash */
+		return futex_queues;
+	/*
+	 * Private futexes -- This covers both FUTEX_PRIVATE_FLAG
+	 * and 'mm' only private futexes
+	 */
+
+	mm = current->mm;
+	if (unlikely(!mm->htb))
+		alloc_htb(mm);
+	return mm->htb;
+}
+#else
+static inline
+struct futex_hash_bucket *get_futex_hashtable(union futex_key *key)
+{
+	return futex_queues;
+}
+#endif
 /*
  * We hash on the keys returned from get_futex_key (see below).
  */
 static struct futex_hash_bucket *hash_futex(union futex_key *key)
 {
-	u32 hash = jhash2((u32*)&key->both.word,
+	struct futex_hash_bucket *htb;
+	u32 hash;
+	htb = get_futex_hashtable(key);
+	hash = jhash2((u32 *)&key->both.word,
 			  (sizeof(key->both.word)+sizeof(key->both.ptr))/4,
 			  key->both.offset);
-	return &futex_queues[hash & ((1 << FUTEX_HASHBITS)-1)];
+	return &htb[hash & ((1 << FUTEX_HASHBITS)-1)];
 }
 
 /*
Index: linux-2.6.28.6/include/linux/futex.h
===================================================================
--- linux-2.6.28.6.orig/include/linux/futex.h	2009-02-17 09:29:27.000000000 -0800
+++ linux-2.6.28.6/include/linux/futex.h	2009-03-18 16:59:27.000000000 -0800
@@ -176,6 +176,15 @@ static inline void exit_pi_state_list(st
 {
 }
 #endif
+
+#ifdef CONFIG_PROCESS_PRIVATE_FUTEX
+extern void free_futex_htb(struct mm_struct *mm);
+#else
+static inline void free_futex_htb(struct mm_struct *mm)
+{
+	return;
+}
+#endif
 #endif /* __KERNEL__ */
 
 #define FUTEX_OP_SET		0	/* *(int *)UADDR2 = OPARG; */
