Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbXKFQ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbXKFQ7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 11:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbXKFQ7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 11:59:08 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45365 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbXKFQ7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 11:59:07 -0500
Subject: [PATCH] r/o bind mounts: fix buggy loop
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, hugh@veritas.com,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Tue, 06 Nov 2007 08:59:00 -0800
Message-Id: <20071106165900.4AA6F6E1@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The mnt->__mnt_writers can go negative for a time if
a pair of mnt_want_write()/mnt_drop_write() calls is
done on a different cpu, but for the same mount.
This part is expected.

The lock_and_coalesce..() function should make that
count positive (or at least 0).  Hugh Dickins had
found a bug in the unionfs code which caused a
permanent imbalance in this code, and eventually
underflowed the atomic_t mnt->__mnt_writers.

It also locked up the while() loop that expects the
count to go up after it is coalesced.

The following patch won't fix such a unionfs bug, but
it will keep the loop from locking up.  It will also
warn a lot earlier that something funky is going on.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/namespace.c        |   31 ++++++++++++++++++++++---------
 linux-2.6.git-dave/include/linux/mount.h |    1 +
 2 files changed, 23 insertions(+), 9 deletions(-)

diff -puN fs/namei.c~fix-naughty-loop fs/namei.c
diff -puN fs/namespace.c~fix-naughty-loop fs/namespace.c
--- linux-2.6.git/fs/namespace.c~fix-naughty-loop	2007-11-05 08:03:59.000000000 -0800
+++ linux-2.6.git-dave/fs/namespace.c	2007-11-05 08:35:06.000000000 -0800
@@ -225,16 +225,29 @@ static void lock_and_coalesce_cpu_mnt_wr
  */
 static void handle_write_count_underflow(struct vfsmount *mnt)
 {
-	while (atomic_read(&mnt->__mnt_writers) <
-		MNT_WRITER_UNDERFLOW_LIMIT) {
-		/*
-		 * It isn't necessary to hold all of the locks
-		 * at the same time, but doing it this way makes
-		 * us share a lot more code.
-		 */
-		lock_and_coalesce_cpu_mnt_writer_counts();
-		mnt_unlock_cpus();
+	if (atomic_read(&mnt->__mnt_writers) >=
+	    MNT_WRITER_UNDERFLOW_LIMIT)
+		return;
+	/*
+	 * It isn't necessary to hold all of the locks
+	 * at the same time, but doing it this way makes
+	 * us share a lot more code.
+	 */
+	lock_and_coalesce_cpu_mnt_writer_counts();
+	/*
+	 * If coalescing the per-cpu writer counts did not
+	 * get us back to a positive writer count, we have
+	 * a bug.
+	 */
+	if ((atomic_read(&mnt->__mnt_writers) < 0) &&
+	    !(mnt->mnt_flags & MNT_IMBALANCED_WRITE_COUNT)) {
+		printk("leak detected on mount(%p) writers count: %d\n",
+			mnt, atomic_read(&mnt->__mnt_writers));
+		WARN_ON(1);
+		/* use the flag to keep the dmesg spam down */
+		mnt->mnt_flags |= MNT_IMBALANCED_WRITE_COUNT;
 	}
+	mnt_unlock_cpus();
 }
 
 /**
diff -puN include/linux/mount.h~fix-naughty-loop include/linux/mount.h
--- linux-2.6.git/include/linux/mount.h~fix-naughty-loop	2007-11-05 08:22:21.000000000 -0800
+++ linux-2.6.git-dave/include/linux/mount.h	2007-11-05 08:28:20.000000000 -0800
@@ -32,6 +32,7 @@ struct mnt_namespace;
 #define MNT_READONLY	0x40	/* does the user want this to be r/o? */
 
 #define MNT_SHRINKABLE	0x100
+#define MNT_IMBALANCED_WRITE_COUNT	0x200 /* just for debugging */
 
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
diff -puN include/linux/fs.h~fix-naughty-loop include/linux/fs.h
diff -puN fs/nfsd/nfs4state.c~fix-naughty-loop fs/nfsd/nfs4state.c
_
