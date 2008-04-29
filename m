Return-Path: <linux-kernel-owner+w=401wt.eu-S1762158AbYD2TAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762158AbYD2TAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757577AbYD2S7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:59:53 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:32999 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbYD2S7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:59:49 -0400
Subject: [RFC][PATCH 1/5] r/o bind mounts: change spinlock to mutex
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       trond.myklebust@fys.uio.no, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2008 11:59:44 -0700
References: <20080429185943.3BA6A050@kernel>
In-Reply-To: <20080429185943.3BA6A050@kernel>
Message-Id: <20080429185944.15C04C04@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In order to lock out new writers during remount operations,
we need to hold the cpu_writer->lock's.  But, remounts can
sleep, so we can not use spinlocks.  Make them mutexes.

We do the fiddling in mnt_drop_write() because we used to
rely on the spin_lock() disabling preemption.  Since the
mutex does not do that, we have to use another method
to avoid underflow.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/namespace.c |   52 +++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff -puN fs/namespace.c~make-cpu_writer-lock-a-mutex fs/namespace.c
--- linux-2.6.git/fs/namespace.c~make-cpu_writer-lock-a-mutex	2008-04-29 11:56:39.000000000 -0700
+++ linux-2.6.git-dave/fs/namespace.c	2008-04-29 11:56:39.000000000 -0700
@@ -173,7 +173,7 @@ struct mnt_writer {
 	 * If holding multiple instances of this lock, they
 	 * must be ordered by cpu number.
 	 */
-	spinlock_t lock;
+	struct mutex lock;
 	struct lock_class_key lock_class; /* compiles out with !lockdep */
 	unsigned long count;
 	struct vfsmount *mnt;
@@ -185,7 +185,7 @@ static int __init init_mnt_writers(void)
 	int cpu;
 	for_each_possible_cpu(cpu) {
 		struct mnt_writer *writer = &per_cpu(mnt_writers, cpu);
-		spin_lock_init(&writer->lock);
+		mutex_init(&writer->lock);
 		lockdep_set_class(&writer->lock, &writer->lock_class);
 		writer->count = 0;
 	}
@@ -200,7 +200,7 @@ static void unlock_mnt_writers(void)
 
 	for_each_possible_cpu(cpu) {
 		cpu_writer = &per_cpu(mnt_writers, cpu);
-		spin_unlock(&cpu_writer->lock);
+		mutex_unlock(&cpu_writer->lock);
 	}
 }
 
@@ -252,8 +252,8 @@ int mnt_want_write(struct vfsmount *mnt)
 	int ret = 0;
 	struct mnt_writer *cpu_writer;
 
-	cpu_writer = &get_cpu_var(mnt_writers);
-	spin_lock(&cpu_writer->lock);
+	cpu_writer = &__get_cpu_var(mnt_writers);
+	mutex_lock(&cpu_writer->lock);
 	if (__mnt_is_readonly(mnt)) {
 		ret = -EROFS;
 		goto out;
@@ -261,8 +261,7 @@ int mnt_want_write(struct vfsmount *mnt)
 	use_cpu_writer_for_mount(cpu_writer, mnt);
 	cpu_writer->count++;
 out:
-	spin_unlock(&cpu_writer->lock);
-	put_cpu_var(mnt_writers);
+	mutex_unlock(&cpu_writer->lock);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mnt_want_write);
@@ -274,7 +273,7 @@ static void lock_mnt_writers(void)
 
 	for_each_possible_cpu(cpu) {
 		cpu_writer = &per_cpu(mnt_writers, cpu);
-		spin_lock(&cpu_writer->lock);
+		mutex_lock(&cpu_writer->lock);
 		__clear_mnt_count(cpu_writer);
 		cpu_writer->mnt = NULL;
 	}
@@ -333,18 +332,34 @@ void mnt_drop_write(struct vfsmount *mnt
 	int must_check_underflow = 0;
 	struct mnt_writer *cpu_writer;
 
-	cpu_writer = &get_cpu_var(mnt_writers);
-	spin_lock(&cpu_writer->lock);
+retry:
+	cpu_writer = &__get_cpu_var(mnt_writers);
+	mutex_lock(&cpu_writer->lock);
 
 	use_cpu_writer_for_mount(cpu_writer, mnt);
 	if (cpu_writer->count > 0) {
 		cpu_writer->count--;
 	} else {
-		must_check_underflow = 1;
+		/*
+		 * Without this check, it is theoretically
+		 * possible for large number of processes
+		 * to atomic_dec(__mnt_writers) and cause
+		 * it to underflow.  Because we are under
+		 * the mutex (and there are NR_CPUS
+		 * mutexes), this limits the number of
+		 * concurrent decrements and underflow
+		 * level to NR_CPUS.
+		 */
+		if (atomic_read(&mnt->__mnt_writers) <
+			MNT_WRITER_UNDERFLOW_LIMIT) {
+			mutex_unlock(&cpu_writer->lock);
+			goto retry;
+		}
 		atomic_dec(&mnt->__mnt_writers);
+		must_check_underflow = 1;
 	}
 
-	spin_unlock(&cpu_writer->lock);
+	mutex_unlock(&cpu_writer->lock);
 	/*
 	 * Logically, we could call this each time,
 	 * but the __mnt_writers cacheline tends to
@@ -352,15 +367,6 @@ void mnt_drop_write(struct vfsmount *mnt
 	 */
 	if (must_check_underflow)
 		handle_write_count_underflow(mnt);
-	/*
-	 * This could be done right after the spinlock
-	 * is taken because the spinlock keeps us on
-	 * the cpu, and disables preemption.  However,
-	 * putting it here bounds the amount that
-	 * __mnt_writers can underflow.  Without it,
-	 * we could theoretically wrap __mnt_writers.
-	 */
-	put_cpu_var(mnt_writers);
 }
 EXPORT_SYMBOL_GPL(mnt_drop_write);
 
@@ -615,7 +621,7 @@ static inline void __mntput(struct vfsmo
 		struct mnt_writer *cpu_writer = &per_cpu(mnt_writers, cpu);
 		if (cpu_writer->mnt != mnt)
 			continue;
-		spin_lock(&cpu_writer->lock);
+		mutex_lock(&cpu_writer->lock);
 		atomic_add(cpu_writer->count, &mnt->__mnt_writers);
 		cpu_writer->count = 0;
 		/*
@@ -624,7 +630,7 @@ static inline void __mntput(struct vfsmo
 		 * it to be valid.
 		 */
 		cpu_writer->mnt = NULL;
-		spin_unlock(&cpu_writer->lock);
+		mutex_unlock(&cpu_writer->lock);
 	}
 	/*
 	 * This probably indicates that somebody messed
_
