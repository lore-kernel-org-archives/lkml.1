Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879Ab0ARSev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab0ARSev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859Ab0ARSeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:34:50 -0500
Received: from relay3.sgi.com ([192.48.152.1]:52447 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755857Ab0ARSer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:34:47 -0500
Message-Id: <20100118183435.948841000@alcatraz.americas.sgi.com>
References: <20100118183412.560438000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jan 2010 12:34:14 -0600
From: Mike Travis <travis@sgi.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>
Cc: Russ Anderson <rja@sgi.com>, Dave Airlie <airlied@redhat.com>,
       Alex Chiang <achiang@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robin Holt <holt@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Adam Jackson <ajax@nwnk.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gaetan Nadon <memsize@videotron.ca>, "H. Peter Anvin" <hpa@zytor.com>,
       Aaron Plattner <aplattner@nvidia.com>, Jack Steiner <steiner@sgi.com>,
       Tiago Vignatti <tiago.vignatti@nokia.com>, Cliff Wickman <cpw@sgi.com>,
       Matthew Wilcox <willy@linux.intel.com>,
       Christian Zander <chzander@nvidia.com>, Yu Zhao <yu.zhao@intel.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org
Subject: [PATCH 2/4] x86_64 UV: Update UV arch to target Legacy VGA I/O correctly.
Content-Disposition: inline; filename=update-uv-using-bios
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function to direct Legacy VGA I/O traffic to correct I/O Hub.

Signed-off-by: Mike Travis <travis@sgi.com>

Cc: Dave Airlie <airlied@redhat.com>
Cc: Alex Chiang <achiang@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Robin Holt <holt@sgi.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Adam Jackson <ajax@nwnk.net>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Gaetan Nadon <memsize@videotron.ca>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Aaron Plattner <aplattner@nvidia.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Tiago Vignatti <tiago.vignatti@nokia.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Christian Zander <chzander@nvidia.com>
Cc: Yu Zhao <yu.zhao@intel.com>

Cc: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: x86@kernel.org
---
 arch/x86/include/asm/uv/bios.h     |    4 +++-
 arch/x86/kernel/apic/x2apic_uv_x.c |   30 ++++++++++++++++++++++++++++++
 arch/x86/kernel/bios_uv.c          |   19 +++++++++++++++++++
 3 files changed, 52 insertions(+), 1 deletion(-)

--- linux.orig/arch/x86/include/asm/uv/bios.h
+++ linux/arch/x86/include/asm/uv/bios.h
@@ -36,7 +36,8 @@
 	UV_BIOS_WATCHLIST_ALLOC,
 	UV_BIOS_WATCHLIST_FREE,
 	UV_BIOS_MEMPROTECT,
-	UV_BIOS_GET_PARTITION_ADDR
+	UV_BIOS_GET_PARTITION_ADDR,
+	UV_BIOS_SET_LEGACY_VGA_TARGET
 };
 
 /*
@@ -96,6 +97,7 @@
 extern int uv_bios_mq_watchlist_free(int, int);
 extern s64 uv_bios_change_memprotect(u64, u64, enum uv_memprotect);
 extern s64 uv_bios_reserved_page_pa(u64, u64 *, u64 *, u64 *);
+extern int uv_bios_set_legacy_vga_target(bool decode, int domain, int bus);
 
 extern void uv_bios_init(void);
 
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -20,6 +20,7 @@
 #include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/pci.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
@@ -34,6 +35,8 @@
 
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
+#define PR_DEVEL(fmt, args...)	pr_devel("%s: " fmt, __func__, args)
+
 static enum uv_system_type uv_system_type;
 static u64 gru_start_paddr, gru_end_paddr;
 int uv_min_hub_revision_id;
@@ -557,6 +560,30 @@
 
 #endif /* !CONFIG_HOTPLUG_CPU */
 
+/* Direct Legacy VGA I/O traffic to designated IOH */
+int uv_set_vga_state(struct pci_dev *pdev, bool decode,
+		      unsigned int command_bits, bool change_bridge)
+{
+	int domain, bus, rc;
+
+	PR_DEVEL("devfn %x decode %d cmd %x chg_brdg %d\n",
+			pdev->devfn, decode, command_bits, change_bridge);
+
+	if (!change_bridge)
+		return 0;
+
+	if ((command_bits & PCI_COMMAND_IO) == 0)
+		return 0;
+
+	domain = pci_domain_nr(pdev->bus);
+	bus = pdev->bus->number;
+
+	rc = uv_bios_set_legacy_vga_target(decode, domain, bus);
+	PR_DEVEL("vga decode %d %x:%x, rc: %d\n", decode, domain, bus, rc);
+
+	return rc;
+}
+
 /*
  * Called on each cpu to initialize the per_cpu UV data area.
  * FIXME: hotplug not supported yet
@@ -717,4 +744,7 @@
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
 	proc_mkdir("sgi_uv", NULL);
+
+	/* register Legacy VGA I/O redirection handler */
+	pci_register_set_vga_state(uv_set_vga_state);
 }
--- linux.orig/arch/x86/kernel/bios_uv.c
+++ linux/arch/x86/kernel/bios_uv.c
@@ -163,6 +163,25 @@
 }
 EXPORT_SYMBOL_GPL(uv_bios_freq_base);
 
+/*
+ * uv_bios_set_legacy_vga_target - Set Legacy VGA I/O Target
+ * @decode: true to enable target, false to disable target
+ * @domain: PCI domain number
+ * @bus: PCI bus number
+ *
+ * Returns:
+ *    0: Success
+ *    -EINVAL: Invalid domain or bus number
+ *    -ENOSYS: Capability not available
+ *    -EBUSY: Legacy VGA I/O cannot be retargeted at this time
+ */
+int uv_bios_set_legacy_vga_target(bool decode, int domain, int bus)
+{
+	return uv_bios_call(UV_BIOS_SET_LEGACY_VGA_TARGET,
+				(u64)decode, (u64)domain, (u64)bus, 0, 0);
+}
+EXPORT_SYMBOL_GPL(uv_bios_set_legacy_vga_target);
+
 
 #ifdef CONFIG_EFI
 void uv_bios_init(void)

-- 
