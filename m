Return-Path: <linux-kernel-owner+w=401wt.eu-S933288AbXKOG7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288AbXKOG7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932443AbXKOGrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:47:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58001 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762378AbXKOGrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:47:22 -0500
Date: Wed, 14 Nov 2007 22:44:51 -0800
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
Subject: [patch 18/40] md: raid5: fix clearing of biofill operations
Message-ID: <20071115064451.GS19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-raid5-not-raid6-fix-clearing-of-biofill-operations.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

raid5: fix clearing of biofill operations

This is the correct merge of the two upstream patches for this issue (it
was mis-merged...)

ops_complete_biofill() runs outside of spin_lock(&sh->lock) and clears the
'pending' and 'ack' bits.  Since the test_and_ack_op() macro only checks
against 'complete' it can get an inconsistent snapshot of pending work.

Move the clearing of these bits to handle_stripe5(), under the lock.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Joel Bertrand <joel.bertrand@systella.fr>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -377,7 +377,12 @@ static unsigned long get_stripe_work(str
 		ack++;
 
 	sh->ops.count -= ack;
-	BUG_ON(sh->ops.count < 0);
+	if (unlikely(sh->ops.count < 0)) {
+		printk(KERN_ERR "pending: %#lx ops.pending: %#lx ops.ack: %#lx "
+			"ops.complete: %#lx\n", pending, sh->ops.pending,
+			sh->ops.ack, sh->ops.complete);
+		BUG();
+	}
 
 	return pending;
 }
@@ -551,8 +556,7 @@ static void ops_complete_biofill(void *s
 			}
 		}
 	}
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+	set_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
 
 	return_io(return_bi);
 
@@ -2630,6 +2634,13 @@ static void handle_stripe5(struct stripe
 	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
+	/* clean-up completed biofill operations */
+	if (test_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
+	}
+
 	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;

-- 
