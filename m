Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbZJVVXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbZJVVXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 17:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756888AbZJVVXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 17:23:40 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:38015 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865AbZJVVXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 17:23:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MMK1mr17yMlZxGe4mPL3JnN9M6HIxiQ+raYJTxvJcvIFxSZRhgnpxCiLGRnhaibUXJ
         dPEAqqpyLV2FYZyjlcfkHpnyp4L+iM7yPjwjBhyTYjgc8nbamiCLkP3UVj5EqkkkaGdm
         nR0Xx659tKjadb8hOvV8xVB2e390UrjCBm6g8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>
Subject: [PATCH 3/3] perf tools: Drop asm/tytes.h wrapper
Date: Thu, 22 Oct 2009 23:23:24 +0200
Message-Id: <1256246604-17156-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1256246604-17156-1-git-send-email-fweisbec@gmail.com>
References: <1256246604-17156-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrapping the kernel headers is dangerous when it comes to arch headers.
Once we wrap asm/tytes.h, it will also replace the glibc asm/tytes.h,
not only the kernel one.

This results in build errors on some machines.

Drop this wrapper and do its work from linux/types.h wrapper, also
the glibc asm/types.h can already handle most of the type definition
it was doing (typedef __u64, __u32, etc...).

Todo: Check the others asm/*.h wrappers to prevent from other
conflicts.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
---
 tools/perf/Makefile                     |    1 -
 tools/perf/util/include/asm/bitops.h    |   12 ++++++++++++
 tools/perf/util/include/asm/byteorder.h |    2 +-
 tools/perf/util/include/asm/types.h     |   17 -----------------
 tools/perf/util/include/linux/types.h   |    2 ++
 5 files changed, 15 insertions(+), 19 deletions(-)
 delete mode 100644 tools/perf/util/include/asm/types.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1370a62..147e3cf 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -353,7 +353,6 @@ LIB_H += util/include/asm/bitops.h
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
 
-- 
1.6.2.3

