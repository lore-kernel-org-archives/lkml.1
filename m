Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbZEZXzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbZEZXzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbZEZXyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38575 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbZEZXyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:41 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH 02/31] x86: MCE: Improve mce_get_rip v3
Date: Wed, 27 May 2009 01:54:04 +0200
Message-Id: <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

Assume RIP is valid when either EIPV or RIPV are set. This influences
whether the machine check exception handler decides to return or panic.

This fixes a test case in the mce-test suite and is more compliant
to the specification.

This currently only makes a difference in a artificial testing
scenario with the mce-test test suite.

Also in addition do not force the RIP to be valid with the exact
register MSRs.

[AK: combination of patches from Huang Ying and Hidetoshi Seto, with
new description by me]
Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 249e3cf..3f158d7 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -247,21 +247,22 @@ int mce_available(struct cpuinfo_x86 *c)
 	return cpu_has(c, X86_FEATURE_MCE) && cpu_has(c, X86_FEATURE_MCA);
 }
 
+/*
+ * Get the address of the instruction at the time of the machine check
+ * error.
+ */
 static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
 {
-	if (regs && (m->mcgstatus & MCG_STATUS_RIPV)) {
+
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
+	if (rip_msr)
 		m->ip = mce_rdmsrl(rip_msr);
-		m->cs = 0;
-	}
 }
 
 /*
-- 
1.6.0.2

