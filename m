Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbZFHTZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbZFHTZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbZFHTXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:22 -0400
Received: from thunk.org ([69.25.196.29]:39542 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbZFHTXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 07/49] ext4: avoid unnecessary spinlock in critical POSIX ACL path
Date: Mon,  8 Jun 2009 15:22:25 -0400
Message-Id: <1244488987-32564-8-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-7-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a filesystem supports POSIX ACL's, the VFS layer expects the filesystem
to do POSIX ACL checks on any files not owned by the caller, and it does
this for every single pathname component that it looks up.

That obviously can be pretty expensive if the filesystem isn't careful
about it, especially with locking. That's doubly sad, since the common
case tends to be that there are no ACL's associated with the files in
question.

ext4 already caches the ACL data so that it doesn't have to look it up
over and over again, but it does so by taking the inode->i_lock spinlock
on every lookup. Which is a noticeable overhead even if it's a private
lock, especially on CPU's where the serialization is expensive (eg Intel
Netburst aka 'P4').

For the special case of not actually having any ACL's, all that locking is
unnecessary. Even if somebody else were to be changing the ACL's on
another CPU, we simply don't care - if we've seen a NULL ACL, we might as
well use it.

So just load the ACL speculatively without any locking, and if it was
NULL, just use it. If it's non-NULL (either because we had a cached
entry, or because the cache hasn't been filled in at all), it means that
we'll need to get the lock and re-load it properly.

(This commit was ported from a patch originally authored by Linus for
ext3.)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/acl.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 647e0d6..605aeed 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -129,12 +129,15 @@ fail:
 static inline struct posix_acl *
 ext4_iget_acl(struct inode *inode, struct posix_acl **i_acl)
 {
-	struct posix_acl *acl = EXT4_ACL_NOT_CACHED;
+	struct posix_acl *acl = ACCESS_ONCE(*i_acl);
 
-	spin_lock(&inode->i_lock);
-	if (*i_acl != EXT4_ACL_NOT_CACHED)
-		acl = posix_acl_dup(*i_acl);
-	spin_unlock(&inode->i_lock);
+	if (acl) {
+		spin_lock(&inode->i_lock);
+		acl = *i_acl;
+		if (acl != EXT4_ACL_NOT_CACHED)
+			acl = posix_acl_dup(acl);
+		spin_unlock(&inode->i_lock);
+	}
 
 	return acl;
 }
-- 
1.6.3.2.1.gb9f7d.dirty

