Return-Path: <linux-kernel-owner+w=401wt.eu-S1761507AbXIURbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507AbXIURbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759357AbXIURbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:31:21 -0400
Received: from mail.sousedi.net ([85.132.167.140]:52434 "EHLO mail.sousedi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756925AbXIURbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:31:19 -0400
Message-ID: <46F3FFE9.7050503@prepere.com>
Date: Fri, 21 Sep 2007 19:31:21 +0200
From: Miloslav Semler <majkls@prepere.com>
User-Agent: IceDove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sysfs_readdir patch for 2.6.16.53
Content-Type: multipart/mixed;
 boundary="------------010209020707000902090804"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010209020707000902090804
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Hello everybody,
so there is some backport of sysfs_readdir patch from 2.6.22.6 to 
2.6.16.53. It is not well tested but it is actually working on my kernel.

Miloslav

--------------010209020707000902090804
Content-Type: text/x-diff;
 name="sysfs_readdir.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sysfs_readdir.patch"

diff -Nrp linux-2.6.16.53/fs/sysfs/dir.c linux-2.6.16.53-pretel/fs/sysfs/dir.c
*** linux-2.6.16.53/fs/sysfs/dir.c	2007-07-25 23:05:45.000000000 +0200
--- linux-2.6.16.53-pretel/fs/sysfs/dir.c	2007-08-21 20:48:26.000000000 +0200
*************** static struct dentry_operations sysfs_de
*** 29,34 ****
--- 29,42 ----
  	.d_iput		= sysfs_d_iput,
  };
  
+ static unsigned int sysfs_inode_counter;
+ ino_t sysfs_get_inum(void)
+ {
+        if (unlikely(sysfs_inode_counter < 3))
+                sysfs_inode_counter = 3;
+        return sysfs_inode_counter++;
+ }
+ 
  /*
   * Allocates a new sysfs_dirent and links it to the parent sysfs_dirent
   */
*************** static struct sysfs_dirent * sysfs_new_d
*** 40,47 ****
--- 48,57 ----
  	sd = kmem_cache_alloc(sysfs_dir_cachep, GFP_KERNEL);
  	if (!sd)
  		return NULL;
+ 	
  
  	memset(sd, 0, sizeof(*sd));
+ 	sd->s_ino = sysfs_get_inum();
  	atomic_set(&sd->s_count, 1);
  	INIT_LIST_HEAD(&sd->s_children);
  	list_add(&sd->s_sibling, &parent_sd->s_children);
*************** static int sysfs_readdir(struct file * f
*** 385,391 ****
  
  	switch (i) {
  		case 0:
! 			ino = dentry->d_inode->i_ino;
  			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
  				break;
  			filp->f_pos++;
--- 395,401 ----
  
  	switch (i) {
  		case 0:
!                         ino = parent_sd->s_ino;
  			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
  				break;
  			filp->f_pos++;
*************** static int sysfs_readdir(struct file * f
*** 415,424 ****
  
  				name = sysfs_get_name(next);
  				len = strlen(name);
! 				if (next->s_dentry)
! 					ino = next->s_dentry->d_inode->i_ino;
! 				else
! 					ino = iunique(sysfs_sb, 2);
  
  				if (filldir(dirent, name, len, filp->f_pos, ino,
  						 dt_type(next)) < 0)
--- 425,431 ----
  
  				name = sysfs_get_name(next);
  				len = strlen(name);
!                                 ino = next->s_ino;
  
  				if (filldir(dirent, name, len, filp->f_pos, ino,
  						 dt_type(next)) < 0)
diff -Nrp linux-2.6.16.53/fs/sysfs/inode.c linux-2.6.16.53-pretel/fs/sysfs/inode.c
*** linux-2.6.16.53/fs/sysfs/inode.c	2007-07-25 23:05:45.000000000 +0200
--- linux-2.6.16.53-pretel/fs/sysfs/inode.c	2007-08-21 20:16:22.000000000 +0200
*************** struct inode * sysfs_new_inode(mode_t mo
*** 119,124 ****
--- 119,125 ----
  		inode->i_mapping->a_ops = &sysfs_aops;
  		inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
  		inode->i_op = &sysfs_inode_operations;
+                 inode->i_ino = sd->s_ino;
  
  		if (sd->s_iattr) {
  			/* sysfs_dirent has non-default attributes
diff -Nrp linux-2.6.16.53/fs/sysfs/mount.c linux-2.6.16.53-pretel/fs/sysfs/mount.c
*** linux-2.6.16.53/fs/sysfs/mount.c	2007-07-25 23:05:45.000000000 +0200
--- linux-2.6.16.53-pretel/fs/sysfs/mount.c	2007-08-17 10:48:50.000000000 +0200
*************** static struct sysfs_dirent sysfs_root = 
*** 29,34 ****
--- 29,35 ----
  	.s_element	= NULL,
  	.s_type		= SYSFS_ROOT,
  	.s_iattr	= NULL,
+         .s_ino          = 1,
  };
  
  static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
diff -Nrp linux-2.6.16.53/include/linux/sysfs.h linux-2.6.16.53-pretel/include/linux/sysfs.h
*** linux-2.6.16.53/include/linux/sysfs.h	2007-07-25 23:05:45.000000000 +0200
--- linux-2.6.16.53-pretel/include/linux/sysfs.h	2007-08-17 10:50:42.000000000 +0200
*************** struct sysfs_dirent {
*** 72,77 ****
--- 72,78 ----
  	void 			* s_element;
  	int			s_type;
  	umode_t			s_mode;
+         ino_t                   s_ino;
  	struct dentry		* s_dentry;
  	struct iattr		* s_iattr;
  };

--------------010209020707000902090804--
