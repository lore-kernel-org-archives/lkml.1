Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZGQUV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZGQUV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbZGQUV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:21:56 -0400
Received: from kroah.org ([198.145.64.141]:43114 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961AbZGQUTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:49 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:33 2009
Message-Id: <20090717201233.513527878@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:09:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ken Milmore <ken.milmore@googlemail.com>, NeilBrown <neilb@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 14/24] blocK: Restore barrier support for md and probably other virtual devices.
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=block-restore-barrier-support-for-md-and-probably-other-virtual-devices.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit db64f680ba4b5c56c4be59f0698000df89ff0281 upstream.

The next_ordered flag is only meaningful for devices that use __make_request.
So move the test against next_ordered out of generic code and in to
__make_request

Since this test was added, barriers have not worked on md or any
devices that don't use __make_request and so don't bother to set
next_ordered.  (dm explicitly sets something other than
QUEUE_ORDERED_NONE since
  commit 99360b4c18f7675b50d283301d46d755affe75fd
but notes in the comments that it is otherwise meaningless).

Cc: Ken Milmore <ken.milmore@googlemail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1158,6 +1158,11 @@ static int __make_request(struct request
 
 	nr_sectors = bio_sectors(bio);
 
+	if (bio_barrier(bio) && bio_has_data(bio) &&
+	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return 0;
+	}
 	/*
 	 * low level driver can indicate that it wants pages above a
 	 * certain limit bounced to low memory (ie for highmem, or even
@@ -1461,11 +1466,6 @@ static inline void __generic_make_reques
 			err = -EOPNOTSUPP;
 			goto end_io;
 		}
-		if (bio_barrier(bio) && bio_has_data(bio) &&
-		    (q->next_ordered == QUEUE_ORDERED_NONE)) {
-			err = -EOPNOTSUPP;
-			goto end_io;
-		}
 
 		ret = q->make_request_fn(q, bio);
 	} while (ret);


