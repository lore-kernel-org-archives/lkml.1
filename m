Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbZEVU23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbZEVU23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbZEVU2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:28:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:30158 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756973AbZEVU2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:28:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,235,1241420400"; 
   d="scan'208";a="692861711"
Message-Id: <20090522202505.440854000@intel.com>
References: <20090522202336.942728000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 22 May 2009 13:23:38 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       shaohua.li@intel.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 2/2] x86: cpa_flush_array wbinvd should be done on all CPUs
Content-Disposition: inline; filename=0002--cpa_flush_array-wbinvd-should-be-done-on-all-CPUs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpa_flush_array seems to prefer wbinvd() over clflush at 4M threshold.
clflush needs to be done on only one CPU as per instruction definition.
wbinvd() however, should be done on all CPUs.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pageattr.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 2cc019a..0f9052b 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -204,6 +204,11 @@ static void cpa_flush_range(unsigned long start, int numpages, int cache)
 	}
 }
 
+static void wbinvd_local(void *unused)
+{
+	wbinvd();
+}
+
 static void cpa_flush_array(unsigned long *start, int numpages, int cache,
 			    int in_flags, struct page **pages)
 {
@@ -219,7 +224,8 @@ static void cpa_flush_array(unsigned long *start, int numpages, int cache,
 	/* 4M threshold */
 	if (numpages >= 1024) {
 		if (boot_cpu_data.x86 >= 4)
-			wbinvd();
+			on_each_cpu(wbinvd_local, NULL, 1);
+
 		return;
 	}
 	/*
-- 
1.6.0.6

-- 

