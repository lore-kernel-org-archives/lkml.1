Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbYBQC75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbYBQC75 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 21:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbYBQC56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:57:58 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36269 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801AbYBQC5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:57:52 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Himanshu Kanda <hkanda@cs.sunysb.edu>
Subject: [PATCH 02/17] Unionfs: ensure consistent lower inodes types
Date: Sat, 16 Feb 2008 21:57:11 -0500
Message-Id: <1203217047142-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
References: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When looking up a lower object in multiple branches, especially for
directories, ignore any existing entries whose type is different than the
type of the first found object (otherwise we'll be trying to, say, call
readdir on a non-dir inode).

Signed-off-by: Himanshu Kanda <hkanda@fsl.cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/lookup.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index b9ee072..755158e 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -256,6 +256,19 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 			continue;
 		}
 
+		/*
+		 * If we already found at least one positive dentry
+		 * (dentry_count is non-zero), then we skip all remaining
+		 * positive dentries if their type is a non-dir.  This is
+		 * because only directories are allowed to stack on multiple
+		 * branches, but we have to skip non-dirs (to avoid, say,
+		 * calling readdir on a regular file).
+		 */
+		if (!S_ISDIR(lower_dentry->d_inode->i_mode) && dentry_count) {
+			dput(lower_dentry);
+			continue;
+		}
+
 		/* number of positive dentries */
 		dentry_count++;
 
-- 
1.5.2.2

