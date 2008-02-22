Return-Path: <linux-kernel-owner+w=401wt.eu-S1762445AbYBVVJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762445AbYBVVJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbYBVVJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:09:32 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52250 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbYBVVJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:09:30 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5236"; a="773382"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pj@sgi.com,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH sched-devel 2/7] cpuisol: Do not route IRQs to the CPUs isolated at boot
Date: Fri, 22 Feb 2008 13:09:13 -0800
Message-Id: <1203714558-20904-2-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203714558-20904-1-git-send-email-maxk@qualcomm.com>
References: <1203714558-20904-1-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most people would expect isolated CPUs to not get any
IRQs by default. This happens naturally if a CPU is brought
off-line, marked isolated and then brought back online.

There was some confusion about this patch originaly. So I wanted
to clarify that it does not completely disable IRQ handling on
the isolated CPUs. Users still have the option or routing IRQs
to them by modifying IRQ affinity mask.

I cannot test other archs hence the patch is for x86_64 only.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 arch/x86/kernel/genapic_flat_64.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 07352b7..e02e58c 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -21,7 +21,9 @@
 
 static cpumask_t flat_target_cpus(void)
 {
-	return cpu_online_map;
+	cpumask_t target;
+	cpus_andnot(target, cpu_online_map, cpu_isolated_map);
+	return target;
 }
 
 static cpumask_t flat_vector_allocation_domain(int cpu)
-- 
1.5.4.1

