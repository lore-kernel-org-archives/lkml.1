Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbXLKPfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbXLKPfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbXLKPfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:35:06 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44584 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbXLKPfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:35:04 -0500
Message-Id: <20071211154144.523501000@bull.net>
References: <20071211153845.766147000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 11 Dec 2007 16:38:47 +0100
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: matthltc@us.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC PATCH 2/2] Scaling msgmni to the number of ipc namespaces
Content-Disposition: inline; filename=ipc_scale_msgmni_with_namespaces.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 02/02]

Since all the namespaces see the same amount of memory (the total one)
this patch introduces a new variable that counts the ipc namespaces and divides
msg_ctlmni by this counter.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/ipc.h |    1 +
 ipc/msg.c           |    6 +++++-
 ipc/util.c          |    6 ++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc4/include/linux/ipc.h
===================================================================
--- linux-2.6.24-rc4.orig/include/linux/ipc.h	2007-12-11 11:57:53.000000000 +0100
+++ linux-2.6.24-rc4/include/linux/ipc.h	2007-12-11 12:34:53.000000000 +0100
@@ -121,6 +121,7 @@ struct ipc_namespace {
 };
 
 extern struct ipc_namespace init_ipc_ns;
+extern atomic_t nr_ipc_ns;
 
 #ifdef CONFIG_SYSVIPC
 #define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
Index: linux-2.6.24-rc4/ipc/util.c
===================================================================
--- linux-2.6.24-rc4.orig/ipc/util.c	2007-12-11 11:57:58.000000000 +0100
+++ linux-2.6.24-rc4/ipc/util.c	2007-12-11 12:36:32.000000000 +0100
@@ -51,6 +51,8 @@ struct ipc_namespace init_ipc_ns = {
 	},
 };
 
+atomic_t nr_ipc_ns = ATOMIC_INIT(1);
+
 static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
 {
 	int err;
@@ -61,6 +63,8 @@ static struct ipc_namespace *clone_ipc_n
 	if (ns == NULL)
 		goto err_mem;
 
+	atomic_inc(&nr_ipc_ns);
+
 	err = sem_init_ns(ns);
 	if (err)
 		goto err_sem;
@@ -80,6 +84,7 @@ err_msg:
 	sem_exit_ns(ns);
 err_sem:
 	kfree(ns);
+	atomic_dec(&nr_ipc_ns);
 err_mem:
 	return ERR_PTR(err);
 }
@@ -109,6 +114,7 @@ void free_ipc_ns(struct kref *kref)
 	msg_exit_ns(ns);
 	shm_exit_ns(ns);
 	kfree(ns);
+	atomic_dec(&nr_ipc_ns);
 }
 
 /**
Index: linux-2.6.24-rc4/ipc/msg.c
===================================================================
--- linux-2.6.24-rc4.orig/ipc/msg.c	2007-12-11 12:12:32.000000000 +0100
+++ linux-2.6.24-rc4/ipc/msg.c	2007-12-11 14:20:28.000000000 +0100
@@ -84,6 +84,7 @@ static void __msg_init_ns(struct ipc_nam
 {
 	struct sysinfo i;
 	unsigned long allowed;
+	int nb_ns;
 
 	ns->ids[IPC_MSG_IDS] = ids;
 	ns->msg_ctlmax = MSGMAX;
@@ -95,10 +96,13 @@ static void __msg_init_ns(struct ipc_nam
 	 * up to 8MB       : msgmni = 16 (MSGMNI)
 	 * 4 GB            : msgmni = 8K
 	 * more than 16 GB : msgmni = 32K (IPCMNI)
+	 * Also take into account the number of nsproxies created so far.
 	 */
 	si_meminfo(&i);
 	allowed = ((i.totalram / MSG_MEM_SCALE) * i.mem_unit) / MSGMNB;
-	ns->msg_ctlmni = min((unsigned long) IPCMNI,
+	nb_ns = atomic_read(&nr_ipc_ns);
+	allowed /= nb_ns;
+	ns->msg_ctlmni = min((unsigned long) (IPCMNI / nb_ns),
 			max((unsigned long) MSGMNI, allowed));
 
 	atomic_set(&ns->msg_bytes, 0);

--
