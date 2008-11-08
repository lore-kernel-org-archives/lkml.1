Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYKHOOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYKHOOy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 09:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYKHOO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 09:14:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52955 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbYKHOO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 09:14:27 -0500
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: smfrench@austin.rr.com, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] cifs: clean up server protocol handling
Date: Sat,  8 Nov 2008 09:14:12 -0500
Message-Id: <1226153656-7741-2-git-send-email-jlayton@redhat.com>
In-Reply-To: <1226153656-7741-1-git-send-email-jlayton@redhat.com>
References: <1226153656-7741-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're currently declaring both a sockaddr_in and sockaddr6_in on the
stack, but we really only need storage for one of them. Declare a
sockaddr struct and cast it to the proper type. Also, eliminate the
protocolType field in the TCP_Server_Info struct. It's redundant since
we have a sa_family field in the sockaddr anyway.

We may need to revisit this if SCTP is ever implemented, but for now
this will simplify the code.

CIFS over IPv6 also has a number of problems currently. This fixes all
of them that I found. Eventually, it would be nice to move more of the
code to be protocol independent, but this is a start.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifs_spnego.c |    4 +-
 fs/cifs/cifsglob.h    |    8 -------
 fs/cifs/connect.c     |   55 +++++++++++++++++++++++++-----------------------
 3 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 9310d0c..f8eb14a 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -73,8 +73,8 @@ struct key_type cifs_spnego_key_type = {
  * strlen(";sec=ntlmsspi") */
 #define MAX_MECH_STR_LEN	13
 
-/* max possible addr len eg FEDC:BA98:7654:3210:FEDC:BA98:7654:3210/60 */
-#define MAX_IPV6_ADDR_LEN	42
+/* max possible addr len eg FEDC:BA98:7654:3210:FEDC:BA98:7654:3210/128 */
+#define MAX_IPV6_ADDR_LEN	43
 
 /* strlen of "host=" */
 #define HOST_KEY_LEN		5
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
index c682be8..22357ec 100644
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
@@ -1897,10 +1897,10 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
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
@@ -1911,6 +1911,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 
 /* cFYI(1, ("Entering cifs_mount. Xid: %d with: %s", xid, mount_data)); */
 
+	memset(&addr, 0, sizeof(struct sockaddr));
 	memset(&volume_info, 0, sizeof(struct smb_vol));
 	if (cifs_parse_mount_options(mount_data, devname, &volume_info)) {
 		rc = -EINVAL;
@@ -1933,16 +1934,16 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 
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
@@ -1982,14 +1983,14 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
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
@@ -1999,24 +2000,23 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 	if (srvTcp) {
 		cFYI(1, ("Existing tcp session with server found"));
 	} else {	/* create socket */
-		if (volume_info.port)
-			sin_server.sin_port = htons(volume_info.port);
-		else
-			sin_server.sin_port = 0;
-		if (address_type == AF_INET6) {
+		if (addr.sa_family == AF_INET6) {
 			cFYI(1, ("attempting ipv6 connect"));
 			/* BB should we allow ipv6 on port 139? */
 			/* other OS never observed in Wild doing 139 with v6 */
-			rc = ipv6_connect(&sin_server6, &csocket,
+			sin_server6->sin6_port = htons(volume_info.port);
+			rc = ipv6_connect(sin_server6, &csocket,
 					volume_info.noblocksnd);
-		} else
-			rc = ipv4_connect(&sin_server, &csocket,
+		} else {
+			sin_server->sin_port = htons(volume_info.port);
+			rc = ipv4_connect(sin_server, &csocket,
 				  volume_info.source_rfc1001_name,
 				  volume_info.target_rfc1001_name,
 				  volume_info.noblocksnd,
 				  volume_info.noautotune);
+		}
 		if (rc < 0) {
-			cERROR(1, ("Error connecting to IPv4 socket. "
+			cERROR(1, ("Error connecting to socket. "
 				   "Aborting operation"));
 			if (csocket != NULL)
 				sock_release(csocket);
@@ -2031,12 +2031,15 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 		} else {
 			srvTcp->noblocksnd = volume_info.noblocksnd;
 			srvTcp->noautotune = volume_info.noautotune;
-			memcpy(&srvTcp->addr.sockAddr, &sin_server,
-				sizeof(struct sockaddr_in));
+			if (addr.sa_family == AF_INET6)
+				memcpy(&srvTcp->addr.sockAddr6, sin_server6,
+					sizeof(struct sockaddr_in6));
+			else
+				memcpy(&srvTcp->addr.sockAddr, sin_server,
+					sizeof(struct sockaddr_in));
 			atomic_set(&srvTcp->inFlight, 0);
 			/* BB Add code for ipv6 case too */
 			srvTcp->ssocket = csocket;
-			srvTcp->protocolType = IPV4;
 			srvTcp->hostname = extract_hostname(volume_info.UNC);
 			if (IS_ERR(srvTcp->hostname)) {
 				rc = PTR_ERR(srvTcp->hostname);
@@ -2088,7 +2091,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 		else {
 			pSesInfo->server = srvTcp;
 			sprintf(pSesInfo->serverName, "%u.%u.%u.%u",
-				NIPQUAD(sin_server.sin_addr.s_addr));
+				NIPQUAD(sin_server->sin_addr.s_addr));
 		}
 
 		if (!rc) {
@@ -2207,7 +2210,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 				   "mount option supported"));
 
 		tcon =
-		    find_unc(sin_server.sin_addr.s_addr, volume_info.UNC,
+		    find_unc(sin_server->sin_addr.s_addr, volume_info.UNC,
 			     volume_info.username);
 		if (tcon) {
 			cFYI(1, ("Found match on UNC path"));
-- 
1.5.5.1

