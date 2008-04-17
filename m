Return-Path: <linux-kernel-owner+w=401wt.eu-S934172AbYDQBew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934172AbYDQBew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933708AbYDQBYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:24:32 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:43319 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763068AbYDQBY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:24:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAAdEBkhMROPA/2dsb2JhbACBYKwb
Date: Wed, 16 Apr 2008 21:24:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Paul Mackerras <paulus@samba.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC patch 23/27] Immediate Values - Powerpc Optimization NMI
	MCE support
Message-ID: <20080417012420.GA11709@Krystal>
References: <20080416213426.298498397@polymtl.ca> <20080416213556.704299869@polymtl.ca> <18438.34621.508450.720068@cargo.ozlabs.ibm.com> <20080416233331.GA9225@Krystal> <18438.39737.921541.359469@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <18438.39737.921541.359469@cargo.ozlabs.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:51:57 up 47 days, 21:02,  4 users,  load average: 0.03, 0.06,
	0.07
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Mackerras (paulus@samba.org) wrote:
> Mathieu Desnoyers writes:
> 
> > * Paul Mackerras (paulus@samba.org) wrote:
> > > Mathieu Desnoyers writes:
> > > 
> > > > Use an atomic update for immediate values.
> > > 
> > > What is meant by an "atomic" update in this context?  AFAICS you are
> > > using memcpy, which is not in any way guaranteed to be atomic.
> > > 
> > > Paul.
> > 
> > I expect memcpy to perform the copy in one memory access, given I put a 
> > 
> >   .align 2
> > 
> > before the 2 bytes instruction. It makes sure the instruction modified
> > fits in a single, aligned, memory write.
> 
> My original question was in the context of the powerpc architecture,
> where instructions are always 4 bytes long and aligned.  So that's not
> an issue.
> 

Sorry, I meant 4 byte instruction with 2 bytes immediate value, but we
both understand it would be a memory write aligned on 2 bytes since we
only change the immediate value.

> > Or maybe am I expecting too much from memcpy ?
> 
> I don't think memcpy gives you any such guarantees.  It would be quite
> within its rights to say "it's only a few bytes, I'll do it byte by
> byte".
> 
> If you really want it to be atomic (which I agree is probably a good
> idea), I think the best way to do it is to use an asm to generate a
> sth (store halfword) instruction to the immediate field (instruction
> address + 2).  That's on powerpc of course; I don't know what you
> would do on other architectures.
> 

A simple 

  *(uint16_t* )destptr = newvalue;

seems to generate the "sth" instruction.

Do you see any reason why the compiler could choose a different, non
atomic assembler primitive ?

quoting Documentation/RCU/whatisRCU.txt :

"In contrast, RCU-based updaters typically take advantage of the fact
that writes to single aligned pointers are atomic on modern CPUs"

Paul E. McKenney could say if I am wrong if I assume that any object
smaller or equal to the architecture pointer size, aligned on a multiple
of its own size, will be read or written atomically.

Therefore, I would suggest the following replacement patch :


Immediate Values - Powerpc Optimization NMI MCE support

Use an atomic update for immediate values.

- Changelog :
Use a direct assignment instead of memcpy to be sure the update is
atomic.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Hellwig <hch@infradead.org>
CC: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/Makefile    |    1 
 arch/powerpc/kernel/immediate.c |   70 ++++++++++++++++++++++++++++++++++++++++
 include/asm-powerpc/immediate.h |   18 ++++++++++
 3 files changed, 89 insertions(+)

Index: linux-2.6-lttng/arch/powerpc/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/powerpc/kernel/immediate.c	2008-04-16 21:22:29.000000000 -0400
@@ -0,0 +1,70 @@
+/*
+ * Powerpc optimized immediate values enabling/disabling.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/module.h>
+#include <linux/immediate.h>
+#include <linux/string.h>
+#include <linux/kprobes.h>
+#include <asm/cacheflush.h>
+#include <asm/page.h>
+
+#define LI_OPCODE_LEN	2
+
+/**
+ * arch_imv_update - update one immediate value
+ * @imv: pointer of type const struct __imv to update
+ * @early: early boot (1), normal (0)
+ *
+ * Update one immediate value. Must be called with imv_mutex held.
+ */
+int arch_imv_update(const struct __imv *imv, int early)
+{
+#ifdef CONFIG_KPROBES
+	kprobe_opcode_t *insn;
+	/*
+	 * Fail if a kprobe has been set on this instruction.
+	 * (TODO: we could eventually do better and modify all the (possibly
+	 * nested) kprobes for this site if kprobes had an API for this.
+	 */
+	switch (imv->size) {
+	case 1:	/* The uint8_t points to the 3rd byte of the
+		 * instruction */
+		insn = (void *)(imv->imv - 1 - LI_OPCODE_LEN);
+		break;
+	case 2:	insn = (void *)(imv->imv - LI_OPCODE_LEN);
+		break;
+	default:
+	return -EINVAL;
+	}
+
+	if (unlikely(!early && *insn == BREAKPOINT_INSTRUCTION)) {
+		printk(KERN_WARNING "Immediate value in conflict with kprobe. "
+				    "Variable at %p, "
+				    "instruction at %p, size %lu\n",
+				    (void *)imv->imv,
+				    (void *)imv->var, imv->size);
+		return -EBUSY;
+	}
+#endif
+
+	/*
+	 * If the variable and the instruction have the same value, there is
+	 * nothing to do.
+	 */
+	switch (imv->size) {
+	case 1:	if (*(uint8_t *)imv->imv == *(uint8_t *)imv->var)
+			return 0;
+		*(uint8_t *)imv->imv = *(uint8_t *)imv->var;
+		break;
+	case 2:	if (*(uint16_t *)imv->imv == *(uint16_t *)imv->var)
+			return 0;
+		*(uint16_t *)imv->imv = *(uint16_t *)imv->var;
+		break;
+	default:return -EINVAL;
+	}
+	flush_icache_range(imv->imv, imv->imv + imv->size);
+	return 0;
+}
Index: linux-2.6-lttng/include/asm-powerpc/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-powerpc/immediate.h	2008-04-16 12:25:42.000000000 -0400
+++ linux-2.6-lttng/include/asm-powerpc/immediate.h	2008-04-16 20:49:48.000000000 -0400
@@ -12,6 +12,16 @@
 
 #include <asm/asm-compat.h>
 
+struct __imv {
+	unsigned long var;	/* Identifier variable of the immediate value */
+	unsigned long imv;	/*
+				 * Pointer to the memory location that holds
+				 * the immediate value within the load immediate
+				 * instruction.
+				 */
+	unsigned char size;	/* Type size. */
+} __attribute__ ((packed));
+
 /**
  * imv_read - read immediate variable
  * @name: immediate value name
@@ -19,6 +29,11 @@
  * Reads the value of @name.
  * Optimized version of the immediate.
  * Do not use in __init and __exit functions. Use _imv_read() instead.
+ * Makes sure the 2 bytes update will be atomic by aligning the immediate
+ * value. Use a normal memory read for the 4 bytes immediate because there is no
+ * way to atomically update it without using a seqlock read side, which would
+ * cost more in term of total i-cache and d-cache space than a simple memory
+ * read.
  */
 #define imv_read(name)							\
 	({								\
@@ -40,6 +55,7 @@
 					PPC_LONG "%c1, ((1f)-2)\n\t"	\
 					".byte 2\n\t"			\
 					".previous\n\t"			\
+					".align 2\n\t"			\
 					"li %0,0\n\t"			\
 					"1:\n\t"			\
 				: "=r" (value)				\
@@ -52,4 +68,6 @@
 		value;							\
 	})
 
+extern int arch_imv_update(const struct __imv *imv, int early);
+
 #endif /* _ASM_POWERPC_IMMEDIATE_H */
Index: linux-2.6-lttng/arch/powerpc/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/Makefile	2008-04-16 12:23:07.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/kernel/Makefile	2008-04-16 12:25:44.000000000 -0400
@@ -45,6 +45,7 @@ obj-$(CONFIG_HIBERNATION)	+= swsusp.o su
 obj64-$(CONFIG_HIBERNATION)	+= swsusp_asm64.o
 obj-$(CONFIG_MODULES)		+= module_$(CONFIG_WORD_SIZE).o
 obj-$(CONFIG_44x)		+= cpu_setup_44x.o
+obj-$(CONFIG_IMMEDIATE)		+= immediate.o
 
 ifeq ($(CONFIG_PPC_MERGE),y)
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
