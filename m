Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYLAQmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYLAQmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYLAQkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:40:00 -0500
Received: from zombie2.ncsc.mil ([144.51.88.133]:56886 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbYLAQjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:39:49 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org, "David P. Quigley" <dpquigl@tycho.nsa.gov>
Subject: [PATCH 01/14] patch fix_use_before_init_in_nfsd4_list_rec_dir
Date: Wed, 26 Nov 2008 16:03:01 -0500
Message-Id: <1227733394-1114-2-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/nfsd/nfs4recover.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index bb93946..7084252 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -228,8 +228,10 @@ nfsd4_list_rec_dir(struct dentry *dir, recdir_func *f)
 
 	filp = dentry_open(dget(dir), mntget(rec_dir.mnt), O_RDONLY);
 	status = PTR_ERR(filp);
-	if (IS_ERR(filp))
-		goto out;
+	if (IS_ERR(filp)) {
+		nfs4_reset_user(uid, gid);
+		return PTR_ERR(filp);
+	}
 	INIT_LIST_HEAD(dentries);
 	status = vfs_readdir(filp, nfsd4_build_dentrylist, &dla);
 	fput(filp);
-- 
1.5.5.1

