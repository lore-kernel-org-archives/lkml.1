Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYJ1ElA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYJ1ElA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 00:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYJ1Ekv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 00:40:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554AbYJ1Eku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 00:40:50 -0400
Date: Mon, 27 Oct 2008 21:39:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][RFC] trace: profile likely and unlikely annotations
Message-Id: <20081027213959.9f632567.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com>
	<alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com>
	<20081028001340.GB9797@mit.edu>
	<alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 00:12:48 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:

> (*) Not ever unlikely is recorded, those that are used by vsyscalls
>  (a few of them) had to be marked as unlikely_notrace().

Yes, it took continuous maintenance to weed this stuff out of
profile-likely-unlikely-macros.patch.

I'd suggest that you take a peek at this patch and make sure that
you've addressed all the sites which had to be fixed up while
maintaining this one.

(I've been maintaining this for 2-1/2 years.  Sniff)


From: Daniel Walker <dwalker@mvista.com>

-ENOCHANGELOG!

Creates /proc/likely_prof.

[randy.dunlap@oracle.com: profile_likely: export do_check_likely]
[akpm@linux-foundation.org: fixes and general maintenance]
[dwalker@mvista.com: likely_prof changed to use proc_create]
[12o3l@tiscali.nl: likeliness accounting change and cleanup]
[adobriyan@gmail.com: proc: remove proc_root from drivers]
[12o3l@tiscali.nl: update to test_and_set_bit_lock / clear_bit_unlock]
[dwalker@mvista.com: likely-profiling: disable ftrace]
Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Hua Zhong <hzhong@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vsyscall_64.c  |    2 
 arch/x86/vdso/vclock_gettime.c |    2 
 include/linux/compiler.h       |   36 +++++++
 lib/Kconfig.debug              |    8 +
 lib/Makefile                   |    5 +
 lib/likely_prof.c              |  150 +++++++++++++++++++++++++++++++
 6 files changed, 203 insertions(+)

diff -puN arch/x86/kernel/vsyscall_64.c~profile-likely-unlikely-macros arch/x86/kernel/vsyscall_64.c
--- a/arch/x86/kernel/vsyscall_64.c~profile-likely-unlikely-macros
+++ a/arch/x86/kernel/vsyscall_64.c
@@ -17,6 +17,8 @@
  *  want per guest time just set the kernel.vsyscall64 sysctl to 0.
  */
 
+#define SUPPRESS_LIKELY_PROFILING
+
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff -puN arch/x86/vdso/vclock_gettime.c~profile-likely-unlikely-macros arch/x86/vdso/vclock_gettime.c
--- a/arch/x86/vdso/vclock_gettime.c~profile-likely-unlikely-macros
+++ a/arch/x86/vdso/vclock_gettime.c
@@ -9,6 +9,8 @@
  * Also alternative() doesn't work.
  */
 
+#define SUPPRESS_LIKELY_PROFILING
+
 #include <linux/kernel.h>
 #include <linux/posix-timers.h>
 #include <linux/time.h>
diff -puN include/linux/compiler.h~profile-likely-unlikely-macros include/linux/compiler.h
--- a/include/linux/compiler.h~profile-likely-unlikely-macros
+++ a/include/linux/compiler.h
@@ -53,6 +53,41 @@ extern void __chk_io_ptr(const volatile 
 # include <linux/compiler-intel.h>
 #endif
 
+#if defined(CONFIG_PROFILE_LIKELY) && !defined(SUPPRESS_LIKELY_PROFILING) && \
+	!(defined(CONFIG_MODULE_UNLOAD) && defined(MODULE))
+struct likeliness {
+	char *const file;
+	unsigned long caller;
+	unsigned int count[2];
+	struct likeliness *next;
+	unsigned int label;
+};
+
+extern int do_check_likely(struct likeliness *likeliness, unsigned int exp);
+
+#define LP_IS_EXPECTED	1
+#define LP_UNSEEN	4
+#define LP_LINE_SHIFT	3
+
+#define __check_likely(exp, is_likely)					\
+	({								\
+		static struct likeliness likeliness = {			\
+			.file = __FILE__,				\
+			.label = __LINE__ << LP_LINE_SHIFT |		\
+						LP_UNSEEN | is_likely,	\
+		};							\
+		do_check_likely(&likeliness, !!(exp));			\
+	})
+
+/*
+ * We check for constant values with __builtin_constant_p() since
+ * it's not interesting to profile them, and there is a compiler
+ * bug in gcc 3.x which blows up during constant evalution when
+ * CONFIG_PROFILE_LIKELY is turned on.
+ */
+#define likely(x)	(__builtin_constant_p(x) ? (!!(x)) : __check_likely((x), 1))
+#define unlikely(x)	(__builtin_constant_p(x) ? (!!(x)) : __check_likely((x), 0))
+#else
 /*
  * Generic compiler-dependent macros required for kernel
  * build go below this comment. Actual compiler/compiler version
@@ -61,6 +96,7 @@ extern void __chk_io_ptr(const volatile 
 
 #define likely(x)	__builtin_expect(!!(x), 1)
 #define unlikely(x)	__builtin_expect(!!(x), 0)
+#endif
 
 /* Optimization barrier */
 #ifndef barrier
diff -puN lib/Kconfig.debug~profile-likely-unlikely-macros lib/Kconfig.debug
--- a/lib/Kconfig.debug~profile-likely-unlikely-macros
+++ a/lib/Kconfig.debug
@@ -568,6 +568,14 @@ config DEBUG_SYNCHRO_TEST
 
 	  See Documentation/synchro-test.txt.
 
+config	PROFILE_LIKELY
+	bool "Record return values from likely/unlikely macros"
+	default n
+	help
+	  Adds profiling on likely/unlikly macros . To see the
+	  results of the profiling you can view the following,
+		/proc/likely_prof
+
 config BOOT_PRINTK_DELAY
 	bool "Delay each boot printk message by N milliseconds"
 	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
diff -puN lib/Makefile~profile-likely-unlikely-macros lib/Makefile
--- a/lib/Makefile~profile-likely-unlikely-macros
+++ a/lib/Makefile
@@ -22,6 +22,9 @@ obj-y += bcd.o div64.o sort.o parser.o h
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 string_helpers.o
 
+# likely profiling can cause recursion in ftrace, so don't trace it.
+CFLAGS_REMOVE_likely_prof.o = -pg
+
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
 CFLAGS_kobject_uevent.o += -DDEBUG
@@ -82,6 +85,8 @@ obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += sys
 
 obj-$(CONFIG_DYNAMIC_PRINTK_DEBUG) += dynamic_printk.o
 
+obj-$(CONFIG_PROFILE_LIKELY) += likely_prof.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff -puN /dev/null lib/likely_prof.c
--- /dev/null
+++ a/lib/likely_prof.c
@@ -0,0 +1,150 @@
+/*
+ * This code should enable profiling the likely and unlikely macros.
+ *
+ * Output goes in /proc/likely_prof
+ *
+ * Authors:
+ * Daniel Walker <dwalker@mvista.com>
+ * Hua Zhong <hzhong@gmail.com>
+ * Andrew Morton <akpm@osdl.org>
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <linux/proc_fs.h>
+#include <linux/kallsyms.h>
+
+#include <asm/bug.h>
+#include <asm/atomic.h>
+
+static struct likeliness *likeliness_head;
+
+int do_check_likely(struct likeliness *likeliness, unsigned int ret)
+{
+	static unsigned long likely_lock;
+
+	likeliness->count[ret]++;
+
+	if (likeliness->label & LP_UNSEEN) {
+		/*
+		 * We don't simply use a spinlock because internally to the
+		 * spinlock there is a call to unlikely which causes recursion.
+		 * We opted for this method because we didn't need a preempt/irq
+		 * disable and it was a bit cleaner then using internal __raw
+		 * spinlock calls.
+		 */
+		if (!test_and_set_bit_lock(0, &likely_lock)) {
+			if (likeliness->label & LP_UNSEEN) {
+				likeliness->label &= (~LP_UNSEEN);
+				likeliness->next = likeliness_head;
+				likeliness_head = likeliness;
+				likeliness->caller = (unsigned long)
+						__builtin_return_address(0);
+			}
+			clear_bit_unlock(0, &likely_lock);
+		}
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(do_check_likely);
+
+static void * lp_seq_start(struct seq_file *out, loff_t *pos)
+{
+
+	if (!*pos) {
+
+		seq_printf(out, "Likely Profiling Results\n");
+		seq_printf(out, " --------------------------------------------"
+				"------------------------\n");
+		seq_printf(out, "[+- ]Type | # True  | # False | Function@"
+				"Filename:Line\n");
+
+		out->private = likeliness_head;
+	}
+
+	return out->private;
+}
+
+static void *lp_seq_next(struct seq_file *out, void *p, loff_t *pos)
+{
+	struct likeliness *entry = p;
+
+	if (entry->next) {
+		++(*pos);
+		out->private = entry->next;
+	} else
+		out->private = NULL;
+
+	return out->private;
+}
+
+static int lp_seq_show(struct seq_file *out, void *p)
+{
+	struct likeliness *entry = p;
+	unsigned int pos = entry->count[1];
+	unsigned int neg = entry->count[0];
+	char function[KSYM_SYMBOL_LEN];
+
+	/*
+	 * Balanced if the suggestion was false in less than 5% of the tests
+	 */
+	if (!(entry->label & LP_IS_EXPECTED)) {
+		if (pos + neg < 20 * pos)
+			seq_printf(out, "+");
+		else
+			seq_printf(out, " ");
+
+		seq_printf(out, "unlikely ");
+	} else {
+		if (pos + neg < 20 * neg)
+			seq_printf(out, "-");
+		else
+			seq_printf(out, " ");
+
+		seq_printf(out, "likely   ");
+	}
+
+	sprint_symbol(function, entry->caller);
+	seq_printf(out, "|%9u|%9u|\t%s@%s:%u\n", pos, neg, function,
+			entry->file, entry->label >> LP_LINE_SHIFT);
+
+	return 0;
+}
+
+static void lp_seq_stop(struct seq_file *m, void *p)
+{
+}
+
+static struct seq_operations likely_profiling_ops = {
+	.start  = lp_seq_start,
+	.next   = lp_seq_next,
+	.stop   = lp_seq_stop,
+	.show   = lp_seq_show
+};
+
+static int lp_results_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &likely_profiling_ops);
+}
+
+static struct file_operations proc_likely_operations  = {
+	.open           = lp_results_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
+static int __init init_likely(void)
+{
+	struct proc_dir_entry *entry =
+		proc_create("likely_prof", 0, NULL, &proc_likely_operations);
+	if (!entry)
+		return 1;
+
+	return 0;
+}
+__initcall(init_likely);
_

