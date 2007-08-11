Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbXHKS6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbXHKS6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 14:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760332AbXHKS5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:57:55 -0400
Received: from 1wt.eu ([62.212.114.60]:1454 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758261AbXHKS5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:57:54 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184828.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:47:53 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 01/28] i386: Fix K8/core2 oprofile on multiple CPUs
Content-Disposition: inline; filename=0001-PATCH-i386-Fix-K8-core2-oprofile-on-multiple-CPUs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Only try to allocate MSRs once instead of for every CPU.

This assumes the MSRs are the same on all CPUs which is currently
true. P4-HT is a special case for different SMT threads, but the code
always saves/restores all MSRs so it works identical.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/i386/oprofile/nmi_int.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/i386/oprofile/nmi_int.c b/arch/i386/oprofile/nmi_int.c
index 3700eef..be4a9a8 100644
--- a/arch/i386/oprofile/nmi_int.c
+++ b/arch/i386/oprofile/nmi_int.c
@@ -131,7 +131,6 @@ static void nmi_save_registers(void * dummy)
 {
 	int cpu = smp_processor_id();
 	struct op_msrs * msrs = &cpu_msrs[cpu];
-	model->fill_in_addresses(msrs);
 	nmi_cpu_save_registers(msrs);
 }
 
@@ -195,6 +194,7 @@ static struct notifier_block profile_exceptions_nb = {
 static int nmi_setup(void)
 {
 	int err=0;
+	int cpu;
 
 	if (!allocate_msrs())
 		return -ENOMEM;
@@ -207,6 +207,13 @@ static int nmi_setup(void)
 	/* We need to serialize save and setup for HT because the subset
 	 * of msrs are distinct for save and setup operations
 	 */
+
+	/* Assume saved/restored counters are the same on all CPUs */
+	model->fill_in_addresses(&cpu_msrs[0]);
+	for_each_possible_cpu (cpu) {
+		if (cpu != 0)
+			cpu_msrs[cpu] = cpu_msrs[0];
+	}
 	on_each_cpu(nmi_save_registers, NULL, 0, 1);
 	on_each_cpu(nmi_cpu_setup, NULL, 0, 1);
 	nmi_enabled = 1;
-- 
1.5.2.4

-- 
