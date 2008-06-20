Return-Path: <linux-kernel-owner+w=401wt.eu-S933006AbYFTUoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbYFTUoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763046AbYFTUZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:25:31 -0400
Received: from mail-wa4.bigfish.com ([216.32.181.115]:3055 "EHLO
	mail212-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763026AbYFTUZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:25:29 -0400
X-BigFish: VPS3(z1033izzz10d3izzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K2S2D1-01-8HK-01
Date: Fri, 20 Jun 2008 22:03:06 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 3/7] x86: pat.c more trivial changes
Message-ID: <20080620200306.GE4105@alberich.amd.com>
References: <20080620195503.GB4105@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620195503.GB4105@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Jun 2008 20:03:08.0434 (UTC) FILETIME=[A8C2DF20:01C8D310]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 - add BUG statement to catch invalid start and end parameters
 - No need to track the actual type in both req_type and actual_type --
   keep req_type unchanged.
 - removed (IMHO) superfluous comments

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/pat.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index a6507bf..c996a36 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -200,7 +200,8 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	unsigned long actual_type;
 	int err = 0;
 
-	/* Only track when pat_enabled */
+ 	BUG_ON(start >= end); /* end is exclusive */
+
 	if (!pat_enabled) {
 		/* This is identical to page table setting without PAT */
 		if (new_type) {
@@ -228,17 +229,13 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		 */
 		u8 mtrr_type = mtrr_type_lookup(start, end);
 
-		if (mtrr_type == MTRR_TYPE_WRBACK) {
-			req_type = _PAGE_CACHE_WB;
+		if (mtrr_type == MTRR_TYPE_WRBACK)
 			actual_type = _PAGE_CACHE_WB;
-		} else {
-			req_type = _PAGE_CACHE_UC_MINUS;
+		else
 			actual_type = _PAGE_CACHE_UC_MINUS;
-		}
-	} else {
-		req_type &= _PAGE_CACHE_MASK;
-		actual_type = pat_x_mtrr_type(start, end, req_type);
-	}
+	} else
+		actual_type = pat_x_mtrr_type(start, end,
+					      req_type & _PAGE_CACHE_MASK);
 
 	new  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
 	if (!new)
@@ -406,10 +403,8 @@ int free_memtype(u64 start, u64 end)
 	struct memtype *entry;
 	int err = -EINVAL;
 
-	/* Only track when pat_enabled */
-	if (!pat_enabled) {
+	if (!pat_enabled)
 		return 0;
-	}
 
 	/* Low ISA region is always mapped WB. No need to track */
 	if (is_ISA_range(start, end - 1))
-- 
1.5.5.4



