Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbYGPJTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbYGPJTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 05:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYGPJTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 05:19:36 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:32785 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbYGPJTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 05:19:35 -0400
Message-Id: <20080715211408.175649726@bull.net>
References: <20080715211407.423625725@bull.net>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 23:14:09 +0200
From: <Solofo.Ramangalahy@bull.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Matt Helsley <matthltc@us.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>, Nadia Derbey <Nadia.Derbey@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>,
       Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
Subject: [PATCH -mm v2 2/3] sysv ipc: recompute msgmnb (and msgmni) on cpu
 hotplug addition and removal
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
 ipc/ipcns_notifier.c          |    8 +++-----
 ipc/util.c                    |   28 ++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 5 deletions(-)

Index: linux-2.6.26-rc8-mm1-MSGMNB3/include/linux/ipc_namespace.h
===================================================================
--- linux-2.6.26-rc8-mm1-MSGMNB3.orig/include/linux/ipc_namespace.h
+++ linux-2.6.26-rc8-mm1-MSGMNB3/include/linux/ipc_namespace.h
@@ -12,6 +12,7 @@
 #define IPCNS_MEMCHANGED   0x00000001   /* Notify lowmem size changed */
 #define IPCNS_CREATED  0x00000002   /* Notify new ipc namespace created */
 #define IPCNS_REMOVED  0x00000003   /* Notify ipc namespace removed */
+#define IPCNS_CPUCHANGED  0x00000004   /* Notify cpu hotplug addition/removal */
 
 #define IPCNS_CALLBACK_PRI 0
 
Index: linux-2.6.26-rc8-mm1-MSGMNB3/ipc/util.c
===================================================================
--- linux-2.6.26-rc8-mm1-MSGMNB3.orig/ipc/util.c
+++ linux-2.6.26-rc8-mm1-MSGMNB3/ipc/util.c
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
Index: linux-2.6.26-rc8-mm1-MSGMNB3/ipc/ipcns_notifier.c
===================================================================
--- linux-2.6.26-rc8-mm1-MSGMNB3.orig/ipc/ipcns_notifier.c
+++ linux-2.6.26-rc8-mm1-MSGMNB3/ipc/ipcns_notifier.c
@@ -26,16 +26,14 @@ static int ipcns_callback(struct notifie
 				unsigned long action, void *arg)
 {
 	struct ipc_namespace *ns;
-
+	ns = container_of(self, struct ipc_namespace, ipcns_nb);
 	switch (action) {
+	case IPCNS_CPUCHANGED:
+		ipc_recompute_msgmnb(ns); /* Fall through */
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

-- 
