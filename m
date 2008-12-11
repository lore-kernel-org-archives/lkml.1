Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbYLKL2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbYLKL2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 06:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbYLKL2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 06:28:12 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54789 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751130AbYLKL2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 06:28:11 -0500
Message-Id: <20081211112806.740820000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 11 Dec 2008 03:28:07 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86: fix assign_irq_vector boot up problem
References: <20081211112806.499831000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=x86:fix-assign_irq_vector-boot-up-problem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix boot up problem.

Fix a problem encountered with the Intel SATA-AHCI disk driver
right at system startup.  Cpumask_intersects really needs to be
a 3-way intersect, and since we need a cpumask_var_t later on,
then just use it for the 3-way intersect as well.

Based on:
  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
+ git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git/cpus4096
+ git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-ingo.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/io_apic.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6-for-ingo/arch/x86/kernel/io_apic.c
@@ -1084,15 +1084,19 @@ static int __assign_irq_vector(int irq, 
 	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
 		return -EBUSY;
 
+	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
+		return -ENOMEM;
+
 	old_vector = cfg->vector;
 	if (old_vector) {
-		if (!cpumask_intersects(mask, cpu_online_mask))
-			return 0;
+		cpumask_and(tmp_mask, mask, cpu_online_mask);
+		cpumask_and(tmp_mask, cfg->domain, tmp_mask);
+		if (!cpumask_empty(tmp_mask)) {
+			free_cpumask_var(tmp_mask);
+ 			return 0;
+		}
 	}
 
-	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
-		return -ENOMEM;
-
 	/* Only try and allocate irqs on cpus that are present */
 	err = -ENOSPC;
 	for_each_cpu_and(cpu, mask, cpu_online_mask) {

