Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbXKSS3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbXKSS3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbXKSSWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:22:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49378 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbXKSSWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:22:44 -0500
Date: Mon, 19 Nov 2007 10:19:31 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: [patch 23/26] ocfs2: fix write() performance regression
Message-ID: <20071119181931.GX15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ocfs2-fix-write-performance-regression.patch"
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Mark Fasheh <mark.fasheh@oracle.com>

ocfs2: fix write() performance regression

patch 4e9563fd55ff4479f2b118d0757d121dd0cfc39c in mainline.

On file systems which don't support sparse files, Ocfs2_map_page_blocks()
was reading blocks on appending writes. This caused write performance to
suffer dramatically. Fix this by detecting an appending write on a nonsparse
fs and skipping the read.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/aops.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -661,6 +661,27 @@ static void ocfs2_clear_page_regions(str
 }
 
 /*
+ * Nonsparse file systems fully allocate before we get to the write
+ * code. This prevents ocfs2_write() from tagging the write as an
+ * allocating one, which means ocfs2_map_page_blocks() might try to
+ * read-in the blocks at the tail of our file. Avoid reading them by
+ * testing i_size against each block offset.
+ */
+static int ocfs2_should_read_blk(struct inode *inode, struct page *page,
+				 unsigned int block_start)
+{
+	u64 offset = page_offset(page) + block_start;
+
+	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+		return 1;
+
+	if (i_size_read(inode) > offset)
+		return 1;
+
+	return 0;
+}
+
+/*
  * Some of this taken from block_prepare_write(). We already have our
  * mapping by now though, and the entire write will be allocating or
  * it won't, so not much need to use BH_New.
@@ -711,7 +732,8 @@ int ocfs2_map_page_blocks(struct page *p
 			if (!buffer_uptodate(bh))
 				set_buffer_uptodate(bh);
 		} else if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
-		     (block_start < from || block_end > to)) {
+			   ocfs2_should_read_blk(inode, page, block_start) &&
+			   (block_start < from || block_end > to)) {
 			ll_rw_block(READ, 1, &bh);
 			*wait_bh++=bh;
 		}

-- 
