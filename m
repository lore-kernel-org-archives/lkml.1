Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbYCSUB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbYCSUB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbYCSTiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbYCSTiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:00 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 25/79] [PATCH] initialize map pointers in setup_32.c
Date: Wed, 19 Mar 2008 14:25:20 -0300
Message-Id: <12059476883852-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059476844196-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

this will serve as a reference as to whether or not to
use the per_cpu variables in mpparse. Done the same way
as x86_64

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/setup_32.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index db9d585..599ce01 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -724,6 +724,18 @@ char * __init __attribute__((weak)) memory_setup(void)
 	return machine_specific_memory_setup();
 }
 
+#ifdef CONFIG_NUMA
+/*
+ * In the golden day, when everything among i386 and x86_64 will be
+ * integrated, this will not live here
+ */
+void *x86_cpu_to_node_map_early_ptr;
+int x86_cpu_to_node_map_init[NR_CPUS] = {
+	[0 ... NR_CPUS-1] = NUMA_NO_NODE
+};
+DEFINE_PER_CPU(int, x86_cpu_to_node_map) = NUMA_NO_NODE;
+#endif
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -856,6 +868,18 @@ void __init setup_arch(char **cmdline_p)
 
 	io_delay_init();
 
+#ifdef CONFIG_X86_SMP
+	/*
+	 * setup to use the early static init tables during kernel startup
+	 * X86_SMP will exclude sub-arches that don't deal well with it.
+	 */
+	x86_cpu_to_apicid_early_ptr = (void *)x86_cpu_to_apicid_init;
+	x86_bios_cpu_apicid_early_ptr = (void *)x86_bios_cpu_apicid_init;
+#ifdef CONFIG_NUMA
+	x86_cpu_to_node_map_early_ptr = (void *)x86_cpu_to_node_map_init;
+#endif
+#endif
+
 #ifdef CONFIG_X86_GENERICARCH
 	generic_apic_probe();
 #endif
-- 
1.5.0.6

