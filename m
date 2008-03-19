Return-Path: <linux-kernel-owner+w=401wt.eu-S1759797AbYCSU1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797AbYCSU1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbYCSTjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229AbYCSTjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:39:11 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 41/79] [PATCH] unify nmi_32.h and nmi_64.h
Date: Wed, 19 Mar 2008 14:25:36 -0300
Message-Id: <12059477611736-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059477561937-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

Two more files goes away. nmi_64.h and nmi_32.h gives birth
to nmi.h

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/nmi_32.c |    2 +-
 include/asm-x86/nmi.h    |   92 ++++++++++++++++++++++++++++++++++++++++++++-
 include/asm-x86/nmi_32.h |   61 ------------------------------
 include/asm-x86/nmi_64.h |   88 --------------------------------------------
 4 files changed, 90 insertions(+), 153 deletions(-)
 delete mode 100644 include/asm-x86/nmi_32.h
 delete mode 100644 include/asm-x86/nmi_64.h

diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index aa6800f..daea273 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -67,7 +67,7 @@ static __init void nmi_cpu_busy(void *data)
 }
 #endif
 
-static int __init check_nmi_watchdog(void)
+int __init check_nmi_watchdog(void)
 {
 	unsigned int *prev_nmi_count;
 	int cpu;
diff --git a/include/asm-x86/nmi.h b/include/asm-x86/nmi.h
index 53ccac1..2b94199 100644
--- a/include/asm-x86/nmi.h
+++ b/include/asm-x86/nmi.h
@@ -1,5 +1,91 @@
-#ifdef CONFIG_X86_32
-# include "nmi_32.h"
+#ifndef _ASM_X86_NMI_H_
+#define _ASM_X86_NMI_H_
+
+#include <linux/pm.h>
+#include <asm/irq.h>
+#include <asm/io.h>
+
+#ifdef ARCH_HAS_NMI_WATCHDOG
+
+/**
+ * do_nmi_callback
+ *
+ * Check to see if a callback exists and execute it.  Return 1
+ * if the handler exists and was handled successfully.
+ */
+int do_nmi_callback(struct pt_regs *regs, int cpu);
+
+#ifdef CONFIG_PM
+
+/** Replace the PM callback routine for NMI. */
+struct pm_dev *set_nmi_pm_callback(pm_callback callback);
+
+/** Unset the PM callback routine back to the default. */
+void unset_nmi_pm_callback(struct pm_dev *dev);
+
 #else
-# include "nmi_64.h"
+
+static inline struct pm_dev *set_nmi_pm_callback(pm_callback callback)
+{
+	return 0;
+}
+
+static inline void unset_nmi_pm_callback(struct pm_dev *dev)
+{
+}
+
+#endif /* CONFIG_PM */
+
+#ifdef CONFIG_X86_64
+extern void default_do_nmi(struct pt_regs *);
+extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
+#endif
+
+extern int check_nmi_watchdog(void);
+extern int nmi_watchdog_enabled;
+extern int unknown_nmi_panic;
+extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
+extern int avail_to_resrv_perfctr_nmi(unsigned int);
+extern int reserve_perfctr_nmi(unsigned int);
+extern void release_perfctr_nmi(unsigned int);
+extern int reserve_evntsel_nmi(unsigned int);
+extern void release_evntsel_nmi(unsigned int);
+extern void nmi_watchdog_default(void);
+
+extern void setup_apic_nmi_watchdog(void *);
+extern void stop_apic_nmi_watchdog(void *);
+extern void disable_timer_nmi_watchdog(void);
+extern void enable_timer_nmi_watchdog(void);
+extern int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason);
+
+extern atomic_t nmi_active;
+extern unsigned int nmi_watchdog;
+#define NMI_DISABLED    -1
+#define NMI_NONE	0
+#define NMI_IO_APIC	1
+#define NMI_LOCAL_APIC	2
+#define NMI_INVALID	3
+#define NMI_DEFAULT	NMI_DISABLED
+
+struct ctl_table;
+struct file;
+extern int proc_nmi_enabled(struct ctl_table *, int , struct file *,
+			void __user *, size_t *, loff_t *);
+extern int unknown_nmi_panic;
+
+void __trigger_all_cpu_backtrace(void);
+#define trigger_all_cpu_backtrace() __trigger_all_cpu_backtrace()
+
+#endif
+
+void lapic_watchdog_stop(void);
+int lapic_watchdog_init(unsigned nmi_hz);
+int lapic_wd_event(unsigned nmi_hz);
+unsigned lapic_adjust_nmi_hz(unsigned hz);
+int lapic_watchdog_ok(void);
+void disable_lapic_nmi_watchdog(void);
+void enable_lapic_nmi_watchdog(void);
+void stop_nmi(void);
+void restart_nmi(void);
+
 #endif
diff --git a/include/asm-x86/nmi_32.h b/include/asm-x86/nmi_32.h
deleted file mode 100644
index 7206c7e..0000000
--- a/include/asm-x86/nmi_32.h
+++ /dev/null
@@ -1,61 +0,0 @@
-#ifndef ASM_NMI_H
-#define ASM_NMI_H
-
-#include <linux/pm.h>
-#include <asm/irq.h>
-
-#ifdef ARCH_HAS_NMI_WATCHDOG
-
-/**
- * do_nmi_callback
- *
- * Check to see if a callback exists and execute it.  Return 1
- * if the handler exists and was handled successfully.
- */
-int do_nmi_callback(struct pt_regs *regs, int cpu);
-
-extern int nmi_watchdog_enabled;
-extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
-extern int avail_to_resrv_perfctr_nmi(unsigned int);
-extern int reserve_perfctr_nmi(unsigned int);
-extern void release_perfctr_nmi(unsigned int);
-extern int reserve_evntsel_nmi(unsigned int);
-extern void release_evntsel_nmi(unsigned int);
-
-extern void setup_apic_nmi_watchdog (void *);
-extern void stop_apic_nmi_watchdog (void *);
-extern void disable_timer_nmi_watchdog(void);
-extern void enable_timer_nmi_watchdog(void);
-extern int nmi_watchdog_tick (struct pt_regs * regs, unsigned reason);
-
-extern atomic_t nmi_active;
-extern unsigned int nmi_watchdog;
-#define NMI_DISABLED    -1
-#define NMI_NONE	0
-#define NMI_IO_APIC	1
-#define NMI_LOCAL_APIC	2
-#define NMI_INVALID	3
-#define NMI_DEFAULT	NMI_DISABLED
-
-struct ctl_table;
-struct file;
-extern int proc_nmi_enabled(struct ctl_table *, int , struct file *,
-			void __user *, size_t *, loff_t *);
-extern int unknown_nmi_panic;
-
-void __trigger_all_cpu_backtrace(void);
-#define trigger_all_cpu_backtrace() __trigger_all_cpu_backtrace()
-
-#endif
-
-void lapic_watchdog_stop(void);
-int lapic_watchdog_init(unsigned nmi_hz);
-int lapic_wd_event(unsigned nmi_hz);
-unsigned lapic_adjust_nmi_hz(unsigned hz);
-int lapic_watchdog_ok(void);
-void disable_lapic_nmi_watchdog(void);
-void enable_lapic_nmi_watchdog(void);
-void stop_nmi(void);
-void restart_nmi(void);
-
-#endif /* ASM_NMI_H */
diff --git a/include/asm-x86/nmi_64.h b/include/asm-x86/nmi_64.h
deleted file mode 100644
index 94a5b19..0000000
--- a/include/asm-x86/nmi_64.h
+++ /dev/null
@@ -1,88 +0,0 @@
-#ifndef ASM_NMI_H
-#define ASM_NMI_H
-
-#include <linux/pm.h>
-#include <asm/io.h>
- 
-/**
- * do_nmi_callback
- *
- * Check to see if a callback exists and execute it.  Return 1
- * if the handler exists and was handled successfully.
- */
-int do_nmi_callback(struct pt_regs *regs, int cpu);
-
-#ifdef CONFIG_PM
- 
-/** Replace the PM callback routine for NMI. */
-struct pm_dev * set_nmi_pm_callback(pm_callback callback);
-
-/** Unset the PM callback routine back to the default. */
-void unset_nmi_pm_callback(struct pm_dev * dev);
-
-#else
-
-static inline struct pm_dev * set_nmi_pm_callback(pm_callback callback)
-{
-	return 0;
-} 
- 
-static inline void unset_nmi_pm_callback(struct pm_dev * dev)
-{
-}
-
-#endif /* CONFIG_PM */
- 
-extern void default_do_nmi(struct pt_regs *);
-extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
-
-extern int unknown_nmi_panic;
-extern int nmi_watchdog_enabled;
-
-extern int check_nmi_watchdog(void);
-extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
-extern int avail_to_resrv_perfctr_nmi(unsigned int);
-extern int reserve_perfctr_nmi(unsigned int);
-extern void release_perfctr_nmi(unsigned int);
-extern int reserve_evntsel_nmi(unsigned int);
-extern void release_evntsel_nmi(unsigned int);
-
-extern void setup_apic_nmi_watchdog (void *);
-extern void stop_apic_nmi_watchdog (void *);
-extern void disable_timer_nmi_watchdog(void);
-extern void enable_timer_nmi_watchdog(void);
-extern int nmi_watchdog_tick (struct pt_regs * regs, unsigned reason);
-
-extern void nmi_watchdog_default(void);
-
-extern atomic_t nmi_active;
-extern unsigned int nmi_watchdog;
-#define NMI_DISABLED    -1
-#define NMI_NONE	0
-#define NMI_IO_APIC	1
-#define NMI_LOCAL_APIC	2
-#define NMI_INVALID	3
-#define NMI_DEFAULT	NMI_DISABLED
-
-struct ctl_table;
-struct file;
-extern int proc_nmi_enabled(struct ctl_table *, int , struct file *,
-			void __user *, size_t *, loff_t *);
-
-extern int unknown_nmi_panic;
-
-void __trigger_all_cpu_backtrace(void);
-#define trigger_all_cpu_backtrace() __trigger_all_cpu_backtrace()
-
-
-void lapic_watchdog_stop(void);
-int lapic_watchdog_init(unsigned nmi_hz);
-int lapic_wd_event(unsigned nmi_hz);
-unsigned lapic_adjust_nmi_hz(unsigned hz);
-int lapic_watchdog_ok(void);
-void disable_lapic_nmi_watchdog(void);
-void enable_lapic_nmi_watchdog(void);
-void stop_nmi(void);
-void restart_nmi(void);
-
-#endif /* ASM_NMI_H */
-- 
1.5.0.6

