Return-Path: <linux-kernel-owner+w=401wt.eu-S1763468AbYEAPyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763468AbYEAPyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761688AbYEAPyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:54:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:4426 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759262AbYEAPyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=Va2N4NYVgHLhquUTiK93zOTlLiY1ZYyu4UVcrLhRiR4md07x5j7I+qrGrD2N3va39pB7rpxwsK+FWME1FrW7OaCGZziHC2c2Re6ogLrRydHwbUMe7YWEXNLv7BoaQgAlzACGQjZqDRMR7umODpJukTA+np3MpXyFsCAzhbCXVOY=
References: <20080501154830.235254575@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 01 May 2008 19:48:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steve French <sfrench@samba.org>, linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 1/2] cifs - find_unc cleanup
Content-Disposition: inline; filename=cifs-find-unc
Message-ID: <4819e79f.0c58560a.0f2c.ffff9899@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to remove too indented code in find_unc

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/fs/cifs/connect.c
===================================================================
--- linux-2.6.git.orig/fs/cifs/connect.c	2008-05-01 18:21:38.000000000 +0400
+++ linux-2.6.git/fs/cifs/connect.c	2008-05-01 19:02:51.000000000 +0400
@@ -1362,45 +1362,43 @@ find_unc(__be32 new_target_ip_addr, char
 {
 	struct list_head *tmp;
 	struct cifsTconInfo *tcon;
+	__be32 old_ip;
 
 	read_lock(&GlobalSMBSeslock);
+
 	list_for_each(tmp, &GlobalTreeConnectionList) {
 		cFYI(1, ("Next tcon"));
 		tcon = list_entry(tmp, struct cifsTconInfo, cifsConnectionList);
-		if (tcon->ses) {
-			if (tcon->ses->server) {
-				cFYI(1,
-				     ("old ip addr: %x == new ip %x ?",
-				      tcon->ses->server->addr.sockAddr.sin_addr.
-				      s_addr, new_target_ip_addr));
-				if (tcon->ses->server->addr.sockAddr.sin_addr.
-				    s_addr == new_target_ip_addr) {
-	/* BB lock tcon, server and tcp session and increment use count here? */
-					/* found a match on the TCP session */
-					/* BB check if reconnection needed */
-					cFYI(1,
-					      ("IP match, old UNC: %s new: %s",
-					      tcon->treeName, uncName));
-					if (strncmp
-					    (tcon->treeName, uncName,
-					     MAX_TREE_SIZE) == 0) {
-						cFYI(1,
-						     ("and old usr: %s new: %s",
-						      tcon->treeName, uncName));
-						if (strncmp
-						    (tcon->ses->userName,
-						     userName,
-						     MAX_USERNAME_SIZE) == 0) {
-							read_unlock(&GlobalSMBSeslock);
-							/* matched smb session
-							(user name */
-							return tcon;
-						}
-					}
-				}
-			}
-		}
+		if (!tcon->ses || !tcon->ses->server)
+			continue;
+
+		old_ip = tcon->ses->server->addr.sockAddr.sin_addr.s_addr;
+		cFYI(1, ("old ip addr: %x == new ip %x ?",
+			old_ip, new_target_ip_addr));
+
+		if (old_ip != new_target_ip_addr)
+			continue;
+
+		/* BB lock tcon, server and tcp session and increment use count here? */
+		/* found a match on the TCP session */
+		/* BB check if reconnection needed */
+		cFYI(1, ("IP match, old UNC: %s new: %s",
+			tcon->treeName, uncName));
+
+		if (strncmp(tcon->treeName, uncName, MAX_TREE_SIZE))
+			continue;
+
+		cFYI(1, ("and old usr: %s new: %s",
+			tcon->treeName, uncName));
+
+		if (strncmp(tcon->ses->userName, userName, MAX_USERNAME_SIZE))
+			continue;
+
+		/* matched smb session (user name) */
+		read_unlock(&GlobalSMBSeslock);
+		return tcon;
 	}
+
 	read_unlock(&GlobalSMBSeslock);
 	return NULL;
 }

-- 
