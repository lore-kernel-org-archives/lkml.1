Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbZE0EaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbZE0EaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 00:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZE0E34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 00:29:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54209 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZE0E34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 00:29:56 -0400
Message-ID: <4A1CC1B7.3060405@jp.fujitsu.com>
Date: Wed, 27 May 2009 13:29:43 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org,
       Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] x86: MCE: Fix for getting IP/CS at MCE
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org> <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com> <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assume IP stored on the stack indicates the address of instruction at
the time of the MCE when either EIPV or RIPV are set.  This influences
whether the machine check exception handler decides to return or panic.

This fixes an EIPV test case in the mce-test suite and is more compliant
to the specification.

This currently only makes a difference in a artificial testing
scenario with the mce-test test suite.

Also in addition do not overwrite the EIPV with the presence of MSR,
and keep in trust the CS value on stack even if MSR is available.

[AK: combination of patches from Huang Ying and Hidetoshi Seto, with
 new description by me]
[HS: change misleading function name, add comment and some description
 based on "Improve mce_get_rip v3" ]
Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 249e3cf..1bb5958 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -247,21 +247,26 @@ int mce_available(struct cpuinfo_x86 *c)
 	return cpu_has(c, X86_FEATURE_MCE) && cpu_has(c, X86_FEATURE_MCA);
 }
 
-static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
+/*
+ * Get the address of the instruction at the time of the machine check
+ * error.
+ */
+static inline void mce_get_ip_at_error(struct mce *m, struct pt_regs *regs)
 {
-	if (regs && (m->mcgstatus & MCG_STATUS_RIPV)) {
+	/* We can trust IP & CS on stack if either RIPV or EIPV is valid */
+	if (regs && (m->mcgstatus & (MCG_STATUS_RIPV|MCG_STATUS_EIPV))) {
 		m->ip = regs->ip;
 		m->cs = regs->cs;
 	} else {
 		m->ip = 0;
 		m->cs = 0;
 	}
-	if (rip_msr) {
-		/* Assume the RIP in the MSR is exact. Is this true? */
-		m->mcgstatus |= MCG_STATUS_EIPV;
+	/*
+	 * Use MSR if available.
+	 * Since there is no MSR for CS, keep in trust it on stack.
+	 */
+	if (rip_msr)
 		m->ip = mce_rdmsrl(rip_msr);
-		m->cs = 0;
-	}
 }
 
 /*
@@ -431,7 +436,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (m.status & MCI_STATUS_ADDRV)
 			m.addr = mce_rdmsrl(MSR_IA32_MC0_ADDR + i*4);
 
-		mce_get_rip(&m, regs);
+		mce_get_ip_at_error(&m, regs);
 		mce_log(&m);
 
 		/*
-- 
1.6.3


