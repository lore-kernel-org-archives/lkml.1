Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbZGTROq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbZGTROq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbZGTROp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:14:45 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:40476 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbZGTROo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:14:44 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 13:14:44 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=d+TUMNbhmpFIQSZeC9j08G4tbCryBZhZ5frsByw8ykGRr2qiTObomk3I67PXxMU72j
         4CouzH3aennmOIiQJX+riqzSlgr0IclC/OalbcIkfzr0Z0XmLAitH/79Y6Tl0okKeFfF
         hBDGOUr9krPTsMHRNgzIl6y0db4ctDA1L4ryk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linuxtronix.de>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware breakpoints
Date: Mon, 20 Jul 2009 13:08:07 -0400
Message-Id: <1248109687-7808-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the support for kernel hardware breakpoints in perfcounter.
It is added as a new type of software counter and can be defined by
using the counter number 5 and by passsing the address of the
breakpoint to set through the config attribute.

Example which traces the BKL accesses by stressing reiserfs:

bkl=0x$(cat ../../System.map | grep kernel_flag | cut -d" " -f 1)
./perf record -f -g -e 5:$bkl -- dbench -t 20 20
./perf report -g -s s
 # Samples: 36
 #
 # Overhead  Symbol
 # ........  ......
 #
    83.33%  [k] lock_kernel
                |
                |--51.72%-- __pwrite64
                |
                |--27.59%-- 0x7f9d83a17b15
                |
                |--13.79%-- __open
                |
                 --10.34%-- unlink

    16.67%  [k] unlock_kernel
                |
                |--80.00%-- 0x7f9d83a17b15
                |
                |--20.00%-- unlink
                |
                 --20.00%-- __pwrite64

For now you can only pass raw kernel addresses.
What is planned next:

- profile by symbol names
- profile with user breakpoints

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Thomas Gleixner <tglx@linuxtronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/hw_breakpoint.h |    4 ++
 include/linux/perf_counter.h        |    1 +
 kernel/hw_breakpoint.c              |   79 +++++++++++++++++++++++++++++++++++
 kernel/perf_counter.c               |   35 +++++++++++++++
 4 files changed, 119 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/hw_breakpoint.h b/include/asm-generic/hw_breakpoint.h
index 598e3c4..82657bb 100644
--- a/include/asm-generic/hw_breakpoint.h
+++ b/include/asm-generic/hw_breakpoint.h
@@ -105,6 +105,10 @@ register_kernel_hw_breakpoint(struct hw_breakpoint *bp, unsigned long addr,
 			      int len, enum breakpoint_type type);
 extern void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
 
+#ifdef CONFIG_PERF_COUNTERS
+extern void bp_perf_triggered(struct hw_breakpoint *bp, struct pt_regs *regs);
+#endif
+
 extern unsigned int hbp_kernel_pos;
 
 #endif	/* __KERNEL__ */
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 5e970c7..c97df54 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -31,6 +31,7 @@ enum perf_type_id {
 	PERF_TYPE_TRACEPOINT			= 2,
 	PERF_TYPE_HW_CACHE			= 3,
 	PERF_TYPE_RAW				= 4,
+	PERF_TYPE_BREAKPOINT			= 5,
 
 	PERF_TYPE_MAX,				/* non-ABI */
 };
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index f9e62e7..c22c29d 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -72,6 +72,85 @@ unsigned int hbp_kernel_pos = HBP_NUM;
  */
 unsigned int hbp_user_refcount[HBP_NUM];
 
+struct bp_perf_event {
+	struct hw_breakpoint	*bp;
+	int			count;
+	struct list_head	list;
+};
+
+#ifdef CONFIG_PERF_COUNTERS
+
+static LIST_HEAD(breakpoint_perf_events);
+static DEFINE_MUTEX(breakpoint_perf_lock);
+
+
+int hw_breakpoint_perf_init(unsigned long addr)
+{
+	struct bp_perf_event *event;
+	int ret;
+
+	mutex_lock(&breakpoint_perf_lock);
+
+	list_for_each_entry(event, &breakpoint_perf_events, list) {
+		if (hw_breakpoint_addr(event->bp) == addr) {
+			event->count++;
+			goto found;
+		}
+	}
+
+	mutex_unlock(&breakpoint_perf_lock);
+
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
+	event->bp = kzalloc(sizeof(*event->bp), GFP_KERNEL);
+	if (!event->bp) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	event->bp->triggered = bp_perf_triggered;
+	ret = register_kernel_hw_breakpoint(event->bp, addr, 1,
+					    BREAK_RW);
+	if (ret)
+		goto fail;
+
+	mutex_lock(&breakpoint_perf_lock);
+	list_add_tail(&event->list, &breakpoint_perf_events);
+
+found:
+	mutex_unlock(&breakpoint_perf_lock);
+	return 0;
+
+fail:
+	kfree(event->bp);
+	kfree(event);
+	return ret;
+}
+
+void hw_breakpoint_perf_exit(unsigned long addr)
+{
+	struct bp_perf_event *event;
+
+	mutex_lock(&breakpoint_perf_lock);
+
+	list_for_each_entry(event, &breakpoint_perf_events, list) {
+		if (hw_breakpoint_addr(event->bp) == addr) {
+			if (--event->count)
+				break;
+
+			list_del(&event->list);
+			unregister_kernel_hw_breakpoint(event->bp);
+			kfree(event->bp);
+			kfree(event);
+			break;
+		}
+	}
+	mutex_unlock(&breakpoint_perf_lock);
+}
+#endif
+
 /*
  * Load the debug registers during startup of a CPU.
  */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 33ffb5a..8c70723 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -29,6 +29,7 @@
 #include <linux/perf_counter.h>
 
 #include <asm/irq_regs.h>
+#include <asm/hw_breakpoint.h>
 
 /*
  * Each CPU has a list of per CPU counters:
@@ -3718,6 +3719,36 @@ static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 }
 #endif
 
+extern int hw_breakpoint_perf_init(unsigned long addr);
+extern void hw_breakpoint_perf_exit(unsigned long addr);
+
+void bp_perf_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
+{
+	unsigned long target = hw_breakpoint_addr(bp);
+
+	struct perf_sample_data data = {
+		.regs = regs,
+		.addr = instruction_pointer(regs),
+	};
+
+	do_perf_swcounter_event(PERF_TYPE_BREAKPOINT, target, 1, 0, &data);
+}
+
+static void bp_perf_counter_destroy(struct perf_counter *counter)
+{
+	hw_breakpoint_perf_exit(counter->attr.config);
+}
+
+static const struct pmu *bp_perf_counter_init(struct perf_counter *counter)
+{
+	if (hw_breakpoint_perf_init((unsigned long)counter->attr.config))
+		return NULL;
+
+	counter->destroy = bp_perf_counter_destroy;
+
+	return &perf_ops_generic;
+}
+
 atomic_t perf_swcounter_enabled[PERF_COUNT_SW_MAX];
 
 static void sw_perf_counter_destroy(struct perf_counter *counter)
@@ -3857,6 +3888,10 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 		pmu = tp_perf_counter_init(counter);
 		break;
 
+	case PERF_TYPE_BREAKPOINT:
+		pmu = bp_perf_counter_init(counter);
+		break;
+
 	default:
 		break;
 	}
-- 
1.6.2.3

