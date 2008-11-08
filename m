Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYKHOPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYKHOPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 09:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYKHOOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 09:14:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52957 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbYKHOO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 09:14:27 -0500
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: smfrench@austin.rr.com, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] cifs: disable sharing session and tcon and add new TCP sharing code
Date: Sat,  8 Nov 2008 09:14:14 -0500
Message-Id: <1226153656-7741-4-git-send-email-jlayton@redhat.com>
In-Reply-To: <1226153656-7741-1-git-send-email-jlayton@redhat.com>
References: <1226153656-7741-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code that allows these structs to be shared is extremely racy.
Disable the sharing of SMB and tcon structs for now until we can
come up with a way to do this that's race free.

We want to continue to share TCP sessions, however since they are
required for multiuser mounts. For that, implement a new (hopefully
race-free) scheme. Add a new global list of TCP sessions, and take
care to get a reference to it whenever we're dealing with one.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifs_debug.c |    2 +-
 fs/cifs/cifsfs.c     |    8 ++
 fs/cifs/cifsglob.h   |    5 +-
 fs/cifs/cifsproto.h  |    1 +
 fs/cifs/cifssmb.c    |   18 ++---
 fs/cifs/connect.c    |  192 ++++++++++++++++----------------------------------
 6 files changed, 84 insertions(+), 142 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index ed16bbb..e1804ca 100644
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
index 3d6129f..5a14d96 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -91,6 +91,12 @@ extern mempool_t *cifs_mid_poolp;
 
 extern struct kmem_cache *cifs_oplock_cachep;
 
+/* global list of TCP_Server_Info structs */
+struct list_head	cifs_tcp_session_list;
+
+/* protects cifs_tcp_session_list and TCP_Server_Info refcount */
+rwlock_t		cifs_tcp_session_lock;
+
 static int
 cifs_read_super(struct super_block *sb, void *data,
 		const char *devname, int silent)
@@ -1063,6 +1069,7 @@ init_cifs(void)
 	INIT_LIST_HEAD(&GlobalSMBSessionList);
 	INIT_LIST_HEAD(&GlobalTreeConnectionList);
 	INIT_LIST_HEAD(&GlobalOplock_Q);
+	INIT_LIST_HEAD(&cifs_tcp_session_list);
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 	INIT_LIST_HEAD(&GlobalDnotifyReqList);
 	INIT_LIST_HEAD(&GlobalDnotifyRsp_Q);
@@ -1089,6 +1096,7 @@ init_cifs(void)
 	GlobalMaxActiveXid = 0;
 	memset(Local_System_Name, 0, 15);
 	rwlock_init(&GlobalSMBSeslock);
+	rwlock_init(&cifs_tcp_session_lock);
 	spin_lock_init(&GlobalMid_Lock);
 
 	if (cifs_max_pending < 2) {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f97ddef..0aec791 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -119,6 +119,8 @@ struct cifs_cred {
  */
 
 struct TCP_Server_Info {
+	struct list_head tcp_session_list;
+	int refcount; /* reference counter */
 	/* 15 character server name + 0x20 16th byte indicating type = srv */
 	char server_RFC1001_name[SERVER_NAME_LEN_WITH_NULL];
 	char unicode_server_Name[SERVER_NAME_LEN_WITH_NULL * 2];
@@ -139,7 +141,6 @@ struct TCP_Server_Info {
 	bool svlocal:1;			/* local server or remote */
 	bool noblocksnd;		/* use blocking sendmsg */
 	bool noautotune;		/* do not autotune send buf sizes */
-	atomic_t socketUseCount; /* number of open cifs sessions on socket */
 	atomic_t inFlight;  /* number of requests on the wire to server */
 #ifdef CONFIG_CIFS_STATS2
 	atomic_t inSend; /* requests trying to send */
@@ -600,6 +601,8 @@ GLOBAL_EXTERN struct smbUidInfo *GlobalUidList[UID_HASH];
 GLOBAL_EXTERN struct list_head GlobalSMBSessionList;
 GLOBAL_EXTERN struct list_head GlobalTreeConnectionList;
 GLOBAL_EXTERN rwlock_t GlobalSMBSeslock;  /* protects list inserts on 3 above */
+extern struct list_head		cifs_tcp_session_list;
+extern rwlock_t			cifs_tcp_session_lock;
 
 GLOBAL_EXTERN struct list_head GlobalOplock_Q;
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 6f21ecb..0250a99 100644
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
index 29bd4a4..83e1527 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -666,8 +666,9 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 			rc = -EIO;
 			goto neg_err_exit;
 		}
-
-		if (server->socketUseCount.counter > 1) {
+		read_lock(&cifs_tcp_session_lock);
+		if (server->refcount > 1) {
+			read_unlock(&cifs_tcp_session_lock);
 			if (memcmp(server->server_GUID,
 				   pSMBr->u.extended_response.
 				   GUID, 16) != 0) {
@@ -676,9 +677,11 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 					pSMBr->u.extended_response.GUID,
 					16);
 			}
-		} else
+		} else {
+			read_unlock(&cifs_tcp_session_lock);
 			memcpy(server->server_GUID,
 			       pSMBr->u.extended_response.GUID, 16);
+		}
 
 		if (count == 16) {
 			server->secType = RawNTLMSSP;
@@ -827,13 +830,8 @@ CIFSSMBLogoff(const int xid, struct cifsSesInfo *ses)
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
index 9d627f9..dbc6b48 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -659,6 +659,11 @@ multi_t2_fnd:
 		}
 	} /* end while !EXITING */
 
+	/* take it off the list, if it's not already */
+	write_lock(&cifs_tcp_session_lock);
+	list_del_init(&server->tcp_session_list);
+	write_unlock(&cifs_tcp_session_lock);
+
 	spin_lock(&GlobalMid_Lock);
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&GlobalMid_Lock);
@@ -1357,92 +1362,61 @@ cifs_parse_mount_options(char *options, const char *devname,
 	return 0;
 }
 
-static struct cifsSesInfo *
-cifs_find_tcp_session(struct in_addr *target_ip_addr,
-		      struct in6_addr *target_ip6_addr,
-		      char *userName, struct TCP_Server_Info **psrvTcp)
+static struct TCP_Server_Info *
+cifs_find_tcp_session(struct sockaddr *addr)
 {
 	struct list_head *tmp;
-	struct cifsSesInfo *ses;
+	struct TCP_Server_Info *server;
+	struct sockaddr_in *addr4 = (struct sockaddr_in *) addr;
+	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *) addr;
 
-	*psrvTcp = NULL;
+	write_lock(&cifs_tcp_session_lock);
+	list_for_each(tmp, &cifs_tcp_session_list) {
+		server = list_entry(tmp, struct TCP_Server_Info,
+				    tcp_session_list);
 
-	read_lock(&GlobalSMBSeslock);
-	list_for_each(tmp, &GlobalSMBSessionList) {
-		ses = list_entry(tmp, struct cifsSesInfo, cifsSessionList);
-		if (!ses->server)
+		/* Only accept sessions that have done successful negotiate */
+		if (server->tcpStatus == CifsNew)
 			continue;
 
-		if (target_ip_addr &&
-		    ses->server->addr.sockAddr.sin_addr.s_addr != target_ip_addr->s_addr)
-				continue;
-		else if (target_ip6_addr &&
-			 memcmp(&ses->server->addr.sockAddr6.sin6_addr,
-				target_ip6_addr, sizeof(*target_ip6_addr)))
-				continue;
-		/* BB lock server and tcp session; increment use count here?? */
-
-		/* found a match on the TCP session */
-		*psrvTcp = ses->server;
+		if (addr->sa_family == AF_INET &&
+		    (addr4->sin_addr.s_addr !=
+		     server->addr.sockAddr.sin_addr.s_addr))
+			continue;
+		else if (addr->sa_family == AF_INET6 &&
+			 memcmp(&server->addr.sockAddr6.sin6_addr,
+				&addr6->sin6_addr, sizeof(addr6->sin6_addr)))
+			continue;
 
-		/* BB check if reconnection needed */
-		if (strncmp(ses->userName, userName, MAX_USERNAME_SIZE) == 0) {
-			read_unlock(&GlobalSMBSeslock);
-			/* Found exact match on both TCP and
-			   SMB sessions */
-			return ses;
-		}
-		/* else tcp and smb sessions need reconnection */
+		++server->refcount;
+		write_unlock(&cifs_tcp_session_lock);
+		return server;
 	}
-	read_unlock(&GlobalSMBSeslock);
-
+	write_unlock(&cifs_tcp_session_lock);
 	return NULL;
 }
 
-static struct cifsTconInfo *
-find_unc(__be32 new_target_ip_addr, char *uncName, char *userName)
+void
+cifs_put_tcp_session(struct TCP_Server_Info *server)
 {
-	struct list_head *tmp;
-	struct cifsTconInfo *tcon;
-	__be32 old_ip;
-
-	read_lock(&GlobalSMBSeslock);
-
-	list_for_each(tmp, &GlobalTreeConnectionList) {
-		cFYI(1, ("Next tcon"));
-		tcon = list_entry(tmp, struct cifsTconInfo, cifsConnectionList);
-		if (!tcon->ses || !tcon->ses->server)
-			continue;
-
-		old_ip = tcon->ses->server->addr.sockAddr.sin_addr.s_addr;
-		cFYI(1, ("old ip addr: %x == new ip %x ?",
-			old_ip, new_target_ip_addr));
-
-		if (old_ip != new_target_ip_addr)
-			continue;
-
-		/* BB lock tcon, server, tcp session and increment use count? */
-		/* found a match on the TCP session */
-		/* BB check if reconnection needed */
-		cFYI(1, ("IP match, old UNC: %s new: %s",
-			tcon->treeName, uncName));
-
-		if (strncmp(tcon->treeName, uncName, MAX_TREE_SIZE))
-			continue;
+	struct task_struct *task;
 
-		cFYI(1, ("and old usr: %s new: %s",
-			tcon->treeName, uncName));
+	write_lock(&cifs_tcp_session_lock);
+	if (--server->refcount > 0) {
+		write_unlock(&cifs_tcp_session_lock);
+		return;
+	}
 
-		if (strncmp(tcon->ses->userName, userName, MAX_USERNAME_SIZE))
-			continue;
+	list_del_init(&server->tcp_session_list);
+	write_unlock(&cifs_tcp_session_lock);
 
-		/* matched smb session (user name) */
-		read_unlock(&GlobalSMBSeslock);
-		return tcon;
-	}
+	spin_lock(&GlobalMid_Lock);
+	server->tcpStatus = CifsExiting;
+	spin_unlock(&GlobalMid_Lock);
 
-	read_unlock(&GlobalSMBSeslock);
-	return NULL;
+	task = xchg(&server->tsk, NULL);
+	if (task)
+		force_sig(SIGKILL, task);
 }
 
 int
@@ -1881,16 +1855,6 @@ convert_delimiter(char *path, char delim)
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
@@ -1983,20 +1947,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 		}
 	}
 
-	if (addr.sa_family == AF_INET)
-		existingCifsSes = cifs_find_tcp_session(&sin_server->sin_addr,
-			NULL /* no ipv6 addr */,
-			volume_info.username, &srvTcp);
-	else if (addr.sa_family == AF_INET6) {
-		cFYI(1, ("looking for ipv6 address"));
-		existingCifsSes = cifs_find_tcp_session(NULL /* no ipv4 addr */,
-			&sin_server6->sin6_addr,
-			volume_info.username, &srvTcp);
-	} else {
-		rc = -EINVAL;
-		goto out;
-	}
-
+	srvTcp = cifs_find_tcp_session(&addr);
 	if (srvTcp) {
 		cFYI(1, ("Existing tcp session with server found"));
 	} else {	/* create socket */
@@ -2069,6 +2020,12 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 			memcpy(srvTcp->server_RFC1001_name,
 				volume_info.target_rfc1001_name, 16);
 			srvTcp->sequence_number = 0;
+			INIT_LIST_HEAD(&srvTcp->tcp_session_list);
+			++srvTcp->refcount;
+			write_lock(&cifs_tcp_session_lock);
+			list_add(&srvTcp->tcp_session_list,
+				 &cifs_tcp_session_list);
+			write_unlock(&cifs_tcp_session_lock);
 		}
 	}
 
@@ -2120,8 +2077,6 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 			rc = cifs_setup_session(xid, pSesInfo,
 						cifs_sb->local_nls);
 			up(&pSesInfo->sesSem);
-			if (!rc)
-				atomic_inc(&srvTcp->socketUseCount);
 		}
 	}
 
@@ -2209,9 +2164,6 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 			cERROR(1, ("mount option dynperm ignored if cifsacl "
 				   "mount option supported"));
 
-		tcon =
-		    find_unc(sin_server->sin_addr.s_addr, volume_info.UNC,
-			     volume_info.username);
 		if (tcon) {
 			cFYI(1, ("Found match on UNC path"));
 			/* we can have only one retry value for a connection
@@ -2280,35 +2232,21 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 
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
+						cifs_put_tcp_session(
+							pSesInfo->server);
 				}
 				sesInfoFree(pSesInfo);
 				/* pSesInfo = NULL; */
@@ -3614,13 +3552,7 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
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

