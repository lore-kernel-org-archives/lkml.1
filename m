Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbXL1UqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbXL1UqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbXL1Uns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:43:48 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37105 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbXL1Unk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:40 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 22/30] Unionfs: handle on lower inodes in lookup
Date: Fri, 28 Dec 2007 15:42:56 -0500
Message-Id: <11988745953304-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |    6 +++++-
 fs/unionfs/lookup.c |    5 +++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index b207a6f..0e89308 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -151,8 +151,12 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 			valid = false;
 	}
 
-	if (!dentry->d_inode)
+	if (!dentry->d_inode ||
+	    ibstart(dentry->d_inode) < 0 ||
+	    ibend(dentry->d_inode) < 0) {
 		valid = false;
+		goto out;
+	}
 
 	if (valid) {
 		/*
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 85a85aa..b9ee072 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -225,6 +225,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 		wh_lower_dentry = NULL;
 
 		/* Now do regular lookup; lookup foo */
+		BUG_ON(!lower_dir_dentry);
 		lower_dentry = lookup_one_len(name, lower_dir_dentry, namelen);
 		if (IS_ERR(lower_dentry)) {
 			dput(first_lower_dentry);
@@ -315,6 +316,10 @@ out_negative:
 			UNIONFS_I(dentry->d_inode)->stale = 1;
 		goto out;
 	}
+	if (!lower_dir_dentry) {
+		err = -ENOENT;
+		goto out;
+	}
 	/* This should only happen if we found a whiteout. */
 	if (first_dentry_offset == -1) {
 		first_lower_dentry = lookup_one_len(name, lower_dir_dentry,
-- 
1.5.2.2

