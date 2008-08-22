Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYHVS2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYHVS2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757807AbYHVS1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:27:47 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:17963 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041AbYHVS1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:27:46 -0400
X-BigFish: VPS3(zzzz10d3izz5a6ciz32i62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K60LXE-02-4AO-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       Jan Beulich <jbeulich@novell.com>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: fix: make PCI ECS for AMD CPUs hotplug capable
Date: Fri, 22 Aug 2008 20:23:38 +0200
Message-ID: <1219429418-29023-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <48AD82D5.76E4.0078.0@novell.com>
References: <48AD82D5.76E4.0078.0@novell.com>
X-OriginalArrivalTime: 22 Aug 2008 18:27:13.0336 (UTC) FILETIME=[B27ADB80:01C90484]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, PCI ECS setup was performed at boot time only and for cpus
that are enabled then. This patch fixes this and adds cpu hotplug.

Tests sequence (check if ECS bit is set when bringing cpu online again):

 # ( perl -e 'sysseek(STDIN, 0xC001001F, 0)'; hexdump -n 8 -e '2/4 "%08x " "\n"' )   < /dev/cpu/1/msr
 00000008 00404010
 # ( perl -e 'sysseek(STDOUT, 0xC001001F, 0); print pack "l*", 8, 0x00400010' ) > /dev/cpu/1/msr
 # ( perl -e 'sysseek(STDIN, 0xC001001F, 0)'; hexdump -n 8 -e '2/4 "%08x " "\n"' )   < /dev/cpu/1/msr
 00000008 00400010
 # echo 0 > /sys/devices/system/cpu/cpu1/online
 # echo 1 > /sys/devices/system/cpu/cpu1/online
 # ( perl -e 'sysseek(STDIN, 0xC001001F, 0)'; hexdump -n 8 -e '2/4 "%08x " "\n"' )   < /dev/cpu/1/msr
 00000008 00404010

Cc: Jan Beulich <jbeulich@novell.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/amd_bus.c |   35 +++++++++++++++++++++++++++++++----
 1 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 4a6f1a6..6a0fca7 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -1,6 +1,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/topology.h>
+#include <linux/cpu.h>
 #include "pci.h"
 
 #ifdef CONFIG_X86_64
@@ -565,7 +566,7 @@ static int __init early_fill_mp_bus_info(void) { return 0; }
 
 #define ENABLE_CF8_EXT_CFG      (1ULL << 46)
 
-static void enable_pci_io_ecs_per_cpu(void *unused)
+static void enable_pci_io_ecs(void *unused)
 {
 	u64 reg;
 	rdmsrl(MSR_AMD64_NB_CFG, reg);
@@ -575,13 +576,39 @@ static void enable_pci_io_ecs_per_cpu(void *unused)
 	}
 }
 
-static int __init enable_pci_io_ecs(void)
+static int __cpuinit amd_cpu_notify(struct notifier_block *self,
+				    unsigned long action, void *hcpu)
 {
+	int cpu = (long)hcpu;
+	switch(action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		smp_call_function_single(cpu, enable_pci_io_ecs, NULL, 0);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata amd_cpu_notifier = {
+	.notifier_call	= amd_cpu_notify,
+};
+
+static int __init pci_io_ecs_init(void)
+{
+	int cpu;
+
 	/* assume all cpus from fam10h have IO ECS */
         if (boot_cpu_data.x86 < 0x10)
 		return 0;
-	on_each_cpu(enable_pci_io_ecs_per_cpu, NULL, 1);
+
+	register_cpu_notifier(&amd_cpu_notifier);
+	for_each_online_cpu(cpu)
+		amd_cpu_notify(&amd_cpu_notifier, (unsigned long)CPU_ONLINE,
+			       (void *)(long)cpu);
 	pci_probe |= PCI_HAS_IO_ECS;
+
 	return 0;
 }
 
@@ -591,7 +618,7 @@ static int __init amd_postcore_init(void)
 		return 0;
 
 	early_fill_mp_bus_info();
-	enable_pci_io_ecs();
+	pci_io_ecs_init();
 
 	return 0;
 }
-- 
1.5.6.4


