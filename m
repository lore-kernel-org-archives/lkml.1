Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbXEXMMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbXEXMMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbXEXMKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:10:24 -0400
Received: from il.qumranet.com ([82.166.9.18]:36455 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065AbXEXMKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:10:20 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com,
       lhcs-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 4/7] SMP: Implement on_one_cpu()
Date: Thu, 24 May 2007 15:10:12 +0300
Message-Id: <11800086152009-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1180008615579-git-send-email-avi@qumranet.com>
References: <1180008615579-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This defines on_one_cpu() which is similar to smp_call_function_single()
except that it works if cpu happens to be the current cpu.  Can also be
seen as a complement to on_each_cpu() (which also doesn't treat the
current cpu specially).

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/smp.h |   15 +++++++++++++++
 kernel/softirq.c    |   24 ++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 3f70149..4ff8d68 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -60,6 +60,11 @@ int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
  * Call a function on all processors
  */
 int on_each_cpu(void (*func) (void *info), void *info, int retry, int wait);
+/*
+ * Call a function on one processor
+ */
+int on_one_cpu(int cpu, void (*func)(void *info), void *info,
+	       int retry, int wait);
 
 #define MSG_ALL_BUT_SELF	0x8000	/* Assume <32768 CPU's */
 #define MSG_ALL			0x8001
@@ -95,6 +100,16 @@ static inline int up_smp_call_function(void)
 		local_irq_enable();		\
 		0;				\
 	})
+
+static inline int on_one_cpu(int cpu, void (*func)(void *info), void *info,
+			     int retry, int wait)
+{
+	local_irq_disable();
+	func(info);
+	local_irq_enable();
+	return 0;
+}
+
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 0b9886a..b1a3284 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -658,4 +658,28 @@ int on_each_cpu(void (*func) (void *info), void *info, int retry, int wait)
 	return ret;
 }
 EXPORT_SYMBOL(on_each_cpu);
+
+/*
+ * Call a function on one processor, which might be the currently executing
+ * processor.
+ */
+int on_one_cpu(int cpu, void (*func) (void *info), void *info,
+	       int retry, int wait)
+{
+	int ret;
+	int this_cpu;
+
+	this_cpu = get_cpu();
+	if (this_cpu == cpu) {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
+		ret = 0;
+	} else
+		ret = smp_call_function_single(cpu, func, info, retry, wait);
+	put_cpu();
+	return ret;
+}
+EXPORT_SYMBOL(on_one_cpu);
+
 #endif
-- 
1.5.0.6

