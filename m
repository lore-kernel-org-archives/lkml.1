Return-Path: <linux-kernel-owner+w=401wt.eu-S1760576AbZCWSNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576AbZCWSNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760499AbZCWSKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:10:17 -0400
Received: from adsl-69-107-72-54.dsl.pltn13.pacbell.net ([69.107.72.54]:60889
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760561AbZCWSKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:10:09 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 12/15] xen/dom0: add XEN_DOM0 config option
Date: Mon, 23 Mar 2009 11:09:56 -0700
Message-Id: <1237831799-6568-13-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <49C45238.7050007@zytor.com>
References: <49C45238.7050007@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add Kconfig to enable XEN_DOM0

Allow dom0 to be configured.  Requires more patches to do something useful.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Kconfig     |   26 ++++++++++++++++++++++++++
 arch/x86/xen/enlighten.c |    5 +++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index b83e119..fe69286 100644
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
index 40a930b..213e1ba 100644
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
 
 static __read_mostly unsigned int cpuid_leaf1_edx_mask = ~0;
-- 
1.6.0.6

