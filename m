Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbZIBOGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbZIBOGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZIBOGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:06:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:12141 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbZIBOGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 10:06:15 -0400
Content-Type: multipart/mixed; boundary="===============1049904871=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,318,1249282800"; 
   d="scan'208";a="723218903"
Message-Id: <20090902140612.943801000@intel.com>
References: <20090902140445.125358000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 02 Sep 2009 16:04:46 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 1/3] x86, perf_counter, bts: fail if BTS is not available
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============1049904871==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.perf_counter.fail_when_not_available.patch

Reserve PERF_COUNT_HW_BRANCH_INSTRUCTIONS with sample_period == 1
for BTS tracing and fail, if BTS is not available.


CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   25 	11 +	14 -	0 !
 1 files changed, 11 insertions(+), 14 deletions(-)

Index: b/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -769,7 +769,7 @@ static int reserve_bts_hardware(void)
 	int cpu, err = 0;
 
 	if (!bts_available())
-		return -EOPNOTSUPP;
+		return 0;
 
 	get_online_cpus();
 
@@ -914,7 +914,7 @@ static int __hw_perf_counter_init(struct
 			if (!reserve_pmc_hardware())
 				err = -EBUSY;
 			else
-				reserve_bts_hardware();
+				err = reserve_bts_hardware();
 		}
 		if (!err)
 			atomic_inc(&active_counters);
@@ -979,6 +979,13 @@ static int __hw_perf_counter_init(struct
 	if (config == -1LL)
 		return -EINVAL;
 
+	/*
+	 * Branch tracing:
+	 */
+	if ((attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
+	    (hwc->sample_period == 1) && !bts_available())
+		return -EOPNOTSUPP;
+
 	hwc->config |= config;
 
 	return 0;
@@ -1355,19 +1362,9 @@ static int x86_pmu_enable(struct perf_co
 
 	idx = fixed_mode_idx(counter, hwc);
 	if (idx == X86_PMC_IDX_FIXED_BTS) {
-		/*
-		 * Try to use BTS for branch tracing. If that is not
-		 * available, try to get a generic counter.
-		 */
-		if (unlikely(!cpuc->ds))
-			goto try_generic;
-
-		/*
-		 * Try to get the fixed counter, if that is already taken
-		 * then try to get a generic counter:
-		 */
+		/* BTS is already occupied. */
 		if (test_and_set_bit(idx, cpuc->used_mask))
-			goto try_generic;
+			return -EAGAIN;
 
 		hwc->config_base	= 0;
 		hwc->counter_base	= 0;

-- 

--===============1049904871==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--===============1049904871==--
