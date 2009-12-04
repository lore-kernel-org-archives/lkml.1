Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbZLDUrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbZLDUrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757247AbZLDUrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:47:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757228AbZLDUrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:47:42 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH 01/15] shmem: do not call fput_filp on an initialized filp
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
Date: Fri, 04 Dec 2009 15:46:46 -0500
Message-ID: <20091204204646.18286.24853.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fput_filp is supposed to be used when the filp was not used.  But in the
ifndef CONFIG_MMU case shmem_setup_file could call this one an initialized
filp.  It should be using fput() instead.  Since the fput() will dec the ima
counts we also need to move the ima hook to make sure that is set up before
the fput().

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Miklos Szeredi <miklos@szeredi.hu>
---

 mm/shmem.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 356dd99..e7f8968 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2656,12 +2656,15 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
 	init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
 		  &shmem_file_operations);
 
+	ima_counts_get(file);
+
 #ifndef CONFIG_MMU
 	error = ramfs_nommu_expand_for_mapping(inode, size);
-	if (error)
-		goto close_file;
+	if (error) {
+		fput(file);
+		return error;
+	}
 #endif
-	ima_counts_get(file);
 	return file;
 
 close_file:

