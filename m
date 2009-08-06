Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbZHFLP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbZHFLP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZHFLP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:15:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44164 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbZHFLPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:15:25 -0400
Subject: [PATCH] block: silently error unsupported empty barriers too
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       dm-devel <dm-devel@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
       Neil Brown <neilb@suse.de>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 12:14:17 +0100
Message-Id: <1249557257.3721.55.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.31-rc5 in a KVM guest using dm and virtio_blk, we see the
following errors:

  end_request: I/O error, dev vda, sector 0
  end_request: I/O error, dev vda, sector 0

The errors go away if dm stops submitting empty barriers, by reverting:

  commit 52b1fd5a27c625c78373e024bf570af3c9d44a79
  Author: Mikulas Patocka <mpatocka@redhat.com>
    dm: send empty barriers to targets in dm_flush

We should error all barriers, even empty barriers, on devices like
virtio_blk which don't support them.

See also:

  https://bugzilla.redhat.com/514901

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Neil Brown <neilb@suse.de>
---
 block/blk-core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e3299a7..35ad2bb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1163,8 +1163,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	const int unplug = bio_unplug(bio);
 	int rw_flags;
 
-	if (bio_barrier(bio) && bio_has_data(bio) &&
-	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
+	if (bio_barrier(bio) && (q->next_ordered == QUEUE_ORDERED_NONE)) {
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
-- 
1.6.4

