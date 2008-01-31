Return-Path: <linux-kernel-owner+w=401wt.eu-S934341AbYAaN6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934341AbYAaN6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933916AbYAaNzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:55:39 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59467 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933868AbYAaNzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:55:35 -0500
Message-Id: <20080131135357.082657000@bull.net>
References: <20080131134018.273154000@bull.net>
User-Agent: quilt/0.45-1
Date: Thu, 31 Jan 2008 14:40:25 +0100
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com,
       akpm@linux-foundation.org
Cc: linux-mm@kvack.org, containers@lists.linux-foundation.org,
       matthltc@us.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC][PATCH v2 7/7] Do not recompute msgmni anymore if explicitely set by user
Content-Disposition: inline; filename=ipc_unregister_callback_on_msgmni_manual_change.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 07/07]

This patch makes msgmni not recomputed anymore upon ipc namespace creation /
removal or memory add/remove, as soon as it has been set from userland.

As soon as msgmni is explicitely set via procfs or sysctl(), the associated
callback routine is unregistered from the ipc namespace notifier chain.


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 ipc/ipc_sysctl.c |   43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

Index: linux-2.6.24/ipc/ipc_sysctl.c
===================================================================
--- linux-2.6.24.orig/ipc/ipc_sysctl.c	2008-01-29 16:55:04.000000000 +0100
+++ linux-2.6.24/ipc/ipc_sysctl.c	2008-01-31 13:13:14.000000000 +0100
@@ -34,6 +34,24 @@ static int proc_ipc_dointvec(ctl_table *
 	return proc_dointvec(&ipc_table, write, filp, buffer, lenp, ppos);
 }
 
+static int proc_ipc_callback_dointvec(ctl_table *table, int write,
+	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	size_t lenp_bef = *lenp;
+	int rc;
+
+	rc = proc_ipc_dointvec(table, write, filp, buffer, lenp, ppos);
+
+	if (write && !rc && lenp_bef == *lenp)
+		/*
+		 * Tunable has successfully been changed from userland:
+		 * disable its automatic recomputing.
+		 */
+		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
+
+	return rc;
+}
+
 static int proc_ipc_doulongvec_minmax(ctl_table *table, int write,
 	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -48,6 +66,7 @@ static int proc_ipc_doulongvec_minmax(ct
 #else
 #define proc_ipc_doulongvec_minmax NULL
 #define proc_ipc_dointvec	   NULL
+#define proc_ipc_callback_dointvec NULL
 #endif
 
 #ifdef CONFIG_SYSCTL_SYSCALL
@@ -89,8 +108,28 @@ static int sysctl_ipc_data(ctl_table *ta
 	}
 	return 1;
 }
+
+static int sysctl_ipc_registered_data(ctl_table *table, int __user *name,
+		int nlen, void __user *oldval, size_t __user *oldlenp,
+		void __user *newval, size_t newlen)
+{
+	int rc;
+
+	rc = sysctl_ipc_data(table, name, nlen, oldval, oldlenp, newval,
+		newlen);
+
+	if (newval && newlen && rc > 0)
+		/*
+		 * Tunable has successfully been changed from userland:
+		 * disable its automatic recomputing.
+		 */
+		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
+
+	return rc;
+}
 #else
 #define sysctl_ipc_data NULL
+#define sysctl_ipc_registered_data NULL
 #endif
 
 static struct ctl_table ipc_kern_table[] = {
@@ -136,8 +175,8 @@ static struct ctl_table ipc_kern_table[]
 		.data		= &init_ipc_ns.msg_ctlmni,
 		.maxlen		= sizeof (init_ipc_ns.msg_ctlmni),
 		.mode		= 0644,
-		.proc_handler	= proc_ipc_dointvec,
-		.strategy	= sysctl_ipc_data,
+		.proc_handler	= proc_ipc_callback_dointvec,
+		.strategy	= sysctl_ipc_registered_data,
 	},
 	{
 		.ctl_name	= KERN_MSGMNB,

--
