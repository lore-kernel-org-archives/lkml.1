Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYKHOPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYKHOPQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 09:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYKHOOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 09:14:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52956 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbYKHOO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 09:14:27 -0500
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: smfrench@austin.rr.com, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] cifs: convert tcon->tidStatus to a bitfield
Date: Sat,  8 Nov 2008 09:14:13 -0500
Message-Id: <1226153656-7741-3-git-send-email-jlayton@redhat.com>
In-Reply-To: <1226153656-7741-1-git-send-email-jlayton@redhat.com>
References: <1226153656-7741-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, it's an enum, but we need to track a number of different
states with it. In particular we need to know if the tcon needs to be
reconnected and whether it's on the way to being freed. A field of
flags is better suited for this purpose.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifs_debug.c |    6 +++---
 fs/cifs/cifsfs.c     |    4 ++--
 fs/cifs/cifsglob.h   |    7 ++++++-
 fs/cifs/cifssmb.c    |   12 +++++++-----
 fs/cifs/connect.c    |    4 ++--
 fs/cifs/file.c       |    2 +-
 fs/cifs/misc.c       |    1 -
 7 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 69a12aa..ed16bbb 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -192,7 +192,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 					 tcon->nativeFileSystem);
 		}
 		seq_printf(m, "DevInfo: 0x%x Attributes: 0x%x"
-				 "\nPathComponentMax: %d Status: %d",
+				 "\nPathComponentMax: %d Status: 0x%lx",
 			    le32_to_cpu(tcon->fsDevInfo.DeviceCharacteristics),
 			    le32_to_cpu(tcon->fsAttrInfo.Attributes),
 			    le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength),
@@ -204,7 +204,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		else
 			seq_printf(m, " type: %d ", dev_type);
 
-		if (tcon->tidStatus == CifsNeedReconnect)
+		if (!test_bit(CIFS_CONNECTED, &tcon->tidStatus))
 			seq_puts(m, "\tDISCONNECTED ");
 	}
 	read_unlock(&GlobalSMBSeslock);
@@ -311,7 +311,7 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 		i++;
 		tcon = list_entry(tmp, struct cifsTconInfo, cifsConnectionList);
 		seq_printf(m, "\n%d) %s", i, tcon->treeName);
-		if (tcon->tidStatus == CifsNeedReconnect)
+		if (!test_bit(CIFS_CONNECTED, &tcon->tidStatus))
 			seq_puts(m, "\tDISCONNECTED ");
 		seq_printf(m, "\nSMBs: %d Oplock Breaks: %d",
 			atomic_read(&tcon->num_smbs_sent),
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index ac5915d..3d6129f 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -516,7 +516,7 @@ static void cifs_umount_begin(struct super_block *sb)
 		return;
 	down(&tcon->tconSem);
 	if (atomic_read(&tcon->useCount) == 1)
-		tcon->tidStatus = CifsExiting;
+		set_bit(CIFS_CLOSING, &tcon->tidStatus);
 	up(&tcon->tconSem);
 
 	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
@@ -1013,7 +1013,7 @@ static int cifs_oplock_thread(void *dummyarg)
 				not bother sending an oplock release if session
 				to server still is disconnected since oplock
 				already released by the server in that case */
-			if (pTcon->tidStatus != CifsNeedReconnect) {
+			if (!test_bit(CIFS_CONNECTED, &pTcon->tidStatus)) {
 				rc = CIFSSMBLock(0, pTcon, netfid,
 						0 /* len */ , 0 /* offset */, 0,
 						0, LOCKING_ANDX_OPLOCK_RELEASE,
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 58b8d5c..f97ddef 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -73,6 +73,10 @@ enum statusEnum {
 	CifsNeedReconnect
 };
 
+/* flags for tcon and session status */
+#define	CIFS_CONNECTED	(0)
+#define	CIFS_CLOSING	(1)
+
 enum securityEnum {
 	PLAINTXT = 0, 		/* Legacy with Plaintext passwords */
 	LANMAN,			/* Legacy LANMAN auth */
@@ -217,6 +221,7 @@ struct cifsSesInfo {
    which do not negotiate NTLM or POSIX dialects, but instead
    negotiate one of the older LANMAN dialects */
 #define CIFS_SES_LANMAN 8
+
 /*
  * there is one of these for each connection to a resource on a particular
  * session
@@ -230,7 +235,7 @@ struct cifsTconInfo {
 	char *nativeFileSystem;
 	__u16 tid;		/* The 2 byte tree id */
 	__u16 Flags;		/* optional support bits */
-	enum statusEnum tidStatus;
+	unsigned long tidStatus;
 	atomic_t useCount;	/* how many explicit/implicit mounts to share */
 #ifdef CONFIG_CIFS_STATS
 	atomic_t num_smbs_sent;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index d5eac48..29bd4a4 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -148,7 +148,7 @@ small_smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
 	   check for tcp and smb session status done differently
 	   for those three - in the calling routine */
 	if (tcon) {
-		if (tcon->tidStatus == CifsExiting) {
+		if (test_bit(CIFS_CLOSING, &tcon->tidStatus)) {
 			/* only tree disconnect, open, and write,
 			(and ulogoff which does not have tcon)
 			are allowed as we start force umount */
@@ -193,7 +193,8 @@ small_smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
 			if (tcon->ses->status == CifsNeedReconnect)
 				rc = cifs_setup_session(0, tcon->ses,
 							nls_codepage);
-			if (!rc && (tcon->tidStatus == CifsNeedReconnect)) {
+			if (!rc &&
+			    !test_bit(CIFS_CONNECTED, &tcon->tidStatus)) {
 				mark_open_files_invalid(tcon);
 				rc = CIFSTCon(0, tcon->ses, tcon->treeName,
 					      tcon, nls_codepage);
@@ -295,7 +296,7 @@ smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
 	   check for tcp and smb session status done differently
 	   for those three - in the calling routine */
 	if (tcon) {
-		if (tcon->tidStatus == CifsExiting) {
+		if (test_bit(CIFS_CLOSING, &tcon->tidStatus)) {
 			/* only tree disconnect, open, and write,
 			  (and ulogoff which does not have tcon)
 			  are allowed as we start force umount */
@@ -340,7 +341,8 @@ smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
 			if (tcon->ses->status == CifsNeedReconnect)
 				rc = cifs_setup_session(0, tcon->ses,
 							nls_codepage);
-			if (!rc && (tcon->tidStatus == CifsNeedReconnect)) {
+			if (!rc &&
+			    !test_bit(CIFS_CONNECTED, &tcon->tidStatus)) {
 				mark_open_files_invalid(tcon);
 				rc = CIFSTCon(0, tcon->ses, tcon->treeName,
 					      tcon, nls_codepage);
@@ -759,7 +761,7 @@ CIFSSMBTDis(const int xid, struct cifsTconInfo *tcon)
 
 	/* No need to return error on this operation if tid invalidated and
 	closed on server already e.g. due to tcp session crashing */
-	if (tcon->tidStatus == CifsNeedReconnect) {
+	if (!test_bit(CIFS_CONNECTED, &tcon->tidStatus)) {
 		up(&tcon->tconSem);
 		return 0;
 	}
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 22357ec..9d627f9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -158,7 +158,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	list_for_each(tmp, &GlobalTreeConnectionList) {
 		tcon = list_entry(tmp, struct cifsTconInfo, cifsConnectionList);
 		if ((tcon->ses) && (tcon->ses->server == server))
-			tcon->tidStatus = CifsNeedReconnect;
+			clear_bit(CIFS_CONNECTED, &tcon->tidStatus);
 	}
 	read_unlock(&GlobalSMBSeslock);
 	/* do not want to be sending data on a socket we are freeing */
@@ -3520,7 +3520,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
 	/* if (rc) rc = map_smb_to_linux_error(smb_buffer_response); */
 	/* above now done in SendReceive */
 	if ((rc == 0) && (tcon != NULL)) {
-		tcon->tidStatus = CifsGood;
+		set_bit(CIFS_CONNECTED, &tcon->tidStatus);
 		tcon->tid = smb_buffer_response->Tid;
 		bcc_ptr = pByteArea(smb_buffer_response);
 		length = strnlen(bcc_ptr, BCC(smb_buffer_response) - 2);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ead1a3b..94da3d2 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -493,7 +493,7 @@ int cifs_close(struct inode *inode, struct file *file)
 		if (pTcon) {
 			/* no sense reconnecting to close a file that is
 			   already closed */
-			if (pTcon->tidStatus != CifsNeedReconnect) {
+			if (test_bit(CIFS_CONNECTED, &pTcon->tidStatus)) {
 				timeout = 2;
 				while ((atomic_read(&pSMBFile->wrtPending) != 0)
 					&& (timeout <= 2048)) {
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 88786ba..7736a38 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -115,7 +115,6 @@ tconInfoAlloc(void)
 		atomic_inc(&tconInfoAllocCount);
 		list_add(&ret_buf->cifsConnectionList,
 			 &GlobalTreeConnectionList);
-		ret_buf->tidStatus = CifsNew;
 		INIT_LIST_HEAD(&ret_buf->openFileList);
 		init_MUTEX(&ret_buf->tconSem);
 #ifdef CONFIG_CIFS_STATS
-- 
1.5.5.1

