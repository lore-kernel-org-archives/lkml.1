Return-Path: <linux-kernel-owner+w=401wt.eu-S1764449AbYEMU1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764449AbYEMU1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932376AbYEMURK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:17:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:39001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375AbYEMURH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:17:07 -0400
Date: Tue, 13 May 2008 13:12:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>
Subject: [patch 37/37] md: fix raid5 repair operations
Message-ID: <20080513201257.GL31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-fix-raid5-repair-operations.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Dan Williams <dan.j.williams@intel.com>

commit c8894419acf5e56851de9741c5047bebd78acd1f upstream
Date: Mon, 12 May 2008 14:02:12 -0700
Subject: [patch 37/37] md: fix raid5 'repair' operations

commit bd2ab67030e9116f1e4aae1289220255412b37fd "md: close a livelock window
in handle_parity_checks5" introduced a bug in handling 'repair' operations.
After a repair operation completes we clear the state bits tracking this
operation.  However, they are cleared too early and this results in the code
deciding to re-run the parity check operation.  Since we have done the repair
in memory the second check does not find a mismatch and thus does not do a
writeback.

Test results:
$ echo repair > /sys/block/md0/md/sync_action
$ cat /sys/block/md0/md/mismatch_cnt
51072
$ echo repair > /sys/block/md0/md/sync_action
$ cat /sys/block/md0/md/mismatch_cnt
0

(also fix incorrect indentation)

Tested-by: George Spelvin <linux@horizon.com>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2354,8 +2354,8 @@ static void handle_parity_checks5(raid5_
 
 	/* complete a check operation */
 	if (test_and_clear_bit(STRIPE_OP_CHECK, &sh->ops.complete)) {
-	    clear_bit(STRIPE_OP_CHECK, &sh->ops.ack);
-	    clear_bit(STRIPE_OP_CHECK, &sh->ops.pending);
+		clear_bit(STRIPE_OP_CHECK, &sh->ops.ack);
+		clear_bit(STRIPE_OP_CHECK, &sh->ops.pending);
 		if (s->failed == 0) {
 			if (sh->ops.zero_sum_result == 0)
 				/* parity is correct (on disc,
@@ -2385,16 +2385,6 @@ static void handle_parity_checks5(raid5_
 			canceled_check = 1; /* STRIPE_INSYNC is not set */
 	}
 
-	/* check if we can clear a parity disk reconstruct */
-	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
-		test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
-
-		clear_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending);
-		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
-		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
-		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
-	}
-
 	/* start a new check operation if there are no failures, the stripe is
 	 * not insync, and a repair is not in flight
 	 */
@@ -2409,6 +2399,17 @@ static void handle_parity_checks5(raid5_
 		}
 	}
 
+	/* check if we can clear a parity disk reconstruct */
+	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
+	    test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
+
+		clear_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+	}
+
+
 	/* Wait for check parity and compute block operations to complete
 	 * before write-back.  If a failure occurred while the check operation
 	 * was in flight we need to cycle this stripe through handle_stripe

-- 
