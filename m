Return-Path: <linux-kernel-owner+w=401wt.eu-S933578AbZJMNYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbZJMNYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759881AbZJMNYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:24:10 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:35580 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759866AbZJMNYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:24:08 -0400
Date: Tue, 13 Oct 2009 15:22:35 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH/RFC v5 4/5]: core: Add dump device to call on oopses and
 panics
Message-ID: <20091013152235.188059d2@marrow.netinsight.se>
In-Reply-To: <20091013151751.59e217a7@marrow.netinsight.se>
References: <20091012113758.GB11035@elte.hu>
	<20091012140149.6789efab@marrow.netinsight.se>
	<20091012120951.GA16799@elte.hu>
	<1255349748.10605.13.camel@macbook.infradead.org>
	<20091012122023.GA19365@elte.hu>
	<20091012150650.51a4b4dc@marrow.netinsight.se>
	<20091012131528.GC25464@elte.hu>
	<20091012153937.0dcd73e5@marrow.netinsight.se>
	<alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
	<20091012110954.67d7d8d8.akpm@linux-foundation.org>
	<20091012182346.GH17138@elte.hu>
	<alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
	<20091013151751.59e217a7@marrow.netinsight.se>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core functionality is implemented as per Linus suggestion from

  http://lists.infradead.org/pipermail/linux-mtd/2009-October/027620.html

a struct dump_device type has been added which contains callbacks to
dump the kernel log buffers on crashes. The dump_kmsg function gets
called from oops_exit() and panic() and invokes these callbacks.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
---
 include/linux/dump_device.h |   33 +++++++++++++++++
 kernel/panic.c              |    3 ++
 kernel/printk.c             |   83 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 119 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/dump_device.h

diff --git a/include/linux/dump_device.h b/include/linux/dump_device.h
new file mode 100644
index 0000000..8c3f378
--- /dev/null
+++ b/include/linux/dump_device.h
@@ -0,0 +1,33 @@
+/*
+ * linux/include/dump_device.h
+ *
+ * Copyright (C) 2009 Net Insight
+ *
+ * Author: Simon Kagstrom <simon.kagstrom@netinsight.net>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ */
+#ifndef _LINUX_DUMP_DEVICE_H
+#define _LINUX_DUMP_DEVICE_H
+
+#include <linux/list.h>
+
+struct dump_device {
+	void	(*oops)(struct dump_device *, const char *, unsigned long,
+			const char *, unsigned long);
+	void	(*panic)(struct dump_device *, const char *, unsigned long,
+			const char *, unsigned long);
+	int	(*setup)(struct dump_device *);
+	void	*priv;
+	struct	 list_head list;
+};
+
+void dump_kmsg(int panic);
+
+int register_dumpdevice(struct dump_device *dump, void *priv);
+
+void unregister_dumpdevice(struct dump_device *dump);
+
+#endif /* _LINUX_DUMP_DEVICE_H */
diff --git a/kernel/panic.c b/kernel/panic.c
index c0b33b8..e7dbf2b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -8,6 +8,7 @@
  * This function is used through-out the kernel (including mm and fs)
  * to indicate a major problem.
  */
+#include <linux/dump_device.h>
 #include <linux/debug_locks.h>
 #include <linux/interrupt.h>
 #include <linux/kallsyms.h>
@@ -76,6 +77,7 @@ NORET_TYPE void panic(const char * fmt, ...)
 	dump_stack();
 #endif
 
+	dump_kmsg(1);
 	/*
 	 * If we have crashed and we have a crash kernel loaded let it handle
 	 * everything else.
@@ -341,6 +343,7 @@ void oops_exit(void)
 {
 	do_oops_enter_exit();
 	print_oops_end_marker();
+	dump_kmsg(0);
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
diff --git a/kernel/printk.c b/kernel/printk.c
index f38b07f..5e1fe73 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/kexec.h>
+#include <linux/dump_device.h>
 
 #include <asm/uaccess.h>
 
@@ -1405,3 +1406,85 @@ bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 }
 EXPORT_SYMBOL(printk_timed_ratelimit);
 #endif
+
+static LIST_HEAD(dump_list);
+static DEFINE_RWLOCK(dump_list_lock);
+
+/**
+ *	register_dump_device - register a dumpdevice.
+ *	@dump: pointer to the dump structure
+ *	@priv: private data for the structure
+ *
+ *	Adds a dump device to the system. The oops and panic callbacks
+ *	in the structure will be called when the kernel oopses and panics
+ *	respectively. At least one of these must be set. Returns zero on
+ *	success and -EINVAL otherwise.
+ */
+int register_dumpdevice(struct dump_device *dump, void *priv)
+{
+	/* We need at least one of these set */
+	if (!dump->oops && !dump->panic)
+		return -EINVAL;
+	if (dump->setup && dump->setup(dump) != 0)
+		return -EINVAL;
+	dump->priv = priv;
+
+	INIT_LIST_HEAD(&dump->list);
+	write_lock(&dump_list_lock);
+	list_add(&dump->list, &dump_list);
+	write_unlock(&dump_list_lock);
+	return 0;
+}
+EXPORT_SYMBOL(register_dumpdevice);
+
+/**
+ *	unregister_dump_device - unregister a dumpdevice.
+ *	@dump: pointer to the dump structure
+ *
+ *	Removes a dump device from the system.
+ */
+void unregister_dumpdevice(struct dump_device *dump)
+{
+	write_lock(&dump_list_lock);
+	list_del(&dump->list);
+	write_unlock(&dump_list_lock);
+}
+EXPORT_SYMBOL(unregister_dumpdevice);
+
+/**
+ *	dump_kmsg - dump kernel log to dump devices.
+ *	@panic: if this is a panic (1) or an oops (0)
+ *
+ *	Iterate through each of the dump devices and call the oops/panic
+ *	callbacks with the log buffer.
+ */
+void dump_kmsg(int panic)
+{
+	unsigned long len = ACCESS_ONCE(log_end);
+	struct dump_device *dump;
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
+		unsigned long pos = (len & LOG_BUF_MASK);
+
+		s1 = log_buf + pos;
+		l1 = log_buf_len - pos;
+
+		s2 = log_buf;
+		l2 = pos;
+	}
+
+	list_for_each_entry(dump, &dump_list, list) {
+		if (panic && dump->panic)
+			dump->panic(dump, s1, l1, s2, l2);
+		else if (!panic && dump->oops)
+			dump->oops(dump, s1, l1, s2, l2);
+	}
+}
-- 
1.6.0.4

