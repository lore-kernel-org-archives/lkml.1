Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZJABA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZJABA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 21:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbZJABA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 21:00:58 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:11415
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755306AbZJABA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 21:00:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEACucw0rLO7dJ/2dsb2JhbADXZ4QnBIFNVg
X-IronPort-AV: E=Sophos;i="4.44,483,1249228800"; 
   d="scan'208";a="567108567"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 01/10] autofs4 - use macros for active list handling
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Sage Weil <sage@newdream.net>, Al Viro <viro@ZenIV.linux.org.uk>,
       Andreas Dilger <adilger@sun.com>, Christoph Hellwig <hch@infradead.org>,
       Yehuda Saheh <yehuda@newdream.net>
Date: Thu, 01 Oct 2009 09:00:55 +0800
Message-ID: <20091001010054.7675.77673.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define some simple macro functions for adding and deleting entries
on the active (and unhashed) dentry list.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/autofs_i.h |    2 ++
 fs/autofs4/inode.c    |    1 +
 fs/autofs4/root.c     |   46 +++++++++++++++++++++++++++++++++++-----------
 3 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 8f7cdde..f3cf151 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -75,6 +75,8 @@ struct autofs_info {
 	struct completion expire_complete;
 
 	struct list_head active;
+	int active_count;
+
 	struct list_head expiring;
 
 	struct autofs_sb_info *sbi;
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 69c8142..4670a78 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -49,6 +49,7 @@ struct autofs_info *autofs4_init_ino(struct autofs_info *ino,
 		ino->dentry = NULL;
 		ino->size = 0;
 		INIT_LIST_HEAD(&ino->active);
+		ino->active_count = 0;
 		INIT_LIST_HEAD(&ino->expiring);
 		atomic_set(&ino->count, 0);
 	}
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index b96a3c5..67d8d96 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -72,6 +72,38 @@ const struct inode_operations autofs4_dir_inode_operations = {
 	.rmdir		= autofs4_dir_rmdir,
 };
 
+static void autofs4_add_active(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		if (!ino->active_count) {
+			if (list_empty(&ino->active))
+				list_add(&ino->active, &sbi->active_list);
+		}
+		ino->active_count++;
+		spin_unlock(&sbi->lookup_lock);
+	}
+	return;
+}
+
+static void autofs4_del_active(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		ino->active_count--;
+		if (!ino->active_count) {
+			if (!list_empty(&ino->active))
+				list_del_init(&ino->active);
+		}
+		spin_unlock(&sbi->lookup_lock);
+	}
+	return;
+}
+
 static int autofs4_dir_open(struct inode *inode, struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
@@ -513,9 +545,7 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 		dentry->d_fsdata = ino;
 		ino->dentry = dentry;
 
-		spin_lock(&sbi->lookup_lock);
-		list_add(&ino->active, &sbi->active_list);
-		spin_unlock(&sbi->lookup_lock);
+		autofs4_add_active(dentry);
 
 		d_instantiate(dentry, NULL);
 	}
@@ -624,10 +654,7 @@ static int autofs4_dir_symlink(struct inode *dir,
 	if (!ino)
 		return -ENOMEM;
 
-	spin_lock(&sbi->lookup_lock);
-	if (!list_empty(&ino->active))
-		list_del_init(&ino->active);
-	spin_unlock(&sbi->lookup_lock);
+	autofs4_del_active(dentry);
 
 	ino->size = strlen(symname);
 	cp = kmalloc(ino->size + 1, GFP_KERNEL);
@@ -775,10 +802,7 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	if (!ino)
 		return -ENOMEM;
 
-	spin_lock(&sbi->lookup_lock);
-	if (!list_empty(&ino->active))
-		list_del_init(&ino->active);
-	spin_unlock(&sbi->lookup_lock);
+	autofs4_del_active(dentry);
 
 	inode = autofs4_get_inode(dir->i_sb, ino);
 	if (!inode) {

