Return-Path: <linux-kernel-owner+w=401wt.eu-S1764302AbXIKNcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764302AbXIKNcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763346AbXIKNcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:32:06 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:18946 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763344AbXIKNcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:32:04 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 05/12] IB/ehca: Refactor hvcall tracing
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709111518.26276.fenkes@de.ibm.com>
In-Reply-To: <200709111518.26276.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3006
Date: Tue, 11 Sep 2007 15:31:49 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709111531.50039.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change hvcall trace output towards better readability: reg numbers instead
of argument numbers, return code as signed decimal instead of unsigned hex.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/hcp_if.c |   57 ++++++++++++++--------------------
 1 files changed, 24 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index 8534061..32f465b 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -84,6 +84,10 @@
 #define H_MP_SHUTDOWN                   EHCA_BMASK_IBM(48, 48)
 #define H_MP_RESET_QKEY_CTR             EHCA_BMASK_IBM(49, 49)
 
+#define HCALL4_REGS_FORMAT "r4=%lx r5=%lx r6=%lx r7=%lx"
+#define HCALL7_REGS_FORMAT HCALL4_REGS_FORMAT " r8=%lx r9=%lx r10=%lx"
+#define HCALL9_REGS_FORMAT HCALL7_REGS_FORMAT " r11=%lx r12=%lx"
+
 static DEFINE_SPINLOCK(hcall_lock);
 
 static u32 get_longbusy_msecs(int longbusy_rc)
@@ -118,8 +122,7 @@ static long ehca_plpar_hcall_norets(unsigned long opcode,
 	long ret;
 	int i, sleep_msecs;
 
-	ehca_gen_dbg("opcode=%lx arg1=%lx arg2=%lx arg3=%lx arg4=%lx "
-		     "arg5=%lx arg6=%lx arg7=%lx",
+	ehca_gen_dbg("opcode=%lx " HCALL7_REGS_FORMAT,
 		     opcode, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
 
 	for (i = 0; i < 5; i++) {
@@ -133,16 +136,13 @@ static long ehca_plpar_hcall_norets(unsigned long opcode,
 		}
 
 		if (ret < H_SUCCESS)
-			ehca_gen_err("opcode=%lx ret=%lx"
-				     " arg1=%lx arg2=%lx arg3=%lx arg4=%lx"
-				     " arg5=%lx arg6=%lx arg7=%lx ",
-				     opcode, ret,
-				     arg1, arg2, arg3, arg4, arg5,
-				     arg6, arg7);
-
-		ehca_gen_dbg("opcode=%lx ret=%lx", opcode, ret);
-		return ret;
+			ehca_gen_err("opcode=%lx ret=%li " HCALL7_REGS_FORMAT,
+				     opcode, ret, arg1, arg2, arg3,
+				     arg4, arg5, arg6, arg7);
+		else
+			ehca_gen_dbg("opcode=%lx ret=%li", opcode, ret);
 
+		return ret;
 	}
 
 	return H_BUSY;
@@ -164,10 +164,8 @@ static long ehca_plpar_hcall9(unsigned long opcode,
 	int i, sleep_msecs, lock_is_set = 0;
 	unsigned long flags = 0;
 
-	ehca_gen_dbg("opcode=%lx arg1=%lx arg2=%lx arg3=%lx arg4=%lx "
-		     "arg5=%lx arg6=%lx arg7=%lx arg8=%lx arg9=%lx",
-		     opcode, arg1, arg2, arg3, arg4, arg5, arg6, arg7,
-		     arg8, arg9);
+	ehca_gen_dbg("INPUT -- opcode=%lx " HCALL9_REGS_FORMAT, opcode,
+		     arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
 
 	for (i = 0; i < 5; i++) {
 		if ((opcode == H_ALLOC_RESOURCE) && (arg2 == 5)) {
@@ -188,26 +186,19 @@ static long ehca_plpar_hcall9(unsigned long opcode,
 			continue;
 		}
 
-		if (ret < H_SUCCESS)
-			ehca_gen_err("opcode=%lx ret=%lx"
-				     " arg1=%lx arg2=%lx arg3=%lx arg4=%lx"
-				     " arg5=%lx arg6=%lx arg7=%lx arg8=%lx"
-				     " arg9=%lx"
-				     " out1=%lx out2=%lx out3=%lx out4=%lx"
-				     " out5=%lx out6=%lx out7=%lx out8=%lx"
-				     " out9=%lx",
-				     opcode, ret,
-				     arg1, arg2, arg3, arg4, arg5,
-				     arg6, arg7, arg8, arg9,
-				     outs[0], outs[1], outs[2], outs[3],
+		if (ret < H_SUCCESS) {
+			ehca_gen_err("INPUT -- opcode=%lx " HCALL9_REGS_FORMAT,
+				     opcode, arg1, arg2, arg3, arg4, arg5,
+				     arg6, arg7, arg8, arg9);
+			ehca_gen_err("OUTPUT -- ret=%li " HCALL9_REGS_FORMAT,
+				     ret, outs[0], outs[1], outs[2], outs[3],
+				     outs[4], outs[5], outs[6], outs[7],
+				     outs[8]);
+		} else
+			ehca_gen_dbg("OUTPUT -- ret=%li " HCALL9_REGS_FORMAT,
+				     ret, outs[0], outs[1], outs[2], outs[3],
 				     outs[4], outs[5], outs[6], outs[7],
 				     outs[8]);
-
-		ehca_gen_dbg("opcode=%lx ret=%lx out1=%lx out2=%lx out3=%lx "
-			     "out4=%lx out5=%lx out6=%lx out7=%lx out8=%lx "
-			     "out9=%lx",
-			     opcode, ret, outs[0], outs[1], outs[2], outs[3],
-			     outs[4], outs[5], outs[6], outs[7], outs[8]);
 		return ret;
 	}
 
-- 
1.5.2


