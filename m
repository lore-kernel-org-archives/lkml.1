Return-Path: <linux-kernel-owner+w=401wt.eu-S936949AbXJSTw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936949AbXJSTw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936300AbXJSTuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:50:13 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:24628 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935191AbXJSTuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:50:01 -0400
Date: Fri, 19 Oct 2007 13:18:23 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 6/8] drivers-edac-i3000 replace macros with functions
Message-ID: <471902ff.FaxIbGYEsl+dBZCd%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Uhlenkott <juhlenko@akamai.com>

Replace function-like macros with functions.

Signed-off-by: Jason Uhlenkott <juhlenko@akamai.com>
CC:     Alan Cox <alan@lxorguk.ukuu.org.uk
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---

 drivers/edac/i3000_edac.c |   50 ++++++++++++++++++++++++++++++++--------------
 1 files changed, 35 insertions(+), 15 deletions(-)

Index: edac/drivers/edac/i3000_edac.c
===================================================================
--- edac.orig/drivers/edac/i3000_edac.c	2007-09-05 18:01:44.404999805 -0700
+++ edac/drivers/edac/i3000_edac.c	2007-09-05 18:03:06.859573940 -0700
@@ -42,11 +42,23 @@
 				 * 0     Error channel 0/1
 				 */
 #define I3000_DEAP_GRAIN 		(1 << 7)
-#define I3000_DEAP_PFN(edeap, deap)	((((edeap) & 1) << (32 - PAGE_SHIFT)) \
-					| ((deap) >> PAGE_SHIFT))
-#define I3000_DEAP_OFFSET(deap)		((deap) & ~(I3000_DEAP_GRAIN-1) & \
-					~PAGE_MASK)
-#define I3000_DEAP_CHANNEL(deap)	((deap) & 1)
+
+static inline unsigned long deap_pfn(u8 edeap, u32 deap)
+{
+	deap >>= PAGE_SHIFT;
+	deap |= (edeap & 1) << (32 - PAGE_SHIFT);
+	return deap;
+}
+
+static inline unsigned long deap_offset(u32 deap)
+{
+	return deap & ~(I3000_DEAP_GRAIN - 1) & ~PAGE_MASK;
+}
+
+static inline int deap_channel(u32 deap)
+{
+	return deap & 1;
+}
 
 #define I3000_DERRSYN	0x5c	/* DRAM Error Syndrome (8b)
 				 *
@@ -116,8 +128,16 @@
 				 *     Others: reserved
 				 */
 #define I3000_C1DRA	0x188	/* Channel 1 DRAM Rank Attribute (8b x 2) */
-#define ODD_RANK_ATTRIB(dra)	(((dra) & 0x70) >> 4)
-#define EVEN_RANK_ATTRIB(dra)	((dra) & 0x07)
+
+static inline unsigned char odd_rank_attrib(unsigned char dra)
+{
+	return (dra & 0x70) >> 4;
+}
+
+static inline unsigned char even_rank_attrib(unsigned char dra)
+{
+	return dra & 0x07;
+}
 
 #define I3000_C0DRC0	0x120	/* DRAM Controller Mode 0 (32b)
 				 *
@@ -206,8 +226,8 @@
 				struct i3000_error_info *info,
 				int handle_errors)
 {
-	int row, multi_chan;
-	int pfn, offset, channel;
+	int row, multi_chan, channel;
+	unsigned long pfn, offset;
 
 	multi_chan = mci->csrows[0].nr_channels - 1;
 
@@ -222,9 +242,9 @@
 		info->errsts = info->errsts2;
 	}
 
-	pfn = I3000_DEAP_PFN(info->edeap, info->deap);
-	offset = I3000_DEAP_OFFSET(info->deap);
-	channel = I3000_DEAP_CHANNEL(info->deap);
+	pfn = deap_pfn(info->edeap, info->deap);
+	offset = deap_offset(info->deap);
+	channel = deap_channel(info->deap);
 
 	row = edac_mc_find_csrow_by_page(mci, pfn);
 
@@ -258,9 +278,9 @@
 	 * we're not interleaved.
 	 */
 	for (i = 0; i < I3000_RANKS_PER_CHANNEL / 2; i++)
-		if (ODD_RANK_ATTRIB(c0dra[i]) != ODD_RANK_ATTRIB(c1dra[i]) ||
-			EVEN_RANK_ATTRIB(c0dra[i]) !=
-						EVEN_RANK_ATTRIB(c1dra[i]))
+		if (odd_rank_attrib(c0dra[i]) != odd_rank_attrib(c1dra[i]) ||
+			even_rank_attrib(c0dra[i]) !=
+						even_rank_attrib(c1dra[i]))
 			return 0;
 
 	/*
