Return-Path: <linux-kernel-owner+w=401wt.eu-S1763335AbZJOXRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763335AbZJOXRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 19:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763304AbZJOXRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 19:17:24 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:43522 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763300AbZJOXRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 19:17:23 -0400
Date: Thu, 15 Oct 2009 17:16:45 -0600
From: dougthompson@xmission.com
To: kmannth@us.ibm.com, iws@ovro.caltech.edu, jroberson@jroberson.net,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 1/3] edac: i5100 fix initialization code
Message-ID: <4ad7ad5d.115Y8SyVFKWEfV/O%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  Keith Mannthey <kmannth@us.ibm.com>

Allow csrows to properly initialize when the topology only has active
channels on 2 and 3.  This new check allows proper detection and
initialization in this topology.  Only checking the first mrt that
represented channels 0 and 1 is not sufficient. 

I also fixed up the related debug information path. I can submit as a
2nd patch if needed. 


Signed-off-by:  Keith Mannthey <kmannth@us.ibm.com>
Acked-by: Aristeu Rozanski <aris@ruivo.org>
Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
---
 i5000_edac.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.31/drivers/edac/i5000_edac.c
===================================================================
--- linux-2.6.31.orig/drivers/edac/i5000_edac.c
+++ linux-2.6.31/drivers/edac/i5000_edac.c
@@ -1173,7 +1173,7 @@ static void i5000_get_mc_regs(struct mem
 			pci_read_config_word(pvt->branch_1, where,
 					&pvt->b1_mtr[slot_row]);
 			debugf2("MTR%d where=0x%x B1 value=0x%x\n", slot_row,
-				where, pvt->b0_mtr[slot_row]);
+				where, pvt->b1_mtr[slot_row]);
 		} else {
 			pvt->b1_mtr[slot_row] = 0;
 		}
@@ -1232,7 +1232,7 @@ static int i5000_init_csrows(struct mem_
 	struct csrow_info *p_csrow;
 	int empty, channel_count;
 	int max_csrows;
-	int mtr;
+	int mtr, mtr1;
 	int csrow_megs;
 	int channel;
 	int csrow;
@@ -1251,9 +1251,10 @@ static int i5000_init_csrows(struct mem_
 
 		/* use branch 0 for the basis */
 		mtr = pvt->b0_mtr[csrow >> 1];
+		mtr1 = pvt->b1_mtr[csrow >> 1];
 
 		/* if no DIMMS on this row, continue */
-		if (!MTR_DIMMS_PRESENT(mtr))
+		if (!MTR_DIMMS_PRESENT(mtr) && !MTR_DIMMS_PRESENT(mtr1))
 			continue;
 
 		/* FAKE OUT VALUES, FIXME */
