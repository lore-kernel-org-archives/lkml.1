Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYLHLoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYLHLoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYLHLh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48280 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbYLHLhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:06 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 40/45] KVM: ppc: combine booke_guest.c and booke_host.c
Date: Mon,  8 Dec 2008 13:36:51 +0200
Message-Id: <1228736216-15787-41-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

The division was somewhat artificial and cumbersome, and had no functional
benefit anyways: we can only guests built for the real host processor.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/Kconfig                    |    6 +-
 arch/powerpc/kvm/Makefile                   |    6 +-
 arch/powerpc/kvm/{booke_guest.c => booke.c} |   60 +++++++++++++++++++
 arch/powerpc/kvm/booke_host.c               |   83 ---------------------------
 4 files changed, 66 insertions(+), 89 deletions(-)
 rename arch/powerpc/kvm/{booke_guest.c => booke.c} (90%)
 delete mode 100644 arch/powerpc/kvm/booke_host.c

diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 53aaa66..ffed96f 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -20,7 +20,7 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	# We can only run on Book E hosts so far
-	select KVM_BOOKE_HOST
+	select KVM_BOOKE
 	---help---
 	  Support hosting virtualized guest machines. You will also
 	  need to select one or more of the processor modules below.
@@ -30,8 +30,8 @@ config KVM
 
 	  If unsure, say N.
 
-config KVM_BOOKE_HOST
-	bool "KVM host support for Book E PowerPC processors"
+config KVM_BOOKE
+	bool "KVM support for Book E PowerPC processors"
 	depends on KVM && 44x
 	---help---
 	  Provides host support for KVM on Book E PowerPC processors. Currently
diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index 2a5d439..a7f8574 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -8,10 +8,10 @@ common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
 
 common-objs-$(CONFIG_KVM_TRACE)  += $(addprefix ../../../virt/kvm/, kvm_trace.o)
 
-kvm-objs := $(common-objs-y) powerpc.o emulate.o booke_guest.o
+kvm-objs := $(common-objs-y) powerpc.o emulate.o
 obj-$(CONFIG_KVM) += kvm.o
 
 AFLAGS_booke_interrupts.o := -I$(obj)
 
-kvm-booke-host-objs := booke_host.o booke_interrupts.o 44x_tlb.o
-obj-$(CONFIG_KVM_BOOKE_HOST) += kvm-booke-host.o
+kvm-booke-objs := booke.o booke_interrupts.o 44x_tlb.o
+obj-$(CONFIG_KVM_BOOKE) += kvm-booke.o
diff --git a/arch/powerpc/kvm/booke_guest.c b/arch/powerpc/kvm/booke.c
similarity index 90%
rename from arch/powerpc/kvm/booke_guest.c
rename to arch/powerpc/kvm/booke.c
index 41bbf4c..b1e90a1 100644
--- a/arch/powerpc/kvm/booke_guest.c
+++ b/arch/powerpc/kvm/booke.c
@@ -27,9 +27,12 @@
 #include <asm/cputable.h>
 #include <asm/uaccess.h>
 #include <asm/kvm_ppc.h>
+#include <asm/cacheflush.h>
 
 #include "44x_tlb.h"
 
+unsigned long kvmppc_booke_handlers;
+
 #define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
 #define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
 
@@ -577,3 +580,60 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 
 	return 0;
 }
+
+static int kvmppc_booke_init(void)
+{
+	unsigned long ivor[16];
+	unsigned long max_ivor = 0;
+	int i;
+
+	/* We install our own exception handlers by hijacking IVPR. IVPR must
+	 * be 16-bit aligned, so we need a 64KB allocation. */
+	kvmppc_booke_handlers = __get_free_pages(GFP_KERNEL | __GFP_ZERO,
+	                                         VCPU_SIZE_ORDER);
+	if (!kvmppc_booke_handlers)
+		return -ENOMEM;
+
+	/* XXX make sure our handlers are smaller than Linux's */
+
+	/* Copy our interrupt handlers to match host IVORs. That way we don't
+	 * have to swap the IVORs on every guest/host transition. */
+	ivor[0] = mfspr(SPRN_IVOR0);
+	ivor[1] = mfspr(SPRN_IVOR1);
+	ivor[2] = mfspr(SPRN_IVOR2);
+	ivor[3] = mfspr(SPRN_IVOR3);
+	ivor[4] = mfspr(SPRN_IVOR4);
+	ivor[5] = mfspr(SPRN_IVOR5);
+	ivor[6] = mfspr(SPRN_IVOR6);
+	ivor[7] = mfspr(SPRN_IVOR7);
+	ivor[8] = mfspr(SPRN_IVOR8);
+	ivor[9] = mfspr(SPRN_IVOR9);
+	ivor[10] = mfspr(SPRN_IVOR10);
+	ivor[11] = mfspr(SPRN_IVOR11);
+	ivor[12] = mfspr(SPRN_IVOR12);
+	ivor[13] = mfspr(SPRN_IVOR13);
+	ivor[14] = mfspr(SPRN_IVOR14);
+	ivor[15] = mfspr(SPRN_IVOR15);
+
+	for (i = 0; i < 16; i++) {
+		if (ivor[i] > max_ivor)
+			max_ivor = ivor[i];
+
+		memcpy((void *)kvmppc_booke_handlers + ivor[i],
+		       kvmppc_handlers_start + i * kvmppc_handler_len,
+		       kvmppc_handler_len);
+	}
+	flush_icache_range(kvmppc_booke_handlers,
+	                   kvmppc_booke_handlers + max_ivor + kvmppc_handler_len);
+
+	return kvm_init(NULL, sizeof(struct kvm_vcpu), THIS_MODULE);
+}
+
+static void __exit kvmppc_booke_exit(void)
+{
+	free_pages(kvmppc_booke_handlers, VCPU_SIZE_ORDER);
+	kvm_exit();
+}
+
+module_init(kvmppc_booke_init)
+module_exit(kvmppc_booke_exit)
diff --git a/arch/powerpc/kvm/booke_host.c b/arch/powerpc/kvm/booke_host.c
deleted file mode 100644
index b480341..0000000
--- a/arch/powerpc/kvm/booke_host.c
+++ /dev/null
@@ -1,83 +0,0 @@
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License, version 2, as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
- *
- * Copyright IBM Corp. 2008
- *
- * Authors: Hollis Blanchard <hollisb@us.ibm.com>
- */
-
-#include <linux/errno.h>
-#include <linux/kvm_host.h>
-#include <linux/module.h>
-#include <asm/cacheflush.h>
-#include <asm/kvm_ppc.h>
-
-unsigned long kvmppc_booke_handlers;
-
-static int kvmppc_booke_init(void)
-{
-	unsigned long ivor[16];
-	unsigned long max_ivor = 0;
-	int i;
-
-	/* We install our own exception handlers by hijacking IVPR. IVPR must
-	 * be 16-bit aligned, so we need a 64KB allocation. */
-	kvmppc_booke_handlers = __get_free_pages(GFP_KERNEL | __GFP_ZERO,
-	                                         VCPU_SIZE_ORDER);
-	if (!kvmppc_booke_handlers)
-		return -ENOMEM;
-
-	/* XXX make sure our handlers are smaller than Linux's */
-
-	/* Copy our interrupt handlers to match host IVORs. That way we don't
-	 * have to swap the IVORs on every guest/host transition. */
-	ivor[0] = mfspr(SPRN_IVOR0);
-	ivor[1] = mfspr(SPRN_IVOR1);
-	ivor[2] = mfspr(SPRN_IVOR2);
-	ivor[3] = mfspr(SPRN_IVOR3);
-	ivor[4] = mfspr(SPRN_IVOR4);
-	ivor[5] = mfspr(SPRN_IVOR5);
-	ivor[6] = mfspr(SPRN_IVOR6);
-	ivor[7] = mfspr(SPRN_IVOR7);
-	ivor[8] = mfspr(SPRN_IVOR8);
-	ivor[9] = mfspr(SPRN_IVOR9);
-	ivor[10] = mfspr(SPRN_IVOR10);
-	ivor[11] = mfspr(SPRN_IVOR11);
-	ivor[12] = mfspr(SPRN_IVOR12);
-	ivor[13] = mfspr(SPRN_IVOR13);
-	ivor[14] = mfspr(SPRN_IVOR14);
-	ivor[15] = mfspr(SPRN_IVOR15);
-
-	for (i = 0; i < 16; i++) {
-		if (ivor[i] > max_ivor)
-			max_ivor = ivor[i];
-
-		memcpy((void *)kvmppc_booke_handlers + ivor[i],
-		       kvmppc_handlers_start + i * kvmppc_handler_len,
-		       kvmppc_handler_len);
-	}
-	flush_icache_range(kvmppc_booke_handlers,
-	                   kvmppc_booke_handlers + max_ivor + kvmppc_handler_len);
-
-	return kvm_init(NULL, sizeof(struct kvm_vcpu), THIS_MODULE);
-}
-
-static void __exit kvmppc_booke_exit(void)
-{
-	free_pages(kvmppc_booke_handlers, VCPU_SIZE_ORDER);
-	kvm_exit();
-}
-
-module_init(kvmppc_booke_init)
-module_exit(kvmppc_booke_exit)
-- 
1.6.0.3

