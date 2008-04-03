Return-Path: <linux-kernel-owner+w=401wt.eu-S1762789AbYDCThq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762789AbYDCThq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760999AbYDCTdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:10 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53025
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760318AbYDCTc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:58 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 19/35] x86: KVM guest: add basic paravirt support
Date: Thu,  3 Apr 2008 22:32:34 +0300
Message-Id: <1207251170-5013-20-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Add basic KVM paravirt support. Avoid vm-exits on IO delays.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/Kconfig           |    8 ++++++
 arch/x86/kernel/Makefile   |    1 +
 arch/x86/kernel/kvm.c      |   52 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup_32.c |    1 +
 arch/x86/kernel/setup_64.c |    2 +
 include/linux/kvm_para.h   |    6 +++++
 6 files changed, 70 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/kvm.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e59ea05..75d2700 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -381,6 +381,14 @@ config KVM_CLOCK
 	  provides the guest with timing infrastructure such as time of day, and
 	  system time
 
+config KVM_GUEST
+	bool "KVM Guest support"
+	select PARAVIRT
+	depends on !(X86_VISWS || X86_VOYAGER)
+	help
+	 This option enables various optimizations for running under the KVM
+	 hypervisor.
+
 source "arch/x86/lguest/Kconfig"
 
 config PARAVIRT
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index a3379a3..1cc9d42 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
+obj-$(CONFIG_KVM_GUEST)		+= kvm.o
 obj-$(CONFIG_KVM_CLOCK)		+= kvmclock.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
new file mode 100644
index 0000000..a8e36da
--- /dev/null
+++ b/arch/x86/kernel/kvm.c
@@ -0,0 +1,52 @@
+/*
+ * KVM paravirt_ops implementation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright (C) 2007, Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ * Copyright IBM Corporation, 2007
+ *   Authors: Anthony Liguori <aliguori@us.ibm.com>
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/kvm_para.h>
+#include <linux/cpu.h>
+#include <linux/mm.h>
+
+/*
+ * No need for any "IO delay" on KVM
+ */
+static void kvm_io_delay(void)
+{
+}
+
+static void paravirt_ops_setup(void)
+{
+	pv_info.name = "KVM";
+	pv_info.paravirt_enabled = 1;
+
+	if (kvm_para_has_feature(KVM_FEATURE_NOP_IO_DELAY))
+		pv_cpu_ops.io_delay = kvm_io_delay;
+
+}
+
+void __init kvm_guest_init(void)
+{
+	if (!kvm_para_available())
+		return;
+
+	paravirt_ops_setup();
+}
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 3ef92a2..65f3a23 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -782,6 +782,7 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	vmi_init();
 #endif
+	kvm_guest_init();
 
 	/*
 	 * NOTE: before this point _nobody_ is allowed to allocate
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 26b676f..10a8ff5 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -452,6 +452,8 @@ void __init setup_arch(char **cmdline_p)
 	init_apic_mappings();
 	ioapic_init_mappings();
 
+	kvm_guest_init();
+
 	/*
 	 * We trust e820 completely. No explicit ROM probing in memory.
 	 */
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index 5497aac..9c462c9 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -20,6 +20,12 @@
 #include <asm/kvm_para.h>
 
 #ifdef __KERNEL__
+#ifdef CONFIG_KVM_GUEST
+void __init kvm_guest_init(void);
+#else
+#define kvm_guest_init() do { } while (0)
+#endif
+
 static inline int kvm_para_has_feature(unsigned int feature)
 {
 	if (kvm_arch_para_features() & (1UL << feature))
-- 
1.5.4.5

