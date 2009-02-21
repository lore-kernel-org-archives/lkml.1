Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZBUNgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZBUNgk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 08:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbZBUNgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 08:36:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:39315 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZBUNgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 08:36:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IQpPNLrwjcFTV3KMseU88dpIrdRQJHKanGBCoCm208Ct+XFAp6ZfTegLjqDcjILBAQ
         tD74vUMNoTuvPTt+h2lt+esg9zKrp5971SslD9bpu6HvxUUrZU06U5ghRL8ZBF1J4NgZ
         s0bGhr+9a/yyWW3UemrCRqCSK9YzqhAhj0cWc=
From: Vegard Nossum <vegard.nossum@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] kmemcheck: disable fast string operations on P4 CPUs
Date: Sat, 21 Feb 2009 14:36:01 +0100
Message-Id: <1235223364-2097-2-git-send-email-vegard.nossum@gmail.com>
X-Mailer: git-send-email 1.6.2.rc0.61.g5cd12
In-Reply-To: <1235223364-2097-1-git-send-email-vegard.nossum@gmail.com>
References: <1235223364-2097-1-git-send-email-vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch may allow us to remove the REP emulation code from
kmemcheck.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/cpu/intel.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1f137a8..65e9717 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -75,6 +75,29 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	 */
 	if (c->x86 == 6 && c->x86_model < 15)
 		clear_cpu_cap(c, X86_FEATURE_PAT);
+
+#ifdef CONFIG_KMEMCHECK
+	/*
+	 * P4s have a "fast strings" feature which causes single-
+	 * stepping REP instructions to only generate a #DB on
+	 * cache-line boundaries.
+	 *
+	 * Ingo Molnar reported a Pentium D (model 6) and a Xeon
+	 * (model 2) with the same problem.
+	 */
+	if (c->x86 == 15) {
+		u64 misc_enable;
+
+		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+
+		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
+			printk(KERN_INFO "kmemcheck: Disabling fast string operations\n");
+
+			misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
+			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		}
+	}
+#endif
 }
 
 #ifdef CONFIG_X86_32
-- 
1.6.0.6

