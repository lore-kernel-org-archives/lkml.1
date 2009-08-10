Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZHJWFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZHJWFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 18:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZHJWFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 18:05:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:43378 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbZHJWFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 18:05:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,355,1246863600"; 
   d="scan'208";a="482388326"
Date: Mon, 10 Aug 2009 15:05:04 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Nils Carlson <nils.carlson@ericsson.com>,
       David Brownell <david-b@pacbell.net>
Subject: [PATCH] hpet: hpet driver periodic timer setup bug fixes
Message-ID: <20090810220503.GA29239@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nils Carlson <nils.carlson@ericsson.com>

The periodic interrupt from drivers/char/hpet.c does not work correctly,
both when using the periodic capability of the hardware and while
emulating the periodic interrupt (when hardware does not support
periodic mode).

With timers capable of periodic interrupts, the comparator field is first
set with the period value followed by set of hidden accumulator,
which has the side effect of overwriting the comparator value. This
results in wrong periodicity for the interrupts. For,
periodic interrupts to work, following steps are necessary, in that order.
* Set config with Tn_VAL_SET_CNF bit
* Write to hidden accumulator, the value written is the time when the
  first interrupt should be generated
* Write compartor with period interval for subsequent interrupts
(http://www.intel.com/hardwaredesign/hpetspec_1.pdf )

When emulating periodic timer with timers not capable of periodic
interrupt, driver is adding the period to counter value instead of
comparator value, which causes slow drift when using this emulation.

Also, driver seems to add hpetp->hp_delta both while setting up
periodic interrupt and while emulating periodic interrupts with timers
not capable of doing periodic interrupts. This hp_delta will result in
slower than expected interrupt rate and should not be used while setting
the interval.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Nils Carlson <nils.carlson@ericsson.com>
---
 drivers/char/hpet.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 4a9f349..70a770a 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -166,9 +166,8 @@ static irqreturn_t hpet_interrupt(int irq, void *data)
 		unsigned long m, t;
 
 		t = devp->hd_ireqfreq;
-		m = read_counter(&devp->hd_hpet->hpet_mc);
-		write_counter(t + m + devp->hd_hpets->hp_delta,
-			      &devp->hd_timer->hpet_compare);
+		m = read_counter(&devp->hd_timer->hpet_compare);
+		write_counter(t + m, &devp->hd_timer->hpet_compare);
 	}
 
 	if (devp->hd_flags & HPET_SHARED_IRQ)
@@ -504,21 +503,25 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
 	g = v | Tn_32MODE_CNF_MASK | Tn_INT_ENB_CNF_MASK;
 
 	if (devp->hd_flags & HPET_PERIODIC) {
-		write_counter(t, &timer->hpet_compare);
 		g |= Tn_TYPE_CNF_MASK;
-		v |= Tn_TYPE_CNF_MASK;
-		writeq(v, &timer->hpet_config);
-		v |= Tn_VAL_SET_CNF_MASK;
+		v |= Tn_TYPE_CNF_MASK | Tn_VAL_SET_CNF_MASK;
 		writeq(v, &timer->hpet_config);
 		local_irq_save(flags);
 
-		/* NOTE:  what we modify here is a hidden accumulator
+		/*
+		 * NOTE: First we modify the hidden accumulator
 		 * register supported by periodic-capable comparators.
 		 * We never want to modify the (single) counter; that
-		 * would affect all the comparators.
+		 * would affect all the comparators. The value written
+		 * is the counter value when the first interrupt is due.
 		 */
 		m = read_counter(&hpet->hpet_mc);
 		write_counter(t + m + hpetp->hp_delta, &timer->hpet_compare);
+		/*
+		 * Then we modify the comparator, indicating the period
+		 * for subsequent interrupt.
+		 */
+		write_counter(t, &timer->hpet_compare);
 	} else {
 		local_irq_save(flags);
 		m = read_counter(&hpet->hpet_mc);
-- 
1.6.0.6

