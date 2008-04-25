Return-Path: <linux-kernel-owner+w=401wt.eu-S933164AbYDYWVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164AbYDYWVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764338AbYDYWUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:20:03 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40562 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763703AbYDYWT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:19:59 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 06/12] Unionfs: don't dereference dentry without lower branches in d_release
Date: Fri, 25 Apr 2008 18:19:02 -0400
Message-Id: <12091619512455-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
References: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index ee0da4f..e5f894c 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -482,12 +482,14 @@ static void unionfs_d_release(struct dentry *dentry)
 	int bindex, bstart, bend;
 
 	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_CHILD);
+	if (unlikely(!UNIONFS_D(dentry)))
+		goto out;	/* skip if no lower branches */
 	/* must lock our branch configuration here */
 	unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
 
 	unionfs_check_dentry(dentry);
 	/* this could be a negative dentry, so check first */
-	if (unlikely(!UNIONFS_D(dentry) || dbstart(dentry) < 0)) {
+	if (dbstart(dentry) < 0) {
 		unionfs_unlock_dentry(dentry);
 		goto out;	/* due to a (normal) failed lookup */
 	}
-- 
1.5.2.2

