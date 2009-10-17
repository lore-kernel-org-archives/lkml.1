Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbZJQPMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbZJQPMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 11:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZJQPMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 11:12:36 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:41219 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbZJQPMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 11:12:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=p9bd51EwGVsKfCaz4nIc2fM2ulmPWakjHbj4aDAj/DhAD+CASFamI1TzHfNZVsXGNx
         543rwNt4v1SX+Y2H4tTxgwC65F6Oeb2Z0JOWnNUYWRGovyucoLg6Foo8a1zR+Plch/GD
         tJDXgXdicRM9ttoNR2FUvrZi9LK8EhTpvSZWs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/2] perf tools: Use kernel bitmap library
Date: Sat, 17 Oct 2009 17:12:33 +0200
Message-Id: <1255792354-11304-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20091016074222.GD30019@elte.hu>
References: <20091016074222.GD30019@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the kernel bitmap library for internal perf tools uses.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/Makefile                      |   16 ++++++++
 tools/perf/builtin-record.c              |    3 --
 tools/perf/builtin-sched.c               |    2 -
 tools/perf/util/include/asm/bitops.h     |    6 +++
 tools/perf/util/include/asm/byteorder.h  |    2 +
 tools/perf/util/include/asm/swab.h       |    1 +
 tools/perf/util/include/asm/types.h      |   17 +++++++++
 tools/perf/util/include/asm/uaccess.h    |   14 +++++++
 tools/perf/util/include/linux/bitmap.h   |    2 +
 tools/perf/util/include/linux/bitops.h   |   27 ++++++++++++++
 tools/perf/util/include/linux/compiler.h |   10 +++++
 tools/perf/util/include/linux/ctype.h    |    1 +
 tools/perf/util/include/linux/kernel.h   |   59 ++++++++++++++++++++++++++++++
 tools/perf/util/include/linux/types.h    |    1 +
 14 files changed, 156 insertions(+), 5 deletions(-)
 create mode 100644 tools/perf/util/include/asm/bitops.h
 create mode 100644 tools/perf/util/include/asm/byteorder.h
 create mode 100644 tools/perf/util/include/asm/swab.h
 create mode 100644 tools/perf/util/include/asm/types.h
 create mode 100644 tools/perf/util/include/asm/uaccess.h
 create mode 100644 tools/perf/util/include/linux/bitmap.h
 create mode 100644 tools/perf/util/include/linux/bitops.h
 create mode 100644 tools/perf/util/include/linux/compiler.h
 create mode 100644 tools/perf/util/include/linux/ctype.h
 create mode 100644 tools/perf/util/include/linux/types.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 106c150..2400e50 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -363,6 +363,9 @@ LIB_OBJS += util/parse-options.o
 LIB_OBJS += util/parse-events.o
 LIB_OBJS += util/path.o
 LIB_OBJS += util/rbtree.o
+LIB_OBJS += util/bitmap.o
+LIB_OBJS += util/hweight.o
+LIB_OBJS += util/find_next_bit.o
 LIB_OBJS += util/run-command.o
 LIB_OBJS += util/quote.o
 LIB_OBJS += util/strbuf.o
@@ -790,6 +793,19 @@ util/config.o: util/config.c PERF-CFLAGS
 util/rbtree.o: ../../lib/rbtree.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o util/rbtree.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+# some perf warning policies can't fit to lib/bitmap.c, eg: it warns about variable shadowing
+# from <string.h> that comes from kernel headers wrapping.
+KBITMAP_FLAGS=`echo $(ALL_CFLAGS) | sed s/-Wshadow// | sed s/-Wswitch-default// | sed s/-Wextra//`
+
+util/bitmap.o: ../../lib/bitmap.c PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o util/bitmap.o -c $(KBITMAP_FLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+
+util/hweight.o: ../../lib/hweight.c PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o util/hweight.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+
+util/find_next_bit.o: ../../lib/find_next_bit.c PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o util/find_next_bit.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+
 perf-%$X: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(ALL_LDFLAGS) $(filter %.o,$^) $(LIBS)
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8b2c860..fc3709c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -21,9 +21,6 @@
 #include <unistd.h>
 #include <sched.h>
 
-#define ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a)-1)
-#define __ALIGN_MASK(x, mask)	(((x)+(mask))&~(mask))
-
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static long			default_interval		=      0;
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index c9c6856..e32c946 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -38,8 +38,6 @@ static int			cwdlen;
 #define PR_SET_NAME		15               /* Set process name */
 #define MAX_CPUS		4096
 
-#define BUG_ON(x)		assert(!(x))
-
 static u64			run_measurement_overhead;
 static u64			sleep_measurement_overhead;
 
diff --git a/tools/perf/util/include/asm/bitops.h b/tools/perf/util/include/asm/bitops.h
new file mode 100644
index 0000000..fbe4d92
--- /dev/null
+++ b/tools/perf/util/include/asm/bitops.h
@@ -0,0 +1,6 @@
+#include "../../../../include/asm-generic/bitops/__fls.h"
+#include "../../../../include/asm-generic/bitops/fls.h"
+#include "../../../../include/asm-generic/bitops/fls64.h"
+#include "../../../../include/asm-generic/bitops/__ffs.h"
+#include "../../../../include/asm-generic/bitops/ffz.h"
+#include "../../../../include/asm-generic/bitops/hweight.h"
diff --git a/tools/perf/util/include/asm/byteorder.h b/tools/perf/util/include/asm/byteorder.h
new file mode 100644
index 0000000..39f367c
--- /dev/null
+++ b/tools/perf/util/include/asm/byteorder.h
@@ -0,0 +1,2 @@
+#include "../asm/types.h"
+#include "../../../../include/linux/swab.h"
diff --git a/tools/perf/util/include/asm/swab.h b/tools/perf/util/include/asm/swab.h
new file mode 100644
index 0000000..ed53894
--- /dev/null
+++ b/tools/perf/util/include/asm/swab.h
@@ -0,0 +1 @@
+/* stub */
diff --git a/tools/perf/util/include/asm/types.h b/tools/perf/util/include/asm/types.h
new file mode 100644
index 0000000..06703c6
--- /dev/null
+++ b/tools/perf/util/include/asm/types.h
@@ -0,0 +1,17 @@
+#ifndef PERF_ASM_TYPES_H_
+#define PERF_ASM_TYPES_H_
+
+#include <linux/compiler.h>
+#include "../../types.h"
+#include <sys/types.h>
+
+/* CHECKME: Not sure both always match */
+#define BITS_PER_LONG	__WORDSIZE
+
+typedef u64	__u64;
+typedef u32	__u32;
+typedef u16	__u16;
+typedef u8	__u8;
+typedef s64	__s64;
+
+#endif /* PERF_ASM_TYPES_H_ */
diff --git a/tools/perf/util/include/asm/uaccess.h b/tools/perf/util/include/asm/uaccess.h
new file mode 100644
index 0000000..d0f72b8
--- /dev/null
+++ b/tools/perf/util/include/asm/uaccess.h
@@ -0,0 +1,14 @@
+#ifndef _PERF_ASM_UACCESS_H_
+#define _PERF_ASM_UACCESS_H_
+
+#define __get_user(src, dest)						\
+({									\
+	(src) = *dest;							\
+	0;								\
+})
+
+#define get_user	__get_user
+
+#define access_ok(type, addr, size)	1
+
+#endif
diff --git a/tools/perf/util/include/linux/bitmap.h b/tools/perf/util/include/linux/bitmap.h
new file mode 100644
index 0000000..821c103
--- /dev/null
+++ b/tools/perf/util/include/linux/bitmap.h
@@ -0,0 +1,2 @@
+#include "../../../../include/linux/bitmap.h"
+#include "../../../../include/asm-generic/bitops/find.h"
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
new file mode 100644
index 0000000..ace57c3
--- /dev/null
+++ b/tools/perf/util/include/linux/bitops.h
@@ -0,0 +1,27 @@
+#ifndef _PERF_LINUX_BITOPS_H_
+#define _PERF_LINUX_BITOPS_H_
+
+#define __KERNEL__
+
+#define CONFIG_GENERIC_FIND_NEXT_BIT
+#define CONFIG_GENERIC_FIND_FIRST_BIT
+#include "../../../../include/linux/bitops.h"
+
+static inline void set_bit(int nr, unsigned long *addr)
+{
+	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
+}
+
+static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
+{
+	return ((1UL << (nr % BITS_PER_LONG)) &
+		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
+}
+
+unsigned long generic_find_next_zero_le_bit(const unsigned long *addr, unsigned
+		long size, unsigned long offset);
+
+unsigned long generic_find_next_le_bit(const unsigned long *addr, unsigned
+		long size, unsigned long offset);
+
+#endif
diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
new file mode 100644
index 0000000..dfb0713
--- /dev/null
+++ b/tools/perf/util/include/linux/compiler.h
@@ -0,0 +1,10 @@
+#ifndef _PERF_LINUX_COMPILER_H_
+#define _PERF_LINUX_COMPILER_H_
+
+#ifndef __always_inline
+#define __always_inline	inline
+#endif
+#define __user
+#define __attribute_const__
+
+#endif
diff --git a/tools/perf/util/include/linux/ctype.h b/tools/perf/util/include/linux/ctype.h
new file mode 100644
index 0000000..bae5783
--- /dev/null
+++ b/tools/perf/util/include/linux/ctype.h
@@ -0,0 +1 @@
+#include "../../../../include/linux/ctype.h"
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index a6b8739..4b9204d 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -1,6 +1,16 @@
 #ifndef PERF_LINUX_KERNEL_H_
 #define PERF_LINUX_KERNEL_H_
 
+#include <stdarg.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <assert.h>
+
+#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
+
+#define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
+#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
+
 #ifndef offsetof
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
 #endif
@@ -26,4 +36,53 @@
 	_max1 > _max2 ? _max1 : _max2; })
 #endif
 
+#ifndef min
+#define min(x, y) ({				\
+	typeof(x) _min1 = (x);			\
+	typeof(y) _min2 = (y);			\
+	(void) (&_min1 == &_min2);		\
+	_min1 < _min2 ? _min1 : _min2; })
+#endif
+
+#ifndef BUG_ON
+#define BUG_ON(cond) assert(!(cond))
+#endif
+
+/*
+ * Both need more care to handle endianness
+ * (Don't use bitmap_copy_le() for now)
+ */
+#define cpu_to_le64(x)	(x)
+#define cpu_to_le32(x)	(x)
+
+static inline int
+vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
+{
+	int i;
+	ssize_t ssize = size;
+
+	i = vsnprintf(buf, size, fmt, args);
+
+	return (i >= ssize) ? (ssize - 1) : i;
+}
+
+static inline int scnprintf(char * buf, size_t size, const char * fmt, ...)
+{
+	va_list args;
+	ssize_t ssize = size;
+	int i;
+
+	va_start(args, fmt);
+	i = vsnprintf(buf, size, fmt, args);
+	va_end(args);
+
+	return (i >= ssize) ? (ssize - 1) : i;
+}
+
+static inline unsigned long
+simple_strtoul(const char *nptr, char **endptr, int base)
+{
+	return strtoul(nptr, endptr, base);
+}
+
 #endif
diff --git a/tools/perf/util/include/linux/types.h b/tools/perf/util/include/linux/types.h
new file mode 100644
index 0000000..ed53894
--- /dev/null
+++ b/tools/perf/util/include/linux/types.h
@@ -0,0 +1 @@
+/* stub */
-- 
1.6.2.3

