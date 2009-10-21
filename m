Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZJUTXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZJUTXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbZJUTXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:23:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbZJUTVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:21:39 -0400
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 37/41] union-mount: Check read-only/read-write status of layers
Date: Wed, 21 Oct 2009 12:19:35 -0700
Message-Id: <1256152779-10054-38-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-37-git-send-email-vaurora@redhat.com>
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
 <1256152779-10054-17-git-send-email-vaurora@redhat.com>
 <1256152779-10054-18-git-send-email-vaurora@redhat.com>
 <1256152779-10054-19-git-send-email-vaurora@redhat.com>
 <1256152779-10054-20-git-send-email-vaurora@redhat.com>
 <1256152779-10054-21-git-send-email-vaurora@redhat.com>
 <1256152779-10054-22-git-send-email-vaurora@redhat.com>
 <1256152779-10054-23-git-send-email-vaurora@redhat.com>
 <1256152779-10054-24-git-send-email-vaurora@redhat.com>
 <1256152779-10054-25-git-send-email-vaurora@redhat.com>
 <1256152779-10054-26-git-send-email-vaurora@redhat.com>
 <1256152779-10054-27-git-send-email-vaurora@redhat.com>
 <1256152779-10054-28-git-send-email-vaurora@redhat.com>
 <1256152779-10054-29-git-send-email-vaurora@redhat.com>
 <1256152779-10054-30-git-send-email-vaurora@redhat.com>
 <1256152779-10054-31-git-send-email-vaurora@redhat.com>
 <1256152779-10054-32-git-send-email-vaurora@redhat.com>
 <1256152779-10054-33-git-send-email-vaurora@redhat.com>
 <1256152779-10054-34-git-send-email-vaurora@redhat.com>
 <1256152779-10054-35-git-send-email-vaurora@redhat.com>
 <1256152779-10054-36-git-send-email-vaurora@redhat.com>
 <1256152779-10054-37-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The top layer of a union mount must be writable (in order to support
readdir-triggered copyups) and the bottom layer must be read-only (to
avoid nasty races).

Thanks to Felix Fietkau <nbd@openwrt.org> for a bug fix.

XXX - Add requirement that top layer is mounted only once

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c |   73 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 59 insertions(+), 14 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 505974a..9b71743 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1462,6 +1462,61 @@ static int do_change_type(struct path *path, int flag)
 }
 
 /*
+ * Mount-time check of upper and lower layer file systems to see if we
+ * can union mount one on the other.
+ *
+ * Union mounts must follow these rules:
+ *
+ * - The lower layer must be read-only.  This avoids lots of nasty
+ *   unsolvable races where file system structures disappear suddenly.
+ *   XXX - Checking the vfsmnt for read-only is a temporary hack; the
+ *   file system could be mounted read-write elsewhere.  We need to
+ *   enforce read-only at the superblock level (patches coming).
+ *
+ * - The upper layer must be writable.  This isn't an absolute
+ *   requirement; right now we need it to make readdir() work since we
+ *   copy up directory entries to the top level.  A possible
+ *   workaround is to mount a tmpfs file system transparently over the
+ *   top.
+ *
+ * - The upper layer must support whiteouts and fallthrus (if it is
+ *   writeable).
+ *
+ * - The lower layer must not also be a union mount.  This is just to
+ *   make life simpler for now, there is no inherent limitation on the
+ *   number of layers.
+ *
+ * XXX - Check other mount flags for incompatibilities - I'm sure
+ * there are some.
+ */
+
+static int
+check_union_mnt(struct path *mntpnt, struct vfsmount *top_mnt, int mnt_flags)
+{
+	struct vfsmount *lower_mnt = mntpnt->mnt;
+
+	/* Is this even a union mount? */
+	if (!(mnt_flags & MNT_UNION))
+		return 0;
+
+	/* Lower layer must be read-only and not a union mount */
+	if (!(lower_mnt->mnt_sb->s_flags & MS_RDONLY) ||
+	    (lower_mnt->mnt_flags & MNT_UNION))
+		return -EBUSY;
+
+	/* Upper layer must be writable */
+	if (mnt_flags & MNT_READONLY)
+		return -EROFS;
+
+	/* Upper layer must support whiteouts and fallthrus */
+	if (!(top_mnt->mnt_sb->s_flags & MS_WHITEOUT))
+		return -EINVAL;
+
+	/* All good! */
+	return 0;
+}
+
+/*
  * do loopback mount.
  */
 static int do_loopback(struct path *path, char *old_name, int recurse,
@@ -1495,13 +1550,8 @@ static int do_loopback(struct path *path, char *old_name, int recurse,
 	if (!mnt)
 		goto out;
 
-	/*
-	 * Unions couldn't be writable if the filesystem doesn't know about
-	 * whiteouts
-	 */
-	err = -ENOTSUPP;
-	if ((mnt_flags & MNT_UNION) &&
-	    !(mnt->mnt_sb->s_flags & (MS_WHITEOUT|MS_RDONLY)))
+	err = check_union_mnt(path, mnt, mnt_flags);
+	if (err)
 		goto out;
 
 	if (mnt_flags & MNT_UNION)
@@ -1726,13 +1776,8 @@ int do_add_mount(struct vfsmount *newmnt, struct path *path,
 	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
 		goto unlock;
 
-	/*
-	 * Unions couldn't be writable if the filesystem doesn't know about
-	 * whiteouts
-	 */
-	err = -ENOTSUPP;
-	if ((mnt_flags & MNT_UNION) &&
-	    !(newmnt->mnt_sb->s_flags & (MS_WHITEOUT|MS_RDONLY)))
+	err = check_union_mnt(path, newmnt, mnt_flags);
+	if (err)
 		goto unlock;
 
 	newmnt->mnt_flags = mnt_flags;
-- 
1.6.3.3

