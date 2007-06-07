Return-Path: <linux-kernel-owner+w=401wt.eu-S933613AbXFGQxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613AbXFGQxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762368AbXFGQvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:51:22 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46480 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762042AbXFGQvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:51:20 -0400
Message-Id: <20070607165557.513597000@bull.net>
References: <20070607165302.917616000@bull.net>
User-Agent: quilt/0.45-1
Date: Thu, 07 Jun 2007 18:53:08 +0200
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, ak@suse.de, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC][PATCH 6/6] Introducing msg_findkey() sem_findkey() and shm_findkey()
Content-Disposition: inline; filename=ipc_findkey.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 06/06]


This is a trivial patch that changes all the calls to casted ipc_findkey()
into calls to static inline routines that do the cast themselves.


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>


---
 ipc/msg.c |    8 +++++++-
 ipc/sem.c |    8 +++++++-
 ipc/shm.c |    8 +++++++-
 3 files changed, 21 insertions(+), 3 deletions(-)

Index: linux-2.6.21/ipc/msg.c
===================================================================
--- linux-2.6.21.orig/ipc/msg.c	2007-06-07 15:18:32.000000000 +0200
+++ linux-2.6.21/ipc/msg.c	2007-06-07 15:43:24.000000000 +0200
@@ -153,6 +153,12 @@ static inline struct msg_queue *msg_lock
 	return (struct msg_queue *) ipc_lock(&msg_ids(ns), id, chk);
 }
 
+static inline struct msg_queue *msg_findkey(struct ipc_namespace *ns,
+						key_t key)
+{
+	return (struct msg_queue *) ipc_findkey(&msg_ids(ns), key);
+}
+
 static inline void msg_rmid(struct ipc_namespace *ns, struct msg_queue *s)
 {
 	ipc_rmid(&msg_ids(ns), &s->q_perm);
@@ -286,7 +292,7 @@ asmlinkage long sys_msgget(key_t key, in
 	if (key == IPC_PRIVATE) 
 		ret = newque(ns, key, msgflg);
 	else  {
-		msq = (struct msg_queue *) ipc_findkey(&msg_ids(ns), key);
+		msq = msg_findkey(ns, key);
 		if (msq == NULL) {
 			/* key not used */
 			if (!(msgflg & IPC_CREAT))
Index: linux-2.6.21/ipc/sem.c
===================================================================
--- linux-2.6.21.orig/ipc/sem.c	2007-06-07 15:19:21.000000000 +0200
+++ linux-2.6.21/ipc/sem.c	2007-06-07 15:45:11.000000000 +0200
@@ -192,6 +192,12 @@ static inline struct sem_array *sem_lock
 	return (struct sem_array *) ipc_lock(&sem_ids(ns), id, chk);
 }
 
+static inline struct sem_array *sem_findkey(struct ipc_namespace *ns,
+						key_t key)
+{
+	return (struct sem_array *) ipc_findkey(&sem_ids(ns), key);
+}
+
 static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
 {
 	ipc_rmid(&sem_ids(ns), &s->sem_perm);
@@ -295,7 +301,7 @@ asmlinkage long sys_semget (key_t key, i
 	if (key == IPC_PRIVATE) {
 		err = newary(ns, key, nsems, semflg);
 	} else {
-		sma = (struct sem_array *) ipc_findkey(&sem_ids(ns), key);
+		sma = sem_findkey(ns, key);
 		if (sma == NULL) {
 			/* key not used */
 			if (!(semflg & IPC_CREAT))
Index: linux-2.6.21/ipc/shm.c
===================================================================
--- linux-2.6.21.orig/ipc/shm.c	2007-06-07 15:20:20.000000000 +0200
+++ linux-2.6.21/ipc/shm.c	2007-06-07 15:46:40.000000000 +0200
@@ -155,6 +155,12 @@ static inline struct shmid_kernel *shm_l
 	return (struct shmid_kernel *) ipc_lock(&shm_ids(ns), id, chk);
 }
 
+static inline struct shmid_kernel *shm_findkey(struct ipc_namespace *ns,
+						key_t key)
+{
+	return (struct shmid_kernel *) ipc_findkey(&shm_ids(ns), key);
+}
+
 static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
 {
 	ipc_rmid(&shm_ids(ns), &s->shm_perm);
@@ -430,7 +436,7 @@ asmlinkage long sys_shmget (key_t key, s
 	if (key == IPC_PRIVATE) {
 		err = newseg(ns, key, shmflg, size);
 	} else {
-		shp = (struct shmid_kernel *) ipc_findkey(&shm_ids(ns), key);
+		shp = shm_findkey(ns, key);
 		if (shp == NULL) {
 			if (!(shmflg & IPC_CREAT))
 				err = -ENOENT;

--
