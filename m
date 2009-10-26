Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZJZIdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZJZIdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 04:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbZJZIdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 04:33:13 -0400
Received: from mx9.orcon.net.nz ([219.88.242.59]:50118 "EHLO mx9.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbZJZIdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 04:33:12 -0400
From: Michael Cree <mcree@orcon.net.nz>
To: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Cc: Michael Cree <mcree@orcon.net.nz>, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] [alpha] Add minimal support for software performance events.
Date: Mon, 26 Oct 2009 21:32:06 +1300
Message-Id: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.6.3.3
X-DSPAM-Check: by mx9.orcon.net.nz on Mon, 26 Oct 2009 21:33:16 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Oct 26 21:33:16 2009
X-DSPAM-Confidence: 0.9930
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the kernel the patch enables configuration of the perf event
option, adds the perf_event_open syscall, and includes a minimal
architecture specific asm/perf_event.h header file.

For the perf tool the patch implements an Alpha specific section
in the perf.h header file and adjusts options used in the
Makefile to allow compilation on Alpha.  The -Wcast-align gives
a "cast increases required alignment of target type" warning for
the list_for_each_entry() macro. The -fstack-protector-all
option generates a "not supported for this target" warning which
with -Werror causes the compiler to abort.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
---
 arch/alpha/Kconfig                  |    1 +
 arch/alpha/include/asm/perf_event.h |    9 +++++++++
 arch/alpha/include/asm/unistd.h     |    3 ++-
 arch/alpha/kernel/systbls.S         |    1 +
 tools/perf/Makefile                 |    5 ++---
 tools/perf/perf.h                   |    6 ++++++
 6 files changed, 21 insertions(+), 4 deletions(-)
 create mode 100644 arch/alpha/include/asm/perf_event.h

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 4434481..bd7261e 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -9,6 +9,7 @@ config ALPHA
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS
+	select HAVE_PERF_EVENTS
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff --git a/arch/alpha/include/asm/perf_event.h b/arch/alpha/include/asm/perf_event.h
new file mode 100644
index 0000000..3bef852
--- /dev/null
+++ b/arch/alpha/include/asm/perf_event.h
@@ -0,0 +1,9 @@
+#ifndef __ASM_ALPHA_PERF_EVENT_H
+#define __ASM_ALPHA_PERF_EVENT_H
+
+/* Alpha only supports software events through this interface. */
+static inline void set_perf_event_pending(void) { }
+
+#define PERF_EVENT_INDEX_OFFSET 0
+
+#endif /* __ASM_ALPHA_PERF_EVENT_H */
diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index 17f72b7..414de17 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -447,10 +447,11 @@
 #define __NR_preadv			489
 #define __NR_pwritev			490
 #define __NR_rt_tgsigqueueinfo		491
+#define __NR_perf_event_open		492
 
 #ifdef __KERNEL__
 
-#define NR_SYSCALLS			492
+#define NR_SYSCALLS			493
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
index 78199b9..63c78e4 100644
--- a/arch/alpha/kernel/systbls.S
+++ b/arch/alpha/kernel/systbls.S
@@ -510,6 +510,7 @@ sys_call_table:
 	.quad sys_preadv
 	.quad sys_pwritev			/* 490 */
 	.quad sys_rt_tgsigqueueinfo
+	.quad sys_perf_event_open
 
 	.size sys_call_table, . - sys_call_table
 	.type sys_call_table, @object
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 742a32e..7940d66 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -177,8 +177,7 @@ endif
 # Include saner warnings here, which can catch bugs:
 #
 
-EXTRA_WARNINGS := -Wcast-align
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat
+EXTRA_WARNINGS := -Wformat
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-y2k
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
@@ -201,7 +200,7 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
 
-CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
+CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 8cc4623..216bdb2 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -47,6 +47,12 @@
 #define cpu_relax()	asm volatile("":::"memory")
 #endif
 
+#ifdef __alpha__
+#include "../../arch/alpha/include/asm/unistd.h"
+#define rmb()		asm volatile("mb" ::: "memory")
+#define cpu_relax()	asm volatile("" ::: "memory")
+#endif
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>
-- 
1.6.3.3

