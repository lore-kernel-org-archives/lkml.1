Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbZKPOQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbZKPOQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbZKPOQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:16:39 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:16385 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZKPOQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:35 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KT7GZ7-01-9KS-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 20/21] amd64_edac: correct sys address to chip select mapping
Date: Mon, 16 Nov 2009 15:16:47 +0100
Message-ID: <1258381008-18783-21-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:13.0344 (UTC) FILETIME=[5A53B200:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The routine does the reverse mapping of the error address of a CECC back
to the node id, DRAM controller and chip select of the DIMM which caused
the error. We should lookup the channel using the syndromes _only_ when
the DCTs are ganged so fix that.

Also, add an early exit when there's an error while scanning for the
csrow thus decreasing indentation levels for better readability.

Finally, fixup comments.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   58 +++++++++++++++++++++------------------------
 1 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 0969a40..533f5ff 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1645,10 +1645,11 @@ static int f10_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
 }
 
 /*
- * This the F10h reference code from AMD to map a @sys_addr to NodeID,
- * CSROW, Channel.
+ * For reference see "2.8.5 Routing DRAM Requests" in F10 BKDG. This code maps
+ * a @sys_addr to NodeID, DCT (channel) and chip select (CSROW).
  *
- * The @sys_addr is usually an error address received from the hardware.
+ * The @sys_addr is usually an error address received from the hardware
+ * (MCX_ADDR).
  */
 static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 				     struct err_regs *info,
@@ -1661,39 +1662,34 @@ static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 
 	csrow = f10_translate_sysaddr_to_cs(pvt, sys_addr, &nid, &chan);
 
-	if (csrow >= 0) {
-		error_address_to_page_and_offset(sys_addr, &page, &offset);
+	if (csrow < 0) {
+		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+		return;
+	}
+
+	error_address_to_page_and_offset(sys_addr, &page, &offset);
 
-		syndrome  = HIGH_SYNDROME(info->nbsl) << 8;
-		syndrome |= LOW_SYNDROME(info->nbsh);
+	syndrome  = HIGH_SYNDROME(info->nbsl) << 8;
+	syndrome |= LOW_SYNDROME(info->nbsh);
+
+	/*
+	 * We need the syndromes for channel detection only when we're
+	 * ganged. Otherwise @chan should already contain the channel at
+	 * this point.
+	 */
+	if (dct_ganging_enabled(pvt) && pvt->nbcfg & K8_NBCFG_CHIPKILL)
+		chan = get_channel_from_ecc_syndrome(mci, syndrome);
 
+	if (chan >= 0)
+		edac_mc_handle_ce(mci, page, offset, syndrome, csrow, chan,
+				  EDAC_MOD_STR);
+	else
 		/*
-		 * Is CHIPKILL on? If so, then we can attempt to use the
-		 * syndrome to isolate which channel the error was on.
+		 * Channel unknown, report all channels on this CSROW as failed.
 		 */
-		if (pvt->nbcfg & K8_NBCFG_CHIPKILL)
-			chan = get_channel_from_ecc_syndrome(mci, syndrome);
-
-		if (chan >= 0) {
+		for (chan = 0; chan < mci->csrows[csrow].nr_channels; chan++)
 			edac_mc_handle_ce(mci, page, offset, syndrome,
-					csrow, chan, EDAC_MOD_STR);
-		} else {
-			/*
-			 * Channel unknown, report all channels on this
-			 * CSROW as failed.
-			 */
-			for (chan = 0; chan < mci->csrows[csrow].nr_channels;
-								chan++) {
-					edac_mc_handle_ce(mci, page, offset,
-							syndrome,
-							csrow, chan,
-							EDAC_MOD_STR);
-			}
-		}
-
-	} else {
-		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
-	}
+					  csrow, chan, EDAC_MOD_STR);
 }
 
 /*
-- 
1.6.4.3


