Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbXDZQ7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbXDZQ7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbXDZQ7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:59:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39442 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbXDZQ7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:59:08 -0400
Date: Thu, 26 Apr 2007 09:55:35 -0700
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
Subject: [patch 08/33] holepunch: fix disconnected pages after second
	truncate
Message-ID: <20070426165535.GI1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="holepunch-fix-disconnected-pages-after-second-truncate.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Hugh Dickins <hugh@veritas.com>

shmem_truncate_range has its own truncate_inode_pages_range, to free any
pages racily instantiated while it was in progress: a SHMEM_PAGEIN flag
is set when this might have happened.  But holepunching gets no chance
to clear that flag at the start of vmtruncate_range, so it's always set
(unless a truncate came just before), so holepunch almost always does
this second truncate_inode_pages_range.

shmem holepunch has unlikely swap<->file races hereabouts whatever we do
(without a fuller rework than is fit for this release): I was going to
skip the second truncate in the punch_hole case, but Miklos points out
that would make holepunch correctness more vulnerable to swapoff.  So
keep the second truncate, but follow it by an unmap_mapping_range to
eliminate the disconnected pages (freed from pagecache while still
mapped in userspace) that it might have left behind.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/shmem.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -674,8 +674,16 @@ done2:
 		 * generic_delete_inode did it, before we lowered next_index.
 		 * Also, though shmem_getpage checks i_size before adding to
 		 * cache, no recheck after: so fix the narrow window there too.
+		 *
+		 * Recalling truncate_inode_pages_range and unmap_mapping_range
+		 * every time for punch_hole (which never got a chance to clear
+		 * SHMEM_PAGEIN at the start of vmtruncate_range) is expensive,
+		 * yet hardly ever necessary: try to optimize them out later.
 		 */
 		truncate_inode_pages_range(inode->i_mapping, start, end);
+		if (punch_hole)
+			unmap_mapping_range(inode->i_mapping, start,
+							end - start, 1);
 	}
 
 	spin_lock(&info->lock);

-- 
