Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZFLNAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZFLNAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762311AbZFLM7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:14 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:59404 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761824AbZFLM7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:12 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i17ch61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KL4MQE-01-LYJ-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/23] x86/oprofile: moving arch_perfmon counter setup to op_x86_model_spec.init
Date: Fri, 12 Jun 2009 14:35:19 +0200
Message-ID: <1244810140-20595-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:05.0389 (UTC) FILETIME=[90FF0DD0:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function arch_perfmon_init() in nmi_int.c is model specific. This
patch moves it to op_model_ppro.c by using the init function pointer
in struct op_x86_model_spec.

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c       |   21 +++++++++------------
 arch/x86/oprofile/op_model_ppro.c |    9 ++++++++-
 arch/x86/oprofile/op_x86_model.h  |    2 --
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 3b285e6..dd85153 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -427,7 +427,7 @@ static int __init ppro_init(char **cpu_type)
 		*cpu_type = "i386/core_2";
 		break;
 	case 26:
-		arch_perfmon_setup_counters();
+		model = &op_arch_perfmon_spec;
 		*cpu_type = "i386/core_i7";
 		break;
 	case 28:
@@ -442,16 +442,6 @@ static int __init ppro_init(char **cpu_type)
 	return 1;
 }
 
-static int __init arch_perfmon_init(char **cpu_type)
-{
-	if (!cpu_has_arch_perfmon)
-		return 0;
-	*cpu_type = "i386/arch_perfmon";
-	model = &op_arch_perfmon_spec;
-	arch_perfmon_setup_counters();
-	return 1;
-}
-
 /* in order to get sysfs right */
 static int using_nmi;
 
@@ -509,8 +499,15 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 			break;
 		}
 
-		if (!cpu_type && !arch_perfmon_init(&cpu_type))
+		if (cpu_type)
+			break;
+
+		if (!cpu_has_arch_perfmon)
 			return -ENODEV;
+
+		/* use arch perfmon as fallback */
+		cpu_type = "i386/arch_perfmon";
+		model = &op_arch_perfmon_spec;
 		break;
 
 	default:
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 2a12399..ae58119 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -233,7 +233,7 @@ struct op_x86_model_spec const op_ppro_spec = {
  * the specific CPU.
  */
 
-void arch_perfmon_setup_counters(void)
+static void arch_perfmon_setup_counters(void)
 {
 	union cpuid10_eax eax;
 
@@ -253,7 +253,14 @@ void arch_perfmon_setup_counters(void)
 	op_arch_perfmon_spec.num_controls = num_counters;
 }
 
+static int arch_perfmon_init(struct oprofile_operations *ignore)
+{
+	arch_perfmon_setup_counters();
+	return 0;
+}
+
 struct op_x86_model_spec op_arch_perfmon_spec = {
+	.init			= &arch_perfmon_init,
 	/* num_counters/num_controls filled in at runtime */
 	.fill_in_addresses	= &ppro_fill_in_addresses,
 	/* user space does the cpuid check for available events */
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 2317149..ed27783 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -51,6 +51,4 @@ extern struct op_x86_model_spec const op_p4_ht2_spec;
 extern struct op_x86_model_spec const op_amd_spec;
 extern struct op_x86_model_spec op_arch_perfmon_spec;
 
-extern void arch_perfmon_setup_counters(void);
-
 #endif /* OP_X86_MODEL_H */
-- 
1.6.3.1


