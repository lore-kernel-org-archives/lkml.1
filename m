Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbZFZLK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbZFZLK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 07:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZFZLKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 07:10:18 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:64284 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbZFZLKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 07:10:17 -0400
X-SourceIP: 213.93.53.227
Subject: [RFC][PATCH] perf_counter: Complete counter swap.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: <tip-bfbd3381e63aa2a14c6706afb50ce4630aa0d9a2@git.kernel.org>
References: <new-submission>
	 <tip-bfbd3381e63aa2a14c6706afb50ce4630aa0d9a2@git.kernel.org>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 13:10:23 +0200
Message-Id: <1246014623.31755.195.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 19:43 +0000, tip-bot for Peter Zijlstra wrote:

> +static void __perf_counter_sync_stat(struct perf_counter *counter,
> +				     struct perf_counter *next_counter)
> +{
> +	u64 value;
> +
> +	if (!counter->attr.inherit_stat)
> +		return;
> +
> +	/*
> +	 * Update the counter value, we cannot use perf_counter_read()
> +	 * because we're in the middle of a context switch and have IRQs
> +	 * disabled, which upsets smp_call_function_single(), however
> +	 * we know the counter must be on the current CPU, therefore we
> +	 * don't need to use it.
> +	 */
> +	switch (counter->state) {
> +	case PERF_COUNTER_STATE_ACTIVE:
> +		__perf_counter_read(counter);
> +		break;
> +
> +	case PERF_COUNTER_STATE_INACTIVE:
> +		update_counter_times(counter);
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	/*
> +	 * In order to keep per-task stats reliable we need to flip the counter
> +	 * values when we flip the contexts.
> +	 */
> +	value = atomic64_read(&next_counter->count);
> +	value = atomic64_xchg(&counter->count, value);
> +	atomic64_set(&next_counter->count, value);
> +
> +	/*
> +	 * XXX also sync time_enabled and time_running ?
> +	 */
> +}

Right, so I convinced myself we indeed want to swap the times as well,
and realized we need to update the userpage after modifying these
counters.

Then again, since inherited counters tend to wander around
self-monitoring mmap() + inherit is bound to be broken.. hmm?

Do we want to fix that or shall we simply say: don't do that then!

Paul?

---
Subject: perf_counter: Complete counter swap.

Complete the counter swap by indeed switching the times too and
updateing the userpage after modifying the counter values.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f2f2326..66ab1e9 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1048,9 +1048,14 @@ static void __perf_counter_sync_stat(struct perf_counter *counter,
 	value = atomic64_xchg(&counter->count, value);
 	atomic64_set(&next_counter->count, value);
 
+	swap(counter->total_time_enabled, next_counter->total_time_enabled);
+	swap(counter->total_time_running, next_counter->total_time_running);
+
 	/*
-	 * XXX also sync time_enabled and time_running ?
+	 * Since we swizzled the values, update the user visible data too.
 	 */
+	perf_counter_update_userpage(counter);
+	perf_counter_update_userpage(next_counter);
 }
 
 #define list_next_entry(pos, member) \


