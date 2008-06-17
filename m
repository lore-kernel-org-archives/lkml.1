Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbYFQWEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbYFQWEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759985AbYFQWCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:02:34 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:14514 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759978AbYFQWCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:02:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=rZek4py2ju75/O6HnH6lECMcS1/fZyXh3YkJr5sppReYF2V/MHf54wZlipBBl/bt//
         3xRsLSVyYYV/xZL/TPdeworCqK+wnOu/hkd+hYShKq1HsL9l8ffEFRb4btAb0eNXyB7u
         mvnsZyyQdBVc8NXF3fMzMuwUs1v1eVW4U2GZA=
To: linux-kernel@vger.kernel.org
Subject: [patch 06/19] perfmon2 minimal v2:  X86 OProfile hooks
From: eranian@googlemail.com
Date: Tue, 17 Jun 2008 15:02:28 -0700 (PDT)
Message-ID: <48583474.1d3e400a.4004.ffffbdba@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides PMU access synchronization between Perfmon2 and OProfile.
Both subsystems can be compiled in. Only one of them can be active
at any one time. It is necessary to issue opcontrol --shutdown
to terminate the OProfile session.

Signed-off-by: Stephane Eranian <eranian@gmail.com>

--

Index: o/arch/x86/oprofile/nmi_int.c
===================================================================
--- o.orig/arch/x86/oprofile/nmi_int.c	2008-06-04 22:36:10.000000000 +0200
+++ o/arch/x86/oprofile/nmi_int.c	2008-06-04 22:38:20.000000000 +0200
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
 }
 
 static void nmi_cpu_start(void *dummy)
Index: o/include/linux/perfmon_kern.h
===================================================================
--- o.orig/include/linux/perfmon_kern.h	2008-06-04 22:38:13.000000000 +0200
+++ o/include/linux/perfmon_kern.h	2008-06-04 22:38:20.000000000 +0200
@@ -180,6 +180,9 @@
 
 void pfm_interrupt_handler(unsigned long ip, struct pt_regs *regs);
 
+int pfm_session_allcpus_acquire(void);
+void pfm_session_allcpus_release(void);
+
 static inline void pfm_exit_thread(void)
 {
 	if (current->pfm_context)
@@ -256,6 +259,8 @@
 #define pfm_copy_thread(_t)		do { } while (0)
 #define pfm_ctxsw_in(_p, _n)    	do { } while (0)
 #define pfm_ctxsw_out(_p, _n)      	do { } while (0)
+#define pfm_session_allcpus_release()	do { } while (0)
+#define pfm_session_allcpus_acquire()	(0)
 
 #endif /* CONFIG_PERFMON */
 
Index: o/perfmon/perfmon_res.c
===================================================================
--- o.orig/perfmon/perfmon_res.c	2008-06-04 22:36:10.000000000 +0200
+++ o/perfmon/perfmon_res.c	2008-06-04 22:38:20.000000000 +0200
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

