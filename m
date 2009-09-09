Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbZIIIE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbZIIIE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 04:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZIIIE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 04:04:58 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:57398 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZIIIE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 04:04:57 -0400
X-SourceIP: 213.93.53.227
Subject: Re: __hw_perf_counter_init() on x86
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20090908.234918.174793485.davem@davemloft.net>
References: <20090908.234918.174793485.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 10:04:47 +0200
Message-Id: <1252483487.7746.164.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 23:49 -0700, David Miller wrote:
> It seems that for most of the error returns this function
> can give, we'll leak the active_counters count grabbed
> at the beginning of the function and therefore we'll never
> re-enable the LAPIC NMI watchdog even once all the perf
> counter users go away.
> 
> Just FYI...

Thanks!

---
Subject: perf_counter: x86: Fix PMU resource leak

Dave noticed that we leak the PMU resource reservations when we fail the
hardware counter init.

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_counter.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index f9cd084..5224371 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -924,6 +924,8 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (err)
 		return err;
 
+	counter->destroy = hw_perf_counter_destroy;
+
 	/*
 	 * Generate PMC IRQs:
 	 * (keep 'enabled' bit clear for now)
@@ -953,8 +955,6 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 			return -EOPNOTSUPP;
 	}
 
-	counter->destroy = hw_perf_counter_destroy;
-
 	/*
 	 * Raw event type provide the config in the event structure
 	 */
@@ -2093,8 +2093,11 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 	int err;
 
 	err = __hw_perf_counter_init(counter);
-	if (err)
+	if (err) {
+		if (counter->destroy)
+			counter->destroy(counter);
 		return ERR_PTR(err);
+	}
 
 	return &pmu;
 }


