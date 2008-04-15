Return-Path: <linux-kernel-owner+w=401wt.eu-S1764718AbYDOLie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764718AbYDOLie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 07:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758340AbYDOLiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 07:38:24 -0400
Received: from styx.suse.cz ([82.119.242.94]:44683 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758035AbYDOLiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:38:23 -0400
Date: Tue, 15 Apr 2008 13:38:21 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: Fix possible deadlock in ext2, ext3, ext4 when using
	xattrs
Message-ID: <20080415113821.GA28699@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mb_cache_entry_alloc() was allocating cache entries with GFP_KERNEL. But filesystems
are calling this function while holding xattr_sem so possible recursion into the fs
violates locking ordering of xattr_sem and transaction start / i_mutex for ext2-4.
Change mb_cache_entry_alloc() so that filesystems can specify desired gfp mask and
use GFP_NOFS from all of them.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Dave Jones <davej@redhat.com>
---
  I've bundled changes for ext2-4 together because they are oneliners and
not likely to conflict with anything and a partial change would make other
filesystems not compilable...

 fs/ext2/xattr.c         |    2 +-
 fs/ext3/xattr.c         |    2 +-
 fs/ext4/xattr.c         |    2 +-
 fs/mbcache.c            |    4 ++--
 include/linux/mbcache.h |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 3e8683d..a99d46f 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -835,7 +835,7 @@ ext2_xattr_cache_insert(struct buffer_head *bh)
 	struct mb_cache_entry *ce;
 	int error;
 
-	ce = mb_cache_entry_alloc(ext2_xattr_cache);
+	ce = mb_cache_entry_alloc(ext2_xattr_cache, GFP_NOFS);
 	if (!ce)
 		return -ENOMEM;
 	error = mb_cache_entry_insert(ce, bh->b_bdev, bh->b_blocknr, &hash);
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index a6ea4d6..4285654 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -1126,7 +1126,7 @@ ext3_xattr_cache_insert(struct buffer_head *bh)
 	struct mb_cache_entry *ce;
 	int error;
 
-	ce = mb_cache_entry_alloc(ext3_xattr_cache);
+	ce = mb_cache_entry_alloc(ext3_xattr_cache, GFP_NOFS);
 	if (!ce) {
 		ea_bdebug(bh, "out of memory");
 		return;
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index d796213..e9054c1 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1386,7 +1386,7 @@ ext4_xattr_cache_insert(struct buffer_head *bh)
 	struct mb_cache_entry *ce;
 	int error;
 
-	ce = mb_cache_entry_alloc(ext4_xattr_cache);
+	ce = mb_cache_entry_alloc(ext4_xattr_cache, GFP_NOFS);
 	if (!ce) {
 		ea_bdebug(bh, "out of memory");
 		return;
diff --git a/fs/mbcache.c b/fs/mbcache.c
index eb31b73..ec88ff3 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -399,11 +399,11 @@ mb_cache_destroy(struct mb_cache *cache)
  * if no more memory was available.
  */
 struct mb_cache_entry *
-mb_cache_entry_alloc(struct mb_cache *cache)
+mb_cache_entry_alloc(struct mb_cache *cache, gfp_t gfp_flags)
 {
 	struct mb_cache_entry *ce;
 
-	ce = kmem_cache_alloc(cache->c_entry_cache, GFP_KERNEL);
+	ce = kmem_cache_alloc(cache->c_entry_cache, gfp_flags);
 	if (ce) {
 		atomic_inc(&cache->c_entry_count);
 		INIT_LIST_HEAD(&ce->e_lru_list);
diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
index 99e044b..a09b84e 100644
--- a/include/linux/mbcache.h
+++ b/include/linux/mbcache.h
@@ -34,7 +34,7 @@ void mb_cache_destroy(struct mb_cache *);
 
 /* Functions on cache entries */
 
-struct mb_cache_entry *mb_cache_entry_alloc(struct mb_cache *);
+struct mb_cache_entry *mb_cache_entry_alloc(struct mb_cache *, gfp_t);
 int mb_cache_entry_insert(struct mb_cache_entry *, struct block_device *,
 			  sector_t, unsigned int[]);
 void mb_cache_entry_release(struct mb_cache_entry *);
-- 
1.5.2.4

