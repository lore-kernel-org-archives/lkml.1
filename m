Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbYJ3PQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbYJ3PQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYJ3PQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:16:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41936 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023AbYJ3PQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:16:40 -0400
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: smfrench@austin.rr.com, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] cifs: clean up server protocol handling for TCP_Server_Info
Date: Thu, 30 Oct 2008 11:16:30 -0400
Message-Id: <1225379793-23283-2-git-send-email-jlayton@redhat.com>
In-Reply-To: <1225379793-23283-1-git-send-email-jlayton@redhat.com>
References: <1225379793-23283-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're currently declaring both a sockaddr_in and sockaddr6_in on the
stack, but we really only need storage for one of them. Declare a
sockaddr struct and cast it to the proper type. Also, eliminate the
protocolType field in the TCP_Server_Info struct. It's redundant since
we have a sin_family field in the sockaddr anyway.

We may need to revisit this if SCTP is ever implemented, but for now
this will simplify the code.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifsglob.h |    8 --------
 fs/cifs/connect.c  |   39 +++++++++++++++++++--------------------
 2 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 1fc051e..58b8d5c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -84,13 +84,6 @@ enum securityEnum {
 	MSKerberos,		/* MS Kerberos via SPNEGO */
 };
 
-enum protocolEnum {
-	IPV4 = 0,
-	IPV6,
-	SCTP
-	/* Netbios frames protocol not supported at this time */
-};
-
 struct mac_key {
 	unsigned int len;
 	union {
@@ -137,7 +130,6 @@ struct TCP_Server_Info {
 	void *Server_NlsInfo;	/* BB - placeholder for future NLS info  */
 	unsigned short server_codepage;	/* codepage for the server    */
 	unsigned long ip_address;	/* IP addr for the server if known */
-	enum protocolEnum protocolType;
 	char versionMajor;
 	char versionMinor;
 	bool svlocal:1;			/* local server or remote */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index e9f9248..7d0b2e5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -193,7 +193,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	while ((server->tcpStatus != CifsExiting) &&
 	       (server->tcpStatus != CifsGood)) {
 		try_to_freeze();
-		if (server->protocolType == IPV6) {
+		if (server->addr.sockAddr6.sin6_family == AF_INET6) {
 			rc = ipv6_connect(&server->addr.sockAddr6,
 					  &server->ssocket, server->noautotune);
 		} else {
@@ -1892,10 +1892,10 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 {
 	int rc = 0;
 	int xid;
-	int address_type = AF_INET;
 	struct socket *csocket = NULL;
-	struct sockaddr_in sin_server;
-	struct sockaddr_in6 sin_server6;
+	struct sockaddr addr;
+	struct sockaddr_in *sin_server = (struct sockaddr_in *) &addr;
+	struct sockaddr_in6 *sin_server6 = (struct sockaddr_in6 *) &addr;
 	struct smb_vol volume_info;
 	struct cifsSesInfo *pSesInfo = NULL;
 	struct cifsSesInfo *existingCifsSes = NULL;
@@ -1928,16 +1928,16 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 
 	if (volume_info.UNCip && volume_info.UNC) {
 		rc = cifs_inet_pton(AF_INET, volume_info.UNCip,
-				    &sin_server.sin_addr.s_addr);
+				    &sin_server->sin_addr.s_addr);
 
 		if (rc <= 0) {
 			/* not ipv4 address, try ipv6 */
 			rc = cifs_inet_pton(AF_INET6, volume_info.UNCip,
-					    &sin_server6.sin6_addr.in6_u);
+					    &sin_server6->sin6_addr.in6_u);
 			if (rc > 0)
-				address_type = AF_INET6;
+				addr.sa_family = AF_INET6;
 		} else {
-			address_type = AF_INET;
+			addr.sa_family = AF_INET;
 		}
 
 		if (rc <= 0) {
@@ -1977,14 +1977,14 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 		}
 	}
 
-	if (address_type == AF_INET)
-		existingCifsSes = cifs_find_tcp_session(&sin_server.sin_addr,
+	if (addr.sa_family == AF_INET)
+		existingCifsSes = cifs_find_tcp_session(&sin_server->sin_addr,
 			NULL /* no ipv6 addr */,
 			volume_info.username, &srvTcp);
-	else if (address_type == AF_INET6) {
+	else if (addr.sa_family == AF_INET6) {
 		cFYI(1, ("looking for ipv6 address"));
 		existingCifsSes = cifs_find_tcp_session(NULL /* no ipv4 addr */,
-			&sin_server6.sin6_addr,
+			&sin_server6->sin6_addr,
 			volume_info.username, &srvTcp);
 	} else {
 		rc = -EINVAL;
@@ -1995,17 +1995,17 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 		cFYI(1, ("Existing tcp session with server found"));
 	} else {	/* create socket */
 		if (volume_info.port)
-			sin_server.sin_port = htons(volume_info.port);
+			sin_server->sin_port = htons(volume_info.port);
 		else
-			sin_server.sin_port = 0;
-		if (address_type == AF_INET6) {
+			sin_server->sin_port = 0;
+		if (addr.sa_family == AF_INET6) {
 			cFYI(1, ("attempting ipv6 connect"));
 			/* BB should we allow ipv6 on port 139? */
 			/* other OS never observed in Wild doing 139 with v6 */
-			rc = ipv6_connect(&sin_server6, &csocket,
+			rc = ipv6_connect(sin_server6, &csocket,
 					volume_info.noblocksnd);
 		} else
-			rc = ipv4_connect(&sin_server, &csocket,
+			rc = ipv4_connect(sin_server, &csocket,
 				  volume_info.source_rfc1001_name,
 				  volume_info.target_rfc1001_name,
 				  volume_info.noblocksnd,
@@ -2026,12 +2026,11 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 		} else {
 			srvTcp->noblocksnd = volume_info.noblocksnd;
 			srvTcp->noautotune = volume_info.noautotune;
-			memcpy(&srvTcp->addr.sockAddr, &sin_server,
+			memcpy(&srvTcp->addr.sockAddr, sin_server,
 				sizeof(struct sockaddr_in));
 			atomic_set(&srvTcp->inFlight, 0);
 			/* BB Add code for ipv6 case too */
 			srvTcp->ssocket = csocket;
-			srvTcp->protocolType = IPV4;
 			srvTcp->hostname = extract_hostname(volume_info.UNC);
 			if (IS_ERR(srvTcp->hostname)) {
 				rc = PTR_ERR(srvTcp->hostname);
@@ -2083,7 +2082,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 		else {
 			pSesInfo->server = srvTcp;
 			sprintf(pSesInfo->serverName, "%u.%u.%u.%u",
-				NIPQUAD(sin_server.sin_addr.s_addr));
+				NIPQUAD(sin_server->sin_addr.s_addr));
 		}
 
 		if (!rc) {
-- 
1.5.5.1

