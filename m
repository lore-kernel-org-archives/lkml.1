Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYFJOIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYFJOIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbYFJOIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:08:38 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:26658 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbYFJOIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:08:37 -0400
X-BigFish: VPS2(zzzz10d3izzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K293A0-01-IWE-01
Date: Tue, 10 Jun 2008 16:07:55 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 5/5] x86: PAT: make pat_x_mtrr_type() more readable
Message-ID: <20080610140755.GI5024@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 10 Jun 2008 14:07:48.0961 (UTC) FILETIME=[5D3BF510:01C8CB03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've found it inconvenient to review pat_x_mtrr_type().
Thus I slightly changed it and added some comment to make it more
readable.
I've also added BUG statements for (some) unused/unhandled PAT/MTRR types.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/pat.c |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 2f6c33d..fc0a397 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -185,18 +185,30 @@ static int pat_x_mtrr_type(u64 start, u64 end, unsigned long prot,
 	prot &= (~_PAGE_CACHE_MASK);
 
 	/* Currently doing intersection by hand. Optimize it later. */
-	if (pat_type == _PAGE_CACHE_WC) {
+	/*    effective type		        ret_prot
+	  pat \ mtrr  WB WC UC		pat \ mtrr  WB  WC  UC
+	  WC          WC WC WC		WC          WC  WC  WC
+	  UC-         UC WC UC		UC-         UC- UC- UC-
+	  UC          UC UC UC		UC          UC  UC  UC
+	  WB          WB WC UC		WB          WB  WC  UC
+	 */
+	if (pat_type == _PAGE_CACHE_WC)
 		*ret_prot = prot | _PAGE_CACHE_WC;
-	} else if (pat_type == _PAGE_CACHE_UC_MINUS) {
+	else if (pat_type == _PAGE_CACHE_UC_MINUS)
 		*ret_prot = prot | _PAGE_CACHE_UC_MINUS;
-	} else if (pat_type == _PAGE_CACHE_UC ||
-		   mtrr_type == MTRR_TYPE_UNCACHABLE) {
+	else if (pat_type == _PAGE_CACHE_UC)
 		*ret_prot = prot | _PAGE_CACHE_UC;
-	} else if (mtrr_type == MTRR_TYPE_WRCOMB) {
-		*ret_prot = prot | _PAGE_CACHE_WC;
-	} else {
-		*ret_prot = prot | _PAGE_CACHE_WB;
-	}
+	else if (pat_type == _PAGE_CACHE_WB) {
+		if (mtrr_type == MTRR_TYPE_WRBACK)
+			*ret_prot = prot | _PAGE_CACHE_WB;
+		else if (mtrr_type == MTRR_TYPE_WRCOMB)
+			*ret_prot = prot | _PAGE_CACHE_WC;
+		else if (mtrr_type == MTRR_TYPE_UNCACHABLE)
+			*ret_prot = prot | _PAGE_CACHE_UC;
+		else
+			BUG();
+	} else
+		  BUG();
 
 	return 0;
 }
-- 
1.5.5.3



