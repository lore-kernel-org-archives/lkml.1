Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbZJBB4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbZJBB4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbZJBB4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:56:45 -0400
Received: from kroah.org ([198.145.64.141]:33037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201AbZJBBcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:55 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:11 2009
Message-Id: <20091002012411.140561491@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [035/136] nilfs2: fix missing zero-fill initialization of btree node cache
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=nilfs2-fix-missing-zero-fill-initialization-of-btree-node-cache.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

commit 1f28fcd925b2b3157411bbd08f0024b55b70d8dd upstream.

This will fix file system corruption which infrequently happens after
mount.  The problem was reported from users with the title "[NILFS
users] Fail to mount NILFS." (Message-ID:
<200908211918.34720.yuri@itinteg.net>), and so forth.  I've also
experienced the corruption multiple times on kernel 2.6.30 and 2.6.31.

The problem turned out to be caused due to discordance between
mapping->nrpages of a btree node cache and the actual number of pages
hung on the cache; if the mapping->nrpages becomes zero even as it has
pages, truncate_inode_pages() returns without doing anything.  Usually
this is harmless except it may cause page leak, but garbage collection
fairly infrequently sees a stale page remained in the btree node cache
of DAT (i.e. disk address translation file of nilfs), and induces the
corruption.

I identified a missing initialization in btree node caches was the
root cause.  This corrects the bug.

I've tested this for kernel 2.6.30 and 2.6.31.

Reported-by: Yuri Chislov <yuri@itinteg.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/btnode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -36,6 +36,7 @@
 
 void nilfs_btnode_cache_init_once(struct address_space *btnc)
 {
+	memset(btnc, 0, sizeof(*btnc));
 	INIT_RADIX_TREE(&btnc->page_tree, GFP_ATOMIC);
 	spin_lock_init(&btnc->tree_lock);
 	INIT_LIST_HEAD(&btnc->private_list);


