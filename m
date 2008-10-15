Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbYJOAmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYJOAmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 20:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYJOAlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 20:41:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47530 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYJOAlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 20:41:15 -0400
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: smfrench@austin.rr.com, linux-kernel@vger.kernel.org, niallain@gmail.com,
       linux-cifs-client@lists.samba.org
Subject: [PATCH 3/5] cifs: handle the TCP_Server_Info->tsk field more carefully
Date: Tue, 14 Oct 2008 20:41:05 -0400
Message-Id: <1224031267-17194-4-git-send-email-jlayton@redhat.com>
In-Reply-To: <1224031267-17194-1-git-send-email-jlayton@redhat.com>
References: <1224031267-17194-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently handle the TCP_Server_Info->tsk field without any locking,
but with some half-measures to try and prevent races. These aren't
really sufficient though. When taking down cifsd, use xchg() to swap
the contents of the tsk field with NULL so we don't end up trying
to send it more than one signal. Also, don't allow cifsd to exit until
the signal is received if we expect one.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |   41 ++++++++++++++++++++++++++++-------------
 1 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index dfc18c1..a631c15 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -748,6 +748,7 @@ multi_t2_fnd:
 	write_unlock(&GlobalSMBSeslock);
 
 	kfree(server->hostname);
+	task_to_wake = xchg(&server->tsk, NULL);
 	kfree(server);
 
 	length = atomic_dec_return(&tcpSesAllocCount);
@@ -755,6 +756,16 @@ multi_t2_fnd:
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv,
 				GFP_KERNEL);
 
+	/* if server->tsk was NULL then wait for a signal before exiting */
+	if (!task_to_wake) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		while(!signal_pending(current)) {
+			schedule();
+			set_current_state(TASK_INTERRUPTIBLE);
+		}
+		set_current_state(TASK_RUNNING);
+	}
+
 	return 0;
 }
 
@@ -1750,6 +1761,16 @@ convert_delimiter(char *path, char delim)
 	}
 }
 
+static void
+kill_cifsd(struct TCP_Server_Info *server)
+{
+	struct task_struct *task;
+
+	task = xchg(&server->tsk, NULL);
+	if (task)
+		force_sig(SIGKILL, task);
+}
+
 int
 cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 	   char *mount_data, const char *devname)
@@ -2113,7 +2134,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 			spin_lock(&GlobalMid_Lock);
 			srvTcp->tcpStatus = CifsExiting;
 			spin_unlock(&GlobalMid_Lock);
-			force_sig(SIGKILL, srvTcp->tsk);
+			kill_cifsd(srvTcp);
 		}
 		 /* If find_unc succeeded then rc == 0 so we can not end */
 		if (tcon)  /* up accidently freeing someone elses tcon struct */
@@ -2126,19 +2147,15 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 					temp_rc = CIFSSMBLogoff(xid, pSesInfo);
 					/* if the socketUseCount is now zero */
 					if ((temp_rc == -ESHUTDOWN) &&
-					    (pSesInfo->server) &&
-					    (pSesInfo->server->tsk))
-						force_sig(SIGKILL,
-							pSesInfo->server->tsk);
+					    (pSesInfo->server))
+						kill_cifsd(pSesInfo->server);
 				} else {
 					cFYI(1, ("No session or bad tcon"));
-					if ((pSesInfo->server) &&
-					    (pSesInfo->server->tsk)) {
+					if (pSesInfo->server) {
 						spin_lock(&GlobalMid_Lock);
 						srvTcp->tcpStatus = CifsExiting;
 						spin_unlock(&GlobalMid_Lock);
-						force_sig(SIGKILL,
-							pSesInfo->server->tsk);
+						kill_cifsd(pSesInfo->server);
 					}
 				}
 				sesInfoFree(pSesInfo);
@@ -3425,7 +3442,6 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 	int rc = 0;
 	int xid;
 	struct cifsSesInfo *ses = NULL;
-	struct task_struct *cifsd_task;
 	char *tmp;
 
 	xid = GetXid();
@@ -3441,7 +3457,6 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 		tconInfoFree(cifs_sb->tcon);
 		if ((ses) && (ses->server)) {
 			/* save off task so we do not refer to ses later */
-			cifsd_task = ses->server->tsk;
 			cFYI(1, ("About to do SMBLogoff "));
 			rc = CIFSSMBLogoff(xid, ses);
 			if (rc == -EBUSY) {
@@ -3449,8 +3464,8 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 				return 0;
 			} else if (rc == -ESHUTDOWN) {
 				cFYI(1, ("Waking up socket by sending signal"));
-				if (cifsd_task)
-					force_sig(SIGKILL, cifsd_task);
+				if (ses->server)
+					kill_cifsd(ses->server);
 				rc = 0;
 			} /* else - we have an smb session
 				left on this socket do not kill cifsd */
-- 
1.5.5.1

