Return-Path: <linux-kernel-owner+w=401wt.eu-S939418AbXGSPdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939418AbXGSPdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937211AbXGSPdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:33:40 -0400
Received: from il.qumranet.com ([82.166.9.18]:49840 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934014AbXGSPdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:33:39 -0400
From: Avi Kivity <avi@qumranet.com>
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
Subject: [PATCH] powerpc: Allow smp_call_function_single() to current cpu
Date: Thu, 19 Jul 2007 18:33:48 +0300
Message-Id: <11848592284075-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the requirement for callers to get_cpu() to check in simple
cases.  i386 and x86_64 already received a similar treatment.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/powerpc/kernel/smp.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index d577b71..087c92f 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -284,7 +284,7 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info, int
 			int wait)
 {
 	cpumask_t map = CPU_MASK_NONE;
-	int ret = -EBUSY;
+	int ret = 0;
 
 	if (!cpu_online(cpu))
 		return -EINVAL;
@@ -292,6 +292,11 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info, int
 	cpu_set(cpu, map);
 	if (cpu != get_cpu())
 		ret = smp_call_function_map(func,info,nonatomic,wait,map);
+	else {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
+	}
 	put_cpu();
 	return ret;
 }
-- 
1.5.2.4

