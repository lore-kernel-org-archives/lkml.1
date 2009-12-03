Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZLCT7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZLCT7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbZLCT7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:59:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbZLCT7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:59:36 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH 2/6] pipes: use alloc-file instead of duplicating code
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
Date: Thu, 03 Dec 2009 14:59:02 -0500
Message-ID: <20091203195902.8925.2985.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091203195851.8925.30926.stgit@paris.rdu.redhat.com>
References: <20091203195851.8925.30926.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pipe code duplicates the functionality of alloc-file and init-file.  Use
the generic vfs functions instead of duplicating code.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/pipe.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index ae17d02..5d6c969 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1028,20 +1028,17 @@ void free_write_pipe(struct file *f)
 
 struct file *create_read_pipe(struct file *wrf, int flags)
 {
-	struct file *f = get_empty_filp();
-	if (!f)
-		return ERR_PTR(-ENFILE);
-
-	/* Grab pipe from the writer */
-	f->f_path = wrf->f_path;
-	path_get(&wrf->f_path);
-	f->f_mapping = wrf->f_path.dentry->d_inode->i_mapping;
+	struct file *f;
+	struct dentry *dentry = wrf->f_path.dentry;
+	struct vfsmount *mnt = wrf->f_path.mnt;
 
-	f->f_pos = 0;
+	dentry = dget(dentry);
+	f = alloc_file(mnt, dentry, FMODE_READ, &read_pipefifo_fops);
+	if (!f) {
+		dput(dentry);
+		return ERR_PTR(-ENFILE);
+	}
 	f->f_flags = O_RDONLY | (flags & O_NONBLOCK);
-	f->f_op = &read_pipefifo_fops;
-	f->f_mode = FMODE_READ;
-	f->f_version = 0;
 
 	return f;
 }

