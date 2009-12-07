Return-Path: <linux-kernel-owner+w=401wt.eu-S933138AbZLGKc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138AbZLGKc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932798AbZLGKcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:32:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41864 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787AbZLGKcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:32:24 -0500
Date: Mon, 7 Dec 2009 11:32:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2] perf: Make location of kernel source configurable
Message-ID: <20091207103227.GE18989@one.firstfloor.org>
References: <20091206307.542816612@firstfloor.org> <20091207061839.GB5186@nowhere> <20091207070715.GC10868@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207070715.GC10868@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > It does not apply cleanly, it seems you are using 2.6.32 There have a 
> > been a lot of updates in this merge window.
> > 
> > Could you please resend against latest linus tree?
> 
> Even better would be a patch against latest -tip:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> which includes the latest perf event tree.

Strangely it applies against

git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip tip

commit 38dc0971ca21f49b97cd139a278c210d4e50958d
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Dec 7 08:14:06 2009 +0100

    auto-perf-next: add perf/lock

without any offsets even:

~/lsrc/git/x86/linux-2.6-tip> patch -p1 --dry-run < ~/lsrc/linux-2.6.32-ak/patches/perf-kernelsrc
patching file tools/perf/Makefile
patching file tools/perf/perf.h
patching file tools/perf/util/header.h
patching file tools/perf/util/include/linux/list.h
patching file tools/perf/util/include/linux/poison.h
patching file tools/perf/util/include/linux/rbtree.h
patching file tools/perf/util/util.h

Looks like tip is the same as .32 in this regard or I tried the wrong
tree.

There's a reject against Linus' latest. I'm appending a patch that applies
cleanly there. Also that tree seems to have gained a lot of new
../..s; I fixed those too, except those that do not go outside
the perf directory tree.

The other version number patch applies in both cases, just with some offsets.

-Andi

---

perf: Make location of kernel source configurable

tools/perf has no support for separate object directories
and lots of hard coded paths assuming that the kernel source
is always in ../..

As a first step of compiling it separately without messing
up clean source trees allow to configure the kernel source
location using a KERNELSRC variable 

This allows at least to copy the whole tools/perf
directory elsewhere and build it separately.

The default is still ../.., so for a standard build
nothing changes

This also removes a lot of ugly ../.. from the source.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 23ec660..6cb1be8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -151,6 +151,8 @@ all::
 #
 # Define EXTRA_CFLAGS=-m64 or EXTRA_CFLAGS=-m32 as appropriate for cross-builds.
 
+KERNELSRC := ../..
+
 PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN
 -include PERF-VERSION-FILE
@@ -260,7 +262,7 @@ endif
 # Those must not be GNU-specific; they are shared with perl/ which may
 # be built by a different compiler. (Note that this is an artifact now
 # but it still might be nice to keep that distinction.)
-BASIC_CFLAGS = -Iutil/include
+BASIC_CFLAGS = -Iutil/include -I $(KERNELSRC)
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -325,10 +327,10 @@ export PERL_PATH
 
 LIB_FILE=libperf.a
 
-LIB_H += ../../include/linux/perf_event.h
-LIB_H += ../../include/linux/rbtree.h
-LIB_H += ../../include/linux/list.h
-LIB_H += ../../include/linux/stringify.h
+LIB_H += $(KERNELSRC)/include/linux/perf_event.h
+LIB_H += $(KERNELSRC)/include/linux/rbtree.h
+LIB_H += $(KERNELSRC)/include/linux/list.h
+LIB_H += $(KERNELSRC)/include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
 LIB_H += util/include/linux/compiler.h
@@ -857,20 +859,20 @@ builtin-init-db.o: builtin-init-db.c PERF-CFLAGS
 util/config.o: util/config.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $*.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
-util/rbtree.o: ../../lib/rbtree.c PERF-CFLAGS
+util/rbtree.o: $(KERNELSRC)/lib/rbtree.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o util/rbtree.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
 # some perf warning policies can't fit to lib/bitmap.c, eg: it warns about variable shadowing
 # from <string.h> that comes from kernel headers wrapping.
 KBITMAP_FLAGS=`echo $(ALL_CFLAGS) | sed s/-Wshadow// | sed s/-Wswitch-default// | sed s/-Wextra//`
 
-util/bitmap.o: ../../lib/bitmap.c PERF-CFLAGS
+util/bitmap.o: $(KERNELSRC)/lib/bitmap.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o util/bitmap.o -c $(KBITMAP_FLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
-util/hweight.o: ../../lib/hweight.c PERF-CFLAGS
+util/hweight.o: $(KERNELSRC)/lib/hweight.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o util/hweight.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
-util/find_next_bit.o: ../../lib/find_next_bit.c PERF-CFLAGS
+util/find_next_bit.o: $(KERNELSRC)/lib/find_next_bit.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o util/find_next_bit.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
 util/trace-event-perl.o: util/trace-event-perl.c PERF-CFLAGS
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 454d5d5..c28938f 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -2,31 +2,31 @@
 #define _PERF_PERF_H
 
 #if defined(__i386__)
-#include "../../arch/x86/include/asm/unistd.h"
+#include "arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #endif
 
 #if defined(__x86_64__)
-#include "../../arch/x86/include/asm/unistd.h"
+#include "arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lfence" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #endif
 
 #ifdef __powerpc__
-#include "../../arch/powerpc/include/asm/unistd.h"
+#include "arch/powerpc/include/asm/unistd.h"
 #define rmb()		asm volatile ("sync" ::: "memory")
 #define cpu_relax()	asm volatile ("" ::: "memory");
 #endif
 
 #ifdef __s390__
-#include "../../arch/s390/include/asm/unistd.h"
+#include "arch/s390/include/asm/unistd.h"
 #define rmb()		asm volatile("bcr 15,0" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory");
 #endif
 
 #ifdef __sh__
-#include "../../arch/sh/include/asm/unistd.h"
+#include "arch/sh/include/asm/unistd.h"
 #if defined(__SH4A__) || defined(__SH5__)
 # define rmb()		asm volatile("synco" ::: "memory")
 #else
@@ -36,25 +36,25 @@
 #endif
 
 #ifdef __hppa__
-#include "../../arch/parisc/include/asm/unistd.h"
+#include "arch/parisc/include/asm/unistd.h"
 #define rmb()		asm volatile("" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory");
 #endif
 
 #ifdef __sparc__
-#include "../../arch/sparc/include/asm/unistd.h"
+#include "arch/sparc/include/asm/unistd.h"
 #define rmb()		asm volatile("":::"memory")
 #define cpu_relax()	asm volatile("":::"memory")
 #endif
 
 #ifdef __alpha__
-#include "../../arch/alpha/include/asm/unistd.h"
+#include "arch/alpha/include/asm/unistd.h"
 #define rmb()		asm volatile("mb" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory")
 #endif
 
 #ifdef __ia64__
-#include "../../arch/ia64/include/asm/unistd.h"
+#include "arch/ia64/include/asm/unistd.h"
 #define rmb()		asm volatile ("mf" ::: "memory")
 #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
 #endif
@@ -64,7 +64,7 @@
 #include <sys/types.h>
 #include <sys/syscall.h>
 
-#include "../../include/linux/perf_event.h"
+#include "include/linux/perf_event.h"
 #include "util/types.h"
 
 /*
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index d1dbe2b..5fd474e 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_HEADER_H
 #define __PERF_HEADER_H
 
-#include "../../../include/linux/perf_event.h"
+#include "include/linux/perf_event.h"
 #include <sys/types.h>
 #include <stdbool.h>
 #include "types.h"
diff --git a/tools/perf/util/include/asm/bitops.h b/tools/perf/util/include/asm/bitops.h
index 58e9817..720f32f 100644
--- a/tools/perf/util/include/asm/bitops.h
+++ b/tools/perf/util/include/asm/bitops.h
@@ -8,11 +8,11 @@
 /* CHECKME: Not sure both always match */
 #define BITS_PER_LONG	__WORDSIZE
 
-#include "../../../../include/asm-generic/bitops/__fls.h"
-#include "../../../../include/asm-generic/bitops/fls.h"
-#include "../../../../include/asm-generic/bitops/fls64.h"
-#include "../../../../include/asm-generic/bitops/__ffs.h"
-#include "../../../../include/asm-generic/bitops/ffz.h"
-#include "../../../../include/asm-generic/bitops/hweight.h"
+#include "include/asm-generic/bitops/__fls.h"
+#include "include/asm-generic/bitops/fls.h"
+#include "include/asm-generic/bitops/fls64.h"
+#include "include/asm-generic/bitops/__ffs.h"
+#include "include/asm-generic/bitops/ffz.h"
+#include "include/asm-generic/bitops/hweight.h"
 
 #endif
diff --git a/tools/perf/util/include/asm/byteorder.h b/tools/perf/util/include/asm/byteorder.h
index b722abe..e84174b 100644
--- a/tools/perf/util/include/asm/byteorder.h
+++ b/tools/perf/util/include/asm/byteorder.h
@@ -1,2 +1,2 @@
 #include <asm/types.h>
-#include "../../../../include/linux/swab.h"
+#include "include/linux/swab.h"
diff --git a/tools/perf/util/include/linux/bitmap.h b/tools/perf/util/include/linux/bitmap.h
index 9450763..8bac145 100644
--- a/tools/perf/util/include/linux/bitmap.h
+++ b/tools/perf/util/include/linux/bitmap.h
@@ -1,3 +1,3 @@
-#include "../../../../include/linux/bitmap.h"
-#include "../../../../include/asm-generic/bitops/find.h"
+#include "include/linux/bitmap.h"
+#include "include/asm-generic/bitops/find.h"
 #include <linux/errno.h>
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index 8d63116..215bd63 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -5,7 +5,7 @@
 
 #define CONFIG_GENERIC_FIND_NEXT_BIT
 #define CONFIG_GENERIC_FIND_FIRST_BIT
-#include "../../../../include/linux/bitops.h"
+#include "include/linux/bitops.h"
 
 #undef __KERNEL__
 
diff --git a/tools/perf/util/include/linux/list.h b/tools/perf/util/include/linux/list.h
index dbe4b81..4644fc9 100644
--- a/tools/perf/util/include/linux/list.h
+++ b/tools/perf/util/include/linux/list.h
@@ -1,4 +1,4 @@
-#include "../../../../include/linux/list.h"
+#include "include/linux/list.h"
 
 #ifndef PERF_LIST_H
 #define PERF_LIST_H
diff --git a/tools/perf/util/include/linux/poison.h b/tools/perf/util/include/linux/poison.h
index fef6dbc..5b8311d 100644
--- a/tools/perf/util/include/linux/poison.h
+++ b/tools/perf/util/include/linux/poison.h
@@ -1 +1 @@
-#include "../../../../include/linux/poison.h"
+#include "include/linux/poison.h"
diff --git a/tools/perf/util/include/linux/rbtree.h b/tools/perf/util/include/linux/rbtree.h
index 7a243a1..712845f 100644
--- a/tools/perf/util/include/linux/rbtree.h
+++ b/tools/perf/util/include/linux/rbtree.h
@@ -1 +1 @@
-#include "../../../../include/linux/rbtree.h"
+#include "include/linux/rbtree.h"
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9e5dbd6..69f50ac 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,4 +1,4 @@
-#include "../../../include/linux/hw_breakpoint.h"
+#include "include/linux/hw_breakpoint.h"
 #include "util.h"
 #include "../perf.h"
 #include "parse-options.h"
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index c673d88..591f6d9 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -77,7 +77,7 @@
 #include <netdb.h>
 #include <pwd.h>
 #include <inttypes.h>
-#include "../../../include/linux/magic.h"
+#include "include/linux/magic.h"
 
 
 #ifndef NO_ICONV
@@ -137,7 +137,7 @@ extern void die(const char *err, ...) NORETURN __attribute__((format (printf, 1,
 extern int error(const char *err, ...) __attribute__((format (printf, 1, 2)));
 extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)));
 
-#include "../../../include/linux/stringify.h"
+#include "include/linux/stringify.h"
 
 #define DIE_IF(cnd)	\
 	do { if (cnd)	\


-- 
ak@linux.intel.com -- Speaking for myself only.
