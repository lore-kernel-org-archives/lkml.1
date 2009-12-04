Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbZLDUsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbZLDUsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:48:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbZLDUr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:47:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329AbZLDUrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:47:55 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH 02/15] shmem: use alloc_file instead of init_file
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
Date: Fri, 04 Dec 2009 15:46:56 -0500
Message-ID: <20091204204656.18286.15131.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091204204646.18286.24853.stgit@paris.rdu.redhat.com>
References: <20091204204646.18286.24853.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shmem uses get_empty_filp() and then init_file().  Their is no good reason
not to just use alloc_file() like everything else.

Acked-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 mm/shmem.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e7f8968..b212184 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2640,21 +2640,20 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
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
 
 	ima_counts_get(file);
 
@@ -2667,8 +2666,6 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
 #endif
 	return file;
 
-close_file:
-	put_filp(file);
 put_dentry:
 	dput(dentry);
 put_memory:

