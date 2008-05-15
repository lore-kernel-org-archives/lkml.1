Return-Path: <linux-kernel-owner+w=401wt.eu-S1763899AbYEOTw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763899AbYEOTw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762068AbYEOTv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:51:28 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57968 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758622AbYEOTvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:51:23 -0400
Message-Id: <20080515195103.521911468@szeredi.hu>
References: <20080515195019.754545421@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 15 May 2008 21:50:20 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: [patch 1/9] lockd: dont return EAGAIN for a permanent error
Content-Disposition: inline; filename=lockd_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Fix nlm_fopen() to return NLM_FAILED (or NLM_LCK_DENIED_NOLOCKS)
instead of NLM_LCK_DENIED.  The latter means the lock request failed
because of a conflicting lock (i.e. a temporary error), which is wrong
in this case.

Also fix the client to return ENOLCK instead of EAGAIN if a blocking
lock request returns with NLM_LOCK_DENIED.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: "J. Bruce Fields" <bfields@fieldses.org>
---
 fs/lockd/clntproc.c |   10 +++++++++-
 fs/nfsd/lockd.c     |   13 +++++++++----
 2 files changed, 18 insertions(+), 5 deletions(-)

Index: linux-2.6/fs/lockd/clntproc.c
===================================================================
--- linux-2.6.orig/fs/lockd/clntproc.c	2008-05-15 17:54:30.000000000 +0200
+++ linux-2.6/fs/lockd/clntproc.c	2008-05-15 17:59:41.000000000 +0200
@@ -580,7 +580,15 @@ again:
 	}
 	if (status < 0)
 		goto out_unlock;
-	status = nlm_stat_to_errno(resp->status);
+	/*
+	 * EAGAIN doesn't make sense for sleeping locks, and in some
+	 * cases NLM_LCK_DENIED is returned for a permanent error.  So
+	 * turn it into an ENOLCK.
+	 */
+	if (resp->status == nlm_lck_denied && (fl_flags & FL_SLEEP))
+		status = -ENOLCK;
+	else
+		status = nlm_stat_to_errno(resp->status);
 out_unblock:
 	nlmclnt_finish_block(block);
 out:
Index: linux-2.6/fs/nfsd/lockd.c
===================================================================
--- linux-2.6.orig/fs/nfsd/lockd.c	2008-05-15 17:54:30.000000000 +0200
+++ linux-2.6/fs/nfsd/lockd.c	2008-05-15 17:57:45.000000000 +0200
@@ -19,6 +19,13 @@
 
 #define NFSDDBG_FACILITY		NFSDDBG_LOCKD
 
+#ifdef CONFIG_LOCKD_V4
+#define nlm_stale_fh	nlm4_stale_fh
+#define nlm_failed	nlm4_failed
+#else
+#define nlm_stale_fh	nlm_lck_denied_nolocks
+#define nlm_failed	nlm_lck_denied_nolocks
+#endif
 /*
  * Note: we hold the dentry use count while the file is open.
  */
@@ -47,12 +54,10 @@ nlm_fopen(struct svc_rqst *rqstp, struct
 		return 0;
 	case nfserr_dropit:
 		return nlm_drop_reply;
-#ifdef CONFIG_LOCKD_V4
 	case nfserr_stale:
-		return nlm4_stale_fh;
-#endif
+		return nlm_stale_fh;
 	default:
-		return nlm_lck_denied;
+		return nlm_failed;
 	}
 }
 

--
