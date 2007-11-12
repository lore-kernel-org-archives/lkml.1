Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbXKLVFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbXKLVFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 16:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbXKLVFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 16:05:11 -0500
Received: from mail.fieldses.org ([66.93.2.214]:42157 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbXKLVFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 16:05:08 -0500
From: "J. Bruce Fields" <bfields@citi.umich.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>, stable@kernel.org,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH] nfsd4: recheck for secure ports in fh_verify
Date: Mon, 12 Nov 2007 16:05:03 -0500
Message-Id: <1194901503-23105-3-git-send-email-bfields@citi.umich.edu>
X-Mailer: git-send-email 1.5.3.5
In-Reply-To: <1194901503-23105-2-git-send-email-bfields@citi.umich.edu>
References: <1194901503-23105-1-git-send-email-bfields@citi.umich.edu>
 <1194901503-23105-2-git-send-email-bfields@citi.umich.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As with

	7fc90ec93a5eb71f4b08... "call nfsd_setuser() on fh_compose()..."

this is a case where we need to redo a security check in fh_verify()
even though the filehandle already has an associated dentry--if the
filehandle was created by fh_compose() in an earlier operation of the
nfsv4 compound, then we may not have done these checks yet.

Without this fix it is possible, for example, to traverse from an export
without the secure ports requirement to one with it in a single
compound, and bypass the secure port check on the new export.

While we're here, fix up some minor style problems and change a printk()
to a dprintk(), to make it harder for random unprivileged users to spam
the logs.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 fs/nfsd/nfsfh.c |   43 ++++++++++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 4f712e9..468f17a 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -95,6 +95,22 @@ nfsd_mode_check(struct svc_rqst *rqstp, umode_t mode, int type)
 	return 0;
 }
 
+static __be32 nfsd_setuser_and_check_port(struct svc_rqst *rqstp,
+					  struct svc_export *exp)
+{
+	/* Check if the request originated from a secure port. */
+	if (!rqstp->rq_secure && EX_SECURE(exp)) {
+		char buf[RPC_MAX_ADDRBUFLEN];
+		dprintk(KERN_WARNING
+		       "nfsd: request from insecure port %s!\n",
+		       svc_print_addr(rqstp, buf, sizeof(buf)));
+		return nfserr_perm;
+	}
+
+	/* Set user creds for this exportpoint */
+	return nfserrno(nfsd_setuser(rqstp, exp));
+}
+
 /*
  * Perform sanity checks on the dentry in a client's file handle.
  *
@@ -167,18 +183,7 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, int type, int access)
 			goto out;
 		}
 
-		/* Check if the request originated from a secure port. */
-		error = nfserr_perm;
-		if (!rqstp->rq_secure && EX_SECURE(exp)) {
-			char buf[RPC_MAX_ADDRBUFLEN];
-			printk(KERN_WARNING
-			       "nfsd: request from insecure port %s!\n",
-			       svc_print_addr(rqstp, buf, sizeof(buf)));
-			goto out;
-		}
-
-		/* Set user creds for this exportpoint */
-		error = nfserrno(nfsd_setuser(rqstp, exp));
+		error = nfsd_setuser_and_check_port(rqstp, exp);
 		if (error)
 			goto out;
 
@@ -227,18 +232,22 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, int type, int access)
 		fhp->fh_export = exp;
 		nfsd_nr_verified++;
 	} else {
-		/* just rechecking permissions
-		 * (e.g. nfsproc_create calls fh_verify, then nfsd_create does as well)
+		/*
+		 * just rechecking permissions
+		 * (e.g. nfsproc_create calls fh_verify, then nfsd_create
+		 * does as well)
 		 */
 		dprintk("nfsd: fh_verify - just checking\n");
 		dentry = fhp->fh_dentry;
 		exp = fhp->fh_export;
-		/* Set user creds for this exportpoint; necessary even
+		/*
+		 * Set user creds for this exportpoint; necessary even
 		 * in the "just checking" case because this may be a
 		 * filehandle that was created by fh_compose, and that
 		 * is about to be used in another nfsv4 compound
-		 * operation */
-		error = nfserrno(nfsd_setuser(rqstp, exp));
+		 * operation.
+		 */
+		error = nfsd_setuser_and_check_port(rqstp, exp);
 		if (error)
 			goto out;
 	}
-- 
1.5.3.5.561.g140d

