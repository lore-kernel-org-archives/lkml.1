Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbYJZCmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbYJZCmZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 22:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYJZCmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 22:42:17 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36172 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778AbYJZCmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 22:42:16 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-kernel@vger.kernel.org,
       eugene@ibrix.com, msnitzer@ibrix.com, akpm@linux-foundation.org,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 2/2] ext4: Fix duplicate entries returned from getdents() system call
Date: Sat, 25 Oct 2008 22:42:13 -0400
Message-Id: <1224988933-13343-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.1.205.ge2c7.dirty
In-Reply-To: <1224988933-13343-1-git-send-email-tytso@mit.edu>
References: <20081026023914.GA10603@mit.edu>
 <1224988933-13343-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a regression caused by commit d0156417, "ext4: fix ext4_dx_readdir
hash collision handling", where deleting files in a large directory
(requiring more than one getdents system call), results in some
filenames being returned twice.  This was caused by a failure to
update info->curr_hash and info->curr_minor_hash, so that if the
directory had gotten modified since the last getdents() system call
(as would be the case if the user is running "rm -r" or "git clean"),
a directory entry would get returned twice to the userspace.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

This patch fixes the bug reported by Markus Trippelsdorf at:
http://bugzilla.kernel.org/show_bug.cgi?id=11844

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
---
 fs/ext4/dir.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 3ca6a2b..fed5b61 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -459,17 +459,8 @@ static int ext4_dx_readdir(struct file *filp,
 	if (info->extra_fname) {
 		if (call_filldir(filp, dirent, filldir, info->extra_fname))
 			goto finished;
-
 		info->extra_fname = NULL;
-		info->curr_node = rb_next(info->curr_node);
-		if (!info->curr_node) {
-			if (info->next_hash == ~0) {
-				filp->f_pos = EXT4_HTREE_EOF;
-				goto finished;
-			}
-			info->curr_hash = info->next_hash;
-			info->curr_minor_hash = 0;
-		}
+		goto next_node;
 	} else if (!info->curr_node)
 		info->curr_node = rb_first(&info->root);
 
@@ -501,9 +492,14 @@ static int ext4_dx_readdir(struct file *filp,
 		info->curr_minor_hash = fname->minor_hash;
 		if (call_filldir(filp, dirent, filldir, fname))
 			break;
-
+	next_node:
 		info->curr_node = rb_next(info->curr_node);
-		if (!info->curr_node) {
+		if (info->curr_node) {
+			fname = rb_entry(info->curr_node, struct fname,
+					 rb_hash);
+			info->curr_hash = fname->hash;
+			info->curr_minor_hash = fname->minor_hash;
+		} else {
 			if (info->next_hash == ~0) {
 				filp->f_pos = EXT4_HTREE_EOF;
 				break;
-- 
1.5.6.1.205.ge2c7.dirty

