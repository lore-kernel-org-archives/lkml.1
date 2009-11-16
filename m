Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbZKPOTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbZKPOTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZKPOTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:19:33 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:43469
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753377AbZKPOQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:24 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KT7GZ5-02-PZ7-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 09/21] amd64_edac: dump DIMM sizes on K8 too
Date: Mon, 16 Nov 2009 15:16:36 +0100
Message-ID: <1258381008-18783-10-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:13.0016 (UTC) FILETIME=[5A21A580:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend f10_debug_display_dimm_sizes to dump the logical DIMMs
configuration on K8 revF too. Remove the ganged arg since we print the
DCT operating mode (ganged vs unganged) earlier.

Also, DCT csrow configuration is relevant therefore dump it as
KERN_DEBUG instead of only on debug builds. Remove misleading DIMM
output since there's no reliable way of mapping of chip selects to
actual physical DIMMs.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   42 ++++++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c65ad2d..c6d1aed 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -822,8 +822,7 @@ static enum edac_type amd64_determine_edac_cap(struct amd64_pvt *pvt)
 }
 
 
-static void f10_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt,
-					 int ganged);
+static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt);
 
 static void amd64_dump_dramcfg_low(u32 dclr, int chan)
 {
@@ -875,8 +874,10 @@ static void amd64_dump_misc_regs(struct amd64_pvt *pvt)
 		(pvt->dhar & DHAR_VALID) ? "yes" : "no");
 
 	/* everything below this point is Fam10h and above */
-	if (boot_cpu_data.x86 == 0xf)
+	if (boot_cpu_data.x86 == 0xf) {
+		amd64_debug_display_dimm_sizes(0, pvt);
 		return;
+	}
 
 	/* Only if NOT ganged does dclr1 have valid info */
 	if (!dct_ganging_enabled(pvt))
@@ -888,10 +889,10 @@ static void amd64_dump_misc_regs(struct amd64_pvt *pvt)
 	 */
 	ganged = dct_ganging_enabled(pvt);
 
-	f10_debug_display_dimm_sizes(0, pvt, ganged);
+	amd64_debug_display_dimm_sizes(0, pvt);
 
 	if (!ganged)
-		f10_debug_display_dimm_sizes(1, pvt, ganged);
+		amd64_debug_display_dimm_sizes(1, pvt);
 }
 
 /* Read in both of DBAM registers */
@@ -1726,23 +1727,31 @@ static int map_dbam_to_csrow_size(int index)
 }
 
 /*
- * debug routine to display the memory sizes of a DIMM (ganged or not) and it
+ * debug routine to display the memory sizes of all logical DIMMs and its
  * CSROWs as well
  */
-static void f10_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt,
-					 int ganged)
+static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 {
 	int dimm, size0, size1;
 	u32 dbam;
 	u32 *dcsb;
 
-	debugf1("  dbam%d: 0x%8.08x  CSROW is %s\n", ctrl,
-			ctrl ? pvt->dbam1 : pvt->dbam0,
-			ganged ? "GANGED - dbam1 not used" : "NON-GANGED");
+	if (boot_cpu_data.x86 == 0xf) {
+		/* K8 families < revF not supported yet */
+	       if (pvt->ext_model < OPTERON_CPU_REV_F)
+			return;
+	       else
+		       WARN_ON(ctrl != 0);
+	}
+
+	debugf1("F2x%d80 (DRAM Bank Address Mapping): 0x%08x\n",
+		ctrl, ctrl ? pvt->dbam1 : pvt->dbam0);
 
 	dbam = ctrl ? pvt->dbam1 : pvt->dbam0;
 	dcsb = ctrl ? pvt->dcsb1 : pvt->dcsb0;
 
+	edac_printk(KERN_DEBUG, EDAC_MC, "DCT%d chip selects:\n", ctrl);
+
 	/* Dump memory sizes for DIMM and its CSROWs */
 	for (dimm = 0; dimm < 4; dimm++) {
 
@@ -1754,15 +1763,8 @@ static void f10_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt,
 		if (dcsb[dimm*2 + 1] & K8_DCSB_CS_ENABLE)
 			size1 = map_dbam_to_csrow_size(DBAM_DIMM(dimm, dbam));
 
-		debugf1("     CTRL-%d DIMM-%d=%5dMB   CSROW-%d=%5dMB "
-				"CSROW-%d=%5dMB\n",
-				ctrl,
-				dimm,
-				size0 + size1,
-				dimm * 2,
-				size0,
-				dimm * 2 + 1,
-				size1);
+		edac_printk(KERN_DEBUG, EDAC_MC, " %d: %5dMB %d: %5dMB\n",
+			    dimm * 2, size0, dimm * 2 + 1, size1);
 	}
 }
 
-- 
1.6.4.3


