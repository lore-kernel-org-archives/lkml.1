Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbYGDGkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbYGDGkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 02:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYGDGkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 02:40:23 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55814 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYGDGkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 02:40:22 -0400
Message-Id: <20080704063729.600339000@bull.net>
References: <20080704063715.300337000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 04 Jul 2008 08:37:16 +0200
From: Nadia.Derbey@bull.net
To: akpm@linux-foundation.org, matthltc@us.ibm.com
Cc: linux-kernel@vger.kernel.org, Solofo.Ramangalahy@bull.net,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 1/1] IPC - Do not use a negative value to re-enable msgmni automatic recomputing
Content-Disposition: inline; filename=auto_msgmni_proc_file.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending after fixing the issues pointed out by Matt.
Now applies to 2.6.26-rc8-mm1.

[PATCH 01/01]

This patch proposes an alternative to the "magical positive-versus-negative
number trick" Andrew complained about last week in
http://lkml.org/lkml/2008/6/24/418.

This had been introduced with the patches that scale msgmni to the amount of
lowmem. With these patches, msgmni has a registered notification routine
that recomputes msgmni value upon memory add/remove or ipc namespace creation/
removal.

When msgmni is changed from user space (i.e. value written to the proc file),
that notification routine is unregistered, and the way to make it registered
back is to write a negative value into the proc file. This is the "magical
positive-versus-negative number trick".

To fix this, a new proc file is introduced: /proc/sys/kernel/auto_msgmni.
This file acts as ON/OFF for msgmni automatic recomputing.

With this patch, the process is the following:
1) kernel boots in "automatic recomputing mode"
   /proc/sys/kernel/msgmni contains the value that has been computed (depends
                           on lowmem)
   /proc/sys/kernel/automatic_msgmni contains "1"

2) echo <val> > /proc/sys/kernel/msgmni
   . sets msg_ctlmni to <val>
   . de-activates automatic recomputing (i.e. if, say, some memory is added
     msgmni won't be recomputed anymore)
   . /proc/sys/kernel/automatic_msgmni now contains "0"

3) echo "0" > /proc/sys/kernel/automatic_msgmni
   . de-activates msgmni automatic recomputing
     this has the same effect as 2) except that msg_ctlmni's value stays
     blocked at its current value)

3) echo "1" > /proc/sys/kernel/automatic_msgmni
   . recomputes msgmni's value based on the current available memory size
     and number of ipc namespaces
   . re-activates automatic recomputing for msgmni.

This patch applies to 2.6.26-rc8-mm1.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/ipc_namespace.h |    3 +
 ipc/ipc_sysctl.c              |   72 ++++++++++++++++++++++++++++++++++--------
 ipc/ipcns_notifier.c          |   20 ++++++++---
 3 files changed, 76 insertions(+), 19 deletions(-)

Index: linux-2.6.26-rc8-mm1/include/linux/ipc_namespace.h
===================================================================
--- linux-2.6.26-rc8-mm1.orig/include/linux/ipc_namespace.h	2008-07-03 16:10:39.000000000 +0200
+++ linux-2.6.26-rc8-mm1/include/linux/ipc_namespace.h	2008-07-04 08:10:50.000000000 +0200
@@ -36,6 +36,7 @@ struct ipc_namespace {
 	int		msg_ctlmni;
 	atomic_t	msg_bytes;
 	atomic_t	msg_hdrs;
+	int		auto_msgmni;
 
 	size_t		shm_ctlmax;
 	size_t		shm_ctlall;
@@ -53,7 +54,7 @@ extern atomic_t nr_ipc_ns;
 
 extern int register_ipcns_notifier(struct ipc_namespace *);
 extern int cond_register_ipcns_notifier(struct ipc_namespace *);
-extern int unregister_ipcns_notifier(struct ipc_namespace *);
+extern void unregister_ipcns_notifier(struct ipc_namespace *);
 extern int ipcns_notify(unsigned long);
 
 #else /* CONFIG_SYSVIPC */
Index: linux-2.6.26-rc8-mm1/ipc/ipcns_notifier.c
===================================================================
--- linux-2.6.26-rc8-mm1.orig/ipc/ipcns_notifier.c	2008-07-03 16:10:39.000000000 +0200
+++ linux-2.6.26-rc8-mm1/ipc/ipcns_notifier.c	2008-07-04 08:12:53.000000000 +0200
@@ -55,25 +55,35 @@ static int ipcns_callback(struct notifie
 
 int register_ipcns_notifier(struct ipc_namespace *ns)
 {
+	int rc;
+
 	memset(&ns->ipcns_nb, 0, sizeof(ns->ipcns_nb));
 	ns->ipcns_nb.notifier_call = ipcns_callback;
 	ns->ipcns_nb.priority = IPCNS_CALLBACK_PRI;
-	return blocking_notifier_chain_register(&ipcns_chain, &ns->ipcns_nb);
+	rc = blocking_notifier_chain_register(&ipcns_chain, &ns->ipcns_nb);
+	if (!rc)
+		ns->auto_msgmni = 1;
+	return rc;
 }
 
 int cond_register_ipcns_notifier(struct ipc_namespace *ns)
 {
+	int rc;
+
 	memset(&ns->ipcns_nb, 0, sizeof(ns->ipcns_nb));
 	ns->ipcns_nb.notifier_call = ipcns_callback;
 	ns->ipcns_nb.priority = IPCNS_CALLBACK_PRI;
-	return blocking_notifier_chain_cond_register(&ipcns_chain,
+	rc = blocking_notifier_chain_cond_register(&ipcns_chain,
 							&ns->ipcns_nb);
+	if (!rc)
+		ns->auto_msgmni = 1;
+	return rc;
 }
 
-int unregister_ipcns_notifier(struct ipc_namespace *ns)
+void unregister_ipcns_notifier(struct ipc_namespace *ns)
 {
-	return blocking_notifier_chain_unregister(&ipcns_chain,
-						&ns->ipcns_nb);
+	blocking_notifier_chain_unregister(&ipcns_chain, &ns->ipcns_nb);
+	ns->auto_msgmni = 0;
 }
 
 int ipcns_notify(unsigned long val)
Index: linux-2.6.26-rc8-mm1/ipc/ipc_sysctl.c
===================================================================
--- linux-2.6.26-rc8-mm1.orig/ipc/ipc_sysctl.c	2008-07-03 16:10:39.000000000 +0200
+++ linux-2.6.26-rc8-mm1/ipc/ipc_sysctl.c	2008-07-04 08:16:36.000000000 +0200
@@ -27,15 +27,17 @@ static void *get_ipc(ctl_table *table)
 }
 
 /*
- * Routine that is called when a tunable has successfully been changed by
- * hand and it has a callback routine registered on the ipc namespace notifier
- * chain: we don't want such tunables to be recomputed anymore upon memory
- * add/remove or ipc namespace creation/removal.
- * They can come back to a recomputable state by being set to a <0 value.
+ * Routine that is called when the file "auto_msgmni" has successfully been
+ * written.
+ * Two values are allowed:
+ * 0: unregister msgmni's callback routine from the ipc namespace notifier
+ *    chain. This means that msgmni won't be recomputed anymore upon memory
+ *    add/remove or ipc namespace creation/removal.
+ * 1: register back the callback routine.
  */
-static void tunable_set_callback(int val)
+static void ipc_auto_callback(int val)
 {
-	if (val >= 0)
+	if (!val)
 		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
 	else {
 		/*
@@ -71,7 +73,12 @@ static int proc_ipc_callback_dointvec(ct
 	rc = proc_dointvec(&ipc_table, write, filp, buffer, lenp, ppos);
 
 	if (write && !rc && lenp_bef == *lenp)
-		tunable_set_callback(*((int *)(ipc_table.data)));
+		/*
+		 * Tunable has successfully been changed by hand. Disable its
+		 * automatic adjustment. This simply requires unregistering
+		 * the notifiers that trigger recalculation.
+		 */
+		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
 
 	return rc;
 }
@@ -87,10 +94,39 @@ static int proc_ipc_doulongvec_minmax(ct
 					lenp, ppos);
 }
 
+static int proc_ipcauto_dointvec_minmax(ctl_table *table, int write,
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
+		 * The file "auto_msgmni" has correctly been set.
+		 * React by (un)registering the corresponding tunable, if the
+		 * value has changed.
+		 */
+		if (newval != oldval)
+			ipc_auto_callback(newval);
+	}
+
+	return rc;
+}
+
 #else
 #define proc_ipc_doulongvec_minmax NULL
 #define proc_ipc_dointvec	   NULL
 #define proc_ipc_callback_dointvec NULL
+#define proc_ipcauto_dointvec_minmax NULL
 #endif
 
 #ifdef CONFIG_SYSCTL_SYSCALL
@@ -142,14 +178,11 @@ static int sysctl_ipc_registered_data(ct
 	rc = sysctl_ipc_data(table, name, nlen, oldval, oldlenp, newval,
 		newlen);
 
-	if (newval && newlen && rc > 0) {
+	if (newval && newlen && rc > 0)
 		/*
 		 * Tunable has successfully been changed from userland
 		 */
-		int *data = get_ipc(table);
-
-		tunable_set_callback(*data);
-	}
+		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
 
 	return rc;
 }
@@ -158,6 +191,9 @@ static int sysctl_ipc_registered_data(ct
 #define sysctl_ipc_registered_data NULL
 #endif
 
+static int zero;
+static int one = 1;
+
 static struct ctl_table ipc_kern_table[] = {
 	{
 		.ctl_name	= KERN_SHMMAX,
@@ -222,6 +258,16 @@ static struct ctl_table ipc_kern_table[]
 		.proc_handler	= proc_ipc_dointvec,
 		.strategy	= sysctl_ipc_data,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "auto_msgmni",
+		.data		= &init_ipc_ns.auto_msgmni,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_ipcauto_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 	{}
 };
 

--
