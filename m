Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbZD0FU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbZD0FU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 01:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZD0FUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 01:20:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:33329 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbZD0FUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 01:20:10 -0400
From: Neil Brown <neilb@suse.de>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Mon, 27 Apr 2009 15:20:22 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18933.16534.862316.787808@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] Fix race between callers of read_cache_page_async and invalidate_inode_pages.
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Callers of read_cache_page_async typically wait for the page to become
unlocked (wait_on_page_locked) and then test PageUptodate to see if
the read was successful, or if there was an error.

This is wrong.

invalidate_inode_pages can cause an unlocked page to lose its
PageUptodate flag at any time without implying a read error.

As any read error will cause PageError to be set, it is much safer,
and more idiomatic to test "PageError" than to test "!PageUptodate".
Hence this patch.

An actual failure that has been seen (on a 2.6.5 based kernel)
involves symlinks.  Symlinks are more suseptible as the 'open' and
'read' phases can be very close together, and so can both overlap with
invalidate_inode_pages.

The sequence goes something like:

  high memory pressure prunes dentry
  continuing memory pressure cause prune
    of inode to start.  Start invaliding
    page(s).
                                             Lookup of path containing symlink
                                              causes inode (inode is found in
                                              cache).
                                             page_getlink calls
                                               read_cache_page
                                                read_cache_page_async
                                                finds that page is Uptodate
   __invalidate_mapping_pages finds page
   and locks it
                                                read_cache_page waits for lock
                                                to be released.
   invalidate_complete_page clears
   PageUptodate
                                                read_cache_page finds Uptodate
                                                is clear and assumes an error.

As we can see, finding !PageUptodate is not an error.  Possibly in
this case we could try an read again, but really there is no point.
After calling read_cache_page_async and waiting for the page to be
unlocked, then either the page has been read, or there was an error.
The simplest way to check, is to tests PageError.

Note the "typically" in the first sentence refers to fs/jffs2/fs.c
which uses read_cache_page_async, but never checks for an error, or
even waits for the page to be unlocked.  This seems wrong, though
maybe there is some justification for it.

Signed-off-by: NeilBrown <neilb@suse.de>
cc: Nick Piggin <npiggin@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 fs/cramfs/inode.c |    2 +-
 mm/filemap.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index dd3634e..573d582 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -180,7 +180,7 @@ static void *cramfs_read(struct super_block *sb, unsigned int offset, unsigned i
 		struct page *page = pages[i];
 		if (page) {
 			wait_on_page_locked(page);
-			if (!PageUptodate(page)) {
+			if (PageError(page)) {
 				/* asynchronous error */
 				page_cache_release(page);
 				pages[i] = NULL;
diff --git a/mm/filemap.c b/mm/filemap.c
index 379ff0b..9ff8093 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1770,7 +1770,7 @@ struct page *read_cache_page(struct address_space *mapping,
 	if (IS_ERR(page))
 		goto out;
 	wait_on_page_locked(page);
-	if (!PageUptodate(page)) {
+	if (!PageError(page)) {
 		page_cache_release(page);
 		page = ERR_PTR(-EIO);
 	}
-- 
1.6.2.4

