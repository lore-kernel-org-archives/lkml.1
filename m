Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbYAJTHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbYAJTHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYAJTHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:07:10 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54804 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbYAJTHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:07:06 -0500
Subject: [RFC][PATCH 3/4] change mnt_writers[] spinlock to mutex
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, serue@us.ibm.com,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 10 Jan 2008 11:07:01 -0800
References: <20080110190657.92A8B61F@kernel>
In-Reply-To: <20080110190657.92A8B61F@kernel>
Message-Id: <20080110190701.FF57BF50@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---

 linux-2.6.git-dave/fs/namespace.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN fs/namespace.c~change-spinlock-to-mutex fs/namespace.c
--- linux-2.6.git/fs/namespace.c~change-spinlock-to-mutex	2008-01-10 10:45:47.000000000 -0800
+++ linux-2.6.git-dave/fs/namespace.c	2008-01-10 10:46:01.000000000 -0800
@@ -118,7 +118,7 @@ struct mnt_writer {
 	 * If holding multiple instances of this lock, they
 	 * must be ordered by cpu number.
 	 */
-	spinlock_t lock;
+	struct mutex lock;
 	struct lock_class_key lock_class; /* compiles out with !lockdep */
 	unsigned long count;
 	struct vfsmount *mnt;
@@ -130,7 +130,7 @@ static int __init init_mnt_writers(void)
 	int cpu;
 	for_each_possible_cpu(cpu) {
 		struct mnt_writer *writer = &per_cpu(mnt_writers, cpu);
-		spin_lock_init(&writer->lock);
+		mutex_init(&writer->lock);
 		lockdep_set_class(&writer->lock, &writer->lock_class);
 		writer->count = 0;
 	}
@@ -145,7 +145,7 @@ static void mnt_unlock_cpus(void)
 
 	for_each_possible_cpu(cpu) {
 		cpu_writer = &per_cpu(mnt_writers, cpu);
-		spin_unlock(&cpu_writer->lock);
+		mutex_unlock(&cpu_writer->lock);
 	}
 }
 
@@ -191,8 +191,8 @@ int mnt_want_write(struct vfsmount *mnt)
 	int ret = 0;
 	struct mnt_writer *cpu_writer;
 
-	cpu_writer = &get_cpu_var(mnt_writers);
-	spin_lock(&cpu_writer->lock);
+	cpu_writer = &__get_cpu_var(mnt_writers);
+	mutex_lock(&cpu_writer->lock);
 	if (__mnt_is_readonly(mnt)) {
 		ret = -EROFS;
 		goto out;
@@ -200,8 +200,7 @@ int mnt_want_write(struct vfsmount *mnt)
 	use_cpu_writer_for_mount(cpu_writer, mnt);
 	cpu_writer->count++;
 out:
-	spin_unlock(&cpu_writer->lock);
-	put_cpu_var(mnt_writers);
+	mutex_unlock(&cpu_writer->lock);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mnt_want_write);
@@ -213,7 +212,7 @@ static void lock_and_coalesce_cpu_mnt_wr
 
 	for_each_possible_cpu(cpu) {
 		cpu_writer = &per_cpu(mnt_writers, cpu);
-		spin_lock(&cpu_writer->lock);
+		mutex_lock(&cpu_writer->lock);
 		__clear_mnt_count(cpu_writer);
 		cpu_writer->mnt = NULL;
 	}
@@ -269,7 +268,7 @@ void mnt_drop_write(struct vfsmount *mnt
 
 retry:
 	cpu_writer = &__get_cpu_var(mnt_writers);
-	spin_lock(&cpu_writer->lock);
+	mutex_lock(&cpu_writer->lock);
 
 	use_cpu_writer_for_mount(cpu_writer, mnt);
 	if (cpu_writer->count > 0) {
@@ -286,14 +285,14 @@ retry:
 		 */
 		if (atomic_read(&mnt->__mnt_writers) <
 		    MNT_WRITER_UNDERFLOW_LIMIT) {
-			spin_unlock(&cpu_writer->lock);
+			mutex_unlock(&cpu_writer->lock);
 			goto retry;
 		}
 		atomic_dec(&mnt->__mnt_writers);
 		must_check_underflow = 1;
 	}
 
-	spin_unlock(&cpu_writer->lock);
+	mutex_unlock(&cpu_writer->lock);
 	/*
 	 * Logically, we could call this each time,
 	 * but the __mnt_writers cacheline tends to
_
