Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbZFAFit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbZFAFit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 01:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZFAFiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 01:38:08 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:63156 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbZFAFiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 01:38:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JExxFqWWlCB8EMcH2tDOlI4inE/6N/8UU81UpPvMjONaZ+KhkAvGTzKLZdZ8jGsB6t
         URHTNm+ZTT5AuM+OOeIt62yN8SjXFCAYoX1u8c6ZwcaR8YHJ2qjcciuMicFBGYHdiQfs
         5nT1Ug7QgfLn/zESEHLSkw09m0YbgEcfuuXaU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>
Subject: [RFC PATCH 2/2] tracing/stat: provide a sample example to use the hashlist based stat tracing
Date: Mon,  1 Jun 2009 07:37:59 +0200
Message-Id: <1243834679-19132-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243834679-19132-1-git-send-email-fweisbec@gmail.com>
References: <1243834679-19132-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Not for inclusion)

This is a sample example just to show how to use this hashlist
based stat tracing.

A thread schedules a worklet every seconds. These worklets
simply log the number of time they are scheduled.
Also one these worklet stat is removed every 20 seconds
to test the removal as well.

This was just a testcase for me but it is a simple example
which shows a basic use.

Not-seriously-signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/Makefile     |    1 +
 kernel/trace/trace_test.c |  108 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100644 kernel/trace/trace_test.c

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 06b8585..16a2edb 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -20,6 +20,7 @@ endif
 # relied on by ptrace for example:
 #
 obj-y += trace_clock.o
+obj-y += trace_test.o
 
 obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
 obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
diff --git a/kernel/trace/trace_test.c b/kernel/trace/trace_test.c
new file mode 100644
index 0000000..909a28a
--- /dev/null
+++ b/kernel/trace/trace_test.c
@@ -0,0 +1,108 @@
+#include "trace_stat.h"
+
+#include <linux/kernel.h>
+#include <linux/workqueue.h>
+#include <linux/kthread.h>
+#include <linux/kallsyms.h>
+#include <linux/module.h>
+
+
+
+struct stat_example {
+	int hit;
+	char func[KSYM_SYMBOL_LEN];
+};
+
+
+static int stat_headers(struct seq_file *s)
+{
+	seq_printf(s, "# Function       hit\n");
+	return 0;
+}
+
+static int stat_show(struct seq_file *s, void *p)
+{
+	struct stat_example *stat = p;
+	seq_printf(s, "%s         %d\n", stat->func, stat->hit);
+
+	return 0;
+}
+
+static struct tracer_stat sample_stat_tracer ={
+	.name = "example",
+	.stat_show = stat_show,
+	.stat_headers = stat_headers,
+	.hlist_size = 3,
+	.node_size = sizeof(struct stat_example),
+	.flags = HASH_NODES
+};
+
+
+
+static void __work(struct work_struct *work)
+{
+	struct stat_example *stat;
+	bool is_first;
+
+	stat = get_stat_entry(&sample_stat_tracer, (unsigned long)work, &is_first);
+	if (!stat) {
+		return;
+	}
+	if (is_first)
+		sprintf(stat->func, "%pf", work->func);
+	stat->hit++;
+	put_stat_entry(stat);
+}
+
+static void func1(struct work_struct *work) { __work(work); }
+static void func2(struct work_struct *work) { __work(work); }
+static void func3(struct work_struct *work) { __work(work); }
+
+static DECLARE_WORK(work1, func1);
+static DECLARE_WORK(work2, func2);
+static DECLARE_WORK(work3, func3);
+
+
+static int __test_stat(void *unused)
+{
+	int tour = 0;
+	struct work_struct *w;
+
+	while (!kthread_should_stop()) {
+
+		switch (tour % 3) {
+		case 0:
+			w = &work1;
+			break;
+		case 1:
+			w = &work2;
+			break;
+		case 2:
+			w = &work3;
+			break;
+		}
+
+		if (!(tour % 20))
+			drop_stat_entry(&sample_stat_tracer, (unsigned long)&work3);
+
+		schedule_work(w);
+
+		tour++;
+		schedule_timeout_uninterruptible(HZ);
+	}
+	return 0;
+}
+
+
+static int __init init_stat_sample(void)
+{
+	int ret;
+
+	ret = register_stat_tracer(&sample_stat_tracer);
+	if (ret)
+		printk("Can't rengister sample stat tracer: %d", ret);
+	kthread_run(__test_stat, NULL, "stat_sampled");
+	return 0;
+}
+device_initcall(init_stat_sample);
+
-- 
1.6.2.3

