Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab0COFPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 01:15:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:24593 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186Ab0COFPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 01:15:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,640,1262592000"; 
   d="scan'208";a="254642454"
Subject: [PATCH] x86,perf: Enable not tagged retired instruction counting
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 15 Mar 2010 12:58:22 +0800
Message-Id: <1268629102.3355.11.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@openvz.org>

This should turn on instruction counting. It's inaccurate
by now, we still need dependant event to tag mops before
count them. The result is that the number of instruction
may be lifted up.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/include/asm/perf_event_p4.h |    8 ++++----
 arch/x86/kernel/cpu/perf_event_p4.c  |    8 +++-----
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index 829f471..b47b9e9 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -324,8 +324,8 @@ static inline u32 p4_default_escr_conf(int cpu, int exclude_os, int exclude_usr)
 
 #define P4_SSE_INPUT_ASSIST		P4_EVENT_PACK(0x34, 0x01)
 	/*
-	 * MSR_P4_FIRM_ESCR:	8, 9
-	 * MSR_P4_FIRM_ESCR:	10, 11
+	 * MSR_P4_FIRM_ESCR0:	8, 9
+	 * MSR_P4_FIRM_ESCR1:	10, 11
 	 */
 
 #define P4_PACKED_SP_UOP		P4_EVENT_PACK(0x08, 0x01)
@@ -462,8 +462,8 @@ static inline u32 p4_default_escr_conf(int cpu, int exclude_os, int exclude_usr)
 
 #define P4_INSTR_RETIRED		P4_EVENT_PACK(0x02, 0x04)
 	/*
-	 * MSR_P4_CRU_ESCR2:	12, 13, 16
-	 * MSR_P4_CRU_ESCR3:	14, 15, 17
+	 * MSR_P4_CRU_ESCR0:	12, 13, 16
+	 * MSR_P4_CRU_ESCR1:	14, 15, 17
 	 */
 
 #define P4_UOPS_RETIRED			P4_EVENT_PACK(0x01, 0x04)
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 381f593..0367889 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -60,13 +60,11 @@ struct p4_event_template p4_templates[] = {
 	[2] = {
 		.opcode	= P4_INSTR_RETIRED,
 		.config	= 0,
-		.dep	= 0, /* needs front-end tagging */
+		.dep	= -1, /* needs front-end tagging */
 		.emask	=
 			P4_EVENT_ATTR(P4_INSTR_RETIRED, NBOGUSNTAG)	|
-			P4_EVENT_ATTR(P4_INSTR_RETIRED, NBOGUSTAG)	|
-			P4_EVENT_ATTR(P4_INSTR_RETIRED, BOGUSNTAG)	|
-			P4_EVENT_ATTR(P4_INSTR_RETIRED, BOGUSTAG),
-		.escr_msr	= { MSR_P4_CRU_ESCR2, MSR_P4_CRU_ESCR3 },
+			P4_EVENT_ATTR(P4_INSTR_RETIRED, BOGUSNTAG),
+		.escr_msr	= { MSR_P4_CRU_ESCR0, MSR_P4_CRU_ESCR1 },
 		.cntr		= { 12, 14 },
 	},
 	[3] = {


