Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbXH0PRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbXH0PRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbXH0PRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:17:14 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58118 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbXH0PRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:17:13 -0400
From: Anthony Liguori <aliguori@us.ibm.com>
To: kvm-devel@lists.sourceforge.net
Cc: Anthony Liguori <aliguori@us.ibm.com>, Avi Kivity <avi@qumranet.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM paravirt-ops implementation
Date: Mon, 27 Aug 2007 10:16:46 -0500
Message-Id: <11882278093751-git-send-email-aliguori@us.ibm.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <11882278082826-git-send-email-aliguori@us.ibm.com>
References: <11882278064002-git-send-email-aliguori@us.ibm.com>
 <1188227808405-git-send-email-aliguori@us.ibm.com>
 <11882278082826-git-send-email-aliguori@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index f952493..ceacc66 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -237,6 +237,13 @@ config VMI
 	  at the moment), by linking the kernel to a GPL-ed ROM module
 	  provided by the hypervisor.
 
+config KVM_GUEST
+	bool "KVM paravirt-ops support"
+	depends on PARAVIRT
+	help
+	  This option enables various optimizations for running under the KVM
+          hypervisor.
+
 config ACPI_SRAT
 	bool
 	default y
diff --git a/arch/i386/kernel/Makefile b/arch/i386/kernel/Makefile
index 9d33b00..6308fcf 100644
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_MGEODE_LX)		+= geode.o
 
 obj-$(CONFIG_VMI)		+= vmi.o vmiclock.o
+obj-$(CONFIG_KVM_GUEST)		+= kvm.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 obj-y				+= pcspeaker.o
 
diff --git a/arch/i386/kernel/kvm.c b/arch/i386/kernel/kvm.c
new file mode 100644
index 0000000..26585a4
--- /dev/null
+++ b/arch/i386/kernel/kvm.c
@@ -0,0 +1,46 @@
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
+ * Copyright IBM Corporation, 2007
+ *   Authors: Anthony Liguori <aliguori@us.ibm.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/kvm_para.h>
+
+/*
+ * No need for any "IO delay" on KVM
+ */
+static void kvm_io_delay(void)
+{
+}
+
+static __init void paravirt_setup(void)
+{
+	paravirt_ops.name = "KVM";
+
+	if (kvm_para_has_feature(KVM_PARA_FEATURE_NOP_IO_DELAY))
+		paravirt_ops.io_delay = kvm_io_delay;
+
+	paravirt_ops.paravirt_enabled = 1;
+}
+
+void __init kvm_guest_init(void)
+{
+	if (kvm_para_available())
+		paravirt_setup();
+}
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index e92ea3e..16e51a1 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -3,6 +3,14 @@
 
 #include <asm/processor.h>
 
+#ifdef CONFIG_KVM_GUEST
+void __init kvm_guest_init(void);
+#else
+static inline void kvm_guest_init(void)
+{
+}
+#endif
+
 #define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"
 
 static inline long kvm_hypercall0(unsigned int nr)
diff --git a/init/main.c b/init/main.c
index d3bcb3b..b224905 100644
--- a/init/main.c
+++ b/init/main.c
@@ -55,6 +55,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
+#include <linux/kvm_para.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -569,6 +570,7 @@ asmlinkage void __init start_kernel(void)
 	}
 	sort_main_extable();
 	trap_init();
+	kvm_guest_init();
 	rcu_init();
 	init_IRQ();
 	pidhash_init();
