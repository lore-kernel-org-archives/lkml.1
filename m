Return-Path: <linux-kernel-owner+w=401wt.eu-S1764804AbYFFGTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764804AbYFFGTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764525AbYFFGRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:17:46 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59294 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764496AbYFFGRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:17:45 -0400
Message-Id: <20080606060958.710882773@bull.net>
References: <20080606060955.317871352@bull.net>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 08:10:00 +0200
From: <Solofo.Ramangalahy@bull.net>
To: <linux-kernel@vger.kernel.org>
Cc: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
Subject: [RFC -mm 5/6] sysv ipc: deconnect msgmnb and msgmni deactivation and
 reactivation
Content-Disposition: inline;
 filename=ipc-deconnect-msgmni-msgmnb-deactivation-reactivation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

The msgmnb and msgmni values are coupled for deactivation and
reactivation of value computation.

The uncoupling of msgmn{b,i} for deactivation/reactivation of
recomputation adds flexibility and testability.

. Flexibility was discussed during the msgmni series development and
  ended up with reactivation by negative value on /proc.

. Testability allows to experiment with the automatic computation of
  msgmn{b,i} values. For example, if current algorithm does not fit
  application needs.


Signed-off-by: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

---
 include/linux/ipc_namespace.h |    3 +-
 ipc/ipc_sysctl.c              |   45 ++++++++++++++++++++++++++++++++----------
 ipc/ipcns_notifier.c          |    9 --------
 ipc/msg.c                     |    6 +++++
 4 files changed, 43 insertions(+), 20 deletions(-)

Index: b/include/linux/ipc_namespace.h
===================================================================
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -34,7 +34,9 @@ struct ipc_namespace {
 
 	int		msg_ctlmax;
 	int		msg_ctlmnb;
+	bool		msg_ctlmnb_activated; /* recompute_msgmnb activation */
 	int		msg_ctlmni;
+	bool		msg_ctlmni_activated; /* recompute_msgmni activation */
 	atomic_t	msg_bytes;
 	atomic_t	msg_hdrs;
 
@@ -53,7 +55,6 @@ extern atomic_t nr_ipc_ns;
 #define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
 
 extern int register_ipcns_notifier(struct ipc_namespace *);
-extern int cond_register_ipcns_notifier(struct ipc_namespace *);
 extern int unregister_ipcns_notifier(struct ipc_namespace *);
 extern int ipcns_notify(unsigned long);
 
Index: b/ipc/msg.c
===================================================================
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -91,6 +91,8 @@ void recompute_msgmni(struct ipc_namespa
 	unsigned long allowed;
 	int nb_ns;
 
+	if (!ns->msg_ctlmni_activated)
+		return;
 	si_meminfo(&i);
 	allowed = (((i.totalram - i.totalhigh) / MSG_MEM_SCALE) * i.mem_unit)
 		/ ns->msg_ctlmnb;
@@ -116,6 +118,8 @@ void recompute_msgmni(struct ipc_namespa
  */
 void recompute_msgmnb(struct ipc_namespace *ns)
 {
+	if (!ns->msg_ctlmnb_activated)
+		return;
 	ns->msg_ctlmnb =
 		min(MSGMNB * num_online_cpus(), MSGMNB * MSG_CPU_SCALE);
 }
@@ -123,6 +127,8 @@ void recompute_msgmnb(struct ipc_namespa
 void msg_init_ns(struct ipc_namespace *ns)
 {
 	ns->msg_ctlmax = MSGMAX;
+	ns->msg_ctlmnb_activated = true;
+	ns->msg_ctlmni_activated = true;
 	recompute_msgmnb(ns);
 
 	recompute_msgmni(ns);
Index: b/ipc/ipc_sysctl.c
===================================================================
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -33,18 +33,42 @@ static void *get_ipc(ctl_table *table)
  * add/remove or ipc namespace creation/removal.
  * They can come back to a recomputable state by being set to a <0 value.
  */
-static void tunable_set_callback(int val)
+static void tunable_set_callback(int val, ctl_table *table)
 {
-	if (val >= 0)
-		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
-	else {
+	int tunable = table->ctl_name;
+
+	if (val >= 0) {
+		switch (tunable) {
+		case KERN_MSGMNB:
+			current->nsproxy->ipc_ns->msg_ctlmnb_activated = false;
+			break;
+		case KERN_MSGMNI:
+			current->nsproxy->ipc_ns->msg_ctlmni_activated = false;
+			break;
+		default:
+			printk(KERN_ERR "ipc: unexpected value %s\n",
+			       table->procname);
+			break;
+		}
+	} else {
 		/*
 		 * Re-enable automatic recomputing only if not already
 		 * enabled.
 		 */
-		recompute_msgmnb(current->nsproxy->ipc_ns);
-		recompute_msgmni(current->nsproxy->ipc_ns);
-		cond_register_ipcns_notifier(current->nsproxy->ipc_ns);
+		switch (tunable) {
+		case KERN_MSGMNB:
+			current->nsproxy->ipc_ns->msg_ctlmnb_activated = true;
+			recompute_msgmnb(current->nsproxy->ipc_ns);
+							/* fall through */
+		case KERN_MSGMNI:
+			current->nsproxy->ipc_ns->msg_ctlmni_activated = true;
+			recompute_msgmni(current->nsproxy->ipc_ns);
+			break;
+		default:
+			printk(KERN_ERR "ipc: unexpected value %s\n",
+			       table->procname);
+			break;
+		}
 	}
 }
 
@@ -72,7 +96,8 @@ static int proc_ipc_callback_dointvec(ct
 	rc = proc_dointvec(&ipc_table, write, filp, buffer, lenp, ppos);
 
 	if (write && !rc && lenp_bef == *lenp)
-		tunable_set_callback(*((int *)(ipc_table.data)));
+		BUG_ON(table == NULL);
+		tunable_set_callback(*((int *)(ipc_table.data)), table);
 
 	return rc;
 }
@@ -148,8 +173,8 @@ static int sysctl_ipc_registered_data(ct
 		 * Tunable has successfully been changed from userland
 		 */
 		int *data = get_ipc(table);
-
-		tunable_set_callback(*data);
+		BUG_ON(table == NULL);
+		tunable_set_callback(*data, table);
 	}
 
 	return rc;
Index: b/ipc/ipcns_notifier.c
===================================================================
--- a/ipc/ipcns_notifier.c
+++ b/ipc/ipcns_notifier.c
@@ -65,15 +65,6 @@ int register_ipcns_notifier(struct ipc_n
 	return blocking_notifier_chain_register(&ipcns_chain, &ns->ipcns_nb);
 }
 
-int cond_register_ipcns_notifier(struct ipc_namespace *ns)
-{
-	memset(&ns->ipcns_nb, 0, sizeof(ns->ipcns_nb));
-	ns->ipcns_nb.notifier_call = ipcns_callback;
-	ns->ipcns_nb.priority = IPCNS_CALLBACK_PRI;
-	return blocking_notifier_chain_cond_register(&ipcns_chain,
-							&ns->ipcns_nb);
-}
-
 int unregister_ipcns_notifier(struct ipc_namespace *ns)
 {
 	return blocking_notifier_chain_unregister(&ipcns_chain,

-- 
Solofo Ramangalahy
Bull SA.
