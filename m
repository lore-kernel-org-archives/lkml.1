Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbYJZCmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbYJZCmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 22:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYJZCmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 22:42:17 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36170 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751753AbYJZCmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 22:42:16 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-kernel@vger.kernel.org,
       eugene@ibrix.com, msnitzer@ibrix.com, akpm@linux-foundation.org,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 1/2] ext3: Fix duplicate entries returned from getdents() system call
Date: Sat, 25 Oct 2008 22:42:12 -0400
Message-Id: <1224988933-13343-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.1.205.ge2c7.dirty
In-Reply-To: <20081026023914.GA10603@mit.edu>
References: <20081026023914.GA10603@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a regression caused by commit 6a897cf4, "ext3: fix ext3_dx_readdir
hash collision handling", where deleting files in a large directory
(requiring more than one getdents system call), results in some
filenames being returned twice.  This was caused by a failure to
update info->curr_hash and info->curr_minor_hash, so that if the
directory had gotten modified since the last getdents() system call
(as would be the case if the user is running "rm -r" or "git clean"),
a directory entry would get returned twice to the userspace.

This patch fixes the bug reported by Markus Trippelsdorf at:
http://bugzilla.kernel.org/show_bug.cgi?id=11844

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
---
 fs/ext3/dir.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index 4c82531..5853f44 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -456,17 +456,8 @@ static int ext3_dx_readdir(struct file * filp,
 	if (info->extra_fname) {
 		if (call_filldir(filp, dirent, filldir, info->extra_fname))
 			goto finished;
-
 		info->extra_fname = NULL;
-		info->curr_node = rb_next(info->curr_node);
-		if (!info->curr_node) {
-			if (info->next_hash == ~0) {
-				filp->f_pos = EXT3_HTREE_EOF;
-				goto finished;
-			}
-			info->curr_hash = info->next_hash;
-			info->curr_minor_hash = 0;
-		}
+		goto next_node;
 	} else if (!info->curr_node)
 		info->curr_node = rb_first(&info->root);
 
@@ -498,9 +489,14 @@ static int ext3_dx_readdir(struct file * filp,
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
 				filp->f_pos = EXT3_HTREE_EOF;
 				break;
-- 
1.5.6.1.205.ge2c7.dirty

