Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZLCT7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZLCT7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZLCT7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:59:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbZLCT7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:59:19 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH 1/6] shmem: use alloc_file instead of init_file
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Cc: viro@zeniv.linux.org.uk, jmorris@namei.org, npiggin@suse.de,
       eparis@redhat.com, zohar@us.ibm.com, jack@suse.cz,
       jmalicki@metacarta.com, dsmith@redhat.com, serue@us.ibm.com, hch@lst.de,
       john@johnmccutchan.com, rlove@rlove.org, ebiederm@xmission.com,
       heiko.carstens@de.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp,
       mszeredi@suse.cz, jens.axboe@oracle.com, akpm@linux-foundation.org,
       matthew@wil.cx, hugh.dickins@tiscali.co.uk,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       davem@davemloft.net, arnd@arndb.de, eric.dumazet@gmail.com
Date: Thu, 03 Dec 2009 14:58:51 -0500
Message-ID: <20091203195851.8925.30926.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shmem uses get_empty_filp() and then init_file().  Their is no good reason
not to just use alloc_file() like everything else.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 mm/shmem.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 356dd99..831f8bb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2640,32 +2640,32 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
 	if (!dentry)
 		goto put_memory;
 
-	error = -ENFILE;
-	file = get_empty_filp();
-	if (!file)
-		goto put_dentry;
-
 	error = -ENOSPC;
 	inode = shmem_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0, flags);
 	if (!inode)
-		goto close_file;
+		goto put_dentry;
 
 	d_instantiate(dentry, inode);
 	inode->i_size = size;
 	inode->i_nlink = 0;	/* It is unlinked */
-	init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
-		  &shmem_file_operations);
+
+	error = -ENFILE;
+	file = alloc_file(shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
+			  &shmem_file_operations);
+	if (!file)
+		goto put_dentry;
 
 #ifndef CONFIG_MMU
 	error = ramfs_nommu_expand_for_mapping(inode, size);
 	if (error)
 		goto close_file;
 #endif
-	ima_counts_get(file);
 	return file;
 
+#ifndef CONFIG_MMU
 close_file:
-	put_filp(file);
+	fput(file);
+#endif
 put_dentry:
 	dput(dentry);
 put_memory:

