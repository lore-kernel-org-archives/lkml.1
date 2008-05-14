Return-Path: <linux-kernel-owner+w=401wt.eu-S1763475AbYENPRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763475AbYENPRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762604AbYENPPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:15:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45848 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762593AbYENPPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:15:54 -0400
From: Paul Jackson <pj@sgi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>
Date: Wed, 14 May 2008 08:15:52 -0700
Message-Id: <20080514151552.148486.84448.sendpatchset@jackhammer.engr.sgi.com>
In-Reply-To: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH 9/10] x86 boot: longer comment explaining sanitize_e820_map routine
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Elaborate on the comment for sanitize_e820_map(), epxlaining more what
it does, what it inputs, and what it returns.  Rearrange the placement of
this comment to fit kernel conventions, before the routine's code rather
than buried inside it.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/e820_64.c |   94 +++++++++++++++++++++++++++-------------------
 1 file changed, 56 insertions(+), 38 deletions(-)

--- 2.6.26-rc2-mm1.orig/arch/x86/kernel/e820_64.c	2008-05-14 03:07:30.399683852 -0700
+++ 2.6.26-rc2-mm1/arch/x86/kernel/e820_64.c	2008-05-14 03:07:34.755755053 -0700
@@ -506,9 +506,64 @@ static void __init e820_print_map(char *
  * Sanitize the BIOS e820 map.
  *
  * Some e820 responses include overlapping entries. The following
- * replaces the original e820 map with a new one, removing overlaps.
+ * replaces the original e820 map with a new one, removing overlaps,
+ * and resolving conflicting memory types in favor of highest
+ * numbered type.
  *
+ * The input parameter biosmap points to an array of 'struct
+ * e820entry' which on entry has elements in the range [0, *pnr_map)
+ * valid, and which has space for up to max_nr_map entries.
+ * On return, the resulting sanitized e820 map entries will be in
+ * overwritten in the same location, starting at biosmap.
+ *
+ * The integer pointed to by pnr_map must be valid on entry (the
+ * current number of valid entries located at biosmap) and will
+ * be updated on return, with the new number of valid entries
+ * (something no more than max_nr_map.)
+ *
+ * The return value from sanitize_e820_map() is zero if it
+ * successfully 'sanitized' the map entries passed in, and is -1
+ * if it did nothing, which can happen if either of (1) it was
+ * only passed one map entry, or (2) any of the input map entries
+ * were invalid (start + size < start, meaning that the size was
+ * so big the described memory range wrapped around through zero.)
+ *
+ *	Visually we're performing the following
+ *	(1,2,3,4 = memory types)...
+ *
+ *	Sample memory map (w/overlaps):
+ *	   ____22__________________
+ *	   ______________________4_
+ *	   ____1111________________
+ *	   _44_____________________
+ *	   11111111________________
+ *	   ____________________33__
+ *	   ___________44___________
+ *	   __________33333_________
+ *	   ______________22________
+ *	   ___________________2222_
+ *	   _________111111111______
+ *	   _____________________11_
+ *	   _________________4______
+ *
+ *	Sanitized equivalent (no overlap):
+ *	   1_______________________
+ *	   _44_____________________
+ *	   ___1____________________
+ *	   ____22__________________
+ *	   ______11________________
+ *	   _________1______________
+ *	   __________3_____________
+ *	   ___________44___________
+ *	   _____________33_________
+ *	   _______________2________
+ *	   ________________1_______
+ *	   _________________4______
+ *	   ___________________2____
+ *	   ____________________33__
+ *	   ______________________4_
  */
+
 int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 				    int *pnr_map)
 {
@@ -529,43 +584,6 @@ int __init sanitize_e820_map(struct e820
 	int old_nr, new_nr, chg_nr;
 	int i;
 
-	/*
-		Visually we're performing the following
-		(1,2,3,4 = memory types)...
-
-		Sample memory map (w/overlaps):
-		   ____22__________________
-		   ______________________4_
-		   ____1111________________
-		   _44_____________________
-		   11111111________________
-		   ____________________33__
-		   ___________44___________
-		   __________33333_________
-		   ______________22________
-		   ___________________2222_
-		   _________111111111______
-		   _____________________11_
-		   _________________4______
-
-		Sanitized equivalent (no overlap):
-		   1_______________________
-		   _44_____________________
-		   ___1____________________
-		   ____22__________________
-		   ______11________________
-		   _________1______________
-		   __________3_____________
-		   ___________44___________
-		   _____________33_________
-		   _______________2________
-		   ________________1_______
-		   _________________4______
-		   ___________________2____
-		   ____________________33__
-		   ______________________4_
-	*/
-
 	/* if there's only one memory region, don't bother */
 	if (*pnr_map < 2)
 		return -1;

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
