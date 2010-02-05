Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095Ab0BEW7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 17:59:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:58867 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934061Ab0BEW7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:59:12 -0500
Date: Fri, 5 Feb 2010 22:57:51 GMT
From: tip-bot for Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       travis@sgi.com, holt@sgi.com, airlied@linux.ie,
       akpm@linux-foundation.org, steiner@sgi.com, jbarnes@virtuousgeek.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       travis@sgi.com, holt@sgi.com, airlied@linux.ie,
       jbarnes@virtuousgeek.org, akpm@linux-foundation.org, steiner@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <201002022238.o12McEbi018727@imap1.linux-foundation.org>
References: <201002022238.o12McEbi018727@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pci] x86, uv: Update UV arch to target Legacy VGA I/O correctly.
Message-ID: <tip-841582ea9e29a8f757c30c5377ce649586ba793a@git.kernel.org>
Git-Commit-ID: 841582ea9e29a8f757c30c5377ce649586ba793a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Feb 2010 22:57:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  841582ea9e29a8f757c30c5377ce649586ba793a
Gitweb:     http://git.kernel.org/tip/841582ea9e29a8f757c30c5377ce649586ba793a
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Tue, 2 Feb 2010 14:38:14 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 5 Feb 2010 14:05:41 -0800

x86, uv: Update UV arch to target Legacy VGA I/O correctly.

Add function to direct Legacy VGA I/O traffic to correct I/O Hub.

Signed-off-by: Mike Travis <travis@sgi.com>
LKML-Reference: <201002022238.o12McEbi018727@imap1.linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/uv/bios.h     |    4 +++-
 arch/x86/kernel/apic/x2apic_uv_x.c |   30 ++++++++++++++++++++++++++++++
 arch/x86/kernel/bios_uv.c          |   19 +++++++++++++++++++
 3 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/uv/bios.h b/arch/x86/include/asm/uv/bios.h
index 2751f30..1634275 100644
--- a/arch/x86/include/asm/uv/bios.h
+++ b/arch/x86/include/asm/uv/bios.h
@@ -36,7 +36,8 @@ enum uv_bios_cmd {
 	UV_BIOS_WATCHLIST_ALLOC,
 	UV_BIOS_WATCHLIST_FREE,
 	UV_BIOS_MEMPROTECT,
-	UV_BIOS_GET_PARTITION_ADDR
+	UV_BIOS_GET_PARTITION_ADDR,
+	UV_BIOS_SET_LEGACY_VGA_TARGET
 };
 
 /*
@@ -96,6 +97,7 @@ extern int uv_bios_mq_watchlist_alloc(unsigned long, unsigned int,
 extern int uv_bios_mq_watchlist_free(int, int);
 extern s64 uv_bios_change_memprotect(u64, u64, enum uv_memprotect);
 extern s64 uv_bios_reserved_page_pa(u64, u64 *, u64 *, u64 *);
+extern int uv_bios_set_legacy_vga_target(bool decode, int domain, int bus);
 
 extern void uv_bios_init(void);
 
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 21db3cb..6ef2899 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
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
@@ -553,6 +556,30 @@ late_initcall(uv_init_heartbeat);
 
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
@@ -691,4 +718,7 @@ void __init uv_system_init(void)
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
 	proc_mkdir("sgi_uv", NULL);
+
+	/* register Legacy VGA I/O redirection handler */
+	pci_register_set_vga_state(uv_set_vga_state);
 }
diff --git a/arch/x86/kernel/bios_uv.c b/arch/x86/kernel/bios_uv.c
index b0206a2..575127a 100644
--- a/arch/x86/kernel/bios_uv.c
+++ b/arch/x86/kernel/bios_uv.c
@@ -154,6 +154,25 @@ s64 uv_bios_freq_base(u64 clock_type, u64 *ticks_per_second)
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
