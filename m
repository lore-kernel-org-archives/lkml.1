Return-Path: <linux-kernel-owner+w=401wt.eu-S1761418AbZE0HUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418AbZE0HUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758328AbZE0HRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:17:25 -0400
Received: from claw.goop.org ([74.207.240.146]:41470 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759762AbZE0HRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:17:25 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 12/16] xen/dom0: add XEN_DOM0 config option
Date: Wed, 27 May 2009 00:15:34 -0700
Message-Id: <1243408538-21100-13-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243408538-21100-1-git-send-email-jeremy@goop.org>
References: <1243408538-21100-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow dom0 to be configured.  Requires more patches to do something useful.
Also announce whether we're running dom0 as part of xen boot message.

[ Impact: add Kconfig to enable XEN_DOM0 ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Kconfig     |   26 ++++++++++++++++++++++++++
 arch/x86/xen/enlighten.c |    6 ++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

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
index 79b9b84..784971d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -172,9 +172,11 @@ static void __init xen_banner(void)
 
 	printk(KERN_INFO "Booting paravirtualized kernel on %s\n",
 	       pv_info.name);
-	printk(KERN_INFO "Xen version: %d.%d%s%s\n",
+	printk(KERN_INFO "Xen version: %d.%d%s%s%s\n",
 	       version >> 16, version & 0xffff, extra.extraversion,
-	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "");
+	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ?
+			" (preserve-AD)" : "",
+	       xen_initial_domain() ? " (dom0)" : "");
 }
 
 static __read_mostly unsigned int cpuid_leaf1_edx_mask = ~0;
-- 
1.6.0.6

