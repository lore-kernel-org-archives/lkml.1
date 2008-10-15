Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYJOAm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYJOAm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 20:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYJOAlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 20:41:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47535 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbYJOAlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 20:41:18 -0400
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: smfrench@austin.rr.com, linux-kernel@vger.kernel.org, niallain@gmail.com,
       linux-cifs-client@lists.samba.org
Subject: [PATCH 5/5] cifs: add global TCP session list and reenable TCP session sharing
Date: Tue, 14 Oct 2008 20:41:07 -0400
Message-Id: <1224031267-17194-6-git-send-email-jlayton@redhat.com>
In-Reply-To: <1224031267-17194-1-git-send-email-jlayton@redhat.com>
References: <1224031267-17194-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the socket/session/tcon sharing code is disabled, we can start
implementing a new scheme. The idea is that this should be a heirarchy:

- A socket has a number of SMB sessions associated with it
- An SMB session has a number of tcon's associated with it

In addition to making the sharing of these structures race-free, we want
to reduce our reliance on global lists as much as possible, and use
fine-grained locking with well-defined rules about what each lock
protects.

Start by adding a new global list of TCP sessions. Add TCP sessions to
the list as they're created, and remove them as they're torn down.

Another optimization we could consider is separate lists for IPv4 and
IPv6, but this should be a good start.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifs_debug.c |    2 +-
 fs/cifs/cifsfs.c     |    8 +++
 fs/cifs/cifsglob.h   |    5 ++-
 fs/cifs/cifsproto.h  |    1 +
 fs/cifs/cifssmb.c    |   14 ++----
 fs/cifs/connect.c    |  123 ++++++++++++++++++++++++++++++++-----------------
 6 files changed, 99 insertions(+), 54 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 69a12aa..c998751 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -144,7 +144,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			seq_printf(m, "TCP status: %d\n\tLocal Users To "
 				    "Server: %d SecMode: 0x%x Req On Wire: %d",
 				ses->server->tcpStatus,
-				atomic_read(&ses->server->socketUseCount),
+				ses->server->refcount,
 				ses->server->secMode,
 				atomic_read(&ses->server->inFlight));
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 25ecbd5..c27cee8 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -91,6 +91,12 @@ extern mempool_t *cifs_mid_poolp;
 
 extern struct kmem_cache *cifs_oplock_cachep;
 
+/* global list of TCP_Server_Info structs */
+struct list_head	cifs_tcp_session_list;
+
+/* protects cifs_tcp_session_list and TCP_Server_Info refcount */
+spinlock_t		cifs_tcp_session_lock;
+
 static int
 cifs_read_super(struct super_block *sb, void *data,
 		const char *devname, int silent)
@@ -1017,6 +1023,7 @@ init_cifs(void)
 	INIT_LIST_HEAD(&GlobalSMBSessionList);
 	INIT_LIST_HEAD(&GlobalTreeConnectionList);
 	INIT_LIST_HEAD(&GlobalOplock_Q);
+	INIT_LIST_HEAD(&cifs_tcp_session_list);
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 	INIT_LIST_HEAD(&GlobalDnotifyReqList);
 	INIT_LIST_HEAD(&GlobalDnotifyRsp_Q);
@@ -1043,6 +1050,7 @@ init_cifs(void)
 	GlobalMaxActiveXid = 0;
 	memset(Local_System_Name, 0, 15);
 	rwlock_init(&GlobalSMBSeslock);
+	spin_lock_init(&cifs_tcp_session_lock);
 	spin_lock_init(&GlobalMid_Lock);
 
 	if (cifs_max_pending < 2) {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 72ec198..2a9b507 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -115,6 +115,8 @@ struct cifs_cred {
  */
 
 struct TCP_Server_Info {
+	struct list_head tcp_session_list;
+	int refcount; /* reference counter */
 	/* 15 character server name + 0x20 16th byte indicating type = srv */
 	char server_RFC1001_name[SERVER_NAME_LEN_WITH_NULL];
 	char unicode_server_Name[SERVER_NAME_LEN_WITH_NULL * 2];
@@ -133,7 +135,6 @@ struct TCP_Server_Info {
 	char versionMajor;
 	char versionMinor;
 	bool svlocal:1;			/* local server or remote */
-	atomic_t socketUseCount; /* number of open cifs sessions on socket */
 	atomic_t inFlight;  /* number of requests on the wire to server */
 #ifdef CONFIG_CIFS_STATS2
 	atomic_t inSend; /* requests trying to send */
@@ -592,6 +593,8 @@ GLOBAL_EXTERN struct smbUidInfo *GlobalUidList[UID_HASH];
 GLOBAL_EXTERN struct list_head GlobalSMBSessionList;
 GLOBAL_EXTERN struct list_head GlobalTreeConnectionList;
 GLOBAL_EXTERN rwlock_t GlobalSMBSeslock;  /* protects list inserts on 3 above */
+extern struct list_head		cifs_tcp_session_list;
+extern spinlock_t		cifs_tcp_session_lock;
 
 GLOBAL_EXTERN struct list_head GlobalOplock_Q;
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 0cff7fe..abd4580 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -102,6 +102,7 @@ extern void acl_to_uid_mode(struct inode *inode, const char *path,
 			    const __u16 *pfid);
 extern int mode_to_acl(struct inode *inode, const char *path, __u64);
 
+extern void cifs_put_tcp_session(struct TCP_Server_Info *server);
 extern int cifs_mount(struct super_block *, struct cifs_sb_info *, char *,
 			const char *);
 extern int cifs_umount(struct super_block *, struct cifs_sb_info *);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6f4ffe1..7b39c49 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -664,8 +664,8 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 			rc = -EIO;
 			goto neg_err_exit;
 		}
-
-		if (server->socketUseCount.counter > 1) {
+		spin_lock(&cifs_tcp_session_lock);
+		if (server->refcount > 1) {
 			if (memcmp(server->server_GUID,
 				   pSMBr->u.extended_response.
 				   GUID, 16) != 0) {
@@ -677,6 +677,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 		} else
 			memcpy(server->server_GUID,
 			       pSMBr->u.extended_response.GUID, 16);
+		spin_unlock(&cifs_tcp_session_lock);
 
 		if (count == 16) {
 			server->secType = RawNTLMSSP;
@@ -825,13 +826,8 @@ CIFSSMBLogoff(const int xid, struct cifsSesInfo *ses)
 	pSMB->AndXCommand = 0xFF;
 	rc = SendReceiveNoRsp(xid, ses, (struct smb_hdr *) pSMB, 0);
 	if (ses->server) {
-		atomic_dec(&ses->server->socketUseCount);
-		if (atomic_read(&ses->server->socketUseCount) == 0) {
-			spin_lock(&GlobalMid_Lock);
-			ses->server->tcpStatus = CifsExiting;
-			spin_unlock(&GlobalMid_Lock);
-			rc = -ESHUTDOWN;
-		}
+		cifs_put_tcp_session(ses->server);
+		rc = 0;
 	}
 	up(&ses->sesSem);
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index af0546f..3d5e53d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -647,6 +647,11 @@ multi_t2_fnd:
 		}
 	} /* end while !EXITING */
 
+	/* take it off the list, if it's not already */
+	spin_lock(&cifs_tcp_session_lock);
+	list_del_init(&server->tcp_session_list);
+	spin_unlock(&cifs_tcp_session_lock);
+
 	spin_lock(&GlobalMid_Lock);
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&GlobalMid_Lock);
@@ -1335,6 +1340,63 @@ cifs_parse_mount_options(char *options, const char *devname,
 	return 0;
 }
 
+static struct TCP_Server_Info *
+cifs_find_tcp_session(struct sockaddr *addr)
+{
+	struct list_head *tmp;
+	struct TCP_Server_Info *server;
+	struct sockaddr_in *addr4 = (struct sockaddr_in *) addr;
+	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *) addr;
+
+	spin_lock(&cifs_tcp_session_lock);
+	list_for_each(tmp, &cifs_tcp_session_list) {
+		server = list_entry(tmp, struct TCP_Server_Info,
+				    tcp_session_list);
+
+		/* Only accept sessions that have done successful negotiate */
+		if (server->tcpStatus == CifsNew)
+			continue;
+
+		if (addr->sa_family == AF_INET &&
+		    (addr4->sin_addr.s_addr !=
+		     server->addr.sockAddr.sin_addr.s_addr))
+			continue;
+		else if (addr->sa_family == AF_INET6 &&
+			 memcmp(&server->addr.sockAddr6.sin6_addr,
+				&addr6->sin6_addr, sizeof(addr6->sin6_addr)))
+			continue;
+
+		++server->refcount;
+		spin_unlock(&cifs_tcp_session_lock);
+		return server;
+	}
+	spin_unlock(&cifs_tcp_session_lock);
+	return NULL;
+}
+
+void
+cifs_put_tcp_session(struct TCP_Server_Info *server)
+{
+	struct task_struct *task;
+
+	spin_lock(&cifs_tcp_session_lock);
+	if (--server->refcount > 0) {
+		spin_unlock(&cifs_tcp_session_lock);
+		return;
+	}
+
+	list_del_init(&server->tcp_session_list);
+	spin_unlock(&cifs_tcp_session_lock);
+
+	spin_lock(&GlobalMid_Lock);
+	server->tcpStatus = CifsExiting;
+	spin_unlock(&GlobalMid_Lock);
+
+	task = xchg(&server->tsk, NULL);
+	if (task)
+		force_sig(SIGKILL, task);
+}
+
 int
 get_dfs_path(int xid, struct cifsSesInfo *pSesInfo, const char *old_path,
 	     const struct nls_table *nls_codepage, unsigned int *pnum_referrals,
@@ -1761,16 +1823,6 @@ convert_delimiter(char *path, char delim)
 	}
 }
 
-static void
-kill_cifsd(struct TCP_Server_Info *server)
-{
-	struct task_struct *task;
-
-	task = xchg(&server->tsk, NULL);
-	if (task)
-		force_sig(SIGKILL, task);
-}
-
 int
 cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 	   char *mount_data, const char *devname)
@@ -1862,6 +1914,8 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 		}
 	}
 
+	srvTcp = cifs_find_tcp_session(&addr);
+
 	if (srvTcp) {
 		cFYI(1, ("Existing tcp session with server found"));
 	} else {	/* create socket */
@@ -1926,6 +1980,12 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 			memcpy(srvTcp->server_RFC1001_name,
 				volume_info.target_rfc1001_name, 16);
 			srvTcp->sequence_number = 0;
+			INIT_LIST_HEAD(&srvTcp->tcp_session_list);
+			++srvTcp->refcount;
+			spin_lock(&cifs_tcp_session_lock);
+			list_add(&cifs_tcp_session_list,
+						&srvTcp->tcp_session_list);
+			spin_unlock(&cifs_tcp_session_lock);
 		}
 	}
 
@@ -1977,8 +2037,6 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 			rc = cifs_setup_session(xid, pSesInfo,
 						cifs_sb->local_nls);
 			up(&pSesInfo->sesSem);
-			if (!rc)
-				atomic_inc(&srvTcp->socketUseCount);
 		}
 	}
 
@@ -2127,35 +2185,20 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 
 /* on error free sesinfo and tcon struct if needed */
 	if (rc) {
-		/* if session setup failed, use count is zero but
-		we still need to free cifsd thread */
-		if (atomic_read(&srvTcp->socketUseCount) == 0) {
-			spin_lock(&GlobalMid_Lock);
-			srvTcp->tcpStatus = CifsExiting;
-			spin_unlock(&GlobalMid_Lock);
-			kill_cifsd(srvTcp);
-		}
-		 /* If find_unc succeeded then rc == 0 so we can not end */
-		if (tcon)  /* up accidently freeing someone elses tcon struct */
+		/* If find_unc succeeded then rc == 0 so we can not end */
+		/* up accidently freeing someone elses tcon struct */
+		if (tcon)
 			tconInfoFree(tcon);
+
 		if (existingCifsSes == NULL) {
 			if (pSesInfo) {
 				if ((pSesInfo->server) &&
-				    (pSesInfo->status == CifsGood)) {
-					int temp_rc;
-					temp_rc = CIFSSMBLogoff(xid, pSesInfo);
-					/* if the socketUseCount is now zero */
-					if ((temp_rc == -ESHUTDOWN) &&
-					    (pSesInfo->server))
-						kill_cifsd(pSesInfo->server);
-				} else {
+				    (pSesInfo->status == CifsGood))
+					CIFSSMBLogoff(xid, pSesInfo);
+				else {
 					cFYI(1, ("No session or bad tcon"));
-					if (pSesInfo->server) {
-						spin_lock(&GlobalMid_Lock);
-						srvTcp->tcpStatus = CifsExiting;
-						spin_unlock(&GlobalMid_Lock);
-						kill_cifsd(pSesInfo->server);
-					}
+					if (pSesInfo->server)
+						cifs_put_tcp_session(pSesInfo->server);
 				}
 				sesInfoFree(pSesInfo);
 				/* pSesInfo = NULL; */
@@ -3461,13 +3504,7 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 			if (rc == -EBUSY) {
 				FreeXid(xid);
 				return 0;
-			} else if (rc == -ESHUTDOWN) {
-				cFYI(1, ("Waking up socket by sending signal"));
-				if (ses->server)
-					kill_cifsd(ses->server);
-				rc = 0;
-			} /* else - we have an smb session
-				left on this socket do not kill cifsd */
+			}
 		} else
 			cFYI(1, ("No session or bad tcon"));
 	}
-- 
1.5.5.1

