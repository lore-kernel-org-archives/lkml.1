Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbZJUT3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbZJUT3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbZJUT3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:29:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbZJUTUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:20:24 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@infradead.org>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 08/41] Don't replace nameidata path when following links
Date: Wed, 21 Oct 2009 12:19:06 -0700
Message-Id: <1256152779-10054-9-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-8-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@infradead.org>

For autofs4 the commit 051d381259eb57d6074d02a6ba6e90e744f1a29f introduced
some code that is replacing the path embedded in the nameidata with the
path of the link itself. This was done to have access to the struct
vfsmount in the autofs4_follow_link function. Instead autofs4 should
remember the struct vfsmount when it is mounted.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/autofs4/autofs_i.h |    1 +
 fs/autofs4/init.c     |   11 ++++++++++-
 fs/autofs4/root.c     |    6 ++++++
 fs/namei.c            |    7 ++-----
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 8f7cdde..db2bfce 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -130,6 +130,7 @@ struct autofs_sb_info {
 	int reghost_enabled;
 	int needs_reghost;
 	struct super_block *sb;
+	struct vfsmount *mnt;
 	struct mutex wq_mutex;
 	spinlock_t fs_lock;
 	struct autofs_wait_queue *queues; /* Wait queue pointer */
diff --git a/fs/autofs4/init.c b/fs/autofs4/init.c
index 9722e4b..5e0dcd7 100644
--- a/fs/autofs4/init.c
+++ b/fs/autofs4/init.c
@@ -17,7 +17,16 @@
 static int autofs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	return get_sb_nodev(fs_type, flags, data, autofs4_fill_super, mnt);
+	struct autofs_sb_info *sbi;
+	int ret;
+
+	ret = get_sb_nodev(fs_type, flags, data, autofs4_fill_super, mnt);
+	if (ret)
+		return ret;
+
+	sbi = autofs4_sbi(mnt->mnt_sb);
+	sbi->mnt = mnt;
+	return 0;
 }
 
 static struct file_system_type autofs_fs_type = {
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index b96a3c5..cb991b8 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -179,6 +179,12 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 	DPRINTK("dentry=%p %.*s oz_mode=%d nd->flags=%d",
 		dentry, dentry->d_name.len, dentry->d_name.name, oz_mode,
 		nd->flags);
+
+	dput(nd->path.dentry);
+	mntput(nd->path.mnt);
+	nd->path.mnt = mntget(sbi->mnt);
+	nd->path.dentry = dget(dentry);
+
 	/*
 	 * For an expire of a covered direct or offset mount we need
 	 * to break out of follow_down() at the autofs mount trigger
diff --git a/fs/namei.c b/fs/namei.c
index a338496..46cf1cb 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -636,11 +636,8 @@ static __always_inline int __do_follow_link(struct path *path, struct nameidata
 	touch_atime(path->mnt, dentry);
 	nd_set_link(nd, NULL);
 
-	if (path->mnt != nd->path.mnt) {
-		path_to_nameidata(path, nd);
-		dget(dentry);
-	}
-	mntget(path->mnt);
+	if (path->mnt == nd->path.mnt)
+		mntget(nd->path.mnt);
 	cookie = dentry->d_inode->i_op->follow_link(dentry, nd);
 	error = PTR_ERR(cookie);
 	if (!IS_ERR(cookie)) {
-- 
1.6.3.3

