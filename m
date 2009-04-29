Return-Path: <linux-kernel-owner+w=401wt.eu-S932522AbZD3Pnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbZD3Pnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932412AbZD3PmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51942 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbZD3PmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:00 -0400
Message-Id: <7480c4c34592fd853c09c48fc0d50ee5630d646f.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 29 Apr 2009 16:51:52 +0200
Subject: [PATCH 02/27] asm-generic: add generic atomic.h
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX190ex8fE609DLM6TS2PjQ0Jgomiy1HL/Ao2vLv
 X5Fm7SkHZkDYRzbxtBSMVgKD7q5h1Jo3O5X3UZeAE7stug8p13
 4mntHG1iNM/Wy1ZH9YdNw==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atomic.h implementation from mn10300 is generic enough
that we can use it as a template for all future architectures.
Those architectures that do not have native atomic operations
or SMP can use this file directly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/atomic.h |  165 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 165 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/atomic.h

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
new file mode 100644
index 0000000..f4bc212
--- /dev/null
+++ b/include/asm-generic/atomic.h
@@ -0,0 +1,165 @@
+/*
+ * Generic C implementation of atomic counter operations
+ * Originally implemented for MN10300.
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef __ASM_GENERIC_ATOMIC_H
+#define __ASM_GENERIC_ATOMIC_H
+
+#ifdef CONFIG_SMP
+#error not SMP safe
+#endif
+
+/*
+ * Atomic operations that C can't guarantee us.  Useful for
+ * resource counting etc..
+ */
+
+#define ATOMIC_INIT(i)	{ (i) }
+
+#ifdef __KERNEL__
+
+/**
+ * atomic_read - read atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically reads the value of @v.  Note that the guaranteed
+ * useful range of an atomic_t is only 24 bits.
+ */
+#define atomic_read(v)	((v)->counter)
+
+/**
+ * atomic_set - set atomic variable
+ * @v: pointer of type atomic_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.  Note that the guaranteed
+ * useful range of an atomic_t is only 24 bits.
+ */
+#define atomic_set(v, i) (((v)->counter) = (i))
+
+#include <asm/system.h>
+
+/**
+ * atomic_add_return - add integer to atomic variable
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v and returns the result
+ * Note that the guaranteed useful range of an atomic_t is only 24 bits.
+ */
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	unsigned long flags;
+	int temp;
+
+	local_irq_save(flags);
+	temp = v->counter;
+	temp += i;
+	v->counter = temp;
+	local_irq_restore(flags);
+
+	return temp;
+}
+
+/**
+ * atomic_sub_return - subtract integer from atomic variable
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically subtracts @i from @v and returns the result
+ * Note that the guaranteed useful range of an atomic_t is only 24 bits.
+ */
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	unsigned long flags;
+	int temp;
+
+	local_irq_save(flags);
+	temp = v->counter;
+	temp -= i;
+	v->counter = temp;
+	local_irq_restore(flags);
+
+	return temp;
+}
+
+static inline int atomic_add_negative(int i, atomic_t *v)
+{
+	return atomic_add_return(i, v) < 0;
+}
+
+static inline void atomic_add(int i, atomic_t *v)
+{
+	atomic_add_return(i, v);
+}
+
+static inline void atomic_sub(int i, atomic_t *v)
+{
+	atomic_sub_return(i, v);
+}
+
+static inline void atomic_inc(atomic_t *v)
+{
+	atomic_add_return(1, v);
+}
+
+static inline void atomic_dec(atomic_t *v)
+{
+	atomic_sub_return(1, v);
+}
+
+#define atomic_dec_return(v)		atomic_sub_return(1, (v))
+#define atomic_inc_return(v)		atomic_add_return(1, (v))
+
+#define atomic_sub_and_test(i, v)	(atomic_sub_return((i), (v)) == 0)
+#define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
+#define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
+
+#define atomic_add_unless(v, a, u)				\
+({								\
+	int c, old;						\
+	c = atomic_read(v);					\
+	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
+		c = old;					\
+	c != (u);						\
+})
+
+#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
+
+static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
+{
+	unsigned long flags;
+
+	mask = ~mask;
+	local_irq_save(flags);
+	*addr &= mask;
+	local_irq_restore(flags);
+}
+
+#define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
+#define atomic_cmpxchg(v, old, new)	(cmpxchg(&((v)->counter), (old), (new)))
+
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+/* Atomic operations are already serializing on MN10300??? */
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
+#include <asm-generic/atomic-long.h>
+
+#endif /* __KERNEL__ */
+#endif /* __ASM_GENERIC_ATOMIC_H */
-- 
1.5.6.3


