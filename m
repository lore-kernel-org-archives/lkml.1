Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbXLaWzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbXLaWzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 17:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbXLaWyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 17:54:52 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44736 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbXLaWyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 17:54:51 -0500
Subject: Re: getting rid of filp search in fs_may_remount_ro()
From: Dave Hansen <haveblue@us.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1199130866.13731.27.camel@localhost>
References: <20071126135220.GA17244@lst.de>  <20071226141214.GA31455@lst.de>
	 <1199130866.13731.27.camel@localhost>
Content-Type: text/plain
Date: Mon, 31 Dec 2007 14:54:48 -0800
Message-Id: <1199141688.13731.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-31 at 11:54 -0800, Dave Hansen wrote:
> On Wed, 2007-12-26 at 15:12 +0100, Christoph Hellwig wrote:
> > Btw, I just noticed in current -mm fs_may_remount_ro() is still around
> > and not replaced by ther per-sb writers count.  That surely sounds like
> > some kind of mismerge..
> 
> I was actually leaving that for later.  Getting rid of the filp search
> is a great benefit of the r/o bind patches, but it isn't strictly
> necessary and it doesn't really hurt anything to keep it.
> 
> The reason that it was contentious was that we need some way to be able
> to do an sb-to-mount mapping.  When remounting the sb, we need to
> determine whether *any* of the mounts of that sb have any writers.
> 
> We don't currently have any mechanisms to do direct lookups from sb to
> mount.  The only alternative I can see right now is to walk over all
> tasks, then walk over all vfs namespaces, and walk each mount tree to
> see if any mounts are of the sb we're looking for.  This needs to be
> done while already holding the mnt_writers[] locks so that no new mnt
> writers can come in.
> 
> *THAT* is going to be a heavyweight operation.  I need to go look in
> detail at how the mount trees are kept, and we'll need some kind of
> mechanism to keep track of which vfs namespaces we've looked at during
> the search so we don't search them twice. 
> 
> Can you think of a simpler way to do it?

Here's one blatantly untested idea I have.  The idea is to keep track if
anyone might be writing to a mnt.  We keep track on a flag in the mnt.
When we set the flag, we increment a counter in the sb and decrement
when the flag is cleared.

We can't simply look at mnt->__mnt_writers because there might be
"checked-out" writers in the mnt_writers[] array.  We also have to keep
new writers from coming in while we do this, so we use the spinlocks in
the mnt_writers[] array for exclusion.  This is a pretty heavyweight
lock, but it only gets used at rw->ro transitions.

-- Dave

--- ./fs/file_table.c.orig	2007-12-31 11:14:59.000000000 -0800
+++ ./fs/file_table.c	2007-12-31 14:38:19.000000000 -0800
@@ -376,26 +376,12 @@
 
 int fs_may_remount_ro(struct super_block *sb)
 {
-	struct file *file;
-
-	/* Check that no files are currently opened for writing. */
-	file_list_lock();
-	list_for_each_entry(file, &sb->s_files, f_u.fu_list) {
-		struct inode *inode = file->f_path.dentry->d_inode;
-
-		/* File with pending delete? */
-		if (inode->i_nlink == 0)
-			goto too_bad;
-
-		/* Writeable file? */
-		if (S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE))
-			goto too_bad;
-	}
-	file_list_unlock();
-	return 1; /* Tis' cool bro. */
-too_bad:
-	file_list_unlock();
-	return 0;
+	int ret = 1;
+	lock_mnt_writers();
+	if (atomic_read(&sb->__s_mnt_writers))
+		ret = 0;
+	unlock_mnt_writers();
+	return ret;
 }
 
 void __init files_init(unsigned long mempages)
--- ./fs/namespace.c.orig	2007-12-31 13:52:36.000000000 -0800
+++ ./fs/namespace.c	2007-12-31 14:53:56.000000000 -0800
@@ -138,7 +138,7 @@
 }
 fs_initcall(init_mnt_writers);
 
-static void mnt_unlock_cpus(void)
+void mnt_unlock_cpus(void)
 {
 	int cpu;
 	struct mnt_writer *cpu_writer;
@@ -149,6 +149,22 @@
 	}
 }
 
+static void mark_mnt_has_writer(struct vfsmount *mnt)
+{
+	if (!test_and_set_bit(ilog2(MNT_MAY_HAVE_WRITERS), &mnt->mnt_flags))
+		atomic_inc(&mnt->mnt_sb->s_possible_mnt_writers);
+}
+
+static void check_mnt_for_writers(struct vfsmount *mnt)
+{
+	int bitnr = ilog2(MNT_MAY_HAVE_WRITERS);
+
+	if (atomic_read(&mnt->__mnt_writers))
+		mark_mnt_has_writer(mnt);
+	else if (test_and_clear_bit(bitnr, &mnt->mnt_flags))
+		atomic_dec(&mnt->mnt_sb->s_possible_mnt_writers);
+}
+
 static inline void __clear_mnt_count(struct mnt_writer *cpu_writer)
 {
 	if (!cpu_writer->mnt)
@@ -199,6 +215,7 @@
 	}
 	use_cpu_writer_for_mount(cpu_writer, mnt);
 	cpu_writer->count++;
+	mark_mnt_has_writer(mnt);
 out:
 	spin_unlock(&cpu_writer->lock);
 	put_cpu_var(mnt_writers);
@@ -215,11 +232,33 @@
 		cpu_writer = &per_cpu(mnt_writers, cpu);
 		spin_lock(&cpu_writer->lock);
 		__clear_mnt_count(cpu_writer);
+		/*
+		 * __mnt_writers may temporarily hit zero
+		 * (and trigger MNT_MAY_HAVE_WRITERS to get
+		 * cleared), but it will get set again if
+		 * and when another mnt_writer[] has an
+		 * entry for that mnt later in this loop.
+		 */
+		check_mnt_has_writers(cpu_writer->mnt);
 		cpu_writer->mnt = NULL;
 	}
 }
 
 /*
+ * This is just an external interface.  I want
+ * to use the long names in here, but leave the
+ * simpler names for external users.
+ */
+void lock_mnt_writers()
+{
+	lock_and_coalesce_cpu_mnt_writer_counts();
+}
+void unlock_mnt_writers()
+{
+	mnt_unlock_cpus();
+}
+
+/*
  * These per-cpu write counts are not guaranteed to have
  * matched increments and decrements on any given cpu.
  * A file open()ed for write on one cpu and close()d on
--- ./include/linux/fs.h.orig	2007-12-31 14:08:20.000000000 -0800
+++ ./include/linux/fs.h	2007-12-31 14:31:12.000000000 -0800
@@ -1005,6 +1005,9 @@
 #ifdef CONFIG_SECURITY
 	void                    *s_security;
 #endif
+	atomic_t		__s_mnt_writers;/* how many mounts of this sb might
+						 * have writers.  Only stable with
+						 * all mnt_writers[] locks held */
 	struct xattr_handler	**s_xattr;
 
 	struct list_head	s_inodes;	/* all inodes */
--- ./include/linux/mount.h.orig	2007-12-31 14:00:13.000000000 -0800
+++ ./include/linux/mount.h	2007-12-31 14:33:44.000000000 -0800
@@ -33,6 +33,7 @@
 
 #define MNT_SHRINKABLE	0x100
 #define MNT_IMBALANCED_WRITE_COUNT	0x200 /* just for debugging */
+#define MNT_MAY_HAVE_WRITERS		0x400 /* did this ever have a writer? */
 
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
@@ -80,6 +81,8 @@
 
 extern int mnt_want_write(struct vfsmount *mnt);
 extern void mnt_drop_write(struct vfsmount *mnt);
+extern void lock_mnt_writers(void);
+extern void unlock_mnt_writers(void);
 extern void mntput_no_expire(struct vfsmount *mnt);
 extern void mnt_pin(struct vfsmount *mnt);
 extern void mnt_unpin(struct vfsmount *mnt);


