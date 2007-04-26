Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbXDZQ6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbXDZQ6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbXDZQ6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:58:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35024 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbXDZQ6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:58:36 -0400
Date: Thu, 26 Apr 2007 09:55:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>,
       Hugh Dickins <hugh@veritas.com>
Subject: [patch 06/33] holepunch: fix shmem_truncate_range punching too far
Message-ID: <20070426165520.GG1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="holepunch-fix-shmem_truncate_range-punching-too-far.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Hugh Dickins <hugh@veritas.com>

Miklos Szeredi observes BUG_ON(!entry) in shmem_writepage() triggered
in rare circumstances, because shmem_truncate_range() erroneously
removes partially truncated directory pages at the end of the range:
later reclaim on pages pointing to these removed directories triggers
the BUG.  Indeed, and it can also cause data loss beyond the hole.

Fix this as in the patch proposed by Miklos, but distinguish between
"limit" (how far we need to search: ignore truncation's next_index
optimization in the holepunch case - if there are races it's more
consistent to act on the whole range specified) and "upper_limit"
(how far we can free directory pages: generally we must be careful
to keep partially punched pages, but can relax at end of file -
i_size being held stable by i_mutex).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 mm/shmem.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -481,7 +481,8 @@ static void shmem_truncate_range(struct 
 	long nr_swaps_freed = 0;
 	int offset;
 	int freed;
-	int punch_hole = 0;
+	int punch_hole;
+	unsigned long upper_limit;
 
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 	idx = (start + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
@@ -492,11 +493,18 @@ static void shmem_truncate_range(struct 
 	info->flags |= SHMEM_TRUNCATE;
 	if (likely(end == (loff_t) -1)) {
 		limit = info->next_index;
+		upper_limit = SHMEM_MAX_INDEX;
 		info->next_index = idx;
+		punch_hole = 0;
 	} else {
-		limit = (end + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-		if (limit > info->next_index)
-			limit = info->next_index;
+		if (end + 1 >= inode->i_size) {	/* we may free a little more */
+			limit = (inode->i_size + PAGE_CACHE_SIZE - 1) >>
+							PAGE_CACHE_SHIFT;
+			upper_limit = SHMEM_MAX_INDEX;
+		} else {
+			limit = (end + 1) >> PAGE_CACHE_SHIFT;
+			upper_limit = limit;
+		}
 		punch_hole = 1;
 	}
 
@@ -520,10 +528,10 @@ static void shmem_truncate_range(struct 
 	 * If there are no indirect blocks or we are punching a hole
 	 * below indirect blocks, nothing to be done.
 	 */
-	if (!topdir || (punch_hole && (limit <= SHMEM_NR_DIRECT)))
+	if (!topdir || limit <= SHMEM_NR_DIRECT)
 		goto done2;
 
-	BUG_ON(limit <= SHMEM_NR_DIRECT);
+	upper_limit -= SHMEM_NR_DIRECT;
 	limit -= SHMEM_NR_DIRECT;
 	idx = (idx > SHMEM_NR_DIRECT)? (idx - SHMEM_NR_DIRECT): 0;
 	offset = idx % ENTRIES_PER_PAGE;
@@ -543,7 +551,7 @@ static void shmem_truncate_range(struct 
 		if (*dir) {
 			diroff = ((idx - ENTRIES_PER_PAGEPAGE/2) %
 				ENTRIES_PER_PAGEPAGE) / ENTRIES_PER_PAGE;
-			if (!diroff && !offset) {
+			if (!diroff && !offset && upper_limit >= stage) {
 				*dir = NULL;
 				nr_pages_to_free++;
 				list_add(&middir->lru, &pages_to_free);
@@ -570,9 +578,11 @@ static void shmem_truncate_range(struct 
 			}
 			stage = idx + ENTRIES_PER_PAGEPAGE;
 			middir = *dir;
-			*dir = NULL;
-			nr_pages_to_free++;
-			list_add(&middir->lru, &pages_to_free);
+			if (upper_limit >= stage) {
+				*dir = NULL;
+				nr_pages_to_free++;
+				list_add(&middir->lru, &pages_to_free);
+			}
 			shmem_dir_unmap(dir);
 			cond_resched();
 			dir = shmem_dir_map(middir);
@@ -598,7 +608,7 @@ static void shmem_truncate_range(struct 
 		}
 		if (offset)
 			offset = 0;
-		else if (subdir && !page_private(subdir)) {
+		else if (subdir && upper_limit - idx >= ENTRIES_PER_PAGE) {
 			dir[diroff] = NULL;
 			nr_pages_to_free++;
 			list_add(&subdir->lru, &pages_to_free);

-- 
