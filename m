Return-Path: <linux-kernel-owner+w=401wt.eu-S932165AbXGTIZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbXGTIZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 04:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760345AbXGTIY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 04:24:27 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:52637 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613AbXGTIYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 04:24:20 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric W Biederman <ebiederm@xmission.com>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 20 Jul 2007 13:54:03 +0530
Message-Id: <20070720082403.20752.68425.sendpatchset@balbir-laptop>
In-Reply-To: <20070720082352.20752.37209.sendpatchset@balbir-laptop>
References: <20070720082352.20752.37209.sendpatchset@balbir-laptop>
Subject: [RFC][-mm PATCH 1/8] Memory controller resource counters (v3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Pavel Emelianov <xemul@openvz.org>

Introduce generic structures and routines for resource accounting.

Each resource accounting container is supposed to aggregate it,
container_subsystem_state and its resource-specific members within.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: <balbir@linux.vnet.ibm.com>
---

 include/linux/res_counter.h |  102 +++++++++++++++++++++++++++++++++++++
 init/Kconfig                |    4 +
 kernel/Makefile             |    1 
 kernel/res_counter.c        |  120 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 227 insertions(+)

diff -puN /dev/null include/linux/res_counter.h
--- /dev/null	2007-06-01 20:42:04.000000000 +0530
+++ linux-2.6.22-rc6-balbir/include/linux/res_counter.h	2007-07-20 13:13:24.000000000 +0530
@@ -0,0 +1,102 @@
+#ifndef __RES_COUNTER_H__
+#define __RES_COUNTER_H__
+
+/*
+ * Resource Counters
+ * Contain common data types and routines for resource accounting
+ *
+ * Copyright 2007 OpenVZ SWsoft Inc
+ *
+ * Author: Pavel Emelianov <xemul@openvz.org>
+ *
+ */
+
+#include <linux/container.h>
+
+/*
+ * The core object. the container that wishes to account for some
+ * resource may include this counter into its structures and use
+ * the helpers described beyond
+ */
+
+struct res_counter {
+	/*
+	 * the current resource consumption level
+	 */
+	unsigned long usage;
+	/*
+	 * the limit that usage cannot exceed
+	 */
+	unsigned long limit;
+	/*
+	 * the number of unsuccessful attempts to consume the resource
+	 */
+	unsigned long failcnt;
+	/*
+	 * the lock to protect all of the above.
+	 * the routines below consider this to be IRQ-safe
+	 */
+	spinlock_t lock;
+};
+
+/*
+ * Helpers to interact with userspace
+ * res_counter_read/_write - put/get the specified fields from the
+ * res_counter struct to/from the user
+ *
+ * @counter:     the counter in question
+ * @member:  the field to work with (see RES_xxx below)
+ * @buf:     the buffer to opeate on,...
+ * @nbytes:  its size...
+ * @pos:     and the offset.
+ */
+
+ssize_t res_counter_read(struct res_counter *counter, int member,
+		const char __user *buf, size_t nbytes, loff_t *pos);
+ssize_t res_counter_write(struct res_counter *counter, int member,
+		const char __user *buf, size_t nbytes, loff_t *pos);
+
+/*
+ * the field descriptors. one for each member of res_counter
+ */
+
+enum {
+	RES_USAGE,
+	RES_LIMIT,
+	RES_FAILCNT,
+};
+
+/*
+ * helpers for accounting
+ */
+
+void res_counter_init(struct res_counter *counter);
+
+/*
+ * charge - try to consume more resource.
+ *
+ * @counter: the counter
+ * @val: the amount of the resource. each controller defines its own
+ *       units, e.g. numbers, bytes, Kbytes, etc
+ *
+ * returns 0 on success and <0 if the counter->usage will exceed the
+ * counter->limit _locked call expects the counter->lock to be taken
+ */
+
+int res_counter_charge_locked(struct res_counter *counter, unsigned long val);
+int res_counter_charge(struct res_counter *counter, unsigned long val);
+
+/*
+ * uncharge - tell that some portion of the resource is released
+ *
+ * @counter: the counter
+ * @val: the amount of the resource
+ *
+ * these calls check for usage underflow and show a warning on the console
+ * _locked call expects the counter->lock to be taken
+ */
+
+void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
+void res_counter_uncharge(struct res_counter *counter, unsigned long val);
+
+#endif
diff -puN init/Kconfig~res_counters_infra init/Kconfig
--- linux-2.6.22-rc6/init/Kconfig~res_counters_infra	2007-07-20 13:13:24.000000000 +0530
+++ linux-2.6.22-rc6-balbir/init/Kconfig	2007-07-20 13:13:24.000000000 +0530
@@ -320,6 +320,10 @@ config CPUSETS
 
 	  Say N if unsure.
 
+config RESOURCE_COUNTERS
+	bool
+	select CONTAINERS
+
 config SYSFS_DEPRECATED
 	bool "Create deprecated sysfs files"
 	default y
diff -puN kernel/Makefile~res_counters_infra kernel/Makefile
--- linux-2.6.22-rc6/kernel/Makefile~res_counters_infra	2007-07-20 13:13:24.000000000 +0530
+++ linux-2.6.22-rc6-balbir/kernel/Makefile	2007-07-20 13:13:24.000000000 +0530
@@ -58,6 +58,7 @@ obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
+obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff -puN /dev/null kernel/res_counter.c
--- /dev/null	2007-06-01 20:42:04.000000000 +0530
+++ linux-2.6.22-rc6-balbir/kernel/res_counter.c	2007-07-20 13:13:24.000000000 +0530
@@ -0,0 +1,120 @@
+/*
+ * resource containers
+ *
+ * Copyright 2007 OpenVZ SWsoft Inc
+ *
+ * Author: Pavel Emelianov <xemul@openvz.org>
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/parser.h>
+#include <linux/fs.h>
+#include <linux/res_counter.h>
+#include <linux/uaccess.h>
+
+void res_counter_init(struct res_counter *counter)
+{
+	spin_lock_init(&counter->lock);
+	counter->limit = (unsigned long)LONG_MAX;
+}
+
+int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
+{
+	if (counter->usage > (counter->limit - val)) {
+		counter->failcnt++;
+		return -ENOMEM;
+	}
+
+	counter->usage += val;
+	return 0;
+}
+
+int res_counter_charge(struct res_counter *counter, unsigned long val)
+{
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&counter->lock, flags);
+	ret = res_counter_charge_locked(counter, val);
+	spin_unlock_irqrestore(&counter->lock, flags);
+	return ret;
+}
+
+void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
+{
+	if (WARN_ON(counter->usage < val))
+		val = counter->usage;
+
+	counter->usage -= val;
+}
+
+void res_counter_uncharge(struct res_counter *counter, unsigned long val)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&counter->lock, flags);
+	res_counter_uncharge_locked(counter, val);
+	spin_unlock_irqrestore(&counter->lock, flags);
+}
+
+
+static inline unsigned long *res_counter_member(struct res_counter *counter,
+						int member)
+{
+	switch (member) {
+	case RES_USAGE:
+		return &counter->usage;
+	case RES_LIMIT:
+		return &counter->limit;
+	case RES_FAILCNT:
+		return &counter->failcnt;
+	};
+
+	BUG();
+	return NULL;
+}
+
+ssize_t res_counter_read(struct res_counter *counter, int member,
+		const char __user *userbuf, size_t nbytes, loff_t *pos)
+{
+	unsigned long *val;
+	char buf[64], *s;
+
+	s = buf;
+	val = res_counter_member(counter, member);
+	s += sprintf(s, "%lu\n", *val);
+	return simple_read_from_buffer((void __user *)userbuf, nbytes,
+			pos, buf, s - buf);
+}
+
+ssize_t res_counter_write(struct res_counter *counter, int member,
+		const char __user *userbuf, size_t nbytes, loff_t *pos)
+{
+	int ret;
+	char *buf, *end;
+	unsigned long tmp, *val;
+
+	buf = kmalloc(nbytes + 1, GFP_KERNEL);
+	ret = -ENOMEM;
+	if (buf == NULL)
+		goto out;
+
+	buf[nbytes] = '\0';
+	ret = -EFAULT;
+	if (copy_from_user(buf, userbuf, nbytes))
+		goto out_free;
+
+	ret = -EINVAL;
+	tmp = simple_strtoul(buf, &end, 10);
+	if (*end != '\0')
+		goto out_free;
+
+	val = res_counter_member(counter, member);
+	*val = tmp;
+	ret = nbytes;
+out_free:
+	kfree(buf);
+out:
+	return ret;
+}
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
