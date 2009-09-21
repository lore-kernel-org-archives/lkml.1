Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZIUGoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZIUGoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 02:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZIUGop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 02:44:45 -0400
Received: from ozlabs.org ([203.10.76.45]:47366 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbZIUGoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 02:44:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19127.8400.376239.586120@drongo.ozlabs.ibm.com>
Date: Mon, 21 Sep 2009 16:44:32 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, Sachin Sant <sachinp@in.ibm.com>,
       Markus Metzger <markus.t.metzger@intel.com>, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH] perf_counter/powerpc: Fix compilation after
   perf_counter_overflow change
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5622f295 ("x86, perf_counter, bts: Optimize BTS overflow
handling") removed the regs field from struct perf_sample_data and
added a regs parameter to perf_counter_overflow().  This breaks the
build on powerpc as reported by Sachin Sant:

arch/powerpc/kernel/perf_counter.c: In function 'record_and_restart':
arch/powerpc/kernel/perf_counter.c:1165: error: unknown field 'regs' specified in initializer
cc1: warnings being treated as errors
arch/powerpc/kernel/perf_counter.c:1165: error: initialization makes integer from pointer without a cast
arch/powerpc/kernel/perf_counter.c:1173: error: too few arguments to function 'perf_counter_overflow'
make[1]: *** [arch/powerpc/kernel/perf_counter.o] Error 1
make: *** [arch/powerpc/kernel] Error 2

This adjusts arch/powerpc/kernel/perf_counter.c to correspond with the
new struct perf_sample_data and perf_counter_overflow().

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
---
I missed this problem when the "x86, perf_counter, bts: Optimize BTS
overflow handling" patch was posted because the headline made it seem
entirely x86-specific, and the changes to struct perf_sample_data and
perf_counter_overflow() were not mentioned in the changelog.

Markus, please take care in future to mention it in the changelog if
your patches touch definitions used by other architectures.  If you
could go so far as to use grep a bit more and fix up other
architectures' callsites for the things you're changing, that would be
very much appreciated.  Thanks.

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
