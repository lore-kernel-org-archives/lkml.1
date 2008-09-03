Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYICKQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYICKQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYICKQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:16:31 -0400
Received: from portal.weinmann.de ([62.8.140.122]:45057 "EHLO
	mail-weinmann.hamburg.kkf.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607AbYICKQa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:16:30 -0400
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2008 06:16:30 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] Add kernel support for oprofile callgraphs on AVR32
Date: Wed, 3 Sep 2008 12:08:55 +0200
Message-ID: <4A01BA1129E3AD489AA4409A99D9076775A42C@wm020.weinmann.com>
In-Reply-To: <20080903112930.56ebac51@hskinnemo-gx745.norway.atmel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Add kernel support for oprofile callgraphs on AVR32
Thread-Index: AckNp6qXh0zXBZ9mQxWX7bTmDfQQcAAAgBgg
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Cc: <kernel@avr32linux.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Hmm. This appears to be the third backtracer added to avr32, the first
> two being dump_stack() and friends in arch/avr32/kernel/process.c, and
> save_stack_trace() in arch/avr32/kernel/stacktrace.c.
> 
> Would be nice if some of this could be consolidated.

I considered using one of them, in fact I also have a version with an
extended stacktrace.c. But due to the small size of the kernel stacktracer
(only a few lines), I found it cleaner to create a separate version. The
overall size is smaller and it cannot potentially mess up other things.
Cf. e.g. the x86 tracer which is of the generic type, but comparatively big
and hard to follow through the places.

> > +	if (head >= bufhead[0].fp)
> 
> Could you swap the two operand so that it matches...

[...]

> > +			if (head->fp <= head)
> 
> ...this?

Sure, modified patch attached.

> > +		/* Assume we have frame pointers in user mode process */
> 
> What happens if we don't? I assume it will stop when it detects that
> the frame pointer isn't monotonically increasing or when it gets a
> fault?

Right. This might lead to false information in oprofile, this case is
described in the oprofile docs. 

Thanks for reviewing,
Niko

---

From: Nikolaus Voss <n.voss@weinmann.de>

This patch adds backtracing capability to oprofile profiling in kernel
and user mode on AVR32. This is done by going through the frames on the stack
and adding oprofile traces for all return addresses. The code being profiled has
to be compiled with frame pointers to make this work.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
diff --git a/arch/avr32/oprofile/Makefile b/arch/avr32/oprofile/Makefile
index 1fe81c3..e0eb520 100644
--- a/arch/avr32/oprofile/Makefile
+++ b/arch/avr32/oprofile/Makefile
@@ -5,4 +5,4 @@ oprofile-y		:= $(addprefix ../../../drivers/oprofile/,	\
 				event_buffer.o oprofile_files.o		\
 				oprofilefs.o oprofile_stats.o		\
 				timer_int.o)
-oprofile-y		+= op_model_avr32.o
+oprofile-y		+= op_model_avr32.o backtrace.o
diff --git a/arch/avr32/oprofile/backtrace.c b/arch/avr32/oprofile/backtrace.c
new file mode 100644
index 0000000..ab31491
--- /dev/null
+++ b/arch/avr32/oprofile/backtrace.c
@@ -0,0 +1,81 @@
+/*
+ * AVR32 specific backtracing code for oprofile
+ *
+ * Copyright 2008 Weinmann GmbH
+ * 
+ * Author: Nikolaus Voss <n.voss@weinmann.de>
+ *
+ * Based on i386 oprofile backtrace code by John Levon and David Smith
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/oprofile.h>
+#include <linux/sched.h>
+#include <asm/uaccess.h>
+
+/* The first two words of each frame on the stack look like this if we have
+ * frame pointers */
+struct frame_head {
+	unsigned long lr;
+	struct frame_head *fp;
+};
+
+/* copied from arch/avr32/kernel/process.c */
+static inline int valid_stack_ptr(struct thread_info *tinfo, unsigned long p)
+{
+	return (p > (unsigned long)tinfo)
+		&& (p < (unsigned long)tinfo + THREAD_SIZE - 3);
+}
+
+/* copied from arch/x86/oprofile/backtrace.c */
+static struct frame_head * dump_user_backtrace(struct frame_head *head)
+{
+	struct frame_head bufhead[2];
+
+	/* Also check accessibility of one struct frame_head beyond */
+	if (!access_ok(VERIFY_READ, head, sizeof(bufhead)))
+		return NULL;
+	if (__copy_from_user_inatomic(bufhead, head, sizeof(bufhead)))
+		return NULL;
+
+	oprofile_add_trace(bufhead[0].lr);
+
+	/* frame pointers should strictly progress back up the stack
+	 * (towards higher addresses) */
+	if (bufhead[0].fp <= head)
+		return NULL;
+
+	return bufhead[0].fp;
+}
+
+void avr32_backtrace(struct pt_regs * const regs, unsigned int depth)
+{
+	/* Get first frame pointer */
+	struct frame_head *head = (struct frame_head *)(regs->r7);
+	
+	if (!user_mode(regs)) {
+#ifdef CONFIG_FRAME_POINTER
+		/*
+		 * Traverse the kernel stack from frame to frame up to
+		 * "depth" steps.
+		 */
+		while (depth-- && valid_stack_ptr(task_thread_info(current),
+						  (unsigned long)head)) {
+			oprofile_add_trace(head->lr);
+			if (head->fp <= head)
+				break;
+			head = head->fp;
+		}
+#endif
+	} else {
+		/* Assume we have frame pointers in user mode process */
+		while (depth-- && head)
+			head = dump_user_backtrace(head);
+	}
+}
+
+
diff --git a/arch/avr32/oprofile/op_model_avr32.c b/arch/avr32/oprofile/op_model_avr32.c
index df42325..a3e9b3c 100644
--- a/arch/avr32/oprofile/op_model_avr32.c
+++ b/arch/avr32/oprofile/op_model_avr32.c
@@ -22,6 +22,8 @@
 #define AVR32_PERFCTR_IRQ_GROUP	0
 #define AVR32_PERFCTR_IRQ_LINE	1
 
+void avr32_backtrace(struct pt_regs * const regs, unsigned int depth);
+
 enum { PCCNT, PCNT0, PCNT1, NR_counter };
 
 struct avr32_perf_counter {
@@ -223,6 +225,8 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	memcpy(ops, &avr32_perf_counter_ops,
 			sizeof(struct oprofile_operations));
 
+	ops->backtrace = avr32_backtrace;
+
 	printk(KERN_INFO "oprofile: using AVR32 performance monitoring.\n");
 
 	return 0;


