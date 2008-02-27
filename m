Return-Path: <linux-kernel-owner+w=401wt.eu-S1762383AbYB0XV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762383AbYB0XV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763293AbYB0XVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:21:13 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:51010 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761036AbYB0XVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:21:11 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>
Subject: [PATCH 07/11] NFS/SELinux: Add security_label text mount option to nfs and add handling code to the security server.
Date: Wed, 27 Feb 2008 15:39:42 -0500
Message-Id: <1204144786-3502-8-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new method for pulling argument for NFS from mount is through a text
parsing system. This patch adds two new entries to the argument parsing code
"securlty_label" and "nosecurity_label". Even though we use text across the
user/kernel boundary internally we still pack a binary structure for mount info
to be passed around. We add a flag for use in the nfs{4,}_mount_data struct to
indicate that are using security labels. Finally we add the SELinux support to
mark the labeling method as native.

Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/nfs/super.c             |   10 +++++++++-
 fs/nfsd/export.c           |    3 +++
 include/linux/nfs4_mount.h |    3 ++-
 include/linux/nfs_mount.h  |    3 ++-
 security/selinux/hooks.c   |   13 ++++++++++++-
 5 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 1fb3818..f3e327e 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -75,6 +75,7 @@ enum {
 	Opt_acl, Opt_noacl,
 	Opt_rdirplus, Opt_nordirplus,
 	Opt_sharecache, Opt_nosharecache,
+	Opt_seclabel, Opt_noseclabel,
 
 	/* Mount options that take integer arguments */
 	Opt_port,
@@ -124,6 +125,8 @@ static match_table_t nfs_mount_option_tokens = {
 	{ Opt_nordirplus, "nordirplus" },
 	{ Opt_sharecache, "sharecache" },
 	{ Opt_nosharecache, "nosharecache" },
+	{ Opt_seclabel, "security_label" },
+	{ Opt_noseclabel, "nosecurity_label" },
 
 	{ Opt_port, "port=%u" },
 	{ Opt_rsize, "rsize=%u" },
@@ -779,7 +782,12 @@ static int nfs_parse_mount_options(char *raw,
 		case Opt_nosharecache:
 			mnt->flags |= NFS_MOUNT_UNSHARED;
 			break;
-
+		case Opt_seclabel:
+			mnt->flags |= NFS_MOUNT_SECURITY_LABEL;
+			break;
+		case Opt_noseclabel:
+			mnt->flags &= ~NFS_MOUNT_SECURITY_LABEL;
+			break;
 		case Opt_port:
 			if (match_int(args, &option))
 				return 0;
diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 8a6f7c9..d32ae56 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1435,6 +1435,9 @@ static struct flags {
 	{ NFSEXP_ALLSQUASH, {"all_squash", ""}},
 	{ NFSEXP_ASYNC, {"async", "sync"}},
 	{ NFSEXP_GATHERED_WRITES, {"wdelay", "no_wdelay"}},
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	{ NFSEXP_SECURITY_LABEL, {"security_label", ""}},
+#endif
 	{ NFSEXP_NOHIDE, {"nohide", ""}},
 	{ NFSEXP_CROSSMOUNT, {"crossmnt", ""}},
 	{ NFSEXP_NOSUBTREECHECK, {"no_subtree_check", ""}},
diff --git a/include/linux/nfs4_mount.h b/include/linux/nfs4_mount.h
index a0dcf66..d7abc3b 100644
--- a/include/linux/nfs4_mount.h
+++ b/include/linux/nfs4_mount.h
@@ -66,6 +66,7 @@ struct nfs4_mount_data {
 #define NFS4_MOUNT_NOAC		0x0020	/* 1 */
 #define NFS4_MOUNT_STRICTLOCK	0x1000	/* 1 */
 #define NFS4_MOUNT_UNSHARED	0x8000	/* 1 */
-#define NFS4_MOUNT_FLAGMASK	0x9033
+#define NFS4_MOUNT_SECURITY_LABEL 0x10000 /* Text Only */
+#define NFS4_MOUNT_FLAGMASK	0x19033
 
 #endif
diff --git a/include/linux/nfs_mount.h b/include/linux/nfs_mount.h
index df7c6b7..1ca5260 100644
--- a/include/linux/nfs_mount.h
+++ b/include/linux/nfs_mount.h
@@ -63,6 +63,7 @@ struct nfs_mount_data {
 #define NFS_MOUNT_SECFLAVOUR	0x2000	/* 5 */
 #define NFS_MOUNT_NORDIRPLUS	0x4000	/* 5 */
 #define NFS_MOUNT_UNSHARED	0x8000	/* 5 */
-#define NFS_MOUNT_FLAGMASK	0xFFFF
+#define NFS_MOUNT_SECURITY_LABEL 0x10000 /* reserved for NFSv4 */
+#define NFS_MOUNT_FLAGMASK	0x1FFFF
 
 #endif
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ebe4e18..e3ed7c3 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -68,6 +68,7 @@
 #include <net/af_unix.h>	/* for Unix socket types */
 #include <linux/parser.h>
 #include <linux/nfs_mount.h>
+#include <linux/nfs4_mount.h>
 #include <net/ipv6.h>
 #include <linux/hugetlb.h>
 #include <linux/personality.h>
@@ -807,6 +808,7 @@ static int superblock_doinit(struct super_block *sb, void *data)
 	/* selinux only know about a fixed number of mount options */
 	char *mnt_opts[NUM_SEL_MNT_OPTS];
 	int mnt_opts_flags[NUM_SEL_MNT_OPTS], num_mnt_opts = 0;
+	struct superblock_security_struct *sbsec = sb->s_security;
 
 	if (!data)
 		goto out;
@@ -829,6 +831,15 @@ static int superblock_doinit(struct super_block *sb, void *data)
 				}
 			}
 			goto build_flags;
+		} else if (!strcmp(name, "nfs4")) {
+			struct nfs4_mount_data *d = data;
+
+			if (d->version !=  NFS4_MOUNT_VERSION)
+				goto out;
+
+			if (d->flags & NFS4_MOUNT_SECURITY_LABEL)
+				sbsec->behavior = SECURITY_FS_USE_NATIVE;
+			goto build_flags;
 		} else
 			goto out;
 	}
@@ -898,7 +909,7 @@ static int superblock_doinit(struct super_block *sb, void *data)
 
 		default:
 			rc = -EINVAL;
-			printk(KERN_WARNING "SELinux:  unknown mount option\n");
+			printk(KERN_WARNING "SELinux:  unknown mount option \"%s\"\n", p);
 			goto out_err;
 
 		}
-- 
1.5.3.8

