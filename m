Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbZEENZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbZEENZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbZEENY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:24:59 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45790 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZEENY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:24:57 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RFC PATCH 2/3] x86: add generic hypercall support
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com
Date: Tue, 05 May 2009 09:24:42 -0400
Message-ID: <20090505132442.19891.12762.stgit@dev.haskins.net>
In-Reply-To: <20090505132005.19891.78436.stgit@dev.haskins.net>
References: <20090505132005.19891.78436.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a hypercall() vector to x86 pv_cpu_ops to be optionally filled in
by a hypervisor driver as it loads its other pv_ops components.  We also
declare x86 as CONFIG_HAVE_HYPERCALL to enable the generic hypercall code
whenever the user builds for x86.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/Kconfig                     |    3 +++
 arch/x86/Kconfig                 |    1 +
 arch/x86/include/asm/paravirt.h  |   13 +++++++++++++
 arch/x86/include/asm/processor.h |    6 ++++++
 4 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 78a35e9..239b658 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -112,3 +112,6 @@ config HAVE_DMA_API_DEBUG
 
 config HAVE_DEFAULT_NO_SPIN_MUTEXES
 	bool
+
+config HAVE_HYPERCALL
+        bool
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index df9e885..3c609cf 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -46,6 +46,7 @@ config X86
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
+	select HAVE_HYPERCALL
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 378e369..ed22c84 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -6,6 +6,7 @@
 #ifdef CONFIG_PARAVIRT
 #include <asm/pgtable_types.h>
 #include <asm/asm.h>
+#include <asm/errno.h>
 
 /* Bitmask of what can be clobbered: usually at least eax. */
 #define CLBR_NONE 0
@@ -203,6 +204,8 @@ struct pv_cpu_ops {
 
 	void (*swapgs)(void);
 
+	long (*hypercall)(unsigned long nr, unsigned long *args, size_t count);
+
 	struct pv_lazy_ops lazy_mode;
 };
 
@@ -723,6 +726,16 @@ static inline void __cpuid(unsigned int *eax, unsigned int *ebx,
 	PVOP_VCALL4(pv_cpu_ops.cpuid, eax, ebx, ecx, edx);
 }
 
+static inline long hypercall(unsigned long nr,
+			     unsigned long *args,
+			     size_t count)
+{
+	if (!pv_cpu_ops.hypercall)
+		return -EINVAL;
+
+	return pv_cpu_ops.hypercall(nr, args, count);
+}
+
 /*
  * These special macros can be used to get or set a debugging register
  */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c2cceae..8fa988d 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -570,6 +570,12 @@ static inline void native_swapgs(void)
 #define __cpuid			native_cpuid
 #define paravirt_enabled()	0
 
+static inline long
+hypercall(unsigned long nr, unsigned long *args, size_t count)
+{
+	return -EINVAL;
+}
+
 /*
  * These special macros can be used to get or set a debugging register
  */

