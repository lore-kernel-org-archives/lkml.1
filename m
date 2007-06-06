Return-Path: <linux-kernel-owner+w=401wt.eu-S934016AbXFFTuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934016AbXFFTuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbXFFTuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:50:08 -0400
Received: from ns1.suse.de ([195.135.220.2]:51595 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbXFFTuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:50:07 -0400
Subject: patch sysfs-store-sysfs-inode-nrs-in-s_ino-to-avoid-readdir-oopses.patch queued to -stable tree
To: sandeen@sandeen.net, akpm@linux-foundation.org, gregkh@suse.de,
       htejun@gmail.com, linux-kernel@vger.kernel.org, maneesh@in.ibm.com,
       sandeen@redhat.com
Cc: <stable@kernel.org>
From: <gregkh@suse.de>
Date: Wed, 06 Jun 2007 12:49:53 -0700
In-Reply-To: <46525648.8050807@sandeen.net>
Message-Id: <20070606194950.D357EE83785@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

     Subject: sysfs: store sysfs inode nrs in s_ino to avoid readdir oopses

to the 2.6.21-stable tree.  Its filename is

     sysfs-store-sysfs-inode-nrs-in-s_ino-to-avoid-readdir-oopses.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Mon May 21 19:34:01 2007
From: Eric Sandeen <sandeen@sandeen.net>
Date: Mon, 21 May 2007 21:32:40 -0500
Subject: sysfs: store sysfs inode nrs in s_ino to avoid readdir oopses
To: Eric Sandeen <sandeen@redhat.com>
Cc: stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Maneesh Soni <maneesh@in.ibm.com>
Message-ID: <46525648.8050807@sandeen.net>


Backport of
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/broken-out/gregkh-driver-sysfs-allocate-inode-number-using-ida.patch

For regular files in sysfs, sysfs_readdir wants to traverse
sysfs_dirent->s_dentry->d_inode->i_ino to get to the inode number.
But, the dentry can be reclaimed under memory pressure, and there
is no synchronization with readdir.  This patch follows Tejun's
scheme of allocating and storing an inode number in the new s_ino
member of a sysfs_dirent, when dirents are created, and retrieving 
it from there for readdir, so that the pointer chain doesn't have 
to be traversed.

Tejun's upstream patch uses a new-ish "ida" allocator which brings along
some extra complexity; this -stable patch has a brain-dead incrementing
counter which does not guarantee uniqueness, but because sysfs doesn't 
hash inodes as iunique expects, uniqueness wasn't guaranteed today anyway.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- linux-2.6.21.orig/fs/sysfs/dir.c
+++ linux-2.6.21/fs/sysfs/dir.c
@@ -30,6 +30,14 @@ static struct dentry_operations sysfs_de
 	.d_iput		= sysfs_d_iput,
 };
 
+static unsigned int sysfs_inode_counter;
+ino_t sysfs_get_inum(void)
+{
+	if (unlikely(sysfs_inode_counter < 3))
+		sysfs_inode_counter = 3;
+	return sysfs_inode_counter++;
+}
+
 /*
  * Allocates a new sysfs_dirent and links it to the parent sysfs_dirent
  */
@@ -41,6 +49,7 @@ static struct sysfs_dirent * __sysfs_new
 	if (!sd)
 		return NULL;
 
+	sd->s_ino = sysfs_get_inum();
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_event, 1);
 	INIT_LIST_HEAD(&sd->s_children);
@@ -509,7 +518,7 @@ static int sysfs_readdir(struct file * f
 
 	switch (i) {
 		case 0:
-			ino = dentry->d_inode->i_ino;
+			ino = parent_sd->s_ino;
 			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
 				break;
 			filp->f_pos++;
@@ -538,10 +547,7 @@ static int sysfs_readdir(struct file * f
 
 				name = sysfs_get_name(next);
 				len = strlen(name);
-				if (next->s_dentry)
-					ino = next->s_dentry->d_inode->i_ino;
-				else
-					ino = iunique(sysfs_sb, 2);
+				ino = next->s_ino;
 
 				if (filldir(dirent, name, len, filp->f_pos, ino,
 						 dt_type(next)) < 0)
Index: linux-2.6.21/fs/sysfs/inode.c
===================================================================
--- linux-2.6.21.orig/fs/sysfs/inode.c
+++ linux-2.6.21/fs/sysfs/inode.c
@@ -140,6 +140,7 @@ struct inode * sysfs_new_inode(mode_t mo
 		inode->i_mapping->a_ops = &sysfs_aops;
 		inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 		inode->i_op = &sysfs_inode_operations;
+		inode->i_ino = sd->s_ino;
 		lockdep_set_class(&inode->i_mutex, &sysfs_inode_imutex_key);
 
 		if (sd->s_iattr) {
Index: linux-2.6.21/fs/sysfs/mount.c
===================================================================
--- linux-2.6.21.orig/fs/sysfs/mount.c
+++ linux-2.6.21/fs/sysfs/mount.c
@@ -33,6 +33,7 @@ static struct sysfs_dirent sysfs_root = 
 	.s_element	= NULL,
 	.s_type		= SYSFS_ROOT,
 	.s_iattr	= NULL,
+	.s_ino		= 1,
 };
 
 static void sysfs_clear_inode(struct inode *inode)
Index: linux-2.6.21/fs/sysfs/sysfs.h
===================================================================
--- linux-2.6.21.orig/fs/sysfs/sysfs.h
+++ linux-2.6.21/fs/sysfs/sysfs.h
@@ -5,6 +5,7 @@ struct sysfs_dirent {
 	void 			* s_element;
 	int			s_type;
 	umode_t			s_mode;
+	ino_t			s_ino;
 	struct dentry		* s_dentry;
 	struct iattr		* s_iattr;
 	atomic_t		s_event;

_______________________________________________
stable mailing list
stable@linux.kernel.org
http://linux.kernel.org/mailman/listinfo/stable


Patches currently in stable-queue which might be from sandeen@sandeen.net are

queue-2.6.21/sysfs-store-sysfs-inode-nrs-in-s_ino-to-avoid-readdir-oopses.patch
