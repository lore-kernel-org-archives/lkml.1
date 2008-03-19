Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbYCSUVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbYCSUVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbYCSTiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbYCSThw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:52 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 21/79] [PATCH] make __smp_prepare_cpu void
Date: Wed, 19 Mar 2008 14:25:16 -0300
Message-Id: <12059476703608-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059476663034-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

We have already removed the only condition that could fail here.
so just don't test for any return value

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 147af81..ee6f3bd 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -704,11 +704,11 @@ static void __cpuinit do_warm_boot_cpu(struct work_struct *work)
 	complete(info->complete);
 }
 
-static int __cpuinit __smp_prepare_cpu(int cpu)
+static void __cpuinit __smp_prepare_cpu(int cpu)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 	struct warm_boot_cpu_info info;
-	int	apicid, ret;
+	int	apicid;
 
 	apicid = per_cpu(x86_cpu_to_apicid, cpu);
 
@@ -725,9 +725,6 @@ static int __cpuinit __smp_prepare_cpu(int cpu)
 	wait_for_completion(&done);
 
 	zap_low_mappings();
-	ret = 0;
-exit:
-	return ret;
 }
 #endif
 
@@ -950,7 +947,6 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 {
 	int apicid = cpu_present_to_apicid(cpu);
 	unsigned long flags;
-	int ret = 0;
 
 	WARN_ON(irqs_disabled());
 
@@ -971,10 +967,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	 * when a cpu is taken offline from cpu_exit_clear().
 	 */
 	if (!cpu_isset(cpu, cpu_callin_map))
-		ret = __smp_prepare_cpu(cpu);
-
-	if (ret)
-		return -EIO;
+		__smp_prepare_cpu(cpu);
 #endif
 
 	/* In case one didn't come up */
-- 
1.5.0.6

