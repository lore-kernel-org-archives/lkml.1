Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbXHVI6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbXHVI6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758183AbXHVIw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:58 -0400
Received: from 1wt.eu ([62.212.114.60]:1968 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbXHVIw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:57 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084006.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:07 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Arne Redlich <agr@powerkom-dd.de>, Neil Brown <neilb@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 23/58] md: handle writes to broken raid10 arrays gracefully
Content-Disposition: inline; filename=0023-md-handle-writes-to-broken-raid10-arrays-gracefully.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When writing to a broken array, raid10 currently happily emits empty bio
lists.  IOW, the master bio will never be completed, sending writers to
UNINTERRUPTIBLE_SLEEP forever.

Signed-off-by: Arne Redlich <agr@powerkom-dd.de>
Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/md/raid10.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9eb66c1..fb5d9c6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -917,6 +917,13 @@ static int make_request(request_queue_t *q, struct bio * bio)
 		bio_list_add(&bl, mbio);
 	}
 
+	if (unlikely(!atomic_read(&r10_bio->remaining))) {
+		/* the array is dead */
+		md_write_end(mddev);
+		raid_end_bio_io(r10_bio);
+		return 0;
+	}
+
 	bitmap_startwrite(mddev->bitmap, bio->bi_sector, r10_bio->sectors, 0);
 	spin_lock_irqsave(&conf->device_lock, flags);
 	bio_list_merge(&conf->pending_bio_list, &bl);
-- 
1.5.2.5

-- 
