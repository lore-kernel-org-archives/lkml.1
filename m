Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbXL1Uri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbXL1Uri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbXL1UoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:07 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37140 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbXL1Uns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:48 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>,
       Rachita Kothiyal <rachita@cs.sunysb.edu>
Subject: [PATCH 05/30] Unionfs: interpose cleanup and fix for spliced dentries
Date: Fri, 28 Dec 2007 15:42:39 -0500
Message-Id: <11988745872908-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix unionfs_interpose to fill lower inode info when d_splice_alias returns
NULL.  Also cleanup impossible case (d_splice_alias doesn't return ERR_PTR).

Signed-off-by: Rachita Kothiyal <rachita@fsl.cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/main.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 22aa6e6..ea8976d 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -149,9 +149,7 @@ skip:
 		break;
 	case INTERPOSE_LOOKUP:
 		spliced = d_splice_alias(inode, dentry);
-		if (IS_ERR(spliced)) {
-			err = PTR_ERR(spliced);
-		} else if (spliced && spliced != dentry) {
+		if (spliced && spliced != dentry) {
 			/*
 			 * d_splice can return a dentry if it was
 			 * disconnected and had to be moved.  We must ensure
@@ -169,6 +167,12 @@ skip:
 				unionfs_fill_inode(dentry, inode);
 			}
 			goto out_spliced;
+		} else if (!spliced) {
+			if (need_fill_inode) {
+				need_fill_inode = 0;
+				unionfs_fill_inode(dentry, inode);
+				goto out_spliced;
+			}
 		}
 		break;
 	case INTERPOSE_REVAL:
-- 
1.5.2.2

