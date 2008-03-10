Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbYCJPNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbYCJPNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYCJPNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:13:12 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:50640 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbYCJPNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=r8x3mbG/c9XeCDs1KXTH1kgAkELnpugWYiUORMrOMb4F7/eDjeokrEaBrGGALFo+Tr61FQahHbLUW091+M81XU5uLyAEBSLamjLASlaIW73G4ogMB2Z000Zjp8KkKefPw5wRjzSaQ9/i+8JMiCpf+46yiO/Y7W8gYBlQ2Fr09ag=
Date: Tue, 11 Mar 2008 00:05:37 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/5] tiny-shmem: use call_once()
Message-ID: <20080310150531.GD6407@APFDCB5C>
References: <20080310145704.GA6396@APFDCB5C> <20080310150026.GA6407@APFDCB5C> <20080310150148.GB6407@APFDCB5C> <20080310150308.GC6407@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20080310150308.GC6407@APFDCB5C>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defers mounting tmpfs till shmem_file_setup() is
called first time by using call_once().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 mm/tiny-shmem.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

Index: 2.6-rc/mm/tiny-shmem.c
===================================================================
--- 2.6-rc.orig/mm/tiny-shmem.c
+++ 2.6-rc/mm/tiny-shmem.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/swap.h>
 #include <linux/ramfs.h>
+#include <linux/once.h>
 
 static struct file_system_type tmpfs_fs_type = {
 	.name		= "tmpfs",
@@ -26,19 +27,23 @@ static struct file_system_type tmpfs_fs_
 	.kill_sb	= kill_litter_super,
 };
 
-static struct vfsmount *shm_mnt;
-
 static int __init init_tmpfs(void)
 {
 	BUG_ON(register_filesystem(&tmpfs_fs_type) != 0);
 
-	shm_mnt = kern_mount(&tmpfs_fs_type);
-	BUG_ON(IS_ERR(shm_mnt));
-
 	return 0;
 }
 module_init(init_tmpfs)
 
+static struct vfsmount *shm_mnt;
+
+static int init_shm_mnt(void)
+{
+	shm_mnt = kern_mount(&tmpfs_fs_type);
+
+	return IS_ERR(shm_mnt) ? PTR_ERR(shm_mnt) : 0;
+}
+
 /*
  * shmem_file_setup - get an unlinked file living in tmpfs
  *
@@ -53,9 +58,11 @@ struct file *shmem_file_setup(char *name
 	struct inode *inode;
 	struct dentry *dentry, *root;
 	struct qstr this;
+	static DEFINE_ONCE(once);
 
-	if (IS_ERR(shm_mnt))
-		return (void *)shm_mnt;
+	error = call_once(&once, init_shm_mnt);
+	if (error)
+		return ERR_PTR(error);
 
 	error = -ENOMEM;
 	this.name = name;
