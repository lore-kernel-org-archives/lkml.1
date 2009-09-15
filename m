Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbZIOMHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbZIOMHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 08:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZIOMHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 08:07:10 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:37412 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbZIOMHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 08:07:01 -0400
Subject: [PATCH v3 1/3] pSeries: cede latency specifier helper function.
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>
Date: Tue, 15 Sep 2009 17:37:01 +0530
Message-ID: <20090915120701.20523.94109.stgit@sofia.in.ibm.com>
In-Reply-To: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>

This patch provides helper functions to set the cede latency specifier
value in the VPA indicating the latency expectation of the guest OS to
inform the hypervisor's choice of the platform dependent energy saving
mode chosen for the processor when unused during the subsequent
H_CEDE hypercall.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 arch/powerpc/include/asm/lppaca.h               |    9 ++++++++-
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   17 +++++++++++++++++
 arch/powerpc/xmon/xmon.c                        |    3 ++-
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/lppaca.h b/arch/powerpc/include/asm/lppaca.h
index f78f65c..aaa0066 100644
--- a/arch/powerpc/include/asm/lppaca.h
+++ b/arch/powerpc/include/asm/lppaca.h
@@ -100,7 +100,14 @@ struct lppaca {
 	// Used to pass parms from the OS to PLIC for SetAsrAndRfid
 	u64	saved_gpr3;		// Saved GPR3                   x20-x27
 	u64	saved_gpr4;		// Saved GPR4                   x28-x2F
-	u64	saved_gpr5;		// Saved GPR5                   x30-x37
+	union {
+		u64	saved_gpr5;	// Saved GPR5                   x30-x37
+		struct {
+			u8	cede_latency_hint;  //			x30
+			u8	reserved[7];        //			x31-x36
+		} fields;
+	} gpr5_dword;
+
 
 	u8	dtl_enable_mask;	// Dispatch Trace Log mask	x38-x38
 	u8	donate_dedicated_cpu;	// Donate dedicated CPU cycles  x39-x39
diff --git a/arch/powerpc/platforms/pseries/plpar_wrappers.h b/arch/powerpc/platforms/pseries/plpar_wrappers.h
index a24a6b2..1174d4b 100644
--- a/arch/powerpc/platforms/pseries/plpar_wrappers.h
+++ b/arch/powerpc/platforms/pseries/plpar_wrappers.h
@@ -9,11 +9,28 @@ static inline long poll_pending(void)
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
 
+static inline long extended_cede_processor(u8 latency_hint)
+{
+	set_cede_latency_hint(latency_hint);
+	cede_processor();
+
+}
+
 static inline long vpa_call(unsigned long flags, unsigned long cpu,
 		unsigned long vpa)
 {
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index e1f33a8..a2089cd 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -1613,7 +1613,8 @@ static void super_regs(void)
 			       ptrLpPaca->saved_srr0, ptrLpPaca->saved_srr1);
 			printf("    Saved Gpr3=%.16lx  Saved Gpr4=%.16lx \n",
 			       ptrLpPaca->saved_gpr3, ptrLpPaca->saved_gpr4);
-			printf("    Saved Gpr5=%.16lx \n", ptrLpPaca->saved_gpr5);
+			printf("    Saved Gpr5=%.16lx \n",
+				ptrLpPaca->gpr5_dword.saved_gpr5);
 		}
 #endif
 

