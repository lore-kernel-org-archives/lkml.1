Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZAVPsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZAVPsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 10:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbZAVPs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 10:48:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37425 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbZAVPsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 10:48:25 -0500
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] cifs: make sure we allocate enough storage for socket address
Date: Thu, 22 Jan 2009 10:48:18 -0500
Message-Id: <1232639298-9168-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sockaddr declared on the stack in cifs_get_tcp_session is too small
for IPv6 addresses. Change it from "struct sockaddr" to "struct
sockaddr_storage" to prevent stack corruption when IPv6 is used.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a3537a9..2209be9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1354,7 +1354,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 }
 
 static struct TCP_Server_Info *
-cifs_find_tcp_session(struct sockaddr *addr)
+cifs_find_tcp_session(struct sockaddr_storage *addr)
 {
 	struct list_head *tmp;
 	struct TCP_Server_Info *server;
@@ -1374,11 +1374,11 @@ cifs_find_tcp_session(struct sockaddr *addr)
 		if (server->tcpStatus == CifsNew)
 			continue;
 
-		if (addr->sa_family == AF_INET &&
+		if (addr->ss_family == AF_INET &&
 		    (addr4->sin_addr.s_addr !=
 		     server->addr.sockAddr.sin_addr.s_addr))
 			continue;
-		else if (addr->sa_family == AF_INET6 &&
+		else if (addr->ss_family == AF_INET6 &&
 			 memcmp(&server->addr.sockAddr6.sin6_addr,
 				&addr6->sin6_addr, sizeof(addr6->sin6_addr)))
 			continue;
@@ -1419,12 +1419,12 @@ static struct TCP_Server_Info *
 cifs_get_tcp_session(struct smb_vol *volume_info)
 {
 	struct TCP_Server_Info *tcp_ses = NULL;
-	struct sockaddr addr;
+	struct sockaddr_storage addr;
 	struct sockaddr_in *sin_server = (struct sockaddr_in *) &addr;
 	struct sockaddr_in6 *sin_server6 = (struct sockaddr_in6 *) &addr;
 	int rc;
 
-	memset(&addr, 0, sizeof(struct sockaddr));
+	memset(&addr, 0, sizeof(struct sockaddr_storage));
 
 	if (volume_info->UNCip && volume_info->UNC) {
 		rc = cifs_inet_pton(AF_INET, volume_info->UNCip,
@@ -1435,9 +1435,9 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 			rc = cifs_inet_pton(AF_INET6, volume_info->UNCip,
 					    &sin_server6->sin6_addr.in6_u);
 			if (rc > 0)
-				addr.sa_family = AF_INET6;
+				addr.ss_family = AF_INET6;
 		} else {
-			addr.sa_family = AF_INET;
+			addr.ss_family = AF_INET;
 		}
 
 		if (rc <= 0) {
@@ -1502,7 +1502,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	tcp_ses->tcpStatus = CifsNew;
 	++tcp_ses->srv_count;
 
-	if (addr.sa_family == AF_INET6) {
+	if (addr.ss_family == AF_INET6) {
 		cFYI(1, ("attempting ipv6 connect"));
 		/* BB should we allow ipv6 on port 139? */
 		/* other OS never observed in Wild doing 139 with v6 */
-- 
1.5.5.6

