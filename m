Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbZGZIUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbZGZIUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbZGZIUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:20:22 -0400
Received: from www.tglx.de ([62.245.132.106]:33799 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbZGZIUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:20:18 -0400
Message-Id: <20090726081555.873287270@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:18:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steve French <sfrench@us.ibm.com>
Subject: [Patch RFC 20/37] cifs: convert semaphore to mutex
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline; filename=cifs-convert-sema-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pSesInfo->sesSem is used as mutex so make it a mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steve French <sfrench@us.ibm.com>
---
 fs/cifs/cifsglob.h |    2 +-
 fs/cifs/cifssmb.c  |   18 +++++++++---------
 fs/cifs/connect.c  |    8 ++++----
 fs/cifs/misc.c     |    2 +-
 4 files changed, 15 insertions(+), 15 deletions(-)

Index: linux-2.6-tip/fs/cifs/cifsglob.h
===================================================================
--- linux-2.6-tip.orig/fs/cifs/cifsglob.h
+++ linux-2.6-tip/fs/cifs/cifsglob.h
@@ -203,7 +203,7 @@ struct cifsUidInfo {
 struct cifsSesInfo {
 	struct list_head smb_ses_list;
 	struct list_head tcon_list;
-	struct semaphore sesSem;
+	struct mutex sesSem;
 #if 0
 	struct cifsUidInfo *uidInfo;	/* pointer to user info */
 #endif
Index: linux-2.6-tip/fs/cifs/cifssmb.c
===================================================================
--- linux-2.6-tip.orig/fs/cifs/cifssmb.c
+++ linux-2.6-tip/fs/cifs/cifssmb.c
@@ -154,7 +154,7 @@ small_smb_init(int smb_command, int wct,
 			nls_codepage = load_nls_default();
 		/* need to prevent multiple threads trying to
 		simultaneously reconnect the same SMB session */
-			down(&tcon->ses->sesSem);
+			mutex_lock(&tcon->ses->sesSem);
 			if (tcon->ses->need_reconnect)
 				rc = cifs_setup_session(0, tcon->ses,
 							nls_codepage);
@@ -162,7 +162,7 @@ small_smb_init(int smb_command, int wct,
 				mark_open_files_invalid(tcon);
 				rc = CIFSTCon(0, tcon->ses, tcon->treeName,
 					      tcon, nls_codepage);
-				up(&tcon->ses->sesSem);
+				mutex_unlock(&tcon->ses->sesSem);
 				/* BB FIXME add code to check if wsize needs
 				   update due to negotiated smb buffer size
 				   shrinking */
@@ -196,7 +196,7 @@ small_smb_init(int smb_command, int wct,
 					}
 				}
 			} else {
-				up(&tcon->ses->sesSem);
+				mutex_unlock(&tcon->ses->sesSem);
 			}
 			unload_nls(nls_codepage);
 
@@ -301,7 +301,7 @@ smb_init(int smb_command, int wct, struc
 			nls_codepage = load_nls_default();
 		/* need to prevent multiple threads trying to
 		simultaneously reconnect the same SMB session */
-			down(&tcon->ses->sesSem);
+			mutex_lock(&tcon->ses->sesSem);
 			if (tcon->ses->need_reconnect)
 				rc = cifs_setup_session(0, tcon->ses,
 							nls_codepage);
@@ -309,7 +309,7 @@ smb_init(int smb_command, int wct, struc
 				mark_open_files_invalid(tcon);
 				rc = CIFSTCon(0, tcon->ses, tcon->treeName,
 					      tcon, nls_codepage);
-				up(&tcon->ses->sesSem);
+				mutex_unlock(&tcon->ses->sesSem);
 				/* BB FIXME add code to check if wsize needs
 				update due to negotiated smb buffer size
 				shrinking */
@@ -343,7 +343,7 @@ smb_init(int smb_command, int wct, struc
 					}
 				}
 			} else {
-				up(&tcon->ses->sesSem);
+				mutex_unlock(&tcon->ses->sesSem);
 			}
 			unload_nls(nls_codepage);
 
@@ -765,13 +765,13 @@ CIFSSMBLogoff(const int xid, struct cifs
 	if (!ses || !ses->server)
 		return -EIO;
 
-	down(&ses->sesSem);
+	mutex_lock(&ses->sesSem);
 	if (ses->need_reconnect)
 		goto session_already_dead; /* no need to send SMBlogoff if uid
 					      already closed due to reconnect */
 	rc = small_smb_init(SMB_COM_LOGOFF_ANDX, 2, NULL, (void **)&pSMB);
 	if (rc) {
-		up(&ses->sesSem);
+		mutex_unlock(&ses->sesSem);
 		return rc;
 	}
 
@@ -786,7 +786,7 @@ CIFSSMBLogoff(const int xid, struct cifs
 	pSMB->AndXCommand = 0xFF;
 	rc = SendReceiveNoRsp(xid, ses, (struct smb_hdr *) pSMB, 0);
 session_already_dead:
-	up(&ses->sesSem);
+	mutex_unlock(&ses->sesSem);
 
 	/* if session dead then we do not need to do ulogoff,
 		since server closed smb session, no sense reporting
Index: linux-2.6-tip/fs/cifs/connect.c
===================================================================
--- linux-2.6-tip.orig/fs/cifs/connect.c
+++ linux-2.6-tip/fs/cifs/connect.c
@@ -2331,13 +2331,13 @@ try_mount_again:
 		 */
 		cifs_put_tcp_session(srvTcp);
 
-		down(&pSesInfo->sesSem);
+		mutex_lock(&pSesInfo->sesSem);
 		if (pSesInfo->need_reconnect) {
 			cFYI(1, ("Session needs reconnect"));
 			rc = cifs_setup_session(xid, pSesInfo,
 						cifs_sb->local_nls);
 		}
-		up(&pSesInfo->sesSem);
+		mutex_unlock(&pSesInfo->sesSem);
 	} else if (!rc) {
 		cFYI(1, ("Existing smb sess not found"));
 		pSesInfo = sesInfoAlloc();
@@ -2380,12 +2380,12 @@ try_mount_again:
 		}
 		pSesInfo->linux_uid = volume_info->linux_uid;
 		pSesInfo->overrideSecFlg = volume_info->secFlg;
-		down(&pSesInfo->sesSem);
+		mutex_lock(&pSesInfo->sesSem);
 
 		/* BB FIXME need to pass vol->secFlgs BB */
 		rc = cifs_setup_session(xid, pSesInfo,
 					cifs_sb->local_nls);
-		up(&pSesInfo->sesSem);
+		mutex_unlock(&pSesInfo->sesSem);
 	}
 
 	/* search for existing tcon to this server share */
Index: linux-2.6-tip/fs/cifs/misc.c
===================================================================
--- linux-2.6-tip.orig/fs/cifs/misc.c
+++ linux-2.6-tip/fs/cifs/misc.c
@@ -80,7 +80,7 @@ sesInfoAlloc(void)
 		++ret_buf->ses_count;
 		INIT_LIST_HEAD(&ret_buf->smb_ses_list);
 		INIT_LIST_HEAD(&ret_buf->tcon_list);
-		init_MUTEX(&ret_buf->sesSem);
+		mutex_init(&ret_buf->sesSem);
 	}
 	return ret_buf;
 }


