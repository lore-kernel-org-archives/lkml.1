Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbYCCRe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbYCCRe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760272AbYCCRQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:16:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758632AbYCCRQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:16:40 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 37/52] use remove_from_maps in cpu_disable
Date: Mon,  3 Mar 2008 14:13:05 -0300
Message-Id: <1204564400-17636-38-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-37-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
 <1204564400-17636-26-git-send-email-gcosta@redhat.com>
 <1204564400-17636-27-git-send-email-gcosta@redhat.com>
 <1204564400-17636-28-git-send-email-gcosta@redhat.com>
 <1204564400-17636-29-git-send-email-gcosta@redhat.com>
 <1204564400-17636-30-git-send-email-gcosta@redhat.com>
 <1204564400-17636-31-git-send-email-gcosta@redhat.com>
 <1204564400-17636-32-git-send-email-gcosta@redhat.com>
 <1204564400-17636-33-git-send-email-gcosta@redhat.com>
 <1204564400-17636-34-git-send-email-gcosta@redhat.com>
 <1204564400-17636-35-git-send-email-gcosta@redhat.com>
 <1204564400-17636-36-git-send-email-gcosta@redhat.com>
 <1204564400-17636-37-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it is already used in x86_64. In i386, it only
removes from cpu_online_map

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |    7 ++++++-
 arch/x86/kernel/smpboot_64.c |    8 +++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index a58ca7f..4939b3a 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -1041,6 +1041,11 @@ void __init native_smp_prepare_boot_cpu(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
+static void __ref remove_cpu_from_maps(int cpu)
+{
+	cpu_clear(cpu, cpu_online_map);
+}
+
 int __cpu_disable(void)
 {
 	cpumask_t map = cpu_online_map;
@@ -1066,7 +1071,7 @@ int __cpu_disable(void)
 
 	remove_siblinginfo(cpu);
 
-	cpu_clear(cpu, map);
+	remove_cpu_from_maps(cpu);
 	fixup_irqs(map);
 	/* It's now safe to remove this processor from the online map */
 	cpu_clear(cpu, cpu_online_map);
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index ca3a3c5..6509d3c 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -838,10 +838,9 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void __ref remove_cpu_from_maps(void)
+static void __ref remove_cpu_from_maps(int cpu)
 {
-	int cpu = smp_processor_id();
-
+	cpu_clear(cpu, cpu_online_map);
 	cpu_clear(cpu, cpu_callout_map);
 	cpu_clear(cpu, cpu_callin_map);
 	clear_bit(cpu, (unsigned long *)&cpu_initialized); /* was set by cpu_init() */
@@ -880,8 +879,7 @@ int __cpu_disable(void)
 	remove_siblinginfo(cpu);
 
 	/* It's now safe to remove this processor from the online map */
-	cpu_clear(cpu, cpu_online_map);
-	remove_cpu_from_maps();
+	remove_cpu_from_maps(cpu);
 	fixup_irqs(cpu_online_map);
 	return 0;
 }
-- 
1.5.0.6

