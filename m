Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbYCTBP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbYCTBP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 21:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757469AbYCTBOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 21:14:22 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1527 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbYCTBOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 21:14:15 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Steve French <sfrench@samba.org>, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org
Subject: [PATCH 1/4] fs/cifs - Pass cifs_sb->mnt_cifs_flags instead of cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR
Date: Wed, 19 Mar 2008 18:11:12 -0700
Message-Id: <1205975475-12708-1-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/cifs/cifs_dfs_ref.c |    4 +-
 fs/cifs/cifsacl.c      |   10 ++--
 fs/cifs/cifsproto.h    |   71 +++++++++++----------------
 fs/cifs/cifssmb.c      |  124 +++++++++++++++++++++++++----------------------
 fs/cifs/connect.c      |   11 ++--
 fs/cifs/dir.c          |   60 +++++++++++------------
 fs/cifs/fcntl.c        |    7 ++-
 fs/cifs/file.c         |   18 +++----
 fs/cifs/inode.c        |  124 +++++++++++++++++++-----------------------------
 fs/cifs/link.c         |   16 ++----
 fs/cifs/misc.c         |    4 +-
 fs/cifs/readdir.c      |    5 +-
 fs/cifs/xattr.c        |   56 ++++++++++-----------
 13 files changed, 233 insertions(+), 277 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 7f88382..453b1de 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -325,8 +325,8 @@ cifs_dfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 	}
 
 	rc = get_dfs_path(xid, ses , full_path, cifs_sb->local_nls,
-		&num_referrals, &referrals,
-		cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			  &num_referrals, &referrals,
+			  cifs_sb->mnt_cifs_flags);
 
 	for (i = 0; i < num_referrals; i++) {
 		dump_referral(referrals+i);
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index f93932c..4fb75af 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -588,9 +588,8 @@ static struct cifs_ntsd *get_cifs_acl(u32 *pacllen, struct inode *inode,
 		int oplock = FALSE;
 		/* open file */
 		rc = CIFSSMBOpen(xid, cifs_sb->tcon, path, FILE_OPEN,
-				READ_CONTROL, 0, &fid, &oplock, NULL,
-				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+				 READ_CONTROL, 0, &fid, &oplock, NULL,
+				 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags);
 		if (rc != 0) {
 			cERROR(1, ("Unable to open file to get ACL"));
 			FreeXid(xid);
@@ -641,9 +640,8 @@ static int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 		int oplock = FALSE;
 		/* open file */
 		rc = CIFSSMBOpen(xid, cifs_sb->tcon, path, FILE_OPEN,
-				WRITE_DAC, 0, &fid, &oplock, NULL,
-				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+				 WRITE_DAC, 0, &fid, &oplock, NULL,
+				 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags);
 		if (rc != 0) {
 			cERROR(1, ("Unable to open file to set ACL"));
 			FreeXid(xid);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 0af63e6..eaec2fd 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -123,7 +123,7 @@ extern int CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
 extern int CIFSFindFirst(const int xid, struct cifsTconInfo *tcon,
 		const char *searchName, const struct nls_table *nls_codepage,
 		__u16 *searchHandle, struct cifs_search_info *psrch_inf,
-		int map, const char dirsep);
+		int cifs_flags, const char dirsep);
 
 extern int CIFSFindNext(const int xid, struct cifsTconInfo *tcon,
 		__u16 searchHandle, struct cifs_search_info *psrch_inf);
@@ -135,33 +135,32 @@ extern int CIFSSMBQPathInfo(const int xid, struct cifsTconInfo *tcon,
 			const unsigned char *searchName,
 			FILE_ALL_INFO * findData,
 			int legacy /* whether to use old info level */,
-			const struct nls_table *nls_codepage, int remap);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int SMBQueryInformation(const int xid, struct cifsTconInfo *tcon,
 			const unsigned char *searchName,
 			FILE_ALL_INFO *findData,
-			const struct nls_table *nls_codepage, int remap);
+			const struct nls_table *nls_codepage, int cifs_flags);
 
 extern int CIFSSMBUnixQPathInfo(const int xid,
 			struct cifsTconInfo *tcon,
 			const unsigned char *searchName,
 			FILE_UNIX_BASIC_INFO * pFindData,
-			const struct nls_table *nls_codepage, int remap);
+			const struct nls_table *nls_codepage, int cifs_flags);
 
 extern int CIFSGetDFSRefer(const int xid, struct cifsSesInfo *ses,
 			const unsigned char *searchName,
 			unsigned char **targetUNCs,
 			unsigned int *number_of_UNC_in_array,
-			const struct nls_table *nls_codepage, int remap);
+			const struct nls_table *nls_codepage, int cifs_flags);
 
 extern int connect_to_dfs_path(int xid, struct cifsSesInfo *pSesInfo,
 			const char *old_path,
-			const struct nls_table *nls_codepage, int remap);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int get_dfs_path(int xid, struct cifsSesInfo *pSesInfo,
 			const char *old_path,
 			const struct nls_table *nls_codepage,
 			unsigned int *pnum_referrals,
-			struct dfs_info3_param **preferrals,
-			int remap);
+			struct dfs_info3_param **preferrals, int cifs_flags);
 extern void reset_cifs_unix_caps(int xid, struct cifsTconInfo *tcon,
 				 struct super_block *sb, struct smb_vol *vol);
 extern int CIFSSMBQFSInfo(const int xid, struct cifsTconInfo *tcon,
@@ -180,8 +179,7 @@ extern int CIFSSMBQFSPosixInfo(const int xid, struct cifsTconInfo *tcon,
 
 extern int CIFSSMBSetTimes(const int xid, struct cifsTconInfo *tcon,
 			const char *fileName, const FILE_BASIC_INFO *data,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSSMBSetFileTimes(const int xid, struct cifsTconInfo *tcon,
 			const FILE_BASIC_INFO *data, __u16 fid);
 #if 0
@@ -192,50 +190,41 @@ extern int CIFSSMBSetAttrLegacy(int xid, struct cifsTconInfo *tcon,
 extern int CIFSSMBSetEOF(const int xid, struct cifsTconInfo *tcon,
 			const char *fileName, __u64 size,
 			int setAllocationSizeFlag,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon,
 			 __u64 size, __u16 fileHandle, __u32 opener_pid,
 			int AllocSizeFlag);
 extern int CIFSSMBUnixSetPerms(const int xid, struct cifsTconInfo *pTcon,
 			char *full_path, __u64 mode, __u64 uid,
 			__u64 gid, dev_t dev,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			const struct nls_table *nls_codepage, int cifs_flags);
 
 extern int CIFSSMBMkDir(const int xid, struct cifsTconInfo *tcon,
 			const char *newName,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSSMBRmDir(const int xid, struct cifsTconInfo *tcon,
 			const char *name, const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			int cifs_flags);
 extern int CIFSPOSIXDelFile(const int xid, struct cifsTconInfo *tcon,
 			const char *name, __u16 type,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSSMBDelFile(const int xid, struct cifsTconInfo *tcon,
 			const char *name,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSSMBRename(const int xid, struct cifsTconInfo *tcon,
 			const char *fromName, const char *toName,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSSMBRenameOpenFile(const int xid, struct cifsTconInfo *pTcon,
 			int netfid, char *target_name,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSCreateHardLink(const int xid,
 			struct cifsTconInfo *tcon,
 			const char *fromName, const char *toName,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSUnixCreateHardLink(const int xid,
 			struct cifsTconInfo *tcon,
 			const char *fromName, const char *toName,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSUnixCreateSymLink(const int xid,
 			struct cifsTconInfo *tcon,
 			const char *fromName, const char *toName,
@@ -255,17 +244,17 @@ extern int CIFSSMBOpen(const int xid, struct cifsTconInfo *tcon,
 			const char *fileName, const int disposition,
 			const int access_flags, const int omode,
 			__u16 *netfid, int *pOplock, FILE_ALL_INFO *,
-			const struct nls_table *nls_codepage, int remap);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int SMBLegacyOpen(const int xid, struct cifsTconInfo *tcon,
 			const char *fileName, const int disposition,
 			const int access_flags, const int omode,
 			__u16 *netfid, int *pOplock, FILE_ALL_INFO *,
-			const struct nls_table *nls_codepage, int remap);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSPOSIXCreate(const int xid, struct cifsTconInfo *tcon,
 			u32 posix_flags, __u64 mode, __u16 *netfid,
 			FILE_UNIX_BASIC_INFO *pRetData,
 			__u32 *pOplock, const char *name,
-			const struct nls_table *nls_codepage, int remap);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSSMBClose(const int xid, struct cifsTconInfo *tcon,
 			const int smb_file_id);
 
@@ -284,12 +273,11 @@ extern int CIFSSMBWrite2(const int xid, struct cifsTconInfo *tcon,
 			struct kvec *iov, const int nvec, const int long_op);
 extern int CIFSGetSrvInodeNumber(const int xid, struct cifsTconInfo *tcon,
 			const unsigned char *searchName, __u64 *inode_number,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int cifs_convertUCSpath(char *target, const __le16 *source, int maxlen,
 			const struct nls_table *codepage);
 extern int cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
-			const struct nls_table *cp, int mapChars);
+			const struct nls_table *cp, int cifs_flags);
 
 extern int CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 			const __u16 netfid, const __u64 len,
@@ -329,8 +317,7 @@ extern int CIFSSMBCopy(int xid,
 			const char *fromName,
 			const __u16 target_tid,
 			const char *toName, const int flags,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSSMBNotify(const int xid, struct cifsTconInfo *tcon,
 			const int notify_subdirs, const __u16 netfid,
 			__u32 filter, struct file *file, int multishot,
@@ -338,15 +325,15 @@ extern int CIFSSMBNotify(const int xid, struct cifsTconInfo *tcon,
 extern ssize_t CIFSSMBQAllEAs(const int xid, struct cifsTconInfo *tcon,
 			const unsigned char *searchName, char *EAData,
 			size_t bufsize, const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			int cifs_flags);
 extern ssize_t CIFSSMBQueryEA(const int xid, struct cifsTconInfo *tcon,
 		const unsigned char *searchName, const unsigned char *ea_name,
 		unsigned char *ea_value, size_t buf_size,
-		const struct nls_table *nls_codepage, int remap_special_chars);
+		const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSSMBSetEA(const int xid, struct cifsTconInfo *tcon,
 		const char *fileName, const char *ea_name,
 		const void *ea_value, const __u16 ea_value_len,
-		const struct nls_table *nls_codepage, int remap_special_chars);
+		const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon,
 			__u16 fid, struct cifs_ntsd **acl_inf, __u32 *buflen);
 extern int CIFSSMBSetCIFSACL(const int, struct cifsTconInfo *, __u16,
@@ -354,11 +341,11 @@ extern int CIFSSMBSetCIFSACL(const int, struct cifsTconInfo *, __u16,
 extern int CIFSSMBGetPosixACL(const int xid, struct cifsTconInfo *tcon,
 		const unsigned char *searchName,
 		char *acl_inf, const int buflen, const int acl_type,
-		const struct nls_table *nls_codepage, int remap_special_chars);
+		const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSSMBSetPosixACL(const int xid, struct cifsTconInfo *tcon,
 		const unsigned char *fileName,
 		const char *local_acl, const int buflen, const int acl_type,
-		const struct nls_table *nls_codepage, int remap_special_chars);
+		const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSGetExtAttr(const int xid, struct cifsTconInfo *tcon,
 			const int netfid, __u64 *pExtAttrBits, __u64 *pMask);
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 30bbe44..222387c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -809,7 +809,8 @@ CIFSSMBLogoff(const int xid, struct cifsSesInfo *ses)
 
 int
 CIFSPOSIXDelFile(const int xid, struct cifsTconInfo *tcon, const char *fileName,
-		 __u16 type, const struct nls_table *nls_codepage, int remap)
+		 __u16 type, const struct nls_table *nls_codepage,
+		 int cifs_flags)
 {
 	TRANSACTION2_SPI_REQ *pSMB = NULL;
 	TRANSACTION2_SPI_RSP *pSMBr = NULL;
@@ -829,7 +830,7 @@ PsxDelete:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUCS((__le16 *) pSMB->FileName, fileName,
-				     PATH_MAX, nls_codepage, remap);
+				     PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else { /* BB add path length overrun check */
@@ -884,7 +885,7 @@ PsxDelete:
 
 int
 CIFSSMBDelFile(const int xid, struct cifsTconInfo *tcon, const char *fileName,
-	       const struct nls_table *nls_codepage, int remap)
+	       const struct nls_table *nls_codepage, int cifs_flags)
 {
 	DELETE_FILE_REQ *pSMB = NULL;
 	DELETE_FILE_RSP *pSMBr = NULL;
@@ -901,7 +902,7 @@ DelFileRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUCS((__le16 *) pSMB->fileName, fileName,
-				     PATH_MAX, nls_codepage, remap);
+				     PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {		/* BB improve check for buffer overruns BB */
@@ -929,7 +930,7 @@ DelFileRetry:
 
 int
 CIFSSMBRmDir(const int xid, struct cifsTconInfo *tcon, const char *dirName,
-	     const struct nls_table *nls_codepage, int remap)
+	     const struct nls_table *nls_codepage, int cifs_flags)
 {
 	DELETE_DIRECTORY_REQ *pSMB = NULL;
 	DELETE_DIRECTORY_RSP *pSMBr = NULL;
@@ -946,7 +947,7 @@ RmDirRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len = cifsConvertToUCS((__le16 *) pSMB->DirName, dirName,
-					 PATH_MAX, nls_codepage, remap);
+					 PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {		/* BB improve check for buffer overruns BB */
@@ -972,7 +973,8 @@ RmDirRetry:
 
 int
 CIFSSMBMkDir(const int xid, struct cifsTconInfo *tcon,
-	     const char *name, const struct nls_table *nls_codepage, int remap)
+	     const char *name, const struct nls_table *nls_codepage,
+	     int cifs_flags)
 {
 	int rc = 0;
 	CREATE_DIRECTORY_REQ *pSMB = NULL;
@@ -989,7 +991,7 @@ MkDirRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len = cifsConvertToUCS((__le16 *) pSMB->DirName, name,
-					    PATH_MAX, nls_codepage, remap);
+					    PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {		/* BB improve check for buffer overruns BB */
@@ -1017,7 +1019,7 @@ int
 CIFSPOSIXCreate(const int xid, struct cifsTconInfo *tcon, __u32 posix_flags,
 		__u64 mode, __u16 *netfid, FILE_UNIX_BASIC_INFO *pRetData,
 		__u32 *pOplock, const char *name,
-		const struct nls_table *nls_codepage, int remap)
+		const struct nls_table *nls_codepage, int cifs_flags)
 {
 	TRANSACTION2_SPI_REQ *pSMB = NULL;
 	TRANSACTION2_SPI_RSP *pSMBr = NULL;
@@ -1038,7 +1040,7 @@ PsxCreat:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUCS((__le16 *) pSMB->FileName, name,
-				     PATH_MAX, nls_codepage, remap);
+				     PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -1167,7 +1169,7 @@ SMBLegacyOpen(const int xid, struct cifsTconInfo *tcon,
 	    const char *fileName, const int openDisposition,
 	    const int access_flags, const int create_options, __u16 *netfid,
 	    int *pOplock, FILE_ALL_INFO *pfile_info,
-	    const struct nls_table *nls_codepage, int remap)
+	    const struct nls_table *nls_codepage, int cifs_flags)
 {
 	int rc = -EACCES;
 	OPENX_REQ *pSMB = NULL;
@@ -1188,7 +1190,8 @@ OldOpenRetry:
 		count = 1;      /* account for one byte pad to word boundary */
 		name_len =
 		   cifsConvertToUCS((__le16 *) (pSMB->fileName + 1),
-				    fileName, PATH_MAX, nls_codepage, remap);
+				    fileName, PATH_MAX,
+				    nls_codepage, cifs_flags);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 	} else {                /* BB improve check for buffer overruns BB */
@@ -1282,7 +1285,7 @@ CIFSSMBOpen(const int xid, struct cifsTconInfo *tcon,
 	    const char *fileName, const int openDisposition,
 	    const int access_flags, const int create_options, __u16 *netfid,
 	    int *pOplock, FILE_ALL_INFO *pfile_info,
-	    const struct nls_table *nls_codepage, int remap)
+	    const struct nls_table *nls_codepage, int cifs_flags)
 {
 	int rc = -EACCES;
 	OPEN_REQ *pSMB = NULL;
@@ -1303,7 +1306,8 @@ openRetry:
 		count = 1;	/* account for one byte pad to word boundary */
 		name_len =
 		    cifsConvertToUCS((__le16 *) (pSMB->fileName + 1),
-				     fileName, PATH_MAX, nls_codepage, remap);
+				     fileName, PATH_MAX,
+				     nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 		pSMB->NameLength = cpu_to_le16(name_len);
@@ -1913,7 +1917,7 @@ CIFSSMBClose(const int xid, struct cifsTconInfo *tcon, int smb_file_id)
 int
 CIFSSMBRename(const int xid, struct cifsTconInfo *tcon,
 	      const char *fromName, const char *toName,
-	      const struct nls_table *nls_codepage, int remap)
+	      const struct nls_table *nls_codepage, int cifs_flags)
 {
 	int rc = 0;
 	RENAME_REQ *pSMB = NULL;
@@ -1937,7 +1941,7 @@ renameRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUCS((__le16 *) pSMB->OldFileName, fromName,
-				     PATH_MAX, nls_codepage, remap);
+				     PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 		pSMB->OldFileName[name_len] = 0x04;	/* pad */
@@ -1945,7 +1949,7 @@ renameRetry:
 		pSMB->OldFileName[name_len + 1] = 0x00;
 		name_len2 =
 		    cifsConvertToUCS((__le16 *) &pSMB->OldFileName[name_len + 2],
-				     toName, PATH_MAX, nls_codepage, remap);
+				     toName, PATH_MAX, nls_codepage, cifs_flags);
 		name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
 		name_len2 *= 2;	/* convert to bytes */
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -1980,7 +1984,7 @@ renameRetry:
 
 int CIFSSMBRenameOpenFile(const int xid, struct cifsTconInfo *pTcon,
 		int netfid, char *target_name,
-		const struct nls_table *nls_codepage, int remap)
+		const struct nls_table *nls_codepage, int cifs_flags)
 {
 	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
 	struct smb_com_transaction2_sfi_rsp *pSMBr = NULL;
@@ -2026,11 +2030,12 @@ int CIFSSMBRenameOpenFile(const int xid, struct cifsTconInfo *pTcon,
 	if (target_name == NULL) {
 		sprintf(dummy_string, "cifs%x", pSMB->hdr.Mid);
 		len_of_str = cifsConvertToUCS((__le16 *)rename_info->target_name,
-					dummy_string, 24, nls_codepage, remap);
+					      dummy_string, 24,
+					      nls_codepage, cifs_flags);
 	} else {
 		len_of_str = cifsConvertToUCS((__le16 *)rename_info->target_name,
-					target_name, PATH_MAX, nls_codepage,
-					remap);
+					      target_name, PATH_MAX,
+					      nls_codepage, cifs_flags);
 	}
 	rename_info->target_name_len = cpu_to_le32(2 * len_of_str);
 	count = 12 /* sizeof(struct set_file_rename) */ + (2 * len_of_str) + 2;
@@ -2060,7 +2065,7 @@ int CIFSSMBRenameOpenFile(const int xid, struct cifsTconInfo *pTcon,
 int
 CIFSSMBCopy(const int xid, struct cifsTconInfo *tcon, const char *fromName,
 	    const __u16 target_tid, const char *toName, const int flags,
-	    const struct nls_table *nls_codepage, int remap)
+	    const struct nls_table *nls_codepage, int cifs_flags)
 {
 	int rc = 0;
 	COPY_REQ *pSMB = NULL;
@@ -2084,7 +2089,7 @@ copyRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len = cifsConvertToUCS((__le16 *) pSMB->OldFileName,
 					    fromName, PATH_MAX, nls_codepage,
-					    remap);
+					    cifs_flags);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 		pSMB->OldFileName[name_len] = 0x04;     /* pad */
@@ -2092,7 +2097,7 @@ copyRetry:
 		pSMB->OldFileName[name_len + 1] = 0x00;
 		name_len2 =
 		    cifsConvertToUCS((__le16 *)&pSMB->OldFileName[name_len + 2],
-				toName, PATH_MAX, nls_codepage, remap);
+				toName, PATH_MAX, nls_codepage, cifs_flags);
 		name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
 		name_len2 *= 2; /* convert to bytes */
 	} else { 	/* BB improve the check for buffer overruns BB */
@@ -2219,7 +2224,7 @@ createSymLinkRetry:
 int
 CIFSUnixCreateHardLink(const int xid, struct cifsTconInfo *tcon,
 		       const char *fromName, const char *toName,
-		       const struct nls_table *nls_codepage, int remap)
+		       const struct nls_table *nls_codepage, int cifs_flags)
 {
 	TRANSACTION2_SPI_REQ *pSMB = NULL;
 	TRANSACTION2_SPI_RSP *pSMBr = NULL;
@@ -2239,7 +2244,7 @@ createHardLinkRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len = cifsConvertToUCS((__le16 *) pSMB->FileName, toName,
-					    PATH_MAX, nls_codepage, remap);
+					    PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 
@@ -2262,7 +2267,7 @@ createHardLinkRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len_target =
 		    cifsConvertToUCS((__le16 *) data_offset, fromName, PATH_MAX,
-				     nls_codepage, remap);
+				     nls_codepage, cifs_flags);
 		name_len_target++;	/* trailing null */
 		name_len_target *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -2304,7 +2309,7 @@ createHardLinkRetry:
 int
 CIFSCreateHardLink(const int xid, struct cifsTconInfo *tcon,
 		   const char *fromName, const char *toName,
-		   const struct nls_table *nls_codepage, int remap)
+		   const struct nls_table *nls_codepage, int cifs_flags)
 {
 	int rc = 0;
 	NT_RENAME_REQ *pSMB = NULL;
@@ -2332,14 +2337,15 @@ winCreateHardLinkRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUCS((__le16 *) pSMB->OldFileName, fromName,
-				     PATH_MAX, nls_codepage, remap);
+				     PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 		pSMB->OldFileName[name_len] = 0;	/* pad */
 		pSMB->OldFileName[name_len + 1] = 0x04;
 		name_len2 =
 		    cifsConvertToUCS((__le16 *)&pSMB->OldFileName[name_len + 2],
-				     toName, PATH_MAX, nls_codepage, remap);
+				     toName, PATH_MAX,
+				     nls_codepage, cifs_flags);
 		name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
 		name_len2 *= 2;	/* convert to bytes */
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -2807,7 +2813,7 @@ int
 CIFSSMBGetPosixACL(const int xid, struct cifsTconInfo *tcon,
 		   const unsigned char *searchName,
 		   char *acl_inf, const int buflen, const int acl_type,
-		   const struct nls_table *nls_codepage, int remap)
+		   const struct nls_table *nls_codepage, int cifs_flags)
 {
 /* SMB_QUERY_POSIX_ACL */
 	TRANSACTION2_QPI_REQ *pSMB = NULL;
@@ -2828,7 +2834,7 @@ queryAclRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 			cifsConvertToUCS((__le16 *) pSMB->FileName, searchName,
-					 PATH_MAX, nls_codepage, remap);
+					 PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 		pSMB->FileName[name_len] = 0;
@@ -2896,7 +2902,7 @@ CIFSSMBSetPosixACL(const int xid, struct cifsTconInfo *tcon,
 		   const unsigned char *fileName,
 		   const char *local_acl, const int buflen,
 		   const int acl_type,
-		   const struct nls_table *nls_codepage, int remap)
+		   const struct nls_table *nls_codepage, int cifs_flags)
 {
 	struct smb_com_transaction2_spi_req *pSMB = NULL;
 	struct smb_com_transaction2_spi_rsp *pSMBr = NULL;
@@ -2915,7 +2921,7 @@ setAclRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 			cifsConvertToUCS((__le16 *) pSMB->FileName, fileName,
-				      PATH_MAX, nls_codepage, remap);
+				      PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -3218,7 +3224,7 @@ setCifsAclRetry:
 int SMBQueryInformation(const int xid, struct cifsTconInfo *tcon,
 			const unsigned char *searchName,
 			FILE_ALL_INFO *pFinfo,
-			const struct nls_table *nls_codepage, int remap)
+			const struct nls_table *nls_codepage, int cifs_flags)
 {
 	QUERY_INFORMATION_REQ *pSMB;
 	QUERY_INFORMATION_RSP *pSMBr;
@@ -3236,7 +3242,7 @@ QInfRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 			cifsConvertToUCS((__le16 *) pSMB->FileName, searchName,
-					PATH_MAX, nls_codepage, remap);
+					PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 	} else {
@@ -3290,7 +3296,7 @@ CIFSSMBQPathInfo(const int xid, struct cifsTconInfo *tcon,
 		 const unsigned char *searchName,
 		 FILE_ALL_INFO *pFindData,
 		 int legacy /* old style infolevel */,
-		 const struct nls_table *nls_codepage, int remap)
+		 const struct nls_table *nls_codepage, int cifs_flags)
 {
 /* level 263 SMB_QUERY_FILE_ALL_INFO */
 	TRANSACTION2_QPI_REQ *pSMB = NULL;
@@ -3310,7 +3316,7 @@ QPathInfoRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUCS((__le16 *) pSMB->FileName, searchName,
-				     PATH_MAX, nls_codepage, remap);
+				     PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -3389,7 +3395,7 @@ int
 CIFSSMBUnixQPathInfo(const int xid, struct cifsTconInfo *tcon,
 		     const unsigned char *searchName,
 		     FILE_UNIX_BASIC_INFO * pFindData,
-		     const struct nls_table *nls_codepage, int remap)
+		     const struct nls_table *nls_codepage, int cifs_flags)
 {
 /* SMB_QUERY_FILE_UNIX_BASIC */
 	TRANSACTION2_QPI_REQ *pSMB = NULL;
@@ -3409,7 +3415,7 @@ UnixQPathInfoRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUCS((__le16 *) pSMB->FileName, searchName,
-				  PATH_MAX, nls_codepage, remap);
+				  PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -3476,7 +3482,8 @@ CIFSFindFirst(const int xid, struct cifsTconInfo *tcon,
 	      const char *searchName,
 	      const struct nls_table *nls_codepage,
 	      __u16 *pnetfid,
-	      struct cifs_search_info *psrch_inf, int remap, const char dirsep)
+	      struct cifs_search_info *psrch_inf, int cifs_flags,
+	      const char dirsep)
 {
 /* level 257 SMB_ */
 	TRANSACTION2_FFIRST_REQ *pSMB = NULL;
@@ -3498,7 +3505,7 @@ findFirstRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUCS((__le16 *) pSMB->FileName, searchName,
-				 PATH_MAX, nls_codepage, remap);
+				 PATH_MAX, nls_codepage, cifs_flags);
 		/* We can not add the asterik earlier in case
 		it got remapped to 0xF03A as if it were part of the
 		directory name instead of a wildcard */
@@ -3767,7 +3774,7 @@ int
 CIFSGetSrvInodeNumber(const int xid, struct cifsTconInfo *tcon,
 		      const unsigned char *searchName,
 		      __u64 *inode_number,
-		      const struct nls_table *nls_codepage, int remap)
+		      const struct nls_table *nls_codepage, int cifs_flags)
 {
 	int rc = 0;
 	TRANSACTION2_QPI_REQ *pSMB = NULL;
@@ -3788,7 +3795,7 @@ GetInodeNumberRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 			cifsConvertToUCS((__le16 *) pSMB->FileName, searchName,
-					 PATH_MAX, nls_codepage, remap);
+					 PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -3861,7 +3868,7 @@ CIFSGetDFSRefer(const int xid, struct cifsSesInfo *ses,
 		const unsigned char *searchName,
 		unsigned char **targetUNCs,
 		unsigned int *number_of_UNC_in_array,
-		const struct nls_table *nls_codepage, int remap)
+		const struct nls_table *nls_codepage, int cifs_flags)
 {
 /* TRANS2_GET_DFS_REFERRAL */
 	TRANSACTION2_GET_DFS_REFER_REQ *pSMB = NULL;
@@ -3899,7 +3906,8 @@ getDFSRetry:
 		pSMB->hdr.Flags2 |= SMBFLG2_UNICODE;
 		name_len =
 		    cifsConvertToUCS((__le16 *) pSMB->RequestFileName,
-				     searchName, PATH_MAX, nls_codepage, remap);
+				     searchName, PATH_MAX,
+				     nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -4583,7 +4591,7 @@ QFSPosixRetry:
 int
 CIFSSMBSetEOF(const int xid, struct cifsTconInfo *tcon, const char *fileName,
 	      __u64 size, int SetAllocation,
-	      const struct nls_table *nls_codepage, int remap)
+	      const struct nls_table *nls_codepage, int cifs_flags)
 {
 	struct smb_com_transaction2_spi_req *pSMB = NULL;
 	struct smb_com_transaction2_spi_rsp *pSMBr = NULL;
@@ -4603,7 +4611,7 @@ SetEOFRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUCS((__le16 *) pSMB->FileName, fileName,
-				     PATH_MAX, nls_codepage, remap);
+				     PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -4823,7 +4831,7 @@ CIFSSMBSetFileTimes(const int xid, struct cifsTconInfo *tcon,
 int
 CIFSSMBSetTimes(const int xid, struct cifsTconInfo *tcon, const char *fileName,
 		const FILE_BASIC_INFO *data,
-		const struct nls_table *nls_codepage, int remap)
+		const struct nls_table *nls_codepage, int cifs_flags)
 {
 	TRANSACTION2_SPI_REQ *pSMB = NULL;
 	TRANSACTION2_SPI_RSP *pSMBr = NULL;
@@ -4844,7 +4852,7 @@ SetTimesRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUCS((__le16 *) pSMB->FileName, fileName,
-				     PATH_MAX, nls_codepage, remap);
+				     PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -4954,7 +4962,7 @@ int
 CIFSSMBUnixSetPerms(const int xid, struct cifsTconInfo *tcon,
 		    char *fileName, __u64 mode, __u64 uid, __u64 gid,
 		    dev_t device, const struct nls_table *nls_codepage,
-		    int remap)
+		    int cifs_flags)
 {
 	TRANSACTION2_SPI_REQ *pSMB = NULL;
 	TRANSACTION2_SPI_RSP *pSMBr = NULL;
@@ -4974,7 +4982,7 @@ setPermsRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUCS((__le16 *) pSMB->FileName, fileName,
-				     PATH_MAX, nls_codepage, remap);
+				     PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -5135,7 +5143,7 @@ ssize_t
 CIFSSMBQAllEAs(const int xid, struct cifsTconInfo *tcon,
 		 const unsigned char *searchName,
 		 char *EAData, size_t buf_size,
-		 const struct nls_table *nls_codepage, int remap)
+		 const struct nls_table *nls_codepage, int cifs_flags)
 {
 		/* BB assumes one setup word */
 	TRANSACTION2_QPI_REQ *pSMB = NULL;
@@ -5157,7 +5165,7 @@ QAllEAsRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUCS((__le16 *) pSMB->FileName, searchName,
-				     PATH_MAX, nls_codepage, remap);
+				     PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -5284,7 +5292,7 @@ QAllEAsRetry:
 ssize_t CIFSSMBQueryEA(const int xid, struct cifsTconInfo *tcon,
 		const unsigned char *searchName, const unsigned char *ea_name,
 		unsigned char *ea_value, size_t buf_size,
-		const struct nls_table *nls_codepage, int remap)
+		const struct nls_table *nls_codepage, int cifs_flags)
 {
 	TRANSACTION2_QPI_REQ *pSMB = NULL;
 	TRANSACTION2_QPI_RSP *pSMBr = NULL;
@@ -5305,7 +5313,7 @@ QEARetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUCS((__le16 *) pSMB->FileName, searchName,
-				     PATH_MAX, nls_codepage, remap);
+				     PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -5434,7 +5442,7 @@ int
 CIFSSMBSetEA(const int xid, struct cifsTconInfo *tcon, const char *fileName,
 	     const char *ea_name, const void *ea_value,
 	     const __u16 ea_value_len, const struct nls_table *nls_codepage,
-	     int remap)
+	     int cifs_flags)
 {
 	struct smb_com_transaction2_spi_req *pSMB = NULL;
 	struct smb_com_transaction2_spi_rsp *pSMBr = NULL;
@@ -5454,7 +5462,7 @@ SetEARetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUCS((__le16 *) pSMB->FileName, fileName,
-				     PATH_MAX, nls_codepage, remap);
+				     PATH_MAX, nls_codepage, cifs_flags);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8dbfa97..a951c63 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1408,14 +1408,14 @@ find_unc(__be32 new_target_ip_addr, char *uncName, char *userName)
 int
 connect_to_dfs_path(int xid, struct cifsSesInfo *pSesInfo,
 		    const char *old_path, const struct nls_table *nls_codepage,
-		    int remap)
+		    int cifs_flags)
 {
 	struct dfs_info3_param *referrals = NULL;
 	unsigned int num_referrals;
 	int rc = 0;
 
 	rc = get_dfs_path(xid, pSesInfo, old_path, nls_codepage,
-			&num_referrals, &referrals, remap);
+			&num_referrals, &referrals, cifs_flags);
 
 	/* BB Add in code to: if valid refrl, if not ip address contact
 		the helper that resolves tcp names, mount to it, try to
@@ -1429,7 +1429,7 @@ connect_to_dfs_path(int xid, struct cifsSesInfo *pSesInfo,
 int
 get_dfs_path(int xid, struct cifsSesInfo *pSesInfo, const char *old_path,
 	     const struct nls_table *nls_codepage, unsigned int *pnum_referrals,
-	     struct dfs_info3_param **preferrals, int remap)
+	     struct dfs_info3_param **preferrals, int cifs_flags)
 {
 	char *temp_unc;
 	int rc = 0;
@@ -1457,7 +1457,7 @@ get_dfs_path(int xid, struct cifsSesInfo *pSesInfo, const char *old_path,
 	}
 	if (rc == 0)
 		rc = CIFSGetDFSRefer(xid, pSesInfo, old_path, &targetUNCs,
-				     pnum_referrals, nls_codepage, remap);
+				     pnum_referrals, nls_codepage, cifs_flags);
 	/* BB map targetUNCs to dfs_info3 structures, here or
 		in CIFSGetDFSRefer BB */
 
@@ -2149,8 +2149,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 					NULL)) {
 					rc = connect_to_dfs_path(xid, pSesInfo,
 						"", cifs_sb->local_nls,
-						cifs_sb->mnt_cifs_flags &
-						  CIFS_MOUNT_MAP_SPECIAL_CHR);
+						cifs_sb->mnt_cifs_flags);
 					rc = -ENODEV;
 					goto out;
 				} else {
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 4e83b47..15fe3b4 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -178,18 +178,19 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 	}
 	if (cifs_sb->tcon->ses->capabilities & CAP_NT_SMBS)
 		rc = CIFSSMBOpen(xid, pTcon, full_path, disposition,
-			 desiredAccess, CREATE_NOT_DIR,
-			 &fileHandle, &oplock, buf, cifs_sb->local_nls,
-			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+				 desiredAccess, CREATE_NOT_DIR,
+				 &fileHandle, &oplock, buf, cifs_sb->local_nls,
+				 cifs_sb->mnt_cifs_flags);
 	else
 		rc = -EIO; /* no NT SMB support fall into legacy open below */
 
 	if (rc == -EIO) {
 		/* old server, retry the open legacy style */
 		rc = SMBLegacyOpen(xid, pTcon, full_path, disposition,
-			desiredAccess, CREATE_NOT_DIR,
-			&fileHandle, &oplock, buf, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+				   desiredAccess, CREATE_NOT_DIR,
+				   &fileHandle, &oplock, buf,
+				   cifs_sb->local_nls,
+				   cifs_sb->mnt_cifs_flags);
 	}
 	if (rc) {
 		cFYI(1, ("cifs_create returned 0x%x", rc));
@@ -200,20 +201,18 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 			mode &= ~current->fs->umask;
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
 				CIFSSMBUnixSetPerms(xid, pTcon, full_path, mode,
-					(__u64)current->fsuid,
-					(__u64)current->fsgid,
-					0 /* dev */,
-					cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+						    (__u64)current->fsuid,
+						    (__u64)current->fsgid,
+						    0 /* dev */,
+						    cifs_sb->local_nls,
+						    cifs_sb->mnt_cifs_flags);
 			} else {
 				CIFSSMBUnixSetPerms(xid, pTcon, full_path, mode,
-					(__u64)-1,
-					(__u64)-1,
-					0 /* dev */,
-					cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+						    (__u64)-1,
+						    (__u64)-1,
+						    0 /* dev */,
+						    cifs_sb->local_nls,
+						    cifs_sb->mnt_cifs_flags);
 			}
 		} else {
 			/* BB implement mode setting via Windows security
@@ -328,18 +327,18 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 	else if (pTcon->unix_ext) {
 		mode &= ~current->fs->umask;
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
-			rc = CIFSSMBUnixSetPerms(xid, pTcon, full_path,
-				mode, (__u64)current->fsuid,
-				(__u64)current->fsgid,
-				device_number, cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+			rc = CIFSSMBUnixSetPerms(xid, pTcon, full_path, mode,
+						 (__u64)current->fsuid,
+						 (__u64)current->fsgid,
+						 device_number,
+						 cifs_sb->local_nls,
+						 cifs_sb->mnt_cifs_flags);
 		} else {
-			rc = CIFSSMBUnixSetPerms(xid, pTcon,
-				full_path, mode, (__u64)-1, (__u64)-1,
-				device_number, cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+			rc = CIFSSMBUnixSetPerms(xid, pTcon, full_path, mode,
+						 (__u64)-1, (__u64)-1,
+						 device_number,
+						 cifs_sb->local_nls,
+						 cifs_sb->mnt_cifs_flags);
 		}
 
 		if (!rc) {
@@ -376,8 +375,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 					 CREATE_NOT_DIR | CREATE_OPTION_SPECIAL,
 					 &fileHandle, &oplock, buf,
 					 cifs_sb->local_nls,
-					 cifs_sb->mnt_cifs_flags &
-					    CIFS_MOUNT_MAP_SPECIAL_CHR);
+					 cifs_sb->mnt_cifs_flags);
 
 			/* BB FIXME - add handling for backlevel servers
 			   which need legacy open and check for all
diff --git a/fs/cifs/fcntl.c b/fs/cifs/fcntl.c
index 7d1d5aa..d345b0b 100644
--- a/fs/cifs/fcntl.c
+++ b/fs/cifs/fcntl.c
@@ -89,9 +89,10 @@ int cifs_dir_notify(struct file *file, unsigned long arg)
 	} else {
 		cFYI(1, ("dir notify on file %s Arg 0x%lx", full_path, arg));
 		rc = CIFSSMBOpen(xid, pTcon, full_path, FILE_OPEN,
-			GENERIC_READ | SYNCHRONIZE, 0 /* create options */,
-			&netfid, &oplock, NULL, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+				 GENERIC_READ | SYNCHRONIZE,
+				 0 /* create options */,
+				 &netfid, &oplock, NULL, cifs_sb->local_nls,
+				 cifs_sb->mnt_cifs_flags);
 		/* BB fixme - add this handle to a notify handle list */
 		if (rc) {
 			cFYI(1, ("Could not open directory for notify"));
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index fa849c9..b0e7795 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -266,18 +266,18 @@ int cifs_open(struct inode *inode, struct file *file)
 
 	if (cifs_sb->tcon->ses->capabilities & CAP_NT_SMBS)
 		rc = CIFSSMBOpen(xid, pTcon, full_path, disposition,
-			 desiredAccess, CREATE_NOT_DIR, &netfid, &oplock, buf,
-			 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
-				 & CIFS_MOUNT_MAP_SPECIAL_CHR);
+				 desiredAccess, CREATE_NOT_DIR,
+				 &netfid, &oplock, buf,
+				 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags);
 	else
 		rc = -EIO; /* no NT SMB support fall into legacy open below */
 
 	if (rc == -EIO) {
 		/* Old server, try legacy style OpenX */
 		rc = SMBLegacyOpen(xid, pTcon, full_path, disposition,
-			desiredAccess, CREATE_NOT_DIR, &netfid, &oplock, buf,
-			cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
-				& CIFS_MOUNT_MAP_SPECIAL_CHR);
+				   desiredAccess, CREATE_NOT_DIR,
+				   &netfid, &oplock, buf,
+				   cifs_sb->local_nls, cifs_sb->mnt_cifs_flags);
 	}
 	if (rc) {
 		cFYI(1, ("cifs_open returned 0x%x", rc));
@@ -310,8 +310,7 @@ int cifs_open(struct inode *inode, struct file *file)
 					    inode->i_mode,
 					    (__u64)-1, (__u64)-1, 0 /* dev */,
 					    cifs_sb->local_nls,
-					    cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					    cifs_sb->mnt_cifs_flags);
 		} else {
 			/* BB implement via Windows security descriptors eg
 			   CIFSSMBWinSetPerms(xid, pTcon, full_path, mode,
@@ -414,8 +413,7 @@ reopen_error_exit:
 
 	rc = CIFSSMBOpen(xid, pTcon, full_path, disposition, desiredAccess,
 			 CREATE_NOT_DIR, &netfid, &oplock, NULL,
-			 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+			 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags);
 	if (rc) {
 		up(&pCifsFile->fh_sem);
 		cFYI(1, ("cifs_open returned 0x%x", rc));
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 24eb4d3..13c728f 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -167,8 +167,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 	cFYI(1, ("Getting info on %s", search_path));
 	/* could have done a find first instead but this returns more info */
 	rc = CIFSSMBUnixQPathInfo(xid, pTcon, search_path, &findData,
-				  cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+				  cifs_sb->local_nls, cifs_sb->mnt_cifs_flags);
 /*	dump_mem("\nUnixQPathInfo return data", &findData,
 		 sizeof(findData)); */
 	if (rc) {
@@ -188,8 +187,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 			rc = connect_to_dfs_path(xid, pTcon->ses,
 						 /* treename + */ tmp_path,
 						 cifs_sb->local_nls,
-						 cifs_sb->mnt_cifs_flags &
-						    CIFS_MOUNT_MAP_SPECIAL_CHR);
+						 cifs_sb->mnt_cifs_flags);
 			kfree(tmp_path);
 
 			/* BB fix up inode etc. */
@@ -266,8 +264,7 @@ static int decode_sfu_inode(struct inode *inode, __u64 size,
 	rc = CIFSSMBOpen(xid, pTcon, path, FILE_OPEN, GENERIC_READ,
 			 CREATE_NOT_DIR, &netfid, &oplock, NULL,
 			 cifs_sb->local_nls,
-			 cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+			 cifs_sb->mnt_cifs_flags);
 	if (rc == 0) {
 		int buf_type = CIFS_NO_BUFFER;
 			/* Read header */
@@ -326,8 +323,9 @@ static int get_sfu_mode(struct inode *inode,
 	__u32 mode;
 
 	rc = CIFSSMBQueryEA(xid, cifs_sb->tcon, path, "SETFILEBITS",
-			ea_value, 4 /* size of buf */, cifs_sb->local_nls,
-		cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			    ea_value, 4 /* size of buf */,
+			    cifs_sb->local_nls,
+			    cifs_sb->mnt_cifs_flags);
 	if (rc < 0)
 		return (int)rc;
 	else if (rc > 3) {
@@ -375,17 +373,16 @@ int cifs_get_inode_info(struct inode **pinode,
 		pfindData = (FILE_ALL_INFO *)buf;
 		/* could do find first instead but this returns more info */
 		rc = CIFSSMBQPathInfo(xid, pTcon, search_path, pfindData,
-			      0 /* not legacy */,
-			      cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+				      0 /* not legacy */,
+				      cifs_sb->local_nls,
+				      cifs_sb->mnt_cifs_flags);
 		/* BB optimize code so we do not make the above call
 		when server claims no NT SMB support and the above call
 		failed at least once - set flag in tcon or mount */
 		if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
 			rc = SMBQueryInformation(xid, pTcon, search_path,
-					pfindData, cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-					  CIFS_MOUNT_MAP_SPECIAL_CHR);
+						 pfindData, cifs_sb->local_nls,
+						 cifs_sb->mnt_cifs_flags);
 			adjustTZ = TRUE;
 		}
 	}
@@ -408,8 +405,7 @@ int cifs_get_inode_info(struct inode **pinode,
 			rc = connect_to_dfs_path(xid, pTcon->ses,
 						 /* treename + */ tmp_path,
 						 cifs_sb->local_nls,
-						 cifs_sb->mnt_cifs_flags &
-						   CIFS_MOUNT_MAP_SPECIAL_CHR);
+						 cifs_sb->mnt_cifs_flags);
 			kfree(tmp_path);
 			/* BB fix up inode etc. */
 		} else if (rc) {
@@ -447,10 +443,9 @@ int cifs_get_inode_info(struct inode **pinode,
 				__u64 inode_num;
 
 				rc1 = CIFSGetSrvInodeNumber(xid, pTcon,
-					search_path, &inode_num,
-					cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+						search_path, &inode_num,
+						cifs_sb->local_nls,
+						cifs_sb->mnt_cifs_flags);
 				if (rc1) {
 					cFYI(1, ("GetSrvInodeNum rc %d", rc1));
 					/* BB EOPNOSUPP disable SERVER_INUM? */
@@ -660,15 +655,16 @@ int cifs_unlink(struct inode *inode, struct dentry *direntry)
 		(CIFS_UNIX_POSIX_PATH_OPS_CAP &
 			le64_to_cpu(pTcon->fsUnixInfo.Capability))) {
 		rc = CIFSPOSIXDelFile(xid, pTcon, full_path,
-			SMB_POSIX_UNLINK_FILE_TARGET, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+				      SMB_POSIX_UNLINK_FILE_TARGET,
+				      cifs_sb->local_nls,
+				      cifs_sb->mnt_cifs_flags);
 		cFYI(1, ("posix del rc %d", rc));
 		if ((rc == 0) || (rc == -ENOENT))
 			goto psx_del_no_retry;
 	}
 
 	rc = CIFSSMBDelFile(xid, pTcon, full_path, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			    cifs_sb->mnt_cifs_flags);
 psx_del_no_retry:
 	if (!rc) {
 		if (direntry->d_inode)
@@ -682,13 +678,11 @@ psx_del_no_retry:
 		rc = CIFSSMBOpen(xid, pTcon, full_path, FILE_OPEN, DELETE,
 				 CREATE_NOT_DIR | CREATE_DELETE_ON_CLOSE,
 				 &netfid, &oplock, NULL, cifs_sb->local_nls,
-				 cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+				 cifs_sb->mnt_cifs_flags);
 		if (rc == 0) {
 			CIFSSMBRenameOpenFile(xid, pTcon, netfid, NULL,
 					      cifs_sb->local_nls,
-					      cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					      cifs_sb->mnt_cifs_flags);
 			CIFSSMBClose(xid, pTcon, netfid);
 			if (direntry->d_inode)
 				drop_nlink(direntry->d_inode);
@@ -703,8 +697,7 @@ psx_del_no_retry:
 				rc = CIFSSMBSetTimes(xid, pTcon, full_path,
 						     pinfo_buf,
 						     cifs_sb->local_nls,
-						     cifs_sb->mnt_cifs_flags &
-							CIFS_MOUNT_MAP_SPECIAL_CHR);
+						     cifs_sb->mnt_cifs_flags);
 			else
 				rc = -EOPNOTSUPP;
 
@@ -727,8 +720,7 @@ psx_del_no_retry:
 						 FILE_WRITE_ATTRIBUTES, 0,
 						 &netfid, &oplock, NULL,
 						 cifs_sb->local_nls,
-						 cifs_sb->mnt_cifs_flags &
-						    CIFS_MOUNT_MAP_SPECIAL_CHR);
+						 cifs_sb->mnt_cifs_flags);
 				if (rc == 0) {
 					rc = CIFSSMBSetFileTimes(xid, pTcon,
 								 pinfo_buf,
@@ -741,8 +733,7 @@ psx_del_no_retry:
 		if (rc == 0) {
 			rc = CIFSSMBDelFile(xid, pTcon, full_path,
 					    cifs_sb->local_nls,
-					    cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					    cifs_sb->mnt_cifs_flags);
 			if (!rc) {
 				if (direntry->d_inode)
 					drop_nlink(direntry->d_inode);
@@ -756,14 +747,12 @@ psx_del_no_retry:
 						 CREATE_DELETE_ON_CLOSE,
 						 &netfid, &oplock, NULL,
 						 cifs_sb->local_nls,
-						 cifs_sb->mnt_cifs_flags &
-						    CIFS_MOUNT_MAP_SPECIAL_CHR);
+						 cifs_sb->mnt_cifs_flags);
 				if (rc == 0) {
 					CIFSSMBRenameOpenFile(xid, pTcon,
 						netfid, NULL,
 						cifs_sb->local_nls,
-						cifs_sb->mnt_cifs_flags &
-						    CIFS_MOUNT_MAP_SPECIAL_CHR);
+						cifs_sb->mnt_cifs_flags);
 					CIFSSMBClose(xid, pTcon, netfid);
 					if (direntry->d_inode)
 						drop_nlink(direntry->d_inode);
@@ -862,10 +851,9 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, int mode)
 
 		mode &= ~current->fs->umask;
 		rc = CIFSPOSIXCreate(xid, pTcon, SMB_O_DIRECTORY | SMB_O_CREAT,
-				mode, NULL /* netfid */, pInfo, &oplock,
-				full_path, cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+				     mode, NULL /* netfid */, pInfo, &oplock,
+				     full_path, cifs_sb->local_nls,
+				     cifs_sb->mnt_cifs_flags);
 		if (rc == -EOPNOTSUPP) {
 			kfree(pInfo);
 			goto mkdir_retry_old;
@@ -924,7 +912,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, int mode)
 mkdir_retry_old:
 	/* BB add setting the equivalent of mode via CreateX w/ACLs */
 	rc = CIFSSMBMkDir(xid, pTcon, full_path, cifs_sb->local_nls,
-			  cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			  cifs_sb->mnt_cifs_flags);
 	if (rc) {
 		cFYI(1, ("cifs_mkdir returned 0x%x", rc));
 		d_drop(direntry);
@@ -956,15 +944,13 @@ mkdir_get_info:
 						    (__u64)current->fsgid,
 						    0 /* dev_t */,
 						    cifs_sb->local_nls,
-						    cifs_sb->mnt_cifs_flags &
-						    CIFS_MOUNT_MAP_SPECIAL_CHR);
+						    cifs_sb->mnt_cifs_flags);
 			} else {
 				CIFSSMBUnixSetPerms(xid, pTcon, full_path,
 						    mode, (__u64)-1,
 						    (__u64)-1, 0 /* dev_t */,
 						    cifs_sb->local_nls,
-						    cifs_sb->mnt_cifs_flags &
-						    CIFS_MOUNT_MAP_SPECIAL_CHR);
+						    cifs_sb->mnt_cifs_flags);
 			}
 		} else {
 			/* BB to be implemented via Windows secrty descriptors
@@ -1012,8 +998,7 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 	}
 
 	rc = CIFSSMBRmDir(xid, pTcon, full_path, cifs_sb->local_nls,
-			  cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
-
+			  cifs_sb->mnt_cifs_flags);
 	if (!rc) {
 		drop_nlink(inode);
 		spin_lock(&direntry->d_inode->i_lock);
@@ -1068,8 +1053,7 @@ int cifs_rename(struct inode *source_inode, struct dentry *source_direntry,
 
 	rc = CIFSSMBRename(xid, pTcon, fromName, toName,
 			   cifs_sb_source->local_nls,
-			   cifs_sb_source->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+			   cifs_sb_source->mnt_cifs_flags);
 	if (rc == -EEXIST) {
 		/* check if they are the same file because rename of hardlinked
 		   files is a noop */
@@ -1084,8 +1068,7 @@ int cifs_rename(struct inode *source_inode, struct dentry *source_direntry,
 				rc = CIFSSMBUnixQPathInfo(xid, pTcon, fromName,
 					info_buf_source,
 					cifs_sb_source->local_nls,
-					cifs_sb_source->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					cifs_sb_source->mnt_cifs_flags);
 			/* else rc is still EEXIST so will fall through to
 			   unlink the target and retry rename */
 			if (rc == 0) {
@@ -1093,8 +1076,7 @@ int cifs_rename(struct inode *source_inode, struct dentry *source_direntry,
 						info_buf_target,
 						cifs_sb_target->local_nls,
 						/* remap based on source sb */
-						cifs_sb_source->mnt_cifs_flags &
-						    CIFS_MOUNT_MAP_SPECIAL_CHR);
+						cifs_sb_source->mnt_cifs_flags);
 			}
 			if ((rc == 0) &&
 			    (info_buf_source->UniqueId ==
@@ -1109,10 +1091,9 @@ int cifs_rename(struct inode *source_inode, struct dentry *source_direntry,
 			   semantics */
 				cifs_unlink(target_inode, target_direntry);
 				rc = CIFSSMBRename(xid, pTcon, fromName,
-						   toName,
-						   cifs_sb_source->local_nls,
-						   cifs_sb_source->mnt_cifs_flags
-						   & CIFS_MOUNT_MAP_SPECIAL_CHR);
+						toName,
+						cifs_sb_source->local_nls,
+						cifs_sb_source->mnt_cifs_flags);
 			}
 			kfree(info_buf_source);
 		} /* if we can not get memory just leave rc as EEXIST */
@@ -1132,13 +1113,11 @@ int cifs_rename(struct inode *source_inode, struct dentry *source_direntry,
 		rc = CIFSSMBOpen(xid, pTcon, fromName, FILE_OPEN, GENERIC_READ,
 				 CREATE_NOT_DIR, &netfid, &oplock, NULL,
 				 cifs_sb_source->local_nls,
-				 cifs_sb_source->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+				 cifs_sb_source->mnt_cifs_flags);
 		if (rc == 0) {
 			rc = CIFSSMBRenameOpenFile(xid, pTcon, netfid, toName,
-					      cifs_sb_source->local_nls,
-					      cifs_sb_source->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+						cifs_sb_source->local_nls,
+						cifs_sb_source->mnt_cifs_flags);
 			CIFSSMBClose(xid, pTcon, netfid);
 		}
 	}
@@ -1458,8 +1437,7 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 			rc = CIFSSMBSetEOF(xid, pTcon, full_path,
 					   attrs->ia_size, FALSE,
 					   cifs_sb->local_nls,
-					   cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					   cifs_sb->mnt_cifs_flags);
 			cFYI(1, ("SetEOF by path (setattrs) rc = %d", rc));
 			if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
 				__u16 netfid;
@@ -1468,10 +1446,9 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 				rc = SMBLegacyOpen(xid, pTcon, full_path,
 					FILE_OPEN,
 					SYNCHRONIZE | FILE_WRITE_ATTRIBUTES,
-					CREATE_NOT_DIR, &netfid, &oplock,
-					NULL, cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					CREATE_NOT_DIR, &netfid, &oplock, NULL,
+					cifs_sb->local_nls,
+					cifs_sb->mnt_cifs_flags);
 				if (rc == 0) {
 					unsigned int bytes_written;
 					rc = CIFSSMBWrite(xid, pTcon,
@@ -1523,8 +1500,7 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 	    && (attrs->ia_valid & (ATTR_MODE | ATTR_GID | ATTR_UID)))
 		rc = CIFSSMBUnixSetPerms(xid, pTcon, full_path, mode, uid, gid,
 					 0 /* dev_t */, cifs_sb->local_nls,
-					 cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					 cifs_sb->mnt_cifs_flags);
 	else if (attrs->ia_valid & ATTR_MODE) {
 		rc = 0;
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -1596,8 +1572,7 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 		if (!(pTcon->ses->flags & CIFS_SES_NT4))
 			rc = CIFSSMBSetTimes(xid, pTcon, full_path, &time_buf,
 					     cifs_sb->local_nls,
-					     cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					     cifs_sb->mnt_cifs_flags);
 		else
 			rc = -EOPNOTSUPP;
 
@@ -1613,8 +1588,7 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 					 SYNCHRONIZE | FILE_WRITE_ATTRIBUTES,
 					 CREATE_NOT_DIR, &netfid, &oplock,
 					 NULL, cifs_sb->local_nls,
-					 cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					 cifs_sb->mnt_cifs_flags);
 			if (rc == 0) {
 				rc = CIFSSMBSetFileTimes(xid, pTcon, &time_buf,
 							 netfid);
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 1d6fb01..4b5ca5f 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -59,13 +59,11 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
 	if (pTcon->unix_ext)
 		rc = CIFSUnixCreateHardLink(xid, pTcon, fromName, toName,
 					    cifs_sb_target->local_nls,
-					    cifs_sb_target->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					    cifs_sb_target->mnt_cifs_flags);
 	else {
 		rc = CIFSCreateHardLink(xid, pTcon, fromName, toName,
 					cifs_sb_target->local_nls,
-					cifs_sb_target->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					cifs_sb_target->mnt_cifs_flags);
 		if ((rc == -EIO) || (rc == -EINVAL))
 			rc = -EOPNOTSUPP;
 	}
@@ -281,10 +279,9 @@ cifs_readlink(struct dentry *direntry, char __user *pBuffer, int buflen)
 		/* add open and read as in fs/cifs/inode.c */
 	} else {
 		rc = CIFSSMBOpen(xid, pTcon, full_path, FILE_OPEN, GENERIC_READ,
-				OPEN_REPARSE_POINT, &fid, &oplock, NULL,
-				cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+				 OPEN_REPARSE_POINT, &fid, &oplock, NULL,
+				 cifs_sb->local_nls,
+				 cifs_sb->mnt_cifs_flags);
 		if (!rc) {
 			rc = CIFSSMBQueryReparseLinkInfo(xid, pTcon, full_path,
 				tmpbuffer,
@@ -312,8 +309,7 @@ cifs_readlink(struct dentry *direntry, char __user *pBuffer, int buflen)
 						tmp_path,
 						cifs_sb->local_nls,
 						&num_referrals, &refs,
-						cifs_sb->mnt_cifs_flags &
-						    CIFS_MOUNT_MAP_SPECIAL_CHR);
+						cifs_sb->mnt_cifs_flags);
 					cFYI(1, ("Get DFS for %s rc = %d ",
 						tmp_path, rc));
 					if ((num_referrals == 0) && (rc == 0))
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 2a42d9f..cd9d977 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -714,14 +714,14 @@ cUCS_out:
    names are little endian 16 bit Unicode on the wire */
 int
 cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
-		 const struct nls_table *cp, int mapChars)
+		 const struct nls_table *cp, int cifs_flags)
 {
 	int i, j, charlen;
 	int len_remaining = maxlen;
 	char src_char;
 	__u16 temp;
 
-	if (!mapChars)
+	if (!(cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR))
 		return cifs_strtoUCS(target, source, PATH_MAX, cp);
 
 	for (i = 0, j = 0; i < maxlen; j++) {
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 32b445e..38811ce 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -481,9 +481,8 @@ ffirst_retry:
 	}
 
 	rc = CIFSFindFirst(xid, pTcon, full_path, cifs_sb->local_nls,
-		&cifsFile->netfid, &cifsFile->srch_inf,
-		cifs_sb->mnt_cifs_flags &
-			CIFS_MOUNT_MAP_SPECIAL_CHR, CIFS_DIR_SEP(cifs_sb));
+			   &cifsFile->netfid, &cifsFile->srch_inf,
+			   cifs_sb->mnt_cifs_flags, CIFS_DIR_SEP(cifs_sb));
 	if (rc == 0)
 		cifsFile->invalidHandle = FALSE;
 	if ((rc == -EOPNOTSUPP) &&
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 8cd6a44..5122683 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -83,8 +83,8 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
 
 		ea_name += 5; /* skip past user. prefix */
 		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, NULL,
-			(__u16)0, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+				  (__u16)0, cifs_sb->local_nls,
+				  cifs_sb->mnt_cifs_flags);
 	}
 remove_ea_exit:
 	kfree(full_path);
@@ -144,16 +144,16 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 
 		ea_name += 5; /* skip past user. prefix */
 		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
-			(__u16)value_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+				  (__u16)value_size, cifs_sb->local_nls,
+				  cifs_sb->mnt_cifs_flags);
 	} else if (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto set_ea_exit;
 
 		ea_name += 4; /* skip past os2. prefix */
 		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
-			(__u16)value_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+				  (__u16)value_size, cifs_sb->local_nls,
+				  cifs_sb->mnt_cifs_flags);
 	} else {
 		int temp;
 		temp = strncmp(ea_name, POSIX_ACL_XATTR_ACCESS,
@@ -164,8 +164,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 				rc = CIFSSMBSetPosixACL(xid, pTcon, full_path,
 					ea_value, (const int)value_size,
 					ACL_TYPE_ACCESS, cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					cifs_sb->mnt_cifs_flags);
 			cFYI(1, ("set POSIX ACL rc %d", rc));
 #else
 			cFYI(1, ("set POSIX ACL not supported"));
@@ -177,8 +176,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 				rc = CIFSSMBSetPosixACL(xid, pTcon, full_path,
 					ea_value, (const int)value_size,
 					ACL_TYPE_DEFAULT, cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					cifs_sb->mnt_cifs_flags);
 			cFYI(1, ("set POSIX default ACL rc %d", rc));
 #else
 			cFYI(1, ("set default POSIX ACL not supported"));
@@ -242,25 +240,25 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 		} /* BB add else when above is implemented */
 		ea_name += 5; /* skip past user. prefix */
 		rc = CIFSSMBQueryEA(xid, pTcon, full_path, ea_name, ea_value,
-			buf_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+				    buf_size, cifs_sb->local_nls,
+				    cifs_sb->mnt_cifs_flags);
 	} else if (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto get_ea_exit;
 
 		ea_name += 4; /* skip past os2. prefix */
 		rc = CIFSSMBQueryEA(xid, pTcon, full_path, ea_name, ea_value,
-			buf_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+				    buf_size, cifs_sb->local_nls,
+				    cifs_sb->mnt_cifs_flags);
 	} else if (strncmp(ea_name, POSIX_ACL_XATTR_ACCESS,
 			  strlen(POSIX_ACL_XATTR_ACCESS)) == 0) {
 #ifdef CONFIG_CIFS_POSIX
 		if (sb->s_flags & MS_POSIXACL)
 			rc = CIFSSMBGetPosixACL(xid, pTcon, full_path,
-				ea_value, buf_size, ACL_TYPE_ACCESS,
-				cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+						ea_value, buf_size,
+						ACL_TYPE_ACCESS,
+						cifs_sb->local_nls,
+						cifs_sb->mnt_cifs_flags);
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 		else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
 			__u16 fid;
@@ -269,10 +267,11 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 			__u32 buflen = 0;
 			if (experimEnabled)
 				rc = CIFSSMBOpen(xid, pTcon, full_path,
-					FILE_OPEN, GENERIC_READ, 0, &fid,
-					&oplock, NULL, cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+						 FILE_OPEN, GENERIC_READ,
+						 0, &fid,
+						 &oplock, NULL,
+						 cifs_sb->local_nls,
+						 cifs_sb->mnt_cifs_flags);
 			/* else rc is EOPNOTSUPP from above */
 
 			if (rc == 0) {
@@ -290,10 +289,10 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 #ifdef CONFIG_CIFS_POSIX
 		if (sb->s_flags & MS_POSIXACL)
 			rc = CIFSSMBGetPosixACL(xid, pTcon, full_path,
-				ea_value, buf_size, ACL_TYPE_DEFAULT,
-				cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+						ea_value, buf_size,
+						ACL_TYPE_DEFAULT,
+						cifs_sb->local_nls,
+						cifs_sb->mnt_cifs_flags);
 #else
 		cFYI(1, ("query POSIX default ACL not supported yet"));
 #endif
@@ -361,9 +360,8 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
 		search server for EAs or streams to
 		returns as xattrs */
 	rc = CIFSSMBQAllEAs(xid, pTcon, full_path, data, buf_size,
-				cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+			    cifs_sb->local_nls,
+			    cifs_sb->mnt_cifs_flags);
 
 	kfree(full_path);
 	FreeXid(xid);
-- 
1.5.4.rc2

