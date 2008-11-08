Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYKHOPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYKHOPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 09:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbYKHOOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 09:14:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52958 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbYKHOO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 09:14:27 -0500
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: smfrench@austin.rr.com, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] cifs: reinstate sharing of SMB sessions sans races
Date: Sat,  8 Nov 2008 09:14:15 -0500
Message-Id: <1226153656-7741-5-git-send-email-jlayton@redhat.com>
In-Reply-To: <1226153656-7741-1-git-send-email-jlayton@redhat.com>
References: <1226153656-7741-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do this by abandoning the global list of SMB sessions and instead
moving to a per-server list. This entails adding a new list head to the
TCP_Server_Info struct. The refcounting for the cifsSesInfo is moved to
a non-atomic variable. We have to protect it by a lock anyway, so there's
no benefit to making it an atomic. The list and refcount are protected
by the global cifs_tcp_session_lock.

The patch also adds a new routines to find and put SMB sessions and
that properly take and put references under the lock.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifs_debug.c |   52 ++++++++--------
 fs/cifs/cifsfs.c     |   17 +++---
 fs/cifs/cifsglob.h   |    8 +-
 fs/cifs/cifsproto.h  |    1 -
 fs/cifs/cifssmb.c    |   10 +---
 fs/cifs/connect.c    |  155 +++++++++++++++++++++++++++++---------------------
 fs/cifs/misc.c       |   15 ++---
 7 files changed, 133 insertions(+), 125 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index e1804ca..cd4793f 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -107,9 +107,9 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 #ifdef CONFIG_PROC_FS
 static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 {
-	struct list_head *tmp;
-	struct list_head *tmp1;
+	struct list_head *tmp, *tmp2, *tmp3;
 	struct mid_q_entry *mid_entry;
+	struct TCP_Server_Info *server;
 	struct cifsSesInfo *ses;
 	struct cifsTconInfo *tcon;
 	int i;
@@ -122,43 +122,44 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 	seq_printf(m, "Servers:");
 
 	i = 0;
-	read_lock(&GlobalSMBSeslock);
-	list_for_each(tmp, &GlobalSMBSessionList) {
+	read_lock(&cifs_tcp_session_lock);
+	list_for_each(tmp, &cifs_tcp_session_list) {
+		server = list_entry(tmp, struct TCP_Server_Info,
+				    tcp_session_list);
 		i++;
-		ses = list_entry(tmp, struct cifsSesInfo, cifsSessionList);
-		if ((ses->serverDomain == NULL) || (ses->serverOS == NULL) ||
-		   (ses->serverNOS == NULL)) {
-			seq_printf(m, "\nentry for %s not fully "
-					"displayed\n\t", ses->serverName);
-		} else {
-			seq_printf(m,
+		list_for_each(tmp2, &server->smb_session_list) {
+			ses = list_entry(tmp2, struct cifsSesInfo,
+					 smb_session_list);
+			if ((ses->serverDomain == NULL) ||
+				(ses->serverOS == NULL) ||
+				(ses->serverNOS == NULL)) {
+				seq_printf(m, "\nentry for %s not fully "
+					   "displayed\n\t", ses->serverName);
+			} else {
+				seq_printf(m,
 				    "\n%d) Name: %s  Domain: %s Mounts: %d OS:"
 				    " %s  \n\tNOS: %s\tCapability: 0x%x\n\tSMB"
 				    " session status: %d\t",
 				i, ses->serverName, ses->serverDomain,
-				atomic_read(&ses->inUse),
-				ses->serverOS, ses->serverNOS,
+				ses->refcount, ses->serverOS, ses->serverNOS,
 				ses->capabilities, ses->status);
-		}
-		if (ses->server) {
+			}
 			seq_printf(m, "TCP status: %d\n\tLocal Users To "
-				    "Server: %d SecMode: 0x%x Req On Wire: %d",
-				ses->server->tcpStatus,
-				ses->server->refcount,
-				ses->server->secMode,
-				atomic_read(&ses->server->inFlight));
+			    "Server: %d SecMode: 0x%x Req On Wire: %d",
+			server->tcpStatus, server->refcount, server->secMode,
+			atomic_read(&server->inFlight));
 
 #ifdef CONFIG_CIFS_STATS2
 			seq_printf(m, " In Send: %d In MaxReq Wait: %d",
-				atomic_read(&ses->server->inSend),
-				atomic_read(&ses->server->num_waiters));
+				atomic_read(&server->inSend),
+				atomic_read(&server->num_waiters));
 #endif
 
 			seq_puts(m, "\nMIDs:\n");
 
 			spin_lock(&GlobalMid_Lock);
-			list_for_each(tmp1, &ses->server->pending_mid_q) {
-				mid_entry = list_entry(tmp1, struct
+			list_for_each(tmp3, &server->pending_mid_q) {
+				mid_entry = list_entry(tmp3, struct
 					mid_q_entry,
 					qhead);
 				seq_printf(m, "State: %d com: %d pid:"
@@ -171,9 +172,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			}
 			spin_unlock(&GlobalMid_Lock);
 		}
-
 	}
-	read_unlock(&GlobalSMBSeslock);
+	read_unlock(&cifs_tcp_session_lock);
 	seq_putc(m, '\n');
 
 	seq_puts(m, "Shares:");
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5a14d96..f930c90 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1037,24 +1037,24 @@ static int cifs_oplock_thread(void *dummyarg)
 static int cifs_dnotify_thread(void *dummyarg)
 {
 	struct list_head *tmp;
-	struct cifsSesInfo *ses;
+	struct TCP_Server_Info *server;
 
 	do {
 		if (try_to_freeze())
 			continue;
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(15*HZ);
-		read_lock(&GlobalSMBSeslock);
 		/* check if any stuck requests that need
 		   to be woken up and wakeq so the
 		   thread can wake up and error out */
-		list_for_each(tmp, &GlobalSMBSessionList) {
-			ses = list_entry(tmp, struct cifsSesInfo,
-				cifsSessionList);
-			if (ses->server && atomic_read(&ses->server->inFlight))
-				wake_up_all(&ses->server->response_q);
+		read_lock(&cifs_tcp_session_lock);
+		list_for_each(tmp, &cifs_tcp_session_list) {
+			server = list_entry(tmp, struct TCP_Server_Info,
+					 tcp_session_list);
+			if (atomic_read(&server->inFlight))
+				wake_up_all(&server->response_q);
 		}
-		read_unlock(&GlobalSMBSeslock);
+		read_unlock(&cifs_tcp_session_lock);
 	} while (!kthread_should_stop());
 
 	return 0;
@@ -1066,7 +1066,6 @@ init_cifs(void)
 	int rc = 0;
 	cifs_proc_init();
 /*	INIT_LIST_HEAD(&GlobalServerList);*/	/* BB not implemented yet */
-	INIT_LIST_HEAD(&GlobalSMBSessionList);
 	INIT_LIST_HEAD(&GlobalTreeConnectionList);
 	INIT_LIST_HEAD(&GlobalOplock_Q);
 	INIT_LIST_HEAD(&cifs_tcp_session_list);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0aec791..e7e59eb 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -119,7 +119,8 @@ struct cifs_cred {
  */
 
 struct TCP_Server_Info {
-	struct list_head tcp_session_list;
+	struct list_head tcp_session_list; /* link to global tcp sess list */
+	struct list_head smb_session_list; /* list of SMB sessions */
 	int refcount; /* reference counter */
 	/* 15 character server name + 0x20 16th byte indicating type = srv */
 	char server_RFC1001_name[SERVER_NAME_LEN_WITH_NULL];
@@ -191,13 +192,13 @@ struct cifsUidInfo {
  * Session structure.  One of these for each uid session with a particular host
  */
 struct cifsSesInfo {
-	struct list_head cifsSessionList;
+	struct list_head smb_session_list;
 	struct semaphore sesSem;
 #if 0
 	struct cifsUidInfo *uidInfo;	/* pointer to user info */
 #endif
 	struct TCP_Server_Info *server;	/* pointer to server info */
-	atomic_t inUse; /* # of mounts (tree connections) on this ses */
+	int refcount;		/* reference counter */
 	enum statusEnum status;
 	unsigned overrideSecFlg;  /* if non-zero override global sec flags */
 	__u16 ipc_tid;		/* special tid for connection to IPC share */
@@ -598,7 +599,6 @@ require use of the stronger protocol */
 GLOBAL_EXTERN struct smbUidInfo *GlobalUidList[UID_HASH];
 
 /* GLOBAL_EXTERN struct list_head GlobalServerList; BB not implemented yet */
-GLOBAL_EXTERN struct list_head GlobalSMBSessionList;
 GLOBAL_EXTERN struct list_head GlobalTreeConnectionList;
 GLOBAL_EXTERN rwlock_t GlobalSMBSeslock;  /* protects list inserts on 3 above */
 extern struct list_head		cifs_tcp_session_list;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 0250a99..6f21ecb 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -102,7 +102,6 @@ extern void acl_to_uid_mode(struct inode *inode, const char *path,
 			    const __u16 *pfid);
 extern int mode_to_acl(struct inode *inode, const char *path, __u64);
 
-extern void cifs_put_tcp_session(struct TCP_Server_Info *server);
 extern int cifs_mount(struct super_block *, struct cifs_sb_info *, char *,
 			const char *);
 extern int cifs_umount(struct super_block *, struct cifs_sb_info *);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 83e1527..e761b65 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -806,11 +806,6 @@ CIFSSMBLogoff(const int xid, struct cifsSesInfo *ses)
 	else
 		return -EIO;
 
-	atomic_dec(&ses->inUse);
-	if (atomic_read(&ses->inUse) > 0) {
-		up(&ses->sesSem);
-		return -EBUSY;
-	}
 	rc = small_smb_init(SMB_COM_LOGOFF_ANDX, 2, NULL, (void **)&pSMB);
 	if (rc) {
 		up(&ses->sesSem);
@@ -829,10 +824,6 @@ CIFSSMBLogoff(const int xid, struct cifsSesInfo *ses)
 
 	pSMB->AndXCommand = 0xFF;
 	rc = SendReceiveNoRsp(xid, ses, (struct smb_hdr *) pSMB, 0);
-	if (ses->server) {
-		cifs_put_tcp_session(ses->server);
-		rc = 0;
-	}
 	up(&ses->sesSem);
 
 	/* if session dead then we do not need to do ulogoff,
@@ -840,6 +831,7 @@ CIFSSMBLogoff(const int xid, struct cifsSesInfo *ses)
 		error */
 	if (rc == -EAGAIN)
 		rc = 0;
+
 	return rc;
 }
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index dbc6b48..63505f1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -144,23 +144,18 @@ cifs_reconnect(struct TCP_Server_Info *server)
 
 	/* before reconnecting the tcp session, mark the smb session (uid)
 		and the tid bad so they are not used until reconnected */
-	read_lock(&GlobalSMBSeslock);
-	list_for_each(tmp, &GlobalSMBSessionList) {
-		ses = list_entry(tmp, struct cifsSesInfo, cifsSessionList);
-		if (ses->server) {
-			if (ses->server == server) {
-				ses->status = CifsNeedReconnect;
-				ses->ipc_tid = 0;
-			}
-		}
-		/* else tcp and smb sessions need reconnection */
+	read_lock(&cifs_tcp_session_lock);
+	list_for_each(tmp, &server->smb_session_list) {
+		ses = list_entry(tmp, struct cifsSesInfo, smb_session_list);
+		ses->status = CifsNeedReconnect;
+		ses->ipc_tid = 0;
 	}
+	read_unlock(&cifs_tcp_session_lock);
 	list_for_each(tmp, &GlobalTreeConnectionList) {
 		tcon = list_entry(tmp, struct cifsTconInfo, cifsConnectionList);
 		if ((tcon->ses) && (tcon->ses->server == server))
 			clear_bit(CIFS_CONNECTED, &tcon->tidStatus);
 	}
-	read_unlock(&GlobalSMBSeslock);
 	/* do not want to be sending data on a socket we are freeing */
 	down(&server->tcpSem);
 	if (server->ssocket) {
@@ -696,29 +691,25 @@ multi_t2_fnd:
 	if (smallbuf) /* no sense logging a debug message if NULL */
 		cifs_small_buf_release(smallbuf);
 
-	read_lock(&GlobalSMBSeslock);
+	read_lock(&cifs_tcp_session_lock);
 	if (list_empty(&server->pending_mid_q)) {
 		/* loop through server session structures attached to this and
 		    mark them dead */
-		list_for_each(tmp, &GlobalSMBSessionList) {
-			ses =
-			    list_entry(tmp, struct cifsSesInfo,
-				       cifsSessionList);
-			if (ses->server == server) {
-				ses->status = CifsExiting;
-				ses->server = NULL;
-			}
+		list_for_each(tmp, &server->smb_session_list) {
+			ses = list_entry(tmp, struct cifsSesInfo,
+					 smb_session_list);
+			ses->status = CifsExiting;
+			ses->server = NULL;
 		}
-		read_unlock(&GlobalSMBSeslock);
+		read_unlock(&cifs_tcp_session_lock);
 	} else {
 		/* although we can not zero the server struct pointer yet,
 		since there are active requests which may depnd on them,
 		mark the corresponding SMB sessions as exiting too */
-		list_for_each(tmp, &GlobalSMBSessionList) {
+		list_for_each(tmp, &server->smb_session_list) {
 			ses = list_entry(tmp, struct cifsSesInfo,
-					 cifsSessionList);
-			if (ses->server == server)
-				ses->status = CifsExiting;
+					 smb_session_list);
+			ses->status = CifsExiting;
 		}
 
 		spin_lock(&GlobalMid_Lock);
@@ -733,7 +724,7 @@ multi_t2_fnd:
 			}
 		}
 		spin_unlock(&GlobalMid_Lock);
-		read_unlock(&GlobalSMBSeslock);
+		read_unlock(&cifs_tcp_session_lock);
 		/* 1/8th of sec is more than enough time for them to exit */
 		msleep(125);
 	}
@@ -755,14 +746,12 @@ multi_t2_fnd:
 	if there are any pointing to this (e.g
 	if a crazy root user tried to kill cifsd
 	kernel thread explicitly this might happen) */
-	write_lock(&GlobalSMBSeslock);
-	list_for_each(tmp, &GlobalSMBSessionList) {
-		ses = list_entry(tmp, struct cifsSesInfo,
-				cifsSessionList);
-		if (ses->server == server)
-			ses->server = NULL;
+	read_lock(&cifs_tcp_session_lock);
+	list_for_each(tmp, &server->smb_session_list) {
+		ses = list_entry(tmp, struct cifsSesInfo, smb_session_list);
+		ses->server = NULL;
 	}
-	write_unlock(&GlobalSMBSeslock);
+	read_unlock(&cifs_tcp_session_lock);
 
 	kfree(server->hostname);
 	task_to_wake = xchg(&server->tsk, NULL);
@@ -1396,7 +1385,7 @@ cifs_find_tcp_session(struct sockaddr *addr)
 	return NULL;
 }
 
-void
+static void
 cifs_put_tcp_session(struct TCP_Server_Info *server)
 {
 	struct task_struct *task;
@@ -1419,6 +1408,50 @@ cifs_put_tcp_session(struct TCP_Server_Info *server)
 		force_sig(SIGKILL, task);
 }
 
+static struct cifsSesInfo *
+cifs_find_smb_session(struct TCP_Server_Info *server, char *username)
+{
+	struct list_head *tmp;
+	struct cifsSesInfo *ses;
+
+	write_lock(&cifs_tcp_session_lock);
+	list_for_each(tmp, &server->smb_session_list) {
+		ses = list_entry(tmp, struct cifsSesInfo, smb_session_list);
+		if (strncmp(ses->userName, username, MAX_USERNAME_SIZE))
+			continue;
+
+		++ses->refcount;
+		write_unlock(&cifs_tcp_session_lock);
+		return ses;
+	}
+	write_unlock(&cifs_tcp_session_lock);
+	return NULL;
+}
+
+static void
+cifs_put_smb_session(struct cifsSesInfo *ses)
+{
+	int xid;
+	struct TCP_Server_Info *server = ses->server;
+
+	write_lock(&cifs_tcp_session_lock);
+	if (--ses->refcount > 0) {
+		write_unlock(&cifs_tcp_session_lock);
+		return;
+	}
+
+	list_del_init(&ses->smb_session_list);
+	write_unlock(&cifs_tcp_session_lock);
+
+	if (ses->status == CifsGood) {
+		xid = GetXid();
+		CIFSSMBLogoff(xid, ses);
+		_FreeXid(xid);
+	}
+	sesInfoFree(ses);
+	cifs_put_tcp_session(server);
+}
+
 int
 get_dfs_path(int xid, struct cifsSesInfo *pSesInfo, const char *old_path,
 	     const struct nls_table *nls_codepage, unsigned int *pnum_referrals,
@@ -1867,7 +1900,6 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 	struct sockaddr_in6 *sin_server6 = (struct sockaddr_in6 *) &addr;
 	struct smb_vol volume_info;
 	struct cifsSesInfo *pSesInfo = NULL;
-	struct cifsSesInfo *existingCifsSes = NULL;
 	struct cifsTconInfo *tcon = NULL;
 	struct TCP_Server_Info *srvTcp = NULL;
 
@@ -2021,6 +2053,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 				volume_info.target_rfc1001_name, 16);
 			srvTcp->sequence_number = 0;
 			INIT_LIST_HEAD(&srvTcp->tcp_session_list);
+			INIT_LIST_HEAD(&srvTcp->smb_session_list);
 			++srvTcp->refcount;
 			write_lock(&cifs_tcp_session_lock);
 			list_add(&srvTcp->tcp_session_list,
@@ -2029,10 +2062,16 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 		}
 	}
 
-	if (existingCifsSes) {
-		pSesInfo = existingCifsSes;
+	pSesInfo = cifs_find_smb_session(srvTcp, volume_info.username);
+	if (pSesInfo) {
 		cFYI(1, ("Existing smb sess found (status=%d)",
 			pSesInfo->status));
+		/*
+		 * The existing SMB session already has a reference to srvTcp,
+		 * so we can put back the extra one we got before
+		 */
+		cifs_put_tcp_session(srvTcp);
+
 		down(&pSesInfo->sesSem);
 		if (pSesInfo->status == CifsNeedReconnect) {
 			cFYI(1, ("Session needs reconnect"));
@@ -2046,9 +2085,15 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 		if (pSesInfo == NULL)
 			rc = -ENOMEM;
 		else {
+			/* new SMB session uses our srvTcp ref */
 			pSesInfo->server = srvTcp;
 			sprintf(pSesInfo->serverName, "%u.%u.%u.%u",
 				NIPQUAD(sin_server->sin_addr.s_addr));
+			++pSesInfo->refcount;
+			write_lock(&cifs_tcp_session_lock);
+			list_add(&pSesInfo->smb_session_list,
+				 &srvTcp->smb_session_list);
+			write_unlock(&cifs_tcp_session_lock);
 		}
 
 		if (!rc) {
@@ -2212,7 +2257,6 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 					}
 				}
 				if (!rc) {
-					atomic_inc(&pSesInfo->inUse);
 					tcon->retry = volume_info.retry;
 					tcon->nocase = volume_info.nocase;
 					tcon->seal = volume_info.seal;
@@ -2230,28 +2274,18 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 	/* BB FIXME fix time_gran to be larger for LANMAN sessions */
 	sb->s_time_gran = 100;
 
-/* on error free sesinfo and tcon struct if needed */
+	/* on error free sesinfo and tcon struct if needed */
 	if (rc) {
 		/* If find_unc succeeded then rc == 0 so we can not end */
 		/* up accidently freeing someone elses tcon struct */
 		if (tcon)
 			tconInfoFree(tcon);
 
-		if (existingCifsSes == NULL) {
-			if (pSesInfo) {
-				if ((pSesInfo->server) &&
-				    (pSesInfo->status == CifsGood))
-					CIFSSMBLogoff(xid, pSesInfo);
-				else {
-					cFYI(1, ("No session or bad tcon"));
-					if (pSesInfo->server)
-						cifs_put_tcp_session(
-							pSesInfo->server);
-				}
-				sesInfoFree(pSesInfo);
-				/* pSesInfo = NULL; */
-			}
-		}
+		/* should also end up putting our tcp session ref if needed */
+		if (pSesInfo)
+			cifs_put_smb_session(pSesInfo);
+		else
+			cifs_put_tcp_session(srvTcp);
 	} else {
 		atomic_inc(&tcon->useCount);
 		cifs_sb->tcon = tcon;
@@ -3545,16 +3579,7 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 		}
 		DeleteTconOplockQEntries(cifs_sb->tcon);
 		tconInfoFree(cifs_sb->tcon);
-		if ((ses) && (ses->server)) {
-			/* save off task so we do not refer to ses later */
-			cFYI(1, ("About to do SMBLogoff "));
-			rc = CIFSSMBLogoff(xid, ses);
-			if (rc == -EBUSY) {
-				FreeXid(xid);
-				return 0;
-			}
-		} else
-			cFYI(1, ("No session or bad tcon"));
+		cifs_put_smb_session(ses);
 	}
 
 	cifs_sb->tcon = NULL;
@@ -3562,8 +3587,6 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 	cifs_sb->prepathlen = 0;
 	cifs_sb->prepath = NULL;
 	kfree(tmp);
-	if (ses)
-		sesInfoFree(ses);
 
 	FreeXid(xid);
 	return rc;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 7736a38..21f4f35 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -75,12 +75,10 @@ sesInfoAlloc(void)
 
 	ret_buf = kzalloc(sizeof(struct cifsSesInfo), GFP_KERNEL);
 	if (ret_buf) {
-		write_lock(&GlobalSMBSeslock);
 		atomic_inc(&sesInfoAllocCount);
 		ret_buf->status = CifsNew;
-		list_add(&ret_buf->cifsSessionList, &GlobalSMBSessionList);
+		INIT_LIST_HEAD(&ret_buf->smb_session_list);
 		init_MUTEX(&ret_buf->sesSem);
-		write_unlock(&GlobalSMBSeslock);
 	}
 	return ret_buf;
 }
@@ -93,10 +91,7 @@ sesInfoFree(struct cifsSesInfo *buf_to_free)
 		return;
 	}
 
-	write_lock(&GlobalSMBSeslock);
 	atomic_dec(&sesInfoAllocCount);
-	list_del(&buf_to_free->cifsSessionList);
-	write_unlock(&GlobalSMBSeslock);
 	kfree(buf_to_free->serverOS);
 	kfree(buf_to_free->serverDomain);
 	kfree(buf_to_free->serverNOS);
@@ -349,9 +344,9 @@ header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
 				if (current->fsuid != treeCon->ses->linux_uid) {
 					cFYI(1, ("Multiuser mode and UID "
 						 "did not match tcon uid"));
-					read_lock(&GlobalSMBSeslock);
-					list_for_each(temp_item, &GlobalSMBSessionList) {
-						ses = list_entry(temp_item, struct cifsSesInfo, cifsSessionList);
+					read_lock(&cifs_tcp_session_lock);
+					list_for_each(temp_item, &treeCon->ses->server->smb_session_list) {
+						ses = list_entry(temp_item, struct cifsSesInfo, smb_session_list);
 						if (ses->linux_uid == current->fsuid) {
 							if (ses->server == treeCon->ses->server) {
 								cFYI(1, ("found matching uid substitute right smb_uid"));
@@ -363,7 +358,7 @@ header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
 							}
 						}
 					}
-					read_unlock(&GlobalSMBSeslock);
+					read_unlock(&cifs_tcp_session_lock);
 				}
 			}
 		}
-- 
1.5.5.1

