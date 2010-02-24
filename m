Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab0BXJzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 04:55:07 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:65005 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab0BXJye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 04:54:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=phOezvvIPBiDoqO3DNpjhO7vMm+JM+UdAhd9bP4nH10h9GHgSdzYFQ0KlWh6le+Ox2
         zRZCx9h6+ghbVffygKYhW+iG8mP5RLstBl+JdnSI2vIXjT8XFjw0NI8+SNzhtY2RitR/
         Nl0KC4ihiiKkFOkKGce2xXCKbnC+tfQP98xzQ=
From: Luca Barbieri <luca@luca-barbieri.com>
To: hpa@zytor.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 3/4] lib: add self-test for atomic64_t
Date: Wed, 24 Feb 2010 10:54:24 +0100
Message-Id: <1267005265-27958-4-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1267005265-27958-1-git-send-email-luca@luca-barbieri.com>
References: <1267005265-27958-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds self-test on boot code for atomic64_t.

This has been used to test the later changes in this patchset.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 lib/Kconfig.debug   |    7 ++
 lib/Makefile        |    2 +
 lib/atomic64_test.c |  158 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 167 insertions(+), 0 deletions(-)
 create mode 100644 lib/atomic64_test.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 25c3ed5..3676c51 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1054,6 +1054,13 @@ config DMA_API_DEBUG
 	  This option causes a performance degredation.  Use only if you want
 	  to debug device drivers. If unsure, say N.
 
+config ATOMIC64_SELFTEST
+	bool "Perform an atomic64_t self-test at boot"
+	help
+	  Enable this option to test the atomic64_t functions at boot.
+
+	  If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
diff --git a/lib/Makefile b/lib/Makefile
index 347ad8d..4af4786 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -99,6 +99,8 @@ obj-$(CONFIG_GENERIC_CSUM) += checksum.o
 
 obj-$(CONFIG_GENERIC_ATOMIC64) += atomic64.o
 
+obj-$(CONFIG_ATOMIC64_SELFTEST) += atomic64_test.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
new file mode 100644
index 0000000..4ff649e
--- /dev/null
+++ b/lib/atomic64_test.c
@@ -0,0 +1,158 @@
+/*
+ * Testsuite for atomic64_t functions
+ *
+ * Copyright © 2010  Luca Barbieri
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/init.h>
+#include <asm/atomic.h>
+
+#define INIT(c) do { atomic64_set(&v, c); r = c; } while (0)
+static __init int test_atomic64(void)
+{
+	long long v0 = 0xaaa31337c001d00dLL;
+	long long v1 = 0xdeadbeefdeafcafeLL;
+	long long v2 = 0xfaceabadf00df001LL;
+	long long onestwos = 0x1111111122222222LL;
+	long long one = 1LL;
+
+	atomic64_t v = ATOMIC64_INIT(v0);
+	long long r = v0;
+	BUG_ON(v.counter != r);
+
+	atomic64_set(&v, v1);
+	r = v1;
+	BUG_ON(v.counter != r);
+	BUG_ON(atomic64_read(&v) != r);
+
+	INIT(v0);
+	atomic64_add(onestwos, &v);
+	r += onestwos;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	atomic64_add(-one, &v);
+	r += -one;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	r += onestwos;
+	BUG_ON(atomic64_add_return(onestwos, &v) != r);
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	r += -one;
+	BUG_ON(atomic64_add_return(-one, &v) != r);
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	atomic64_sub(onestwos, &v);
+	r -= onestwos;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	atomic64_sub(-one, &v);
+	r -= -one;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	r -= onestwos;
+	BUG_ON(atomic64_sub_return(onestwos, &v) != r);
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	r -= -one;
+	BUG_ON(atomic64_sub_return(-one, &v) != r);
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	atomic64_inc(&v);
+	r += one;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	r += one;
+	BUG_ON(atomic64_inc_return(&v) != r);
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	atomic64_dec(&v);
+	r -= one;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	r -= one;
+	BUG_ON(atomic64_dec_return(&v) != r);
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	BUG_ON(atomic64_xchg(&v, v1) != v0);
+	r = v1;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	BUG_ON(atomic64_cmpxchg(&v, v0, v1) != v0);
+	r = v1;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	BUG_ON(atomic64_cmpxchg(&v, v2, v1) != v0);
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	BUG_ON(!atomic64_add_unless(&v, one, v0));
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	BUG_ON(atomic64_add_unless(&v, one, v1));
+	r += one;
+	BUG_ON(v.counter != r);
+
+	INIT(onestwos);
+	BUG_ON(atomic64_dec_if_positive(&v) != (onestwos - 1));
+	r -= one;
+	BUG_ON(v.counter != r);
+
+	INIT(0);
+	BUG_ON(atomic64_dec_if_positive(&v) != -one);
+	BUG_ON(v.counter != r);
+
+	INIT(-one);
+	BUG_ON(atomic64_dec_if_positive(&v) != (-one - one));
+	BUG_ON(v.counter != r);
+
+	INIT(onestwos);
+	BUG_ON(atomic64_inc_not_zero(&v));
+	r += one;
+	BUG_ON(v.counter != r);
+
+	INIT(0);
+	BUG_ON(!atomic64_inc_not_zero(&v));
+	BUG_ON(v.counter != r);
+
+	INIT(-one);
+	BUG_ON(atomic64_inc_not_zero(&v));
+	r += one;
+	BUG_ON(v.counter != r);
+
+#ifdef CONFIG_X86
+	printk(KERN_INFO "atomic64 test passed for %s+ platform %s CX8 and %s SSE\n",
+#ifdef CONFIG_X86_CMPXCHG64
+			"586",
+#else
+			"386",
+#endif
+			boot_cpu_has(X86_FEATURE_CX8) ? "with" : "without",
+			boot_cpu_has(X86_FEATURE_XMM) ? "with" : "without");
+#else
+	printk(KERN_INFO "atomic64 test passed\n");
+#endif
+
+	return 0;
+}
+
+core_initcall(test_atomic64);
-- 
1.6.6.1.476.g01ddb

