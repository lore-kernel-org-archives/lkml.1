Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbYANP6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbYANP6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYANP5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:57:51 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43392 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbYANP5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:57:49 -0500
Message-Id: <20080114155602.000415000@bull.net>
References: <20080114155402.690906000@bull.net>
User-Agent: quilt/0.45-1
Date: Mon, 14 Jan 2008 16:54:04 +0100
From: Nadia.Derbey@bull.net
To: akmp@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, matthltc@us.ibm.com,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC PATCH 2/4] [RESEND] Scaling msgmni to the number of ipc namespaces
Content-Disposition: inline; filename=ipc_scale_msgmni_with_namespaces.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 02/04]

Since all the namespaces see the same amount of memory (the total one)
this patch introduces a new variable that counts the ipc namespaces and
divides msg_ctlmni by this counter.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/ipc.h |    1 +
 ipc/msg.c           |    8 ++++++--
 ipc/util.c          |    7 +++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

Index: linux-2.6.24-rc7/include/linux/ipc.h
===================================================================
--- linux-2.6.24-rc7.orig/include/linux/ipc.h	2008-01-11 15:50:21.000000000 +0100
+++ linux-2.6.24-rc7/include/linux/ipc.h	2008-01-11 16:00:50.000000000 +0100
@@ -121,6 +121,7 @@ struct ipc_namespace {
 };
 
 extern struct ipc_namespace init_ipc_ns;
+extern atomic_t nr_ipc_ns;
 
 #ifdef CONFIG_SYSVIPC
 #define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
Index: linux-2.6.24-rc7/ipc/util.c
===================================================================
--- linux-2.6.24-rc7.orig/ipc/util.c	2008-01-11 15:50:21.000000000 +0100
+++ linux-2.6.24-rc7/ipc/util.c	2008-01-11 16:12:38.000000000 +0100
@@ -51,6 +51,9 @@ struct ipc_namespace init_ipc_ns = {
 	},
 };
 
+atomic_t nr_ipc_ns = ATOMIC_INIT(1);
+
+
 static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
 {
 	int err;
@@ -61,6 +64,8 @@ static struct ipc_namespace *clone_ipc_n
 	if (ns == NULL)
 		goto err_mem;
 
+	atomic_inc(&nr_ipc_ns);
+
 	err = sem_init_ns(ns);
 	if (err)
 		goto err_sem;
@@ -80,6 +85,7 @@ err_msg:
 	sem_exit_ns(ns);
 err_sem:
 	kfree(ns);
+	atomic_dec(&nr_ipc_ns);
 err_mem:
 	return ERR_PTR(err);
 }
@@ -109,6 +115,7 @@ void free_ipc_ns(struct kref *kref)
 	msg_exit_ns(ns);
 	shm_exit_ns(ns);
 	kfree(ns);
+	atomic_dec(&nr_ipc_ns);
 }
 
 /**
Index: linux-2.6.24-rc7/ipc/msg.c
===================================================================
--- linux-2.6.24-rc7.orig/ipc/msg.c	2008-01-11 15:51:00.000000000 +0100
+++ linux-2.6.24-rc7/ipc/msg.c	2008-01-11 16:08:32.000000000 +0100
@@ -83,15 +83,19 @@ static int sysvipc_msg_proc_show(struct 
 /*
  * Scale msgmni with the available lowmem size: the memory dedicated to msg
  * queues should occupy at most 1/MSG_MEM_SCALE of lowmem.
+ * Also take into account the number of nsproxies created so far.
  */
 static void recompute_msgmni(struct ipc_namespace *ns)
 {
 	struct sysinfo i;
 	unsigned long allowed;
+	int nb_ns;
 
 	si_meminfo(&i);
 	allowed = (((i.totalram - i.totalhigh) / MSG_MEM_SCALE) * i.mem_unit)
 		/ MSGMNB;
+	nb_ns = atomic_read(&nr_ipc_ns);
+	allowed /= nb_ns;
 
 	/*
 	 * Never fall under the current minimum value
@@ -104,8 +108,8 @@ static void recompute_msgmni(struct ipc_
 	/*
 	 * Never go over the current max value
 	 */
-	if (allowed > IPCMNI) {
-		ns->msg_ctlmni = IPCMNI;
+	if (allowed > IPCMNI / nb_ns) {
+		ns->msg_ctlmni = IPCMNI / nb_ns;
 		goto out_callback;
 	}
 

--
