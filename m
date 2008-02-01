Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbYBAPDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbYBAPDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYBAPDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:03:10 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:47669 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbYBAPDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:03:09 -0500
Date: Fri, 1 Feb 2008 16:03:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: linux-kernel@vger.kernel.org,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: Avoid section mismatch involving arch_register_cpu
Message-ID: <20080201150312.GB13992@uranus.ravnborg.org>
References: <20080201145649.GA12318@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201145649.GA12318@mailshack.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander.

See below for my take on the same warning.
It is already in x86.git pending merge.

Comments welcome.

	Sam

>From b7b4f3e109c742d32d255e04b7c2f90d08599ea8 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 26 Jan 2008 21:25:08 +0100
Subject: [PATCH] x86: fix section mismatch warning in topology.c

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

