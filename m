Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbXCPHRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbXCPHRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbXCPHRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:17:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41118 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbXCPHRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:17:08 -0400
Date: Fri, 16 Mar 2007 09:17:06 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] revoke: misc fixes
Message-ID: <Pine.LNX.4.64.0703160916430.14651@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This is a rollup patch of the following fixes to address some of Andrew's
review comments:

  - Fix return value type of system calls to long
  - Add comment for vma->vm_flag barrier
  - No need for GFP_NOFS for inode allocation, use GFP_KERNEL instead
  - Remove unnecessary line break before EXPORT_SYMBOL

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/revoke.c              |    9 +++++----
 include/linux/syscalls.h |    4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

Index: uml-2.6/fs/revoke.c
===================================================================
--- uml-2.6.orig/fs/revoke.c	2007-03-16 08:58:31.000000000 +0200
+++ uml-2.6/fs/revoke.c	2007-03-16 09:00:37.000000000 +0200
@@ -167,7 +167,9 @@ static int revoke_vma(struct vm_area_str
 	end_addr = vma->vm_end;
 
 	/*
- 	 * Not holding ->mmap_sem here.
+ 	 * Not holding ->mmap_sem here but we must watch out for page
+ 	 * faults and after the shared mappings have been taken down
+ 	 * and sys_mmap() trying to remap the revoked range.
 	 */
 	vma->vm_flags |= VM_REVOKED;
 	smp_mb();
@@ -455,7 +457,7 @@ 	int err = 0;
 	return err;
 }
 
-asmlinkage int sys_revokeat(int dfd, const char __user * filename)
+asmlinkage long sys_revokeat(int dfd, const char __user * filename)
 {
 	struct nameidata nd;
 	int err;
@@ -499,7 +501,6 @@ int generic_file_revoke(struct file *fil
   out:
 	return err;
 }
-
 EXPORT_SYMBOL(generic_file_revoke);
 
 /*
@@ -510,7 +511,7 @@ static struct inode *revokefs_alloc_inod
 {
 	struct revokefs_inode_info *info;
 
-	info = kmem_cache_alloc(revokefs_inode_cache, GFP_NOFS);
+	info = kmem_cache_alloc(revokefs_inode_cache, GFP_KERNEL);
 	if (!info)
 		return NULL;
 
Index: uml-2.6/include/linux/syscalls.h
===================================================================
--- uml-2.6.orig/include/linux/syscalls.h	2007-03-16 08:58:30.000000000 +0200
+++ uml-2.6/include/linux/syscalls.h	2007-03-16 08:59:59.000000000 +0200
@@ -605,7 +605,7 @@ asmlinkage long sys_getcpu(unsigned __us
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
-asmlinkage int sys_revokeat(int dfd, const char __user *filename);
-asmlinkage int sys_frevoke(unsigned int fd);
+asmlinkage long sys_revokeat(int dfd, const char __user *filename);
+asmlinkage long sys_frevoke(unsigned int fd);
 
 #endif
