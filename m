Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbZBPXxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbZBPXxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbZBPXqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:46:33 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:50806
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753511AbZBPXqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:46:20 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 13/19] xen/dom0: add XEN_DOM0 config option
Date: Mon, 16 Feb 2009 15:46:07 -0800
Message-Id: <b4adea5f3e4c3ebba175f2344d138f85aa48dd57.1234826723.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <0b79be113b42a033f3b3ca4d4f3ca4035c8a7bf5.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <edde7fdd064390d321bdafcfb993b28b4d2588b1.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <9fbd402b72d6c494f453ff86e071ac1b2658ece9.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f47f399029ba9035a14ae381b6ae504a5c5bd445.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f1402ed2345e1d654faa823afefa53fc4745e368.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f0d2b3f946de1b3398c278c7a33069f670b78268.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <83b1377d81029933b769798dbe1ca134f6d365ae.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <630b678d3259163fc237f673b6f2a4a5fa76ac25.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <8349825a016bec5b8712940ad6f8c3f18f8003fb.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f156acbfffc23cccd71b71d36e6668c6c246f3b4.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f156acbfffc23cccd71b71d36e6668c6c246f3b4.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <e59d440a548af3d4e4bb483c73e24614a5b3af63.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <2fe9663efa1686898ebf9d28e911daac3185b6b7.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <0b79be113b42a033f3b3ca4d4f3ca4035c8a7bf5.1234826723.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
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

