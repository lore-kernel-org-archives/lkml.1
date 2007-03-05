Return-Path: <linux-kernel-owner+w=401wt.eu-S1751211AbXCEB5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211AbXCEB5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbXCEBzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:55:39 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38379 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbXCEBzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:55:24 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 03/13] fs/unionfs/: Don't grab dentry private data mutex in unionfs_d_release
Date: Sun,  4 Mar 2007 20:54:53 -0500
Message-Id: <11730597043100-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.2.260.g2eb065
In-Reply-To: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
References: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grabbing the UNIONFS_D(dentry)->lock is completely unnecessary and there are
no other references; we are about to free the object anyway. Additionally,
grabbing the mutex produces warning when the slab object is reused - as it
was freed while there still was a reference to it.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 3721409..ac4bf0e 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -190,12 +190,6 @@ static void unionfs_d_release(struct dentry *dentry)
 {
 	int bindex, bstart, bend;
 
-	/* There is no reason to lock the dentry, because we have the only
-	 * reference, but the printing functions verify that we have a lock
-	 * on the dentry before calling dbstart, etc.
-	 */
-	unionfs_lock_dentry(dentry);
-
 	/* this could be a negative dentry, so check first */
 	if (!UNIONFS_D(dentry)) {
 		printk(KERN_DEBUG "dentry without private data: %.*s",
-- 
1.5.0.2.260.g2eb065

