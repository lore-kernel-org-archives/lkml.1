Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbZJPMKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbZJPMKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 08:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbZJPMKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 08:10:10 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:54848 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751063AbZJPMKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 08:10:07 -0400
Date: Fri, 16 Oct 2009 14:09:18 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Ingo Molnar <mingo@elte.hu>, linux-mtd <linux-mtd@lists.infradead.org>
Cc: dedekind1@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH v11 4/5] core: Add kernel message dumper to call on oopses
 and panics
Message-ID: <20091016140918.3981cfa2@marrow.netinsight.se>
In-Reply-To: <20091016101045.GA3263@elte.hu>
References: <20091015094057.7298e0d7@marrow.netinsight.se>
	<20091015094805.754461fa@marrow.netinsight.se>
	<20091015093133.GF10546@elte.hu>
	<20091015161052.0752208e@marrow.netinsight.se>
	<20091015154640.GA11408@elte.hu>
	<20091016094601.4e2c2d3e@marrow.netinsight.se>
	<20091016080935.GA3895@elte.hu>
	<1255681467.32489.360.camel@localhost>
	<20091016112556.6902b2dc@marrow.netinsight.se>
	<20091016101045.GA3263@elte.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core functionality is implemented as per Linus suggestion from

  http://lists.infradead.org/pipermail/linux-mtd/2009-October/027620.html

(with the kmsg_dump implementation by Linus). A struct kmsg_dumper has
been added which contains a callback to dump the kernel log buffers on
crashes. The kmsg_dump function gets called from oops_exit() and panic()
and invokes this callbacks with the crash reason.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
Reviewed-by: Anders Grafstrom <anders.grafstrom@netinsight.net>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
The bikeshed paint is drying:

ChangeLog:
	* (Ingo Molnar): Flatten lock use
	* (Artem, Aaro): Fix style issues

 include/linux/kmsg_dump.h |   44 ++++++++++++++++++
 kernel/panic.c            |    3 +
 kernel/printk.c           |  112 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 159 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/kmsg_dump.h

diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
new file mode 100644
index 0000000..7f089ec
--- /dev/null
+++ b/include/linux/kmsg_dump.h
@@ -0,0 +1,44 @@
+/*
+ * linux/include/kmsg_dump.h
+ *
+ * Copyright (C) 2009 Net Insight AB
+ *
+ * Author: Simon Kagstrom <simon.kagstrom@netinsight.net>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ */
+#ifndef _LINUX_KMSG_DUMP_H
+#define _LINUX_KMSG_DUMP_H
+
+#include <linux/list.h>
+
+enum kmsg_dump_reason {
+	KMSG_DUMP_OOPS,
+	KMSG_DUMP_PANIC,
+};
+
+/**
+ * struct kmsg_dumper - kernel crash message dumper structure
+ * @dump:	The callback which gets called on crashes. The buffer is passed
+ * 		as two sections, where s1 (length l1) contains the older
+ * 		messages and s2 (length l2) contains the newer.
+ * @list:	Entry in the dumper list (private)
+ * @registered:	Flag that specifies if this is already registered
+ */
+struct kmsg_dumper {
+	void (*dump)(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
+			const char *s1, unsigned long l1,
+			const char *s2, unsigned long l2);
+	struct list_head list;
+	int registered;
+};
+
+void kmsg_dump(enum kmsg_dump_reason reason);
+
+int kmsg_dump_register(struct kmsg_dumper *dumper);
+
+int kmsg_dump_unregister(struct kmsg_dumper *dumper);
+
+#endif /* _LINUX_KMSG_DUMP_H */
diff --git a/kernel/panic.c b/kernel/panic.c
index c0b33b8..763296d 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -10,6 +10,7 @@
  */
 #include <linux/debug_locks.h>
 #include <linux/interrupt.h>
+#include <linux/kmsg_dump.h>
 #include <linux/kallsyms.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
@@ -76,6 +77,7 @@ NORET_TYPE void panic(const char * fmt, ...)
 	dump_stack();
 #endif
 
+	kmsg_dump(KMSG_DUMP_PANIC);
 	/*
 	 * If we have crashed and we have a crash kernel loaded let it handle
 	 * everything else.
@@ -341,6 +343,7 @@ void oops_exit(void)
 {
 	do_oops_enter_exit();
 	print_oops_end_marker();
+	kmsg_dump(KMSG_DUMP_OOPS);
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
diff --git a/kernel/printk.c b/kernel/printk.c
index f38b07f..f711b99 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/kexec.h>
+#include <linux/kmsg_dump.h>
 
 #include <asm/uaccess.h>
 
@@ -1405,3 +1406,114 @@ bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 }
 EXPORT_SYMBOL(printk_timed_ratelimit);
 #endif
+
+static DEFINE_SPINLOCK(dump_list_lock);
+static LIST_HEAD(dump_list);
+
+/**
+ * kmsg_dump_register - register a kernel log dumper.
+ * @dump: pointer to the kmsg_dumper structure
+ *
+ * Adds a kernel log dumper to the system. The dump callback in the
+ * structure will be called when the kernel oopses or panics and must be
+ * set. Returns zero on success and %-EINVAL or %-EBUSY otherwise.
+ */
+int kmsg_dump_register(struct kmsg_dumper *dumper)
+{
+	unsigned long flags;
+	int err = -EBUSY;
+
+	/* The dump callback needs to be set */
+	if (!dumper->dump)
+		return -EINVAL;
+
+	spin_lock_irqsave(&dump_list_lock, flags);
+	/* Don't allow registering multiple times */
+	if (!dumper->registered) {
+		dumper->registered = 1;
+		list_add_tail(&dumper->list, &dump_list);
+		err = 0;
+	}
+	spin_unlock_irqrestore(&dump_list_lock, flags);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(kmsg_dump_register);
+
+/**
+ * kmsg_dump_unregister - unregister a kmsg dumper.
+ * @dump: pointer to the kmsg_dumper structure
+ *
+ * Removes a dump device from the system. Returns zero on success and
+ * %-EINVAL otherwise.
+ */
+int kmsg_dump_unregister(struct kmsg_dumper *dumper)
+{
+	unsigned long flags;
+	int err = -EINVAL;
+
+	spin_lock_irqsave(&dump_list_lock, flags);
+	if (dumper->registered) {
+		dumper->registered = 0;
+		list_del(&dumper->list);
+		err = 0;
+	}
+	spin_unlock_irqrestore(&dump_list_lock, flags);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(kmsg_dump_unregister);
+
+static const char const *kmsg_reasons[] = {
+	[KMSG_DUMP_OOPS]	= "oops",
+	[KMSG_DUMP_PANIC]	= "panic",
+};
+
+static const char *kmsg_to_str(enum kmsg_dump_reason reason)
+{
+	if (reason >= ARRAY_SIZE(kmsg_reasons) || reason < 0)
+		return "unknown";
+
+	return kmsg_reasons[reason];
+}
+
+/**
+ * kmsg_dump - dump kernel log to kernel message dumpers.
+ * @reason: the reason (oops, panic etc) for dumping
+ *
+ * Iterate through each of the dump devices and call the oops/panic
+ * callbacks with the log buffer.
+ */
+void kmsg_dump(enum kmsg_dump_reason reason)
+{
+	unsigned long len = ACCESS_ONCE(log_end);
+	struct kmsg_dumper *dumper;
+	const char *s1, *s2;
+	unsigned long l1, l2;
+	unsigned long flags;
+
+	s1 = "";
+	l1 = 0;
+	s2 = log_buf;
+	l2 = len;
+
+	/* Have we rotated around the circular buffer? */
+	if (len > log_buf_len) {
+		unsigned long pos = len & LOG_BUF_MASK;
+
+		s1 = log_buf + pos;
+		l1 = log_buf_len - pos;
+
+		s2 = log_buf;
+		l2 = pos;
+	}
+
+	if (!spin_trylock_irqsave(&dump_list_lock, flags)) {
+		printk(KERN_ERR "dump_kmsg: dump list lock is held during %s, skipping dump\n",
+				kmsg_to_str(reason));
+		return;
+	}
+	list_for_each_entry(dumper, &dump_list, list)
+		dumper->dump(dumper, reason, s1, l1, s2, l2);
+	spin_unlock_irqrestore(&dump_list_lock, flags);
+}
-- 
1.6.0.4

