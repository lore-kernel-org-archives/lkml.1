Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYIGLOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYIGLOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 07:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYIGLNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 07:13:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36800 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbYIGLNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 07:13:49 -0400
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [CIFS] eliminate usage of kthread_stop for cifsd (resend)
Date: Sun,  7 Sep 2008 07:11:56 -0400
Message-Id: <1220785916-22543-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending to wider distribution list per Steve French's request)

When cifs_demultiplex_thread was converted to a kthread based kernel
thread, great pains were taken to make it so that kthread_stop would be
used to bring it down. This just added unnecessary complexity since we
needed to use a signal anyway to break out of kernel_recvmsg.

Also, cifs_demultiplex_thread does a bit of cleanup as it's exiting, and
we need to be certain that this gets done. It's possible for a kthread
to exit before its main function is ever run if kthread_stop is called
soon after its creation. While I'm not sure that this is a real problem
with cifsd now, it could be at some point in the future if cifs_mount is
ever changed to bring down the thread quickly.

The upshot here is that using kthread_stop to bring down the thread just
adds extra complexity with no real benefit. This patch changes the code
to use the original method to bring down the thread, but still leaves it
so that the thread is actually started with kthread_run.

This seems to fix the deadlock caused by the reproducer in this bug
report:

https://bugzilla.samba.org/show_bug.cgi?id=5720

If this patch looks OK, I think it's probably 2.6.28 material, though
getting it into linux-next ASAP would be good way to get it some
exposure.

As a side comment, the locking and refcounting with cifsd startup and
shutdown is really hairy, and there are probably other races lurking
here. We really need for someone to take a hard look at this code and
try to clarify and clean up the locking on the variables involved.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |   42 +++++++++++++-----------------------------
 1 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4c13bcd..0d63fc7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -124,7 +124,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	struct mid_q_entry *mid_entry;
 
 	spin_lock(&GlobalMid_Lock);
-	if (kthread_should_stop()) {
+	if (server->tcpStatus == CifsExiting) {
 		/* the demux thread will exit normally
 		next time through the loop */
 		spin_unlock(&GlobalMid_Lock);
@@ -184,7 +184,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	spin_unlock(&GlobalMid_Lock);
 	up(&server->tcpSem);
 
-	while ((!kthread_should_stop()) && (server->tcpStatus != CifsGood)) {
+	while ((server->tcpStatus != CifsExiting) &&
+	       (server->tcpStatus != CifsGood)) {
 		try_to_freeze();
 		if (server->protocolType == IPV6) {
 			rc = ipv6_connect(&server->addr.sockAddr6,
@@ -201,7 +202,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		} else {
 			atomic_inc(&tcpSesReconnectCount);
 			spin_lock(&GlobalMid_Lock);
-			if (!kthread_should_stop())
+			if (server->tcpStatus != CifsExiting)
 				server->tcpStatus = CifsGood;
 			server->sequence_number = 0;
 			spin_unlock(&GlobalMid_Lock);
@@ -356,7 +357,7 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 				GFP_KERNEL);
 
 	set_freezable();
-	while (!kthread_should_stop()) {
+	while (server->tcpStatus != CifsExiting) {
 		if (try_to_freeze())
 			continue;
 		if (bigbuf == NULL) {
@@ -397,7 +398,7 @@ incomplete_rcv:
 		    kernel_recvmsg(csocket, &smb_msg,
 				&iov, 1, pdu_length, 0 /* BB other flags? */);
 
-		if (kthread_should_stop()) {
+		if (server->tcpStatus == CifsExiting) {
 			break;
 		} else if (server->tcpStatus == CifsNeedReconnect) {
 			cFYI(1, ("Reconnect after server stopped responding"));
@@ -522,7 +523,7 @@ incomplete_rcv:
 		     total_read += length) {
 			length = kernel_recvmsg(csocket, &smb_msg, &iov, 1,
 						pdu_length - total_read, 0);
-			if (kthread_should_stop() ||
+			if ((server->tcpStatus == CifsExiting) ||
 			    (length == -EINTR)) {
 				/* then will exit */
 				reconnect = 2;
@@ -651,14 +652,6 @@ multi_t2_fnd:
 	spin_unlock(&GlobalMid_Lock);
 	wake_up_all(&server->response_q);
 
-	/* don't exit until kthread_stop is called */
-	set_current_state(TASK_UNINTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		schedule();
-		set_current_state(TASK_UNINTERRUPTIBLE);
-	}
-	set_current_state(TASK_RUNNING);
-
 	/* check if we have blocked requests that need to free */
 	/* Note that cifs_max_pending is normally 50, but
 	can be set at module install time to as little as two */
@@ -2225,14 +2218,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 			spin_lock(&GlobalMid_Lock);
 			srvTcp->tcpStatus = CifsExiting;
 			spin_unlock(&GlobalMid_Lock);
-			if (srvTcp->tsk) {
-				/* If we could verify that kthread_stop would
-				   always wake up processes blocked in
-				   tcp in recv_mesg then we could remove the
-				   send_sig call */
-				force_sig(SIGKILL, srvTcp->tsk);
-				kthread_stop(srvTcp->tsk);
-			}
+			force_sig(SIGKILL, srvTcp->tsk);
 		}
 		 /* If find_unc succeeded then rc == 0 so we can not end */
 		if (tcon)  /* up accidently freeing someone elses tcon struct */
@@ -2246,18 +2232,18 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 					/* if the socketUseCount is now zero */
 					if ((temp_rc == -ESHUTDOWN) &&
 					    (pSesInfo->server) &&
-					    (pSesInfo->server->tsk)) {
+					    (pSesInfo->server->tsk))
 						force_sig(SIGKILL,
 							pSesInfo->server->tsk);
-						kthread_stop(pSesInfo->server->tsk);
-					}
 				} else {
 					cFYI(1, ("No session or bad tcon"));
 					if ((pSesInfo->server) &&
 					    (pSesInfo->server->tsk)) {
+						spin_lock(&GlobalMid_Lock);
+						srvTcp->tcpStatus = CifsExiting;
+						spin_unlock(&GlobalMid_Lock);
 						force_sig(SIGKILL,
 							pSesInfo->server->tsk);
-						kthread_stop(pSesInfo->server->tsk);
 					}
 				}
 				sesInfoFree(pSesInfo);
@@ -3568,10 +3554,8 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 				return 0;
 			} else if (rc == -ESHUTDOWN) {
 				cFYI(1, ("Waking up socket by sending signal"));
-				if (cifsd_task) {
+				if (cifsd_task)
 					force_sig(SIGKILL, cifsd_task);
-					kthread_stop(cifsd_task);
-				}
 				rc = 0;
 			} /* else - we have an smb session
 				left on this socket do not kill cifsd */
-- 
1.5.5.1

