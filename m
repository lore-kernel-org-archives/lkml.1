Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbYKGMyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbYKGMyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 07:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYKGMyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 07:54:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39235 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYKGMyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 07:54:05 -0500
Date: Fri, 7 Nov 2008 14:02:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-2.6.28-rc2 regression : oprofile doesnt work anymore ?
Message-ID: <20081107130249.GN29626@one.firstfloor.org>
References: <4909F690.9090208@cosmosbay.com> <84144f020810310721x1d1eccbeica5d10608d7b2e57@mail.gmail.com> <20081104181855.GK9785@erda.amd.com> <Pine.LNX.4.64.0811042118460.1597@melkki.cs.Helsinki.FI> <4910CD65.1010301@cosmosbay.com> <49113894.5040806@cosmosbay.com> <49130694.7000007@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49130694.7000007@cosmosbay.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Can you please test this patch and see if it solves the problem?

Thanks,
-Andi

---

oprofile: Fix p6 counter overflow check

Fix the counter overflow check for CPUs with counter width > 32

I had a similar change in a different patch that I didn't submit
and I didn't notice the problem earlier because it was always
tested together.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/oprofile/op_model_ppro.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6.28-rc3-test/arch/x86/oprofile/op_model_ppro.c
===================================================================
--- linux-2.6.28-rc3-test.orig/arch/x86/oprofile/op_model_ppro.c	2008-11-07 13:46:23.000000000 +0100
+++ linux-2.6.28-rc3-test/arch/x86/oprofile/op_model_ppro.c	2008-11-07 13:50:57.000000000 +0100
@@ -27,8 +27,7 @@
 static int counter_width = 32;
 
 #define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
-#define CTR_READ(l, h, msrs, c) do {rdmsr(msrs->counters[(c)].addr, (l), (h)); } while (0)
-#define CTR_OVERFLOWED(n) (!((n) & (1U<<(counter_width-1))))
+#define CTR_OVERFLOWED(n) (!((n) & (1ULL<<(counter_width-1))))
 
 #define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
 #define CTRL_READ(l, h, msrs, c) do {rdmsr((msrs->controls[(c)].addr), (l), (h)); } while (0)
@@ -124,14 +123,14 @@
 static int ppro_check_ctrs(struct pt_regs * const regs,
 			   struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
 
 	for (i = 0 ; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
-		CTR_READ(low, high, msrs, i);
-		if (CTR_OVERFLOWED(low)) {
+		rdmsrl(msrs->counters[i].addr, val);
+		if (CTR_OVERFLOWED(val)) {
 			oprofile_add_sample(regs, i);
 			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
 		}


-- 
ak@linux.intel.com
