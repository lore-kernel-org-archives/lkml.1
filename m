Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbZCCUp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbZCCUp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbZCCUpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:45:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46699 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZCCUpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:45:17 -0500
Date: Tue, 3 Mar 2009 21:45:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Robert Richter <robert.richter@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>, Tim Blechmann <tim@klingt.org>
Subject: Re: [Bug #12395] 2.6.28-rc9: oprofile regression
Message-ID: <20090303204504.GA20038@elte.hu>
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera> <LLno3yT_fnC.A.Lh.4zzoJB@chimera> <20090303113218.GE10085@erda.amd.com> <200903032055.23969.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903032055.23969.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Tuesday 03 March 2009, Robert Richter wrote:
> > Fix upstream in tip/x86/urgent:
> > 
> > 780eef9492b16a1543a3b2ae9f9526a735fc9856
> 
> URL, please?

The fix is not yet in Linus's tree - the commit is below.

	Ingo

------------>
>From 780eef9492b16a1543a3b2ae9f9526a735fc9856 Mon Sep 17 00:00:00 2001
From: Tim Blechmann <tim@klingt.org>
Date: Thu, 19 Feb 2009 17:34:03 +0100
Subject: [PATCH] x86: oprofile: don't set counter width from cpuid on Core2

Impact: fix stuck NMIs and non-working oprofile on certain CPUs

Resetting the counter width of the performance counters on Intel's
Core2 CPUs, breaks the delivery of NMIs, when running in x86_64 mode.

This should fix bug #12395:

  http://bugzilla.kernel.org/show_bug.cgi?id=12395

Signed-off-by: Tim Blechmann <tim@klingt.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <20090303100412.GC10085@erda.amd.com>
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/oprofile/op_model_ppro.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index e9f80c7..10131fb 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -78,8 +78,18 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
 	if (cpu_has_arch_perfmon) {
 		union cpuid10_eax eax;
 		eax.full = cpuid_eax(0xa);
-		if (counter_width < eax.split.bit_width)
-			counter_width = eax.split.bit_width;
+
+		/*
+		 * For Core2 (family 6, model 15), don't reset the
+		 * counter width:
+		 */
+		if (!(eax.split.version_id == 0 &&
+			current_cpu_data.x86 == 6 &&
+				current_cpu_data.x86_model == 15)) {
+
+			if (counter_width < eax.split.bit_width)
+				counter_width = eax.split.bit_width;
+		}
 	}
 
 	/* clear all counters */
