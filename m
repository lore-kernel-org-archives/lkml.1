Return-Path: <linux-kernel-owner+w=401wt.eu-S1761217AbYG3Cvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761217AbYG3Cvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbYG3Cpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:45:35 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46263 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbYG3CoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:44:22 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, miklos@szeredi.hu,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 16/19] Unionfs: symlink no longer takes a mode parameter
Date: Tue, 29 Jul 2008 22:43:46 -0400
Message-Id: <12173858443931-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
References: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/copyup.c |    1 -
 fs/unionfs/inode.c  |    3 +--
 fs/unionfs/sioq.c   |    2 +-
 fs/unionfs/sioq.h   |    1 -
 4 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index bbd49c8..ae6ea2b 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -184,7 +184,6 @@ static int __copyup_ndentry(struct dentry *old_lower_dentry,
 		args.symlink.parent = new_lower_parent_dentry->d_inode;
 		args.symlink.dentry = new_lower_dentry;
 		args.symlink.symbuf = symbuf;
-		args.symlink.mode = old_mode;
 
 		run_sioq(__unionfs_symlink, &args);
 		err = args.err;
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index a05b412..1a95e3b 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -412,8 +412,7 @@ static int unionfs_symlink(struct inode *parent, struct dentry *dentry,
 	}
 
 	mode = S_IALLUGO;
-	err = vfs_symlink(lower_parent_dentry->d_inode, lower_dentry,
-			  symname, mode);
+	err = vfs_symlink(lower_parent_dentry->d_inode, lower_dentry, symname);
 	if (!err) {
 		err = PTR_ERR(unionfs_interpose(dentry, parent->i_sb, 0));
 		if (!err) {
diff --git a/fs/unionfs/sioq.c b/fs/unionfs/sioq.c
index e6f15a0..dd45e39 100644
--- a/fs/unionfs/sioq.c
+++ b/fs/unionfs/sioq.c
@@ -87,7 +87,7 @@ void __unionfs_symlink(struct work_struct *work)
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct symlink_args *s = &args->symlink;
 
-	args->err = vfs_symlink(s->parent, s->dentry, s->symbuf, s->mode);
+	args->err = vfs_symlink(s->parent, s->dentry, s->symbuf);
 	complete(&args->comp);
 }
 
diff --git a/fs/unionfs/sioq.h b/fs/unionfs/sioq.h
index e072bf7..679a0df 100644
--- a/fs/unionfs/sioq.h
+++ b/fs/unionfs/sioq.h
@@ -49,7 +49,6 @@ struct symlink_args {
 	struct inode *parent;
 	struct dentry *dentry;
 	char *symbuf;
-	umode_t mode;
 };
 
 struct unlink_args {
-- 
1.5.2.2

