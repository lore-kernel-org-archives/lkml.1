Return-Path: <linux-kernel-owner+w=401wt.eu-S934142AbXICCet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142AbXICCet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbXICC0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:26:08 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57694 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbXICCZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:25:09 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 23/32] Unionfs: mount-time option parsing fix
Date: Sun,  2 Sep 2007 22:20:46 -0400
Message-Id: <11887860583576-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/main.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index bc5c105..ce08d96 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -337,8 +337,12 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 		int perms;
 		char *mode = strchr(name, '=');
 
-		if (!name || !*name)
+		if (!name)
 			continue;
+		if (!*name) {	/* bad use of ':' (extra colons) */
+			err = -EINVAL;
+			goto out;
+		}
 
 		branches++;
 
@@ -404,10 +408,9 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 	 * branch-overlapping test.
 	 */
 	for (i = 0; i < branches; i++) {
+		dent1 = lower_root_info->lower_paths[i].dentry;
 		for (j = i + 1; j < branches; j++) {
-			dent1 = lower_root_info->lower_paths[i].dentry;
 			dent2 = lower_root_info->lower_paths[j].dentry;
-
 			if (is_branch_overlap(dent1, dent2)) {
 				printk(KERN_WARNING "unionfs: branches %d and "
 				       "%d overlap\n", i, j);
-- 
1.5.2.2.238.g7cbf2f2

