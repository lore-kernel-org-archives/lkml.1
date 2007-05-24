Return-Path: <linux-kernel-owner+w=401wt.eu-S1761744AbXEXAjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761744AbXEXAjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761405AbXEXAgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:36:41 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40230 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759109AbXEXAgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:25 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 17/21] Unionfs: Documentation update regarding overlapping branches and new lookup code
Date: Wed, 23 May 2007 20:36:07 -0400
Message-Id: <11799669741770-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Added detailed comment and updated documentation to explain why overlapping
branches are disallowed, and better explain the cache coherency issues.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 Documentation/filesystems/unionfs/issues.txt |   16 ++++++++--------
 fs/unionfs/main.c                            |   16 +++++++++++++++-
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/unionfs/issues.txt b/Documentation/filesystems/unionfs/issues.txt
index a434fee..c634604 100644
--- a/Documentation/filesystems/unionfs/issues.txt
+++ b/Documentation/filesystems/unionfs/issues.txt
@@ -5,14 +5,14 @@ KNOWN Unionfs 2.0 ISSUES:
    This means we can't reliably detect a read-only NFS export.
 
 2. Modifying a Unionfs branch directly, while the union is mounted, is
-   currently unsupported.  We have tested Unionfs under such conditions, and
-   fixed any bugs we found (Unionfs comes with an extensive regression test
-   suite).  However, it may still be possible that changes made to lower
-   branches directly could cause cache incoherency which, in the worst case,
-   may case an oops.  We are currently addressing this problem for Unionfs
-   and also generically for all stackable file systems, by handing mmap and
-   introducing small VFS/MM changes that would allow a file system to handle
-   cache coherency correctly.
+   currently unsupported, because it could cause a cache incoherency between
+   the union layer and the lower file systems (for that reason, Unionfs
+   currently prohibits using branches which overlap with each other, even
+   partially).  We have tested Unionfs under such conditions, and fixed any
+   bugs we found (Unionfs comes with an extensive regression test suite).
+   However, it may still be possible that changes made to lower branches
+   directly could cause cache incoherency which, in the worst case, may case
+   an oops.
 
    Unionfs 2.0 has a temporary workaround for this.  You can force Unionfs
    to increase the superblock generation number, and hence purge all cached
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 84d3bf5..a9ad445 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -351,7 +351,21 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 
 	BUG_ON(branches != (hidden_root_info->bend + 1));
 
-	/* ensure that no overlaps exist in the branches */
+	/*
+	 * Ensure that no overlaps exist in the branches.
+	 *
+	 * This test is required because the Linux kernel has no support
+	 * currently for ensuring coherency between stackable layers and
+	 * branches.  If we were to allow overlapping branches, it would be
+	 * possible, for example, to delete a file via one branch, which
+	 * would not be reflected in another branch.  Such incoherency could
+	 * lead to inconsistencies and even kernel oopses.  Rather than
+	 * implement hacks to work around some of these cache-coherency
+	 * problems, we prevent branch overlapping, for now.  A complete
+	 * solution will involve proper kernel/VFS support for cache
+	 * coherency, at which time we could safely remove this
+	 * branch-overlapping test.
+	 */
 	for (i = 0; i < branches; i++) {
 		for (j = i + 1; j < branches; j++) {
 			dent1 = hidden_root_info->lower_paths[i].dentry;
-- 
1.5.2.rc1.165.gaf9b

