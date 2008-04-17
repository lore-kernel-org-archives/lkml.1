Return-Path: <linux-kernel-owner+w=401wt.eu-S933293AbYDQJYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293AbYDQJYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763615AbYDQJLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:33 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59129
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763293AbYDQJLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:09 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 34/45] KVM: ia64: VMM module interfaces
Date: Thu, 17 Apr 2008 12:10:39 +0300
Message-Id: <1208423450-29415-35-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

vmm.c adds the interfaces with kvm/module, and initialize global data area.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/kvm/vmm.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100644 arch/ia64/kvm/vmm.c

diff --git a/arch/ia64/kvm/vmm.c b/arch/ia64/kvm/vmm.c
new file mode 100644
index 0000000..2275bf4
--- /dev/null
+++ b/arch/ia64/kvm/vmm.c
@@ -0,0 +1,66 @@
+/*
+ * vmm.c: vmm module interface with kvm module
+ *
+ * Copyright (c) 2007, Intel Corporation.
+ *
+ *  Xiantao Zhang (xiantao.zhang@intel.com)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ */
+
+
+#include<linux/module.h>
+#include<asm/fpswa.h>
+
+#include "vcpu.h"
+
+MODULE_AUTHOR("Intel");
+MODULE_LICENSE("GPL");
+
+extern char kvm_ia64_ivt;
+extern fpswa_interface_t *vmm_fpswa_interface;
+
+struct kvm_vmm_info vmm_info = {
+	.module	     = THIS_MODULE,
+	.vmm_entry   = vmm_entry,
+	.tramp_entry = vmm_trampoline,
+	.vmm_ivt     = (unsigned long)&kvm_ia64_ivt,
+};
+
+static int __init  kvm_vmm_init(void)
+{
+
+	vmm_fpswa_interface = fpswa_interface;
+
+	/*Register vmm data to kvm side*/
+	return kvm_init(&vmm_info, 1024, THIS_MODULE);
+}
+
+static void __exit kvm_vmm_exit(void)
+{
+	kvm_exit();
+	return ;
+}
+
+void vmm_spin_lock(spinlock_t *lock)
+{
+	_vmm_raw_spin_lock(lock);
+}
+
+void vmm_spin_unlock(spinlock_t *lock)
+{
+	_vmm_raw_spin_unlock(lock);
+}
+module_init(kvm_vmm_init)
+module_exit(kvm_vmm_exit)
-- 
1.5.5

