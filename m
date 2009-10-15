Return-Path: <linux-kernel-owner+w=401wt.eu-S1763322AbZJOXR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763322AbZJOXR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 19:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763303AbZJOXRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 19:17:25 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:43519 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763302AbZJOXRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 19:17:23 -0400
Date: Thu, 15 Oct 2009 17:16:45 -0600
From: dougthompson@xmission.com
To: kmannth@us.ibm.com, iws@ovro.caltech.edu, jroberson@jroberson.net,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 1/1] edac: i5400 fix csrow mapping
Message-ID: <4ad7ad5d.6N/npXDMRTBUpdp5%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Roberson <jroberson@jroberson.net>

The i5400 EDAC driver has several bugs with chip-select row computation which most likely lead to bugs 
in detailed error reporting.  Attempts to contact the authors have gone mostly unanswered so I am 
presenting my diff here.  I do not subscribe to lkml and would appreciate being kept in the cc.

The most egregious problem was miscalculating the addresses of MTR registers after register 0 by assuming 
they are 32bit rather than 16. This caused the driver to miss half of the memories.  Most motherboards 
tend to have only 8 dimm slots and not 16, so this may not have been noticed before.

Further, the row calculations multiplied the number of dimms several times, ultimately ending up with a 
maximum row of 32.  The chipset only supports 4 dimms in each of 4 channels, so csrow could not be higher 
than 4 unless you use a row per-rank with dual-rank dimms.  I opted to eliminate this behavior as it is 
confusing to the user and the error reporting works by slot and not rank.  This gives a much clearer view 
of memory by slot and channel in /sys.

Signed-off-by: Jeff Roberson <jroberson@jroberson.net>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---

 i5400_edac.c |   87 ++++++++++++++++++-----------------------------------------
 1 file changed, 27 insertions(+), 60 deletions(-)
Index: linux-2.6.31/drivers/edac/i5400_edac.c
===================================================================
--- linux-2.6.31.orig/drivers/edac/i5400_edac.c
+++ linux-2.6.31/drivers/edac/i5400_edac.c
@@ -46,9 +46,10 @@
 /* Limits for i5400 */
 #define NUM_MTRS_PER_BRANCH	4
 #define CHANNELS_PER_BRANCH	2
+#define MAX_DIMMS_PER_CHANNEL	NUM_MTRS_PER_BRANCH
 #define	MAX_CHANNELS		4
-#define MAX_DIMMS		(MAX_CHANNELS * 4)	/* Up to 4 DIMM's per channel */
-#define MAX_CSROWS		(MAX_DIMMS * 2)		/* max possible csrows per channel */
+/* max possible csrows per channel */
+#define MAX_CSROWS		(MAX_DIMMS_PER_CHANNEL)
 
 /* Device 16,
  * Function 0: System Address
@@ -331,7 +332,6 @@ static const struct i5400_dev_info i5400
 
 struct i5400_dimm_info {
 	int megabytes;		/* size, 0 means not present  */
-	int dual_rank;
 };
 
 /* driver private data structure */
@@ -849,11 +849,9 @@ static int determine_mtr(struct i5400_pv
 	int n;
 
 	/* There is one MTR for each slot pair of FB-DIMMs,
-	   Each slot may have one or two ranks (2 csrows),
 	   Each slot pair may be at branch 0 or branch 1.
-	   So, csrow should be divided by eight
 	 */
-	n = csrow >> 3;
+	n = csrow;
 
 	if (n >= NUM_MTRS_PER_BRANCH) {
 		debugf0("ERROR: trying to access an invalid csrow: %d\n",
@@ -905,25 +903,22 @@ static void handle_channel(struct i5400_
 		amb_present_reg = determine_amb_present_reg(pvt, channel);
 
 		/* Determine if there is a DIMM present in this DIMM slot */
-		if (amb_present_reg & (1 << (csrow >> 1))) {
-			dinfo->dual_rank = MTR_DIMM_RANK(mtr);
+		if (amb_present_reg & (1 << csrow)) {
+			/* Start with the number of bits for a Bank
+			 * on the DRAM */
+			addrBits = MTR_DRAM_BANKS_ADDR_BITS(mtr);
+			/* Add thenumber of ROW bits */
+			addrBits += MTR_DIMM_ROWS_ADDR_BITS(mtr);
+			/* add the number of COLUMN bits */
+			addrBits += MTR_DIMM_COLS_ADDR_BITS(mtr);
+			/* add the number of RANK bits */
+			addrBits += MTR_DIMM_RANK(mtr);
+
+			addrBits += 6;	/* add 64 bits per DIMM */
+			addrBits -= 20;	/* divide by 2^^20 */
+			addrBits -= 3;	/* 8 bits per bytes */
 
-			if (!((dinfo->dual_rank == 0) &&
-				((csrow & 0x1) == 0x1))) {
-				/* Start with the number of bits for a Bank
-				 * on the DRAM */
-				addrBits = MTR_DRAM_BANKS_ADDR_BITS(mtr);
-				/* Add thenumber of ROW bits */
-				addrBits += MTR_DIMM_ROWS_ADDR_BITS(mtr);
-				/* add the number of COLUMN bits */
-				addrBits += MTR_DIMM_COLS_ADDR_BITS(mtr);
-
-				addrBits += 6;	/* add 64 bits per DIMM */
-				addrBits -= 20;	/* divide by 2^^20 */
-				addrBits -= 3;	/* 8 bits per bytes */
-
-				dinfo->megabytes = 1 << addrBits;
-			}
+			dinfo->megabytes = 1 << addrBits;
 		}
 	}
 }
@@ -951,12 +946,12 @@ static void calculate_dimm_size(struct i
 		return;
 	}
 
-	/* Scan all the actual CSROWS (which is # of DIMMS * 2)
+	/* Scan all the actual CSROWS
 	 * and calculate the information for each DIMM
 	 * Start with the highest csrow first, to display it first
 	 * and work toward the 0th csrow
 	 */
-	max_csrows = pvt->maxdimmperch * 2;
+	max_csrows = pvt->maxdimmperch;
 	for (csrow = max_csrows - 1; csrow >= 0; csrow--) {
 
 		/* on an odd csrow, first output a 'boundary' marker,
@@ -1064,7 +1059,7 @@ static void i5400_get_mc_regs(struct mem
 
 	/* Get the set of MTR[0-3] regs by each branch */
 	for (slot_row = 0; slot_row < NUM_MTRS_PER_BRANCH; slot_row++) {
-		int where = MTR0 + (slot_row * sizeof(u32));
+		int where = MTR0 + (slot_row * sizeof(u16));
 
 		/* Branch 0 set of MTR registers */
 		pci_read_config_word(pvt->branch_0, where,
@@ -1146,7 +1141,7 @@ static int i5400_init_csrows(struct mem_
 	pvt = mci->pvt_info;
 
 	channel_count = pvt->maxch;
-	max_csrows = pvt->maxdimmperch * 2;
+	max_csrows = pvt->maxdimmperch;
 
 	empty = 1;		/* Assume NO memory */
 
@@ -1215,28 +1210,6 @@ static void i5400_enable_error_reporting
 }
 
 /*
- * i5400_get_dimm_and_channel_counts(pdev, &num_csrows, &num_channels)
- *
- *	ask the device how many channels are present and how many CSROWS
- *	 as well
- */
-static void i5400_get_dimm_and_channel_counts(struct pci_dev *pdev,
-					int *num_dimms_per_channel,
-					int *num_channels)
-{
-	u8 value;
-
-	/* Need to retrieve just how many channels and dimms per channel are
-	 * supported on this memory controller
-	 */
-	pci_read_config_byte(pdev, MAXDIMMPERCH, &value);
-	*num_dimms_per_channel = (int)value * 2;
-
-	pci_read_config_byte(pdev, MAXCH, &value);
-	*num_channels = (int)value;
-}
-
-/*
  *	i5400_probe1	Probe for ONE instance of device to see if it is
  *			present.
  *	return:
@@ -1263,22 +1236,16 @@ static int i5400_probe1(struct pci_dev *
 	if (PCI_FUNC(pdev->devfn) != 0)
 		return -ENODEV;
 
-	/* Ask the devices for the number of CSROWS and CHANNELS so
-	 * that we can calculate the memory resources, etc
-	 *
-	 * The Chipset will report what it can handle which will be greater
-	 * or equal to what the motherboard manufacturer will implement.
-	 *
-	 * As we don't have a motherboard identification routine to determine
+	/* As we don't have a motherboard identification routine to determine
 	 * actual number of slots/dimms per channel, we thus utilize the
 	 * resource as specified by the chipset. Thus, we might have
 	 * have more DIMMs per channel than actually on the mobo, but this
 	 * allows the driver to support upto the chipset max, without
 	 * some fancy mobo determination.
 	 */
-	i5400_get_dimm_and_channel_counts(pdev, &num_dimms_per_channel,
-					&num_channels);
-	num_csrows = num_dimms_per_channel * 2;
+	num_dimms_per_channel = MAX_DIMMS_PER_CHANNEL;
+	num_channels = MAX_CHANNELS;
+	num_csrows = num_dimms_per_channel;
 
 	debugf0("MC: %s(): Number of - Channels= %d  DIMMS= %d  CSROWS= %d\n",
 		__func__, num_channels, num_dimms_per_channel, num_csrows);
