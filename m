Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbYJQLwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbYJQLwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYJQLwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:52:34 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:28001 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYJQLwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:52:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=bYbhmAzVRdTFKoiu9bVRLz6INpmPTrL6pAZgCIKSM9XSNsyijC2fSuituAaYM+Ss75
         mqNiBpCCvzuenDkW+LpN8eWfe/KUpEUDj97VZe1vUp1SBMkIg59Y6un/TzLwByhE4rzv
         ZpXhvoEbMToPOO8Mjv8in94sIdTZR8hg5QxYs=
Date: Fri, 17 Oct 2008 15:55:35 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: proc_init_inodecache can't fail
Message-ID: <20081017115535.GA19077@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added to proc.git]

commit 7e19c847f7e748e8fbb2f4149d0d1dbde4c8b0b9
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Fri Oct 17 03:43:55 2008 +0400

    proc: proc_init_inodecache() can't fail
    
    kmem_cache creation code will panic, don't return anything.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index c6b4fa7..2543fd0 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -106,14 +106,13 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-int __init proc_init_inodecache(void)
+void __init proc_init_inodecache(void)
 {
 	proc_inode_cachep = kmem_cache_create("proc_inode_cache",
 					     sizeof(struct proc_inode),
 					     0, (SLAB_RECLAIM_ACCOUNT|
 						SLAB_MEM_SPREAD|SLAB_PANIC),
 					     init_once);
-	return 0;
 }
 
 static const struct super_operations proc_sops = {
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 3bfb7b8..d5bf4de 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -66,7 +66,7 @@ extern const struct inode_operations proc_net_inode_operations;
 
 void free_proc_entry(struct proc_dir_entry *de);
 
-int proc_init_inodecache(void);
+void proc_init_inodecache(void);
 
 static inline struct pid *proc_pid(struct inode *inode)
 {
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 9511753..2a3abd2 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -104,9 +104,9 @@ static struct file_system_type proc_fs_type = {
 
 void __init proc_root_init(void)
 {
-	int err = proc_init_inodecache();
-	if (err)
-		return;
+	int err;
+
+	proc_init_inodecache();
 	err = register_filesystem(&proc_fs_type);
 	if (err)
 		return;
