Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbYLKWmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbYLKWmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759077AbYLKWlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:41:00 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:54052 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbYLKWk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:40:57 -0500
Message-ID: <494196DD.5070600@cosmosbay.com>
Date: Thu, 11 Dec 2008 23:40:29 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       "kernel-testers@vger.kernel.org >> Kernel Testers List" 
	<kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v3 6/7] fs: struct file move from call_rcu() to SLAB_DESTROY_BY_RCU
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net> <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com> <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com> <20081121153453.GA23713@elte.hu> <492DDB6A.8090806@cosmosbay.com> <493100B0.6090104@cosmosbay.com>
In-Reply-To: <493100B0.6090104@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 11 Dec 2008 23:40:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux-foundation.org>

[PATCH] fs: struct file move from call_rcu() to SLAB_DESTROY_BY_RCU

Currently we schedule RCU frees for each file we free separately. That has
several drawbacks against the earlier file handling (in 2.6.5 f.e.), which
did not require RCU callbacks:

1. Excessive number of RCU callbacks can be generated causing long RCU
  queues that in turn cause long latencies. We hit SLUB page allocation
  more often than necessary.

2. The cache hot object is not preserved between free and realloc. A close
  followed by another open is very fast with the RCUless approach because
  the last freed object is returned by the slab allocator that is
  still cache hot. RCU free means that the object is not immediately
  available again. The new object is cache cold and therefore open/close
  performance tests show a significant degradation with the RCU
  implementation.

One solution to this problem is to move the RCU freeing into the Slab
allocator by specifying SLAB_DESTROY_BY_RCU as an option at slab creation
time. The slab allocator will do RCU frees only when it is necessary
to dispose of slabs of objects (rare). So with that approach we can cut
out the RCU overhead significantly.

However, the slab allocator may return the object for another use even
before the RCU period has expired under SLAB_DESTROY_BY_RCU. This means
there is the (unlikely) possibility that the object is going to be
switched under us in sections protected by rcu_read_lock() and
rcu_read_unlock(). So we need to verify that we have acquired the correct
object after establishing a stable object reference (incrementing the
refcounter does that).


Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/filesystems/files.txt |   21 ++++++++++++++--
 fs/file_table.c                     |   33 ++++++++++++++++++--------
 include/linux/fs.h                  |    5 ---
 3 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/Documentation/filesystems/files.txt b/Documentation/filesystems/files.txt
index ac2facc..6916baa 100644
--- a/Documentation/filesystems/files.txt
+++ b/Documentation/filesystems/files.txt
@@ -78,13 +78,28 @@ the fdtable structure -
    that look-up may race with the last put() operation on the
    file structure. This is avoided using atomic_long_inc_not_zero()
    on ->f_count :
+   As file structures are allocated with SLAB_DESTROY_BY_RCU,
+   they can also be freed before a RCU grace period, and reused,
+   but still as a struct file.
+   It is necessary to check again after getting
+   a stable reference (ie after atomic_long_inc_not_zero()),
+   that fcheck_files(files, fd) points to the same file.
 
 	rcu_read_lock();
 	file = fcheck_files(files, fd);
 	if (file) {
-		if (atomic_long_inc_not_zero(&file->f_count))
+		if (atomic_long_inc_not_zero(&file->f_count)) {
 			*fput_needed = 1;
-		else
+			/*
+			 * Now we have a stable reference to an object.
+			 * Check if other threads freed file and reallocated it.
+			 */
+			if (file != fcheck_files(files, fd)) {
+				*fput_needed = 0;
+				put_filp(file);
+				file = NULL;
+			}
+		} else
 		/* Didn't get the reference, someone's freed */
 			file = NULL;
 	}
@@ -95,6 +110,8 @@ the fdtable structure -
    atomic_long_inc_not_zero() detects if refcounts is already zero or
    goes to zero during increment. If it does, we fail
    fget()/fget_light().
+   The second call to fcheck_files(files, fd) checks that this filp
+   was not freed, then reused by an other thread.
 
 6. Since both fdtable and file structures can be looked up
    lock-free, they must be installed using rcu_assign_pointer()
diff --git a/fs/file_table.c b/fs/file_table.c
index a46e880..3e9259d 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -37,17 +37,11 @@ static struct kmem_cache *filp_cachep __read_mostly;
 
 static struct percpu_counter nr_files __cacheline_aligned_in_smp;
 
-static inline void file_free_rcu(struct rcu_head *head)
-{
-	struct file *f =  container_of(head, struct file, f_u.fu_rcuhead);
-	kmem_cache_free(filp_cachep, f);
-}
-
 static inline void file_free(struct file *f)
 {
 	percpu_counter_dec(&nr_files);
 	file_check_state(f);
-	call_rcu(&f->f_u.fu_rcuhead, file_free_rcu);
+	kmem_cache_free(filp_cachep, f);
 }
 
 /*
@@ -306,6 +300,14 @@ struct file *fget(unsigned int fd)
 			rcu_read_unlock();
 			return NULL;
 		}
+		/*
+		 * Now we have a stable reference to an object.
+		 * Check if other threads freed file and re-allocated it.
+		 */
+		if (unlikely(file != fcheck_files(files, fd))) {
+			put_filp(file);
+			file = NULL;
+		}
 	}
 	rcu_read_unlock();
 
@@ -333,9 +335,19 @@ struct file *fget_light(unsigned int fd, int *fput_needed)
 		rcu_read_lock();
 		file = fcheck_files(files, fd);
 		if (file) {
-			if (atomic_long_inc_not_zero(&file->f_count))
+			if (atomic_long_inc_not_zero(&file->f_count)) {
 				*fput_needed = 1;
-			else
+				/*
+				 * Now we have a stable reference to an object.
+				 * Check if other threads freed this file and
+				 * re-allocated it.
+				 */
+				if (unlikely(file != fcheck_files(files, fd))) {
+					*fput_needed = 0;
+					put_filp(file);
+					file = NULL;
+				}
+			} else
 				/* Didn't get the reference, someone's freed */
 				file = NULL;
 		}
@@ -402,7 +414,8 @@ void __init files_init(unsigned long mempages)
 	int n; 
 
 	filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
-			SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN | SLAB_DESTROY_BY_RCU | SLAB_PANIC,
+			NULL);
 
 	/*
 	 * One file with associated inode and dcache is very roughly 1K. 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a702d81..a1f56d4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -811,13 +811,8 @@ static inline int ra_has_index(struct file_ra_state *ra, pgoff_t index)
 #define FILE_MNT_WRITE_RELEASED	2
 
 struct file {
-	/*
-	 * fu_list becomes invalid after file_free is called and queued via
-	 * fu_rcuhead for RCU freeing
-	 */
 	union {
 		struct list_head	fu_list;
-		struct rcu_head 	fu_rcuhead;
 	} f_u;
 	struct path		f_path;
 #define f_dentry	f_path.dentry
