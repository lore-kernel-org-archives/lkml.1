Return-Path: <linux-kernel-owner+w=401wt.eu-S1764541AbYFFGSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764541AbYFFGSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764465AbYFFGRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:17:40 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59257 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764451AbYFFGRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:17:37 -0400
Message-Id: <20080606060958.224166281@bull.net>
References: <20080606060955.317871352@bull.net>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 08:09:57 +0200
From: <Solofo.Ramangalahy@bull.net>
To: <linux-kernel@vger.kernel.org>
Cc: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
Subject: [RFC -mm 2/6] sysv ipc: recompute msgmnb (and msgmni) on cpu hotplug
 addition and removal
Content-Disposition: inline;
 filename=ipc-recompute-msgmnb-and-msgmni-on-cpu-hotplug-addition-removal.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

As msgmnb is scaled wrt. online cpus, cpu hotplug events should grow
and shrink the value.

Like msgmni with ipc_memory_callback(), the ipc_cpu_callback()
function triggers msgmnb recomputation.

Signed-off-by: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

---
 include/linux/ipc_namespace.h |    1 +
 ipc/ipcns_notifier.c          |   14 +++++++++-----
 ipc/util.c                    |   28 ++++++++++++++++++++++++++++
 ipc/util.h                    |    1 +
 4 files changed, 39 insertions(+), 5 deletions(-)

Index: b/include/linux/ipc_namespace.h
===================================================================
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -12,6 +12,7 @@
 #define IPCNS_MEMCHANGED   0x00000001   /* Notify lowmem size changed */
 #define IPCNS_CREATED  0x00000002   /* Notify new ipc namespace created */
 #define IPCNS_REMOVED  0x00000003   /* Notify ipc namespace removed */
+#define IPCNS_CPUCHANGED  0x00000004   /* Notify cpu hotplug addition/removal */
 
 #define IPCNS_CALLBACK_PRI 0
 
Index: b/ipc/util.c
===================================================================
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -34,6 +34,7 @@
 #include <linux/nsproxy.h>
 #include <linux/rwsem.h>
 #include <linux/memory.h>
+#include <linux/cpu.h>
 #include <linux/ipc_namespace.h>
 
 #include <asm/unistd.h>
@@ -96,6 +97,32 @@ static int ipc_memory_callback(struct no
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+static void ipc_cpu_notifier(struct work_struct *work)
+{
+	ipcns_notify(IPCNS_CPUCHANGED);
+}
+
+static DECLARE_WORK(ipc_cpu_wq, ipc_cpu_notifier);
+
+static int __cpuinit ipc_cpu_callback(struct notifier_block *nfb,
+				    unsigned long action, void *hcpu)
+{
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		schedule_work(&ipc_cpu_wq);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+#endif /* CONFIG_HOTPLUG_CPU */
 /**
  *	ipc_init	-	initialise IPC subsystem
  *
@@ -112,6 +139,7 @@ static int __init ipc_init(void)
 	msg_init();
 	shm_init();
 	hotplug_memory_notifier(ipc_memory_callback, IPC_CALLBACK_PRI);
+	hotcpu_notifier(ipc_cpu_callback, IPC_CALLBACK_PRI);
 	register_ipcns_notifier(&init_ipc_ns);
 	return 0;
 }
Index: b/ipc/ipcns_notifier.c
===================================================================
--- a/ipc/ipcns_notifier.c
+++ b/ipc/ipcns_notifier.c
@@ -26,16 +26,20 @@ static int ipcns_callback(struct notifie
 				unsigned long action, void *arg)
 {
 	struct ipc_namespace *ns;
-
+	ns = container_of(self, struct ipc_namespace, ipcns_nb);
 	switch (action) {
+	case IPCNS_CPUCHANGED:
+		/*
+		 * Fall through.
+		 * We do not scale msgmnb with IPC namespace
+		 * add/remove for simplicity (adjustment of the
+		 * message pool is done indirectly via msgmni).
+		 */
+		recompute_msgmnb(ns);
 	case IPCNS_MEMCHANGED:   /* amount of lowmem has changed */
 	case IPCNS_CREATED:
 	case IPCNS_REMOVED:
 		/*
-		 * It's time to recompute msgmni
-		 */
-		ns = container_of(self, struct ipc_namespace, ipcns_nb);
-		/*
 		 * No need to get a reference on the ns: the 1st job of
 		 * free_ipc_ns() is to unregister the callback routine.
 		 * blocking_notifier_chain_unregister takes the wr lock to do
Index: b/ipc/util.h
===================================================================
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -122,6 +122,7 @@ extern struct msg_msg *load_msg(const vo
 extern int store_msg(void __user *dest, struct msg_msg *msg, int len);
 
 extern void recompute_msgmni(struct ipc_namespace *);
+extern void recompute_msgmnb(struct ipc_namespace *);
 
 static inline int ipc_buildid(int id, int seq)
 {

-- 
Solofo Ramangalahy
Bull SA.
