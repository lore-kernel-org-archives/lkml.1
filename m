Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbZFTSsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbZFTSsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757696AbZFTSqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:46:22 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48097 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757877AbZFTSqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:46:20 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Philippe Gerum <rpm@xenomai.org>
Subject: [PATCH 12/25] Blackfin: convert interrupt pipeline to irqflags
Date: Sat, 20 Jun 2009 14:44:35 -0400
Message-Id: <1245523488-26536-13-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/ipipe_base.h |   30 +++---
 arch/blackfin/include/asm/irq.h        |    7 --
 arch/blackfin/include/asm/irqflags.h   |  164 ++++++++++++++++++++++++++++++-
 arch/blackfin/include/asm/system.h     |    4 +-
 arch/blackfin/kernel/ipipe.c           |    2 +-
 5 files changed, 177 insertions(+), 30 deletions(-)

diff --git a/arch/blackfin/include/asm/ipipe_base.h b/arch/blackfin/include/asm/ipipe_base.h
index 3e8acbd..490098f 100644
--- a/arch/blackfin/include/asm/ipipe_base.h
+++ b/arch/blackfin/include/asm/ipipe_base.h
@@ -51,23 +51,23 @@
 
 extern unsigned long __ipipe_root_status; /* Alias to ipipe_root_cpudom_var(status) */
 
-static inline void __ipipe_stall_root(void)
-{
-	volatile unsigned long *p = &__ipipe_root_status;
-	set_bit(0, p);
-}
+#define __ipipe_stall_root()						\
+	do {								\
+		volatile unsigned long *p = &__ipipe_root_status;	\
+		set_bit(0, p);						\
+	} while (0)
 
-static inline unsigned long __ipipe_test_and_stall_root(void)
-{
-	volatile unsigned long *p = &__ipipe_root_status;
-	return test_and_set_bit(0, p);
-}
+#define __ipipe_test_and_stall_root()					\
+	({								\
+		volatile unsigned long *p = &__ipipe_root_status;	\
+		test_and_set_bit(0, p);					\
+	})
 
-static inline unsigned long __ipipe_test_root(void)
-{
-	const unsigned long *p = &__ipipe_root_status;
-	return test_bit(0, p);
-}
+#define __ipipe_test_root()					\
+	({							\
+		const unsigned long *p = &__ipipe_root_status;	\
+		test_bit(0, p);					\
+	})
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/blackfin/include/asm/irq.h b/arch/blackfin/include/asm/irq.h
index 9a7f63a..42a15f5 100644
--- a/arch/blackfin/include/asm/irq.h
+++ b/arch/blackfin/include/asm/irq.h
@@ -22,13 +22,6 @@
 /* SYS_IRQS and NR_IRQS are defined in <mach-bf5xx/irq.h> */
 #include <mach/irq.h>
 
-/* Xenomai IPIPE helpers */
-#define local_irq_restore_hw(x) local_irq_restore(x)
-#define local_irq_save_hw(x)    local_irq_save(x)
-#define local_irq_enable_hw(x)  local_irq_enable(x)
-#define local_irq_disable_hw(x) local_irq_disable(x)
-#define irqs_disabled_hw(x)     irqs_disabled(x)
-
 #if ANOMALY_05000244 && defined(CONFIG_BFIN_ICACHE)
 # define NOP_PAD_ANOMALY_05000244 "nop; nop;"
 #else
diff --git a/arch/blackfin/include/asm/irqflags.h b/arch/blackfin/include/asm/irqflags.h
index 139cba4..9b19a19 100644
--- a/arch/blackfin/include/asm/irqflags.h
+++ b/arch/blackfin/include/asm/irqflags.h
@@ -31,6 +31,150 @@ static inline unsigned long bfin_cli(void)
 	return flags;
 }
 
+#ifdef CONFIG_IPIPE
+
+#include <linux/ipipe_base.h>
+#include <linux/ipipe_trace.h>
+
+#ifdef CONFIG_DEBUG_HWERR
+# define bfin_no_irqs 0x3f
+#else
+# define bfin_no_irqs 0x1f
+#endif
+
+#define raw_local_irq_disable()				\
+	do {						\
+		ipipe_check_context(ipipe_root_domain);	\
+		__ipipe_stall_root();			\
+		barrier();				\
+	} while (0)
+
+static inline void raw_local_irq_enable(void)
+{
+	barrier();
+	ipipe_check_context(ipipe_root_domain);
+	__ipipe_unstall_root();
+}
+
+#define raw_local_save_flags_ptr(x)					\
+	do {								\
+		*(x) = __ipipe_test_root() ? bfin_no_irqs : bfin_irq_flags; \
+	} while (0)
+
+#define raw_local_save_flags(x)		raw_local_save_flags_ptr(&(x))
+
+#define raw_irqs_disabled_flags(x)	((x) == bfin_no_irqs)
+
+#define raw_local_irq_save_ptr(x)					\
+	do {								\
+		*(x) = __ipipe_test_and_stall_root() ? bfin_no_irqs : bfin_irq_flags; \
+		barrier();						\
+	} while (0)
+
+#define raw_local_irq_save(x)				\
+	do {						\
+		ipipe_check_context(ipipe_root_domain);	\
+		raw_local_irq_save_ptr(&(x));		\
+	} while (0)
+
+static inline unsigned long raw_mangle_irq_bits(int virt, unsigned long real)
+{
+	/*
+	 * Merge virtual and real interrupt mask bits into a single
+	 * 32bit word.
+	 */
+	return (real & ~(1 << 31)) | ((virt != 0) << 31);
+}
+
+static inline int raw_demangle_irq_bits(unsigned long *x)
+{
+	int virt = (*x & (1 << 31)) != 0;
+	*x &= ~(1L << 31);
+	return virt;
+}
+
+static inline void local_irq_disable_hw_notrace(void)
+{
+	bfin_cli();
+}
+
+static inline void local_irq_enable_hw_notrace(void)
+{
+	bfin_sti(bfin_irq_flags);
+}
+
+#define local_save_flags_hw(flags)			\
+	do {						\
+		(flags) = bfin_read_IMASK();		\
+	} while (0)
+
+#define irqs_disabled_flags_hw(flags) (((flags) & ~0x3f) == 0)
+
+#define irqs_disabled_hw()			\
+	({					\
+	unsigned long flags;			\
+	local_save_flags_hw(flags);		\
+	irqs_disabled_flags_hw(flags);		\
+	})
+
+static inline void local_irq_save_ptr_hw(unsigned long *flags)
+{
+	*flags = bfin_cli();
+#ifdef CONFIG_DEBUG_HWERR
+	bfin_sti(0x3f);
+#endif
+}
+
+#define local_irq_save_hw_notrace(flags)		\
+	do {						\
+		local_irq_save_ptr_hw(&(flags));	\
+	} while (0)
+
+static inline void local_irq_restore_hw_notrace(unsigned long flags)
+{
+	if (!irqs_disabled_flags_hw(flags))
+		local_irq_enable_hw_notrace();
+}
+
+#ifdef CONFIG_IPIPE_TRACE_IRQSOFF
+# define local_irq_disable_hw()				\
+	do {						\
+		if (!irqs_disabled_hw()) {		\
+			local_irq_disable_hw_notrace();	\
+			ipipe_trace_begin(0x80000000);	\
+		}					\
+	} while (0)
+# define local_irq_enable_hw()				\
+	do {						\
+		if (irqs_disabled_hw()) {		\
+			ipipe_trace_end(0x80000000);	\
+			local_irq_enable_hw_notrace();	\
+		}					\
+	} while (0)
+# define local_irq_save_hw(flags)			\
+	do {						\
+		local_save_flags_hw(flags);		\
+		if (!irqs_disabled_flags_hw(flags)) {	\
+			local_irq_disable_hw_notrace();	\
+			ipipe_trace_begin(0x80000001);	\
+		}					\
+	} while (0)
+# define local_irq_restore_hw(flags)			\
+	do {						\
+		if (!irqs_disabled_flags_hw(flags)) {	\
+			ipipe_trace_end(0x80000001);	\
+			local_irq_enable_hw_notrace();	\
+		}					\
+	} while (0)
+#else /* !CONFIG_IPIPE_TRACE_IRQSOFF */
+# define local_irq_disable_hw()		local_irq_disable_hw_notrace()
+# define local_irq_enable_hw()		local_irq_enable_hw_notrace()
+# define local_irq_save_hw(flags)	local_irq_save_hw_notrace(flags)
+# define local_irq_restore_hw(flags)	local_irq_restore_hw_notrace(flags)
+#endif /* !CONFIG_IPIPE_TRACE_IRQSOFF */
+
+#else /* CONFIG_IPIPE */
+
 static inline void raw_local_irq_disable(void)
 {
 	bfin_cli();
@@ -44,12 +188,6 @@ static inline void raw_local_irq_enable(void)
 
 #define raw_irqs_disabled_flags(flags) (((flags) & ~0x3f) == 0)
 
-static inline void raw_local_irq_restore(unsigned long flags)
-{
-	if (!raw_irqs_disabled_flags(flags))
-		raw_local_irq_enable();
-}
-
 static inline unsigned long __raw_local_irq_save(void)
 {
 	unsigned long flags = bfin_cli();
@@ -60,4 +198,18 @@ static inline unsigned long __raw_local_irq_save(void)
 }
 #define raw_local_irq_save(flags) do { (flags) = __raw_local_irq_save(); } while (0)
 
+#define local_irq_save_hw(flags)	raw_local_irq_save(flags)
+#define local_irq_restore_hw(flags)	raw_local_irq_restore(flags)
+#define local_irq_enable_hw()		raw_local_irq_enable()
+#define local_irq_disable_hw()		raw_local_irq_disable()
+#define irqs_disabled_hw()		irqs_disabled()
+
+#endif /* !CONFIG_IPIPE */
+
+static inline void raw_local_irq_restore(unsigned long flags)
+{
+	if (!raw_irqs_disabled_flags(flags))
+		raw_local_irq_enable();
+}
+
 #endif
diff --git a/arch/blackfin/include/asm/system.h b/arch/blackfin/include/asm/system.h
index 294dbda..85e8f16 100644
--- a/arch/blackfin/include/asm/system.h
+++ b/arch/blackfin/include/asm/system.h
@@ -135,11 +135,13 @@ struct __xchg_dummy {
 };
 #define __xg(x) ((volatile struct __xchg_dummy *)(x))
 
+#include <mach/blackfin.h>
+
 static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
 				   int size)
 {
 	unsigned long tmp = 0;
-	unsigned long flags = 0;
+	unsigned long flags;
 
 	local_irq_save_hw(flags);
 
diff --git a/arch/blackfin/kernel/ipipe.c b/arch/blackfin/kernel/ipipe.c
index d8cde1f..2b979ed 100644
--- a/arch/blackfin/kernel/ipipe.c
+++ b/arch/blackfin/kernel/ipipe.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(__ipipe_freq_scale);
 
 atomic_t __ipipe_irq_lvdepth[IVG15 + 1];
 
-unsigned long __ipipe_irq_lvmask = __all_masked_irq_flags;
+unsigned long __ipipe_irq_lvmask = bfin_no_irqs;
 EXPORT_SYMBOL(__ipipe_irq_lvmask);
 
 static void __ipipe_ack_irq(unsigned irq, struct irq_desc *desc)
-- 
1.6.3.1

