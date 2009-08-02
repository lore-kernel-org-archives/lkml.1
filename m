Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbZHBIw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbZHBIw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 04:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZHBIw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 04:52:57 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:53602 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbZHBIwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 04:52:55 -0400
Date: Sun, 2 Aug 2009 10:45:18 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: fenghua.yu@intel.com, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/15] arch/ia64: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908021044540.15557@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
but is perhaps more readable.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression x,__divisor;
@@

- (((x) + ((__divisor) / 2)) / (__divisor))
+ DIV_ROUND_CLOSEST(x,__divisor)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/ia64/kernel/time.c             |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 4990495..aaa6651 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -314,7 +314,7 @@ ia64_init_itm (void)
 
 	itc_freq = (platform_base_freq*itc_ratio.num)/itc_ratio.den;
 
-	local_cpu_data->itm_delta = (itc_freq + HZ/2) / HZ;
+	local_cpu_data->itm_delta = DIV_ROUND_CLOSEST(itc_freq, HZ);
 	printk(KERN_DEBUG "CPU %d: base freq=%lu.%03luMHz, ITC ratio=%u/%u, "
 	       "ITC freq=%lu.%03luMHz", smp_processor_id(),
 	       platform_base_freq / 1000000, (platform_base_freq / 1000) % 1000,
@@ -330,9 +330,11 @@ ia64_init_itm (void)
 
 	local_cpu_data->proc_freq = (platform_base_freq*proc_ratio.num)/proc_ratio.den;
 	local_cpu_data->itc_freq = itc_freq;
-	local_cpu_data->cyc_per_usec = (itc_freq + USEC_PER_SEC/2) / USEC_PER_SEC;
-	local_cpu_data->nsec_per_cyc = ((NSEC_PER_SEC<<IA64_NSEC_PER_CYC_SHIFT)
-					+ itc_freq/2)/itc_freq;
+	local_cpu_data->cyc_per_usec =
+		DIV_ROUND_CLOSEST(itc_freq, USEC_PER_SEC);
+	local_cpu_data->nsec_per_cyc =
+		DIV_ROUND_CLOSEST(NSEC_PER_SEC << IA64_NSEC_PER_CYC_SHIFT,
+				  itc_freq);
 
 	if (!(sal_platform_features & IA64_SAL_PLATFORM_FEATURE_ITC_DRIFT)) {
 #ifdef CONFIG_SMP

