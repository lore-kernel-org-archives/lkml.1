Return-Path: <linux-kernel-owner+w=401wt.eu-S1763538AbZB1CF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763538AbZB1CF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760513AbZB1B7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:59:41 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:59191
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757291AbZB1B7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:59:32 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH] xen/dom0: add XEN_DOM0 config option
Date: Fri, 27 Feb 2009 17:59:19 -0800
Message-Id: <1235786365-17744-14-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235786365-17744-1-git-send-email-jeremy@goop.org>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow dom0 to be configured.  Requires more patches to do something useful.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Kconfig     |   26 ++++++++++++++++++++++++++
 arch/x86/xen/enlighten.c |    5 +++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 87b9ab1..e5c141a 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -36,3 +36,29 @@ config XEN_DEBUG_FS
 	help
 	  Enable statistics output and various tuning options in debugfs.
 	  Enabling this option may incur a significant performance overhead.
+
+config XEN_DOM0
+	bool "Enable Xen privileged domain support"
+	depends on XEN && X86_IO_APIC && ACPI
+	help
+	  The Xen hypervisor requires a privileged domain ("dom0") to
+	  actually manage the machine, provide devices drivers, etc.
+	  This option enables dom0 support.  A dom0 kernel can also
+	  run as an unprivileged domU kernel, or a kernel running
+	  native on bare hardware.
+
+# Dummy symbol since people have come to rely on the PRIVILEGED_GUEST
+# name in tools.
+config XEN_PRIVILEGED_GUEST
+	def_bool XEN_DOM0
+
+config XEN_PCI_PASSTHROUGH
+       bool #"Enable support for Xen PCI passthrough devices"
+       depends on XEN && PCI
+       help
+         Enable support for passing PCI devices through to
+	 unprivileged domains. (COMPLETELY UNTESTED)
+
+config XEN_DOM0_PCI
+       def_bool y
+       depends on XEN_DOM0 && PCI
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 62d229a..676aaf8 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -169,9 +169,10 @@ static void __init xen_banner(void)
 
 	printk(KERN_INFO "Booting paravirtualized kernel on %s\n",
 	       pv_info.name);
-	printk(KERN_INFO "Xen version: %d.%d%s%s\n",
+	printk(KERN_INFO "Xen version: %d.%d%s%s%s\n",
 	       version >> 16, version & 0xffff, extra.extraversion,
-	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "");
+	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "",
+	       xen_initial_domain() ? " (dom0)" : "");
 }
 
 static void xen_cpuid(unsigned int *ax, unsigned int *bx,
-- 
1.6.0.6

