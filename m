Return-Path: <linux-kernel-owner+w=401wt.eu-S1762175AbXGJCYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762175AbXGJCYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761077AbXGJCYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:24:07 -0400
Received: from mx1.suse.de ([195.135.220.2]:38069 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760628AbXGJCYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:24:05 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jul 2007 12:24:01 +1000
Message-Id: <1070710022401.13066@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: J "." Bruce Fields <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 005 of 20] knfsd: nfsd4: simplify exp_pseudoroot arguments
References: <20070710121949.12548.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>

We're passing three arguments to exp_pseudoroot, two of which are just
fields of the svc_rqst.  Soon we'll want to pass in a third field as
well.  So let's just give up and pass in the whole struct svc_rqst.

Also sneak in some minor style cleanups while we're at it.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/export.c            |    5 ++---
 ./fs/nfsd/nfs4proc.c          |    7 +++----
 ./fs/nfsd/nfs4xdr.c           |    2 +-
 ./include/linux/nfsd/export.h |    2 +-
 4 files changed, 7 insertions(+), 9 deletions(-)

diff .prev/fs/nfsd/export.c ./fs/nfsd/export.c
--- .prev/fs/nfsd/export.c	2007-07-10 11:33:27.000000000 +1000
+++ ./fs/nfsd/export.c	2007-07-10 11:33:32.000000000 +1000
@@ -1235,8 +1235,7 @@ exp_find(struct auth_domain *clp, int fs
  * export point with fsid==0
  */
 __be32
-exp_pseudoroot(struct auth_domain *clp, struct svc_fh *fhp,
-	       struct cache_req *creq)
+exp_pseudoroot(struct svc_rqst *rqstp, struct svc_fh *fhp)
 {
 	struct svc_export *exp;
 	__be32 rv;
@@ -1244,7 +1243,7 @@ exp_pseudoroot(struct auth_domain *clp, 
 
 	mk_fsid(FSID_NUM, fsidv, 0, 0, 0, NULL);
 
-	exp = exp_find(clp, FSID_NUM, fsidv, creq);
+	exp = exp_find(rqstp->rq_client, FSID_NUM, fsidv, rqstp->rq_chandle);
 	if (PTR_ERR(exp) == -ENOENT)
 		return nfserr_perm;
 	if (IS_ERR(exp))

diff .prev/fs/nfsd/nfs4proc.c ./fs/nfsd/nfs4proc.c
--- .prev/fs/nfsd/nfs4proc.c	2007-07-10 11:19:58.000000000 +1000
+++ ./fs/nfsd/nfs4proc.c	2007-07-10 11:33:32.000000000 +1000
@@ -286,8 +286,7 @@ nfsd4_putrootfh(struct svc_rqst *rqstp, 
 	__be32 status;
 
 	fh_put(&cstate->current_fh);
-	status = exp_pseudoroot(rqstp->rq_client, &cstate->current_fh,
-			      &rqstp->rq_chandle);
+	status = exp_pseudoroot(rqstp, &cstate->current_fh);
 	return status;
 }
 
@@ -474,8 +473,8 @@ nfsd4_lookupp(struct svc_rqst *rqstp, st
 	__be32 ret;
 
 	fh_init(&tmp_fh, NFS4_FHSIZE);
-	if((ret = exp_pseudoroot(rqstp->rq_client, &tmp_fh,
-			      &rqstp->rq_chandle)) != 0)
+	ret = exp_pseudoroot(rqstp, &tmp_fh);
+	if (ret)
 		return ret;
 	if (tmp_fh.fh_dentry == cstate->current_fh.fh_dentry) {
 		fh_put(&tmp_fh);

diff .prev/fs/nfsd/nfs4xdr.c ./fs/nfsd/nfs4xdr.c
--- .prev/fs/nfsd/nfs4xdr.c	2007-07-10 11:19:58.000000000 +1000
+++ ./fs/nfsd/nfs4xdr.c	2007-07-10 11:33:32.000000000 +1000
@@ -1296,7 +1296,7 @@ static char *nfsd4_path(struct svc_rqst 
 	char *path, *rootpath;
 
 	fh_init(&tmp_fh, NFS4_FHSIZE);
-	*stat = exp_pseudoroot(rqstp->rq_client, &tmp_fh, &rqstp->rq_chandle);
+	*stat = exp_pseudoroot(rqstp, &tmp_fh);
 	if (*stat)
 		return NULL;
 	rootpath = tmp_fh.fh_export->ex_path;

diff .prev/include/linux/nfsd/export.h ./include/linux/nfsd/export.h
--- .prev/include/linux/nfsd/export.h	2007-07-10 11:29:02.000000000 +1000
+++ ./include/linux/nfsd/export.h	2007-07-10 11:33:32.000000000 +1000
@@ -135,7 +135,7 @@ struct svc_export *	exp_parent(struct au
 				   struct cache_req *reqp);
 int			exp_rootfh(struct auth_domain *, 
 					char *path, struct knfsd_fh *, int maxsize);
-__be32			exp_pseudoroot(struct auth_domain *, struct svc_fh *fhp, struct cache_req *creq);
+__be32			exp_pseudoroot(struct svc_rqst *, struct svc_fh *);
 __be32			nfserrno(int errno);
 
 extern struct cache_detail svc_export_cache;
