Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbZJOHtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbZJOHtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 03:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbZJOHtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 03:49:00 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:14562 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754063AbZJOHtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 03:49:00 -0400
Date: Thu, 15 Oct 2009 09:48:05 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH v7 4/5]: core: Add kernel message dumper to call on oopses
 and panics
Message-ID: <20091015094805.754461fa@marrow.netinsight.se>
In-Reply-To: <20091015094057.7298e0d7@marrow.netinsight.se>
References: <20091015094057.7298e0d7@marrow.netinsight.se>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core functionality is implemented as per Linus suggestion from

  http://lists.infradead.org/pipermail/linux-mtd/2009-October/027620.html

(with the dump_kmsg implementation by Linus). A struct kmsg_dumper has
been added which contains a callback to dump the kernel log buffers on
crashes. The dump_kmsg function gets called from oops_exit() and panic()
and invokes this callbacks with the crash reason.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
Reviewed-by: Anders Grafstrom <anders.grafstrom@netinsight.net>
---
ChangeLog:

 * (The other patches are sent only to linux-mtd since they are really
   just mtdoops-specific now)
 * (Linus) remove the priv pointer in the structure and
   let users determine the address of their own structure
   with container_of

 include/linux/kmsg_dump.h |   36 +++++++++++++++
 kernel/panic.c            |    3 +
 kernel/printk.c           |  104 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 143 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/kmsg_dump.h

diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
new file mode 100644
index 0000000..d7c9a4c
--- /dev/null
+++ b/include/linux/kmsg_dump.h
@@ -0,0 +1,36 @@
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
+	kmsg_dump_oops,
+	kmsg_dump_panic,
+};
+
+struct kmsg_dumper {
+	void (*dump)(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
+			const char *s1, unsigned long l1,
+			const char *s2, unsigned long l2);
+	struct list_head list;
+	int registered;
+};
+
+void dump_kmsg(enum kmsg_dump_reason reason);
+
+int register_kmsg_dumper(struct kmsg_dumper *dumper);
+
+void unregister_kmsg_dumper(struct kmsg_dumper *dumper);
+
+#endif /* _LINUX_DUMP_DEVICE_H */
diff --git a/kernel/panic.c b/kernel/panic.c
index c0b33b8..3a5a93f 100644
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
 
+	dump_kmsg(kmsg_dump_panic);
 	/*
 	 * If we have crashed and we have a crash kernel loaded let it handle
 	 * everything else.
@@ -341,6 +343,7 @@ void oops_exit(void)
 {
 	do_oops_enter_exit();
 	print_oops_end_marker();
+	dump_kmsg(kmsg_dump_oops);
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
diff --git a/kernel/printk.c b/kernel/printk.c
index f38b07f..9c4d9cb 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -33,6 +33,8 @@
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/kexec.h>
+#include <linux/kmsg_dump.h>
+#include <linux/spinlock.h>
 
 #include <asm/uaccess.h>
 
@@ -1405,3 +1407,105 @@ bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 }
 EXPORT_SYMBOL(printk_timed_ratelimit);
 #endif
+
+static LIST_HEAD(dump_list);
+static DEFINE_SPINLOCK(dump_list_lock);
+
+/**
+ *	register_dump_device - register a kernel log dumper.
+ *	@dump: pointer to the dump structure
+ *	@priv: private data for the structure
+ *
+ *	Adds a kernel log dumper to the system. The dump callback in the
+ *	structure will be called when the kernel oopses or panics and must be
+ *	set. Returns zero on success and -EINVAL or -EBUSY otherwise.
+ */
+int register_kmsg_dumper(struct kmsg_dumper *dumper)
+{
+	unsigned long flags;
+
+	/* The dump callback needs to be set */
+	if (!dumper->dump)
+		return -EINVAL;
+
+	/* Don't allow registering multiple times */
+	if (dumper->registered)
+		return -EBUSY;
+
+	dumper->registered = 1;
+
+	spin_lock_irqsave(&dump_list_lock, flags);
+	list_add(&dumper->list, &dump_list);
+	spin_unlock_irqrestore(&dump_list_lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL(register_kmsg_dumper);
+
+/**
+ *	unregister_dump_device - unregister a dumpdevice.
+ *	@dump: pointer to the dump structure
+ *
+ *	Removes a dump device from the system.
+ */
+void unregister_kmsg_dumper(struct kmsg_dumper *dumper)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dump_list_lock, flags);
+	list_del(&dumper->list);
+	spin_unlock_irqrestore(&dump_list_lock, flags);
+}
+EXPORT_SYMBOL(unregister_kmsg_dumper);
+
+static const char *kmsg_reasons[] = {
+	[kmsg_dump_oops]	= "oops",
+	[kmsg_dump_panic]	= "panic",
+};
+
+static const char *kmsg_to_str(enum kmsg_dump_reason reason)
+{
+	if (reason > ARRAY_SIZE(kmsg_reasons) || reason < 0)
+		return "unknown";
+
+	return kmsg_reasons[reason];
+}
+
+/**
+ *	dump_kmsg - dump kernel log to kernel message dumpers.
+ *	@reason: the reason (oops, panic etc) for dumping
+ *
+ *	Iterate through each of the dump devices and call the oops/panic
+ *	callbacks with the log buffer.
+ */
+void dump_kmsg(enum kmsg_dump_reason reason)
+{
+	unsigned long len = ACCESS_ONCE(log_end);
+	struct kmsg_dumper *dumper;
+	const char *s1, *s2;
+	unsigned long l1, l2;
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
+	if (!spin_trylock(&dump_list_lock)) {
+		printk(KERN_ERR "dump_kmsg: dump list lock is held during %s, skipping dump\n",
+				kmsg_to_str(reason));
+		return;
+	}
+	list_for_each_entry(dumper, &dump_list, list)
+		dumper->dump(dumper, reason, s1, l1, s2, l2);
+	spin_unlock(&dump_list_lock);
+}
-- 
1.6.0.4

