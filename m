Return-Path: <linux-kernel-owner+w=401wt.eu-S1756333AbZCXHRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbZCXHRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 03:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZCXHRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 03:17:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:49697 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZCXHRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 03:17:33 -0400
Date: Tue, 24 Mar 2009 08:17:30 +0100
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH] block: fix intermittent dm timeout based oops
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090324071730.53D7118C7A2@pentland.suse.de>
From: hare@suse.de (Hannes Reinecke)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Very rarely under stress testing of dm, oopses are occuring as
something tampers with an old stack frame.  This has been traced back
to blk_abort_queue() leaving a timeout_list pointing to the stack.
The reason is that sometimes blk_abort_request() won't delete the
timer (if the request is marked as complete but before the timer has
been removed, a small race window).  Fix this by splicing back from
the ususally empty list to the q->timeout_list.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-timeout.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index bbbdc4b..6213123 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -224,6 +224,12 @@ void blk_abort_queue(struct request_queue *q)
 	list_for_each_entry_safe(rq, tmp, &list, timeout_list)
 		blk_abort_request(rq);
 
+	/*
+	 * Occasionally, blk_abort_request() will return without
+	 * deleting the element from the list
+	 */
+	list_splice(&list, &q->timeout_list);
+
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 }
-- 
1.5.3.2

