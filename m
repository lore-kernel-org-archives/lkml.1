Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZG1RSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZG1RSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbZG1RS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:28 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53243 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbZG1RSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:05 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DP-04-A2K-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 14/26] x86/oprofile: Moving nmi_setup_cpu_mux() in nmi_int.c
Date: Tue, 28 Jul 2009 19:07:14 +0200
Message-ID: <1248800846-25422-15-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:49.0556 (UTC) FILETIME=[551F7340:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves some code in nmi_int.c to get a single separate
multiplexing code section.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   45 ++++++++++++++++++------------------------
 1 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 674fa37..b1edfc9 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -130,11 +130,30 @@ static int nmi_setup_mux(void)
 	return 1;
 }
 
+static void nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs)
+{
+	int i;
+	struct op_msr *multiplex = msrs->multiplex;
+
+	for (i = 0; i < model->num_virt_counters; ++i) {
+		if (counter_config[i].enabled) {
+			multiplex[i].saved = -(u64)counter_config[i].count;
+		} else {
+			multiplex[i].addr  = 0;
+			multiplex[i].saved = 0;
+		}
+	}
+
+	per_cpu(switch_index, cpu) = 0;
+}
+
 #else
 
 inline int op_x86_phys_to_virt(int phys) { return phys; }
 static inline void nmi_shutdown_mux(void) { }
 static inline int nmi_setup_mux(void) { return 1; }
+static inline void
+nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs) { }
 
 #endif
 
@@ -169,32 +188,6 @@ static int allocate_msrs(void)
 	return 1;
 }
 
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-
-static void nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs)
-{
-	int i;
-	struct op_msr *multiplex = msrs->multiplex;
-
-	for (i = 0; i < model->num_virt_counters; ++i) {
-		if (counter_config[i].enabled) {
-			multiplex[i].saved = -(u64)counter_config[i].count;
-		} else {
-			multiplex[i].addr  = 0;
-			multiplex[i].saved = 0;
-		}
-	}
-
-	per_cpu(switch_index, cpu) = 0;
-}
-
-#else
-
-static inline void
-nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs) { }
-
-#endif
-
 static void nmi_cpu_setup(void *dummy)
 {
 	int cpu = smp_processor_id();
-- 
1.6.3.3


