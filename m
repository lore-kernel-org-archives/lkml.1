Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYJYL4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYJYL4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 07:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYJYL4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 07:56:36 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49606 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751622AbYJYL4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 07:56:35 -0400
Date: Sat, 25 Oct 2008 07:56:31 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-kernel@vger.kernel.org,
       eugene@ibrix.com, msnitzer@ibrix.com, akpm@linux-foundation.org
Subject: [PATCH] Re: ext3: fix ext3_dx_readdir hash collision handling -
	Regression
Message-ID: <20081025115631.GA17661@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	linux-kernel@vger.kernel.org, eugene@ibrix.com, msnitzer@ibrix.com,
	akpm@linux-foundation.org
References: <20081022093201.GA2227@gentoox2.trippelsdorf.de> <20081023032832.GE10369@mit.edu> <20081023063740.GA2438@gentoox2.trippelsdorf.de> <20081024000109.GD7842@mit.edu> <20081024042851.GA2360@gentoox2.trippelsdorf.de> <alpine.LFD.2.00.0810240853310.3287@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810240853310.3287@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe I've found the problem.  I'm still not 100% sure why I'm not
seeing this on a 32-bit kernel, so I want to do a bit more testing to
make sure I completely understand what was happening.  However, once I
reproduced it on a a 64-bit kernel, it was pretty clear what the
problem was.  The problem only happens when the directory is changing
out from under us (which would be the case when the directory is
getting deleted via "/bin/rm -r" or "git clean").  When that happens,
the following check causes us to reload the rbtree we use to return
the directory entries in hash sort error:

		/*
		 * Fill the rbtree if we have no more entries,
		 * or the inode has changed since we last read in the
		 * cached entries.
		 */
		if ((!info->curr_node) ||
		    (filp->f_version != inode->i_version)) {
			info->curr_node = NULL;
			free_rb_tree_fname(&info->root);
			filp->f_version = inode->i_version;
			ret = ext3_htree_fill_tree(filp, info->curr_hash,
						   info->curr_minor_hash,
						   &info->next_hash);


Unfortunately, the commit which which fixes the duplicated entries
when there are hash collisions wasn't properly setting info->curr_hash
and info->curr_minor_hash after going to the next node, which results
the first entry being returned twice on the subsequent getdents()
system call.  What I don't understand was why I wasn't seeing this on
a 32-bit kernel (maybe I screwed up my test environment; this problem
should have occurred regardless of the 32-bit or 64-bit environment).

In any case, if folks could test to see whether this patch fixes
things, I'd appreciate it.  (Patch for ext3 and ext4 follows).

							- Ted

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
