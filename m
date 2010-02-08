Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab0BHIxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 03:53:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:59568 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab0BHIx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 03:53:27 -0500
Date: Mon, 8 Feb 2010 08:52:13 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1265424425-31562-4-git-send-email-dzickus@redhat.com>
References: <1265424425-31562-4-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] nmi_watchdog: Config option to enable new nmi_watchdog
Message-ID: <tip-84e478c6f1eb9c4bfa1fff2f8108e9a061b46428@git.kernel.org>
Git-Commit-ID: 84e478c6f1eb9c4bfa1fff2f8108e9a061b46428
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 08 Feb 2010 08:52:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84e478c6f1eb9c4bfa1fff2f8108e9a061b46428
Gitweb:     http://git.kernel.org/tip/84e478c6f1eb9c4bfa1fff2f8108e9a061b46428
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Fri, 5 Feb 2010 21:47:05 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 8 Feb 2010 08:29:03 +0100

nmi_watchdog: Config option to enable new nmi_watchdog

These are the bits that enable the new nmi_watchdog and safely
isolate the old nmi_watchdog.  Only one or the other can run,
not both at the same time.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: gorcunov@gmail.com
Cc: aris@redhat.com
Cc: peterz@infradead.org
LKML-Reference: <1265424425-31562-4-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index 51ef893..973cbc4 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -406,6 +406,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	        			                == NOTIFY_STOP)
 	                return;
 
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
index 25c3ed5..f80b67e 100644
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
