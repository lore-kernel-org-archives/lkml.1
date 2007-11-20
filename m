Return-Path: <linux-kernel-owner+w=401wt.eu-S1761543AbXKTS2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761543AbXKTS2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761184AbXKTS0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:26:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60174 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761087AbXKTS0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:26:11 -0500
Date: Tue, 20 Nov 2007 10:23:26 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Neil Brown <neilb@suse.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>, nfs@lists.sourceforge.net
Subject: [patch 08/29] nfsd4: recheck for secure ports in fh_verify
Message-ID: <20071120182326.GI28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfsd4-recheck-for-secure-ports-in-fh_verify.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: J. Bruce Fields <bfields@citi.umich.edu>

patch 6fa02839bf9412e18e773d04e96182b4cd0b5d57 in mainline.

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
Reviewed-By: NeilBrown <neilb@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfsfh.c |   43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -95,6 +95,22 @@ nfsd_mode_check(struct svc_rqst *rqstp, 
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
@@ -167,18 +183,7 @@ fh_verify(struct svc_rqst *rqstp, struct
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
 
@@ -227,18 +232,22 @@ fh_verify(struct svc_rqst *rqstp, struct
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
