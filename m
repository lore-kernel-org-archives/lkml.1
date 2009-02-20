Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZBTUv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZBTUv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 15:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZBTUvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 15:51:51 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:18653 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZBTUvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 15:51:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=J4jKOyUx/kaTqyZetb3ZIgMzqQAmN6N5bSPyWsScExHrbk9UqWVYVrIt/YFhMJi/tm
         M/ptapNzTTaJH9X4TZF+UzqGcQI9NUZfrj9JwerzXkXqyoj2GMhhGlhwyTJdF5q9mE3d
         Peo6lWraYFA+ZKtJBn06yk6Dx/4CQjlWkpzcc=
Date: Fri, 20 Feb 2009 21:51:46 +0100 (CET)
From: Horst Reiterer <horst.reiterer@gmail.com>
X-X-Sender: horstreiterer@horst-reiterers-macbook-air.local
To: smfrench@gmail.com
cc: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: [PATCH] fs/cifs: send SMB_COM_FLUSH in cifs_fsync
Message-ID: <alpine.OSX.2.00.0902202138421.3998@horst-reiterers-macbook-air.local>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In contrast to the now-obsolete smbfs, cifs does not send SMB_COM_FLUSH
in response to an explicit fsync(2) to guarantee that all volatile data
is written to stable storage on the server side, provided the server
honors the request (which, to my knowledge, is true for Windows and
Samba with 'strict sync' enabled).
This patch modifies the cifs_fsync implementation to restore the
fsync-behavior of smbfs by triggering SMB_COM_FLUSH after sending
outstanding data on the client side to the server.

I inquired about this issue in the linux-cifs-client@lists.samba.org
mailing list:

On Tue, Feb 10, 2009 at 12:35 AM, Jeff Layton <jlayton@redhat.com> wrote:
> Horst Reiterer wrote:
> > Why was the explicit SMB_COM_FLUSH dropped in the new implementation?
>
> It's not that it was "removed" per-se, just never implemented. Patches
> to add that capability would certainly be welcome.

I tested the patch with 2.6.28.6 and 2.6.18 (backported) on x86_64.
Please review and apply.

Horst.


Signed-off-by: Horst Reiterer <horst.reiterer@gmail.com>

diff -uprN linux-2.6.28.6/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
--- linux-2.6.28.6/fs/cifs/cifs_debug.c	2009-02-17 18:29:27.000000000 +0100
+++ b/fs/cifs/cifs_debug.c	2009-02-20 00:42:18.000000000 +0100
@@ -340,6 +340,8 @@ static int cifs_stats_proc_show(struct s
 				seq_printf(m, "\nWrites: %d Bytes: %lld",
 					atomic_read(&tcon->num_writes),
 					(long long)(tcon->bytes_written));
+				seq_printf(m, "\nFlushes: %d",
+					atomic_read(&tcon->num_flushes));
 				seq_printf(m, "\nLocks: %d HardLinks: %d "
 					      "Symlinks: %d",
 					atomic_read(&tcon->num_locks),
diff -uprN linux-2.6.28.6/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
--- linux-2.6.28.6/fs/cifs/cifsglob.h	2009-02-17 18:29:27.000000000 +0100
+++ b/fs/cifs/cifsglob.h	2009-02-20 00:42:18.000000000 +0100
@@ -246,6 +246,7 @@ struct cifsTconInfo {
 	atomic_t num_smbs_sent;
 	atomic_t num_writes;
 	atomic_t num_reads;
+	atomic_t num_flushes;
 	atomic_t num_oplock_brks;
 	atomic_t num_opens;
 	atomic_t num_closes;
diff -uprN linux-2.6.28.6/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
--- linux-2.6.28.6/fs/cifs/cifspdu.h	2009-02-17 18:29:27.000000000 +0100
+++ b/fs/cifs/cifspdu.h	2009-02-20 00:42:18.000000000 +0100
@@ -43,6 +43,7 @@
 #define SMB_COM_CREATE_DIRECTORY      0x00 /* trivial response */
 #define SMB_COM_DELETE_DIRECTORY      0x01 /* trivial response */
 #define SMB_COM_CLOSE                 0x04 /* triv req/rsp, timestamp ignored */
+#define SMB_COM_FLUSH                 0x05 /* triv req/rsp */
 #define SMB_COM_DELETE                0x06 /* trivial response */
 #define SMB_COM_RENAME                0x07 /* trivial response */
 #define SMB_COM_QUERY_INFORMATION     0x08 /* aka getattr */
@@ -790,6 +791,12 @@ typedef struct smb_com_close_rsp {
 	__u16 ByteCount;	/* bct = 0 */
 } __attribute__((packed)) CLOSE_RSP;

+typedef struct smb_com_flush_req {
+	struct smb_hdr hdr;	/* wct = 1 */
+	__u16 FileID;
+	__u16 ByteCount;	/* 0 */
+} __attribute__((packed)) FLUSH_REQ;
+
 typedef struct smb_com_findclose_req {
 	struct smb_hdr hdr; /* wct = 1 */
 	__u16 FileID;
diff -uprN linux-2.6.28.6/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
--- linux-2.6.28.6/fs/cifs/cifsproto.h	2009-02-17 18:29:27.000000000 +0100
+++ b/fs/cifs/cifsproto.h	2009-02-20 00:42:18.000000000 +0100
@@ -277,6 +277,9 @@ extern int CIFSPOSIXCreate(const int xid
 extern int CIFSSMBClose(const int xid, struct cifsTconInfo *tcon,
 			const int smb_file_id);

+extern int CIFSSMBFlush(const int xid, struct cifsTconInfo *tcon,
+			const int smb_file_id);
+
 extern int CIFSSMBRead(const int xid, struct cifsTconInfo *tcon,
 			const int netfid, unsigned int count,
 			const __u64 lseek, unsigned int *nbytes, char **buf,
diff -uprN linux-2.6.28.6/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
--- linux-2.6.28.6/fs/cifs/cifssmb.c	2009-02-17 18:29:27.000000000 +0100
+++ b/fs/cifs/cifssmb.c	2009-02-20 00:42:18.000000000 +0100
@@ -1928,6 +1928,27 @@ CIFSSMBClose(const int xid, struct cifsT
 }

 int
+CIFSSMBFlush(const int xid, struct cifsTconInfo *tcon, int smb_file_id)
+{
+	int rc = 0;
+	FLUSH_REQ *pSMB = NULL;
+	cFYI(1, ("In CIFSSMBFlush"));
+
+	rc = small_smb_init(SMB_COM_FLUSH, 1, tcon, (void **) &pSMB);
+	if (rc)
+		return rc;
+
+	pSMB->FileID = (__u16) smb_file_id;
+	pSMB->ByteCount = 0;
+	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
+	cifs_stats_inc(&tcon->num_flushes);
+	if (rc)
+		cERROR(1, ("Send error in Flush = %d", rc));
+
+	return rc;
+}
+
+int
 CIFSSMBRename(const int xid, struct cifsTconInfo *tcon,
 	      const char *fromName, const char *toName,
 	      const struct nls_table *nls_codepage, int remap)
diff -uprN linux-2.6.28.6/fs/cifs/file.c b/fs/cifs/file.c
--- linux-2.6.28.6/fs/cifs/file.c	2009-02-17 18:29:27.000000000 +0100
+++ b/fs/cifs/file.c	2009-02-20 00:42:18.000000000 +0100
@@ -1522,18 +1522,31 @@ int cifs_fsync(struct file *file, struct
 {
 	int xid;
 	int rc = 0;
+	struct cifs_sb_info *cifs_sb;
+	struct cifsTconInfo *pTcon;
+	struct cifsFileInfo *pSMBFile =
+		(struct cifsFileInfo *)file->private_data;
 	struct inode *inode = file->f_path.dentry->d_inode;

 	xid = GetXid();

+	cifs_sb = CIFS_SB(inode->i_sb);
+	pTcon = cifs_sb->tcon;
+
 	cFYI(1, ("Sync file - name: %s datasync: 0x%x",
 		dentry->d_name.name, datasync));

-	rc = filemap_write_and_wait(inode->i_mapping);
-	if (rc == 0) {
-		rc = CIFS_I(inode)->write_behind_rc;
-		CIFS_I(inode)->write_behind_rc = 0;
-	}
+	if (pSMBFile) {
+		rc = filemap_write_and_wait(inode->i_mapping);
+		if (rc == 0) {
+			rc = CIFS_I(inode)->write_behind_rc;
+			CIFS_I(inode)->write_behind_rc = 0;
+			if (pTcon)
+				rc = CIFSSMBFlush(xid, pTcon, pSMBFile->netfid);
+		}
+	} else
+		rc = -EBADF;
+
 	FreeXid(xid);
 	return rc;
 }
