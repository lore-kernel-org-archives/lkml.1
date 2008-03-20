Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbYCTBQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbYCTBQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 21:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758724AbYCTBO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 21:14:26 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1528 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbYCTBOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 21:14:18 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Steve French <sfrench@samba.org>, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org
Subject: [PATCH 2/4] fs/cifs - Use bool
Date: Wed, 19 Mar 2008 18:11:13 -0700
Message-Id: <1205975475-12708-2-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1205975475-12708-1-git-send-email-joe@perches.com>
References: <1205975475-12708-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/cifs/asn1.c       |   10 +++---
 fs/cifs/cifsacl.c    |   16 +++++-----
 fs/cifs/cifsfs.c     |    6 ++--
 fs/cifs/cifsfs.h     |    8 -----
 fs/cifs/cifsglob.h   |   44 +++++++++++----------------
 fs/cifs/cifsproto.h  |   13 ++++----
 fs/cifs/cifssmb.c    |   38 ++++++++++++------------
 fs/cifs/connect.c    |   80 +++++++++++++++++++++++++-------------------------
 fs/cifs/dir.c        |   18 +++++-----
 fs/cifs/fcntl.c      |    2 +-
 fs/cifs/file.c       |   80 +++++++++++++++++++++++++-------------------------
 fs/cifs/inode.c      |   42 +++++++++++++-------------
 fs/cifs/link.c       |    2 +-
 fs/cifs/misc.c       |   33 ++++++++++----------
 fs/cifs/readdir.c    |   12 ++++----
 fs/cifs/smbencrypt.c |    8 ++--
 fs/cifs/xattr.c      |    2 +-
 17 files changed, 200 insertions(+), 214 deletions(-)

diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
index bcda2c6..cb52cbb 100644
--- a/fs/cifs/asn1.c
+++ b/fs/cifs/asn1.c
@@ -460,8 +460,8 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 	unsigned char *sequence_end;
 	unsigned long *oid = NULL;
 	unsigned int cls, con, tag, oidlen, rc;
-	int use_ntlmssp = FALSE;
-	int use_kerberos = FALSE;
+	bool use_ntlmssp = false;
+	bool use_kerberos = false;
 
 	*secType = NTLM; /* BB eventually make Kerberos or NLTMSSP the default*/
 
@@ -561,15 +561,15 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 					if (compare_oid(oid, oidlen,
 							MSKRB5_OID,
 							MSKRB5_OID_LEN))
-						use_kerberos = TRUE;
+						use_kerberos = true;
 					else if (compare_oid(oid, oidlen,
 							     KRB5_OID,
 							     KRB5_OID_LEN))
-						use_kerberos = TRUE;
+						use_kerberos = true;
 					else if (compare_oid(oid, oidlen,
 							     NTLMSSP_OID,
 							     NTLMSSP_OID_LEN))
-						use_ntlmssp = TRUE;
+						use_ntlmssp = true;
 
 					kfree(oid);
 				}
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 4fb75af..feb8dbb 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -559,7 +559,7 @@ static struct cifs_ntsd *get_cifs_acl(u32 *pacllen, struct inode *inode,
 				       const char *path)
 {
 	struct cifsFileInfo *open_file;
-	int unlock_file = FALSE;
+	bool unlock_file = false;
 	int xid;
 	int rc = -EIO;
 	__u16 fid;
@@ -582,10 +582,10 @@ static struct cifs_ntsd *get_cifs_acl(u32 *pacllen, struct inode *inode,
 	cifs_sb = CIFS_SB(sb);
 
 	if (open_file) {
-		unlock_file = TRUE;
+		unlock_file = true;
 		fid = open_file->netfid;
 	} else {
-		int oplock = FALSE;
+		int oplock = 0;
 		/* open file */
 		rc = CIFSSMBOpen(xid, cifs_sb->tcon, path, FILE_OPEN,
 				 READ_CONTROL, 0, &fid, &oplock, NULL,
@@ -599,7 +599,7 @@ static struct cifs_ntsd *get_cifs_acl(u32 *pacllen, struct inode *inode,
 
 	rc = CIFSSMBGetCIFSACL(xid, cifs_sb->tcon, fid, &pntsd, pacllen);
 	cFYI(1, ("GetCIFSACL rc = %d ACL len %d", rc, *pacllen));
-	if (unlock_file == TRUE)
+	if (unlock_file)
 		atomic_dec(&open_file->wrtPending);
 	else
 		CIFSSMBClose(xid, cifs_sb->tcon, fid);
@@ -613,7 +613,7 @@ static int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 				struct inode *inode, const char *path)
 {
 	struct cifsFileInfo *open_file;
-	int unlock_file = FALSE;
+	bool unlock_file = false;
 	int xid;
 	int rc = -EIO;
 	__u16 fid;
@@ -634,10 +634,10 @@ static int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 
 	open_file = find_readable_file(CIFS_I(inode));
 	if (open_file) {
-		unlock_file = TRUE;
+		unlock_file = true;
 		fid = open_file->netfid;
 	} else {
-		int oplock = FALSE;
+		int oplock = 0;
 		/* open file */
 		rc = CIFSSMBOpen(xid, cifs_sb->tcon, path, FILE_OPEN,
 				 WRITE_DAC, 0, &fid, &oplock, NULL,
@@ -651,7 +651,7 @@ static int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 
 	rc = CIFSSMBSetCIFSACL(xid, cifs_sb->tcon, fid, pnntsd, acllen);
 	cFYI(DBG2, ("SetCIFSACL rc = %d", rc));
-	if (unlock_file == TRUE)
+	if (unlock_file)
 		atomic_dec(&open_file->wrtPending);
 	else
 		CIFSSMBClose(xid, cifs_sb->tcon, fid);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index a04b17e..14dceac 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -306,8 +306,8 @@ cifs_alloc_inode(struct super_block *sb)
 	/* Until the file is open and we have gotten oplock
 	info back from the server, can not assume caching of
 	file data or metadata */
-	cifs_inode->clientCanCacheRead = FALSE;
-	cifs_inode->clientCanCacheAll = FALSE;
+	cifs_inode->clientCanCacheRead = false;
+	cifs_inode->clientCanCacheAll = false;
 	cifs_inode->vfs_inode.i_blkbits = 14;  /* 2**14 = CIFS_MAX_MSGSIZE */
 
 	/* Can not set i_flags here - they get immediately overwritten
@@ -945,7 +945,7 @@ static int cifs_oplock_thread(void *dummyarg)
 				    rc = CIFSSMBLock(0, pTcon, netfid,
 					    0 /* len */ , 0 /* offset */, 0,
 					    0, LOCKING_ANDX_OPLOCK_RELEASE,
-					    0 /* wait flag */);
+					    false /* wait flag */);
 					cFYI(1, ("Oplock release rc = %d", rc));
 				}
 			} else
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 6897830..ab7246a 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -24,14 +24,6 @@
 
 #define ROOT_I 2
 
-#ifndef FALSE
-#define FALSE 0
-#endif
-
-#ifndef TRUE
-#define TRUE 1
-#endif
-
 extern struct file_system_type cifs_fs_type;
 extern const struct address_space_operations cifs_addr_ops;
 extern const struct address_space_operations cifs_addr_ops_smallbuf;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 69a2e19..b7d9f69 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -57,14 +57,6 @@
 
 #include "cifspdu.h"
 
-#ifndef FALSE
-#define FALSE 0
-#endif
-
-#ifndef TRUE
-#define TRUE 1
-#endif
-
 #ifndef XATTR_DOS_ATTRIB
 #define XATTR_DOS_ATTRIB "user.DOSATTRIB"
 #endif
@@ -147,7 +139,7 @@ struct TCP_Server_Info {
 	enum protocolEnum protocolType;
 	char versionMajor;
 	char versionMinor;
-	unsigned svlocal:1;	/* local server or remote */
+	bool svlocal:1;			/* local server or remote */
 	atomic_t socketUseCount; /* number of open cifs sessions on socket */
 	atomic_t inFlight;  /* number of requests on the wire to server */
 #ifdef CONFIG_CIFS_STATS2
@@ -286,10 +278,10 @@ struct cifsTconInfo {
 	FILE_SYSTEM_DEVICE_INFO fsDevInfo;
 	FILE_SYSTEM_ATTRIBUTE_INFO fsAttrInfo; /* ok if fs name truncated */
 	FILE_SYSTEM_UNIX_INFO fsUnixInfo;
-	unsigned ipc:1;		/* set if connection to IPC$ eg for RPC/PIPES */
-	unsigned retry:1;
-	unsigned nocase:1;
-	unsigned unix_ext:1; /* if off disable Linux extensions to CIFS protocol
+	bool ipc:1;		/* set if connection to IPC$ eg for RPC/PIPES */
+	bool retry:1;
+	bool nocase:1;
+	bool unix_ext:1;  /* if false disable Linux extensions to CIFS protocol
 				for this mount even if server would support */
 	/* BB add field for back pointer to sb struct(s)? */
 };
@@ -317,10 +309,10 @@ struct cifs_search_info {
 	char *srch_entries_start;
 	char *presume_name;
 	unsigned int resume_name_len;
-	unsigned endOfSearch:1;
-	unsigned emptyDir:1;
-	unsigned unicode:1;
-	unsigned smallBuf:1; /* so we know which buf_release function to call */
+	bool endOfSearch:1;
+	bool emptyDir:1;
+	bool unicode:1;
+	bool smallBuf:1; /* so we know which buf_release function to call */
 };
 
 struct cifsFileInfo {
@@ -335,9 +327,9 @@ struct cifsFileInfo {
 	struct inode *pInode; /* needed for oplock break */
 	struct mutex lock_mutex;
 	struct list_head llist; /* list of byte range locks we have. */
-	unsigned closePend:1;	/* file is marked to close */
-	unsigned invalidHandle:1;  /* file closed via session abend */
-	unsigned messageMode:1;    /* for pipes: message vs byte mode */
+	bool closePend:1;	/* file is marked to close */
+	bool invalidHandle:1;	/* file closed via session abend */
+	bool messageMode:1;	/* for pipes: message vs byte mode */
 	atomic_t wrtPending;   /* handle in use - defer close */
 	struct semaphore fh_sem; /* prevents reopen race after dead ses*/
 	char *search_resume_name; /* BB removeme BB */
@@ -356,9 +348,9 @@ struct cifsInodeInfo {
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
 	atomic_t inUse;	 /* num concurrent users (local openers cifs) of file*/
 	unsigned long time;	/* jiffies of last update/check of inode */
-	unsigned clientCanCacheRead:1; /* read oplock */
-	unsigned clientCanCacheAll:1;  /* read and writebehind oplock */
-	unsigned oplockPending:1;
+	bool clientCanCacheRead:1;	/* read oplock */
+	bool clientCanCacheAll:1;	/* read and writebehind oplock */
+	bool oplockPending:1;
 	struct inode vfs_inode;
 };
 
@@ -426,9 +418,9 @@ struct mid_q_entry {
 	struct smb_hdr *resp_buf;	/* response buffer */
 	int midState;	/* wish this were enum but can not pass to wait_event */
 	__u8 command;	/* smb command code */
-	unsigned largeBuf:1;    /* if valid response, is pointer to large buf */
-	unsigned multiRsp:1;   /* multiple trans2 responses for one request  */
-	unsigned multiEnd:1; /* both received */
+	bool largeBuf:1;	/* if valid response, is pointer to large buf */
+	bool multiRsp:1;	/* multiple trans2 responses for one request  */
+	bool multiEnd:1;	/* both received */
 };
 
 struct oplock_q_entry {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index eaec2fd..26d33d0 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -59,8 +59,9 @@ extern int SendReceiveBlockingLock(const unsigned int xid,
 			struct smb_hdr *out_buf,
 			int *bytes_returned);
 extern int checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length);
-extern int is_valid_oplock_break(struct smb_hdr *smb, struct TCP_Server_Info *);
-extern int is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
+extern bool is_valid_oplock_break(struct smb_hdr *smb,
+				  struct TCP_Server_Info *);
+extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
 extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *);
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *);
@@ -189,11 +190,11 @@ extern int CIFSSMBSetAttrLegacy(int xid, struct cifsTconInfo *tcon,
 #endif /* possibly unneeded function */
 extern int CIFSSMBSetEOF(const int xid, struct cifsTconInfo *tcon,
 			const char *fileName, __u64 size,
-			int setAllocationSizeFlag,
+			bool setAllocationSizeFlag,
 			const struct nls_table *nls_codepage, int cifs_flags);
 extern int CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon,
 			 __u64 size, __u16 fileHandle, __u32 opener_pid,
-			int AllocSizeFlag);
+			bool AllocSizeFlag);
 extern int CIFSSMBUnixSetPerms(const int xid, struct cifsTconInfo *pTcon,
 			char *full_path, __u64 mode, __u64 uid,
 			__u64 gid, dev_t dev,
@@ -283,11 +284,11 @@ extern int CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 			const __u16 netfid, const __u64 len,
 			const __u64 offset, const __u32 numUnlock,
 			const __u32 numLock, const __u8 lockType,
-			const int waitFlag);
+			const bool waitFlag);
 extern int CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
 			const __u16 smb_file_id, const int get_flag,
 			const __u64 len, struct file_lock *,
-			const __u16 lock_type, const int waitFlag);
+			const __u16 lock_type, const bool waitFlag);
 extern int CIFSSMBTDis(const int xid, struct cifsTconInfo *tcon);
 extern int CIFSSMBLogoff(const int xid, struct cifsSesInfo *ses);
 
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 222387c..ee59e93 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -95,7 +95,7 @@ static void mark_open_files_invalid(struct cifsTconInfo *pTcon)
 	list_for_each_safe(tmp, tmp1, &pTcon->openFileList) {
 		open_file = list_entry(tmp, struct cifsFileInfo, tlist);
 		if (open_file)
-			open_file->invalidHandle = TRUE;
+			open_file->invalidHandle = true;
 	}
 	write_unlock(&GlobalSMBSeslock);
 	/* BB Add call to invalidate_inodes(sb) for all superblocks mounted
@@ -141,7 +141,7 @@ small_smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
 				if (tcon->ses->server->tcpStatus ==
 							CifsNeedReconnect) {
 					/* on "soft" mounts we wait once */
-					if ((tcon->retry == FALSE) ||
+					if (!tcon->retry ||
 					   (tcon->ses->status == CifsExiting)) {
 						cFYI(1, ("gave up waiting on "
 						      "reconnect in smb_init"));
@@ -287,7 +287,7 @@ smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
 				if (tcon->ses->server->tcpStatus ==
 						CifsNeedReconnect) {
 					/* on "soft" mounts we wait once */
-					if ((tcon->retry == FALSE) ||
+					if (!tcon->retry ||
 					   (tcon->ses->status == CifsExiting)) {
 						cFYI(1, ("gave up waiting on "
 						      "reconnect in smb_init"));
@@ -1686,7 +1686,7 @@ int
 CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 	    const __u16 smb_file_id, const __u64 len,
 	    const __u64 offset, const __u32 numUnlock,
-	    const __u32 numLock, const __u8 lockType, const int waitFlag)
+	    const __u32 numLock, const __u8 lockType, const bool waitFlag)
 {
 	int rc = 0;
 	LOCK_REQ *pSMB = NULL;
@@ -1695,7 +1695,7 @@ CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 	int timeout = 0;
 	__u16 count;
 
-	cFYI(1, ("CIFSSMBLock timeout %d numLock %d", waitFlag, numLock));
+	cFYI(1, ("CIFSSMBLock timeout %d numLock %d", (int)waitFlag, numLock));
 	rc = small_smb_init(SMB_COM_LOCKING_ANDX, 8, tcon, (void **) &pSMB);
 
 	if (rc)
@@ -1706,7 +1706,7 @@ CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 	if (lockType == LOCKING_ANDX_OPLOCK_RELEASE) {
 		timeout = CIFS_ASYNC_OP; /* no response expected */
 		pSMB->Timeout = 0;
-	} else if (waitFlag == TRUE) {
+	} else if (waitFlag) {
 		timeout = CIFS_BLOCKING_OP; /* blocking operation, no timeout */
 		pSMB->Timeout = cpu_to_le32(-1);/* blocking - do not time out */
 	} else {
@@ -1756,7 +1756,7 @@ int
 CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
 		const __u16 smb_file_id, const int get_flag, const __u64 len,
 		struct file_lock *pLockData, const __u16 lock_type,
-		const int waitFlag)
+		const bool waitFlag)
 {
 	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
 	struct smb_com_transaction2_sfi_rsp *pSMBr = NULL;
@@ -3584,9 +3584,9 @@ findFirstRetry:
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 		if (rc == 0) {
 			if (pSMBr->hdr.Flags2 & SMBFLG2_UNICODE)
-				psrch_inf->unicode = TRUE;
+				psrch_inf->unicode = true;
 			else
-				psrch_inf->unicode = FALSE;
+				psrch_inf->unicode = false;
 
 			psrch_inf->ntwrk_buf_start = (char *)pSMBr;
 			psrch_inf->smallBuf = 0;
@@ -3597,9 +3597,9 @@ findFirstRetry:
 			       le16_to_cpu(pSMBr->t2.ParameterOffset));
 
 			if (parms->EndofSearch)
-				psrch_inf->endOfSearch = TRUE;
+				psrch_inf->endOfSearch = true;
 			else
-				psrch_inf->endOfSearch = FALSE;
+				psrch_inf->endOfSearch = false;
 
 			psrch_inf->entries_in_buffer =
 					le16_to_cpu(parms->SearchCount);
@@ -3627,7 +3627,7 @@ int CIFSFindNext(const int xid, struct cifsTconInfo *tcon,
 
 	cFYI(1, ("In FindNext"));
 
-	if (psrch_inf->endOfSearch == TRUE)
+	if (psrch_inf->endOfSearch)
 		return -ENOENT;
 
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
@@ -3685,7 +3685,7 @@ int CIFSFindNext(const int xid, struct cifsTconInfo *tcon,
 	cifs_stats_inc(&tcon->num_fnext);
 	if (rc) {
 		if (rc == -EBADF) {
-			psrch_inf->endOfSearch = TRUE;
+			psrch_inf->endOfSearch = true;
 			rc = 0; /* search probably was closed at end of search*/
 		} else
 			cFYI(1, ("FindNext returned = %d", rc));
@@ -3695,9 +3695,9 @@ int CIFSFindNext(const int xid, struct cifsTconInfo *tcon,
 		if (rc == 0) {
 			/* BB fixme add lock for file (srch_info) struct here */
 			if (pSMBr->hdr.Flags2 & SMBFLG2_UNICODE)
-				psrch_inf->unicode = TRUE;
+				psrch_inf->unicode = true;
 			else
-				psrch_inf->unicode = FALSE;
+				psrch_inf->unicode = false;
 			response_data = (char *) &pSMBr->hdr.Protocol +
 			       le16_to_cpu(pSMBr->t2.ParameterOffset);
 			parms = (T2_FNEXT_RSP_PARMS *)response_data;
@@ -3712,9 +3712,9 @@ int CIFSFindNext(const int xid, struct cifsTconInfo *tcon,
 			psrch_inf->ntwrk_buf_start = (char *)pSMB;
 			psrch_inf->smallBuf = 0;
 			if (parms->EndofSearch)
-				psrch_inf->endOfSearch = TRUE;
+				psrch_inf->endOfSearch = true;
 			else
-				psrch_inf->endOfSearch = FALSE;
+				psrch_inf->endOfSearch = false;
 			psrch_inf->entries_in_buffer =
 						le16_to_cpu(parms->SearchCount);
 			psrch_inf->index_of_last_entry +=
@@ -4590,7 +4590,7 @@ QFSPosixRetry:
 
 int
 CIFSSMBSetEOF(const int xid, struct cifsTconInfo *tcon, const char *fileName,
-	      __u64 size, int SetAllocation,
+	      __u64 size, bool SetAllocation,
 	      const struct nls_table *nls_codepage, int cifs_flags)
 {
 	struct smb_com_transaction2_spi_req *pSMB = NULL;
@@ -4679,7 +4679,7 @@ SetEOFRetry:
 
 int
 CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon, __u64 size,
-		   __u16 fid, __u32 pid_of_opener, int SetAllocation)
+		   __u16 fid, __u32 pid_of_opener, bool SetAllocation)
 {
 	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
 	char *data_offset;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a951c63..7c0e1ac 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -71,23 +71,23 @@ struct smb_vol {
 	mode_t file_mode;
 	mode_t dir_mode;
 	unsigned secFlg;
-	unsigned rw:1;
-	unsigned retry:1;
-	unsigned intr:1;
-	unsigned setuids:1;
-	unsigned override_uid:1;
-	unsigned override_gid:1;
-	unsigned noperm:1;
-	unsigned no_psx_acl:1; /* set if posix acl support should be disabled */
-	unsigned cifs_acl:1;
-	unsigned no_xattr:1;   /* set if xattr (EA) support should be disabled*/
-	unsigned server_ino:1; /* use inode numbers from server ie UniqueId */
-	unsigned direct_io:1;
-	unsigned remap:1;   /* set to remap seven reserved chars in filenames */
-	unsigned posix_paths:1;   /* unset to not ask for posix pathnames. */
-	unsigned no_linux_ext:1;
-	unsigned sfu_emul:1;
-	unsigned nullauth:1; /* attempt to authenticate with null user */
+	bool rw:1;
+	bool retry:1;
+	bool intr:1;
+	bool setuids:1;
+	bool override_uid:1;
+	bool override_gid:1;
+	bool noperm:1;
+	bool no_psx_acl:1; /* set if posix acl support should be disabled */
+	bool cifs_acl:1;
+	bool no_xattr:1;   /* set if xattr (EA) support should be disabled*/
+	bool server_ino:1; /* use inode numbers from server ie UniqueId */
+	bool direct_io:1;
+	bool remap:1;     /* set to remap seven reserved chars in filenames */
+	bool posix_paths:1;   /* unset to not ask for posix pathnames. */
+	bool no_linux_ext:1;
+	bool sfu_emul:1;
+	bool nullauth:1; /* attempt to authenticate with null user */
 	unsigned nocase;     /* request case insensitive filenames */
 	unsigned nobrl;      /* disable sending byte range locks to srv */
 	unsigned int rsize;
@@ -345,8 +345,8 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mid_entry;
 	char temp;
-	int isLargeBuf = FALSE;
-	int isMultiRsp;
+	bool isLargeBuf = false;
+	bool isMultiRsp;
 	int reconnect;
 
 	current->flags |= PF_MEMALLOC;
@@ -390,8 +390,8 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 		} else /* if existing small buf clear beginning */
 			memset(smallbuf, 0, sizeof(struct smb_hdr));
 
-		isLargeBuf = FALSE;
-		isMultiRsp = FALSE;
+		isLargeBuf = false;
+		isMultiRsp = false;
 		smb_buffer = smallbuf;
 		iov.iov_base = smb_buffer;
 		iov.iov_len = 4;
@@ -517,7 +517,7 @@ incomplete_rcv:
 		reconnect = 0;
 
 		if (pdu_length > MAX_CIFS_SMALL_BUFFER_SIZE - 4) {
-			isLargeBuf = TRUE;
+			isLargeBuf = true;
 			memcpy(bigbuf, smallbuf, 4);
 			smb_buffer = bigbuf;
 		}
@@ -582,16 +582,18 @@ incomplete_rcv:
 			    (mid_entry->command == smb_buffer->Command)) {
 				if (check2ndT2(smb_buffer,server->maxBuf) > 0) {
 					/* We have a multipart transact2 resp */
-					isMultiRsp = TRUE;
+					isMultiRsp = true;
 					if (mid_entry->resp_buf) {
 						/* merge response - fix up 1st*/
 						if (coalesce_t2(smb_buffer,
 							mid_entry->resp_buf)) {
-							mid_entry->multiRsp = 1;
+							mid_entry->multiRsp =
+								 true;
 							break;
 						} else {
 							/* all parts received */
-							mid_entry->multiEnd = 1;
+							mid_entry->multiEnd =
+								 true;
 							goto multi_t2_fnd;
 						}
 					} else {
@@ -603,17 +605,15 @@ incomplete_rcv:
 							/* Have first buffer */
 							mid_entry->resp_buf =
 								 smb_buffer;
-							mid_entry->largeBuf = 1;
+							mid_entry->largeBuf = 
+								 true;
 							bigbuf = NULL;
 						}
 					}
 					break;
 				}
 				mid_entry->resp_buf = smb_buffer;
-				if (isLargeBuf)
-					mid_entry->largeBuf = 1;
-				else
-					mid_entry->largeBuf = 0;
+				mid_entry->largeBuf = isLargeBuf;
 multi_t2_fnd:
 				task_to_wake = mid_entry->tsk;
 				mid_entry->midState = MID_RESPONSE_RECEIVED;
@@ -638,8 +638,8 @@ multi_t2_fnd:
 					smallbuf = NULL;
 			}
 			wake_up_process(task_to_wake);
-		} else if ((is_valid_oplock_break(smb_buffer, server) == FALSE)
-		    && (isMultiRsp == FALSE)) {
+		} else if (!is_valid_oplock_break(smb_buffer, server) &&
+			   !isMultiRsp) {
 			cERROR(1, ("No task to wake, unknown frame received! "
 				   "NumMids %d", midCount.counter));
 			cifs_dump_mem("Received Data is: ", (char *)smb_buffer,
@@ -825,7 +825,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 	vol->file_mode = (S_IRWXUGO | S_ISGID) & (~S_IXGRP);
 
 	/* vol->retry default is 0 (i.e. "soft" limited retry not hard retry) */
-	vol->rw = TRUE;
+	vol->rw = true;
 	/* default is always to request posix paths. */
 	vol->posix_paths = 1;
 
@@ -1181,7 +1181,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 		} else if (strnicmp(data, "guest", 5) == 0) {
 			/* ignore */
 		} else if (strnicmp(data, "rw", 2) == 0) {
-			vol->rw = TRUE;
+			vol->rw = true;
 		} else if ((strnicmp(data, "suid", 4) == 0) ||
 				   (strnicmp(data, "nosuid", 6) == 0) ||
 				   (strnicmp(data, "exec", 4) == 0) ||
@@ -1197,7 +1197,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 			    is ok to just ignore them */
 			continue;
 		} else if (strnicmp(data, "ro", 2) == 0) {
-			vol->rw = FALSE;
+			vol->rw = false;
 		} else if (strnicmp(data, "hard", 4) == 0) {
 			vol->retry = 1;
 		} else if (strnicmp(data, "soft", 4) == 0) {
@@ -2601,7 +2601,7 @@ sesssetup_nomem:	/* do not return an error on nomem for the info strings,
 
 static int
 CIFSNTLMSSPNegotiateSessSetup(unsigned int xid,
-			      struct cifsSesInfo *ses, int *pNTLMv2_flag,
+			      struct cifsSesInfo *ses, bool *pNTLMv2_flag,
 			      const struct nls_table *nls_codepage)
 {
 	struct smb_hdr *smb_buffer;
@@ -2624,7 +2624,7 @@ CIFSNTLMSSPNegotiateSessSetup(unsigned int xid,
 	if (ses == NULL)
 		return -EINVAL;
 	domain = ses->domainName;
-	*pNTLMv2_flag = FALSE;
+	*pNTLMv2_flag = false;
 	smb_buffer = cifs_buf_get();
 	if (smb_buffer == NULL) {
 		return -ENOMEM;
@@ -2777,7 +2777,7 @@ CIFSNTLMSSPNegotiateSessSetup(unsigned int xid,
 				       CIFS_CRYPTO_KEY_SIZE);
 				if (SecurityBlob2->NegotiateFlags &
 					cpu_to_le32(NTLMSSP_NEGOTIATE_NTLMV2))
-					*pNTLMv2_flag = TRUE;
+					*pNTLMv2_flag = true;
 
 				if ((SecurityBlob2->NegotiateFlags &
 					cpu_to_le32(NTLMSSP_NEGOTIATE_ALWAYS_SIGN))
@@ -2938,7 +2938,7 @@ CIFSNTLMSSPNegotiateSessSetup(unsigned int xid,
 }
 static int
 CIFSNTLMSSPAuthSessSetup(unsigned int xid, struct cifsSesInfo *ses,
-			char *ntlm_session_key, int ntlmv2_flag,
+			char *ntlm_session_key, bool ntlmv2_flag,
 			const struct nls_table *nls_codepage)
 {
 	struct smb_hdr *smb_buffer;
@@ -3567,7 +3567,7 @@ int cifs_setup_session(unsigned int xid, struct cifsSesInfo *pSesInfo,
 {
 	int rc = 0;
 	char ntlm_session_key[CIFS_SESS_KEY_SIZE];
-	int ntlmv2_flag = FALSE;
+	bool ntlmv2_flag = false;
 	int first_time = 0;
 
 	/* what if server changes its buffer size after dropping the session? */
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 15fe3b4..6850199 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -130,7 +130,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 	struct cifsFileInfo *pCifsFile = NULL;
 	struct cifsInodeInfo *pCifsInode;
 	int disposition = FILE_OVERWRITE_IF;
-	int write_only = FALSE;
+	bool write_only = false;
 
 	xid = GetXid();
 
@@ -152,7 +152,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 		if (oflags & FMODE_WRITE) {
 			desiredAccess |= GENERIC_WRITE;
 			if (!(oflags & FMODE_READ))
-				write_only = TRUE;
+				write_only = true;
 		}
 
 		if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
@@ -252,7 +252,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 			d_instantiate(direntry, newinode);
 		}
 		if ((nd == NULL /* nfsd case - nfs srv does not set nd */) ||
-			((nd->flags & LOOKUP_OPEN) == FALSE)) {
+			(!(nd->flags & LOOKUP_OPEN))) {
 			/* mknod case - do not leave file open */
 			CIFSSMBClose(xid, pTcon, fileHandle);
 		} else if (newinode) {
@@ -264,8 +264,8 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 			pCifsFile->netfid = fileHandle;
 			pCifsFile->pid = current->tgid;
 			pCifsFile->pInode = newinode;
-			pCifsFile->invalidHandle = FALSE;
-			pCifsFile->closePend     = FALSE;
+			pCifsFile->invalidHandle = false;
+			pCifsFile->closePend     = false;
 			init_MUTEX(&pCifsFile->fh_sem);
 			mutex_init(&pCifsFile->lock_mutex);
 			INIT_LIST_HEAD(&pCifsFile->llist);
@@ -278,7 +278,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 			pCifsInode = CIFS_I(newinode);
 			if (pCifsInode) {
 				/* if readable file instance put first in list*/
-				if (write_only == TRUE) {
+				if (write_only) {
 					list_add_tail(&pCifsFile->flist,
 						&pCifsInode->openFileList);
 				} else {
@@ -286,12 +286,12 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 						&pCifsInode->openFileList);
 				}
 				if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
-					pCifsInode->clientCanCacheAll = TRUE;
-					pCifsInode->clientCanCacheRead = TRUE;
+					pCifsInode->clientCanCacheAll = true;
+					pCifsInode->clientCanCacheRead = true;
 					cFYI(1, ("Exclusive Oplock inode %p",
 						newinode));
 				} else if ((oplock & 0xF) == OPLOCK_READ)
-					pCifsInode->clientCanCacheRead = TRUE;
+					pCifsInode->clientCanCacheRead = true;
 			}
 			write_unlock(&GlobalSMBSeslock);
 		}
diff --git a/fs/cifs/fcntl.c b/fs/cifs/fcntl.c
index d345b0b..a7cd331 100644
--- a/fs/cifs/fcntl.c
+++ b/fs/cifs/fcntl.c
@@ -68,7 +68,7 @@ int cifs_dir_notify(struct file *file, unsigned long arg)
 {
 	int xid;
 	int rc = -EINVAL;
-	int oplock = FALSE;
+	int oplock = 0;
 	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *pTcon;
 	char *full_path = NULL;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b0e7795..2c3a099 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -51,8 +51,8 @@ static inline struct cifsFileInfo *cifs_init_private(
 	INIT_LIST_HEAD(&private_data->llist);
 	private_data->pfile = file; /* needed for writepage */
 	private_data->pInode = inode;
-	private_data->invalidHandle = FALSE;
-	private_data->closePend = FALSE;
+	private_data->invalidHandle = false;
+	private_data->closePend = false;
 	/* we have to track num writers to the inode, since writepages
 	does not tell us which handle the write is for so there can
 	be a close (overlapping with write) of the filehandle that
@@ -148,12 +148,12 @@ client_can_cache:
 			full_path, buf, inode->i_sb, xid);
 
 	if ((*oplock & 0xF) == OPLOCK_EXCLUSIVE) {
-		pCifsInode->clientCanCacheAll = TRUE;
-		pCifsInode->clientCanCacheRead = TRUE;
+		pCifsInode->clientCanCacheAll = true;
+		pCifsInode->clientCanCacheRead = true;
 		cFYI(1, ("Exclusive Oplock granted on inode %p",
 			 file->f_path.dentry->d_inode));
 	} else if ((*oplock & 0xF) == OPLOCK_READ)
-		pCifsInode->clientCanCacheRead = TRUE;
+		pCifsInode->clientCanCacheRead = true;
 
 	return rc;
 }
@@ -247,7 +247,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	if (oplockEnabled)
 		oplock = REQ_OPLOCK;
 	else
-		oplock = FALSE;
+		oplock = 0;
 
 	/* BB pass O_SYNC flag through on file attributes .. BB */
 
@@ -338,7 +338,7 @@ static int cifs_relock_file(struct cifsFileInfo *cifsFile)
 	return rc;
 }
 
-static int cifs_reopen_file(struct file *file, int can_flush)
+static int cifs_reopen_file(struct file *file, bool can_flush)
 {
 	int rc = -EACCES;
 	int xid, oplock;
@@ -359,7 +359,7 @@ static int cifs_reopen_file(struct file *file, int can_flush)
 
 	xid = GetXid();
 	down(&pCifsFile->fh_sem);
-	if (pCifsFile->invalidHandle == FALSE) {
+	if (!pCifsFile->invalidHandle) {
 		up(&pCifsFile->fh_sem);
 		FreeXid(xid);
 		return 0;
@@ -403,7 +403,7 @@ reopen_error_exit:
 	if (oplockEnabled)
 		oplock = REQ_OPLOCK;
 	else
-		oplock = FALSE;
+		oplock = 0;
 
 	/* Can not refresh inode by passing in file_info buf to be returned
 	   by SMBOpen and then calling get_inode_info with returned buf
@@ -420,7 +420,7 @@ reopen_error_exit:
 		cFYI(1, ("oplock: %d", oplock));
 	} else {
 		pCifsFile->netfid = netfid;
-		pCifsFile->invalidHandle = FALSE;
+		pCifsFile->invalidHandle = false;
 		up(&pCifsFile->fh_sem);
 		pCifsInode = CIFS_I(inode);
 		if (pCifsInode) {
@@ -430,8 +430,8 @@ reopen_error_exit:
 					CIFS_I(inode)->write_behind_rc = rc;
 			/* temporarily disable caching while we
 			   go to server to get inode info */
-				pCifsInode->clientCanCacheAll = FALSE;
-				pCifsInode->clientCanCacheRead = FALSE;
+				pCifsInode->clientCanCacheAll = false;
+				pCifsInode->clientCanCacheRead = false;
 				if (pTcon->unix_ext)
 					rc = cifs_get_inode_info_unix(&inode,
 						full_path, inode->i_sb, xid);
@@ -446,16 +446,16 @@ reopen_error_exit:
 			     we can not go to the server to get the new inod
 			     info */
 			if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
-				pCifsInode->clientCanCacheAll = TRUE;
-				pCifsInode->clientCanCacheRead = TRUE;
+				pCifsInode->clientCanCacheAll = true;
+				pCifsInode->clientCanCacheRead = true;
 				cFYI(1, ("Exclusive Oplock granted on inode %p",
 					 file->f_path.dentry->d_inode));
 			} else if ((oplock & 0xF) == OPLOCK_READ) {
-				pCifsInode->clientCanCacheRead = TRUE;
-				pCifsInode->clientCanCacheAll = FALSE;
+				pCifsInode->clientCanCacheRead = true;
+				pCifsInode->clientCanCacheAll = false;
 			} else {
-				pCifsInode->clientCanCacheRead = FALSE;
-				pCifsInode->clientCanCacheAll = FALSE;
+				pCifsInode->clientCanCacheRead = false;
+				pCifsInode->clientCanCacheAll = false;
 			}
 			cifs_relock_file(pCifsFile);
 		}
@@ -482,7 +482,7 @@ int cifs_close(struct inode *inode, struct file *file)
 	if (pSMBFile) {
 		struct cifsLockInfo *li, *tmp;
 
-		pSMBFile->closePend = TRUE;
+		pSMBFile->closePend = true;
 		if (pTcon) {
 			/* no sense reconnecting to close a file that is
 			   already closed */
@@ -551,8 +551,8 @@ int cifs_close(struct inode *inode, struct file *file)
 		cFYI(1, ("closing last open instance for inode %p", inode));
 		/* if the file is not open we do not know if we can cache info
 		   on this inode, much less write behind and read ahead */
-		CIFS_I(inode)->clientCanCacheRead = FALSE;
-		CIFS_I(inode)->clientCanCacheAll  = FALSE;
+		CIFS_I(inode)->clientCanCacheRead = false;
+		CIFS_I(inode)->clientCanCacheAll  = false;
 	}
 	read_unlock(&GlobalSMBSeslock);
 	if ((rc == 0) && CIFS_I(inode)->write_behind_rc)
@@ -581,9 +581,9 @@ int cifs_closedir(struct inode *inode, struct file *file)
 		pTcon = cifs_sb->tcon;
 
 		cFYI(1, ("Freeing private data in close dir"));
-		if ((pCFileStruct->srch_inf.endOfSearch == FALSE) &&
-		   (pCFileStruct->invalidHandle == FALSE)) {
-			pCFileStruct->invalidHandle = TRUE;
+		if (!pCFileStruct->srch_inf.endOfSearch &&
+		    !pCFileStruct->invalidHandle) {
+			pCFileStruct->invalidHandle = true;
 			rc = CIFSFindClose(xid, pTcon, pCFileStruct->netfid);
 			cFYI(1, ("Closing uncompleted readdir with rc %d",
 				 rc));
@@ -635,12 +635,12 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 	__u32 numLock = 0;
 	__u32 numUnlock = 0;
 	__u64 length;
-	int wait_flag = FALSE;
+	bool wait_flag = false;
 	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *pTcon;
 	__u16 netfid;
 	__u8 lockType = LOCKING_ANDX_LARGE_FILES;
-	int posix_locking;
+	bool posix_locking;
 
 	length = 1 + pfLock->fl_end - pfLock->fl_start;
 	rc = -EACCES;
@@ -657,7 +657,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 		cFYI(1, ("Flock"));
 	if (pfLock->fl_flags & FL_SLEEP) {
 		cFYI(1, ("Blocking lock"));
-		wait_flag = TRUE;
+		wait_flag = true;
 	}
 	if (pfLock->fl_flags & FL_ACCESS)
 		cFYI(1, ("Process suspended by mandatory locking - "
@@ -792,7 +792,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 					stored_rc = CIFSSMBLock(xid, pTcon,
 							netfid,
 							li->length, li->offset,
-							1, 0, li->type, FALSE);
+							1, 0, li->type, false);
 					if (stored_rc)
 						rc = stored_rc;
 
@@ -864,7 +864,7 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 				   filemap_fdatawait from here so tell
 				   reopen_file not to flush data to server
 				   now */
-				rc = cifs_reopen_file(file, FALSE);
+				rc = cifs_reopen_file(file, false);
 				if (rc != 0)
 					break;
 			}
@@ -964,7 +964,7 @@ static ssize_t cifs_write(struct file *file, const char *write_data,
 				   filemap_fdatawait from here so tell
 				   reopen_file not to flush data to
 				   server now */
-				rc = cifs_reopen_file(file, FALSE);
+				rc = cifs_reopen_file(file, false);
 				if (rc != 0)
 					break;
 			}
@@ -1091,7 +1091,7 @@ refind_writable:
 
 			read_unlock(&GlobalSMBSeslock);
 			/* Had to unlock since following call can block */
-			rc = cifs_reopen_file(open_file->pfile, FALSE);
+			rc = cifs_reopen_file(open_file->pfile, false);
 			if (!rc) {
 				if (!open_file->closePend)
 					return open_file;
@@ -1606,7 +1606,7 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
 			int buf_type = CIFS_NO_BUFFER;
 			if ((open_file->invalidHandle) &&
 			    (!open_file->closePend)) {
-				rc = cifs_reopen_file(file, TRUE);
+				rc = cifs_reopen_file(file, true);
 				if (rc != 0)
 					break;
 			}
@@ -1691,7 +1691,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 		while (rc == -EAGAIN) {
 			if ((open_file->invalidHandle) &&
 			    (!open_file->closePend)) {
-				rc = cifs_reopen_file(file, TRUE);
+				rc = cifs_reopen_file(file, true);
 				if (rc != 0)
 					break;
 			}
@@ -1848,7 +1848,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		while (rc == -EAGAIN) {
 			if ((open_file->invalidHandle) &&
 			    (!open_file->closePend)) {
-				rc = cifs_reopen_file(file, TRUE);
+				rc = cifs_reopen_file(file, true);
 				if (rc != 0)
 					break;
 			}
@@ -2007,10 +2007,10 @@ static int is_inode_writable(struct cifsInodeInfo *cifs_inode)
    refreshing the inode only on increases in the file size
    but this is tricky to do without racing with writebehind
    page caching in the current Linux kernel design */
-int is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file)
+bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file)
 {
 	if (!cifsInode)
-		return 1;
+		return true;
 
 	if (is_inode_writable(cifsInode)) {
 		/* This inode is open for write at least once */
@@ -2020,15 +2020,15 @@ int is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file)
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO) {
 			/* since no page cache to corrupt on directio
 			we can change size safely */
-			return 1;
+			return true;
 		}
 
 		if (i_size_read(&cifsInode->vfs_inode) < end_of_file)
-			return 1;
+			return true;
 
-		return 0;
+		return false;
 	} else
-		return 1;
+		return true;
 }
 
 static int cifs_prepare_write(struct file *file, struct page *page,
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 13c728f..d247558 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -245,7 +245,7 @@ static int decode_sfu_inode(struct inode *inode, __u64 size,
 			    struct cifs_sb_info *cifs_sb, int xid)
 {
 	int rc;
-	int oplock = FALSE;
+	int oplock = 0;
 	__u16 netfid;
 	struct cifsTconInfo *pTcon = cifs_sb->tcon;
 	char buf[24];
@@ -353,7 +353,7 @@ int cifs_get_inode_info(struct inode **pinode,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	char *tmp_path;
 	char *buf = NULL;
-	int adjustTZ = FALSE;
+	bool adjustTZ = false;
 
 	pTcon = cifs_sb->tcon;
 	cFYI(1, ("Getting info on %s", search_path));
@@ -383,7 +383,7 @@ int cifs_get_inode_info(struct inode **pinode,
 			rc = SMBQueryInformation(xid, pTcon, search_path,
 						 pfindData, cifs_sb->local_nls,
 						 cifs_sb->mnt_cifs_flags);
-			adjustTZ = TRUE;
+			adjustTZ = true;
 		}
 	}
 	/* dump_mem("\nQPathInfo return data",&findData, sizeof(findData)); */
@@ -672,7 +672,7 @@ psx_del_no_retry:
 	} else if (rc == -ENOENT) {
 		d_drop(direntry);
 	} else if (rc == -ETXTBSY) {
-		int oplock = FALSE;
+		int oplock = 0;
 		__u16 netfid;
 
 		rc = CIFSSMBOpen(xid, pTcon, full_path, FILE_OPEN, DELETE,
@@ -702,7 +702,7 @@ psx_del_no_retry:
 				rc = -EOPNOTSUPP;
 
 			if (rc == -EOPNOTSUPP) {
-				int oplock = FALSE;
+				int oplock = 0;
 				__u16 netfid;
 			/*	rc = CIFSSMBSetAttrLegacy(xid, pTcon,
 							  full_path,
@@ -738,7 +738,7 @@ psx_del_no_retry:
 				if (direntry->d_inode)
 					drop_nlink(direntry->d_inode);
 			} else if (rc == -ETXTBSY) {
-				int oplock = FALSE;
+				int oplock = 0;
 				__u16 netfid;
 
 				rc = CIFSSMBOpen(xid, pTcon, full_path,
@@ -1103,7 +1103,7 @@ int cifs_rename(struct inode *source_inode, struct dentry *source_direntry,
 		cFYI(1, ("rename rc %d", rc));
 
 	if ((rc == -EIO) || (rc == -EEXIST)) {
-		int oplock = FALSE;
+		int oplock = 0;
 		__u16 netfid;
 
 		/* BB FIXME Is Generic Read correct for rename? */
@@ -1138,7 +1138,7 @@ int cifs_revalidate(struct dentry *direntry)
 	struct cifsInodeInfo *cifsInode;
 	loff_t local_size;
 	struct timespec local_mtime;
-	int invalidate_inode = FALSE;
+	bool invalidate_inode = false;
 
 	if (direntry->d_inode == NULL)
 		return -ENOENT;
@@ -1220,7 +1220,7 @@ int cifs_revalidate(struct dentry *direntry)
 			   only ones who could have modified the file and the
 			   server copy is staler than ours */
 		} else {
-			invalidate_inode = TRUE;
+			invalidate_inode = true;
 		}
 	}
 
@@ -1354,8 +1354,8 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 	int rc = -EACCES;
 	struct cifsFileInfo *open_file = NULL;
 	FILE_BASIC_INFO time_buf;
-	int set_time = FALSE;
-	int set_dosattr = FALSE;
+	bool set_time = false;
+	bool set_dosattr = false;
 	__u64 mode = 0xFFFFFFFFFFFFFFFFULL;
 	__u64 uid = 0xFFFFFFFFFFFFFFFFULL;
 	__u64 gid = 0xFFFFFFFFFFFFFFFFULL;
@@ -1415,7 +1415,7 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 			__u16 nfid = open_file->netfid;
 			__u32 npid = open_file->pid;
 			rc = CIFSSMBSetFileSize(xid, pTcon, attrs->ia_size,
-						nfid, npid, FALSE);
+						nfid, npid, false);
 			atomic_dec(&open_file->wrtPending);
 			cFYI(1, ("SetFSize for attrs rc = %d", rc));
 			if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
@@ -1435,13 +1435,13 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 			   it was found or because there was an error setting
 			   it by handle */
 			rc = CIFSSMBSetEOF(xid, pTcon, full_path,
-					   attrs->ia_size, FALSE,
+					   attrs->ia_size, false,
 					   cifs_sb->local_nls,
 					   cifs_sb->mnt_cifs_flags);
 			cFYI(1, ("SetEOF by path (setattrs) rc = %d", rc));
 			if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
 				__u16 netfid;
-				int oplock = FALSE;
+				int oplock = 0;
 
 				rc = SMBLegacyOpen(xid, pTcon, full_path,
 					FILE_OPEN,
@@ -1465,7 +1465,7 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 
 		/* Server is ok setting allocation size implicitly - no need
 		   to call:
-		CIFSSMBSetEOF(xid, pTcon, full_path, attrs->ia_size, TRUE,
+		CIFSSMBSetEOF(xid, pTcon, full_path, attrs->ia_size, true,
 			 cifs_sb->local_nls);
 		   */
 
@@ -1512,7 +1512,7 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 #endif
 			/* not writeable */
 			if ((cifsInode->cifsAttrs & ATTR_READONLY) == 0) {
-				set_dosattr = TRUE;
+				set_dosattr = true;
 				time_buf.Attributes =
 					cpu_to_le32(cifsInode->cifsAttrs |
 						    ATTR_READONLY);
@@ -1522,7 +1522,7 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 			not be able to write to it - so if any write
 			bit is enabled for user or group or other we
 			need to at least try to remove r/o dos attr */
-			set_dosattr = TRUE;
+			set_dosattr = true;
 			time_buf.Attributes = cpu_to_le32(cifsInode->cifsAttrs &
 					    (~ATTR_READONLY));
 			/* Windows ignores set to zero */
@@ -1536,14 +1536,14 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 	}
 
 	if (attrs->ia_valid & ATTR_ATIME) {
-		set_time = TRUE;
+		set_time = true;
 		time_buf.LastAccessTime =
 		    cpu_to_le64(cifs_UnixTimeToNT(attrs->ia_atime));
 	} else
 		time_buf.LastAccessTime = 0;
 
 	if (attrs->ia_valid & ATTR_MTIME) {
-		set_time = TRUE;
+		set_time = true;
 		time_buf.LastWriteTime =
 		    cpu_to_le64(cifs_UnixTimeToNT(attrs->ia_mtime));
 	} else
@@ -1554,7 +1554,7 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 	   server times */
 
 	if (set_time && (attrs->ia_valid & ATTR_CTIME)) {
-		set_time = TRUE;
+		set_time = true;
 		/* Although Samba throws this field away
 		it may be useful to Windows - but we do
 		not want to set ctime unless some other
@@ -1577,7 +1577,7 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 			rc = -EOPNOTSUPP;
 
 		if (rc == -EOPNOTSUPP) {
-			int oplock = FALSE;
+			int oplock = 0;
 			__u16 netfid;
 
 			cFYI(1, ("calling SetFileInfo since SetPathInfo for "
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 4b5ca5f..98fa3bc 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -228,7 +228,7 @@ cifs_readlink(struct dentry *direntry, char __user *pBuffer, int buflen)
 	struct inode *inode = direntry->d_inode;
 	int rc = -EACCES;
 	int xid;
-	int oplock = FALSE;
+	int oplock = 0;
 	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *pTcon;
 	char *full_path = NULL;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index cd9d977..a0b02d1 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -496,7 +496,8 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
 	}
 	return 0;
 }
-int
+
+bool
 is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 {
 	struct smb_com_lock_req *pSMB = (struct smb_com_lock_req *)buf;
@@ -522,17 +523,17 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 				pnotify->Action));  /* BB removeme BB */
 			/*   cifs_dump_mem("Rcvd notify Data: ",buf,
 				sizeof(struct smb_hdr)+60); */
-			return TRUE;
+			return true;
 		}
 		if (pSMBr->hdr.Status.CifsError) {
 			cFYI(1, ("notify err 0x%d",
 				pSMBr->hdr.Status.CifsError));
-			return TRUE;
+			return true;
 		}
-		return FALSE;
+		return false;
 	}
 	if (pSMB->hdr.Command != SMB_COM_LOCKING_ANDX)
-		return FALSE;
+		return false;
 	if (pSMB->hdr.Flags & SMBFLG_RESPONSE) {
 		/* no sense logging error on invalid handle on oplock
 		   break - harmless race between close request and oplock
@@ -541,21 +542,21 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 		if ((NT_STATUS_INVALID_HANDLE) ==
 		   le32_to_cpu(pSMB->hdr.Status.CifsError)) {
 			cFYI(1, ("invalid handle on oplock break"));
-			return TRUE;
+			return true;
 		} else if (ERRbadfid ==
 		   le16_to_cpu(pSMB->hdr.Status.DosError.Error)) {
-			return TRUE;
+			return true;
 		} else {
-			return FALSE; /* on valid oplock brk we get "request" */
+			return false; /* on valid oplock brk we get "request" */
 		}
 	}
 	if (pSMB->hdr.WordCount != 8)
-		return FALSE;
+		return false;
 
 	cFYI(1, ("oplock type 0x%d level 0x%d",
 		 pSMB->LockType, pSMB->OplockLevel));
 	if (!(pSMB->LockType & LOCKING_ANDX_OPLOCK_RELEASE))
-		return FALSE;
+		return false;
 
 	/* look up tcon based on tid & uid */
 	read_lock(&GlobalSMBSeslock);
@@ -573,11 +574,11 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 					    ("file id match, oplock break"));
 					pCifsInode =
 						CIFS_I(netfile->pInode);
-					pCifsInode->clientCanCacheAll = FALSE;
+					pCifsInode->clientCanCacheAll = false;
 					if (pSMB->OplockLevel == 0)
 						pCifsInode->clientCanCacheRead
-							= FALSE;
-					pCifsInode->oplockPending = TRUE;
+							= false;
+					pCifsInode->oplockPending = true;
 					AllocOplockQEntry(netfile->pInode,
 							  netfile->netfid,
 							  tcon);
@@ -585,17 +586,17 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 					    ("about to wake up oplock thread"));
 					if (oplockThread)
 					    wake_up_process(oplockThread);
-					return TRUE;
+					return true;
 				}
 			}
 			read_unlock(&GlobalSMBSeslock);
 			cFYI(1, ("No matching file for oplock break"));
-			return TRUE;
+			return true;
 		}
 	}
 	read_unlock(&GlobalSMBSeslock);
 	cFYI(1, ("Can not process oplock break for non-existent connection"));
-	return TRUE;
+	return true;
 }
 
 void
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 38811ce..06dda4b 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -447,8 +447,8 @@ static int initiate_cifs_search(const int xid, struct file *file)
 	if (file->private_data == NULL)
 		return -ENOMEM;
 	cifsFile = file->private_data;
-	cifsFile->invalidHandle = TRUE;
-	cifsFile->srch_inf.endOfSearch = FALSE;
+	cifsFile->invalidHandle = true;
+	cifsFile->srch_inf.endOfSearch = false;
 
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	if (cifs_sb == NULL)
@@ -484,7 +484,7 @@ ffirst_retry:
 			   &cifsFile->netfid, &cifsFile->srch_inf,
 			   cifs_sb->mnt_cifs_flags, CIFS_DIR_SEP(cifs_sb));
 	if (rc == 0)
-		cifsFile->invalidHandle = FALSE;
+		cifsFile->invalidHandle = false;
 	if ((rc == -EOPNOTSUPP) &&
 		(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
 		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
@@ -669,7 +669,7 @@ static int find_cifs_entry(const int xid, struct cifsTconInfo *pTcon,
 	   (index_to_find < first_entry_in_buffer)) {
 		/* close and restart search */
 		cFYI(1, ("search backing up - close and restart search"));
-		cifsFile->invalidHandle = TRUE;
+		cifsFile->invalidHandle = true;
 		CIFSFindClose(xid, pTcon, cifsFile->netfid);
 		kfree(cifsFile->search_resume_name);
 		cifsFile->search_resume_name = NULL;
@@ -691,7 +691,7 @@ static int find_cifs_entry(const int xid, struct cifsTconInfo *pTcon,
 	}
 
 	while ((index_to_find >= cifsFile->srch_inf.index_of_last_entry) &&
-	      (rc == 0) && (cifsFile->srch_inf.endOfSearch == FALSE)) {
+	      (rc == 0) && !cifsFile->srch_inf.endOfSearch) {
 		cFYI(1, ("calling findnext2"));
 		rc = CIFSFindNext(xid, pTcon, cifsFile->netfid,
 				  &cifsFile->srch_inf);
@@ -1037,7 +1037,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 				break;
 			}
 		} /* else {
-			cifsFile->invalidHandle = TRUE;
+			cifsFile->invalidHandle = true;
 			CIFSFindClose(xid, pTcon, cifsFile->netfid);
 		}
 		kfree(cifsFile->search_resume_name);
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 58bbfd9..ff3232f 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -35,11 +35,11 @@
 #include "cifs_debug.h"
 #include "cifsencrypt.h"
 
-#ifndef FALSE
-#define FALSE 0
+#ifndef false
+#define false 0
 #endif
-#ifndef TRUE
-#define TRUE 1
+#ifndef true
+#define true 1
 #endif
 
 /* following came from the other byteorder.h to avoid include conflicts */
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 5122683..b48680c 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -262,7 +262,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 		else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
 			__u16 fid;
-			int oplock = FALSE;
+			int oplock = 0;
 			struct cifs_ntsd *pacl = NULL;
 			__u32 buflen = 0;
 			if (experimEnabled)
-- 
1.5.4.rc2

