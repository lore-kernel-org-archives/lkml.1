Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbZIBOGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbZIBOGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZIBOGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:06:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:15854 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbZIBOGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 10:06:19 -0400
Content-Type: multipart/mixed; boundary="===============0056262382=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,318,1249282800"; 
   d="scan'208";a="489815599"
Message-Id: <20090902140616.901253000@intel.com>
References: <20090902140445.125358000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 02 Sep 2009 16:04:48 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zjilstra@chello.nl>,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 3/3] x86, perf_counter, bts: do not allow kernel BTS tracing.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0056262382==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.perf_counter.disable_kernel_bts.patch

Kernel BTS tracing generates too much data too fast for us to handle,
causing the kernel to hang.

Fail for BTS requests for kernel code.

CC: Peter Zijlstra <a.p.zjilstra@chello.nl>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   11 	9 +	2 -	0 !
 1 files changed, 9 insertions(+), 2 deletions(-)

Index: b/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -984,8 +984,15 @@ static int __hw_perf_counter_init(struct
 	 * Branch tracing:
 	 */
 	if ((attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
-	    (hwc->sample_period == 1) && !bts_available())
-		return -EOPNOTSUPP;
+	    (hwc->sample_period == 1)) {
+		/* BTS is not supported by this architecture. */
+		if (!bts_available())
+			return -EOPNOTSUPP;
+
+		/* BTS is currently only allowed for user-mode. */
+		if (hwc->config & ARCH_PERFMON_EVENTSEL_OS)
+			return -EOPNOTSUPP;
+	}
 
 	hwc->config |= config;
 

-- 

--===============0056262382==
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

--===============0056262382==--
