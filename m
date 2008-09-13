Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbYIMPdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbYIMPdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 11:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYIMPc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 11:32:57 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:50913 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384AbYIMPc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 11:32:56 -0400
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@MIT.EDU>,
       Eugene Dashevsky <eugene@ibrix.com>, Mike Snitzer <msnitzer@ibrix.com>,
       linux-ext4@vger.kernel.org
Subject: [PATCH 1/4] ext3: Fix ext3_dx_readdir hash collision handling
Date: Sat, 13 Sep 2008 11:32:48 -0400
Message-Id: <1221319971-29879-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.1.205.ge2c7.dirty
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a bug where readdir() would return a directory entry twice
if there was a hash collision in an hash tree indexed directory.

Signed-off-by: Eugene Dashevsky <eugene@ibrix.com>
Signed-off-by: Mike Snitzer <msnitzer@ibrix.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext3/dir.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index 2eea96e..42c5391 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -410,7 +410,7 @@ static int call_filldir(struct file * filp, void * dirent,
 				get_dtype(sb, fname->file_type));
 		if (error) {
 			filp->f_pos = curr_pos;
-			info->extra_fname = fname->next;
+			info->extra_fname = fname;
 			return error;
 		}
 		fname = fname->next;
@@ -449,11 +449,21 @@ static int ext3_dx_readdir(struct file * filp,
 	 * If there are any leftover names on the hash collision
 	 * chain, return them first.
 	 */
-	if (info->extra_fname &&
-	    call_filldir(filp, dirent, filldir, info->extra_fname))
-		goto finished;
-
-	if (!info->curr_node)
+	if (info->extra_fname) {
+                if (call_filldir(filp, dirent, filldir, info->extra_fname))
+                        goto finished;
+
+                info->extra_fname = NULL;
+                info->curr_node = rb_next(info->curr_node);
+                if (!info->curr_node) {
+                        if (info->next_hash == ~0) {
+                                filp->f_pos = EXT3_HTREE_EOF;
+                                goto finished;
+                        }
+                        info->curr_hash = info->next_hash;
+                        info->curr_minor_hash = 0;
+                }
+        } else if (!info->curr_node)
 		info->curr_node = rb_first(&info->root);
 
 	while (1) {
-- 
1.5.6.1.205.ge2c7.dirty

