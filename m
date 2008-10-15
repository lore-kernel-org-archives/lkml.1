Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbYJOAl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbYJOAl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 20:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYJOAlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 20:41:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47528 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYJOAlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 20:41:15 -0400
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: smfrench@austin.rr.com, linux-kernel@vger.kernel.org, niallain@gmail.com,
       linux-cifs-client@lists.samba.org
Subject: [PATCH 1/5] cifs: disable sharing of server, session and tcon
Date: Tue, 14 Oct 2008 20:41:03 -0400
Message-Id: <1224031267-17194-2-git-send-email-jlayton@redhat.com>
In-Reply-To: <1224031267-17194-1-git-send-email-jlayton@redhat.com>
References: <1224031267-17194-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code that allows these structs to be shared is extremely racy.
Disable them for now until we can come up with a way to do this that's
race free.

Note that this leaves a substantial amount of dead code in cifs_mount.
I'm leery of removing it at this point until we know for sure that we
aren't going to reuse it later.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |  105 -----------------------------------------------------
 1 files changed, 0 insertions(+), 105 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4c13bcd..492d3a9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1331,94 +1331,6 @@ cifs_parse_mount_options(char *options, const char *devname,
 	return 0;
 }
 
-static struct cifsSesInfo *
-cifs_find_tcp_session(struct in_addr *target_ip_addr,
-		      struct in6_addr *target_ip6_addr,
-		      char *userName, struct TCP_Server_Info **psrvTcp)
-{
-	struct list_head *tmp;
-	struct cifsSesInfo *ses;
-
-	*psrvTcp = NULL;
-
-	read_lock(&GlobalSMBSeslock);
-	list_for_each(tmp, &GlobalSMBSessionList) {
-		ses = list_entry(tmp, struct cifsSesInfo, cifsSessionList);
-		if (!ses->server)
-			continue;
-
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
-
-		/* BB check if reconnection needed */
-		if (strncmp(ses->userName, userName, MAX_USERNAME_SIZE) == 0) {
-			read_unlock(&GlobalSMBSeslock);
-			/* Found exact match on both TCP and
-			   SMB sessions */
-			return ses;
-		}
-		/* else tcp and smb sessions need reconnection */
-	}
-	read_unlock(&GlobalSMBSeslock);
-
-	return NULL;
-}
-
-static struct cifsTconInfo *
-find_unc(__be32 new_target_ip_addr, char *uncName, char *userName)
-{
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
-
-		cFYI(1, ("and old usr: %s new: %s",
-			tcon->treeName, uncName));
-
-		if (strncmp(tcon->ses->userName, userName, MAX_USERNAME_SIZE))
-			continue;
-
-		/* matched smb session (user name) */
-		read_unlock(&GlobalSMBSeslock);
-		return tcon;
-	}
-
-	read_unlock(&GlobalSMBSeslock);
-	return NULL;
-}
-
 int
 get_dfs_path(int xid, struct cifsSesInfo *pSesInfo, const char *old_path,
 	     const struct nls_table *nls_codepage, unsigned int *pnum_referrals,
@@ -1936,20 +1848,6 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 		}
 	}
 
-	if (address_type == AF_INET)
-		existingCifsSes = cifs_find_tcp_session(&sin_server.sin_addr,
-			NULL /* no ipv6 addr */,
-			volume_info.username, &srvTcp);
-	else if (address_type == AF_INET6) {
-		cFYI(1, ("looking for ipv6 address"));
-		existingCifsSes = cifs_find_tcp_session(NULL /* no ipv4 addr */,
-			&sin_server6.sin6_addr,
-			volume_info.username, &srvTcp);
-	} else {
-		rc = -EINVAL;
-		goto out;
-	}
-
 	if (srvTcp) {
 		cFYI(1, ("Existing tcp session with server found"));
 	} else {	/* create socket */
@@ -2155,9 +2053,6 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 			cERROR(1, ("mount option dynperm ignored if cifsacl "
 				   "mount option supported"));
 
-		tcon =
-		    find_unc(sin_server.sin_addr.s_addr, volume_info.UNC,
-			     volume_info.username);
 		if (tcon) {
 			cFYI(1, ("Found match on UNC path"));
 			/* we can have only one retry value for a connection
-- 
1.5.5.1

