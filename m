Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbZG1RWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbZG1RWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbZG1RSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:24 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:35463 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbZG1RSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:04 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DS-04-A2T-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 22/26] x86/oprofile: Implement mux_clone()
Date: Tue, 28 Jul 2009 19:07:22 +0200
Message-ID: <1248800846-25422-23-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:51.0087 (UTC) FILETIME=[56090FF0:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To setup a counter for all cpus, its structure is cloned from cpu
0. This patch implements mux_clone() to do this part for multiplexing
data.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   37 +++++++++++++++++++++++--------------
 1 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index f0fb447..da6d2ab 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -264,6 +264,16 @@ static inline void mux_init(struct oprofile_operations *ops)
 		ops->switch_events = nmi_switch_event;
 }
 
+static void mux_clone(int cpu)
+{
+	if (!has_mux())
+		return;
+
+	memcpy(per_cpu(cpu_msrs, cpu).multiplex,
+	       per_cpu(cpu_msrs, 0).multiplex,
+	       sizeof(struct op_msr) * model->num_virt_counters);
+}
+
 #else
 
 inline int op_x86_phys_to_virt(int phys) { return phys; }
@@ -272,6 +282,7 @@ static inline int nmi_setup_mux(void) { return 1; }
 static inline void
 nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs) { }
 static inline void mux_init(struct oprofile_operations *ops) { }
+static void mux_clone(int cpu) { }
 
 #endif
 
@@ -350,20 +361,18 @@ static int nmi_setup(void)
 	/* Assume saved/restored counters are the same on all CPUs */
 	model->fill_in_addresses(&per_cpu(cpu_msrs, 0));
 	for_each_possible_cpu(cpu) {
-		if (cpu != 0) {
-			memcpy(per_cpu(cpu_msrs, cpu).counters,
-				per_cpu(cpu_msrs, 0).counters,
-				sizeof(struct op_msr) * model->num_counters);
-
-			memcpy(per_cpu(cpu_msrs, cpu).controls,
-				per_cpu(cpu_msrs, 0).controls,
-				sizeof(struct op_msr) * model->num_controls);
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-			memcpy(per_cpu(cpu_msrs, cpu).multiplex,
-				per_cpu(cpu_msrs, 0).multiplex,
-				sizeof(struct op_msr) * model->num_virt_counters);
-#endif
-		}
+		if (!cpu)
+			continue;
+
+		memcpy(per_cpu(cpu_msrs, cpu).counters,
+		       per_cpu(cpu_msrs, 0).counters,
+		       sizeof(struct op_msr) * model->num_counters);
+
+		memcpy(per_cpu(cpu_msrs, cpu).controls,
+		       per_cpu(cpu_msrs, 0).controls,
+		       sizeof(struct op_msr) * model->num_controls);
+
+		mux_clone(cpu);
 	}
 	on_each_cpu(nmi_cpu_setup, NULL, 1);
 	nmi_enabled = 1;
-- 
1.6.3.3


