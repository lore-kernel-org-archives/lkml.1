Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0BJTki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 14:40:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:44446 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab0BJTkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 14:40:36 -0500
Date: Wed, 10 Feb 2010 19:39:46 GMT
From: tip-bot for Haicheng Li <haicheng.li@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com, hpa@zytor.com,
       mingo@redhat.com, trenn@suse.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, haicheng.li@linux.intel.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trenn@suse.de
In-Reply-To: <4B6AAA39.6000300@linux.intel.com>
References: <4B6AAA39.6000300@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86, acpi: Map hotadded cpu to correct node.
Message-ID: <tip-0271f91003d3703675be13b8865618359a6caa1f@git.kernel.org>
Git-Commit-ID: 0271f91003d3703675be13b8865618359a6caa1f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Feb 2010 19:39:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0271f91003d3703675be13b8865618359a6caa1f
Gitweb:     http://git.kernel.org/tip/0271f91003d3703675be13b8865618359a6caa1f
Author:     Haicheng Li <haicheng.li@linux.intel.com>
AuthorDate: Thu, 4 Feb 2010 19:06:33 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 10 Feb 2010 11:00:43 -0800

x86, acpi: Map hotadded cpu to correct node.

When hotadd new cpu to system, if its affinitive node is online,
should map the cpu to its own node.  Otherwise, let kernel select one
online node for the new cpu later.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
LKML-Reference: <4B6AAA39.6000300@linux.intel.com>
Tested-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/acpi/boot.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 036d28a..7db15e1 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -49,6 +49,7 @@ EXPORT_SYMBOL(acpi_disabled);
 
 #ifdef	CONFIG_X86_64
 # include <asm/proto.h>
+# include <asm/numa_64.h>
 #endif				/* X86 */
 
 #define BAD_MADT_ENTRY(entry, end) (					    \
@@ -482,6 +483,25 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
  */
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 
+static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
+{
+#ifdef CONFIG_ACPI_NUMA
+	int nid;
+
+	nid = acpi_get_node(handle);
+	if (nid == -1 || !node_online(nid))
+		return;
+#ifdef CONFIG_X86_64
+	apicid_to_node[physid] = nid;
+	numa_set_node(cpu, nid);
+#else /* CONFIG_X86_32 */
+	apicid_2_node[physid] = nid;
+	cpu_to_node_map[cpu] = nid;
+#endif
+
+#endif
+}
+
 static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
@@ -540,6 +560,7 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 	}
 
 	cpu = cpumask_first(new_map);
+	acpi_map_cpu2node(handle, cpu, physid);
 
 	*pcpu = cpu;
 	retval = 0;
