Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbYIANIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbYIANIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYIANIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:08:23 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13829 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751117AbYIANIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:08:22 -0400
Message-ID: <48BBE8F5.8020709@panasas.com>
Date: Mon, 01 Sep 2008 16:07:01 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] debug, x86: move BUILD_BUG_ON() ARRAY_SIZE and __FUNCTION__
References: <48BBE77D.7070007@panasas.com>
In-Reply-To: <48BBE77D.7070007@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Sep 2008 13:06:13.0375 (UTC) FILETIME=[82C788F0:01C90C33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

move BUILD_BUG_ON variants, ARRAY_SIZE and __FUNCTION__
definitions from kernel.h to compiler.h.

Besides being the correct location for such trivial wrappers around
compiler functionality, this also allows the removal of duplicate
definitions from arch/x86/boot/boot.h.

[ boot.h cannot just include kernel.h to pick up the new definitions,
  as it is also built into user-space utilities on the host system. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 arch/x86/boot/boot.h     |    5 -----
 include/linux/compiler.h |   14 ++++++++++++++
 include/linux/kernel.h   |   14 --------------
 3 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index cc0ef13..f09b79a 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -27,11 +27,6 @@
 #include "bitops.h"
 #include <asm/cpufeature.h>
 
-/* Useful macros */
-#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
-
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
-
 extern struct setup_header hdr;
 extern struct boot_params boot_params;
 
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index c8bd2da..90fa975 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -194,4 +194,18 @@ extern void __chk_io_ptr(const volatile void __iomem *);
  */
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
+/* Force a compilation error if condition is true */
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+
+/* Force a compilation error if condition is true, but also produce a
+   result (of value 0 and type size_t), so the expression can be used
+   e.g. in a structure initializer (or where-ever else comma expressions
+   aren't permitted). */
+#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
+
+/* Trap pasters of __FUNCTION__ at compile-time */
+#define __FUNCTION__ (__func__)
+
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+
 #endif /* __LINUX_COMPILER_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2651f80..29ca10d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -42,8 +42,6 @@ extern const char linux_proc_banner[];
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
 #define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
 
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
-
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
@@ -467,18 +465,6 @@ struct sysinfo {
 	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
 };
 
-/* Force a compilation error if condition is true */
-#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
-
-/* Force a compilation error if condition is true, but also produce a
-   result (of value 0 and type size_t), so the expression can be used
-   e.g. in a structure initializer (or where-ever else comma expressions
-   aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
-
-/* Trap pasters of __FUNCTION__ at compile-time */
-#define __FUNCTION__ (__func__)
-
 /* This helps us to avoid #ifdef CONFIG_NUMA */
 #ifdef CONFIG_NUMA
 #define NUMA_BUILD 1
