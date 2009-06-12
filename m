Return-Path: <linux-kernel-owner+w=401wt.eu-S1764311AbZFLNQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764311AbZFLNQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764861AbZFLNPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:15:10 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:39051 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764857AbZFLNPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:15:07 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KL4MQN-03-HW7-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 14/23] x86/oprofile: pass the model to setup_ctrs() functions
Date: Fri, 12 Jun 2009 14:35:31 +0200
Message-ID: <1244810140-20595-15-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:07.0498 (UTC) FILETIME=[9240DCA0:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In follow-on patches the setup_ctrs() functions will need data that
describes the model. This patch extends the function argument list to
pass a pointer of the model to these function.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c       |    2 +-
 arch/x86/oprofile/op_model_amd.c  |    3 ++-
 arch/x86/oprofile/op_model_p4.c   |    3 ++-
 arch/x86/oprofile/op_model_ppro.c |    3 ++-
 arch/x86/oprofile/op_x86_model.h  |    3 ++-
 5 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index ae0ab03..c31f87b 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -125,7 +125,7 @@ static void nmi_cpu_setup(void *dummy)
 	int cpu = smp_processor_id();
 	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
 	spin_lock(&oprofilefs_lock);
-	model->setup_ctrs(msrs);
+	model->setup_ctrs(model, msrs);
 	spin_unlock(&oprofilefs_lock);
 	per_cpu(saved_lvtpc, cpu) = apic_read(APIC_LVTPC);
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index aaa7ffa..86e0a01 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -85,7 +85,8 @@ static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 }
 
 
-static void op_amd_setup_ctrs(struct op_msrs const * const msrs)
+static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
+			      struct op_msrs const * const msrs)
 {
 	unsigned int low, high;
 	int i;
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 365d8a9..05ba028 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -542,7 +542,8 @@ static void pmc_setup_one_p4_counter(unsigned int ctr)
 }
 
 
-static void p4_setup_ctrs(struct op_msrs const * const msrs)
+static void p4_setup_ctrs(struct op_x86_model_spec const *model,
+			  struct op_msrs const * const msrs)
 {
 	unsigned int i;
 	unsigned int low, high;
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 61ee8f6..40b44ee 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -51,7 +51,8 @@ static void ppro_fill_in_addresses(struct op_msrs * const msrs)
 }
 
 
-static void ppro_setup_ctrs(struct op_msrs const * const msrs)
+static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
+			    struct op_msrs const * const msrs)
 {
 	unsigned int low, high;
 	int i;
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index a207b1c..6161c7f 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -48,7 +48,8 @@ struct op_x86_model_spec {
 	int		(*init)(struct oprofile_operations *ops);
 	void		(*exit)(void);
 	void		(*fill_in_addresses)(struct op_msrs * const msrs);
-	void		(*setup_ctrs)(struct op_msrs const * const msrs);
+	void		(*setup_ctrs)(struct op_x86_model_spec const *model,
+				      struct op_msrs const * const msrs);
 	int		(*check_ctrs)(struct pt_regs * const regs,
 				      struct op_msrs const * const msrs);
 	void		(*start)(struct op_msrs const * const msrs);
-- 
1.6.3.1


