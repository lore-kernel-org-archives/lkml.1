Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZJIJyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZJIJyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZJIJx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:53:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbZJIJx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:53:59 -0400
Date: Fri, 9 Oct 2009 11:53:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Geert Uytterhoeven <geert@linux-m68k.org>, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [RFC] ataflop: remove buggy IRQ disable from
 do_fd_request()
Message-ID: <alpine.LSU.2.00.0910091141150.19284@wotan.suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a nice gem in drivers/block/ataflop.c::do_fd_request()

	void do_fd_request(struct request_queue * q)
	{
		unsigned long flags;

		DPRINT(("do_fd_request for pid %d\n",current->pid));
		while( fdc_busy ) sleep_on( &fdc_wait );
		fdc_busy = 1;
		stdma_lock(floppy_irq, NULL);

		atari_disable_irq( IRQ_MFP_FDC );
		local_save_flags(flags);        /* The request function is called with ints
		local_irq_disable();             * disabled... so must save the IPL for later */
		redo_fd_request();
		local_irq_restore(flags);
		atari_enable_irq( IRQ_MFP_FDC );
	}

If you look at the code long enough, you will notioce that the 
local_irq_disable() call is actually commented out. This has been 
introduced back in 2002 in [1], but as you can see, the same bug has been 
there even before, with the sti() call being commented out in the very 
same way :)

I am not familiar with the code myself at all, but I guess that the whole 
stuff can just be removed. Why do we need save_flags/restore_flags at all, 
without actually disabling the local IRQs afterwards? The 
redo_fd_request() doesn't seem to do anything that would mess with flags 
inconsistently.

But I'd rather anyone who has touched the surrounding code in past years 
Ack it. I can then take it through trivial tree or submit to akpm.

[1] http://lkml.org/lkml/2002/12/27/58

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---
 drivers/block/ataflop.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 847a9e5..a5af1d6 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -1478,10 +1478,7 @@ void do_fd_request(struct request_queue * q)
 	stdma_lock(floppy_irq, NULL);
 
 	atari_disable_irq( IRQ_MFP_FDC );
-	local_save_flags(flags);	/* The request function is called with ints
-	local_irq_disable();		 * disabled... so must save the IPL for later */ 
 	redo_fd_request();
-	local_irq_restore(flags);
 	atari_enable_irq( IRQ_MFP_FDC );
 }
 
-- 
1.5.6

