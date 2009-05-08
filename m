Return-Path: <linux-kernel-owner+w=401wt.eu-S932257AbZEHSh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbZEHSh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761598AbZEHSfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:35:36 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61221 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbZEHSff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:35:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lQ18JZ1HXHg2G5Ot+k4DhyNp2w3AKY5M/HRu1TzOWEc8PMN5lMiL3WZlADkcKHEVS9
         6/bya4pGS41S8wIAGDFdtd7tJLtKcQfwYLudsgpl0WPZipli2swANNFqprAe9chFP4fo
         PzLU1IOSCrr4kjnpO77XdOPwCr3H4Od7Gv34M=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 5/7] kill-the-bkl/reiserfs: reduce number of contentions in search_by_key()
Date: Fri,  8 May 2009 20:35:22 +0200
Message-Id: <1241807725-6263-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241807725-6263-1-git-send-email-fweisbec@gmail.com>
References: <1241807725-6263-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

search_by_key() is a central function in reiserfs which searches
the patch in the fs tree from the root to a node given its key.

It is the function that is most requesting the write lock
because it's a path very often used.

Also we forget to release the lock while reading the next tree node,
making us holding the lock in a wasteful way.

Then we release the lock while reading the current node and its childs,
all-in-one. It should be safe because we have a reference to these
blocks and even if we read a block that will be concurrently changed,
we have an fs_changed check later that will make us retry the path from
the root.

[ Impact: release the write lock while unused in a hot path ]

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/stree.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 6ddcecb..960c911 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -529,6 +529,14 @@ static void search_by_key_reada(struct super_block *s,
 	for (i = 0; i < num; i++) {
 		bh[i] = sb_getblk(s, b[i]);
 	}
+	/*
+	 * We are going to read some blocks on which we
+	 * have a reference. It's safe, though we might be
+	 * reading blocks concurrently changed if we release
+	 * the lock. But it's still fine because we check later
+	 * if the tree changed
+	 */
+	reiserfs_write_unlock(s);
 	for (j = 0; j < i; j++) {
 		/*
 		 * note, this needs attention if we are getting rid of the BKL
@@ -626,10 +634,12 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
 		if ((bh = last_element->pe_buffer =
 		     sb_getblk(sb, block_number))) {
 			if (!buffer_uptodate(bh) && reada_count > 1)
+				/* will unlock the write lock */
 				search_by_key_reada(sb, reada_bh,
 						    reada_blocks, reada_count);
+			else
+				reiserfs_write_unlock(sb);
 			ll_rw_block(READ, 1, &bh);
-			reiserfs_write_unlock(sb);
 			wait_on_buffer(bh);
 			reiserfs_write_lock(sb);
 			if (!buffer_uptodate(bh))
-- 
1.6.2.3

