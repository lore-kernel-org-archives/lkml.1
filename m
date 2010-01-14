Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397Ab0ANS6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab0ANS6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951Ab0ANS6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:58:13 -0500
Received: from [206.15.93.42] ([206.15.93.42]:26752 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757171Ab0ANS6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:58:13 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au, x86@kernel.org
Subject: [PATCH] cpuinfo_op: consolidate extern declaration
Date: Thu, 14 Jan 2010 11:58:09 -0700
Cc: mingo@redhat.com, tglx@linutronix.de, monstr@monstr.eu,
       lethal@linux-sh.org, hpa@zytor.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001141158.09795.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuinfo_op: consolidate extern declaration

All the architectures supported by the kernel also support
/proc/cpuinfo. Only a couple actually declare the seq_operations
as extern. All the others will produce a sparse warning like:

warning: symbol 'cpuinfo_op' was not declared. Should it be static?

Fix all the warnings and consolidate the declaration by putting it
in <linux/seq_file.h>.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: H. Peter Anvin <hpa@zytor.com>

---

 arch/microblaze/include/asm/processor.h |    2 --
 arch/sh/include/asm/processor.h         |    4 ----
 arch/x86/include/asm/processor.h        |    2 --
 fs/proc/cpuinfo.c                       |    1 -
 include/linux/seq_file.h                |    6 ++++++
 5 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index 563c6b9..e2f8c73 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -19,8 +19,6 @@
 #include <asm/current.h>
 
 # ifndef __ASSEMBLY__
-/* from kernel/cpu/mb.c */
-extern const struct seq_operations cpuinfo_op;
 
 # define cpu_relax()		barrier()
 # define cpu_sleep()		do {} while (0)
diff --git a/arch/sh/include/asm/processor.h b/arch/sh/include/asm/processor.h
index 017e0c1..fb4f942 100644
--- a/arch/sh/include/asm/processor.h
+++ b/arch/sh/include/asm/processor.h
@@ -96,14 +96,10 @@ extern struct sh_cpuinfo cpu_data[];
 #define cpu_sleep()	__asm__ __volatile__ ("sleep" : : : "memory")
 #define cpu_relax()	barrier()
 
-/* Forward decl */
-struct seq_operations;
-
 extern struct pt_regs fake_swapper_regs;
 
 /* arch/sh/kernel/setup.c */
 const char *get_cpu_subtype(struct sh_cpuinfo *c);
-extern const struct seq_operations cpuinfo_op;
 
 /* processor boot mode configuration */
 #define MODE_PIN0 (1 << 0)
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index fc801ba..5c17303 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -149,8 +149,6 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 #define current_cpu_data	boot_cpu_data
 #endif
 
-extern const struct seq_operations cpuinfo_op;
-
 static inline int hlt_works(int cpu)
 {
 #ifdef CONFIG_X86_32
diff --git a/fs/proc/cpuinfo.c b/fs/proc/cpuinfo.c
index 5a1e539..f8eea8e 100644
--- a/fs/proc/cpuinfo.c
+++ b/fs/proc/cpuinfo.c
@@ -3,7 +3,6 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
-extern const struct seq_operations cpuinfo_op;
 static int cpuinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &cpuinfo_op);
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 8366d8f..ab13819 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -33,6 +33,12 @@ struct seq_operations {
 	int (*show) (struct seq_file *m, void *v);
 };
 
+/*
+ * All architectures support /proc/cpuinfo
+ * Define the seq_operations here to keep things clean.
+ */
+extern const struct seq_operations cpuinfo_op;
+
 #define SEQ_SKIP 1
 
 /**
