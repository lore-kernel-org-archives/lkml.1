Return-Path: <linux-kernel-owner+w=401wt.eu-S933358AbZHVUaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358AbZHVUaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 16:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932825AbZHVUai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 16:30:38 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:49317 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800AbZHVUai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 16:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=QVtl1820531I6BiLQMqlRo+QROYXNJzVvx3vqGyUrhvTv1NzC9IMxsi/hY4gGaz57Y
         Rcg4yv2zOcCN5VcLQ1Y3PBsyEpMak0oB0l/vBnto6hpNb0mZ8aYsVDXxn4kACuDIjso8
         Istg89jbPiaHblLKfSk+cwWEyCNONKQtRjRek=
Subject: Subject :[ PATCH 003:003] inclue files
From: raz ben yehuda <raziebe@gmail.com>
To: riel@redhat.com
Cc: mingo@elte.hu, peterz@infradead.org, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 23 Aug 2009 02:30:37 +0300
Message-Id: <1250983837.5688.25.camel@raz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

offsched APIs to be used by offsched drivers.

 cpu.h   |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 sched.h |    2 +-
 2 files changed, 51 insertions(+), 1 deletion(-)

Signed-off-by: raziebe@gmail.com
---
diff -X 2.6.30-offsched/Documentation/dontdiff -urN tmp/linux-2.6.30/include/linux/cpu.h 2.6.30-offsched/include/linux/cpu.h
--- tmp/linux-2.6.30/include/linux/cpu.h	2009-06-10 06:05:27.000000000 +0300
+++ 2.6.30-offsched/include/linux/cpu.h	2009-08-21 22:05:03.000000000 +0300
@@ -43,14 +43,28 @@
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
+extern void unregister_offsched(int cpuid);
 #endif
 struct notifier_block;
 
 #ifdef CONFIG_SMP
 /* Need to know about CPUs going up/down? */
 #ifdef CONFIG_HOTPLUG_CPU
+
+
 extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
+extern int register_offsched(void (*hotplug_cpu_dead)(void), int cpuid);
+extern int is_offsched(int cpuid);
+extern int is_offsched_kmem(int cpuid);
+extern void unset_offsched_kmem(int cpuid);
+extern void set_offsched_kmem(int cpuid);
+extern void run_offsched(void);
+extern int  offsched_is_napi_avail(void);
+extern void offsched_register_napi(void);
+extern void offsched_unregister_napi(void);
+extern void offsched_napi_schedule(void *n);
+extern int offsched_pkt(void *s);
 #else
 
 #ifndef MODULE
@@ -60,11 +74,47 @@
 {
 	return 0;
 }
+
+static inline int register_offsched(void (*hotplug_cpu_dead)(void), int cpuid);
+{
+	return 0;
+}
+
+int  offsched_is_napi_avail(void)
+{
+	return 0;
+}
+
+int offsched_pkt(void *s)
+{
+	return 0;
+}
 #endif
 
 static inline void unregister_cpu_notifier(struct notifier_block *nb)
 {
 }
+
+static inline void unregister_offsched(int cpuid)
+{
+}
+static inline int is_offsched(int cpuid)
+{
+	return 0;
+}
+static inline void run_offsched(void)
+{
+}
+static inline int is_offsched_memory(int cpuid)
+{
+	return 0;
+}
+
+static inline void offsched_napi_schedule(void *n)
+{
+
+}
+
 #endif
 
 int cpu_up(unsigned int cpu);
diff -X 2.6.30-offsched/Documentation/dontdiff -urN tmp/linux-2.6.30/include/linux/sched.h 2.6.30-offsched/include/linux/sched.h
--- tmp/linux-2.6.30/include/linux/sched.h	2009-06-10 06:05:27.000000000 +0300
+++ 2.6.30-offsched/include/linux/sched.h	2009-07-25 13:59:19.000000000 +0300
@@ -1999,7 +1999,7 @@
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
 extern char *get_task_comm(char *to, struct task_struct *tsk);
-
+extern rwlock_t *get_tasklist_lock(void);
 #ifdef CONFIG_SMP
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else


