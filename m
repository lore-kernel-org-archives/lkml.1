Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195Ab0AVPBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab0AVPBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159Ab0AVPA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:00:58 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:39179 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab0AVPA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:00:56 -0500
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>
Cc: <andreas.herrmann3@amd.com>, <x86@kernel.org>,
       <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/5] x86, lib: Add wbinvd smp helpers
Date: Fri, 22 Jan 2010 16:01:03 +0100
Message-Id: <1264172467-25155-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264172467-25155-1-git-send-email-bp@amd64.org>
References: <1264172467-25155-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add wbinvd_on_cpu and wbinvd_on_all_cpus stubs for executing wbinvd on a
particular CPU.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/smp.h |    5 +++++
 arch/x86/lib/Makefile      |    1 +
 arch/x86/lib/smp.c         |   19 +++++++++++++++++++
 3 files changed, 25 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/lib/smp.c

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 1e79678..82e675b 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -135,6 +135,8 @@ int native_cpu_disable(void);
 void native_cpu_die(unsigned int cpu);
 void native_play_dead(void);
 void play_dead_common(void);
+void wbinvd_on_cpu(int cpu);
+int wbinvd_on_all_cpus(void);
 
 void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
@@ -147,6 +149,9 @@ static inline int num_booting_cpus(void)
 {
 	return cpumask_weight(cpu_callout_mask);
 }
+#else /* !CONFIG_SMP */
+#define wbinvd_on_cpu(cpu)     wbinvd()
+#define wbinvd_on_all_cpus()   wbinvd()
 #endif /* CONFIG_SMP */
 
 extern unsigned disabled_cpus __cpuinitdata;
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index cffd754..171cb14 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -15,6 +15,7 @@ $(obj)/inat.o: $(obj)/inat-tables.c
 clean-files := inat-tables.c
 
 obj-$(CONFIG_SMP) += msr-smp.o
+obj-$(CONFIG_SMP) += smp.o
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
diff --git a/arch/x86/lib/smp.c b/arch/x86/lib/smp.c
new file mode 100644
index 0000000..a3c6688
--- /dev/null
+++ b/arch/x86/lib/smp.c
@@ -0,0 +1,19 @@
+#include <linux/smp.h>
+#include <linux/module.h>
+
+static void __wbinvd(void *dummy)
+{
+	wbinvd();
+}
+
+void wbinvd_on_cpu(int cpu)
+{
+	smp_call_function_single(cpu, __wbinvd, NULL, 1);
+}
+EXPORT_SYMBOL(wbinvd_on_cpu);
+
+int wbinvd_on_all_cpus(void)
+{
+	return on_each_cpu(__wbinvd, NULL, 1);
+}
+EXPORT_SYMBOL(wbinvd_on_all_cpus);
-- 
1.6.6

