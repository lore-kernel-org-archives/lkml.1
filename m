Return-Path: <linux-kernel-owner+w=401wt.eu-S1760292AbZJIIbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292AbZJIIbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760284AbZJIIbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:31:46 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:49369 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758290AbZJIIbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:31:40 -0400
Subject: [PATCH v4 1/4] pSeries: extended_cede_processor() helper function.
To: Nathan Fontenot <nfont@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
Date: Fri, 09 Oct 2009 14:00:50 +0530
Message-ID: <20091009083050.32381.68023.stgit@sofia.in.ibm.com>
In-Reply-To: <20091009082952.32381.32794.stgit@sofia.in.ibm.com>
References: <20091009082952.32381.32794.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides an extended_cede_processor() helper function
which takes the cede latency hint as an argument. This hint is to be passed
on to the hypervisor to cede to the corresponding state on platforms
which support it.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/lppaca.h               |    9 ++++++++-
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   22 ++++++++++++++++++++++
 arch/powerpc/xmon/xmon.c                        |    3 ++-
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/lppaca.h b/arch/powerpc/include/asm/lppaca.h
index f78f65c..14b592d 100644
--- a/arch/powerpc/include/asm/lppaca.h
+++ b/arch/powerpc/include/asm/lppaca.h
@@ -100,7 +100,14 @@ struct lppaca {
 	// Used to pass parms from the OS to PLIC for SetAsrAndRfid
 	u64	saved_gpr3;		// Saved GPR3                   x20-x27
 	u64	saved_gpr4;		// Saved GPR4                   x28-x2F
-	u64	saved_gpr5;		// Saved GPR5                   x30-x37
+	union {
+		u64	saved_gpr5;	/* Saved GPR5               x30-x37 */
+		struct {
+			u8	cede_latency_hint;  /*			x30 */
+			u8	reserved[7];        /*		    x31-x36 */
+		} fields;
+	} gpr5_dword;
+
 
 	u8	dtl_enable_mask;	// Dispatch Trace Log mask	x38-x38
 	u8	donate_dedicated_cpu;	// Donate dedicated CPU cycles  x39-x39
diff --git a/arch/powerpc/platforms/pseries/plpar_wrappers.h b/arch/powerpc/platforms/pseries/plpar_wrappers.h
index a24a6b2..0603c91 100644
--- a/arch/powerpc/platforms/pseries/plpar_wrappers.h
+++ b/arch/powerpc/platforms/pseries/plpar_wrappers.h
@@ -9,11 +9,33 @@ static inline long poll_pending(void)
 	return plpar_hcall_norets(H_POLL_PENDING);
 }
 
+static inline u8 get_cede_latency_hint(void)
+{
+	return get_lppaca()->gpr5_dword.fields.cede_latency_hint;
+}
+
+static inline void set_cede_latency_hint(u8 latency_hint)
+{
+	get_lppaca()->gpr5_dword.fields.cede_latency_hint = latency_hint;
+}
+
 static inline long cede_processor(void)
 {
 	return plpar_hcall_norets(H_CEDE);
 }
 
+static inline long extended_cede_processor(unsigned long latency_hint)
+{
+	long rc;
+	u8 old_latency_hint = get_cede_latency_hint();
+
+	set_cede_latency_hint(latency_hint);
+	rc = cede_processor();
+	set_cede_latency_hint(old_latency_hint);
+
+	return rc;
+}
+
 static inline long vpa_call(unsigned long flags, unsigned long cpu,
 		unsigned long vpa)
 {
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index c6f0a71..57124cf 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -1623,7 +1623,8 @@ static void super_regs(void)
 			       ptrLpPaca->saved_srr0, ptrLpPaca->saved_srr1);
 			printf("    Saved Gpr3=%.16lx  Saved Gpr4=%.16lx \n",
 			       ptrLpPaca->saved_gpr3, ptrLpPaca->saved_gpr4);
-			printf("    Saved Gpr5=%.16lx \n", ptrLpPaca->saved_gpr5);
+			printf("    Saved Gpr5=%.16lx \n",
+				ptrLpPaca->gpr5_dword.saved_gpr5);
 		}
 #endif
 

