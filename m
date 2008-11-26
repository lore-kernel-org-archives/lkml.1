Return-Path: <linux-kernel-owner+w=401wt.eu-S1751672AbYLAQlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbYLAQlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYLAQj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:39:56 -0500
Received: from zombie2.ncsc.mil ([144.51.88.133]:56873 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYLAQjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:39:49 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org, "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 08/14] NFSv4: Add label recommended attribute and NFSv4 flags
Date: Wed, 26 Nov 2008 16:03:08 -0500
Message-Id: <1227733394-1114-9-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new recommended attribute named label into the NFSv4 file
attribute structure. It also adds several new flags to allow the NFS client and
server to determine if this attribute is supported and if it is being sent over
the wire.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 include/linux/nfs4.h        |    2 ++
 include/linux/nfs_fs_sb.h   |    2 +-
 include/linux/nfs_xdr.h     |    4 ++++
 include/linux/nfsd/export.h |    5 +++--
 include/linux/nfsd/nfsd.h   |    7 ++++---
 5 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/nfs4.h b/include/linux/nfs4.h
index ea03667..144eacf 100644
--- a/include/linux/nfs4.h
+++ b/include/linux/nfs4.h
@@ -21,6 +21,7 @@
 #define NFS4_FHSIZE		128
 #define NFS4_MAXPATHLEN		PATH_MAX
 #define NFS4_MAXNAMLEN		NAME_MAX
+#define NFS4_MAXLABELLEN	4096
 
 #define NFS4_ACCESS_READ        0x0001
 #define NFS4_ACCESS_LOOKUP      0x0002
@@ -345,6 +346,7 @@ enum lock_type4 {
 #define FATTR4_WORD1_TIME_MODIFY        (1UL << 21)
 #define FATTR4_WORD1_TIME_MODIFY_SET    (1UL << 22)
 #define FATTR4_WORD1_MOUNTED_ON_FILEID  (1UL << 23)
+#define FATTR4_WORD1_SECURITY_LABEL     (1UL << 31)
 
 #define NFSPROC4_NULL 0
 #define NFSPROC4_COMPOUND 1
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 4e477ae..ed42b07 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -134,5 +134,5 @@ struct nfs_server {
 #define NFS_CAP_SYMLINKS	(1U << 2)
 #define NFS_CAP_ACLS		(1U << 3)
 #define NFS_CAP_ATOMIC_OPEN	(1U << 4)
-
+#define NFS_CAP_SECURITY_LABEL (1U << 5)
 #endif
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index c1c31ac..58532cb 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -57,6 +57,10 @@ struct nfs_fattr {
 	__u64			pre_change_attr;/* pre-op NFSv4 change attribute */
 	unsigned long		time_start;
 	unsigned long		gencount;
+#ifdef CONFIG_SECURITY
+	void			*label;
+	__u32			 label_len;
+#endif
 };
 
 #define NFS_ATTR_WCC		0x0001		/* pre-op WCC data    */
diff --git a/include/linux/nfsd/export.h b/include/linux/nfsd/export.h
index 5431512..bb831fc 100644
--- a/include/linux/nfsd/export.h
+++ b/include/linux/nfsd/export.h
@@ -32,7 +32,8 @@
 #define NFSEXP_ALLSQUASH	0x0008
 #define NFSEXP_ASYNC		0x0010
 #define NFSEXP_GATHERED_WRITES	0x0020
-/* 40 80 100 currently unused */
+#define NFSEXP_SECURITY_LABEL	0x0040  /* Support security label fattr4 */
+/* 80 100 currently unused */
 #define NFSEXP_NOHIDE		0x0200
 #define NFSEXP_NOSUBTREECHECK	0x0400
 #define	NFSEXP_NOAUTHNLM	0x0800		/* Don't authenticate NLM requests - just trust */
@@ -40,7 +41,7 @@
 #define NFSEXP_FSID		0x2000
 #define	NFSEXP_CROSSMOUNT	0x4000
 #define	NFSEXP_NOACL		0x8000	/* reserved for possible ACL related use */
-#define NFSEXP_ALLFLAGS		0xFE3F
+#define NFSEXP_ALLFLAGS		0xFE7F
 
 /* The flags that may vary depending on security flavor: */
 #define NFSEXP_SECINFO_FLAGS	(NFSEXP_READONLY | NFSEXP_ROOTSQUASH \
diff --git a/include/linux/nfsd/nfsd.h b/include/linux/nfsd/nfsd.h
index 2126940..8219925 100644
--- a/include/linux/nfsd/nfsd.h
+++ b/include/linux/nfsd/nfsd.h
@@ -318,8 +318,8 @@ extern struct timeval	nfssvc_boot;
  | FATTR4_WORD1_OWNER	        | FATTR4_WORD1_OWNER_GROUP  | FATTR4_WORD1_RAWDEV           \
  | FATTR4_WORD1_SPACE_AVAIL     | FATTR4_WORD1_SPACE_FREE   | FATTR4_WORD1_SPACE_TOTAL      \
  | FATTR4_WORD1_SPACE_USED      | FATTR4_WORD1_TIME_ACCESS  | FATTR4_WORD1_TIME_ACCESS_SET  \
- | FATTR4_WORD1_TIME_DELTA   | FATTR4_WORD1_TIME_METADATA    \
- | FATTR4_WORD1_TIME_MODIFY     | FATTR4_WORD1_TIME_MODIFY_SET | FATTR4_WORD1_MOUNTED_ON_FILEID)
+ | FATTR4_WORD1_TIME_DELTA   	| FATTR4_WORD1_TIME_METADATA | FATTR4_WORD1_TIME_MODIFY     \
+ | FATTR4_WORD1_TIME_MODIFY_SET | FATTR4_WORD1_MOUNTED_ON_FILEID | FATTR4_WORD1_SECURITY_LABEL)
 
 /* These will return ERR_INVAL if specified in GETATTR or READDIR. */
 #define NFSD_WRITEONLY_ATTRS_WORD1							    \
@@ -330,7 +330,8 @@ extern struct timeval	nfssvc_boot;
 (FATTR4_WORD0_SIZE              | FATTR4_WORD0_ACL                                         )
 #define NFSD_WRITEABLE_ATTRS_WORD1                                                          \
 (FATTR4_WORD1_MODE              | FATTR4_WORD1_OWNER         | FATTR4_WORD1_OWNER_GROUP     \
- | FATTR4_WORD1_TIME_ACCESS_SET | FATTR4_WORD1_TIME_MODIFY_SET)
+ | FATTR4_WORD1_TIME_ACCESS_SET | FATTR4_WORD1_TIME_METADATA | FATTR4_WORD1_TIME_MODIFY_SET \
+ | FATTR4_WORD1_SECURITY_LABEL)
 
 #endif /* CONFIG_NFSD_V4 */
 
-- 
1.5.5.1

