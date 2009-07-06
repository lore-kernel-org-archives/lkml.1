Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbZGFTnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbZGFTnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZGFTnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:43:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47325 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbZGFTnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:43:21 -0400
Date: Mon, 6 Jul 2009 15:47:39 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: emcnabb@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] fix softlockups in ext2/3 when trying to allocate blocks
Message-ID: <20090706194739.GB19798@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't a huge deal, but using a big beefy box with more CPUs than what is
sane, you can get a nice flood of softlockup messages when running heavy
multi-threaded io tests on ext2/3.  The processors compete for blocks from the
allocator, so they will loop quite a bit trying to get their allocation.  This
patch simply makes sure that we reschedule if need be.  This made the softlockup
messages disappear whereas before they happened almost immediately.  Thanks,

Tested-by: Evan McNabb <emcnabb@redhat.com>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/ext2/balloc.c |    1 +
 fs/ext3/balloc.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 7f8d2e5..17dd55f 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -1176,6 +1176,7 @@ ext2_try_to_allocate_with_rsv(struct super_block *sb, unsigned int group,
 			break;				/* succeed */
 		}
 		num = *count;
+		cond_resched();
 	}
 	return ret;
 }
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 27967f9..cffc8cd 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -735,6 +735,7 @@ bitmap_search_next_usable_block(ext3_grpblk_t start, struct buffer_head *bh,
 	struct journal_head *jh = bh2jh(bh);
 
 	while (start < maxblocks) {
+		cond_resched();
 		next = ext3_find_next_zero_bit(bh->b_data, maxblocks, start);
 		if (next >= maxblocks)
 			return -1;
@@ -1391,6 +1392,7 @@ ext3_try_to_allocate_with_rsv(struct super_block *sb, handle_t *handle,
 			break;				/* succeed */
 		}
 		num = *count;
+		cond_resched();
 	}
 out:
 	if (ret >= 0) {
-- 
1.6.2.2

