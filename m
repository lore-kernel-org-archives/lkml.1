Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab0BDRWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:22:09 -0500
Received: from kroah.org ([198.145.64.141]:34684 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933136Ab0BDRVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:48 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:03 2010
Message-Id: <20100204171502.712906861@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [25/74] Fix remount races with symlink handling in affs
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 29333920a5a46edcc9b728e2cf0134d5a9b516ee upstream.

A couple of fields in affs_sb_info is used in follow_link() and
symlink() for handling AFFS "absolute" symlinks.  Need locking
against affs_remount() updates.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/affs/affs.h    |    2 +-
 fs/affs/namei.c   |    7 +++++--
 fs/affs/super.c   |   17 ++++++++++++++---
 fs/affs/symlink.c |    7 +++++--
 4 files changed, 25 insertions(+), 8 deletions(-)

--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -106,8 +106,8 @@ struct affs_sb_info {
 	u32 s_last_bmap;
 	struct buffer_head *s_bmap_bh;
 	char *s_prefix;			/* Prefix for volumes and assigns. */
-	int s_prefix_len;		/* Length of prefix. */
 	char s_volume[32];		/* Volume prefix for absolute symlinks. */
+	spinlock_t symlink_lock;	/* protects the previous two */
 };
 
 #define SF_INTL		0x0001		/* International filesystem. */
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -341,10 +341,13 @@ affs_symlink(struct inode *dir, struct d
 	p  = (char *)AFFS_HEAD(bh)->table;
 	lc = '/';
 	if (*symname == '/') {
+		struct affs_sb_info *sbi = AFFS_SB(sb);
 		while (*symname == '/')
 			symname++;
-		while (AFFS_SB(sb)->s_volume[i])	/* Cannot overflow */
-			*p++ = AFFS_SB(sb)->s_volume[i++];
+		spin_lock(&sbi->symlink_lock);
+		while (sbi->s_volume[i])	/* Cannot overflow */
+			*p++ = sbi->s_volume[i++];
+		spin_unlock(&sbi->symlink_lock);
 	}
 	while (i < maxlen && (c = *symname++)) {
 		if (c == '.' && lc == '/' && *symname == '.' && symname[1] == '/') {
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -221,8 +221,6 @@ parse_options(char *options, uid_t *uid,
 			*mount_opts |= SF_MUFS;
 			break;
 		case Opt_prefix:
-			/* Free any previous prefix */
-			kfree(*prefix);
 			*prefix = match_strdup(&args[0]);
 			if (!*prefix)
 				return 0;
@@ -311,6 +309,7 @@ static int affs_fill_super(struct super_
 		return -ENOMEM;
 	sb->s_fs_info = sbi;
 	mutex_init(&sbi->s_bmlock);
+	spin_lock_init(&sbi->symlink_lock);
 
 	if (!parse_options(data,&uid,&gid,&i,&reserved,&root_block,
 				&blocksize,&sbi->s_prefix,
@@ -518,14 +517,18 @@ affs_remount(struct super_block *sb, int
 	unsigned long		 mount_flags;
 	int			 res = 0;
 	char			*new_opts = kstrdup(data, GFP_KERNEL);
+	char			 volume[32];
+	char			*prefix = NULL;
 
 	pr_debug("AFFS: remount(flags=0x%x,opts=\"%s\")\n",*flags,data);
 
 	*flags |= MS_NODIRATIME;
 
+	memcpy(volume, sbi->s_volume, 32);
 	if (!parse_options(data, &uid, &gid, &mode, &reserved, &root_block,
-			   &blocksize, &sbi->s_prefix, sbi->s_volume,
+			   &blocksize, &prefix, volume,
 			   &mount_flags)) {
+		kfree(prefix);
 		kfree(new_opts);
 		return -EINVAL;
 	}
@@ -536,6 +539,14 @@ affs_remount(struct super_block *sb, int
 	sbi->s_mode  = mode;
 	sbi->s_uid   = uid;
 	sbi->s_gid   = gid;
+	/* protect against readers */
+	spin_lock(&sbi->symlink_lock);
+	if (prefix) {
+		kfree(sbi->s_prefix);
+		sbi->s_prefix = prefix;
+	}
+	memcpy(sbi->s_volume, volume, 32);
+	spin_unlock(&sbi->symlink_lock);
 
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
 		unlock_kernel();
--- a/fs/affs/symlink.c
+++ b/fs/affs/symlink.c
@@ -20,7 +20,6 @@ static int affs_symlink_readpage(struct 
 	int			 i, j;
 	char			 c;
 	char			 lc;
-	char			*pf;
 
 	pr_debug("AFFS: follow_link(ino=%lu)\n",inode->i_ino);
 
@@ -32,11 +31,15 @@ static int affs_symlink_readpage(struct 
 	j  = 0;
 	lf = (struct slink_front *)bh->b_data;
 	lc = 0;
-	pf = AFFS_SB(inode->i_sb)->s_prefix ? AFFS_SB(inode->i_sb)->s_prefix : "/";
 
 	if (strchr(lf->symname,':')) {	/* Handle assign or volume name */
+		struct affs_sb_info *sbi = AFFS_SB(inode->i_sb);
+		char *pf;
+		spin_lock(&sbi->symlink_lock);
+		pf = sbi->s_prefix ? sbi->s_prefix : "/";
 		while (i < 1023 && (c = pf[i]))
 			link[i++] = c;
+		spin_unlock(&sbi->symlink_lock);
 		while (i < 1023 && lf->symname[j] != ':')
 			link[i++] = lf->symname[j++];
 		if (i < 1023)


