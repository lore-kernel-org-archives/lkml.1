Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbXGHL66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbXGHL66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbXGHLzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:55:21 -0400
Received: from il.qumranet.com ([82.166.9.18]:38400 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbXGHLyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:47 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 17/20] SMP: Implement on_cpu()
Date: Sun,  8 Jul 2007 14:54:46 +0300
Message-Id: <11838956893094-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This defines on_cpu() which is similar to smp_call_function_single()
except that it works if cpu happens to be the current cpu.  Can also be
seen as a complement to on_each_cpu() (which also doesn't treat the
current cpu specially).

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/smp.h |   16 ++++++++++++++++
 kernel/softirq.c    |   24 ++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 96ac21f..613edd2 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -7,6 +7,7 @@
  */
 
 #include <linux/errno.h>
+#include <asm/system.h>
 
 extern void cpu_idle(void);
 
@@ -61,6 +62,11 @@ int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
  * Call a function on all processors
  */
 int on_each_cpu(void (*func) (void *info), void *info, int retry, int wait);
+/*
+ * Call a function on one processor
+ */
+int on_cpu(int cpu, void (*func)(void *info), void *info,
+	       int retry, int wait);
 
 #define MSG_ALL_BUT_SELF	0x8000	/* Assume <32768 CPU's */
 #define MSG_ALL			0x8001
@@ -96,6 +102,16 @@ static inline int up_smp_call_function(void)
 		local_irq_enable();		\
 		0;				\
 	})
+
+static inline int on_cpu(int cpu, void (*func)(void *info), void *info,
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
index 0b9886a..11666f7 100644
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
+int on_cpu(int cpu, void (*func) (void *info), void *info,
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
+EXPORT_SYMBOL(on_cpu);
+
 #endif
-- 
1.5.2.2

