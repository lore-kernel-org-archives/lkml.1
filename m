Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZKSRWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZKSRWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZKSRWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:22:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360AbZKSRWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:22:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 16/28] FS-Cache: Don't delete pending pages from the
	page-store tracking tree
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:21:56 +0000
Message-ID: <20091119172156.1679.87264.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't delete pending pages from the page-store tracking tree, but rather send
them for another write as they've presumably been updated.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/page.c |    7 +++++--
 lib/radix-tree.c  |    2 --
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 3ea8897..022a5da 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -57,8 +57,11 @@ static void fscache_end_page_write(struct fscache_object *object,
 		/* delete the page from the tree if it is now no longer
 		 * pending */
 		spin_lock(&cookie->stores_lock);
-		fscache_stat(&fscache_n_store_radix_deletes);
-		xpage = radix_tree_delete(&cookie->stores, page->index);
+		if (!radix_tree_tag_get(&cookie->stores, page->index,
+					FSCACHE_COOKIE_PENDING_TAG)) {
+			fscache_stat(&fscache_n_store_radix_deletes);
+			xpage = radix_tree_delete(&cookie->stores, page->index);
+		}
 		spin_unlock(&cookie->stores_lock);
 		wake_up_bit(&cookie->flags, 0);
 	}
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index ae61068..92cdd99 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -546,7 +546,6 @@ out:
 }
 EXPORT_SYMBOL(radix_tree_tag_clear);
 
-#ifndef __KERNEL__	/* Only the test harness uses this at present */
 /**
  * radix_tree_tag_get - get a tag on a radix tree node
  * @root:		radix tree root
@@ -609,7 +608,6 @@ int radix_tree_tag_get(struct radix_tree_root *root,
 	}
 }
 EXPORT_SYMBOL(radix_tree_tag_get);
-#endif
 
 /**
  *	radix_tree_next_hole    -    find the next hole (not-present entry)

