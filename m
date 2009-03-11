Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbZCKWLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbZCKWLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbZCKWLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:11:22 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56415 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZCKWLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:11:21 -0400
Subject: Re: [patch 1/2] fs: mnt_want_write speedup
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090310143718.GB15977@wotan.suse.de>
References: <20090310143718.GB15977@wotan.suse.de>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 15:11:17 -0700
Message-Id: <1236809477.30142.83.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm feeling a bit better about these, although I am still honestly quite
afraid of the barriers.  I also didn't like all the #ifdefs much, but
here's some help on that.

How about this on top of what you have as a bit of a cleanup?  It gets
rid of all the new #ifdefs in .c files?

Did I miss the use of get_mnt_writers_ptr()?  I don't think I actually
saw it used anywhere in this pair of patches, so I've stolen it.  I
think gcc should compile all this new stuff down to be basically the
same as you had before.  The one thing I'm not horribly sure of is the
"out_free_devname:" label.  It shouldn't be reachable in the !SMP case. 

I could also consolidate the header #ifdefs into a single one if you
think that looks better.

This is just compile tested, btw.  

---

 linux-2.6.git-dave/fs/namespace.c        |   35 ++++++-------------------------
 linux-2.6.git-dave/include/linux/mount.h |   30 ++++++++++++++++++++++++--
 2 files changed, 35 insertions(+), 30 deletions(-)

diff -puN include/linux/mount.h~move-ifdefs-take2 include/linux/mount.h
--- linux-2.6.git/include/linux/mount.h~move-ifdefs-take2	2009-03-11 15:01:10.000000000 -0700
+++ linux-2.6.git-dave/include/linux/mount.h	2009-03-11 15:02:01.000000000 -0700
@@ -71,15 +71,41 @@ struct vfsmount {
 #endif
 };
 
-static inline int *get_mnt_writers_ptr(struct vfsmount *mnt)
+static inline int *get_mnt_writers_ptr_cpu(struct vfsmount *mnt,
+					   int cpu)
 {
 #ifdef CONFIG_SMP
-	return mnt->mnt_writers;
+	return per_cpu_ptr(mnt->mnt_writers, cpu);
 #else
 	return &mnt->mnt_writers;
 #endif
 }
 
+static inline int *get_mnt_writers_ptr(struct vfsmount *mnt)
+{
+	return get_mnt_writers_ptr_cpu(mnt, smp_processor_id());
+}
+
+static inline int alloc_mnt_writers(struct vfsmount *mnt)
+{
+#ifdef CONFIG_SMP
+	mnt->mnt_writers = alloc_percpu(int);
+	if (!mnt->mnt_writers)
+		return -ENOMEM;
+#else
+	mnt->mnt_writers = 0;
+#endif
+	return 0;
+}
+
+static inline void free_mnt_writers(struct vfsmount *mnt)
+{
+#ifdef CONFIG_SMP
+	free_percpu(mnt->mnt_writers);
+#endif
+}
+
+
 static inline struct vfsmount *mntget(struct vfsmount *mnt)
 {
 	if (mnt)
diff -puN fs/namespace.c~move-ifdefs-take2 fs/namespace.c
--- linux-2.6.git/fs/namespace.c~move-ifdefs-take2	2009-03-11 15:01:10.000000000 -0700
+++ linux-2.6.git-dave/fs/namespace.c	2009-03-11 15:04:05.000000000 -0700
@@ -130,20 +130,14 @@ struct vfsmount *alloc_vfsmnt(const char
 		INIT_LIST_HEAD(&mnt->mnt_share);
 		INIT_LIST_HEAD(&mnt->mnt_slave_list);
 		INIT_LIST_HEAD(&mnt->mnt_slave);
-#ifdef CONFIG_SMP
-		mnt->mnt_writers = alloc_percpu(int);
-		if (!mnt->mnt_writers)
+		err = alloc_mnt_writers(mnt);
+		if (err)
 			goto out_free_devname;
-#else
-		mnt->mnt_writers = 0;
-#endif
 	}
 	return mnt;
 
-#ifdef CONFIG_SMP
 out_free_devname:
 	kfree(mnt->mnt_devname);
-#endif
 out_free_id:
 	mnt_free_id(mnt);
 out_free_cache:
@@ -182,36 +176,23 @@ EXPORT_SYMBOL_GPL(__mnt_is_readonly);
 
 static inline void inc_mnt_writers(struct vfsmount *mnt)
 {
-#ifdef CONFIG_SMP
-	(*per_cpu_ptr(mnt->mnt_writers, smp_processor_id()))++;
-#else
-	mnt->mnt_writers++;
-#endif
+	(*get_mnt_writers_ptr(mnt))++;
 }
 
 static inline void dec_mnt_writers(struct vfsmount *mnt)
 {
-#ifdef CONFIG_SMP
-	(*per_cpu_ptr(mnt->mnt_writers, smp_processor_id()))--;
-#else
-	mnt->mnt_writers--;
-#endif
+	(*get_mnt_writers_ptr(mnt))--;
 }
 
 static unsigned int count_mnt_writers(struct vfsmount *mnt)
 {
-#ifdef CONFIG_SMP
 	unsigned int count = 0;
 	int cpu;
 
-	for_each_possible_cpu(cpu) {
-		count += *per_cpu_ptr(mnt->mnt_writers, cpu);
-	}
+	for_each_possible_cpu(cpu)\
+		count += *get_mnt_writers_ptr_cpu(mnt, cpu);
 
 	return count;
-#else
-	return mnt->mnt_writers;
-#endif
 }
 
 /*
@@ -344,9 +325,7 @@ void free_vfsmnt(struct vfsmount *mnt)
 {
 	kfree(mnt->mnt_devname);
 	mnt_free_id(mnt);
-#ifdef CONFIG_SMP
-	free_percpu(mnt->mnt_writers);
-#endif
+	free_mnt_writers(mnt);
 	kmem_cache_free(mnt_cache, mnt);
 }
 
_


-- Dave

