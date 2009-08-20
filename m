Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZHTNmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZHTNmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbZHTNmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:42:17 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:5577 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754560AbZHTNmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:42:14 -0400
X-SpamScore: 16
X-BigFish: VPS16(z1857r34a4j8deizzz1202hzzz32i6bh203h43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KOOGN3-01-173-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:40:13 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 9/15] sched: Check sched_mn_power_savings when setting
	flags for CPU and MN domains
Message-ID: <20090820134013.GX29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090820131243.GO29327@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:40:14.0438 (UTC) FILETIME=[BF2AC860:01CA219B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use new function sd_balance_for_mn_power() and adapt
sd_balance_for_package_power() and sd_power_saving_flags() for correct
setting of flags SD_POWERSAVINGS_BALANCE and SD_BALANCE_NEWIDLE in CPU
and MN domains.

Furthermore add flag SD_SHARE_PKG_RESOURCES to MN domain.
Rational: a multi-node processor most likely shares package resources
(on Magny-Cours the package constitues a "voltage domain").

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/topology.h |    3 ++-
 include/linux/sched.h           |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 6d7d133..4a520b8 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -198,7 +198,8 @@ static inline void setup_node_to_cpumask_map(void) { }
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_BALANCE	\
-				| sd_balance_for_package_power()\
+				| SD_SHARE_PKG_RESOURCES\
+				| sd_balance_for_mn_power()\
 				| sd_power_saving_flags(),\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5755643..c53bdd8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -844,9 +844,18 @@ static inline int sd_balance_for_mc_power(void)
 	return 0;
 }
 
+static inline int sd_balance_for_mn_power(void)
+{
+	if (sched_mc_power_savings || sched_smt_power_savings)
+		return SD_POWERSAVINGS_BALANCE;
+
+	return 0;
+}
+
 static inline int sd_balance_for_package_power(void)
 {
-	if (sched_mc_power_savings | sched_smt_power_savings)
+	if (sched_mn_power_savings || sched_mc_power_savings ||
+	    sched_smt_power_savings)
 		return SD_POWERSAVINGS_BALANCE;
 
 	return 0;
@@ -860,7 +869,8 @@ static inline int sd_balance_for_package_power(void)
 
 static inline int sd_power_saving_flags(void)
 {
-	if (sched_mc_power_savings | sched_smt_power_savings)
+	if (sched_mn_power_savings || sched_mc_power_savings ||
+	    sched_smt_power_savings)
 		return SD_BALANCE_NEWIDLE;
 
 	return 0;
-- 
1.6.0.4



