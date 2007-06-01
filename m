Return-Path: <linux-kernel-owner+w=401wt.eu-S1758550AbXFAHPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbXFAHPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbXFAHPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:15:01 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:3791 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301AbXFAHPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:15:00 -0400
Date: Fri, 1 Jun 2007 11:22:49 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH 2.6.16] Fix NULL bio crash in loop worker thread
Message-ID: <20070601072249.GA6085@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After LOOP_SET_FD/LOOP_CLR_FD combo loop device's queue gets request
handler which is persistent.

After, say

        mount -t iso9660 /dev/loop0 /mnt        # sic

this request handler is called directly with
a) ->lo_state being Lo_unbound
b) ->lo_pending being zero

Error path in loop_make_request() completes ->lo_bh_done completion
which is persistent as well.

Now, let's start worker thread as usual. It'll set ->lo_pending to 1,
don't wait for completion because it was already completed (brokenly),
and will not get out of infinite loop because of ->lo_pending. Loop
device doesn't have bios at this point and triggers BUG_ON.

So, don't complete ->lo_bh_done when loop device isn't setup fully.

Steps to reproduce:

	#!/bin/sh -x
	ISO=1.iso
	mount -o loop $ISO /mnt
	umount /mnt
	mount -t iso9660 /dev/loop0 /mnt        # sic
	mount -o loop $ISO /mnt

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 drivers/block/loop.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -521,7 +521,7 @@ static int loop_make_request(request_queue_t *q, struct bio *old_bio)
 
 	spin_lock_irq(&lo->lo_lock);
 	if (lo->lo_state != Lo_bound)
-		goto out;
+		goto out_not_bound;
 	if (unlikely(rw == WRITE && (lo->lo_flags & LO_FLAGS_READ_ONLY)))
 		goto out;
 	lo->lo_pending++;
@@ -533,6 +533,7 @@ static int loop_make_request(request_queue_t *q, struct bio *old_bio)
 out:
 	if (lo->lo_pending == 0)
 		complete(&lo->lo_bh_done);
+out_not_bound:
 	spin_unlock_irq(&lo->lo_lock);
 	bio_io_error(old_bio, old_bio->bi_size);
 	return 0;

