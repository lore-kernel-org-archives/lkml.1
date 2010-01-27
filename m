Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550Ab0A0UEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab0A0UEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112Ab0A0UEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:04:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0A0UEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:04:21 -0500
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com
Cc: aris@redhat.com, linux-kernel@vger.kernel.org,
       Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/3] [RFC] nmi_watchdog: config option to enable new nmi_watchdog
Date: Wed, 27 Jan 2010 15:03:42 -0500
Message-Id: <1264622622-5778-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1264622622-5778-1-git-send-email-dzickus@redhat.com>
References: <1264622622-5778-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the bits that enable the new nmi_watchdog and safely isolate the
old nmi_watchdog.  Only one or the other can run, not both at the same
time.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/Makefile |    7 ++++++-
 arch/x86/kernel/traps.c       |    2 ++
 include/linux/nmi.h           |    4 ++++
 kernel/Makefile               |    1 +
 lib/Kconfig.debug             |   13 +++++++++++++
 5 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 565c1bf..1a4512e 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -2,7 +2,12 @@
 # Makefile for local APIC drivers and for the IO-APIC code
 #
 
-obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o probe_$(BITS).o ipi.o nmi.o
+obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o probe_$(BITS).o ipi.o
+ifneq ($(CONFIG_NMI_WATCHDOG),y)
+obj-$(CONFIG_X86_LOCAL_APIC)	+= nmi.o
+endif
+obj-$(CONFIG_NMI_WATCHDOG)	+= hw_nmi.o
+
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_SMP)		+= ipi.o
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 3b98dd3..eee1dc8 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -406,6 +406,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	                return;
 
 #ifdef CONFIG_X86_LOCAL_APIC
+#ifndef CONFIG_NMI_WATCHDOG
 		/*
 		 * Ok, so this is none of the documented NMI sources,
 		 * so it must be the NMI watchdog.
@@ -413,6 +414,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		if (nmi_watchdog_tick(regs, reason))
 			return;
 		if (!do_nmi_callback(regs, cpu))
+#endif /* !CONFIG_NMI_WATCHDOG */
 			unknown_nmi_error(reason, regs);
 #else
 		unknown_nmi_error(reason, regs);
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index b752e80..a42ff0b 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -47,4 +47,8 @@ static inline bool trigger_all_cpu_backtrace(void)
 }
 #endif
 
+#ifdef CONFIG_NMI_WATCHDOG
+int hw_nmi_is_cpu_stuck(struct pt_regs *);
+#endif
+
 #endif
diff --git a/kernel/Makefile b/kernel/Makefile
index 864ff75..8a5abe5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_KGDB) += kgdb.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
+obj-$(CONFIG_NMI_WATCHDOG) += nmi_watchdog.o
 obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 25c3ed5..04a43a2 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -170,6 +170,19 @@ config DETECT_SOFTLOCKUP
 	   can be detected via the NMI-watchdog, on platforms that
 	   support it.)
 
+config NMI_WATCHDOG
+	bool "Detect Hard Lockups with an NMI Watchdog"
+	depends on DEBUG_KERNEL && PERF_EVENTS
+	default y
+	help
+	  Say Y here to enable the kernel to use the NMI as a watchdog
+	  to detect hard lockups.  This is useful when a cpu hangs for no
+	  reason but can still respond to NMIs.  A backtrace is displayed
+	  for reviewing and reporting.
+
+	  The overhead should be minimal, just an extra NMI every few 
+	  seconds.
+
 config BOOTPARAM_SOFTLOCKUP_PANIC
 	bool "Panic (Reboot) On Soft Lockups"
 	depends on DETECT_SOFTLOCKUP
-- 
1.6.5.2

