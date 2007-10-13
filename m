Return-Path: <linux-kernel-owner+w=401wt.eu-S1763323AbXJMO6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763323AbXJMO6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762186AbXJMOnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:43:45 -0400
Received: from 1wt.eu ([62.212.114.60]:3050 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762083AbXJMOnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:43:43 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143508.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:50 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 28/35] Fix race with shared tag queue maps
Content-Disposition: inline; filename=0085-Fix-race-with-shared-tag-queue-maps.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The commit in Linus upstream git tree is
f3da54ba140c6427fa4a32913e1bf406f41b5dda.

Fix race with shared tag queue maps

There's a race condition in blk_queue_end_tag() for shared tag maps,
users include stex (promise supertrak thingy) and qla2xxx.  The former
at least has reported bugs in this area, not sure why we haven't seen
any for the latter.  It could be because the window is narrow and that
other conditions in the qla2xxx code hide this.  It's a real bug,
though, as the stex smp users can attest.

We need to ensure two things - the tag bit clearing needs to happen
AFTER we cleared the tag pointer, as the tag bit clearing/setting is
what protects this map.  Secondly, we need to ensure that the visibility
of the tag pointer and tag bit clear are ordered properly.

[ I removed the SMP barriers - "test_and_clear_bit()" already implies
  all the required barriers.  -- Linus ]

Also see http://bugzilla.kernel.org/show_bug.cgi?id=7842

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/ll_rw_blk.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

Index: 2.6/block/ll_rw_blk.c
===================================================================
--- 2.6.orig/block/ll_rw_blk.c
+++ 2.6/block/ll_rw_blk.c
@@ -1072,12 +1072,6 @@ void blk_queue_end_tag(request_queue_t *
 		 */
 		return;
 
-	if (unlikely(!__test_and_clear_bit(tag, bqt->tag_map))) {
-		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)
",
-		       __FUNCTION__, tag);
-		return;
-	}
-
 	list_del_init(&rq->queuelist);
 	rq->cmd_flags &= ~REQ_QUEUED;
 	rq->tag = -1;
@@ -1087,6 +1081,13 @@ void blk_queue_end_tag(request_queue_t *
 		       __FUNCTION__, tag);
 
 	bqt->tag_index[tag] = NULL;
+
+	if (unlikely(!test_and_clear_bit(tag, bqt->tag_map))) {
+		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)
",
+		       __FUNCTION__, tag);
+		return;
+	}
+
 	bqt->busy--;
 }
 

-- 
