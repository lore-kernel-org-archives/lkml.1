Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYGDXz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYGDXz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 19:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYGDXzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 19:55:12 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:42503 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbYGDXzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:55:09 -0400
Message-Id: <20080704235424.823519262@polymtl.ca>
References: <20080704235207.147809973@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 19:52:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Subject: [RFC patch 03/12] LTTng instrumentation ipc
Content-Disposition: inline; filename=lttng-instrumentation-ipc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri,  4 Jul 2008 23:54:25 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interprocess communication, core events.

Added tracepoints :

ipc_msg_create
ipc_sem_create
ipc_shm_create

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
---
 ipc/ipc-trace.h |   15 +++++++++++++++
 ipc/msg.c       |    6 +++++-
 ipc/sem.c       |    6 +++++-
 ipc/shm.c       |    6 +++++-
 4 files changed, 30 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/ipc/msg.c
===================================================================
--- linux-2.6-lttng.orig/ipc/msg.c	2008-07-03 12:45:36.000000000 -0400
+++ linux-2.6-lttng/ipc/msg.c	2008-07-03 12:47:14.000000000 -0400
@@ -38,6 +38,7 @@
 #include <linux/rwsem.h>
 #include <linux/nsproxy.h>
 #include <linux/ipc_namespace.h>
+#include "ipc-trace.h"
 
 #include <asm/current.h>
 #include <asm/uaccess.h>
@@ -314,6 +315,7 @@ asmlinkage long sys_msgget(key_t key, in
 	struct ipc_namespace *ns;
 	struct ipc_ops msg_ops;
 	struct ipc_params msg_params;
+	long ret;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -324,7 +326,9 @@ asmlinkage long sys_msgget(key_t key, in
 	msg_params.key = key;
 	msg_params.flg = msgflg;
 
-	return ipcget(ns, &msg_ids(ns), &msg_ops, &msg_params);
+	ret = ipcget(ns, &msg_ids(ns), &msg_ops, &msg_params);
+	trace_ipc_msg_create(ret, msgflg);
+	return ret;
 }
 
 static inline unsigned long
Index: linux-2.6-lttng/ipc/sem.c
===================================================================
--- linux-2.6-lttng.orig/ipc/sem.c	2008-07-03 12:45:36.000000000 -0400
+++ linux-2.6-lttng/ipc/sem.c	2008-07-03 12:47:14.000000000 -0400
@@ -83,6 +83,7 @@
 #include <linux/rwsem.h>
 #include <linux/nsproxy.h>
 #include <linux/ipc_namespace.h>
+#include "ipc-trace.h"
 
 #include <asm/uaccess.h>
 #include "util.h"
@@ -314,6 +315,7 @@ asmlinkage long sys_semget(key_t key, in
 	struct ipc_namespace *ns;
 	struct ipc_ops sem_ops;
 	struct ipc_params sem_params;
+	long err;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -328,7 +330,9 @@ asmlinkage long sys_semget(key_t key, in
 	sem_params.flg = semflg;
 	sem_params.u.nsems = nsems;
 
-	return ipcget(ns, &sem_ids(ns), &sem_ops, &sem_params);
+	err = ipcget(ns, &sem_ids(ns), &sem_ops, &sem_params);
+	trace_ipc_sem_create(err, semflg);
+	return err;
 }
 
 /* Manage the doubly linked list sma->sem_pending as a FIFO:
Index: linux-2.6-lttng/ipc/shm.c
===================================================================
--- linux-2.6-lttng.orig/ipc/shm.c	2008-07-03 12:45:36.000000000 -0400
+++ linux-2.6-lttng/ipc/shm.c	2008-07-03 12:47:14.000000000 -0400
@@ -39,6 +39,7 @@
 #include <linux/nsproxy.h>
 #include <linux/mount.h>
 #include <linux/ipc_namespace.h>
+#include "ipc-trace.h"
 
 #include <asm/uaccess.h>
 
@@ -460,6 +461,7 @@ asmlinkage long sys_shmget (key_t key, s
 	struct ipc_namespace *ns;
 	struct ipc_ops shm_ops;
 	struct ipc_params shm_params;
+	long err;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -471,7 +473,9 @@ asmlinkage long sys_shmget (key_t key, s
 	shm_params.flg = shmflg;
 	shm_params.u.size = size;
 
-	return ipcget(ns, &shm_ids(ns), &shm_ops, &shm_params);
+	err = ipcget(ns, &shm_ids(ns), &shm_ops, &shm_params);
+	trace_ipc_shm_create(err, shmflg);
+	return err;
 }
 
 static inline unsigned long copy_shmid_to_user(void __user *buf, struct shmid64_ds *in, int version)
Index: linux-2.6-lttng/ipc/ipc-trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/ipc/ipc-trace.h	2008-07-03 12:47:14.000000000 -0400
@@ -0,0 +1,15 @@
+#ifndef _IPC_TRACE_H
+#define _IPC_TRACE_H
+
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(ipc_msg_create,
+	TPPROTO(long id, int flags),
+	TPARGS(id, flags));
+DEFINE_TRACE(ipc_sem_create,
+	TPPROTO(long id, int flags),
+	TPARGS(id, flags));
+DEFINE_TRACE(ipc_shm_create,
+	TPPROTO(long id, int flags),
+	TPARGS(id, flags));
+#endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
