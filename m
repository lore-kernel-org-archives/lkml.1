Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731Ab0COHnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 03:43:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:51244 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759620Ab0COHnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 03:43:33 -0400
Date: Mon, 15 Mar 2010 07:42:45 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, peterz@infradead.org, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, peterz@infradead.org, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1268629102.3355.11.camel@minggr.sh.intel.com>
References: <1268629102.3355.11.camel@minggr.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Enable not tagged retired instruction counting on P4s
Message-ID: <tip-e4495262826d1eabca3529fa6ac22394eb348132@git.kernel.org>
Git-Commit-ID: e4495262826d1eabca3529fa6ac22394eb348132
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 15 Mar 2010 07:42:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4495262826d1eabca3529fa6ac22394eb348132
Gitweb:     http://git.kernel.org/tip/e4495262826d1eabca3529fa6ac22394eb348132
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Mon, 15 Mar 2010 12:58:22 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 15 Mar 2010 08:14:34 +0100

perf, x86: Enable not tagged retired instruction counting on P4s

This should turn on instruction counting on P4s, which was missing in
the first version of the new PMU driver.

It's inaccurate for now, we still need dependant event to tag mops
before we can count them precisely. The result is that the number of
instruction may be lifted up.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1268629102.3355.11.camel@minggr.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index ef861da..a11ce73 100644
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
