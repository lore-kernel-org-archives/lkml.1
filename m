Return-Path: <linux-kernel-owner+w=401wt.eu-S1760602AbYGQQAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602AbYGQQAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757017AbYGQQAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:00:43 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58828 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756111AbYGQQAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:00:42 -0400
Message-Id: <20080717160003.148484591@polymtl.ca>
References: <20080717155724.897537670@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 11:57:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Avi Kivity <avi@qumranet.com>, kvm@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: [patch 3/4] KVM move register read-write to system headers
Content-Disposition: inline; filename=kvm-move-register-read-write-to-system-headers.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 17 Jul 2008 16:00:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed by kvm_tracer probes, which are outside of arch/x86/kvm.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: 'Feng(Eric) Liu' <eric.e.liu@intel.com>
CC: Avi Kivity <avi@qumranet.com>
CC: kvm@vger.kernel.org
---
 arch/x86/kvm/kvm_cache_regs.h    |   32 --------------------------------
 arch/x86/kvm/lapic.c             |    2 +-
 arch/x86/kvm/svm.c               |    2 +-
 arch/x86/kvm/vmx.c               |    2 +-
 arch/x86/kvm/x86.c               |    2 +-
 arch/x86/kvm/x86_emulate.c       |    2 +-
 include/asm-x86/kvm_cache_regs.h |   32 ++++++++++++++++++++++++++++++++
 7 files changed, 37 insertions(+), 37 deletions(-)

Index: linux-2.6-lttng/arch/x86/kvm/kvm_cache_regs.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kvm/kvm_cache_regs.h	2008-07-17 11:44:43.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,32 +0,0 @@
-#ifndef ASM_KVM_CACHE_REGS_H
-#define ASM_KVM_CACHE_REGS_H
-
-static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu,
-					      enum kvm_reg reg)
-{
-	if (!test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail))
-		kvm_x86_ops->cache_reg(vcpu, reg);
-
-	return vcpu->arch.regs[reg];
-}
-
-static inline void kvm_register_write(struct kvm_vcpu *vcpu,
-				      enum kvm_reg reg,
-				      unsigned long val)
-{
-	vcpu->arch.regs[reg] = val;
-	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
-	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
-}
-
-static inline unsigned long kvm_rip_read(struct kvm_vcpu *vcpu)
-{
-	return kvm_register_read(vcpu, VCPU_REGS_RIP);
-}
-
-static inline void kvm_rip_write(struct kvm_vcpu *vcpu, unsigned long val)
-{
-	kvm_register_write(vcpu, VCPU_REGS_RIP, val);
-}
-
-#endif
Index: linux-2.6-lttng/include/asm-x86/kvm_cache_regs.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-x86/kvm_cache_regs.h	2008-07-17 11:44:53.000000000 -0400
@@ -0,0 +1,32 @@
+#ifndef ASM_KVM_CACHE_REGS_H
+#define ASM_KVM_CACHE_REGS_H
+
+static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu,
+					      enum kvm_reg reg)
+{
+	if (!test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail))
+		kvm_x86_ops->cache_reg(vcpu, reg);
+
+	return vcpu->arch.regs[reg];
+}
+
+static inline void kvm_register_write(struct kvm_vcpu *vcpu,
+				      enum kvm_reg reg,
+				      unsigned long val)
+{
+	vcpu->arch.regs[reg] = val;
+	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
+	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+}
+
+static inline unsigned long kvm_rip_read(struct kvm_vcpu *vcpu)
+{
+	return kvm_register_read(vcpu, VCPU_REGS_RIP);
+}
+
+static inline void kvm_rip_write(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	kvm_register_write(vcpu, VCPU_REGS_RIP, val);
+}
+
+#endif
Index: linux-2.6-lttng/arch/x86/kvm/lapic.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kvm/lapic.c	2008-07-17 11:46:14.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kvm/lapic.c	2008-07-17 11:46:29.000000000 -0400
@@ -32,7 +32,7 @@
 #include <asm/current.h>
 #include <asm/apicdef.h>
 #include <asm/atomic.h>
-#include "kvm_cache_regs.h"
+#include <asm/kvm_cache_regs.h>
 #include "irq.h"
 
 #define PRId64 "d"
Index: linux-2.6-lttng/arch/x86/kvm/svm.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kvm/svm.c	2008-07-17 11:46:14.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kvm/svm.c	2008-07-17 11:46:47.000000000 -0400
@@ -18,7 +18,6 @@
 #include "kvm_svm.h"
 #include "irq.h"
 #include "mmu.h"
-#include "kvm_cache_regs.h"
 
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -26,6 +25,7 @@
 #include <linux/highmem.h>
 #include <linux/sched.h>
 
+#include <asm/kvm_cache_regs.h>
 #include <asm/desc.h>
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
Index: linux-2.6-lttng/arch/x86/kvm/vmx.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kvm/vmx.c	2008-07-17 11:46:14.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kvm/vmx.c	2008-07-17 11:47:04.000000000 -0400
@@ -26,9 +26,9 @@
 #include <linux/highmem.h>
 #include <linux/sched.h>
 #include <linux/moduleparam.h>
-#include "kvm_cache_regs.h"
 #include "x86.h"
 
+#include <asm/kvm_cache_regs.h>
 #include <asm/io.h>
 #include <asm/desc.h>
 
Index: linux-2.6-lttng/arch/x86/kvm/x86.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kvm/x86.c	2008-07-17 11:46:14.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kvm/x86.c	2008-07-17 11:47:12.000000000 -0400
@@ -19,7 +19,6 @@
 #include "mmu.h"
 #include "i8254.h"
 #include "tss.h"
-#include "kvm_cache_regs.h"
 #include "x86.h"
 
 #include <linux/clocksource.h>
@@ -30,6 +29,7 @@
 #include <linux/mman.h>
 #include <linux/highmem.h>
 
+#include <asm/kvm_cache_regs.h>
 #include <asm/uaccess.h>
 #include <asm/msr.h>
 #include <asm/desc.h>
Index: linux-2.6-lttng/arch/x86/kvm/x86_emulate.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kvm/x86_emulate.c	2008-07-17 11:46:14.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kvm/x86_emulate.c	2008-07-17 11:47:24.000000000 -0400
@@ -26,10 +26,10 @@
 #define DPRINTF(_f, _a ...) printf(_f , ## _a)
 #else
 #include <linux/kvm_host.h>
-#include "kvm_cache_regs.h"
 #define DPRINTF(x...) do {} while (0)
 #endif
 #include <linux/module.h>
+#include <asm/kvm_cache_regs.h>
 #include <asm/kvm_x86_emulate.h>
 
 /*

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
