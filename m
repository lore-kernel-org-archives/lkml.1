Return-Path: <linux-kernel-owner+w=401wt.eu-S932472AbZJUT0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbZJUT0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932364AbZJUT0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:26:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239AbZJUTVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:21:03 -0400
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
       Jan Blunck <jblunck@suse.de>, Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 19/41] union-mount: Introduce MNT_UNION and MS_UNION flags
Date: Wed, 21 Oct 2009 12:19:17 -0700
Message-Id: <1256152779-10054-20-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-19-git-send-email-vaurora@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Add per mountpoint flag for Union Mount support. You need additional patches
to util-linux for that to work - see:

git://git.kernel.org/pub/scm/utils/util-linux-ng/val/util-linux-ng.git

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c        |    5 ++++-
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 4cd43ea..81b3188 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -770,6 +770,7 @@ static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
 		{ MNT_STRICTATIME, ",strictatime" },
+		{ MNT_UNION, ",union" },
 		{ 0, NULL }
 	};
 	const struct proc_fs_info *fs_infop;
@@ -1925,10 +1926,12 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 		mnt_flags &= ~(MNT_RELATIME | MNT_NOATIME);
 	if (flags & MS_RDONLY)
 		mnt_flags |= MNT_READONLY;
+	if (flags & MS_UNION)
+		mnt_flags |= MNT_UNION;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
-		   MS_STRICTATIME);
+		   MS_STRICTATIME | MS_UNION);
 
 	/* ... and get the mountpoint */
 	retval = kern_path(dir_name, LOOKUP_FOLLOW, &path);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d13de8a..efea78c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -188,6 +188,7 @@ struct inodes_stat_t {
 #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
 #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
 #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
+#define MS_UNION	256
 #define MS_NOATIME	1024	/* Do not update access times. */
 #define MS_NODIRATIME	2048	/* Do not update directory access times */
 #define MS_BIND		4096
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 5d52753..e175c47 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -35,6 +35,7 @@ struct mnt_namespace;
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
 #define MNT_PNODE_MASK	0x3000	/* propagation flag mask */
+#define MNT_UNION	0x4000	/* if the vfsmount is a union mount */
 
 struct vfsmount {
 	struct list_head mnt_hash;
-- 
1.6.3.3

