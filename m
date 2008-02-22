Return-Path: <linux-kernel-owner+w=401wt.eu-S1765399AbYBVVKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765399AbYBVVKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbYBVVJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:09:33 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52250 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbYBVVJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:09:31 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5236"; a="773384"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pj@sgi.com,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH sched-devel 4/7] cpuisol: Move on-stack array used for boot cmd parsing into __initdata
Date: Fri, 22 Feb 2008 13:09:15 -0800
Message-Id: <1203714558-20904-4-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203714558-20904-3-git-send-email-maxk@qualcomm.com>
References: <1203714558-20904-1-git-send-email-maxk@qualcomm.com>
 <1203714558-20904-2-git-send-email-maxk@qualcomm.com>
 <1203714558-20904-3-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested by Andrew Morton:

  isolated_cpu_setup() has an on-stack array of NR_CPUS integers.  This
  will consume 4k of stack on ia64 (at least).  We'll just squeak through
  for a ittle while, but this needs to be fixed.  Just move it into
  __initdata.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 kernel/cpu.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index a0ac386..b3af739 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -446,15 +446,20 @@ out:
 
 #ifdef CONFIG_CPUISOL
 /* Setup the mask of isolated cpus */
+
+static int __initdata isolcpu[NR_CPUS];
+
 static int __init isolated_cpu_setup(char *str)
 {
-	int ints[NR_CPUS], i;
+	int i, n;
+
+	str = get_options(str, ARRAY_SIZE(isolcpu), isolcpu);
+	n   = isolcpu[0];
 
-	str = get_options(str, ARRAY_SIZE(ints), ints);
 	cpus_clear(cpu_isolated_map);
-	for (i = 1; i <= ints[0]; i++)
-		if (ints[i] < NR_CPUS)
-			cpu_set(ints[i], cpu_isolated_map);
+	for (i = 1; i <= n; i++)
+		if (isolcpu[i] < NR_CPUS)
+			cpu_set(isolcpu[i], cpu_isolated_map);
 	return 1;
 }
 
-- 
1.5.4.1

