Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbYFPM6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbYFPM6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYFPM6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:58:36 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:51867 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYFPM6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:58:35 -0400
X-BigFish: VPS-1(zz3117Kzz10d3izzz32i6bh65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K2K417-02-W7S-01
Date: Mon, 16 Jun 2008 14:58:21 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 5/5 v2] x86: PAT: make pat_x_mtrr_type() more readable
Message-ID: <20080616125821.GA5213@alberich.amd.com>
References: <20080610140755.GI5024@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080610140755.GI5024@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Jun 2008 12:58:22.0912 (UTC) FILETIME=[A88DD400:01C8CFB0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've found it inconvenient to review pat_x_mtrr_type().
Thus I slightly changed it and added some comment to make
it more readable.

I've also added BUG statements for (some) unused/unhandled PAT/MTRR
types.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
New patch version. (against current tip/x86/pat - v2.6.26-rc6-105-gfaeca31)
Previous version had some conflict with another commit in tip/master.

Regards,
Andreas

 arch/x86/mm/pat.c |   50 +++++++++++++++++++++++++++-----------------------
 1 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 4beccea..cdf2c15 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -169,35 +169,39 @@ static int pat_x_mtrr_type(u64 start, u64 end, unsigned long prot,
 	prot &= (~_PAGE_CACHE_MASK);
 
 	/*
-	 * We return the PAT request directly for types where PAT takes
-	 * precedence with respect to MTRR and for UC_MINUS.
+	 * We return the PAT request directly for types where PAT
+	 * takes precedence with respect to MTRR and for UC_MINUS. In
+	 * case of pat_type==WB we have to know mtrr_type to get the
+	 * effective type.
+	 *
+	 *    effective type                ret_prot
+	 *  pat \ mtrr  WB WC UC    pat \ mtrr  WB  WC  UC
+	 *  WC          WC WC WC    WC          WC  WC  WC
+	 *  UC-         UC WC UC    UC-         UC- UC- UC-
+	 *  UC          UC UC UC    UC          UC  UC  UC
+	 *  WB          WB WC UC    WB          WB  WC  UC
+	 *
 	 * Consistency checks with other PAT requests is done later
 	 * while going through memtype list.
 	 */
-	if (pat_type == _PAGE_CACHE_WC) {
+	if (pat_type == _PAGE_CACHE_WC)
 		*ret_prot = prot | _PAGE_CACHE_WC;
-		return 0;
-	} else if (pat_type == _PAGE_CACHE_UC_MINUS) {
+	else if (pat_type == _PAGE_CACHE_UC_MINUS)
 		*ret_prot = prot | _PAGE_CACHE_UC_MINUS;
-		return 0;
-	} else if (pat_type == _PAGE_CACHE_UC) {
-		*ret_prot = prot | _PAGE_CACHE_UC;
-		return 0;
-	}
-
-	/*
-	 * Look for MTRR hint to get the effective type in case where PAT
-	 * request is for WB.
-	 */
-	mtrr_type = mtrr_type_lookup(start, end);
-
-	if (mtrr_type == MTRR_TYPE_UNCACHABLE) {
+	else if (pat_type == _PAGE_CACHE_UC)
 		*ret_prot = prot | _PAGE_CACHE_UC;
-	} else if (mtrr_type == MTRR_TYPE_WRCOMB) {
-		*ret_prot = prot | _PAGE_CACHE_WC;
-	} else {
-		*ret_prot = prot | _PAGE_CACHE_WB;
-	}
+	else if (pat_type == _PAGE_CACHE_WB) {
+		mtrr_type = mtrr_type_lookup(start, end);
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
1.5.5.4




