Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbXINGlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbXINGlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 02:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbXINGlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 02:41:17 -0400
Received: from ns.suse.de ([195.135.220.2]:37322 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbXINGlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 02:41:16 -0400
Date: Fri, 14 Sep 2007 08:41:12 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>
Subject: [patch] shared tag queue barrier comment
Message-ID: <20070914064112.GA25277@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Should add some comments for the tag barriers (they won't be so important
if we can switch over to the explicit _lock bitops, but for now we should
make it clear).

Jens' original patch said a barrier after the test_and_clear_bit was also
required. I can't see why (and it would prevent the use of the _lock bitop).

--
Index: linux-2.6/block/ll_rw_blk.c
===================================================================
--- linux-2.6.orig/block/ll_rw_blk.c
+++ linux-2.6/block/ll_rw_blk.c
@@ -1085,6 +1085,12 @@ void blk_queue_end_tag(struct request_qu
 
 	bqt->tag_index[tag] = NULL;
 
+	/*
+	 * We use test_and_clear_bit's memory ordering properties here.
+	 * The tag_map bit acts as a lock for tag_index[bit], so we need
+	 * a barrer before clearing the bit (precisely: release semantics).
+	 * Could use clear_bit_unlock when it is merged.
+	 */
 	if (unlikely(!test_and_clear_bit(tag, bqt->tag_map))) {
 		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)\n",
 		       __FUNCTION__, tag);
@@ -1137,6 +1143,10 @@ int blk_queue_start_tag(struct request_q
 			return 1;
 
 	} while (test_and_set_bit(tag, bqt->tag_map));
+	/*
+	 * We rely on test_and_set_bit providing lock memory ordering semantics
+	 * (could use test_and_set_bit_lock when it is merged).
+	 */
 
 	rq->cmd_flags |= REQ_QUEUED;
 	rq->tag = tag;
