Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbZBKKtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbZBKKtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbZBKKsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:48:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33249 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493AbZBKKsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:48:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <19f34abd0902101956t2af01f9cifeab655c1f6625eb@mail.gmail.com>
References: <19f34abd0902101956t2af01f9cifeab655c1f6625eb@mail.gmail.com> <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <19f34abd0902092310g513fb776s2e4d37285c8fa7be@mail.gmail.com> <20090210162708.6FBF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
To: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Serge Hallyn <serue@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Date: Wed, 11 Feb 2009 10:48:31 +0000
Message-ID: <12760.1234349311@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Will refine my test program to see if I can trigger this immediately
> and accurately.

I'm running two copies of:

	#include <stdlib.h>
	#include <unistd.h>

	int main()
	{
		for (;;) {
			if (setreuid(0, 99999) < 0) {
				perror("setreuid A");
				exit(1);
			}
			if (setreuid(99999, 0) < 0) {
				perror("setreuid B");
				exit(1);
			}
		}
	}

but it doesn't seem to be showing anything interesting.  I have the attached
patch compiled into my kernel and enabled in the hope it might catch either
this bug or Ingo's key slab corruption bug.

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Attempt to catch atomic_dec_and_test() on freed and poisoned slab memory

Add an option to attempt to catch atomic_dec_and_test() on freed and poisoned
slab memory by complaining if the counter LSB is the poison value.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/include/asm/atomic_32.h |    8 ++++++++
 arch/x86/include/asm/atomic_64.h |    8 ++++++++
 lib/Kconfig.debug                |   10 ++++++++++
 lib/Makefile                     |    1 +
 lib/debug_poisoned_put.c         |   39 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100644 lib/debug_poisoned_put.c


diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index 85b46fb..b0b1a7c 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -101,6 +101,10 @@ static inline void atomic_dec(atomic_t *v)
 		     : "+m" (v->counter));
 }
 
+#ifdef CONFIG_DEBUG_POISONED_PUT
+extern void check_atomic_dec_and_test(atomic_t *v);
+#endif
+
 /**
  * atomic_dec_and_test - decrement and test
  * @v: pointer of type atomic_t
@@ -113,6 +117,10 @@ static inline int atomic_dec_and_test(atomic_t *v)
 {
 	unsigned char c;
 
+#ifdef CONFIG_DEBUG_POISONED_PUT
+	check_atomic_dec_and_test(v);
+#endif
+
 	asm volatile(LOCK_PREFIX "decl %0; sete %1"
 		     : "+m" (v->counter), "=qm" (c)
 		     : : "memory");
diff --git a/arch/x86/include/asm/atomic_64.h b/arch/x86/include/asm/atomic_64.h
index 8c21731..6a7f228 100644
--- a/arch/x86/include/asm/atomic_64.h
+++ b/arch/x86/include/asm/atomic_64.h
@@ -102,6 +102,10 @@ static inline void atomic_dec(atomic_t *v)
 		     : "m" (v->counter));
 }
 
+#ifdef CONFIG_DEBUG_POISONED_PUT
+extern void check_atomic_dec_and_test(atomic_t *v);
+#endif
+
 /**
  * atomic_dec_and_test - decrement and test
  * @v: pointer of type atomic_t
@@ -114,6 +118,10 @@ static inline int atomic_dec_and_test(atomic_t *v)
 {
 	unsigned char c;
 
+#ifdef CONFIG_DEBUG_POISONED_PUT
+	check_atomic_dec_and_test(v);
+#endif
+
 	asm volatile(LOCK_PREFIX "decl %0; sete %1"
 		     : "=m" (v->counter), "=qm" (c)
 		     : "m" (v->counter) : "memory");
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 29044f5..bb5801b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -221,6 +221,16 @@ config TIMER_STATS
 	  (it defaults to deactivated on bootup and will only be activated
 	  if some application like powertop activates it explicitly).
 
+config DEBUG_POISONED_PUT
+	bool "Catch puts of already released memory"
+	depends on DEBUG_KERNEL
+	help
+	  If you say Y here, atomic_dec_and_test() will complain if it sees
+	  what might be a poisoned value from a released slab object or a
+	  counter already reduced to nothing.  Note that this test cannot say
+	  for certain that the value is in error - the value on the counter
+	  might be completely legitimate.
+
 config DEBUG_OBJECTS
 	bool "Debug object operations"
 	depends on DEBUG_KERNEL
diff --git a/lib/Makefile b/lib/Makefile
index 32b0e64..c47cc74 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_PLIST) += plist.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
+obj-$(CONFIG_DEBUG_POISONED_PUT) += debug_poisoned_put.o
 
 ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
   lib-y += dec_and_lock.o
diff --git a/lib/debug_poisoned_put.c b/lib/debug_poisoned_put.c
new file mode 100644
index 0000000..1e04325
--- /dev/null
+++ b/lib/debug_poisoned_put.c
@@ -0,0 +1,39 @@
+/* Deal with a poisoned atomic counter
+ *
+ * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/poison.h>
+#include <linux/module.h>
+#include <asm/atomic.h>
+
+/*
+ * Check to see if an atomic_dec_and_test() is being performed on released
+ * and poisoned memory
+ */
+extern void check_atomic_dec_and_test(atomic_t *v)
+{
+	int c = v->counter;
+
+	if (unlikely(
+#ifdef CONFIG_DEBUG_SLAB
+		    c == (POISON_FREE << 24 |
+			  POISON_FREE << 16 |
+			  POISON_FREE << 8 |
+			  POISON_FREE) ||
+#endif
+		    c <= 0)) {
+		printk(KERN_WARNING "atomic_dec_and_test() of suspicious value."
+		       " insn=%p addr=%p val=%d\n",
+		       __builtin_return_address(0), v, c);
+		dump_stack();
+	}
+}
+EXPORT_SYMBOL(check_atomic_dec_and_test);
