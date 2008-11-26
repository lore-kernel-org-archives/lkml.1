Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbYKZIom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbYKZIom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYKZImT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:42:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:25617 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbYKZImQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:42:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:from:date:message-id;
        b=MAsiIkr7J9qE2E44J8BIYc16d6u2642F/jecPfp4bD/iqEFcMmAmjPXuYT8Ui6z3bC
         uKTyUAMC1oMjPmGE4zkaVCA8ooazpWT/mcUkXTKt0Dkae6qcR53eHgpgxtyuDB8zHTqL
         lApbC12FDncpuHdRPVkxl8zeHmDK5t2+dp3oQ=
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: [patch 07/24] perfmon: OProfile hooks (x86)
From: eranian@googlemail.com
Date: Wed, 26 Nov 2008 00:42:15 -0800 (PST)
Message-ID: <492d0be7.0f975e0a.1ba8.5380@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides PMU access synchronization between Perfmon and OProfile.
Both subsystems can be compiled in. Only one of them can be active
at any one time. It is necessary to issue opcontrol --shutdown
to terminate the OProfile session.

Signed-off-by: Stephane Eranian <eranian@gmail.com>

--

Index: o3/arch/x86/oprofile/nmi_int.c
===================================================================
--- o3.orig/arch/x86/oprofile/nmi_int.c	2008-11-03 10:46:42.000000000 +0100
+++ o3/arch/x86/oprofile/nmi_int.c	2008-11-03 10:58:17.000000000 +0100
@@ -17,6 +17,7 @@
 #include <linux/moduleparam.h>
 #include <linux/kdebug.h>
 #include <linux/cpu.h>
+#include <linux/perfmon_kern.h>
 #include <asm/nmi.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
@@ -142,12 +143,18 @@
 	int err = 0;
 	int cpu;
 
-	if (!allocate_msrs())
+	if (pfm_session_allcpus_acquire())
+		return -EBUSY;
+
+	if (!allocate_msrs()) {
+		pfm_session_allcpus_release();
 		return -ENOMEM;
+	}
 
 	err = register_die_notifier(&profile_exceptions_nb);
 	if (err) {
 		free_msrs();
+		pfm_session_allcpus_release();
 		return err;
 	}
 
@@ -228,6 +235,7 @@
 	msrs = &get_cpu_var(cpu_msrs);
 	model->shutdown(msrs);
 	free_msrs();
+	pfm_session_allcpus_release();
 	put_cpu_var(cpu_msrs);
 }
 
Index: o3/include/linux/perfmon_kern.h
===================================================================
--- o3.orig/include/linux/perfmon_kern.h	2008-11-03 10:49:47.000000000 +0100
+++ o3/include/linux/perfmon_kern.h	2008-11-03 10:58:17.000000000 +0100
@@ -192,6 +192,9 @@
 
 void pfm_interrupt_handler(unsigned long ip, struct pt_regs *regs);
 
+int pfm_session_allcpus_acquire(void);
+void pfm_session_allcpus_release(void);
+
 static inline void pfm_exit_thread(void)
 {
 	if (current->pfm_context)
@@ -272,5 +275,13 @@
 
 static inline void pfm_ctxsw_out(struct task_struct *p, struct task_struct *n)
 {}
+
+static inline void pfm_session_allcpus_release(void)
+{}
+
+static inline int pfm_session_allcpus_acquire(void)
+{
+	return 0;
+}
 #endif /* CONFIG_PERFMON */
 #endif /* __LINUX_PERFMON_KERN_H__ */
Index: o3/perfmon/perfmon_res.c
===================================================================
--- o3.orig/perfmon/perfmon_res.c	2008-11-03 10:49:37.000000000 +0100
+++ o3/perfmon/perfmon_res.c	2008-11-03 10:58:17.000000000 +0100
@@ -36,6 +36,7 @@
  * 02111-1307 USA
  */
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/perfmon_kern.h>
 #include "perfmon_priv.h"
 
@@ -103,3 +104,87 @@
 
 	spin_unlock_irqrestore(&pfm_res_lock, flags);
 }
+
+/**
+ * pfm_session_allcpus_acquire - acquire per-cpu sessions on all available cpus
+ *
+ * currently used by Oprofile on X86
+ */
+int pfm_session_allcpus_acquire(void)
+{
+	unsigned long flags;
+	u32 nsys_cpus, cpu;
+	int ret = -EBUSY;
+
+	spin_lock_irqsave(&pfm_res_lock, flags);
+
+	nsys_cpus = cpus_weight(pfm_res.sys_cpumask);
+
+	PFM_DBG("in  sys=%u task=%u",
+		nsys_cpus,
+		pfm_res.thread_sessions);
+
+	if (nsys_cpus) {
+		PFM_DBG("already some system-wide sessions");
+		goto abort;
+	}
+
+	/*
+	 * cannot mix system wide and per-task sessions
+	 */
+	if (pfm_res.thread_sessions) {
+		PFM_DBG("%u conflicting thread_sessions",
+			pfm_res.thread_sessions);
+		goto abort;
+	}
+
+	for_each_online_cpu(cpu) {
+		cpu_set(cpu, pfm_res.sys_cpumask);
+		nsys_cpus++;
+	}
+
+	PFM_DBG("out sys=%u task=%u",
+		nsys_cpus,
+		pfm_res.thread_sessions);
+
+	ret = 0;
+abort:
+	spin_unlock_irqrestore(&pfm_res_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(pfm_session_allcpus_acquire);
+
+/**
+ * pfm_session_allcpus_release - relase per-cpu sessions on all cpus
+ *
+ * currently used by Oprofile code
+ */
+void pfm_session_allcpus_release(void)
+{
+	unsigned long flags;
+	u32 nsys_cpus, cpu;
+
+	spin_lock_irqsave(&pfm_res_lock, flags);
+
+	nsys_cpus = cpus_weight(pfm_res.sys_cpumask);
+
+	PFM_DBG("in  sys=%u task=%u",
+		nsys_cpus,
+		pfm_res.thread_sessions);
+
+	/*
+	 * XXX: could use __cpus_clear() with nbits
+	 */
+	for_each_online_cpu(cpu) {
+		cpu_clear(cpu, pfm_res.sys_cpumask);
+		nsys_cpus--;
+	}
+
+	PFM_DBG("out sys=%u task=%u",
+		nsys_cpus,
+		pfm_res.thread_sessions);
+
+	spin_unlock_irqrestore(&pfm_res_lock, flags);
+}
+EXPORT_SYMBOL(pfm_session_allcpus_release);

-- 

