Return-Path: <linux-kernel-owner+w=401wt.eu-S1764240AbYCTBOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764240AbYCTBOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 21:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYCTBOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 21:14:14 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1529 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbYCTBOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 21:14:12 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Steve French <sfrench@samba.org>, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org
Subject: [PATCH 3/4] fs/cifs - Remove an indent level, use normal kthread_run arguments
Date: Wed, 19 Mar 2008 18:11:14 -0700
Message-Id: <1205975475-12708-3-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1205975475-12708-2-git-send-email-joe@perches.com>
References: <1205975475-12708-1-git-send-email-joe@perches.com>
 <1205975475-12708-2-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/cifs/connect.c |   54 +++++++++++++++++++++++++---------------------------
 1 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7c0e1ac..ca16fdc 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -330,8 +330,9 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 }
 
 static int
-cifs_demultiplex_thread(struct TCP_Server_Info *server)
+cifs_demultiplex_thread(void *data);
 {
+	struct TCP_Server_Info *server = data;
 	int length;
 	unsigned int pdu_length, total_read;
 	struct smb_hdr *smb_buffer = NULL;
@@ -1367,35 +1368,31 @@ find_unc(__be32 new_target_ip_addr, char *uncName, char *userName)
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
+		if (tcon->ses && tcon->ses->server) {
+			cFYI(1,
+			     ("old ip addr: %x == new ip %x ?",
+			      tcon->ses->server->addr.sockAddr.sin_addr.s_addr,
+			      new_target_ip_addr));
+			if (tcon->ses->server->addr.sockAddr.sin_addr.s_addr ==
+			    new_target_ip_addr) {
 	/* BB lock tcon, server and tcp session and increment use count here? */
-					/* found a match on the TCP session */
-					/* BB check if reconnection needed */
+				/* found a match on the TCP session */
+				/* BB check if reconnection needed */
+				cFYI(1,
+				     ("IP match, old UNC: %s new: %s",
+				      tcon->treeName, uncName));
+				if (strncmp(tcon->treeName, uncName,
+					    MAX_TREE_SIZE) == 0) {
 					cFYI(1,
-					      ("IP match, old UNC: %s new: %s",
+					     ("and old usr: %s new: %s",
 					      tcon->treeName, uncName));
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
+					if (strncmp(tcon->ses->userName,
+						    userName,
+						    MAX_USERNAME_SIZE) == 0) {
+						read_unlock(&GlobalSMBSeslock);
+						/* matched smb session
+						   (user name */
+						return tcon;
 					}
 				}
 			}
@@ -1973,7 +1970,8 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 			so no need to spinlock this init of tcpStatus */
 			srvTcp->tcpStatus = CifsNew;
 			init_MUTEX(&srvTcp->tcpSem);
-			srvTcp->tsk = kthread_run((void *)(void *)cifs_demultiplex_thread, srvTcp, "cifsd");
+			srvTcp->tsk = kthread_run(cifs_demultiplex_thread,
+						  srvTcp, "cifsd");
 			if (IS_ERR(srvTcp->tsk)) {
 				rc = PTR_ERR(srvTcp->tsk);
 				cERROR(1, ("error %d create cifsd thread", rc));
-- 
1.5.4.rc2

