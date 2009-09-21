Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbZIUHTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbZIUHTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZIUHTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:19:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:51793 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbZIUHTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:19:43 -0400
Date: Mon, 21 Sep 2009 07:19:09 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, sachinp@in.ibm.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       markus.t.metzger@intel.com, sachinp@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <19127.8400.376239.586120@drongo.ozlabs.ibm.com>
References: <19127.8400.376239.586120@drongo.ozlabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/urgent] perf_counter/powerpc: Fix compilation after perf_counter_overflow() change
Message-ID: <tip-a42418acb5c2872fc43e028118c275c2245b5eba@git.kernel.org>
Git-Commit-ID: a42418acb5c2872fc43e028118c275c2245b5eba
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 21 Sep 2009 07:19:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a42418acb5c2872fc43e028118c275c2245b5eba
Gitweb:     http://git.kernel.org/tip/a42418acb5c2872fc43e028118c275c2245b5eba
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 21 Sep 2009 16:44:32 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 21 Sep 2009 09:03:34 +0200

perf_counter/powerpc: Fix compilation after perf_counter_overflow() change

Commit 5622f295 ("x86, perf_counter, bts: Optimize BTS overflow
handling") removed the regs field from struct perf_sample_data and
added a regs parameter to perf_counter_overflow().  This breaks the
build on powerpc as reported by Sachin Sant:

  arch/powerpc/kernel/perf_counter.c: In function 'record_and_restart':
  arch/powerpc/kernel/perf_counter.c:1165: error: unknown field 'regs' specified in initializer

This adjusts arch/powerpc/kernel/perf_counter.c to correspond with the
new struct perf_sample_data and perf_counter_overflow().

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Markus Metzger <markus.t.metzger@intel.com>
Cc: benh@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <19127.8400.376239.586120@drongo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 7ceefaf..5ccf9bc 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -1162,7 +1162,6 @@ static void record_and_restart(struct perf_counter *counter, unsigned long val,
 	 */
 	if (record) {
 		struct perf_sample_data data = {
-			.regs	= regs,
 			.addr	= 0,
 			.period	= counter->hw.last_period,
 		};
@@ -1170,7 +1169,7 @@ static void record_and_restart(struct perf_counter *counter, unsigned long val,
 		if (counter->attr.sample_type & PERF_SAMPLE_ADDR)
 			perf_get_data_addr(regs, &data.addr);
 
-		if (perf_counter_overflow(counter, nmi, &data)) {
+		if (perf_counter_overflow(counter, nmi, &data, regs)) {
 			/*
 			 * Interrupts are coming too fast - throttle them
 			 * by setting the counter to 0, so it will be
