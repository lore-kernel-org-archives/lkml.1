Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbXIEVW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbXIEVW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 17:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbXIEVWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 17:22:18 -0400
Received: from mail.fieldses.org ([66.93.2.214]:60912 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbXIEVWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 17:22:17 -0400
From: "J. Bruce Fields" <bfields@citi.umich.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH 1/2] knfsd: Fixed problem with NFS exporting directories which are mounted on.
Date: Wed,  5 Sep 2007 17:22:12 -0400
Message-Id: <11890273334076-git-send-email-bfields@citi.umich.edu>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1189027333981-git-send-email-bfields@citi.umich.edu>
References: <1189027333981-git-send-email-bfields@citi.umich.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Brown <neilb@suse.de>

Recent changes in NFSd cause a directory which is mounted-on
to not appear properly when the filesystem containing it is exported.

*exp_get* not returns -ENOENT rather than NULL and when
  commit 5d3dbbeaf56d0365ac6b5c0a0da0bd31cc4781e1
removed the NULL checks, it didn't add a check for -ENOENT.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 fs/nfsd/vfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index a0c2b25..7867151 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -115,7 +115,8 @@ nfsd_cross_mnt(struct svc_rqst *rqstp, struct dentry **dpp,
 
 	exp2 = rqst_exp_get_by_name(rqstp, mnt, mounts);
 	if (IS_ERR(exp2)) {
-		err = PTR_ERR(exp2);
+		if (PTR_ERR(exp2) != -ENOENT)
+			err = PTR_ERR(exp2);
 		dput(mounts);
 		mntput(mnt);
 		goto out;
-- 
1.5.3

