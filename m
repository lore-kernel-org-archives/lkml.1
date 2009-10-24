Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbZJXBHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbZJXBHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZJXBHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:07:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:51736 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbZJXBEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:50 -0400
Date: Sat, 24 Oct 2009 01:04:02 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, paulus@samba.org,
       acme@redhat.com, hpa@zytor.com, mingo@redhat.com, efault@gmx.de,
       peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       anton@samba.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
       efault@gmx.de, fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1256246604-17156-3-git-send-email-fweisbec@gmail.com>
References: <1256246604-17156-3-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] perf tools: Drop asm/types.h wrapper
Message-ID: <tip-802da5f2289bbe363acef084805195c11f453c48@git.kernel.org>
Git-Commit-ID: 802da5f2289bbe363acef084805195c11f453c48
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  802da5f2289bbe363acef084805195c11f453c48
Gitweb:     http://git.kernel.org/tip/802da5f2289bbe363acef084805195c11f453c48
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 22 Oct 2009 23:23:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Oct 2009 07:55:19 +0200

perf tools: Drop asm/types.h wrapper

Wrapping the kernel headers is dangerous when it comes to arch
headers. Once we wrap asm/types.h, it will also replace the
glibc asm/types.h, not only the kernel one.

This results in build errors on some machines.

Drop this wrapper and do its work from linux/types.h wrapper,
also the glibc asm/types.h can already handle most of the type
definition it was doing (typedef __u64, __u32, etc...).

Todo: Check the others asm/*.h wrappers to prevent from other
conflicts.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
LKML-Reference: <1256246604-17156-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile                     |    1 -
 tools/perf/util/include/asm/bitops.h    |   12 ++++++++++++
 tools/perf/util/include/asm/byteorder.h |    2 +-
 tools/perf/util/include/asm/types.h     |   17 -----------------
 tools/perf/util/include/linux/types.h   |    2 ++
 5 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 65e6e52..0a40c29 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -352,7 +352,6 @@ LIB_H += util/include/asm/bitops.h
 LIB_H += util/include/asm/byteorder.h
 LIB_H += util/include/asm/swab.h
 LIB_H += util/include/asm/system.h
-LIB_H += util/include/asm/types.h
 LIB_H += util/include/asm/uaccess.h
 LIB_H += perf.h
 LIB_H += util/event.h
diff --git a/tools/perf/util/include/asm/bitops.h b/tools/perf/util/include/asm/bitops.h
index fbe4d92..58e9817 100644
--- a/tools/perf/util/include/asm/bitops.h
+++ b/tools/perf/util/include/asm/bitops.h
@@ -1,6 +1,18 @@
+#ifndef _PERF_ASM_BITOPS_H_
+#define _PERF_ASM_BITOPS_H_
+
+#include <sys/types.h>
+#include "../../types.h"
+#include <linux/compiler.h>
+
+/* CHECKME: Not sure both always match */
+#define BITS_PER_LONG	__WORDSIZE
+
 #include "../../../../include/asm-generic/bitops/__fls.h"
 #include "../../../../include/asm-generic/bitops/fls.h"
 #include "../../../../include/asm-generic/bitops/fls64.h"
 #include "../../../../include/asm-generic/bitops/__ffs.h"
 #include "../../../../include/asm-generic/bitops/ffz.h"
 #include "../../../../include/asm-generic/bitops/hweight.h"
+
+#endif
diff --git a/tools/perf/util/include/asm/byteorder.h b/tools/perf/util/include/asm/byteorder.h
index 39f367c..b722abe 100644
--- a/tools/perf/util/include/asm/byteorder.h
+++ b/tools/perf/util/include/asm/byteorder.h
@@ -1,2 +1,2 @@
-#include "../asm/types.h"
+#include <asm/types.h>
 #include "../../../../include/linux/swab.h"
diff --git a/tools/perf/util/include/asm/types.h b/tools/perf/util/include/asm/types.h
deleted file mode 100644
index 06703c6..0000000
--- a/tools/perf/util/include/asm/types.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef PERF_ASM_TYPES_H_
-#define PERF_ASM_TYPES_H_
-
-#include <linux/compiler.h>
-#include "../../types.h"
-#include <sys/types.h>
-
-/* CHECKME: Not sure both always match */
-#define BITS_PER_LONG	__WORDSIZE
-
-typedef u64	__u64;
-typedef u32	__u32;
-typedef u16	__u16;
-typedef u8	__u8;
-typedef s64	__s64;
-
-#endif /* PERF_ASM_TYPES_H_ */
diff --git a/tools/perf/util/include/linux/types.h b/tools/perf/util/include/linux/types.h
index 858a38d..196862a 100644
--- a/tools/perf/util/include/linux/types.h
+++ b/tools/perf/util/include/linux/types.h
@@ -1,6 +1,8 @@
 #ifndef _PERF_LINUX_TYPES_H_
 #define _PERF_LINUX_TYPES_H_
 
+#include <asm/types.h>
+
 #define DECLARE_BITMAP(name,bits) \
 	unsigned long name[BITS_TO_LONGS(bits)]
 
