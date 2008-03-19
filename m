Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYCST7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYCST7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756959AbYCSTh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:37:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756899AbYCSThu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:50 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 20/79] [PATCH] do tests before do_boot_cpu in i386
Date: Wed, 19 Mar 2008 14:25:15 -0300
Message-Id: <12059476663034-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1205947661385-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

Do tests before do_boot_cpu in native_cpu_up for i386.
Tests are a little bit broader than originally, and are the
same as x86_64. Test for smp_callin is not applicable right now
and is deferred.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 8144aa3..147af81 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -711,10 +711,6 @@ static int __cpuinit __smp_prepare_cpu(int cpu)
 	int	apicid, ret;
 
 	apicid = per_cpu(x86_cpu_to_apicid, cpu);
-	if (apicid == BAD_APICID) {
-		ret = -ENODEV;
-		goto exit;
-	}
 
 	info.complete = &done;
 	info.apicid = apicid;
@@ -952,10 +948,22 @@ void __init native_smp_prepare_boot_cpu(void)
 
 int __cpuinit native_cpu_up(unsigned int cpu)
 {
+	int apicid = cpu_present_to_apicid(cpu);
 	unsigned long flags;
-#ifdef CONFIG_HOTPLUG_CPU
 	int ret = 0;
 
+	WARN_ON(irqs_disabled());
+
+	Dprintk("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
+
+	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
+	    !physid_isset(apicid, phys_cpu_present_map)) {
+		printk(KERN_ERR "%s: bad cpu %d\n", __func__, cpu);
+		return -EINVAL;
+	}
+
+#ifdef CONFIG_HOTPLUG_CPU
+
 	/*
 	 * We do warm boot only on cpus that had booted earlier
 	 * Otherwise cold boot is all handled from smp_boot_cpus().
-- 
1.5.0.6

