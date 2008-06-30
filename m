Return-Path: <linux-kernel-owner+w=401wt.eu-S1762460AbYF3NPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762460AbYF3NPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbYF3NOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:14:00 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:57975 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761919AbYF3NN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:13:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=fO+2ms1tnvqg62br4Ja1SKIB5C17BzIlhF6yo/omExhASz7xWTDnI865PUfttzlbtg
         hAKiupW0L5XumIcOWDILHhDr+AP9TSzK5t9zv/hQRQKWxC71HWyxX5mBADRklRI2Qheb
         SO4jPl7Dmxc7/8Lf9kQkhdxFscEex6PSL2i/g=
To: linux-kernel@vger.kernel.org
Subject: [patch 06/19] perfmon2 minimal v3:  X86 OProfile hooks
From: eranian@googlemail.com
Date: Mon, 30 Jun 2008 06:13:53 -0700 (PDT)
Message-ID: <4868dc11.16125e0a.0637.ffffeccd@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides PMU access synchronization between Perfmon2 and OProfile.
Both subsystems can be compiled in. Only one of them can be active
at any one time. It is necessary to issue opcontrol --shutdown
to terminate the OProfile session.

Signed-off-by: Stephane Eranian <eranian@gmail.com>

--

Index: linux-next/arch/x86/oprofile/nmi_int.c
===================================================================
--- linux-next.orig/arch/x86/oprofile/nmi_int.c	2008-06-26 17:46:24.000000000 +0200
+++ linux-next/arch/x86/oprofile/nmi_int.c	2008-06-26 19:48:15.000000000 +0200
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/moduleparam.h>
 #include <linux/kdebug.h>
+#include <linux/perfmon_kern.h>
 #include <asm/nmi.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
@@ -191,12 +192,18 @@
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
 
@@ -275,6 +282,7 @@
 	unregister_die_notifier(&profile_exceptions_nb);
 	model->shutdown(msrs);
 	free_msrs();
+	pfm_session_allcpus_release();
 	put_cpu_var(cpu_msrs);
 }
 
Index: linux-next/include/linux/perfmon_kern.h
===================================================================
--- linux-next.orig/include/linux/perfmon_kern.h	2008-06-26 19:47:13.000000000 +0200
+++ linux-next/include/linux/perfmon_kern.h	2008-06-26 19:47:29.000000000 +0200
@@ -178,6 +178,9 @@
 
 void pfm_interrupt_handler(unsigned long ip, struct pt_regs *regs);
 
+int pfm_session_allcpus_acquire(void);
+void pfm_session_allcpus_release(void);
+
 static inline void pfm_exit_thread(void)
 {
 	if (current->pfm_context)
@@ -254,6 +257,8 @@
 #define pfm_copy_thread(_t)		do { } while (0)
 #define pfm_ctxsw_in(_p, _n)    	do { } while (0)
 #define pfm_ctxsw_out(_p, _n)      	do { } while (0)
+#define pfm_session_allcpus_release()	do { } while (0)
+#define pfm_session_allcpus_acquire()	(0)
 
 #endif /* CONFIG_PERFMON */
 #endif /* __LINUX_PERFMON_KERN_H__ */
Index: linux-next/perfmon/perfmon_res.c
===================================================================
--- linux-next.orig/perfmon/perfmon_res.c	2008-06-26 19:47:05.000000000 +0200
+++ linux-next/perfmon/perfmon_res.c	2008-06-26 19:47:29.000000000 +0200
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

