Return-Path: <linux-kernel-owner+w=401wt.eu-S1760554AbXGRW6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554AbXGRW6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbXGRW5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:57:37 -0400
Received: from mail.fieldses.org ([66.93.2.214]:42901 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbXGRW5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:57:36 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, andros@citi.umich.edu,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH 5/5] knfsd: clean up EX_RDONLY
Date: Wed, 18 Jul 2007 18:57:30 -0400
Message-Id: <11847994503092-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1184799450116-git-send-email-bfields@fieldses.org>
References: <20070713114228.3c171a90.akpm@linux-foundation.org>
 <11847994502579-git-send-email-bfields@fieldses.org>
 <11847994502502-git-send-email-bfields@fieldses.org>
 <11847994503243-git-send-email-bfields@fieldses.org>
 <11847994503028-git-send-email-bfields@fieldses.org>
 <1184799450116-git-send-email-bfields@fieldses.org>
Message-Id: <986bf36dcb843bf352799fad5c20f1764748ce22.1184798679.git.bfields@citi.umich.edu>
In-Reply-To: <2ac9f179334dc7894bb58b1c2fb62837a07fbbdf.1184798679.git.bfields@citi.umich.edu>
References: <2ac9f179334dc7894bb58b1c2fb62837a07fbbdf.1184798679.git.bfields@citi.umich.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

Share a little common code, reverse the arguments for consistency, drop
the unnecessary "inline", and lowercase the name.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 fs/nfsd/auth.c              |    3 ++-
 fs/nfsd/vfs.c               |   13 +++----------
 include/linux/nfsd/export.h |    1 +
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index cf61dc8..2192805 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -9,10 +9,11 @@
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/svcauth.h>
 #include <linux/nfsd/nfsd.h>
+#include <linux/nfsd/export.h>
 
 #define	CAP_NFSD_MASK (CAP_FS_MASK|CAP_TO_MASK(CAP_SYS_RESOURCE))
 
-static int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp)
+int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp)
 {
 	struct exp_flavor_info *f;
 	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index f2684e5..ee96a89 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1797,16 +1797,9 @@ nfsd_statfs(struct svc_rqst *rqstp, struct svc_fh *fhp, struct kstatfs *stat)
 	return err;
 }
 
-static inline int EX_RDONLY(struct svc_export *exp, struct svc_rqst *rqstp)
+static int exp_rdonly(struct svc_rqst *rqstp, struct svc_export *exp)
 {
-	struct exp_flavor_info *f;
-	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
-
-	for (f = exp->ex_flavors; f < end; f++) {
-		if (f->pseudoflavor == rqstp->rq_flavor)
-			return f->flags & NFSEXP_READONLY;
-	}
-	return exp->ex_flags & NFSEXP_READONLY;
+	return nfsexp_flags(rqstp, exp) & NFSEXP_READONLY;
 }
 
 /*
@@ -1845,7 +1838,7 @@ nfsd_permission(struct svc_rqst *rqstp, struct svc_export *exp,
 	 */
 	if (!(acc & MAY_LOCAL_ACCESS))
 		if (acc & (MAY_WRITE | MAY_SATTR | MAY_TRUNC)) {
-			if (EX_RDONLY(exp, rqstp) || IS_RDONLY(inode))
+			if (exp_rdonly(rqstp, exp) || IS_RDONLY(inode))
 				return nfserr_rofs;
 			if (/* (acc & MAY_WRITE) && */ IS_IMMUTABLE(inode))
 				return nfserr_perm;
diff --git a/include/linux/nfsd/export.h b/include/linux/nfsd/export.h
index fb4e930..5cd1924 100644
--- a/include/linux/nfsd/export.h
+++ b/include/linux/nfsd/export.h
@@ -116,6 +116,7 @@ struct svc_expkey {
 #define EX_NOHIDE(exp)		((exp)->ex_flags & NFSEXP_NOHIDE)
 #define EX_WGATHER(exp)		((exp)->ex_flags & NFSEXP_GATHERED_WRITES)
 
+int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp);
 __be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp);
 
 /*
-- 
1.5.3.rc2

