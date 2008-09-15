Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYIOVGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYIOVGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbYIOVG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:06:29 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:64413 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbYIOVG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:06:27 -0400
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 08/14] NFS: Add security_label text mount option and handling code to NFS
Date: Mon, 15 Sep 2008 16:41:12 -0400
Message-Id: <1221511278-28051-9-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two new text options to to the NFS mount options to specify
security labeling. It also sends certain LSM related mount options into the
module for handling.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/nfs/super.c             |    9 +++++++++
 include/linux/nfs4_mount.h |    6 +++++-
 security/selinux/hooks.c   |    2 +-
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 9abcd2b..256ce27 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -75,6 +75,7 @@ enum {
 	Opt_acl, Opt_noacl,
 	Opt_rdirplus, Opt_nordirplus,
 	Opt_sharecache, Opt_nosharecache,
+	Opt_security_label, Opt_nosecurity_label,
 
 	/* Mount options that take integer arguments */
 	Opt_port,
@@ -128,6 +129,8 @@ static match_table_t nfs_mount_option_tokens = {
 	{ Opt_nordirplus, "nordirplus" },
 	{ Opt_sharecache, "sharecache" },
 	{ Opt_nosharecache, "nosharecache" },
+	{ Opt_security_label, "security_label" },
+	{ Opt_nosecurity_label, "nosecurity_label" },
 
 	{ Opt_port, "port=%u" },
 	{ Opt_rsize, "rsize=%u" },
@@ -1033,6 +1036,12 @@ static int nfs_parse_mount_options(char *raw,
 		case Opt_nosharecache:
 			mnt->flags |= NFS_MOUNT_UNSHARED;
 			break;
+		case Opt_nosecurity_label:
+			mnt->flags &= ~NFS4_MOUNT_SECURITY_LABEL;
+			break;
+		case Opt_security_label:
+			mnt->flags |= NFS4_MOUNT_SECURITY_LABEL;
+			break;
 
 		/*
 		 * options that take numeric values
diff --git a/include/linux/nfs4_mount.h b/include/linux/nfs4_mount.h
index a0dcf66..e65067b 100644
--- a/include/linux/nfs4_mount.h
+++ b/include/linux/nfs4_mount.h
@@ -17,6 +17,7 @@
  * but here they are anyway.
  */
 #define NFS4_MOUNT_VERSION	1
+#define NFS4_MAX_CONTEXT_LEN	4096
 
 struct nfs_string {
 	unsigned int len;
@@ -53,6 +54,8 @@ struct nfs4_mount_data {
 	/* Pseudo-flavours to use for authentication. See RFC2623 */
 	int auth_flavourlen;			/* 1 */
 	int __user *auth_flavours;		/* 1 */
+
+	char context[NFS4_MAX_CONTEXT_LEN + 1];  /* 2 */
 };
 
 /* bits in the flags field */
@@ -66,6 +69,7 @@ struct nfs4_mount_data {
 #define NFS4_MOUNT_NOAC		0x0020	/* 1 */
 #define NFS4_MOUNT_STRICTLOCK	0x1000	/* 1 */
 #define NFS4_MOUNT_UNSHARED	0x8000	/* 1 */
-#define NFS4_MOUNT_FLAGMASK	0x9033
+#define NFS4_MOUNT_SECURITY_LABEL 0x10000 /* 2 */
+#define NFS4_MOUNT_FLAGMASK	0x19033
 
 #endif
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 78e79d3..6919766 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -612,7 +612,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 	for (i = 0; i < num_opts; i++) {
 		u32 sid;
 		if (flags[i] == NATIVE_LABELS_MNT) {
-			sbsec->flags | = NATIVE_LABELS_MNT;
+			sbsec->flags |= NATIVE_LABELS_MNT;
 			continue;
 		}
 		rc = security_context_to_sid(mount_options[i],
-- 
1.5.5.1

