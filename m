Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYLAQlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYLAQlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYLAQjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:39:52 -0500
Received: from zombie2.ncsc.mil ([144.51.88.133]:56882 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYLAQjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:39:49 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org, "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 09/14] NFS: Add security_label text mount option and handling code to NFS
Date: Wed, 26 Nov 2008 16:03:09 -0500
Message-Id: <1227733394-1114-10-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
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
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index f48db67..9b89a4b 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -75,6 +75,7 @@ enum {
 	Opt_acl, Opt_noacl,
 	Opt_rdirplus, Opt_nordirplus,
 	Opt_sharecache, Opt_nosharecache,
+	Opt_security_label, Opt_nosecurity_label,
 
 	/* Mount options that take integer arguments */
 	Opt_port,
@@ -129,6 +130,8 @@ static const match_table_t nfs_mount_option_tokens = {
 	{ Opt_nordirplus, "nordirplus" },
 	{ Opt_sharecache, "sharecache" },
 	{ Opt_nosharecache, "nosharecache" },
+	{ Opt_security_label, "security_label" },
+	{ Opt_nosecurity_label, "nosecurity_label" },
 
 	{ Opt_port, "port=%u" },
 	{ Opt_rsize, "rsize=%u" },
@@ -1035,6 +1038,12 @@ static int nfs_parse_mount_options(char *raw,
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
-- 
1.5.5.1

