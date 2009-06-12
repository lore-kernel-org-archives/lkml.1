Return-Path: <linux-kernel-owner+w=401wt.eu-S1764589AbZFLNEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764589AbZFLNEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762824AbZFLM7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:34 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:39195 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761738AbZFLM7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:32 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j)
X-FB-SS: 5,
X-WSS-ID: 0KL4MQP-03-HWB-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 20/23] x86/oprofile: use 64 bit values to save MSR states
Date: Fri, 12 Jun 2009 14:35:37 +0200
Message-ID: <1244810140-20595-21-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:08.0748 (UTC) FILETIME=[92FF98C0:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes struct op_saved_msr and replaces it by an u64
variable. This makes code easier and it is possible to use 64 bit MSR
functions.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c      |   28 ++++++++--------------------
 arch/x86/oprofile/op_x86_model.h |    9 ++-------
 2 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 388ee15..3b84b78 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -78,19 +78,13 @@ static void nmi_cpu_save_registers(struct op_msrs *msrs)
 	unsigned int i;
 
 	for (i = 0; i < nr_ctrs; ++i) {
-		if (counters[i].addr) {
-			rdmsr(counters[i].addr,
-				counters[i].saved.low,
-				counters[i].saved.high);
-		}
+		if (counters[i].addr)
+			rdmsrl(counters[i].addr, counters[i].saved);
 	}
 
 	for (i = 0; i < nr_ctrls; ++i) {
-		if (controls[i].addr) {
-			rdmsr(controls[i].addr,
-				controls[i].saved.low,
-				controls[i].saved.high);
-		}
+		if (controls[i].addr)
+			rdmsrl(controls[i].addr, controls[i].saved);
 	}
 }
 
@@ -204,19 +198,13 @@ static void nmi_restore_registers(struct op_msrs *msrs)
 	unsigned int i;
 
 	for (i = 0; i < nr_ctrls; ++i) {
-		if (controls[i].addr) {
-			wrmsr(controls[i].addr,
-				controls[i].saved.low,
-				controls[i].saved.high);
-		}
+		if (controls[i].addr)
+			wrmsrl(controls[i].addr, controls[i].saved);
 	}
 
 	for (i = 0; i < nr_ctrs; ++i) {
-		if (counters[i].addr) {
-			wrmsr(counters[i].addr,
-				counters[i].saved.low,
-				counters[i].saved.high);
-		}
+		if (counters[i].addr)
+			wrmsrl(counters[i].addr, counters[i].saved);
 	}
 }
 
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 69f1eb4..fda52b4 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -15,14 +15,9 @@
 #include <asm/types.h>
 #include <asm/intel_arch_perfmon.h>
 
-struct op_saved_msr {
-	unsigned int high;
-	unsigned int low;
-};
-
 struct op_msr {
-	unsigned long addr;
-	struct op_saved_msr saved;
+	unsigned long	addr;
+	u64		saved;
 };
 
 struct op_msrs {
-- 
1.6.3.1


