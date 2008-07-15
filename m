Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbYGPJUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbYGPJUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 05:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759575AbYGPJTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 05:19:41 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:32832 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759510AbYGPJTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 05:19:40 -0400
Message-Id: <20080715211408.381111371@bull.net>
References: <20080715211407.423625725@bull.net>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 23:14:10 +0200
From: <Solofo.Ramangalahy@bull.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Matt Helsley <matthltc@us.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>, Nadia Derbey <Nadia.Derbey@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>,
       Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
Subject: [PATCH -mm v2 3/3] sysv ipc: use auto_msgmnb to desactivate and
 reactivate msgmnb recomputation
Content-Disposition: inline; filename=ipc-use-auto_msgmnb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

Add /proc/sys/kernel/auto_msgmnb to control automatic recomputation of
/proc/sys/kernel/msgmnb (msg_ctlmnb).

Signed-off-by: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
---
 Documentation/sysctl/kernel.txt |   35 ++++++++++++++++
 include/linux/ipc_namespace.h   |    5 ++
 ipc/ipc_sysctl.c                |   87 ++++++++++++++++++++++++++++++++++++----
 ipc/ipcns_notifier.c            |   62 +++++++++++++++++++++++++++-
 ipc/namespace.c                 |    2 
 ipc/util.c                      |    1 
 6 files changed, 183 insertions(+), 9 deletions(-)

Index: linux-2.6.26-rc8-mm1-MSGMNB3/include/linux/ipc_namespace.h
===================================================================
--- linux-2.6.26-rc8-mm1-MSGMNB3.orig/include/linux/ipc_namespace.h
+++ linux-2.6.26-rc8-mm1-MSGMNB3/include/linux/ipc_namespace.h
@@ -38,6 +38,7 @@ struct ipc_namespace {
 	atomic_t	msg_bytes;
 	atomic_t	msg_hdrs;
 	int		auto_msgmni;
+	int		auto_msgmnb;
 
 	size_t		shm_ctlmax;
 	size_t		shm_ctlall;
@@ -45,6 +46,7 @@ struct ipc_namespace {
 	int		shm_tot;
 
 	struct notifier_block ipcns_nb;
+	struct notifier_block ipcns_nb_msgmnb;
 };
 
 extern struct ipc_namespace init_ipc_ns;
@@ -56,6 +58,9 @@ extern atomic_t nr_ipc_ns;
 extern int register_ipcns_notifier(struct ipc_namespace *);
 extern int cond_register_ipcns_notifier(struct ipc_namespace *);
 extern void unregister_ipcns_notifier(struct ipc_namespace *);
+extern int register_ipcns_notifier_msgmnb(struct ipc_namespace *);
+extern int cond_register_ipcns_notifier_msgmnb(struct ipc_namespace *);
+extern void unregister_ipcns_notifier_msgmnb(struct ipc_namespace *);
 extern int ipcns_notify(unsigned long);
 
 #else /* CONFIG_SYSVIPC */
Index: linux-2.6.26-rc8-mm1-MSGMNB3/ipc/ipc_sysctl.c
===================================================================
--- linux-2.6.26-rc8-mm1-MSGMNB3.orig/ipc/ipc_sysctl.c
+++ linux-2.6.26-rc8-mm1-MSGMNB3/ipc/ipc_sysctl.c
@@ -50,6 +50,22 @@ static void ipc_auto_callback(int val)
 	}
 }
 
+static void ipc_auto_callback_msgmnb(int val)
+{
+	struct ipc_namespace *ns = current->nsproxy->ipc_ns;
+	if (!val)
+		unregister_ipcns_notifier_msgmnb(ns);
+	else {
+		/*
+		 * Re-enable automatic recomputing only if not already
+		 * enabled.
+		 */
+		ipc_recompute_msgmnb(ns);
+		recompute_msgmni(ns);
+		cond_register_ipcns_notifier_msgmnb(ns);
+	}
+}
+
 #ifdef CONFIG_PROC_FS
 static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
@@ -73,14 +89,24 @@ static int proc_ipc_callback_dointvec(ct
 
 	rc = proc_dointvec(&ipc_table, write, filp, buffer, lenp, ppos);
 
-	if (write && !rc && lenp_bef == *lenp)
+	if (write && !rc && lenp_bef == *lenp) {
+		struct ipc_namespace *ns = current->nsproxy->ipc_ns;
 		/*
 		 * Tunable has successfully been changed by hand. Disable its
 		 * automatic adjustment. This simply requires unregistering
 		 * the notifiers that trigger recalculation.
 		 */
-		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
-
+		switch (table->ctl_name) {
+		case KERN_MSGMNI:
+			unregister_ipcns_notifier(ns);
+			break;
+		case KERN_MSGMNB:
+			unregister_ipcns_notifier_msgmnb(ns);
+			break;
+		default:
+			break;
+		}
+	}
 	return rc;
 }
 
@@ -123,6 +149,34 @@ static int proc_ipcauto_dointvec_minmax(
 	return rc;
 }
 
+static int proc_ipcauto_dointvec_minmax_msgmnb(ctl_table *table, int write,
+	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table ipc_table;
+	size_t lenp_bef = *lenp;
+	int oldval;
+	int rc;
+
+	memcpy(&ipc_table, table, sizeof(ipc_table));
+	ipc_table.data = get_ipc(table);
+	oldval = *((int *)(ipc_table.data));
+
+	rc = proc_dointvec_minmax(&ipc_table, write, filp, buffer, lenp, ppos);
+
+	if (write && !rc && lenp_bef == *lenp) {
+		int newval = *((int *)(ipc_table.data));
+		/*
+		 * The file "auto_msgmnb" has correctly been set.
+		 * React by (un)registering the corresponding tunable, if the
+		 * value has changed.
+		 */
+		if (newval != oldval)
+			ipc_auto_callback_msgmnb(newval);
+	}
+
+	return rc;
+}
+
 #else
 #define proc_ipc_doulongvec_minmax NULL
 #define proc_ipc_dointvec	   NULL
@@ -175,16 +229,25 @@ static int sysctl_ipc_registered_data(ct
 		void __user *newval, size_t newlen)
 {
 	int rc;
-
 	rc = sysctl_ipc_data(table, name, nlen, oldval, oldlenp, newval,
 		newlen);
 
-	if (newval && newlen && rc > 0)
+	if (newval && newlen && rc > 0) {
+		struct ipc_namespace *ns = current->nsproxy->ipc_ns;
 		/*
 		 * Tunable has successfully been changed from userland
 		 */
-		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
-
+		switch (table->ctl_name) {
+		case KERN_MSGMNI:
+			unregister_ipcns_notifier(ns);
+			break;
+		case KERN_MSGMNB:
+			unregister_ipcns_notifier_msgmnb(ns);
+			break;
+		default:
+			break;
+		}
+	}
 	return rc;
 }
 #else
@@ -269,6 +332,16 @@ static struct ctl_table ipc_kern_table[]
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "auto_msgmnb",
+		.data		= &init_ipc_ns.auto_msgmnb,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_ipcauto_dointvec_minmax_msgmnb,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 	{}
 };
 
Index: linux-2.6.26-rc8-mm1-MSGMNB3/ipc/ipcns_notifier.c
===================================================================
--- linux-2.6.26-rc8-mm1-MSGMNB3.orig/ipc/ipcns_notifier.c
+++ linux-2.6.26-rc8-mm1-MSGMNB3/ipc/ipcns_notifier.c
@@ -29,7 +29,8 @@ static int ipcns_callback(struct notifie
 	ns = container_of(self, struct ipc_namespace, ipcns_nb);
 	switch (action) {
 	case IPCNS_CPUCHANGED:
-		ipc_recompute_msgmnb(ns); /* Fall through */
+		if (ns->auto_msgmnb)
+			ipc_recompute_msgmnb(ns); /* Fall through */
 	case IPCNS_MEMCHANGED:   /* amount of lowmem has changed */
 	case IPCNS_CREATED:
 	case IPCNS_REMOVED:
@@ -42,7 +43,8 @@ static int ipcns_callback(struct notifie
 		 * blocking_notifier_call_chain.
 		 * So the ipc ns cannot be freed while we are here.
 		 */
-		recompute_msgmni(ns);
+		if (ns->auto_msgmni)
+			recompute_msgmni(ns);
 		break;
 	default:
 		break;
@@ -88,3 +90,59 @@ int ipcns_notify(unsigned long val)
 {
 	return blocking_notifier_call_chain(&ipcns_chain, val, NULL);
 }
+
+static int ipcns_callback_msgmnb(struct notifier_block *self,
+				unsigned long action, void *arg)
+{
+	struct ipc_namespace *ns;
+	ns = container_of(self, struct ipc_namespace, ipcns_nb_msgmnb);
+	switch (action) {
+	case IPCNS_CPUCHANGED:
+		if (ns->auto_msgmnb)
+			ipc_recompute_msgmnb(ns); /* Fall through */
+	case IPCNS_MEMCHANGED:
+	case IPCNS_CREATED:
+	case IPCNS_REMOVED:
+		if (ns->auto_msgmni)
+			recompute_msgmni(ns);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+int register_ipcns_notifier_msgmnb(struct ipc_namespace *ns)
+{
+	int rc;
+
+	memset(&ns->ipcns_nb_msgmnb, 0, sizeof(ns->ipcns_nb_msgmnb));
+	ns->ipcns_nb_msgmnb.notifier_call = ipcns_callback_msgmnb;
+	ns->ipcns_nb_msgmnb.priority = IPCNS_CALLBACK_PRI;
+	rc = blocking_notifier_chain_register(&ipcns_chain,
+					      &ns->ipcns_nb_msgmnb);
+	if (!rc)
+		ns->auto_msgmnb = 1;
+	return rc;
+}
+
+int cond_register_ipcns_notifier_msgmnb(struct ipc_namespace *ns)
+{
+	int rc;
+
+	memset(&ns->ipcns_nb_msgmnb, 0, sizeof(ns->ipcns_nb_msgmnb));
+	ns->ipcns_nb_msgmnb.notifier_call = ipcns_callback_msgmnb;
+	ns->ipcns_nb_msgmnb.priority = IPCNS_CALLBACK_PRI;
+	rc = blocking_notifier_chain_cond_register(&ipcns_chain,
+							&ns->ipcns_nb_msgmnb);
+	if (!rc)
+		ns->auto_msgmnb = 1;
+	return rc;
+}
+
+void unregister_ipcns_notifier_msgmnb(struct ipc_namespace *ns)
+{
+	blocking_notifier_chain_unregister(&ipcns_chain, &ns->ipcns_nb_msgmnb);
+	ns->auto_msgmnb = 0;
+}
Index: linux-2.6.26-rc8-mm1-MSGMNB3/ipc/namespace.c
===================================================================
--- linux-2.6.26-rc8-mm1-MSGMNB3.orig/ipc/namespace.c
+++ linux-2.6.26-rc8-mm1-MSGMNB3/ipc/namespace.c
@@ -26,6 +26,7 @@ static struct ipc_namespace *clone_ipc_n
 	msg_init_ns(ns);
 	shm_init_ns(ns);
 
+	register_ipcns_notifier_msgmnb(ns);
 	/*
 	 * msgmni has already been computed for the new ipc ns.
 	 * Thus, do the ipcns creation notification before registering that
@@ -98,6 +99,7 @@ void free_ipc_ns(struct kref *kref)
 	 * released the rd lock.
 	 */
 	unregister_ipcns_notifier(ns);
+	unregister_ipcns_notifier_msgmnb(ns);
 	sem_exit_ns(ns);
 	msg_exit_ns(ns);
 	shm_exit_ns(ns);
Index: linux-2.6.26-rc8-mm1-MSGMNB3/ipc/util.c
===================================================================
--- linux-2.6.26-rc8-mm1-MSGMNB3.orig/ipc/util.c
+++ linux-2.6.26-rc8-mm1-MSGMNB3/ipc/util.c
@@ -141,6 +141,7 @@ static int __init ipc_init(void)
 	hotplug_memory_notifier(ipc_memory_callback, IPC_CALLBACK_PRI);
 	hotcpu_notifier(ipc_cpu_callback, IPC_CALLBACK_PRI);
 	register_ipcns_notifier(&init_ipc_ns);
+	register_ipcns_notifier_msgmnb(&init_ipc_ns);
 	return 0;
 }
 __initcall(ipc_init);
Index: linux-2.6.26-rc8-mm1-MSGMNB3/Documentation/sysctl/kernel.txt
===================================================================
--- linux-2.6.26-rc8-mm1-MSGMNB3.orig/Documentation/sysctl/kernel.txt
+++ linux-2.6.26-rc8-mm1-MSGMNB3/Documentation/sysctl/kernel.txt
@@ -179,6 +179,41 @@ kernel stack.
 
 ==============================================================
 
+msgmnb
+
+Maximum size in bytes, not in message count, of a single SystemV IPC
+message queue (b stands for bytes).
+
+This value is dynamic and depends on the online cpu count of the
+machine (taking cpu hotplug into account).
+
+Computed values are between MSGMNB and MSGMNB*MSG_CPU_SCALE #define
+constants (currently [16384,65536]).
+
+The exact value is automatically (re)computed, but:
+
+. If the value is positioned from user space (via procfs or sysctl()),
+  then the automatic recomputation is disabled. E.g.:
+
+  # echo 16384 > /proc/sys/kernel/msgmnb
+
+. The automatic recomputation can also be disabled via auto_msgmnb,
+  e.g.:
+
+  # echo 0 > /proc/sys/kernel/auto_msgmnb
+
+. When disabled, the automatic recomputation can be reenabled via
+  auto_msgmnb, e.g.:
+
+  # echo 1 > /proc/sys/kernel/auto_msgmnb
+
+The msgmnb and auto_msgmnb values in each (ipc) namespace are
+independent.
+
+Initially, the msgmnb value is computed automatically: at boot time
+and (ipc) namespace creation.
+
+==============================================================
 osrelease, ostype & version:
 
 # cat osrelease

-- 
