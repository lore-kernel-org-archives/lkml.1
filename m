Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbXJQXio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbXJQXio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 19:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbXJQXic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 19:38:32 -0400
Received: from homer.mvista.com ([63.81.120.158]:9452 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757004AbXJQXib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 19:38:31 -0400
Message-ID: <47169CEC.5020706@ct.jp.nec.com>
Date: Wed, 17 Oct 2007 16:38:20 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: merge init_task_32/64.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Merge init_task_32/64.c.
Move 64bit per cpu data orig_ist to setup64.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/i386/Makefile             |    2 +-
 arch/x86/kernel/Makefile_32    |    2 +-
 arch/x86/kernel/Makefile_64    |    2 +-
 arch/x86/kernel/init_task.c    |   49 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/init_task_32.c |   46 ----------------------------------
 arch/x86/kernel/init_task_64.c |   54 ----------------------------------------
 arch/x86/kernel/setup64.c      |    6 ++++
 arch/x86_64/Makefile           |    2 +-
 8 files changed, 59 insertions(+), 104 deletions(-)
 create mode 100644 arch/x86/kernel/init_task.c
 delete mode 100644 arch/x86/kernel/init_task_32.c
 delete mode 100644 arch/x86/kernel/init_task_64.c

diff --git a/arch/i386/Makefile b/arch/i386/Makefile
index f036d2d..6966116 100644
--- a/arch/i386/Makefile
+++ b/arch/i386/Makefile
@@ -102,7 +102,7 @@ core-$(CONFIG_XEN)		+= arch/x86/xen/
 # default subarch .h files
 mflags-y += -Iinclude/asm-x86/mach-default
 
-head-y := arch/x86/kernel/head_32.o arch/x86/kernel/init_task_32.o
+head-y := arch/x86/kernel/head_32.o arch/x86/kernel/init_task.o
 
 libs-y 					+= arch/x86/lib/
 core-y					+= arch/x86/kernel/ \
diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index a3fa11f..69990f0 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-extra-y := head_32.o init_task_32.o vmlinux.lds
+extra-y := head_32.o init_task.o vmlinux.lds
 
 obj-y	:= process_32.o signal_32.o entry_32.o traps_32.o irq_32.o \
 		ptrace_32.o time_32.o ioport_32.o ldt_32.o setup_32.o i8259_32.o sys_i386_32.o \
diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index 43da662..2fc3d3f 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-extra-y 	:= head_64.o head64.o init_task_64.o vmlinux.lds
+extra-y 	:= head_64.o head64.o init_task.o vmlinux.lds
 EXTRA_AFLAGS	:= -traditional
 obj-y	:= process_64.o signal_64.o entry_64.o traps_64.o irq_64.o \
 		ptrace_64.o time_64.o ioport_64.o ldt_64.o setup_64.o i8259_64.o sys_x86_64.o \
diff --git a/arch/x86/kernel/init_task.c b/arch/x86/kernel/init_task.c
new file mode 100644
index 0000000..b1deb2c
--- /dev/null
+++ b/arch/x86/kernel/init_task.c
@@ -0,0 +1,49 @@
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/init_task.h>
+#include <linux/fs.h>
+#include <linux/mqueue.h>
+
+#include <asm/uaccess.h>
+#include <asm/pgtable.h>
+#include <asm/desc.h>
+
+static struct fs_struct init_fs = INIT_FS;
+static struct files_struct init_files = INIT_FILES;
+static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
+static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
+struct mm_struct init_mm = INIT_MM(init_mm);
+
+EXPORT_SYMBOL(init_mm);
+
+/*
+ * Initial thread structure.
+ *
+ * We need to make sure that this is THREAD_SIZE aligned due to the
+ * way process stacks are handled. This is done by having a special
+ * "init_task" linker map entry..
+ */
+union thread_union init_thread_union 
+	__attribute__((__section__(".data.init_task"))) =
+		{ INIT_THREAD_INFO(init_task) };
+
+/*
+ * Initial task structure.
+ *
+ * All other task structs will be allocated on slabs in fork.c
+ */
+struct task_struct init_task = INIT_TASK(init_task);
+
+EXPORT_SYMBOL(init_task);
+
+/*
+ * per-CPU TSS segments. Threads are completely 'soft' on Linux,
+ * no more per-task TSS's. The TSS size is kept cacheline-aligned
+ * so they are allowed to end up in the .data.cacheline_aligned
+ * section. Since TSS's are completely CPU-local, we want them
+ * on exact cacheline boundaries, to eliminate cacheline ping-pong.
+ */ 
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
+
diff --git a/arch/x86/kernel/init_task_32.c b/arch/x86/kernel/init_task_32.c
deleted file mode 100644
index d26fc06..0000000
--- a/arch/x86/kernel/init_task_32.c
+++ /dev/null
@@ -1,46 +0,0 @@
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/init_task.h>
-#include <linux/fs.h>
-#include <linux/mqueue.h>
-
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-#include <asm/desc.h>
-
-static struct fs_struct init_fs = INIT_FS;
-static struct files_struct init_files = INIT_FILES;
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
-/*
- * Initial thread structure.
- *
- * We need to make sure that this is THREAD_SIZE aligned due to the
- * way process stacks are handled. This is done by having a special
- * "init_task" linker map entry..
- */
-union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
-		{ INIT_THREAD_INFO(init_task) };
-
-/*
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-struct task_struct init_task = INIT_TASK(init_task);
-
-EXPORT_SYMBOL(init_task);
-
-/*
- * per-CPU TSS segments. Threads are completely 'soft' on Linux,
- * no more per-task TSS's.
- */ 
-DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
-
diff --git a/arch/x86/kernel/init_task_64.c b/arch/x86/kernel/init_task_64.c
deleted file mode 100644
index 4ff33d4..0000000
--- a/arch/x86/kernel/init_task_64.c
+++ /dev/null
@@ -1,54 +0,0 @@
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/init_task.h>
-#include <linux/fs.h>
-#include <linux/mqueue.h>
-
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-#include <asm/desc.h>
-
-static struct fs_struct init_fs = INIT_FS;
-static struct files_struct init_files = INIT_FILES;
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
-/*
- * Initial task structure.
- *
- * We need to make sure that this is 8192-byte aligned due to the
- * way process stacks are handled. This is done by having a special
- * "init_task" linker map entry..
- */
-union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
-		{ INIT_THREAD_INFO(init_task) };
-
-/*
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-struct task_struct init_task = INIT_TASK(init_task);
-
-EXPORT_SYMBOL(init_task);
-/*
- * per-CPU TSS segments. Threads are completely 'soft' on Linux,
- * no more per-task TSS's. The TSS size is kept cacheline-aligned
- * so they are allowed to end up in the .data.cacheline_aligned
- * section. Since TSS's are completely CPU-local, we want them
- * on exact cacheline boundaries, to eliminate cacheline ping-pong.
- */ 
-DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
-
-/* Copies of the original ist values from the tss are only accessed during
- * debugging, no special alignment required.
- */
-DEFINE_PER_CPU(struct orig_ist, orig_ist);
-
-#define ALIGN_TO_4K __attribute__((section(".data.init_task")))
diff --git a/arch/x86/kernel/setup64.c b/arch/x86/kernel/setup64.c
index ba91882..e11886e 100644
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -185,6 +185,12 @@ void __cpuinit check_efer(void)
 unsigned long kernel_eflags;
 
 /*
+ * Copies of the original ist values from the tss are only accessed during
+ * debugging, no special alignment required.
+ */
+DEFINE_PER_CPU(struct orig_ist, orig_ist);
+
+/*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
  * and IDT. We reload them nevertheless, this function acts as a
diff --git a/arch/x86_64/Makefile b/arch/x86_64/Makefile
index 03e1ede..ca71c43 100644
--- a/arch/x86_64/Makefile
+++ b/arch/x86_64/Makefile
@@ -74,7 +74,7 @@ KBUILD_CFLAGS += $(cflags-y)
 CFLAGS_KERNEL += $(cflags-kernel-y)
 KBUILD_AFLAGS += -m64
 
-head-y := arch/x86/kernel/head_64.o arch/x86/kernel/head64.o arch/x86/kernel/init_task_64.o
+head-y := arch/x86/kernel/head_64.o arch/x86/kernel/head64.o arch/x86/kernel/init_task.o
 
 libs-y 					+= arch/x86/lib/
 core-y					+= arch/x86/kernel/ \
-- 
1.5.2.3

