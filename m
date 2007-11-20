Return-Path: <linux-kernel-owner+w=401wt.eu-S1762043AbXKTS1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762043AbXKTS1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760943AbXKTS0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:26:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60150 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169AbXKTS0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:26:03 -0500
Date: Tue, 20 Nov 2007 10:23:21 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, joel.bertrand@systella.fr, neilb@suse.de,
       dan.j.williams@intel.com
Subject: [patch 06/29] raid5: fix unending write sequence
Message-ID: <20071120182321.GG28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="raid5-fix-unending-write-sequence.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Dan Williams <dan.j.williams@intel.com>

patch 6c55be8b962f1bdc592d579e81fc27b11ea53dfc in mainline.

<debug output from Joel's system>
handling stripe 7629696, state=0x14 cnt=1, pd_idx=2 ops=0:0:0
check 5: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800ffcffcc0 written 0000000000000000
check 4: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800fdd4e360 written 0000000000000000
check 3: state 0x1 toread 0000000000000000 read 0000000000000000 write 0000000000000000 written 0000000000000000
check 2: state 0x1 toread 0000000000000000 read 0000000000000000 write 0000000000000000 written 0000000000000000
check 1: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800ff517e40 written 0000000000000000
check 0: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800fd4cae60 written 0000000000000000
locked=4 uptodate=2 to_read=0 to_write=4 failed=0 failed_num=0
for sector 7629696, rmw=0 rcw=0
</debug>

These blocks were prepared to be written out, but were never handled in
ops_run_biodrain(), so they remain locked forever.  The operations flags
are all clear which means handle_stripe() thinks nothing else needs to be
done.

This state suggests that the STRIPE_OP_PREXOR bit was sampled 'set' when it
should not have been.  This patch cleans up cases where the code looks at
sh->ops.pending when it should be looking at the consistent stack-based
snapshot of the operations flags.

Report from Joel:
	Resync done. Patch fix this bug.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Joel Bertrand <joel.bertrand@systella.fr>
Cc: <stable@kernel.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -689,7 +689,8 @@ ops_run_prexor(struct stripe_head *sh, s
 }
 
 static struct dma_async_tx_descriptor *
-ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
+		 unsigned long pending)
 {
 	int disks = sh->disks;
 	int pd_idx = sh->pd_idx, i;
@@ -697,7 +698,7 @@ ops_run_biodrain(struct stripe_head *sh,
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (Wantprexor)
 	 */
-	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
@@ -774,7 +775,8 @@ static void ops_complete_write(void *str
 }
 
 static void
-ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
+		unsigned long pending)
 {
 	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
@@ -782,7 +784,7 @@ ops_run_postxor(struct stripe_head *sh, 
 
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
-	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
 	unsigned long flags;
 	dma_async_tx_callback callback;
 
@@ -809,7 +811,7 @@ ops_run_postxor(struct stripe_head *sh, 
 	}
 
 	/* check whether this postxor is part of a write */
-	callback = test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending) ?
+	callback = test_bit(STRIPE_OP_BIODRAIN, &pending) ?
 		ops_complete_write : ops_complete_postxor;
 
 	/* 1/ if we prexor'd then the dest is reused as a source
@@ -897,12 +899,12 @@ static void raid5_run_ops(struct stripe_
 		tx = ops_run_prexor(sh, tx);
 
 	if (test_bit(STRIPE_OP_BIODRAIN, &pending)) {
-		tx = ops_run_biodrain(sh, tx);
+		tx = ops_run_biodrain(sh, tx, pending);
 		overlap_clear++;
 	}
 
 	if (test_bit(STRIPE_OP_POSTXOR, &pending))
-		ops_run_postxor(sh, tx);
+		ops_run_postxor(sh, tx, pending);
 
 	if (test_bit(STRIPE_OP_CHECK, &pending))
 		ops_run_check(sh);

-- 
