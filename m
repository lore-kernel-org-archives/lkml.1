Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbYAZWOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbYAZWOB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 17:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbYAZWLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 17:11:50 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41521 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbYAZWLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 17:11:43 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: fix section mismatch warning in topology.c
Date: Sat, 26 Jan 2008 23:11:49 +0100
Message-Id: <1201385513-26885-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080126215917.GB26651@uranus.ravnborg.org>
References: <20080126215917.GB26651@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: arch/x86/kernel/built-in.o(__ksymtab+0x2b0): Section mismatch: reference to .cpuinit.text:arch_register_cpu in '__ksymtab_arch_register_cpu'

Annotating exported symbols are wrong.
Previously the warning were hidden by avoiding the export
in the non HOTPLUG_CPU case but the improved checks in
modpost caught it anyway.
Fix it by removing the __cpuinit annotation and rearrange the
code a bit to save one ifdef/endif pair.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/kernel/topology.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index a0d1719..78cbb65 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -33,7 +33,8 @@
 
 static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
 
-int __cpuinit arch_register_cpu(int num)
+#ifdef CONFIG_HOTPLUG_CPU
+int arch_register_cpu(int num)
 {
 	/*
 	 * CPU0 cannot be offlined due to several
@@ -44,21 +45,23 @@ int __cpuinit arch_register_cpu(int num)
 	 * Also certain PCI quirks require not to enable hotplug control
 	 * for all CPU's.
 	 */
-#ifdef CONFIG_HOTPLUG_CPU
 	if (num)
 		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
-#endif
-
 	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
 }
+EXPORT_SYMBOL(arch_register_cpu);
 
-#ifdef CONFIG_HOTPLUG_CPU
 void arch_unregister_cpu(int num)
 {
 	return unregister_cpu(&per_cpu(cpu_devices, num).cpu);
 }
-EXPORT_SYMBOL(arch_register_cpu);
 EXPORT_SYMBOL(arch_unregister_cpu);
+#else
+int arch_register_cpu(int num)
+{
+	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
+}
+EXPORT_SYMBOL(arch_register_cpu);
 #endif /*CONFIG_HOTPLUG_CPU*/
 
 static int __init topology_init(void)
-- 
1.5.4.rc3.14.g44397

