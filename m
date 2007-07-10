Return-Path: <linux-kernel-owner+w=401wt.eu-S1762481AbXGJC0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762481AbXGJC0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762205AbXGJCZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:25:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:34116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762240AbXGJCZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:25:41 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jul 2007 12:25:37 +1000
Message-Id: <1070710022537.13297@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: J "." Bruce Fields <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 010 of 20] knfsd: nfsd: factor nfsd_lookup into 2 pieces
References: <20070710121949.12548.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>

Factor nfsd_lookup into nfsd_lookup_dentry, which finds the right dentry
and export, and a second part which composes the filehandle (and which
will later check the security flavor on the new export).

No change in behavior.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/vfs.c |   55 ++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 19 deletions(-)

diff .prev/fs/nfsd/vfs.c ./fs/nfsd/vfs.c
--- .prev/fs/nfsd/vfs.c	2007-07-10 11:34:22.000000000 +1000
+++ ./fs/nfsd/vfs.c	2007-07-10 11:38:15.000000000 +1000
@@ -135,21 +135,10 @@ out:
 	return err;
 }
 
-/*
- * Look up one component of a pathname.
- * N.B. After this call _both_ fhp and resfh need an fh_put
- *
- * If the lookup would cross a mountpoint, and the mounted filesystem
- * is exported to the client with NFSEXP_NOHIDE, then the lookup is
- * accepted as it stands and the mounted directory is
- * returned. Otherwise the covered directory is returned.
- * NOTE: this mountpoint crossing is not supported properly by all
- *   clients and is explicitly disallowed for NFSv3
- *      NeilBrown <neilb@cse.unsw.edu.au>
- */
 __be32
-nfsd_lookup(struct svc_rqst *rqstp, struct svc_fh *fhp, const char *name,
-					int len, struct svc_fh *resfh)
+nfsd_lookup_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp,
+		   const char *name, int len,
+		   struct svc_export **exp_ret, struct dentry **dentry_ret)
 {
 	struct svc_export	*exp;
 	struct dentry		*dparent;
@@ -219,6 +208,38 @@ nfsd_lookup(struct svc_rqst *rqstp, stru
 			}
 		}
 	}
+	*dentry_ret = dentry;
+	*exp_ret = exp;
+	return 0;
+
+out_nfserr:
+	exp_put(exp);
+	return nfserrno(host_err);
+}
+
+/*
+ * Look up one component of a pathname.
+ * N.B. After this call _both_ fhp and resfh need an fh_put
+ *
+ * If the lookup would cross a mountpoint, and the mounted filesystem
+ * is exported to the client with NFSEXP_NOHIDE, then the lookup is
+ * accepted as it stands and the mounted directory is
+ * returned. Otherwise the covered directory is returned.
+ * NOTE: this mountpoint crossing is not supported properly by all
+ *   clients and is explicitly disallowed for NFSv3
+ *      NeilBrown <neilb@cse.unsw.edu.au>
+ */
+__be32
+nfsd_lookup(struct svc_rqst *rqstp, struct svc_fh *fhp, const char *name,
+					int len, struct svc_fh *resfh)
+{
+	struct svc_export	*exp;
+	struct dentry		*dentry;
+	__be32 err;
+
+	err = nfsd_lookup_dentry(rqstp, fhp, name, len, &exp, &dentry);
+	if (err)
+		return err;
 	/*
 	 * Note: we compose the file handle now, but as the
 	 * dentry may be negative, it may need to be updated.
@@ -227,15 +248,11 @@ nfsd_lookup(struct svc_rqst *rqstp, stru
 	if (!err && !dentry->d_inode)
 		err = nfserr_noent;
 	dput(dentry);
-out:
 	exp_put(exp);
 	return err;
-
-out_nfserr:
-	err = nfserrno(host_err);
-	goto out;
 }
 
+
 /*
  * Set various file attributes.
  * N.B. After this call fhp needs an fh_put
