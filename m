Return-Path: <linux-kernel-owner+w=401wt.eu-S1763646AbYEAPyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763646AbYEAPyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760368AbYEAPyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:54:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:4404 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbYEAPyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=eTahE38tD1Ptbh4JePz6kR+Ti2WX22E0mDTOOi3YUJQNLMpqzrF45MAbp7Z3bZIe5Vdc6gq4SKaR0VXCg4y6RveV/Z94+QgxxLMk/Q34YP6ylkrD/hb+KFF/yov5pKjEs9TmgZ281ObQZAZaIacnjWDmxhnT+bgE54UznWy3j24=
References: <20080501154830.235254575@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 01 May 2008 19:48:32 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steve French <sfrench@samba.org>, linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 2/2] cifs - cifs_find_tcp_session cleanup
Content-Disposition: inline; filename=cifs-cifs_find_tcp_session
Message-ID: <4819e79f.0c07560a.5b13.ffff8e6c@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to remove too indented code in cifs_find_tcp_session.
Also memcmp was used wrongly - we would have found the session
which IP6 addresses didn't match.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/fs/cifs/connect.c
===================================================================
--- linux-2.6.git.orig/fs/cifs/connect.c	2008-05-01 19:02:51.000000000 +0400
+++ linux-2.6.git/fs/cifs/connect.c	2008-05-01 19:36:54.000000000 +0400
@@ -1318,42 +1318,44 @@ cifs_parse_mount_options(char *options, 
 
 static struct cifsSesInfo *
 cifs_find_tcp_session(struct in_addr *target_ip_addr,
-		struct in6_addr *target_ip6_addr,
-		 char *userName, struct TCP_Server_Info **psrvTcp)
+		      struct in6_addr *target_ip6_addr,
+		      char *userName, struct TCP_Server_Info **psrvTcp)
 {
 	struct list_head *tmp;
 	struct cifsSesInfo *ses;
+
 	*psrvTcp = NULL;
-	read_lock(&GlobalSMBSeslock);
 
+	if (!target_ip_addr)
+		return NULL;
+
+	read_lock(&GlobalSMBSeslock);
 	list_for_each(tmp, &GlobalSMBSessionList) {
 		ses = list_entry(tmp, struct cifsSesInfo, cifsSessionList);
-		if (ses->server) {
-			if ((target_ip_addr &&
-				(ses->server->addr.sockAddr.sin_addr.s_addr
-				  == target_ip_addr->s_addr)) || (target_ip6_addr
-				&& memcmp(&ses->server->addr.sockAddr6.sin6_addr,
-					target_ip6_addr, sizeof(*target_ip6_addr)))) {
-				/* BB lock server and tcp session and increment
-				      use count here?? */
-
-				/* found a match on the TCP session */
-				*psrvTcp = ses->server;
-
-				/* BB check if reconnection needed */
-				if (strncmp
-				    (ses->userName, userName,
-				     MAX_USERNAME_SIZE) == 0){
-					read_unlock(&GlobalSMBSeslock);
-					/* Found exact match on both TCP and
-					   SMB sessions */
-					return ses;
-				}
-			}
-		}
-		/* else tcp and smb sessions need reconnection */
+		if (!ses->server)
+			continue;
+
+		if (ses->server->addr.sockAddr.sin_addr.s_addr != target_ip_addr->s_addr ||
+		    memcmp(&ses->server->addr.sockAddr6.sin6_addr,
+			   target_ip6_addr, sizeof(*target_ip6_addr)))
+			continue;
+
+		/* BB lock server and tcp session and increment
+		   use count here?? */
+
+		/* found a match on the TCP session */
+		*psrvTcp = ses->server;
+
+		/* BB check if reconnection needed */
+		if (strncmp(ses->userName, userName, MAX_USERNAME_SIZE))
+			continue;
+
+		/* Found exact match on both TCP and SMB sessions */
+		read_unlock(&GlobalSMBSeslock);
+		return ses;
 	}
 	read_unlock(&GlobalSMBSeslock);
+
 	return NULL;
 }
 

-- 
