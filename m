Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbXLUNYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbXLUNYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 08:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXLUNYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 08:24:37 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:46658 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000AbXLUNYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 08:24:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAARNa0dMROHU/2dsb2JhbACBV6dz
Date: Fri, 21 Dec 2007 08:19:32 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 14/24] Immediate Values - x86 Optimization (updated)
Message-ID: <20071221131932.GB30372@Krystal>
References: <20071221015438.433195466@polymtl.ca> <20071221015726.909058404@polymtl.ca> <476B2B5E.5060204@zytor.com> <20071221031900.GA2414@Krystal> <476B335C.5080905@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <476B335C.5080905@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:18:14 up 47 days, 18:23,  3 users,  load average: 0.21, 0.39,
	0.69
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 optimization of the immediate values which uses a movl with code patching
to set/unset the value used to populate the register used as variable source.

Changelog:
- Use text_poke_early with cr0 WP save/restore to patch the bypass. We are doing
  non atomic writes to a code region only touched by us (nobody can execute it
  since we are protected by the imv_mutex).
- Put imv_set and _imv_set in the architecture independent header.
- Use $0 instead of %2 with (0) operand.
- Add x86_64 support, ready for i386+x86_64 -> x86 merge.
- Use asm-x86/asm.h.

Ok, so the most flexible solution that I see, that should fit for both
x86 and x86_64 would be :
1 byte  :       "=q" : "a", "b", "c", or "d" register for the i386.  For
                       x86-64 it is equivalent to "r" class (for 8-bit
                       instructions that do not use upper halves).
2, 4, 8 bytes : "=r" : A register operand is allowed provided that it is in a
                       general register.

- "Redux" immediate values : no need to put a breakpoint, therefore, no
  need to know where the instruction starts. It's therefore OK to have a
  REX prefix.

- Bugfix : 8 bytes 64 bits immediate value was declared as "4 bytes" in the
  immediate structure.
- Change the immediate.c update code to support variable length opcodes.
- Vastly simplified, using a busy looping IPI with interrupts disabled.
  Does not protect against NMI nor MCE.
- Pack the __imv section. Use smallest types required for size (char).
- Use imv_* instead of immediate_*.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <ak@muc.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Chuck Ebbert <cebbert@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/Kconfig            |    1 
 include/asm-x86/immediate.h |   77 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

Index: linux-2.6-lttng.mm/include/asm-x86/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng.mm/include/asm-x86/immediate.h	2007-12-20 18:55:00.000000000 -0500
@@ -0,0 +1,77 @@
+#ifndef _ASM_X86_IMMEDIATE_H
+#define _ASM_X86_IMMEDIATE_H
+
+/*
+ * Immediate values. x86 architecture optimizations.
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm/asm.h>
+
+/**
+ * imv_read - read immediate variable
+ * @name: immediate value name
+ *
+ * Reads the value of @name.
+ * Optimized version of the immediate.
+ * Do not use in __init and __exit functions. Use _imv_read() instead.
+ * If size is bigger than the architecture long size, fall back on a memory
+ * read.
+ *
+ * Make sure to populate the initial static 64 bits opcode with a value
+ * what will generate an instruction with 8 bytes immediate value (not the REX.W
+ * prefixed one that loads a sign extended 32 bits immediate value in a r64
+ * register).
+ */
+#define imv_read(name)							\
+	({								\
+		__typeof__(name##__imv) value;				\
+		BUILD_BUG_ON(sizeof(value) > 8);			\
+		switch (sizeof(value)) {				\
+		case 1:							\
+			asm(".section __imv,\"a\",@progbits\n\t"	\
+				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
+				".byte %c2\n\t"				\
+				".previous\n\t"				\
+				"mov $0,%0\n\t"				\
+				"3:\n\t"				\
+				: "=q" (value)				\
+				: "i" (&name##__imv),			\
+				  "i" (sizeof(value)));			\
+			break;						\
+		case 2:							\
+		case 4:							\
+			asm(".section __imv,\"a\",@progbits\n\t"	\
+				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
+				".byte %c2\n\t"				\
+				".previous\n\t"				\
+				"mov $0,%0\n\t"				\
+				"3:\n\t"				\
+				: "=r" (value)				\
+				: "i" (&name##__imv),			\
+				  "i" (sizeof(value)));			\
+			break;						\
+		case 8:							\
+			if (sizeof(long) < 8) {				\
+				value = name##__imv;			\
+				break;					\
+			}						\
+			asm(".section __imv,\"a\",@progbits\n\t"	\
+				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
+				".byte %c2\n\t"				\
+				".previous\n\t"				\
+				"mov $0xFEFEFEFE01010101,%0\n\t" 	\
+				"3:\n\t"				\
+				: "=r" (value)				\
+				: "i" (&name##__imv),			\
+				  "i" (sizeof(value)));			\
+			break;						\
+		};							\
+		value;							\
+	})
+
+#endif /* _ASM_X86_IMMEDIATE_H */
Index: linux-2.6-lttng.mm/arch/x86/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/x86/Kconfig	2007-12-20 18:43:46.000000000 -0500
+++ linux-2.6-lttng.mm/arch/x86/Kconfig	2007-12-20 18:55:00.000000000 -0500
@@ -20,6 +20,7 @@ config X86
 	def_bool y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_IMMEDIATE
 
 config GENERIC_TIME
 	def_bool y

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
