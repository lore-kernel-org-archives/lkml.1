Return-Path: <linux-kernel-owner+w=401wt.eu-S964782AbXBLHtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964782AbXBLHtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933083AbXBLHqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:46:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:49610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933085AbXBLHiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:02 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [12/39] i386: Handle 32 bit PerfMon Counter writes cleanly in oprofile
Message-Id: <20070212073759.2D7DA13E11@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:37:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Handle these 32 bit perfmon counter MSR writes cleanly in oprofile.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/oprofile/op_model_ppro.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux/arch/i386/oprofile/op_model_ppro.c
===================================================================
--- linux.orig/arch/i386/oprofile/op_model_ppro.c
+++ linux/arch/i386/oprofile/op_model_ppro.c
@@ -24,7 +24,8 @@
 
 #define CTR_IS_RESERVED(msrs,c) (msrs->counters[(c)].addr ? 1 : 0)
 #define CTR_READ(l,h,msrs,c) do {rdmsr(msrs->counters[(c)].addr, (l), (h));} while (0)
-#define CTR_WRITE(l,msrs,c) do {wrmsr(msrs->counters[(c)].addr, -(u32)(l), -1);} while (0)
+#define CTR_32BIT_WRITE(l,msrs,c)	\
+	do {wrmsr(msrs->counters[(c)].addr, -(u32)(l), 0);} while (0)
 #define CTR_OVERFLOWED(n) (!((n) & (1U<<31)))
 
 #define CTRL_IS_RESERVED(msrs,c) (msrs->controls[(c)].addr ? 1 : 0)
@@ -79,7 +80,7 @@ static void ppro_setup_ctrs(struct op_ms
 	for (i = 0; i < NUM_COUNTERS; ++i) {
 		if (unlikely(!CTR_IS_RESERVED(msrs,i)))
 			continue;
-		CTR_WRITE(1, msrs, i);
+		CTR_32BIT_WRITE(1, msrs, i);
 	}
 
 	/* enable active counters */
@@ -87,7 +88,7 @@ static void ppro_setup_ctrs(struct op_ms
 		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs,i))) {
 			reset_value[i] = counter_config[i].count;
 
-			CTR_WRITE(counter_config[i].count, msrs, i);
+			CTR_32BIT_WRITE(counter_config[i].count, msrs, i);
 
 			CTRL_READ(low, high, msrs, i);
 			CTRL_CLEAR(low);
@@ -116,7 +117,7 @@ static int ppro_check_ctrs(struct pt_reg
 		CTR_READ(low, high, msrs, i);
 		if (CTR_OVERFLOWED(low)) {
 			oprofile_add_sample(regs, i);
-			CTR_WRITE(reset_value[i], msrs, i);
+			CTR_32BIT_WRITE(reset_value[i], msrs, i);
 		}
 	}
 
