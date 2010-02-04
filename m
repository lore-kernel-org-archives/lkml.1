Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab0BDLGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 06:06:37 -0500
Received: from mga05.intel.com ([192.55.52.89]:49325 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756555Ab0BDLGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 06:06:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,404,1262592000"; 
   d="scan'208";a="537675637"
Message-ID: <4B6AAA39.6000300@linux.intel.com>
Date: Thu, 04 Feb 2010 19:06:33 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, Suresh.b.siddha@intel.com,
       lenb@kernel.org, trenn@suse.de,
       "Zheng, Shaohui" <shaohui.zheng@intel.com>,
       linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@intel.com>,
       "Lv, Jane" <jane.lv@intel.com>
Subject: [PATCH] x86, acpi: map hotadded cpu to correct node.
References: <C8EDE645B81E5141A8C6B2F73FD9265117C58A3504@shzsmsx501.ccr.corp.intel.com> <20100203220328.GG7510@basil.fritz.box>
In-Reply-To: <20100203220328.GG7510@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: map hotadded cpu to correct node.

When hotadd new cpu to system, if its affinitive node is online, should map the cpu to its own node. 
otherwise, let kernel select one online node for the new cpu later.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
  arch/x86/kernel/acpi/boot.c |   21 +++++++++++++++++++++
  1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 67e929b..92a4861 100644
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
+	if (!node_online(nid))
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
-- 
1.6.0.rc1




-haicheng
