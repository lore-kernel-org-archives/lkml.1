Return-Path: <linux-kernel-owner+w=401wt.eu-S1758996AbXGRW6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbXGRW6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbXGRW5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:57:38 -0400
Received: from mail.fieldses.org ([66.93.2.214]:42902 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbXGRW5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:57:36 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, andros@citi.umich.edu,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH 2/5] nfsd: return errors, not NULL, from export functions
Date: Wed, 18 Jul 2007 18:57:27 -0400
Message-Id: <11847994503243-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <11847994502502-git-send-email-bfields@fieldses.org>
References: <20070713114228.3c171a90.akpm@linux-foundation.org>
 <11847994502579-git-send-email-bfields@fieldses.org>
 <11847994502502-git-send-email-bfields@fieldses.org>
Message-Id: <278646972e4b7eaf86d648d8ee2ae879f8b6b680.1184798679.git.bfields@citi.umich.edu>
In-Reply-To: <2ac9f179334dc7894bb58b1c2fb62837a07fbbdf.1184798679.git.bfields@citi.umich.edu>
References: <2ac9f179334dc7894bb58b1c2fb62837a07fbbdf.1184798679.git.bfields@citi.umich.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

I converted the various export-returning functions to return -ENOENT
instead of NULL, but missed a few cases.

This particular case could cause actual bugs in the case of a krb5
client that doesn't match any ip-based client and that is trying to
access a filesystem not exported to krb5 clients.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 fs/nfsd/export.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index c7bbf46..6ab8de4 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1265,7 +1265,7 @@ struct svc_export *
 rqst_exp_get_by_name(struct svc_rqst *rqstp, struct vfsmount *mnt,
 		struct dentry *dentry)
 {
-	struct svc_export *gssexp, *exp = NULL;
+	struct svc_export *gssexp, *exp = ERR_PTR(-ENOENT);
 
 	if (rqstp->rq_client == NULL)
 		goto gss;
@@ -1288,7 +1288,7 @@ gss:
 						&rqstp->rq_chandle);
 	if (PTR_ERR(gssexp) == -ENOENT)
 		return exp;
-	if (exp && !IS_ERR(exp))
+	if (!IS_ERR(exp))
 		exp_put(exp);
 	return gssexp;
 }
@@ -1296,7 +1296,7 @@ gss:
 struct svc_export *
 rqst_exp_find(struct svc_rqst *rqstp, int fsid_type, u32 *fsidv)
 {
-	struct svc_export *gssexp, *exp = NULL;
+	struct svc_export *gssexp, *exp = ERR_PTR(-ENOENT);
 
 	if (rqstp->rq_client == NULL)
 		goto gss;
@@ -1318,7 +1318,7 @@ gss:
 						&rqstp->rq_chandle);
 	if (PTR_ERR(gssexp) == -ENOENT)
 		return exp;
-	if (exp && !IS_ERR(exp))
+	if (!IS_ERR(exp))
 		exp_put(exp);
 	return gssexp;
 }
-- 
1.5.3.rc2

