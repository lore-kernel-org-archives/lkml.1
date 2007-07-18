Return-Path: <linux-kernel-owner+w=401wt.eu-S934181AbXGRW7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181AbXGRW7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758864AbXGRW5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:57:39 -0400
Received: from mail.fieldses.org ([66.93.2.214]:42907 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473AbXGRW5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:57:38 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, andros@citi.umich.edu,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH 4/5] knfsd: move EX_RDONLY out of header
Date: Wed, 18 Jul 2007 18:57:29 -0400
Message-Id: <1184799450116-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <11847994503028-git-send-email-bfields@fieldses.org>
References: <20070713114228.3c171a90.akpm@linux-foundation.org>
 <11847994502579-git-send-email-bfields@fieldses.org>
 <11847994502502-git-send-email-bfields@fieldses.org>
 <11847994503243-git-send-email-bfields@fieldses.org>
 <11847994503028-git-send-email-bfields@fieldses.org>
Message-Id: <fbbdd23e675df0288cf80243fdcd5e211fff855b.1184798679.git.bfields@citi.umich.edu>
In-Reply-To: <2ac9f179334dc7894bb58b1c2fb62837a07fbbdf.1184798679.git.bfields@citi.umich.edu>
References: <2ac9f179334dc7894bb58b1c2fb62837a07fbbdf.1184798679.git.bfields@citi.umich.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

EX_RDONLY is only called in one place; just put it there.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 fs/nfsd/vfs.c               |   12 ++++++++++++
 include/linux/nfsd/export.h |   12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 5c97d0e..f2684e5 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1797,6 +1797,18 @@ nfsd_statfs(struct svc_rqst *rqstp, struct svc_fh *fhp, struct kstatfs *stat)
 	return err;
 }
 
+static inline int EX_RDONLY(struct svc_export *exp, struct svc_rqst *rqstp)
+{
+	struct exp_flavor_info *f;
+	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
+
+	for (f = exp->ex_flavors; f < end; f++) {
+		if (f->pseudoflavor == rqstp->rq_flavor)
+			return f->flags & NFSEXP_READONLY;
+	}
+	return exp->ex_flags & NFSEXP_READONLY;
+}
+
 /*
  * Check for a user's access permissions to this inode.
  */
diff --git a/include/linux/nfsd/export.h b/include/linux/nfsd/export.h
index 78feb7b..fb4e930 100644
--- a/include/linux/nfsd/export.h
+++ b/include/linux/nfsd/export.h
@@ -116,18 +116,6 @@ struct svc_expkey {
 #define EX_NOHIDE(exp)		((exp)->ex_flags & NFSEXP_NOHIDE)
 #define EX_WGATHER(exp)		((exp)->ex_flags & NFSEXP_GATHERED_WRITES)
 
-static inline int EX_RDONLY(struct svc_export *exp, struct svc_rqst *rqstp)
-{
-	struct exp_flavor_info *f;
-	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
-
-	for (f = exp->ex_flavors; f < end; f++) {
-		if (f->pseudoflavor == rqstp->rq_flavor)
-			return f->flags & NFSEXP_READONLY;
-	}
-	return exp->ex_flags & NFSEXP_READONLY;
-}
-
 __be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp);
 
 /*
-- 
1.5.3.rc2

