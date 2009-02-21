Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbZBUBzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbZBUBzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 20:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZBUBzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 20:55:04 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:57048 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZBUBzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 20:55:01 -0500
Date: Fri, 20 Feb 2009 17:54:57 -0800
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: akpm@linux-foundation.org
Cc: wli@movementarian.org, mel@csn.ul.ie, linux-mm@kvack.org,
       shai@scalex86.org, linux-kernel@vger.kernel.org
Subject: [patch 1/2] mm: Fix SHM_HUGETLB to work with users in
	hugetlb_shm_group
Message-ID: <20090221015457.GA32674@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a two patch series to fix a long standing inconsistency with the
mechanism to allow non root users allocate hugetlb shm.  The patch changelog
is self explanatory.  Here's a link to the previous discussion as well:

	http://lkml.org/lkml/2009/2/10/89

---
Fix hugetlb subsystem so that non root users belonging to hugetlb_shm_group
can actually allocate hugetlb backed shm.

Currently non root users cannot even map one large page using SHM_HUGETLB
when they belong to the gid in /proc/sys/vm/hugetlb_shm_group.
This is because allocation size is verified against RLIMIT_MEMLOCK resource
limit even if the user belongs to hugetlb_shm_group.

This patch
1. Fixes hugetlb subsystem so that users with CAP_IPC_LOCK and users
   belonging to hugetlb_shm_group don't need to be restricted with
   RLIMIT_MEMLOCK resource limits
2. This patch also disables mlock based rlimit checking (which will
   be reinstated and marked deprecated in a subsequent patch).

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Wli <wli@movementarian.org>

Index: linux-2.6-tip/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6-tip.orig/fs/hugetlbfs/inode.c	2009-02-10 13:24:56.000000000 -0800
+++ linux-2.6-tip/fs/hugetlbfs/inode.c	2009-02-10 13:30:05.000000000 -0800
@@ -942,9 +942,7 @@ static struct vfsmount *hugetlbfs_vfsmou
 
 static int can_do_hugetlb_shm(void)
 {
-	return likely(capable(CAP_IPC_LOCK) ||
-			in_group_p(sysctl_hugetlb_shm_group) ||
-			can_do_mlock());
+	return (capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group));
 }
 
 struct file *hugetlb_file_setup(const char *name, size_t size)
@@ -962,9 +960,6 @@ struct file *hugetlb_file_setup(const ch
 	if (!can_do_hugetlb_shm())
 		return ERR_PTR(-EPERM);
 
-	if (!user_shm_lock(size, user))
-		return ERR_PTR(-ENOMEM);
-
 	root = hugetlbfs_vfsmount->mnt_root;
 	quick_string.name = name;
 	quick_string.len = strlen(quick_string.name);
@@ -1002,7 +997,6 @@ out_inode:
 out_dentry:
 	dput(dentry);
 out_shm_unlock:
-	user_shm_unlock(size, user);
 	return ERR_PTR(error);
 }
 
