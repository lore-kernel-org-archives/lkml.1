Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbXKMTmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbXKMTmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759128AbXKMTlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:41:17 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:47670 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760743AbXKMTlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:41:12 -0500
Message-Id: <20071113194024.523591895@polymtl.ca>
References: <20071113193349.214098508@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 14:33:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC 3/7] LTTng instrumentation ipc
Content-Disposition: inline; filename=lttng-instrumentation-ipc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 19:40:25 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Interprocess communication, core events.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 ipc/msg.c |    5 ++++-
 ipc/sem.c |    5 ++++-
 ipc/shm.c |    5 ++++-
 3 files changed, 12 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/ipc/msg.c
===================================================================
--- linux-2.6-lttng.orig/ipc/msg.c	2007-11-13 09:49:27.000000000 -0500
+++ linux-2.6-lttng/ipc/msg.c	2007-11-13 09:49:31.000000000 -0500
@@ -315,6 +315,7 @@ asmlinkage long sys_msgget(key_t key, in
 	struct ipc_namespace *ns;
 	struct ipc_ops msg_ops;
 	struct ipc_params msg_params;
+	long ret;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -325,7 +326,9 @@ asmlinkage long sys_msgget(key_t key, in
 	msg_params.key = key;
 	msg_params.flg = msgflg;
 
-	return ipcget(ns, &msg_ids(ns), &msg_ops, &msg_params);
+	ret = ipcget(ns, &msg_ids(ns), &msg_ops, &msg_params);
+	trace_mark(ipc_msg_create, "id %ld flags %d", ret, msgflg);
+	return ret;
 }
 
 static inline unsigned long
Index: linux-2.6-lttng/ipc/sem.c
===================================================================
--- linux-2.6-lttng.orig/ipc/sem.c	2007-11-13 09:49:27.000000000 -0500
+++ linux-2.6-lttng/ipc/sem.c	2007-11-13 09:49:31.000000000 -0500
@@ -334,6 +334,7 @@ asmlinkage long sys_semget(key_t key, in
 	struct ipc_namespace *ns;
 	struct ipc_ops sem_ops;
 	struct ipc_params sem_params;
+	long err;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -348,7 +349,9 @@ asmlinkage long sys_semget(key_t key, in
 	sem_params.flg = semflg;
 	sem_params.u.nsems = nsems;
 
-	return ipcget(ns, &sem_ids(ns), &sem_ops, &sem_params);
+	err = ipcget(ns, &sem_ids(ns), &sem_ops, &sem_params);
+	trace_mark(ipc_sem_create, "id %ld flags %d", err, semflg);
+	return err;
 }
 
 /* Manage the doubly linked list sma->sem_pending as a FIFO:
Index: linux-2.6-lttng/ipc/shm.c
===================================================================
--- linux-2.6-lttng.orig/ipc/shm.c	2007-11-13 09:49:27.000000000 -0500
+++ linux-2.6-lttng/ipc/shm.c	2007-11-13 09:49:31.000000000 -0500
@@ -497,6 +497,7 @@ asmlinkage long sys_shmget (key_t key, s
 	struct ipc_namespace *ns;
 	struct ipc_ops shm_ops;
 	struct ipc_params shm_params;
+	long err;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -508,7 +509,9 @@ asmlinkage long sys_shmget (key_t key, s
 	shm_params.flg = shmflg;
 	shm_params.u.size = size;
 
-	return ipcget(ns, &shm_ids(ns), &shm_ops, &shm_params);
+	err = ipcget(ns, &shm_ids(ns), &shm_ops, &shm_params);
+	trace_mark(ipc_shm_create, "id %ld flags %d", err, shmflg);
+	return err;
 }
 
 static inline unsigned long copy_shmid_to_user(void __user *buf, struct shmid64_ds *in, int version)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
