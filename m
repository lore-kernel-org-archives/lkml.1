Return-Path: <linux-kernel-owner+w=401wt.eu-S1758744AbYJWTwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbYJWTwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 15:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYJWTwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 15:52:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbYJWTwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 15:52:21 -0400
Date: Thu, 23 Oct 2008 15:52:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ftrace: move nmi die handler to arch specific
Message-ID: <alpine.DEB.1.10.0810231550460.9459@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton pointed out that some archs do not compile the ftrace code
because their NMI code does not define a DIE_OOPS. The ftrace dump_on_oops
code adds an NMI handler to dump out the contents of the buffer if we
hit an oops or a NMI detected lockup.

The NMI handlers are called for other reasons than DIE_OOPS so the ftrace
handler must distinguish between them. This patch creates a "weak" handler
that does nothing and lets the arch define the NMI handler for ftrace.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/Makefile |    2 +-
 arch/x86/kernel/ftrace.c |   17 +++++++++++++++++
 kernel/trace/trace.c     |   27 +++++++++++++++------------
 3 files changed, 33 insertions(+), 13 deletions(-)

Index: linux-tip.git/arch/x86/kernel/Makefile
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/Makefile	2008-10-23 12:55:19.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/Makefile	2008-10-23 15:23:06.000000000 -0400
@@ -65,7 +65,7 @@ obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
-obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
+obj-$(CONFIG_TRACING)		+= ftrace.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
Index: linux-tip.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/ftrace.c	2008-10-23 12:55:19.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/ftrace.c	2008-10-23 15:25:40.000000000 -0400
@@ -14,13 +14,29 @@
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
 #include <linux/percpu.h>
+#include <linux/kdebug.h>
 #include <linux/init.h>
 #include <linux/list.h>
 
 #include <asm/ftrace.h>
 #include <asm/nops.h>
 
+int ftrace_nmi_die_handler(struct notifier_block *self,
+			   unsigned long val,
+			   void *data)
+{
+	switch (val) {
+	case DIE_OOPS:
+		if (ftrace_dump_on_oops)
+			ftrace_dump();
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
 
+#ifdef CONFIG_DYNAMIC_FTRACE
 /* Long is fine, even if it is only 4 bytes ;-) */
 static unsigned long *ftrace_nop;
 
@@ -171,3 +187,4 @@ int __init ftrace_dyn_arch_init(void *da
 
 	return 0;
 }
+#endif /* CONFIG_DYNAMIC_FTRACE */
Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-10-23 14:24:28.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-10-23 15:49:54.000000000 -0400
@@ -3051,23 +3051,26 @@ static struct notifier_block trace_panic
 	.priority       = 150   /* priority: INT_MAX >= x >= 0 */
 };
 
-static int trace_die_handler(struct notifier_block *self,
-			     unsigned long val,
-			     void *data)
+/**
+ * ftrace_nmi_die_handler - handler to call by ftrace on NMI lockup
+ * @self: unused
+ * @val: NMI handler type variable
+ * @data: unused
+ *
+ * Architectures need to define their own NMI watchdog handler.
+ * The NMI handlers may be called for various reasons, but we
+ * only want to dump the ftrace buffers when it is a lockup.
+ * Unfortunately, not all architectures define DIE_OOPS.
+ */
+int __weak ftrace_nmi_die_handler(struct notifier_block *self,
+				  unsigned long val,
+				  void *data)
 {
-	switch (val) {
-	case DIE_OOPS:
-		if (ftrace_dump_on_oops)
-			ftrace_dump();
-		break;
-	default:
-		break;
-	}
 	return NOTIFY_OK;
 }
 
 static struct notifier_block trace_die_notifier = {
-	.notifier_call = trace_die_handler,
+	.notifier_call = ftrace_nmi_die_handler,
 	.priority = 200
 };
 

