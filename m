Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbZG1RTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbZG1RTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZG1RTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:19:00 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:19237
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755185AbZG1RSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:53 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DN-03-BLV-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 06/26] x86/oprofile: Fix initialization of switch_index
Date: Tue, 28 Jul 2009 19:07:06 +0200
Message-ID: <1248800846-25422-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:47.0947 (UTC) FILETIME=[5429EFB0:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable switch_index must be initialized for each cpu. This patch
fixes the initialization by moving it to the per-cpu init function
nmi_cpu_setup().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 8cd4658..b211d33 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -160,7 +160,7 @@ static int allocate_msrs(void)
 
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 
-static void nmi_setup_cpu_mux(struct op_msrs const * const msrs)
+static void nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs)
 {
 	int i;
 	struct op_msr *multiplex = msrs->multiplex;
@@ -173,8 +173,15 @@ static void nmi_setup_cpu_mux(struct op_msrs const * const msrs)
 			multiplex[i].saved = 0;
 		}
 	}
+
+	per_cpu(switch_index, cpu) = 0;
 }
 
+#else
+
+static inline void
+nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs) { }
+
 #endif
 
 static void nmi_cpu_setup(void *dummy)
@@ -184,9 +191,7 @@ static void nmi_cpu_setup(void *dummy)
 	nmi_cpu_save_registers(msrs);
 	spin_lock(&oprofilefs_lock);
 	model->setup_ctrs(model, msrs);
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-	nmi_setup_cpu_mux(msrs);
-#endif
+	nmi_cpu_setup_mux(cpu, msrs);
 	spin_unlock(&oprofilefs_lock);
 	per_cpu(saved_lvtpc, cpu) = apic_read(APIC_LVTPC);
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
@@ -662,9 +667,6 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	register_cpu_notifier(&oprofile_cpu_nb);
 #endif
 	/* default values, can be overwritten by model */
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-	__raw_get_cpu_var(switch_index) = 0;
-#endif
 	ops->create_files	= nmi_create_files;
 	ops->setup		= nmi_setup;
 	ops->shutdown		= nmi_shutdown;
-- 
1.6.3.3


