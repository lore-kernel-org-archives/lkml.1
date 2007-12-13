Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbXLMDgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbXLMDgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 22:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbXLMDgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 22:36:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:59914 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbXLMDgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 22:36:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,160,1196668800"; 
   d="scan'208";a="435382797"
Subject: [PATCH]Avoid the overflow when calculate the proportion of bdi
	quota
From: zhejiang <zhe.jiang@intel.com>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com
Content-Type: text/plain
Date: Thu, 13 Dec 2007 11:30:32 +0800
Message-Id: <1197516632.18076.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__percpu_counter_add() cache the result in percpu variable until it
exceeds the batch.
The prop_norm_percpu() use the percpu_counter_read(&pl->events) to read
the counter ,and use percpu_counter_add(&pl->events, -half) to half the
counter.

There are potential problems:
1.The counter may be negative 
2.After some calculation, it may be converted to a big positive number.

1.
For example, the batch is 32, when the bdi add 32 to the pl->events,
the pl->events->count will be 32.Suppose one of the percpu counter is 1.

In the prop_norm_percpu(),the half will be 16.Because it is under the
batch, the pl->events->count won't be modified and one of the percpu
counter may be -15. If call the prop_norm_percpu() again, the half will
still be 16,though it should be 8.The percpu counter may be -31.
Now, there pl->events->count is still 32.
If do the third calculation, the percpu counter will be -47, it will
be merged into the pl->evnets->count.Then pl->events->count will be
negative.

2.When the pl->events->count is negative,
unsigned long val = percpu_counter_read(&pl->events);
This statement may return a negative number, so the val would be a big
number.Because of the overflow, the pl->events->count will be converted
into a big positive number after some calculation.

Because of the overflow, I catch some very big numerators when call the
prop_fraction_percpu().

I think that it should use percpu_counter_sum() instead of the
percpu_counter_read() to be more robust.

diff -Nur a/proportions.c b/proportions.c
--- a/proportions.c     2007-12-12 11:05:59.000000000 +0800
+++ b/proportions.c     2007-12-13 11:05:40.000000000 +0800
@@ -241,7 +241,7 @@
         * can never result in a negative number.
         */
        while (pl->period != global_period) {
-               unsigned long val = percpu_counter_read(&pl->events);
+               unsigned long val = percpu_counter_sum(&pl->events);
                unsigned long half = (val + 1) >> 1;
 
                /*




Here is the relative codes:

static
void prop_norm_percpu(struct prop_global *pg, struct prop_local_percpu
*pl)
{
/*
	 * For each missed period, we half the local counter.
	 * basically:
	 *   pl->events >> (global_period - pl->period);
	 *
	 * but since the distributed nature of percpu counters make division
	 * rather hard, use a regular subtraction loop. This is safe, because
	 * the events will only every be incremented, hence the subtraction
	 * can never result in a negative number.
	 */
	while (pl->period != global_period) {
		unsigned long val = percpu_counter_read(&pl->events);
		unsigned long half = (val + 1) >> 1;

		/*
		 * Half of zero won't be much less, break out.
		 * This limits the loop to shift iterations, even
		 * if we missed a million.
		 */
		if (!val)
			break;

		percpu_counter_add(&pl->events, -half);
		pl->period += period;
	}
	pl->period = global_period;
	spin_unlock_irqrestore(&pl->lock, flags);
}

void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32
batch)
{
	s64 count;
	s32 *pcount;
	int cpu = get_cpu();

	pcount = per_cpu_ptr(fbc->counters, cpu);
	count = *pcount + amount;
	if (count >= batch || count <= -batch) {
		spin_lock(&fbc->lock);
		fbc->count += count;
		*pcount = 0;
		spin_unlock(&fbc->lock);
	} else {
		*pcount = count;
	}
	put_cpu();
}
