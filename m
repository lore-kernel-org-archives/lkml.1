Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbYLKTrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbYLKTrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757964AbYLKTTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:40 -0500
Received: from kroah.org ([198.145.64.141]:56872 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757600AbYLKTTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:38 -0500
Date: Thu, 11 Dec 2008 11:16:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, smfrench@gmail.com, shirishp@us.ibm.com,
       sjayaraman@suse.de, Jeff Layton <jlayton@redhat.com>
Subject: [patch 82/83] cifs: fix a regression in cifs umount codepath
Message-ID: <20081211191654.GD5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-fix-a-regression-in-cifs-umount-codepath.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

backport of 469ee614aaa367d9cde01cbdd2027212f56c6cc6 upstream.

Several cifs patches were added to 2.6.27.8 to fix some races in the
mount/umount codepath. When this was done, a couple of prerequisite
patches were missed causing a minor regression.

When the last cifs mount to a server goes away, the kthread that manages
the socket is supposed to come down. The patches that went into 2.6.27.8
removed the kthread_stop calls that used to take down these threads, but
left the thread function expecting them. This made the thread stay up
even after the last mount was gone.

This patch should fix up this regression and also prevent a possible
race where a dead task could be signalled.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>
Acked-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |   36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -128,7 +128,7 @@ cifs_reconnect(struct TCP_Server_Info *s
 	struct mid_q_entry *mid_entry;
 
 	spin_lock(&GlobalMid_Lock);
-	if (kthread_should_stop()) {
+	if (server->tcpStatus == CifsExiting) {
 		/* the demux thread will exit normally
 		next time through the loop */
 		spin_unlock(&GlobalMid_Lock);
@@ -182,7 +182,8 @@ cifs_reconnect(struct TCP_Server_Info *s
 	spin_unlock(&GlobalMid_Lock);
 	up(&server->tcpSem);
 
-	while ((!kthread_should_stop()) && (server->tcpStatus != CifsGood)) {
+	while ((server->tcpStatus != CifsExiting) &&
+	       (server->tcpStatus != CifsGood)) {
 		try_to_freeze();
 		if (server->addr.sockAddr6.sin6_family == AF_INET6) {
 			rc = ipv6_connect(&server->addr.sockAddr6,
@@ -200,7 +201,7 @@ cifs_reconnect(struct TCP_Server_Info *s
 		} else {
 			atomic_inc(&tcpSesReconnectCount);
 			spin_lock(&GlobalMid_Lock);
-			if (!kthread_should_stop())
+			if (server->tcpStatus != CifsExiting)
 				server->tcpStatus = CifsGood;
 			server->sequence_number = 0;
 			spin_unlock(&GlobalMid_Lock);
@@ -355,7 +356,7 @@ cifs_demultiplex_thread(struct TCP_Serve
 				GFP_KERNEL);
 
 	set_freezable();
-	while (!kthread_should_stop()) {
+	while (server->tcpStatus != CifsExiting) {
 		if (try_to_freeze())
 			continue;
 		if (bigbuf == NULL) {
@@ -396,7 +397,7 @@ incomplete_rcv:
 		    kernel_recvmsg(csocket, &smb_msg,
 				&iov, 1, pdu_length, 0 /* BB other flags? */);
 
-		if (kthread_should_stop()) {
+		if (server->tcpStatus == CifsExiting) {
 			break;
 		} else if (server->tcpStatus == CifsNeedReconnect) {
 			cFYI(1, ("Reconnect after server stopped responding"));
@@ -527,7 +528,7 @@ incomplete_rcv:
 		     total_read += length) {
 			length = kernel_recvmsg(csocket, &smb_msg, &iov, 1,
 						pdu_length - total_read, 0);
-			if (kthread_should_stop() ||
+			if ((server->tcpStatus == CifsExiting) ||
 			    (length == -EINTR)) {
 				/* then will exit */
 				reconnect = 2;
@@ -661,14 +662,6 @@ multi_t2_fnd:
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
@@ -764,6 +757,7 @@ multi_t2_fnd:
 	read_unlock(&cifs_tcp_ses_lock);
 
 	kfree(server->hostname);
+	task_to_wake = xchg(&server->tsk, NULL);
 	kfree(server);
 
 	length = atomic_dec_return(&tcpSesAllocCount);
@@ -771,6 +765,16 @@ multi_t2_fnd:
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv,
 				GFP_KERNEL);
 
+	/* if server->tsk was NULL then wait for a signal before exiting */
+	if (!task_to_wake) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		while (!signal_pending(current)) {
+			schedule();
+			set_current_state(TASK_INTERRUPTIBLE);
+		}
+		set_current_state(TASK_RUNNING);
+	}
+
 	return 0;
 }
 
@@ -2310,7 +2314,7 @@ cifs_mount(struct super_block *sb, struc
 	/* on error free sesinfo and tcon struct if needed */
 mount_fail_check:
 	if (rc) {
-		 /* If find_unc succeeded then rc == 0 so we can not end */
+		/* If find_unc succeeded then rc == 0 so we can not end */
 		/* up accidently freeing someone elses tcon struct */
 		if (tcon)
 			cifs_put_tcon(tcon);
@@ -3715,8 +3719,10 @@ int cifs_setup_session(unsigned int xid,
 		cERROR(1, ("Send error in SessSetup = %d", rc));
 	} else {
 		cFYI(1, ("CIFS Session Established successfully"));
+			spin_lock(&GlobalMid_Lock);
 			pSesInfo->status = CifsGood;
 			pSesInfo->need_reconnect = false;
+			spin_unlock(&GlobalMid_Lock);
 	}
 
 ss_err_exit:

