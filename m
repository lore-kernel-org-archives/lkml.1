Return-Path: <linux-kernel-owner+w=401wt.eu-S932392AbZHUQiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbZHUQiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932309AbZHUQiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:38:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33902 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306AbZHUQiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:38:05 -0400
Date: Fri, 21 Aug 2009 18:37:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Cohen <wcohen@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH, V2] perf_counter, IA64: Add support for software
	performance counters
Message-ID: <20090821163757.GC20898@elte.hu>
References: <4A8C2290.3040707@redhat.com> <1250698351.8282.106.camel@twins> <4A8C4CAA.5070101@redhat.com> <1250708819.7154.5.camel@laptop> <4A8DBDDB.5080402@redhat.com> <20090821142514.GE11098@elte.hu> <4A8EB8A9.9000900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8EB8A9.9000900@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* William Cohen <wcohen@redhat.com> wrote:

> The following is the revised patch with the corrected macros and 
> the include file in the correct place.

Note, this is not how v2 patches are generally expected to be 
submitted upstream - all info is supposed to be re-submitted with a 
new v2 email title to make it easy and context-less for maintainers.

I've done that here: i've tidied up the changelog (to match IA64 and 
perf_counter patch title standards), added a diffstat, added the 
acks/signoffs the patch got in the discussion and included the whole 
thing below, for IA64 folks to comment on.

Thanks,

	Ingo

---------------------->
Subject: perf_counter, IA64: Add support for software performance counters
From: William Cohen <wcohen@redhat.com>
Date: Fri, 21 Aug 2009 11:09:29 -0400

The patch enables configuration of the perf counter option on
IA64, adds the perf_counter_open syscall, and includes a
minimal machine specific asm/perf.h header file.

For the perf tool the header perf.h includes an ia64 specific
section and the options used in the Makefile were adjusted to
allow compilation on ia64.

[ The -Wcast-align gives "cast increases required alignment of
  target type" warning for the list_for_each_entry() macro. The
  "-fno-strict-aliasing" was used to avoid warnings for
  "dereferencing type-punned pointer will break strict-aliasing
  rules" warnings for sscanf() functions in
  util/trace-event-parse.c ]

Signed-off-by: William Cohen <wcohen@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <4A8EB8A9.9000900@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/ia64/Kconfig                    |    1 +
 arch/ia64/include/asm/perf_counter.h |    9 +++++++++
 arch/ia64/include/asm/unistd.h       |    3 ++-
 arch/ia64/kernel/entry.S             |    1 +
 tools/perf/Makefile                  |   10 ++++++----
 tools/perf/perf.h                    |    6 ++++++
 6 files changed, 25 insertions(+), 5 deletions(-)

Index: tip/arch/ia64/Kconfig
===================================================================
--- tip.orig/arch/ia64/Kconfig
+++ tip/arch/ia64/Kconfig
@@ -29,6 +29,7 @@ config IA64
 	select HAVE_KVM
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
+	select HAVE_PERF_COUNTERS
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
Index: tip/arch/ia64/include/asm/perf_counter.h
===================================================================
--- /dev/null
+++ tip/arch/ia64/include/asm/perf_counter.h
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
Index: tip/arch/ia64/include/asm/unistd.h
===================================================================
--- tip.orig/arch/ia64/include/asm/unistd.h
+++ tip/arch/ia64/include/asm/unistd.h
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
Index: tip/arch/ia64/kernel/entry.S
===================================================================
--- tip.orig/arch/ia64/kernel/entry.S
+++ tip/arch/ia64/kernel/entry.S
@@ -1806,6 +1806,7 @@ sys_call_table:
 	data8 sys_preadv
 	data8 sys_pwritev			// 1320
 	data8 sys_rt_tgsigqueueinfo
+	data8 sys_perf_counter_open
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
 #endif /* __IA64_ASM_PARAVIRTUALIZED_NATIVE */
Index: tip/tools/perf/Makefile
===================================================================
--- tip.orig/tools/perf/Makefile
+++ tip/tools/perf/Makefile
@@ -159,8 +159,10 @@ uname_V := $(shell sh -c 'uname -v 2>/de
 
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
Index: tip/tools/perf/perf.h
===================================================================
--- tip.orig/tools/perf/perf.h
+++ tip/tools/perf/perf.h
@@ -41,6 +41,12 @@
 #define cpu_relax()	asm volatile("" ::: "memory");
 #endif
 
+#ifdef __ia64__
+#include "../../arch/ia64/include/asm/unistd.h"
+#define rmb()		asm volatile("mf" ::: "memory")
+#define cpu_relax()	asm volatile("hint @pause" ::: "memory")
+#endif
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>
