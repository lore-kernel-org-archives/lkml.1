Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZGTQPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZGTQPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZGTQPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:15:46 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:24730
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751916AbZGTQN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:13:27 -0400
X-SpamScore: 2
X-BigFish: VPS2(zz1402Izz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KN3920-04-7DV-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 08/14] amd64_edac: carve out MCi_STATUS decoding
Date: Mon, 20 Jul 2009 18:12:59 +0200
Message-ID: <1248106385-27514-9-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 Jul 2009 16:13:13.0937 (UTC) FILETIME=[FBC4EC10:01CA0954]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MCi_STATUS registers have most field definitions in common so decode
those in the general path.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c     |   53 ++++++++++++++++++++---------------------
 drivers/edac/amd64_edac.h     |    6 +---
 drivers/edac/amd64_edac_dbg.c |    2 +-
 3 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index af08c9e..a691bb8 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2242,7 +2242,7 @@ static void amd64_decode_bus_error(struct mem_ctl_info *mci,
 
 	if (ecc_type == 2)
 		amd64_handle_ce(mci, info);
-	else
+	else if (ecc_type == 1)
 		amd64_handle_ue(mci, info);
 
 	/*
@@ -2257,11 +2257,10 @@ static void amd64_decode_bus_error(struct mem_ctl_info *mci,
 }
 
 void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
-			 int handle_errors)
+			 int handle_errors, int ecc)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u32 ec, xec;
-	int ecc;
 
 	if (!handle_errors)
 		return;
@@ -2280,21 +2279,6 @@ void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 		pr_cont(", core: %d\n", ilog2((regs->nbsh & 0xf)));
 	}
 
-	pr_emerg(" Error: %sorrected",
-		 ((regs->nbsh & K8_NBSH_UC_ERR) ? "Unc" : "C"));
-	pr_cont(", Report Error: %s",
-		 ((regs->nbsh & K8_NBSH_ERR_EN) ? "yes" : "no"));
-	pr_cont(", MiscV: %svalid, CPU context corrupt: %s",
-		((regs->nbsh & K8_NBSH_MISCV) ? "" : "In"),
-		((regs->nbsh & K8_NBSH_PCC)   ? "yes" : "no"));
-
-	/* do the two bits[14:13] together */
-	ecc = regs->nbsh & (0x3 << 13);
-	if (ecc)
-		pr_cont(", %sECC Error", ((ecc == 2) ? "C" : "U"));
-
-	pr_cont("\n");
-
 	ec = ERROR_CODE(regs->nbsl);
 	xec = EXT_ERROR_CODE(regs->nbsl);
 
@@ -2343,18 +2327,33 @@ void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 void decode_mce(struct mce *m)
 {
 	struct err_regs regs;
+	int ecc;
 
-	if (m->bank != 4)
-		return;
+	pr_emerg("MC%d_STATUS:\n", m->bank);
 
-	regs.nbsl  = (u32) m->status;
-	regs.nbsh  = (u32)(m->status >> 32);
-	regs.nbeal = (u32) m->addr;
-	regs.nbeah = (u32)(m->addr >> 32);
+	pr_emerg(" Error: %sorrected, Report: %s, MiscV: %svalid, "
+		 "CPU context corrupt: %s",
+		 ((m->status & MCI_STATUS_UC) ? "Unc"  : "C"),
+		 ((m->status & MCI_STATUS_EN) ? "yes"  : "no"),
+		 ((m->status & MCI_STATUS_MISCV) ? ""  : "In"),
+		 ((m->status & MCI_STATUS_PCC) ? "yes" : "no"));
 
-	amd64_decode_nb_mce(mci_lookup[0], &regs, 1);
-}
+	/* do the two bits[14:13] together */
+	ecc = m->status & (3ULL << 45);
+	if (ecc)
+		pr_cont(", %sECC Error", ((ecc == 2) ? "C" : "U"));
 
+	pr_cont("\n");
+
+	if (m->bank == 4) {
+		regs.nbsl  = (u32) m->status;
+		regs.nbsh  = (u32)(m->status >> 32);
+		regs.nbeal = (u32) m->addr;
+		regs.nbeah = (u32)(m->addr >> 32);
+
+		amd64_decode_nb_mce(mci_lookup[0], &regs, 1, ecc);
+	}
+}
 
 /*
  * The main polling 'check' function, called FROM the edac core to perform the
@@ -2365,7 +2364,7 @@ static void amd64_check(struct mem_ctl_info *mci)
 	struct err_regs regs;
 
 	if (amd64_get_error_info(mci, &regs))
-		amd64_decode_nb_mce(mci, &regs, 1);
+		amd64_decode_nb_mce(mci, &regs, 1, 0);
 }
 
 /*
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 7c9138e..31cff33 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -626,8 +626,6 @@ static inline struct low_ops *family_ops(int index)
 #define F10_MIN_SCRUB_RATE_BITS	0x5
 #define F11_MIN_SCRUB_RATE_BITS	0x6
 
-void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *info,
-			int handle_errors);
+void amd64_decode_nb_mce(struct mem_ctl_info *, struct err_regs *, int, int);
 
-int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
-			     u64 *hole_offset, u64 *hole_size);
+int amd64_get_dram_hole_info(struct mem_ctl_info *, u64 *, u64 *, u64 *);
diff --git a/drivers/edac/amd64_edac_dbg.c b/drivers/edac/amd64_edac_dbg.c
index bcb4e2e..d6b8a35 100644
--- a/drivers/edac/amd64_edac_dbg.c
+++ b/drivers/edac/amd64_edac_dbg.c
@@ -24,7 +24,7 @@ static ssize_t amd64_nbea_store(struct mem_ctl_info *mci, const char *data,
 
 		/* Process the Mapping request */
 		/* TODO: Add race prevention */
-		amd64_decode_nb_mce(mci, &pvt->ctl_error_info, 1);
+		amd64_decode_nb_mce(mci, &pvt->ctl_error_info, 1, 0);
 
 		return count;
 	}
-- 
1.6.3.3


