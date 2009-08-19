Return-Path: <linux-kernel-owner+w=401wt.eu-S1751432AbZHSQEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbZHSQEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZHSQEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:04:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50374 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750919AbZHSQEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:04:42 -0400
Message-ID: <4A8C2290.3040707@redhat.com>
Date: Wed, 19 Aug 2009 12:04:32 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add minimal support for software performance counters for
 ia64
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------030308010300080207040007"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030308010300080207040007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The following patch adds minimal support for software performance counters for ia64.

For the kernel the patch enables configuration of the perf counter
option, adds the perf_counter_open syscall, and includes a minimal machine
specific asm/perf.h header file.

For the perf tool the header perf.h includes an ia64 specific section
and the options used in the Makefile were adjusted to allow
compilation on ia64.  The -Wcast-align gives "cast increases required
alignment of target type" warning for the list_for_each_entry()
macro. The "-fno-strict-aliasing" was used to avoid warnings for
"dereferencing type-punned pointer will break strict-aliasing rules"
warnings for sscanf() functions in util/trace-event-parse.c

-Will

Signed-off-by: William Cohen <wcohen@redhat.com>

--------------030308010300080207040007
Content-Type: text/plain;
 name="perf_ia64a.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf_ia64a.patch"

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 170042b..8471526 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -29,6 +29,7 @@ config IA64
 	select HAVE_KVM
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
+	select HAVE_PERF_COUNTERS
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/arch/ia64/include/asm/unistd.h b/arch/ia64/include/asm/unistd.h
index 5a5347f..f69d1c9 100644
--- a/arch/ia64/include/asm/unistd.h
+++ b/arch/ia64/include/asm/unistd.h
@@ -311,11 +311,12 @@
 #define __NR_preadv			1319
 #define __NR_pwritev			1320
 #define __NR_rt_tgsigqueueinfo		1321
+#define __NR_perf_counter_open		1322
 
 #ifdef __KERNEL__
 
 
-#define NR_syscalls			298 /* length of syscall table */
+#define NR_syscalls			299 /* length of syscall table */
 
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining about
diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
index d0e7d37..4cf88b0 100644
--- a/arch/ia64/kernel/entry.S
+++ b/arch/ia64/kernel/entry.S
@@ -1806,6 +1806,7 @@ sys_call_table:
 	data8 sys_preadv
 	data8 sys_pwritev			// 1320
 	data8 sys_rt_tgsigqueueinfo
+	data8 sys_perf_counter_open
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
 #endif /* __IA64_ASM_PARAVIRTUALIZED_NATIVE */
diff --git a/include/asm-ia64/perf_counter.h b/include/asm-ia64/perf_counter.h
new file mode 100644
index 0000000..cab4352
--- /dev/null
+++ b/include/asm-ia64/perf_counter.h
@@ -0,0 +1,9 @@
+#ifndef __ASM_IA64_PERF_COUNTER_H
+#define __ASM_IA64_PERF_COUNTER_H
+
+/* IA64 only supports software counters through this interface. */
+static inline void set_perf_counter_pending(void) {}
+
+#define PERF_COUNTER_INDEX_OFFSET	0
+
+#endif /* __ASM_IA64_PERF_COUNTER_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c481a51..69db3de 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -159,8 +159,10 @@ uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
 # If we're on a 64-bit kernel, use -m64
 ifndef NO_64BIT
-	ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
-	  M64 := -m64
+	ifeq ($(patsubst %ia64,%,$(uname_M)),$(uname_M))
+	  ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
+	    M64 := -m64
+	  endif
 	endif
 endif
 
@@ -169,9 +171,9 @@ endif
 #
 # Include saner warnings here, which can catch bugs:
 #
-EXTRA_WARNINGS = -Wcast-align -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement
+EXTRA_WARNINGS = -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement
 
-CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
+CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 -fno-strict-aliasing $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index e5148e2..90179c9 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -41,6 +41,12 @@
 #define cpu_relax()	asm volatile("" ::: "memory");
 #endif
 
+#ifdef __ia64__
+#include "../../arch/ia64/include/asm/unistd.h"
+#define rmb()		asm volatile("" ::: "memory")
+#define cpu_relax()	asm volatile("" ::: "memory");
+#endif
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>

--------------030308010300080207040007--
