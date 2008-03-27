Return-Path: <linux-kernel-owner+w=401wt.eu-S1760641AbYC0Nbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641AbYC0Nbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758723AbYC0NaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:30:23 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45325 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758093AbYC0NaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:30:20 -0400
Message-Id: <20080327133013.575499799@polymtl.ca>
References: <20080327132057.449831367@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 27 Mar 2008 09:21:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch for 2.6.26 3/7] LTTng instrumentation ipc
Content-Disposition: inline; filename=lttng-instrumentation-ipc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 27 Mar 2008 13:30:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interprocess communication, core events.

Added markers :

ipc_msg_create
ipc_sem_create
ipc_shm_create

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 ipc/msg.c |    6 +++++-
 ipc/sem.c |    6 +++++-
 ipc/shm.c |    6 +++++-
 3 files changed, 15 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/ipc/msg.c
===================================================================
--- linux-2.6-lttng.orig/ipc/msg.c	2008-03-27 07:40:09.000000000 -0400
+++ linux-2.6-lttng/ipc/msg.c	2008-03-27 07:40:12.000000000 -0400
@@ -37,6 +37,7 @@
 #include <linux/rwsem.h>
 #include <linux/nsproxy.h>
 #include <linux/ipc_namespace.h>
+#include <linux/marker.h>
 
 #include <asm/current.h>
 #include <asm/uaccess.h>
@@ -293,6 +294,7 @@ asmlinkage long sys_msgget(key_t key, in
 	struct ipc_namespace *ns;
 	struct ipc_ops msg_ops;
 	struct ipc_params msg_params;
+	long ret;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -303,7 +305,9 @@ asmlinkage long sys_msgget(key_t key, in
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
--- linux-2.6-lttng.orig/ipc/sem.c	2008-03-27 07:40:09.000000000 -0400
+++ linux-2.6-lttng/ipc/sem.c	2008-03-27 07:40:12.000000000 -0400
@@ -83,6 +83,7 @@
 #include <linux/rwsem.h>
 #include <linux/nsproxy.h>
 #include <linux/ipc_namespace.h>
+#include <linux/marker.h>
 
 #include <asm/uaccess.h>
 #include "util.h"
@@ -312,6 +313,7 @@ asmlinkage long sys_semget(key_t key, in
 	struct ipc_namespace *ns;
 	struct ipc_ops sem_ops;
 	struct ipc_params sem_params;
+	long err;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -326,7 +328,9 @@ asmlinkage long sys_semget(key_t key, in
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
--- linux-2.6-lttng.orig/ipc/shm.c	2008-03-27 07:40:09.000000000 -0400
+++ linux-2.6-lttng/ipc/shm.c	2008-03-27 07:40:12.000000000 -0400
@@ -39,6 +39,7 @@
 #include <linux/nsproxy.h>
 #include <linux/mount.h>
 #include <linux/ipc_namespace.h>
+#include <linux/marker.h>
 
 #include <asm/uaccess.h>
 
@@ -482,6 +483,7 @@ asmlinkage long sys_shmget (key_t key, s
 	struct ipc_namespace *ns;
 	struct ipc_ops shm_ops;
 	struct ipc_params shm_params;
+	long err;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -493,7 +495,9 @@ asmlinkage long sys_shmget (key_t key, s
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
