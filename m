Return-Path: <linux-kernel-owner+w=401wt.eu-S1764154AbXFKFDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764154AbXFKFDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 01:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbXFKFC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 01:02:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:50571 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbXFKFCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 01:02:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WGGnABVEUZKCn3vY+hexRoIXCX90FbRz6WltzSE5aCoVTfN961r4r2VSo6vk5cseuAJ4pzgIDFP3jcPO6iNKGzGQzA7NfKXSxuduMb90ui2vn6H33pZO7q/BCGxy+quo1fSrM5O62AfNzPErGzrjbuQ1y5nWVxdQe8D7QnS8dz8=
Date: Mon, 11 Jun 2007 14:02:45 +0900
From: Tejun Heo <htejun@gmail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org,
       cebbert@redhat.com, sandeen@redhat.com, maneesh@in.ibm.com,
       cs@tequila.co.jp
Subject: [PATCH 1/3] sysfs: store sysfs inode nrs in s_ino to avoid readdir oopses
Message-ID: <20070611050245.GK29122@htj.dyndns.org>
References: <20070611050107.GJ29122@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611050107.GJ29122@htj.dyndns.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@sandeen.net>

Backport of
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/broken-out/gregkh-driver-sysfs-allocate-inode-number-using-ida.patch

For regular files in sysfs, sysfs_readdir wants to traverse
sysfs_dirent->s_dentry->d_inode->i_ino to get to the inode number.
But, the dentry can be reclaimed under memory pressure, and there is
no synchronization with readdir.  This patch follows Tejun's scheme of
allocating and storing an inode number in the new s_ino member of a
sysfs_dirent, when dirents are created, and retrieving it from there
for readdir, so that the pointer chain doesn't have to be traversed.

Tejun's upstream patch uses a new-ish "ida" allocator which brings
along some extra complexity; this -stable patch has a brain-dead
incrementing counter which does not guarantee uniqueness, but because
sysfs doesn't hash inodes as iunique expects, uniqueness wasn't
guaranteed today anyway.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |   16 +++++++++++-----
 fs/sysfs/inode.c |    1 +
 fs/sysfs/mount.c |    1 +
 fs/sysfs/sysfs.h |    1 +
 4 files changed, 14 insertions(+), 5 deletions(-)

Index: work1/fs/sysfs/dir.c
===================================================================
--- work1.orig/fs/sysfs/dir.c
+++ work1/fs/sysfs/dir.c
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
Index: work1/fs/sysfs/inode.c
===================================================================
--- work1.orig/fs/sysfs/inode.c
+++ work1/fs/sysfs/inode.c
@@ -141,6 +141,7 @@ struct inode * sysfs_new_inode(mode_t mo
 		inode->i_mapping->a_ops = &sysfs_aops;
 		inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 		inode->i_op = &sysfs_inode_operations;
+		inode->i_ino = sd->s_ino;
 		lockdep_set_class(&inode->i_mutex, &sysfs_inode_imutex_key);
 
 		if (sd->s_iattr) {
Index: work1/fs/sysfs/mount.c
===================================================================
--- work1.orig/fs/sysfs/mount.c
+++ work1/fs/sysfs/mount.c
@@ -33,6 +33,7 @@ static struct sysfs_dirent sysfs_root = 
 	.s_element	= NULL,
 	.s_type		= SYSFS_ROOT,
 	.s_iattr	= NULL,
+	.s_ino		= 1,
 };
 
 static void sysfs_clear_inode(struct inode *inode)
Index: work1/fs/sysfs/sysfs.h
===================================================================
--- work1.orig/fs/sysfs/sysfs.h
+++ work1/fs/sysfs/sysfs.h
@@ -5,6 +5,7 @@ struct sysfs_dirent {
 	void 			* s_element;
 	int			s_type;
 	umode_t			s_mode;
+	ino_t			s_ino;
 	struct dentry		* s_dentry;
 	struct iattr		* s_iattr;
 	atomic_t		s_event;
