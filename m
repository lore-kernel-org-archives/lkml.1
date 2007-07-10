Return-Path: <linux-kernel-owner+w=401wt.eu-S1763109AbXGJCaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763109AbXGJCaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762716AbXGJC2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:28:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:34313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762271AbXGJC2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:28:20 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jul 2007 12:28:16 +1000
Message-Id: <1070710022816.13624@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: J "." Bruce Fields <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 019 of 20] knfsd: nfsd: allow auth_sys nlm on rpcsec_gss exports
References: <20070710121949.12548.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>

Our clients (like other clients, as far as I know) use only auth_sys for
nlm, even when using rpcsec_gss for the main nfs operations.

Administrators that want to deny non-kerberos-authenticated locking
requests will need to turn off NFS protocol versions less than 4....

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfsfh.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff .prev/fs/nfsd/nfsfh.c ./fs/nfsd/nfsfh.c
--- .prev/fs/nfsd/nfsfh.c	2007-07-10 12:18:34.000000000 +1000
+++ ./fs/nfsd/nfsfh.c	2007-07-10 12:19:36.000000000 +1000
@@ -249,10 +249,16 @@ fh_verify(struct svc_rqst *rqstp, struct
 	if (error)
 		goto out;
 
-	/* Check security flavor */
-	error = check_nfsd_access(exp, rqstp);
-	if (error)
-		goto out;
+	if (!(access & MAY_LOCK)) {
+		/*
+		 * pseudoflavor restrictions are not enforced on NLM,
+		 * which clients virtually always use auth_sys for,
+		 * even while using RPCSEC_GSS for NFS.
+		 */
+		error = check_nfsd_access(exp, rqstp);
+		if (error)
+			goto out;
+	}
 
 	/* Finally, check access permissions. */
 	error = nfsd_permission(rqstp, exp, dentry, access);
