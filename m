Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZG1RSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZG1RSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbZG1RSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:51 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:19724 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753893AbZG1RSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:23 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DQ-04-A2N-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 15/26] x86/oprofile: Moving nmi_cpu_save/restore_mpx_registers() in nmi_int.c
Date: Tue, 28 Jul 2009 19:07:15 +0200
Message-ID: <1248800846-25422-16-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:49.0665 (UTC) FILETIME=[55301510:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves some code in nmi_int.c to get a single separate
multiplexing code section.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   52 +++++++++++++++++++-----------------------
 1 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index b1edfc9..f38c5cf 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -147,6 +147,30 @@ static void nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs)
 	per_cpu(switch_index, cpu) = 0;
 }
 
+static void nmi_cpu_save_mpx_registers(struct op_msrs *msrs)
+{
+	struct op_msr *multiplex = msrs->multiplex;
+	int i;
+
+	for (i = 0; i < model->num_counters; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (multiplex[virt].addr)
+			rdmsrl(multiplex[virt].addr, multiplex[virt].saved);
+	}
+}
+
+static void nmi_cpu_restore_mpx_registers(struct op_msrs *msrs)
+{
+	struct op_msr *multiplex = msrs->multiplex;
+	int i;
+
+	for (i = 0; i < model->num_counters; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (multiplex[virt].addr)
+			wrmsrl(multiplex[virt].addr, multiplex[virt].saved);
+	}
+}
+
 #else
 
 inline int op_x86_phys_to_virt(int phys) { return phys; }
@@ -252,34 +276,6 @@ static int nmi_setup(void)
 	return 0;
 }
 
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-
-static void nmi_cpu_save_mpx_registers(struct op_msrs *msrs)
-{
-	struct op_msr *multiplex = msrs->multiplex;
-	int i;
-
-	for (i = 0; i < model->num_counters; ++i) {
-		int virt = op_x86_phys_to_virt(i);
-		if (multiplex[virt].addr)
-			rdmsrl(multiplex[virt].addr, multiplex[virt].saved);
-	}
-}
-
-static void nmi_cpu_restore_mpx_registers(struct op_msrs *msrs)
-{
-	struct op_msr *multiplex = msrs->multiplex;
-	int i;
-
-	for (i = 0; i < model->num_counters; ++i) {
-		int virt = op_x86_phys_to_virt(i);
-		if (multiplex[virt].addr)
-			wrmsrl(multiplex[virt].addr, multiplex[virt].saved);
-	}
-}
-
-#endif
-
 static void nmi_cpu_restore_registers(struct op_msrs *msrs)
 {
 	struct op_msr *counters = msrs->counters;
-- 
1.6.3.3


