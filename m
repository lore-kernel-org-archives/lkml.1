Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbZJUTUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbZJUTUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZJUTUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:20:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbZJUTUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:20:41 -0400
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
       Felix Fietkau <nbd@openwrt.org>, David Woodhouse <dwmw2@infradead.org>,
       linux-mtd@lists.infradead.org
Subject: [PATCH 16/41] whiteout: jffs2 whiteout support
Date: Wed, 21 Oct 2009 12:19:14 -0700
Message-Id: <1256152779-10054-17-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-16-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

Add support for whiteout dentries to jffs2.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 fs/jffs2/dir.c        |   77 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/jffs2/fs.c         |    4 ++
 fs/jffs2/super.c      |    2 +-
 include/linux/jffs2.h |    2 +
 4 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 6f60cc9..46a2e1b 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -34,6 +34,8 @@ static int jffs2_mknod (struct inode *,struct dentry *,int,dev_t);
 static int jffs2_rename (struct inode *, struct dentry *,
 			 struct inode *, struct dentry *);
 
+static int jffs2_whiteout (struct inode *, struct dentry *, struct dentry *);
+
 const struct file_operations jffs2_dir_operations =
 {
 	.read =		generic_read_dir,
@@ -55,6 +57,7 @@ const struct inode_operations jffs2_dir_inode_operations =
 	.rmdir =	jffs2_rmdir,
 	.mknod =	jffs2_mknod,
 	.rename =	jffs2_rename,
+	.whiteout =     jffs2_whiteout,
 	.permission =	jffs2_permission,
 	.setattr =	jffs2_setattr,
 	.setxattr =	jffs2_setxattr,
@@ -98,8 +101,18 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
 			fd = fd_list;
 		}
 	}
-	if (fd)
-		ino = fd->ino;
+	if (fd) {
+		spin_lock(&target->d_lock);
+		switch(fd->type) {
+		case DT_WHT:
+			target->d_flags |= DCACHE_WHITEOUT;
+			break;
+		default:
+			ino = fd->ino;
+			break;
+		}
+		spin_unlock(&target->d_lock);
+	}
 	mutex_unlock(&dir_f->sem);
 	if (ino) {
 		inode = jffs2_iget(dir_i->i_sb, ino);
@@ -498,6 +511,11 @@ static int jffs2_mkdir (struct inode *dir_i, struct dentry *dentry, int mode)
 		return PTR_ERR(inode);
 	}
 
+	if (dentry->d_flags & DCACHE_WHITEOUT) {
+		inode->i_flags |= S_OPAQUE;
+		ri->flags = cpu_to_je16(JFFS2_INO_FLAG_OPAQUE);
+	}
+
 	inode->i_op = &jffs2_dir_inode_operations;
 	inode->i_fop = &jffs2_dir_operations;
 
@@ -779,6 +797,61 @@ static int jffs2_mknod (struct inode *dir_i, struct dentry *dentry, int mode, de
 	return 0;
 }
 
+static int jffs2_whiteout (struct inode *dir, struct dentry *old_dentry,
+			   struct dentry *new_dentry)
+{
+	struct jffs2_sb_info *c = JFFS2_SB_INFO(dir->i_sb);
+	struct jffs2_inode_info *victim_f = NULL;
+	uint32_t now;
+	int ret;
+
+	/* If it's a directory, then check whether it is really empty
+	 */
+	if (new_dentry->d_inode) {
+		victim_f = JFFS2_INODE_INFO(old_dentry->d_inode);
+		if (S_ISDIR(old_dentry->d_inode->i_mode)) {
+			struct jffs2_full_dirent *fd;
+
+			mutex_lock(&victim_f->sem);
+			for (fd = victim_f->dents; fd; fd = fd->next) {
+				if (fd->ino) {
+					mutex_unlock(&victim_f->sem);
+					return -ENOTEMPTY;
+				}
+			}
+			mutex_unlock(&victim_f->sem);
+		}
+	}
+
+	now = get_seconds();
+	ret = jffs2_do_link(c, JFFS2_INODE_INFO(dir), 0, DT_WHT,
+			    new_dentry->d_name.name, new_dentry->d_name.len, now);
+	if (ret)
+		return ret;
+
+	spin_lock(&new_dentry->d_lock);
+	new_dentry->d_flags |= DCACHE_WHITEOUT;
+	spin_unlock(&new_dentry->d_lock);
+	d_add(new_dentry, NULL);
+
+	if (victim_f) {
+		/* There was a victim. Kill it off nicely */
+		drop_nlink(old_dentry->d_inode);
+		/* Don't oops if the victim was a dirent pointing to an
+		   inode which didn't exist. */
+		if (victim_f->inocache) {
+			mutex_lock(&victim_f->sem);
+			if (S_ISDIR(old_dentry->d_inode->i_mode))
+				victim_f->inocache->pino_nlink = 0;
+			else
+				victim_f->inocache->pino_nlink--;
+			mutex_unlock(&victim_f->sem);
+		}
+	}
+
+	return 0;
+}
+
 static int jffs2_rename (struct inode *old_dir_i, struct dentry *old_dentry,
 			 struct inode *new_dir_i, struct dentry *new_dentry)
 {
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 3451a81..c1e333c 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -301,6 +301,10 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 
 		inode->i_op = &jffs2_dir_inode_operations;
 		inode->i_fop = &jffs2_dir_operations;
+
+		if (je16_to_cpu(latest_node.flags) & JFFS2_INO_FLAG_OPAQUE)
+			inode->i_flags |= S_OPAQUE;
+
 		break;
 	}
 	case S_IFREG:
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 0035c02..6607f0b 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -172,7 +172,7 @@ static int jffs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_op = &jffs2_super_operations;
 	sb->s_export_op = &jffs2_export_ops;
-	sb->s_flags = sb->s_flags | MS_NOATIME;
+	sb->s_flags = sb->s_flags | MS_NOATIME | MS_WHITEOUT;
 	sb->s_xattr = jffs2_xattr_handlers;
 #ifdef CONFIG_JFFS2_FS_POSIX_ACL
 	sb->s_flags |= MS_POSIXACL;
diff --git a/include/linux/jffs2.h b/include/linux/jffs2.h
index 2b32d63..65533bb 100644
--- a/include/linux/jffs2.h
+++ b/include/linux/jffs2.h
@@ -87,6 +87,8 @@
 #define JFFS2_INO_FLAG_USERCOMPR  2	/* User has requested a specific
 					   compression type */
 
+#define JFFS2_INO_FLAG_OPAQUE     4	/* Directory is opaque (for union mounts) */
+
 
 /* These can go once we've made sure we've caught all uses without
    byteswapping */
-- 
1.6.3.3

