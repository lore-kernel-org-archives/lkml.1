Return-Path: <linux-kernel-owner+w=401wt.eu-S932191Ab0A2Ujj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab0A2Ujj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754913Ab0A2Ujc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:39:32 -0500
Received: from www.tglx.de ([62.245.132.106]:44800 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964Ab0A2Uja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:39:30 -0500
Message-Id: <20100129203613.554147570@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 29 Jan 2010 20:38:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [patch 05/10] cifs: convert semaphore to mutex
References: <20100129203549.526478432@linutronix.de>
Content-Disposition: inline; filename=cifs-convert-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pSesInfo->sesSem is used as mutex. Rename it to session_mutex and
convert it to a real mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Steve French <sfrench@us.ibm.com>
---
 fs/cifs/cifsglob.h |    2 +-
 fs/cifs/cifssmb.c  |   12 ++++++------
 fs/cifs/connect.c  |    8 ++++----
 fs/cifs/misc.c     |    2 +-
 4 files changed, 12 insertions(+), 12 deletions(-)

Index: linux-2.6-tip/fs/cifs/cifsglob.h
===================================================================
--- linux-2.6-tip.orig/fs/cifs/cifsglob.h
+++ linux-2.6-tip/fs/cifs/cifsglob.h
@@ -204,7 +204,7 @@ struct cifsUidInfo {
 struct cifsSesInfo {
 	struct list_head smb_ses_list;
 	struct list_head tcon_list;
-	struct semaphore sesSem;
+	struct mutex session_mutex;
 #if 0
 	struct cifsUidInfo *uidInfo;	/* pointer to user info */
 #endif
Index: linux-2.6-tip/fs/cifs/cifssmb.c
===================================================================
--- linux-2.6-tip.orig/fs/cifs/cifssmb.c
+++ linux-2.6-tip/fs/cifs/cifssmb.c
@@ -170,19 +170,19 @@ cifs_reconnect_tcon(struct cifsTconInfo 
 	 * need to prevent multiple threads trying to simultaneously
 	 * reconnect the same SMB session
 	 */
-	down(&ses->sesSem);
+	mutex_lock(&ses->session_mutex);
 	if (ses->need_reconnect)
 		rc = cifs_setup_session(0, ses, nls_codepage);
 
 	/* do we need to reconnect tcon? */
 	if (rc || !tcon->need_reconnect) {
-		up(&ses->sesSem);
+		mutex_unlock(&ses->session_mutex);
 		goto out;
 	}
 
 	mark_open_files_invalid(tcon);
 	rc = CIFSTCon(0, ses, tcon->treeName, tcon, nls_codepage);
-	up(&ses->sesSem);
+	mutex_unlock(&ses->session_mutex);
 	cFYI(1, ("reconnect tcon rc = %d", rc));
 
 	if (rc)
@@ -700,13 +700,13 @@ CIFSSMBLogoff(const int xid, struct cifs
 	if (!ses || !ses->server)
 		return -EIO;
 
-	down(&ses->sesSem);
+	mutex_lock(&ses->session_mutex);
 	if (ses->need_reconnect)
 		goto session_already_dead; /* no need to send SMBlogoff if uid
 					      already closed due to reconnect */
 	rc = small_smb_init(SMB_COM_LOGOFF_ANDX, 2, NULL, (void **)&pSMB);
 	if (rc) {
-		up(&ses->sesSem);
+		mutex_unlock(&ses->session_mutex);
 		return rc;
 	}
 
@@ -721,7 +721,7 @@ CIFSSMBLogoff(const int xid, struct cifs
 	pSMB->AndXCommand = 0xFF;
 	rc = SendReceiveNoRsp(xid, ses, (struct smb_hdr *) pSMB, 0);
 session_already_dead:
-	up(&ses->sesSem);
+	mutex_unlock(&ses->session_mutex);
 
 	/* if session dead then we do not need to do ulogoff,
 		since server closed smb session, no sense reporting
Index: linux-2.6-tip/fs/cifs/connect.c
===================================================================
--- linux-2.6-tip.orig/fs/cifs/connect.c
+++ linux-2.6-tip/fs/cifs/connect.c
@@ -2366,13 +2366,13 @@ try_mount_again:
 		 */
 		cifs_put_tcp_session(srvTcp);
 
-		down(&pSesInfo->sesSem);
+		mutex_lock(&pSesInfo->session_mutex);
 		if (pSesInfo->need_reconnect) {
 			cFYI(1, ("Session needs reconnect"));
 			rc = cifs_setup_session(xid, pSesInfo,
 						cifs_sb->local_nls);
 		}
-		up(&pSesInfo->sesSem);
+		mutex_unlock(&pSesInfo->session_mutex);
 	} else if (!rc) {
 		cFYI(1, ("Existing smb sess not found"));
 		pSesInfo = sesInfoAlloc();
@@ -2415,12 +2415,12 @@ try_mount_again:
 		}
 		pSesInfo->linux_uid = volume_info->linux_uid;
 		pSesInfo->overrideSecFlg = volume_info->secFlg;
-		down(&pSesInfo->sesSem);
+		mutex_lock(&pSesInfo->session_mutex);
 
 		/* BB FIXME need to pass vol->secFlgs BB */
 		rc = cifs_setup_session(xid, pSesInfo,
 					cifs_sb->local_nls);
-		up(&pSesInfo->sesSem);
+		mutex_unlock(&pSesInfo->session_mutex);
 	}
 
 	/* search for existing tcon to this server share */
Index: linux-2.6-tip/fs/cifs/misc.c
===================================================================
--- linux-2.6-tip.orig/fs/cifs/misc.c
+++ linux-2.6-tip/fs/cifs/misc.c
@@ -79,7 +79,7 @@ sesInfoAlloc(void)
 		++ret_buf->ses_count;
 		INIT_LIST_HEAD(&ret_buf->smb_ses_list);
 		INIT_LIST_HEAD(&ret_buf->tcon_list);
-		init_MUTEX(&ret_buf->sesSem);
+		mutex_init(&ret_buf->session_mutex);
 	}
 	return ret_buf;
 }


