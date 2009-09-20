Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbZITSHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbZITSHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbZITSHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:07:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:50118 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693AbZITSHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:07:10 -0400
Date: Sun, 20 Sep 2009 18:06:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
       davem@davemloft.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, davem@davemloft.net,
       mingo@elte.hu
In-Reply-To: <1252483487.7746.164.camel@twins>
References: <1252483487.7746.164.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/urgent] perf_counter: x86: Fix PMU resource leak
Message-ID: <tip-a1792cdacaf5180e04e07811e220c4a3b4a9c33e@git.kernel.org>
Git-Commit-ID: a1792cdacaf5180e04e07811e220c4a3b4a9c33e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 20 Sep 2009 18:06:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1792cdacaf5180e04e07811e220c4a3b4a9c33e
Gitweb:     http://git.kernel.org/tip/a1792cdacaf5180e04e07811e220c4a3b4a9c33e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 9 Sep 2009 10:04:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Sep 2009 19:53:57 +0200

perf_counter: x86: Fix PMU resource leak

Dave noticed that we leak the PMU resource reservations when we
fail the hardware counter init.

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: David Miller <davem@davemloft.net>
LKML-Reference: <1252483487.7746.164.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index dbdf712..a6c8b27 100644
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
@@ -2107,8 +2107,11 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
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
