Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbZF2Gcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbZF2Gcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 02:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbZF2Gcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 02:32:36 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:58606 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbZF2Gcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 02:32:35 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] fs: allow d_instantiate to be called with negative parent
	dentry
Message-Id: <1246257118.265649.273423097532.1.gpush@pingu>
To: <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
       Christoph Hellwig <hch@lst.de>, <cbe-oss-dev@ozlabs.org>
From: Jeremy Kerr <jk@ozlabs.org>
Date: Mon, 29 Jun 2009 14:31:58 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new fsnotify infrastructure (starting at 90586523) causes an oops in
spufs, where we populate a directory with files before instantiating the
directory itself. The new changes seem to have introduced an assumption
that a dentry's parent will be positive when instantiating.

This change makes it once again possible to d_instantiate a dentry
with a negative parent, and brings __fsnotify_d_instantiate() into
line with inotify_d_instantiate(), which already has this NULL check.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

---
Apologies for the resend, fixed lkml address

---
 include/linux/fsnotify_backend.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 44848aa..6c3de99 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -280,7 +280,7 @@ static inline void __fsnotify_update_dcache_flags(struct dentry *dentry)
 	assert_spin_locked(&dentry->d_lock);
 
 	parent = dentry->d_parent;
-	if (fsnotify_inode_watches_children(parent->d_inode))
+	if (parent->d_inode && fsnotify_inode_watches_children(parent->d_inode))
 		dentry->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
 	else
 		dentry->d_flags &= ~DCACHE_FSNOTIFY_PARENT_WATCHED;
