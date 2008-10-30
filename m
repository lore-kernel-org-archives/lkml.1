Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbYJ3PSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbYJ3PSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYJ3PQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:16:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41940 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037AbYJ3PQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:16:41 -0400
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: smfrench@austin.rr.com, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] cifs: reinstate sharing of tree connections
Date: Thu, 30 Oct 2008 11:16:33 -0400
Message-Id: <1225379793-23283-5-git-send-email-jlayton@redhat.com>
In-Reply-To: <1225379793-23283-1-git-send-email-jlayton@redhat.com>
References: <1225379793-23283-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifs_debug.c |  244 ++++++++++++++++++++++++++++---------------------
 fs/cifs/cifsfs.c     |    8 +-
 fs/cifs/cifsglob.h   |    8 +-
 fs/cifs/cifssmb.c    |   34 +------
 fs/cifs/connect.c    |   95 ++++++++++++++------
 fs/cifs/misc.c       |   78 ++++++++--------
 6 files changed, 258 insertions(+), 209 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 81ccc60..0472114 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -107,12 +107,13 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 #ifdef CONFIG_PROC_FS
 static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 {
-	struct list_head *tmp, *tmp2, *tmp3;
+	struct list_head *tmp1, *tmp2, *tmp3;
 	struct mid_q_entry *mid_entry;
 	struct TCP_Server_Info *server;
 	struct cifsSesInfo *ses;
 	struct cifsTconInfo *tcon;
-	int i;
+	int i, j;
+	__u32 dev_type;
 
 	seq_puts(m,
 		    "Display Internal CIFS Data Structures for Debugging\n"
@@ -123,8 +124,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 
 	i = 0;
 	spin_lock(&cifs_tcp_session_lock);
-	list_for_each(tmp, &cifs_tcp_session_list) {
-		server = list_entry(tmp, struct TCP_Server_Info,
+	list_for_each(tmp1, &cifs_tcp_session_list) {
+		server = list_entry(tmp1, struct TCP_Server_Info,
 				    tcp_session_list);
 		i++;
 		spin_lock(&server->smb_session_lock);
@@ -134,12 +135,12 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			if ((ses->serverDomain == NULL) ||
 				(ses->serverOS == NULL) ||
 				(ses->serverNOS == NULL)) {
-				seq_printf(m, "\nentry for %s not fully "
-					   "displayed\n\t", ses->serverName);
+				seq_printf(m, "\n%d) entry for %s not fully "
+					   "displayed\n\t", i, ses->serverName);
 			} else {
 				seq_printf(m,
-				    "\n%d) Name: %s  Domain: %s Mounts: %d OS:"
-				    " %s  \n\tNOS: %s\tCapability: 0x%x\n\tSMB"
+				    "\n%d) Name: %s  Domain: %s Uses: %d OS:"
+				    " %s\n\tNOS: %s\tCapability: 0x%x\n\tSMB"
 				    " session status: %d\t",
 				i, ses->serverName, ses->serverDomain,
 				ses->refcount, ses->serverOS, ses->serverNOS,
@@ -156,14 +157,46 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				atomic_read(&server->num_waiters));
 #endif
 
-			seq_puts(m, "\nMIDs:\n");
+			seq_puts(m, "\n\tShares:");
+			j = 0;
+			spin_lock(&ses->tcon_lock);
+			list_for_each(tmp3, &ses->tcon_list) {
+				tcon = list_entry(tmp3, struct cifsTconInfo,
+						  tcon_list);
+				++j;
+				dev_type = le32_to_cpu(tcon->fsDevInfo.DeviceType);
+				seq_printf(m, "\n\t%d) %s Mounts: %d ", j,
+					   tcon->treeName, tcon->refcount);
+				if (tcon->nativeFileSystem) {
+					seq_printf(m, "Type: %s ",
+						   tcon->nativeFileSystem);
+				}
+				seq_printf(m, "DevInfo: 0x%x Attributes: 0x%x"
+					"\nPathComponentMax: %d Status: %d",
+					le32_to_cpu(tcon->fsDevInfo.DeviceCharacteristics),
+					le32_to_cpu(tcon->fsAttrInfo.Attributes),
+					le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength),
+					tcon->tidStatus);
+				if (dev_type == FILE_DEVICE_DISK)
+					seq_puts(m, " type: DISK ");
+				else if (dev_type == FILE_DEVICE_CD_ROM)
+					seq_puts(m, " type: CDROM ");
+				else
+					seq_printf(m, " type: %d ", dev_type);
+
+				if (tcon->tidStatus == CifsNeedReconnect)
+					seq_puts(m, "\tDISCONNECTED ");
+				seq_putc(m, '\n');
+			}
+			spin_unlock(&ses->tcon_lock);
+
+			seq_puts(m, "\n\tMIDs:\n");
 
 			spin_lock(&GlobalMid_Lock);
 			list_for_each(tmp3, &server->pending_mid_q) {
-				mid_entry = list_entry(tmp3, struct
-					mid_q_entry,
+				mid_entry = list_entry(tmp3, struct mid_q_entry,
 					qhead);
-				seq_printf(m, "State: %d com: %d pid:"
+				seq_printf(m, "\tState: %d com: %d pid:"
 						" %d tsk: %p mid %d\n",
 						mid_entry->midState,
 						(int)mid_entry->command,
@@ -178,40 +211,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 	spin_unlock(&cifs_tcp_session_lock);
 	seq_putc(m, '\n');
 
-	seq_puts(m, "Shares:");
 
-	i = 0;
-	read_lock(&GlobalSMBSeslock);
-	list_for_each(tmp, &GlobalTreeConnectionList) {
-		__u32 dev_type;
-		i++;
-		tcon = list_entry(tmp, struct cifsTconInfo, cifsConnectionList);
-		dev_type = le32_to_cpu(tcon->fsDevInfo.DeviceType);
-		seq_printf(m, "\n%d) %s Uses: %d ", i,
-				 tcon->treeName, atomic_read(&tcon->useCount));
-		if (tcon->nativeFileSystem) {
-			seq_printf(m, "Type: %s ",
-					 tcon->nativeFileSystem);
-		}
-		seq_printf(m, "DevInfo: 0x%x Attributes: 0x%x"
-				 "\nPathComponentMax: %d Status: %d",
-			    le32_to_cpu(tcon->fsDevInfo.DeviceCharacteristics),
-			    le32_to_cpu(tcon->fsAttrInfo.Attributes),
-			    le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength),
-			    tcon->tidStatus);
-		if (dev_type == FILE_DEVICE_DISK)
-			seq_puts(m, " type: DISK ");
-		else if (dev_type == FILE_DEVICE_CD_ROM)
-			seq_puts(m, " type: CDROM ");
-		else
-			seq_printf(m, " type: %d ", dev_type);
-
-		if (tcon->tidStatus == CifsNeedReconnect)
-			seq_puts(m, "\tDISCONNECTED ");
-	}
-	read_unlock(&GlobalSMBSeslock);
 
-	seq_putc(m, '\n');
 
 	/* BB add code to dump additional info such as TCP session info now */
 	return 0;
@@ -236,7 +237,9 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 {
 	char c;
 	int rc;
-	struct list_head *tmp;
+	struct list_head *tmp1, *tmp2, *tmp3;
+	struct TCP_Server_Info *server;
+	struct cifsSesInfo *ses;
 	struct cifsTconInfo *tcon;
 
 	rc = get_user(c, buffer);
@@ -244,33 +247,46 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 		return rc;
 
 	if (c == '1' || c == 'y' || c == 'Y' || c == '0') {
-		read_lock(&GlobalSMBSeslock);
 #ifdef CONFIG_CIFS_STATS2
 		atomic_set(&totBufAllocCount, 0);
 		atomic_set(&totSmBufAllocCount, 0);
 #endif /* CONFIG_CIFS_STATS2 */
-		list_for_each(tmp, &GlobalTreeConnectionList) {
-			tcon = list_entry(tmp, struct cifsTconInfo,
-					cifsConnectionList);
-			atomic_set(&tcon->num_smbs_sent, 0);
-			atomic_set(&tcon->num_writes, 0);
-			atomic_set(&tcon->num_reads, 0);
-			atomic_set(&tcon->num_oplock_brks, 0);
-			atomic_set(&tcon->num_opens, 0);
-			atomic_set(&tcon->num_closes, 0);
-			atomic_set(&tcon->num_deletes, 0);
-			atomic_set(&tcon->num_mkdirs, 0);
-			atomic_set(&tcon->num_rmdirs, 0);
-			atomic_set(&tcon->num_renames, 0);
-			atomic_set(&tcon->num_t2renames, 0);
-			atomic_set(&tcon->num_ffirst, 0);
-			atomic_set(&tcon->num_fnext, 0);
-			atomic_set(&tcon->num_fclose, 0);
-			atomic_set(&tcon->num_hardlinks, 0);
-			atomic_set(&tcon->num_symlinks, 0);
-			atomic_set(&tcon->num_locks, 0);
+		spin_lock(&cifs_tcp_session_lock);
+		list_for_each(tmp1, &cifs_tcp_session_list) {
+			server = list_entry(tmp1, struct TCP_Server_Info,
+					    tcp_session_list);
+			spin_lock(server->smb_session_lock);
+			list_for_each(tmp2, &server->smb_session_list) {
+				ses = list_entry(tmp2, struct cifsSesInfo,
+						 smb_session_list);
+				spin_lock(&ses->tcon_lock);
+				list_for_each(tmp3, &ses->tcon_list) {
+					tcon = list_entry(tmp3,
+							  struct cifsTconInfo,
+							  tcon_list);
+					atomic_set(&tcon->num_smbs_sent, 0);
+					atomic_set(&tcon->num_writes, 0);
+					atomic_set(&tcon->num_reads, 0);
+					atomic_set(&tcon->num_oplock_brks, 0);
+					atomic_set(&tcon->num_opens, 0);
+					atomic_set(&tcon->num_closes, 0);
+					atomic_set(&tcon->num_deletes, 0);
+					atomic_set(&tcon->num_mkdirs, 0);
+					atomic_set(&tcon->num_rmdirs, 0);
+					atomic_set(&tcon->num_renames, 0);
+					atomic_set(&tcon->num_t2renames, 0);
+					atomic_set(&tcon->num_ffirst, 0);
+					atomic_set(&tcon->num_fnext, 0);
+					atomic_set(&tcon->num_fclose, 0);
+					atomic_set(&tcon->num_hardlinks, 0);
+					atomic_set(&tcon->num_symlinks, 0);
+					atomic_set(&tcon->num_locks, 0);
+				}
+				spin_unlock(&ses->tcon_lock);
+			}
+			spin_unlock(&server->smb_session_lock);
 		}
-		read_unlock(&GlobalSMBSeslock);
+		spin_unlock(&cifs_tcp_session_lock);
 	}
 
 	return count;
@@ -279,7 +295,9 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 static int cifs_stats_proc_show(struct seq_file *m, void *v)
 {
 	int i;
-	struct list_head *tmp;
+	struct list_head *tmp1, *tmp2, *tmp3;
+	struct TCP_Server_Info *server;
+	struct cifsSesInfo *ses;
 	struct cifsTconInfo *tcon;
 
 	seq_printf(m,
@@ -308,44 +326,60 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 		GlobalCurrentXid, GlobalMaxActiveXid);
 
 	i = 0;
-	read_lock(&GlobalSMBSeslock);
-	list_for_each(tmp, &GlobalTreeConnectionList) {
-		i++;
-		tcon = list_entry(tmp, struct cifsTconInfo, cifsConnectionList);
-		seq_printf(m, "\n%d) %s", i, tcon->treeName);
-		if (tcon->tidStatus == CifsNeedReconnect)
-			seq_puts(m, "\tDISCONNECTED ");
-		seq_printf(m, "\nSMBs: %d Oplock Breaks: %d",
-			atomic_read(&tcon->num_smbs_sent),
-			atomic_read(&tcon->num_oplock_brks));
-		seq_printf(m, "\nReads:  %d Bytes: %lld",
-			atomic_read(&tcon->num_reads),
-			(long long)(tcon->bytes_read));
-		seq_printf(m, "\nWrites: %d Bytes: %lld",
-			atomic_read(&tcon->num_writes),
-			(long long)(tcon->bytes_written));
-		seq_printf(m,
-			"\nLocks: %d HardLinks: %d Symlinks: %d",
-			atomic_read(&tcon->num_locks),
-			atomic_read(&tcon->num_hardlinks),
-			atomic_read(&tcon->num_symlinks));
-
-		seq_printf(m, "\nOpens: %d Closes: %d Deletes: %d",
-			atomic_read(&tcon->num_opens),
-			atomic_read(&tcon->num_closes),
-			atomic_read(&tcon->num_deletes));
-		seq_printf(m, "\nMkdirs: %d Rmdirs: %d",
-			atomic_read(&tcon->num_mkdirs),
-			atomic_read(&tcon->num_rmdirs));
-		seq_printf(m, "\nRenames: %d T2 Renames %d",
-			atomic_read(&tcon->num_renames),
-			atomic_read(&tcon->num_t2renames));
-		seq_printf(m, "\nFindFirst: %d FNext %d FClose %d",
-			atomic_read(&tcon->num_ffirst),
-			atomic_read(&tcon->num_fnext),
-			atomic_read(&tcon->num_fclose));
+	spin_lock(&cifs_tcp_session_lock);
+	list_for_each(tmp1, &cifs_tcp_session_list) {
+		server = list_entry(tmp1, struct TCP_Server_Info,
+				    tcp_session_list);
+		spin_lock(server->smb_session_lock);
+		list_for_each(tmp2, &server->smb_session_list) {
+			ses = list_entry(tmp2, struct cifsSesInfo,
+					 smb_session_list);
+			spin_lock(&ses->tcon_lock);
+			list_for_each(tmp3, &ses->tcon_list) {
+				tcon = list_entry(tmp3,
+						  struct cifsTconInfo,
+						  tcon_list);
+				i++;
+				seq_printf(m, "\n%d) %s", i, tcon->treeName);
+				if (tcon->tidStatus == CifsNeedReconnect)
+					seq_puts(m, "\tDISCONNECTED ");
+				seq_printf(m, "\nSMBs: %d Oplock Breaks: %d",
+					atomic_read(&tcon->num_smbs_sent),
+					atomic_read(&tcon->num_oplock_brks));
+				seq_printf(m, "\nReads:  %d Bytes: %lld",
+					atomic_read(&tcon->num_reads),
+					(long long)(tcon->bytes_read));
+				seq_printf(m, "\nWrites: %d Bytes: %lld",
+					atomic_read(&tcon->num_writes),
+					(long long)(tcon->bytes_written));
+				seq_printf(m, "\nLocks: %d HardLinks: %d "
+					      "Symlinks: %d",
+					atomic_read(&tcon->num_locks),
+					atomic_read(&tcon->num_hardlinks),
+					atomic_read(&tcon->num_symlinks));
+		
+				seq_printf(m, "\nOpens: %d Closes: %d"
+					      "Deletes: %d",
+					atomic_read(&tcon->num_opens),
+					atomic_read(&tcon->num_closes),
+					atomic_read(&tcon->num_deletes));
+				seq_printf(m, "\nMkdirs: %d Rmdirs: %d",
+					atomic_read(&tcon->num_mkdirs),
+					atomic_read(&tcon->num_rmdirs));
+				seq_printf(m, "\nRenames: %d T2 Renames %d",
+					atomic_read(&tcon->num_renames),
+					atomic_read(&tcon->num_t2renames));
+				seq_printf(m, "\nFindFirst: %d FNext %d "
+					      "FClose %d",
+					atomic_read(&tcon->num_ffirst),
+					atomic_read(&tcon->num_fnext),
+					atomic_read(&tcon->num_fclose));
+			}
+			spin_unlock(&ses->tcon_lock);
+		}
+		spin_unlock(&server->smb_session_lock);
 	}
-	read_unlock(&GlobalSMBSeslock);
+	spin_unlock(&cifs_tcp_session_lock);
 
 	seq_putc(m, '\n');
 	return 0;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index a6072b3..ee04ad4 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -520,10 +520,11 @@ static void cifs_umount_begin(struct super_block *sb)
 	tcon = cifs_sb->tcon;
 	if (tcon == NULL)
 		return;
-	down(&tcon->tconSem);
-	if (atomic_read(&tcon->useCount) == 1)
+	spin_lock(&tcon->ses->tcon_lock);
+	if (tcon->refcount == 1) {
 		tcon->tidStatus = CifsExiting;
-	up(&tcon->tconSem);
+	}
+	spin_unlock(&tcon->ses->tcon_lock);
 
 	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
 	/* cancel_notify_requests(tcon); */
@@ -1066,7 +1067,6 @@ init_cifs(void)
 	int rc = 0;
 	cifs_proc_init();
 /*	INIT_LIST_HEAD(&GlobalServerList);*/	/* BB not implemented yet */
-	INIT_LIST_HEAD(&GlobalTreeConnectionList);
 	INIT_LIST_HEAD(&GlobalOplock_Q);
 	INIT_LIST_HEAD(&cifs_tcp_session_list);
 #ifdef CONFIG_CIFS_EXPERIMENTAL
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 59befef..e5aa4cf 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -190,6 +190,8 @@ struct cifsUidInfo {
  */
 struct cifsSesInfo {
 	struct list_head smb_session_list;
+	struct list_head tcon_list;
+	spinlock_t tcon_lock;
 	struct semaphore sesSem;
 #if 0
 	struct cifsUidInfo *uidInfo;	/* pointer to user info */
@@ -225,16 +227,15 @@ struct cifsSesInfo {
  * session
  */
 struct cifsTconInfo {
-	struct list_head cifsConnectionList;
+	struct list_head tcon_list;
+	int refcount;
 	struct list_head openFileList;
-	struct semaphore tconSem;
 	struct cifsSesInfo *ses;	/* pointer to session associated with */
 	char treeName[MAX_TREE_SIZE + 1]; /* UNC name of resource in ASCII */
 	char *nativeFileSystem;
 	__u16 tid;		/* The 2 byte tree id */
 	__u16 Flags;		/* optional support bits */
 	enum statusEnum tidStatus;
-	atomic_t useCount;	/* how many explicit/implicit mounts to share */
 #ifdef CONFIG_CIFS_STATS
 	atomic_t num_smbs_sent;
 	atomic_t num_writes;
@@ -595,7 +596,6 @@ require use of the stronger protocol */
 GLOBAL_EXTERN struct smbUidInfo *GlobalUidList[UID_HASH];
 
 /* GLOBAL_EXTERN struct list_head GlobalServerList; BB not implemented yet */
-GLOBAL_EXTERN struct list_head GlobalTreeConnectionList;
 GLOBAL_EXTERN rwlock_t GlobalSMBSeslock;  /* protects list inserts on 3 above */
 extern struct list_head		cifs_tcp_session_list;
 extern spinlock_t		cifs_tcp_session_lock;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c9e9243..78131d8 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -740,50 +740,26 @@ CIFSSMBTDis(const int xid, struct cifsTconInfo *tcon)
 	int rc = 0;
 
 	cFYI(1, ("In tree disconnect"));
-	/*
-	 *  If last user of the connection and
-	 *  connection alive - disconnect it
-	 *  If this is the last connection on the server session disconnect it
-	 *  (and inside session disconnect we should check if tcp socket needs
-	 *  to be freed and kernel thread woken up).
-	 */
-	if (tcon)
-		down(&tcon->tconSem);
-	else
-		return -EIO;
-
-	atomic_dec(&tcon->useCount);
-	if (atomic_read(&tcon->useCount) > 0) {
-		up(&tcon->tconSem);
-		return -EBUSY;
-	}
 
 	/* No need to return error on this operation if tid invalidated and
 	closed on server already e.g. due to tcp session crashing */
-	if (tcon->tidStatus == CifsNeedReconnect) {
-		up(&tcon->tconSem);
+	if (tcon->tidStatus == CifsNeedReconnect)
 		return 0;
-	}
 
-	if ((tcon->ses == NULL) || (tcon->ses->server == NULL)) {
-		up(&tcon->tconSem);
+	if ((tcon->ses == NULL) || (tcon->ses->server == NULL))
 		return -EIO;
-	}
+
 	rc = small_smb_init(SMB_COM_TREE_DISCONNECT, 0, tcon,
 			    (void **)&smb_buffer);
-	if (rc) {
-		up(&tcon->tconSem);
+	if (rc)
 		return rc;
-	}
 
 	rc = SendReceiveNoRsp(xid, tcon->ses, smb_buffer, 0);
 	if (rc)
 		cFYI(1, ("Tree disconnect failed %d", rc));
 
-	up(&tcon->tconSem);
-
 	/* No need to return error on this operation if tid invalidated and
-	closed on server already e.g. due to tcp session crashing */
+	   closed on server already e.g. due to tcp session crashing */
 	if (rc == -EAGAIN)
 		rc = 0;
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1d7d7c8..608fc3b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -124,7 +124,7 @@ static int
 cifs_reconnect(struct TCP_Server_Info *server)
 {
 	int rc = 0;
-	struct list_head *tmp;
+	struct list_head *tmp, *tmp2;
 	struct cifsSesInfo *ses;
 	struct cifsTconInfo *tcon;
 	struct mid_q_entry *mid_entry;
@@ -149,13 +149,14 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		ses = list_entry(tmp, struct cifsSesInfo, smb_session_list);
 		ses->status = CifsNeedReconnect;
 		ses->ipc_tid = 0;
-	}
-	spin_unlock(&server->smb_session_lock);
-	list_for_each(tmp, &GlobalTreeConnectionList) {
-		tcon = list_entry(tmp, struct cifsTconInfo, cifsConnectionList);
-		if ((tcon->ses) && (tcon->ses->server == server))
+		spin_lock(&ses->tcon_lock);
+		list_for_each(tmp2, &ses->tcon_list) {
+			tcon = list_entry(tmp2, struct cifsTconInfo, tcon_list);
 			tcon->tidStatus = CifsNeedReconnect;
+		}
+		spin_unlock(&ses->tcon_lock);
 	}
+	spin_unlock(&server->smb_session_lock);
 	/* do not want to be sending data on a socket we are freeing */
 	down(&server->tcpSem);
 	if (server->ssocket) {
@@ -1447,6 +1448,50 @@ cifs_put_smb_session(struct cifsSesInfo *ses)
 	cifs_put_tcp_session(server);
 }
 
+static struct cifsTconInfo *
+cifs_find_tcon(struct cifsSesInfo *ses, const char *unc)
+{
+	struct list_head *tmp;
+	struct cifsTconInfo *tcon;
+
+	spin_lock(&ses->tcon_lock);
+	list_for_each(tmp, &ses->tcon_list) {
+		tcon = list_entry(tmp, struct cifsTconInfo, tcon_list);
+		if (strncmp(tcon->treeName, unc, MAX_TREE_SIZE))
+			continue;
+
+		++tcon->refcount;
+		spin_unlock(&ses->tcon_lock);
+		return tcon;
+	}
+	spin_unlock(&ses->tcon_lock);
+	return NULL;
+}
+
+static void
+cifs_put_tcon(struct cifsTconInfo *tcon)
+{
+	int xid;
+	struct cifsSesInfo *ses = tcon->ses;
+
+	spin_lock(&ses->tcon_lock);
+	if (--tcon->refcount > 0) {
+		spin_unlock(&ses->tcon_lock);
+		return;
+	}
+
+	list_del_init(&tcon->tcon_list);
+	spin_unlock(&ses->tcon_lock);
+
+	xid = GetXid();
+	CIFSSMBTDis(xid, tcon);
+	_FreeXid(xid);
+
+	DeleteTconOplockQEntries(tcon);
+	tconInfoFree(tcon);
+	cifs_put_smb_session(ses);
+}
+
 int
 get_dfs_path(int xid, struct cifsSesInfo *pSesInfo, const char *old_path,
 	     const struct nls_table *nls_codepage, unsigned int *pnum_referrals,
@@ -2201,8 +2246,12 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 			cERROR(1, ("mount option dynperm ignored if cifsacl "
 				   "mount option supported"));
 
+		tcon = cifs_find_tcon(pSesInfo, volume_info.UNC);
 		if (tcon) {
 			cFYI(1, ("Found match on UNC path"));
+			/* existing tcon already has a reference */
+			cifs_put_smb_session(pSesInfo);
+
 			/* we can have only one retry value for a connection
 			   to a share so for resources mounted more than once
 			   to the same server share the last value passed in
@@ -2252,6 +2301,12 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 					tcon->retry = volume_info.retry;
 					tcon->nocase = volume_info.nocase;
 					tcon->seal = volume_info.seal;
+					tcon->ses = pSesInfo;
+					++tcon->refcount;
+					spin_lock(&pSesInfo->tcon_lock);
+					list_add(&tcon->tcon_list,
+						 &pSesInfo->tcon_list);
+					spin_unlock(&pSesInfo->tcon_lock);
 				}
 			}
 		}
@@ -2271,17 +2326,13 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 		/* If find_unc succeeded then rc == 0 so we can not end */
 		/* up accidently freeing someone elses tcon struct */
 		if (tcon)
-			tconInfoFree(tcon);
-
-		/* should also end up putting our tcp session ref if needed */
-		if (pSesInfo)
+			cifs_put_tcon(tcon);
+		else if (pSesInfo)
 			cifs_put_smb_session(pSesInfo);
 		else
 			cifs_put_tcp_session(srvTcp);
 	} else {
-		atomic_inc(&tcon->useCount);
 		cifs_sb->tcon = tcon;
-		tcon->ses = pSesInfo;
 
 		/* do not care if following two calls succeed - informational */
 		if (!tcon->ipc) {
@@ -3484,7 +3535,9 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
 	/* if (rc) rc = map_smb_to_linux_error(smb_buffer_response); */
 	/* above now done in SendReceive */
 	if ((rc == 0) && (tcon != NULL)) {
+		spin_lock(&ses->tcon_lock);
 		tcon->tidStatus = CifsGood;
+		spin_unlock(&ses->tcon_lock);
 		tcon->tid = smb_buffer_response->Tid;
 		bcc_ptr = pByteArea(smb_buffer_response);
 		length = strnlen(bcc_ptr, BCC(smb_buffer_response) - 2);
@@ -3556,23 +3609,10 @@ int
 cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 {
 	int rc = 0;
-	int xid;
-	struct cifsSesInfo *ses = NULL;
 	char *tmp;
 
-	xid = GetXid();
-
-	if (cifs_sb->tcon) {
-		ses = cifs_sb->tcon->ses; /* save ptr to ses before delete tcon!*/
-		rc = CIFSSMBTDis(xid, cifs_sb->tcon);
-		if (rc == -EBUSY) {
-			FreeXid(xid);
-			return 0;
-		}
-		DeleteTconOplockQEntries(cifs_sb->tcon);
-		tconInfoFree(cifs_sb->tcon);
-		cifs_put_smb_session(ses);
-	}
+	if (cifs_sb->tcon)
+		cifs_put_tcon(cifs_sb->tcon);
 
 	cifs_sb->tcon = NULL;
 	tmp = cifs_sb->prepath;
@@ -3580,7 +3620,6 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 	cifs_sb->prepath = NULL;
 	kfree(tmp);
 
-	FreeXid(xid);
 	return rc;
 }
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 4a5c6bd..d5a95c1 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -78,6 +78,8 @@ sesInfoAlloc(void)
 		atomic_inc(&sesInfoAllocCount);
 		ret_buf->status = CifsNew;
 		INIT_LIST_HEAD(&ret_buf->smb_session_list);
+		INIT_LIST_HEAD(&ret_buf->tcon_list);
+		spin_lock_init(&ret_buf->tcon_lock);
 		init_MUTEX(&ret_buf->sesSem);
 	}
 	return ret_buf;
@@ -106,17 +108,13 @@ tconInfoAlloc(void)
 	struct cifsTconInfo *ret_buf;
 	ret_buf = kzalloc(sizeof(struct cifsTconInfo), GFP_KERNEL);
 	if (ret_buf) {
-		write_lock(&GlobalSMBSeslock);
 		atomic_inc(&tconInfoAllocCount);
-		list_add(&ret_buf->cifsConnectionList,
-			 &GlobalTreeConnectionList);
 		ret_buf->tidStatus = CifsNew;
 		INIT_LIST_HEAD(&ret_buf->openFileList);
-		init_MUTEX(&ret_buf->tconSem);
+		INIT_LIST_HEAD(&ret_buf->tcon_list);
 #ifdef CONFIG_CIFS_STATS
 		spin_lock_init(&ret_buf->stat_lock);
 #endif
-		write_unlock(&GlobalSMBSeslock);
 	}
 	return ret_buf;
 }
@@ -128,10 +126,7 @@ tconInfoFree(struct cifsTconInfo *buf_to_free)
 		cFYI(1, ("Null buffer passed to tconInfoFree"));
 		return;
 	}
-	write_lock(&GlobalSMBSeslock);
 	atomic_dec(&tconInfoAllocCount);
-	list_del(&buf_to_free->cifsConnectionList);
-	write_unlock(&GlobalSMBSeslock);
 	kfree(buf_to_free->nativeFileSystem);
 	kfree(buf_to_free);
 }
@@ -492,9 +487,10 @@ bool
 is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 {
 	struct smb_com_lock_req *pSMB = (struct smb_com_lock_req *)buf;
-	struct list_head *tmp;
-	struct list_head *tmp1;
+	struct list_head *tmp, *tmp1, *tmp2;
+	struct cifsSesInfo *ses;
 	struct cifsTconInfo *tcon;
+	struct cifsInodeInfo *pCifsInode;
 	struct cifsFileInfo *netfile;
 
 	cFYI(1, ("Checking for oplock break or dnotify response"));
@@ -549,42 +545,46 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 		return false;
 
 	/* look up tcon based on tid & uid */
-	read_lock(&GlobalSMBSeslock);
-	list_for_each(tmp, &GlobalTreeConnectionList) {
-		tcon = list_entry(tmp, struct cifsTconInfo, cifsConnectionList);
-		if ((tcon->tid == buf->Tid) && (srv == tcon->ses->server)) {
+	spin_lock(&srv->smb_session_lock);
+	list_for_each(tmp, &srv->smb_session_list) {
+		ses = list_entry(tmp, struct cifsSesInfo, smb_session_list);
+		spin_lock(&ses->tcon_lock);
+		list_for_each(tmp1, &ses->tcon_list) {
+			tcon = list_entry(tmp1, struct cifsTconInfo, tcon_list);
+			if (tcon->tid != buf->Tid)
+				continue;
+
 			cifs_stats_inc(&tcon->num_oplock_brks);
-			list_for_each(tmp1, &tcon->openFileList) {
-				netfile = list_entry(tmp1, struct cifsFileInfo,
+			list_for_each(tmp2, &tcon->openFileList) {
+				netfile = list_entry(tmp2, struct cifsFileInfo,
 						     tlist);
-				if (pSMB->Fid == netfile->netfid) {
-					struct cifsInodeInfo *pCifsInode;
-					read_unlock(&GlobalSMBSeslock);
-					cFYI(1,
-					    ("file id match, oplock break"));
-					pCifsInode =
-						CIFS_I(netfile->pInode);
-					pCifsInode->clientCanCacheAll = false;
-					if (pSMB->OplockLevel == 0)
-						pCifsInode->clientCanCacheRead
-							= false;
-					pCifsInode->oplockPending = true;
-					AllocOplockQEntry(netfile->pInode,
-							  netfile->netfid,
-							  tcon);
-					cFYI(1,
-					    ("about to wake up oplock thread"));
-					if (oplockThread)
-					    wake_up_process(oplockThread);
-					return true;
-				}
+				if (pSMB->Fid != netfile->netfid)
+					continue;
+
+				spin_unlock(&ses->tcon_lock);
+				spin_unlock(&srv->smb_session_lock);
+				cFYI(1, ("file id match, oplock break"));
+				pCifsInode = CIFS_I(netfile->pInode);
+				pCifsInode->clientCanCacheAll = false;
+				if (pSMB->OplockLevel == 0)
+					pCifsInode->clientCanCacheRead = false;
+				pCifsInode->oplockPending = true;
+				AllocOplockQEntry(netfile->pInode,
+						  netfile->netfid, tcon);
+				cFYI(1, ("about to wake up oplock thread"));
+				if (oplockThread)
+					wake_up_process(oplockThread);
+
+				return true;
 			}
-			read_unlock(&GlobalSMBSeslock);
+			spin_unlock(&ses->tcon_lock);
+			spin_unlock(&srv->smb_session_lock);
 			cFYI(1, ("No matching file for oplock break"));
 			return true;
 		}
+		spin_unlock(&ses->tcon_lock);
 	}
-	read_unlock(&GlobalSMBSeslock);
+	spin_unlock(&srv->smb_session_lock);
 	cFYI(1, ("Can not process oplock break for non-existent connection"));
 	return true;
 }
-- 
1.5.5.1

