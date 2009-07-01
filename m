Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbZGAFhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbZGAFhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 01:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZGAFhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 01:37:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39885 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZGAFhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 01:37:13 -0400
Date: Wed, 1 Jul 2009 15:37:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the block tree with the  tree
Message-Id: <20090701153715.7e2935a8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
mm/page-writeback.c between commit
d7831a0bdf06b9f722b947bb0c205ff7d77cebd8 ("mm: prevent balance_dirty_pages
() from doing too much work") from Linus' tree and commit
83f866f06c6d0266330e1631f4644ba6a63e6925 ("writeback: switch to per-bdi
threads for flushing data") from the block tree.

Context changes.  I fixed it up (see below) but am not sure if this is
the correct fix.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/page-writeback.c
index 7687879,7b87d10..0000000
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@@ -541,12 -527,9 +527,12 @@@ static void balance_dirty_pages(struct 
  		 * filesystems (i.e. NFS) in which data may have been
  		 * written to the server's write cache, but has not yet
  		 * been flushed to permanent storage.
 +		 * Only move pages to writeback if this bdi is over its
 +		 * threshold otherwise wait until the disk writes catch
 +		 * up.
  		 */
 -		if (bdi_nr_reclaimable) {
 +		if (bdi_nr_reclaimable > bdi_thresh) {
- 			writeback_inodes(&wbc);
+ 			generic_sync_bdi_inodes(NULL, &wbc);
  			pages_written += write_chunk - wbc.nr_to_write;
  			get_dirty_limits(&background_thresh, &dirty_thresh,
  				       &bdi_thresh, bdi);
