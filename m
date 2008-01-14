Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbYANP67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbYANP67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbYANP5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:57:54 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43425 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYANP5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:57:53 -0500
Message-Id: <20080114155602.855698000@bull.net>
References: <20080114155402.690906000@bull.net>
User-Agent: quilt/0.45-1
Date: Mon, 14 Jan 2008 16:54:06 +0100
From: Nadia.Derbey@bull.net
To: akmp@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, matthltc@us.ibm.com,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC PATCH 4/4] [RESEND] Recomputing msgmni on memory add / remove
Content-Disposition: inline; filename=ipc_recompute_msgmni_on_memory_hotplug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 04/04]

This patch introduces the registration of a callback routine that recomputes
msg_ctlmni upon memory add / remove.

A notifier block structure has been added to the ipc namespace structure.

Each time a new ipc namespace is allocated, this notifier block callback
routine is registered into the memory hotplug notifier chain (it is
unregistered when the ipc namespace is freed). That routine is then activated
when memory is added or removed, in order to recompute msgmni for that
namespace.  


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/ipc.h    |   25 +++++++++++++++++++++
 include/linux/memory.h |    1 
 ipc/msg.c              |    2 -
 ipc/util.c             |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
 ipc/util.h             |    2 +
 5 files changed, 86 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc7/include/linux/ipc.h
===================================================================
--- linux-2.6.24-rc7.orig/include/linux/ipc.h	2008-01-11 16:00:50.000000000 +0100
+++ linux-2.6.24-rc7/include/linux/ipc.h	2008-01-11 16:52:04.000000000 +0100
@@ -81,6 +81,10 @@ struct ipc_kludge {
 
 #include <linux/kref.h>
 #include <linux/spinlock.h>
+#ifdef CONFIG_MEMORY_HOTPLUG
+#include <linux/notifier.h>
+#include <linux/memory.h>
+#endif /* CONFIG_MEMORY_HOTPLUG */
 
 #define IPCMNI 32768  /* <= MAX_INT limit for ipc arrays (including sysctl changes) */
 
@@ -118,6 +122,10 @@ struct ipc_namespace {
 	size_t		shm_ctlall;
 	int		shm_ctlmni;
 	int		shm_tot;
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+	struct notifier_block ipc_memory_hotplug;
+#endif
 };
 
 extern struct ipc_namespace init_ipc_ns;
@@ -153,6 +161,23 @@ static inline void put_ipc_ns(struct ipc
 #endif
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+
+extern void register_ipc_hotplug_notifier(struct ipc_namespace *);
+
+static inline void unregister_ipc_hotplug_notifier(struct ipc_namespace *ns)
+{
+	unregister_memory_notifier(&ns->ipc_memory_hotplug);
+}
+
+#else /* CONFIG_MEMORY_HOTPLUG */
+
+#define register_ipc_hotplug_notifier(ns)   do { } while (0)
+#define unregister_ipc_hotplug_notifier(ns)  do { } while (0)
+
+#endif /* CONFIG_MEMORY_HOTPLUG */
+
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_IPC_H */
Index: linux-2.6.24-rc7/include/linux/memory.h
===================================================================
--- linux-2.6.24-rc7.orig/include/linux/memory.h	2008-01-11 16:26:03.000000000 +0100
+++ linux-2.6.24-rc7/include/linux/memory.h	2008-01-11 16:53:10.000000000 +0100
@@ -59,6 +59,7 @@ struct mem_section;
  * order in the callback chain)
  */
 #define SLAB_CALLBACK_PRI       1
+#define IPC_CALLBACK_PRI        10
 
 #ifndef CONFIG_MEMORY_HOTPLUG_SPARSE
 static inline int memory_dev_init(void)
Index: linux-2.6.24-rc7/ipc/util.h
===================================================================
--- linux-2.6.24-rc7.orig/ipc/util.h	2008-01-11 14:08:48.000000000 +0100
+++ linux-2.6.24-rc7/ipc/util.h	2008-01-11 16:56:23.000000000 +0100
@@ -134,6 +134,8 @@ extern int ipcget_new(struct ipc_namespa
 extern int ipcget_public(struct ipc_namespace *, struct ipc_ids *,
 			struct ipc_ops *, struct ipc_params *);
 
+extern void recompute_msgmni(struct ipc_namespace *);
+
 static inline int ipc_buildid(int id, int seq)
 {
 	return SEQ_MULTIPLIER * seq + id;
Index: linux-2.6.24-rc7/ipc/util.c
===================================================================
--- linux-2.6.24-rc7.orig/ipc/util.c	2008-01-11 16:12:38.000000000 +0100
+++ linux-2.6.24-rc7/ipc/util.c	2008-01-11 16:58:29.000000000 +0100
@@ -33,6 +33,7 @@
 #include <linux/audit.h>
 #include <linux/nsproxy.h>
 #include <linux/rwsem.h>
+#include <linux/memory.h>
 
 #include <asm/unistd.h>
 
@@ -54,6 +55,50 @@ struct ipc_namespace init_ipc_ns = {
 atomic_t nr_ipc_ns = ATOMIC_INIT(1);
 
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+
+static int ipc_memory_callback(struct notifier_block *self,
+				unsigned long action, void *arg)
+{
+	struct ipc_namespace *ns;
+
+	switch (action) {
+	case MEM_ONLINE:    /* memory successfully brought online */
+	case MEM_OFFLINE:   /* or offline: it's time to recompute xxxmni */
+		ns = container_of(self, struct ipc_namespace,
+				ipc_memory_hotplug);
+		/*
+		 * No need to get a reference on the ns: the 1st job of
+		 * free_ipc_ns() is to unregister the callback routine.
+		 * blocking_notifier_chain_unregister takes the wr lock to do
+		 * it.
+		 * When this callback routine is called the rd lock is held by
+		 * blocking_notifier_call_chain.
+		 * So the ipc ns cannot be freed while we are here.
+		 */
+		recompute_msgmni(ns);
+		break;
+	case MEM_GOING_ONLINE:
+	case MEM_GOING_OFFLINE:
+	case MEM_CANCEL_ONLINE:
+	case MEM_CANCEL_OFFLINE:
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+void register_ipc_hotplug_notifier(struct ipc_namespace *ns)
+{
+	memset(&ns->ipc_memory_hotplug, 0, sizeof(ns->ipc_memory_hotplug));
+	ns->ipc_memory_hotplug.notifier_call = ipc_memory_callback;
+	ns->ipc_memory_hotplug.priority = IPC_CALLBACK_PRI;
+	register_memory_notifier(&ns->ipc_memory_hotplug);
+}
+
+#endif /* CONFIG_MEMORY_HOTPLUG */
+
 static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
 {
 	int err;
@@ -76,6 +121,8 @@ static struct ipc_namespace *clone_ipc_n
 	if (err)
 		goto err_shm;
 
+	register_ipc_hotplug_notifier(ns);
+
 	kref_init(&ns->kref);
 	return ns;
 
@@ -111,6 +158,15 @@ void free_ipc_ns(struct kref *kref)
 	struct ipc_namespace *ns;
 
 	ns = container_of(kref, struct ipc_namespace, kref);
+	/*
+	 * Unregistering the hotplug notifier at the beginning guarantees
+	 * that the ipc namespace won't be freed while we are inside the
+	 * the callback routine. Since the blocking_notifier_chain_XXX
+	 * routines hold a rw lock on the notifier list,
+	 * unregister_ipc_hotplug_notifier() won't take the rw lock before
+	 * blocking_notifier_call_chain() has released the rd lock.
+	 */
+	unregister_ipc_hotplug_notifier(ns);
 	sem_exit_ns(ns);
 	msg_exit_ns(ns);
 	shm_exit_ns(ns);
@@ -130,6 +186,7 @@ static int __init ipc_init(void)
 	sem_init();
 	msg_init();
 	shm_init();
+	register_ipc_hotplug_notifier(&init_ipc_ns);
 	return 0;
 }
 __initcall(ipc_init);
Index: linux-2.6.24-rc7/ipc/msg.c
===================================================================
--- linux-2.6.24-rc7.orig/ipc/msg.c	2008-01-11 16:08:32.000000000 +0100
+++ linux-2.6.24-rc7/ipc/msg.c	2008-01-11 17:03:31.000000000 +0100
@@ -85,7 +85,7 @@ static int sysvipc_msg_proc_show(struct 
  * queues should occupy at most 1/MSG_MEM_SCALE of lowmem.
  * Also take into account the number of nsproxies created so far.
  */
-static void recompute_msgmni(struct ipc_namespace *ns)
+void recompute_msgmni(struct ipc_namespace *ns)
 {
 	struct sysinfo i;
 	unsigned long allowed;

--
