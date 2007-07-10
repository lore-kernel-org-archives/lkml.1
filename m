Return-Path: <linux-kernel-owner+w=401wt.eu-S1762367AbXGJC0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762367AbXGJC0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762210AbXGJCZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:25:24 -0400
Received: from ns2.suse.de ([195.135.220.15]:34072 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761714AbXGJCZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:25:22 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jul 2007 12:25:17 +1000
Message-Id: <1070710022517.13262@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: J "." Bruce Fields <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 009 of 20] knfsd: nfsd: use ip-address-based domain in secinfo case
References: <20070710121949.12548.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>

With this patch, we fall back on using the gss/pseudoflavor only if we
fail to find a matching auth_unix export that has a secinfo list.

As long as sec= options aren't used, there's still no change in behavior
here (except possibly for some additional auth_unix cache lookups, whose
results will be ignored).

The sec= option, however, is not actually enforced yet; later patches
will add the necessary checks.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/export.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 67 insertions(+), 9 deletions(-)

diff .prev/fs/nfsd/export.c ./fs/nfsd/export.c
--- .prev/fs/nfsd/export.c	2007-07-10 11:35:37.000000000 +1000
+++ ./fs/nfsd/export.c	2007-07-10 11:37:38.000000000 +1000
@@ -1229,6 +1229,10 @@ exp_find(struct auth_domain *clp, int fs
 }
 
 /*
+ * Uses rq_client and rq_gssclient to find an export; uses rq_client (an
+ * auth_unix client) if it's available and has secinfo information;
+ * otherwise, will try to use rq_gssclient.
+ *
  * Called from functions that handle requests; functions that do work on
  * behalf of mountd are passed a single client name to use, and should
  * use exp_get_by_name() or exp_find().
@@ -1237,29 +1241,83 @@ struct svc_export *
 rqst_exp_get_by_name(struct svc_rqst *rqstp, struct vfsmount *mnt,
 		struct dentry *dentry)
 {
-	struct auth_domain *clp;
+	struct svc_export *gssexp, *exp = NULL;
 
-	clp = rqstp->rq_gssclient ? rqstp->rq_gssclient : rqstp->rq_client;
-	return exp_get_by_name(clp, mnt, dentry, &rqstp->rq_chandle);
+	if (rqstp->rq_client == NULL)
+		goto gss;
+
+	/* First try the auth_unix client: */
+	exp = exp_get_by_name(rqstp->rq_client, mnt, dentry,
+						&rqstp->rq_chandle);
+	if (PTR_ERR(exp) == -ENOENT)
+		goto gss;
+	if (IS_ERR(exp))
+		return exp;
+	/* If it has secinfo, assume there are no gss/... clients */
+	if (exp->ex_nflavors > 0)
+		return exp;
+gss:
+	/* Otherwise, try falling back on gss client */
+	if (rqstp->rq_gssclient == NULL)
+		return exp;
+	gssexp = exp_get_by_name(rqstp->rq_gssclient, mnt, dentry,
+						&rqstp->rq_chandle);
+	if (PTR_ERR(gssexp) == -ENOENT)
+		return exp;
+	if (exp)
+		exp_put(exp);
+	return gssexp;
 }
 
 struct svc_export *
 rqst_exp_find(struct svc_rqst *rqstp, int fsid_type, u32 *fsidv)
 {
-	struct auth_domain *clp;
+	struct svc_export *gssexp, *exp = NULL;
 
-	clp = rqstp->rq_gssclient ? rqstp->rq_gssclient : rqstp->rq_client;
-	return exp_find(clp, fsid_type, fsidv, &rqstp->rq_chandle);
+	if (rqstp->rq_client == NULL)
+		goto gss;
+
+	/* First try the auth_unix client: */
+	exp = exp_find(rqstp->rq_client, fsid_type, fsidv, &rqstp->rq_chandle);
+	if (PTR_ERR(exp) == -ENOENT)
+		goto gss;
+	if (IS_ERR(exp))
+		return exp;
+	/* If it has secinfo, assume there are no gss/... clients */
+	if (exp->ex_nflavors > 0)
+		return exp;
+gss:
+	/* Otherwise, try falling back on gss client */
+	if (rqstp->rq_gssclient == NULL)
+		return exp;
+	gssexp = exp_find(rqstp->rq_gssclient, fsid_type, fsidv,
+						&rqstp->rq_chandle);
+	if (PTR_ERR(gssexp) == -ENOENT)
+		return exp;
+	if (exp)
+		exp_put(exp);
+	return gssexp;
 }
 
 struct svc_export *
 rqst_exp_parent(struct svc_rqst *rqstp, struct vfsmount *mnt,
 		struct dentry *dentry)
 {
-	struct auth_domain *clp;
+	struct svc_export *exp;
+
+	dget(dentry);
+	exp = rqst_exp_get_by_name(rqstp, mnt, dentry);
 
-	clp = rqstp->rq_gssclient ? rqstp->rq_gssclient : rqstp->rq_client;
-	return exp_parent(rqstp->rq_client, mnt, dentry, &rqstp->rq_chandle);
+	while (PTR_ERR(exp) == -ENOENT && !IS_ROOT(dentry)) {
+		struct dentry *parent;
+
+		parent = dget_parent(dentry);
+		dput(dentry);
+		dentry = parent;
+		exp = rqst_exp_get_by_name(rqstp, mnt, dentry);
+	}
+	dput(dentry);
+	return exp;
 }
 
 /*
