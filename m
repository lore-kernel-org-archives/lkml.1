Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbXJWPjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbXJWPjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXJWPi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:38:57 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50022 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbXJWPi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:38:56 -0400
Date: Tue, 23 Oct 2007 17:38:37 +0200
From: Pierre Peiffer <pierre.peiffer@bull.net>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] IPC: fix error check in all new xxx_lock()  and
 xxx_exit_ns() functions
Message-Id: <20071023173837.27445e26.pierre.peiffer@bull.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 23/10/2007 17:45:31,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 23/10/2007 17:45:32,
	Serialize complete at 23/10/2007 17:45:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend of a patch sent few days (or weeks) ago.
It has been updated with some more corrections.

In the new implementation of the [sem|shm|msg]_lock[_check]() routines,
we use the return value of ipc_lock() in container_of() without any check.
But ipc_lock may return a errcode. The use of this errcode in container_of()
may alter this errcode, and we don't want this.

And in xxx_exit_ns, the pointer return by idr_find is of type 'struct kern_ipc_per'...

Today, the code will work as is because the member used in these container_of()
is the first member of its container (offset == 0), the errcode isn't changed
then. But in the general case, we can't count on this assumption and this
may lead later to a real bug if we don't correct this.

Again, the proposed solution is simple and correct. But, as pointed by Nadia, with this
solution, the same check will be done several times (in all sub-callers...), what is not
very funny/optimal...

That's why I send this as RFC.
Comments or other proposals are welcome, but there are some corrections to do anyway.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>

---
 ipc/msg.c |   17 ++++++++++++++---
 ipc/sem.c |   17 ++++++++++++++---
 ipc/shm.c |   20 +++++++++++++++++---
 3 files changed, 45 insertions(+), 9 deletions(-)

Index: b/ipc/msg.c
===================================================================
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -106,6 +106,7 @@ int msg_init_ns(struct ipc_namespace *ns
 void msg_exit_ns(struct ipc_namespace *ns)
 {
 	struct msg_queue *msq;
+	struct kern_ipc_perm *perm;
 	int next_id;
 	int total, in_use;
 
@@ -114,10 +115,11 @@ void msg_exit_ns(struct ipc_namespace *n
 	in_use = msg_ids(ns).in_use;
 
 	for (total = 0, next_id = 0; total < in_use; next_id++) {
-		msq = idr_find(&msg_ids(ns).ipcs_idr, next_id);
-		if (msq == NULL)
+		perm = idr_find(&msg_ids(ns).ipcs_idr, next_id);
+		if (perm == NULL)
 			continue;
-		ipc_lock_by_ptr(&msq->q_perm);
+		ipc_lock_by_ptr(perm);
+		msq = container_of(perm, struct msg_queue, q_perm);
 		freeque(ns, msq);
 		total++;
 	}
@@ -145,6 +147,9 @@ static inline struct msg_queue *msg_lock
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_check_down(&msg_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct msg_queue *)ipcp;
+
 	return container_of(ipcp, struct msg_queue, q_perm);
 }
 
@@ -156,6 +161,9 @@ static inline struct msg_queue *msg_lock
 {
 	struct kern_ipc_perm *ipcp = ipc_lock(&msg_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct msg_queue *)ipcp;
+
 	return container_of(ipcp, struct msg_queue, q_perm);
 }
 
@@ -164,6 +172,9 @@ static inline struct msg_queue *msg_lock
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_check(&msg_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct msg_queue *)ipcp;
+
 	return container_of(ipcp, struct msg_queue, q_perm);
 }
 
Index: b/ipc/sem.c
===================================================================
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -143,6 +143,7 @@ int sem_init_ns(struct ipc_namespace *ns
 void sem_exit_ns(struct ipc_namespace *ns)
 {
 	struct sem_array *sma;
+	struct kern_ipc_perm *perm;
 	int next_id;
 	int total, in_use;
 
@@ -151,10 +152,11 @@ void sem_exit_ns(struct ipc_namespace *n
 	in_use = sem_ids(ns).in_use;
 
 	for (total = 0, next_id = 0; total < in_use; next_id++) {
-		sma = idr_find(&sem_ids(ns).ipcs_idr, next_id);
-		if (sma == NULL)
+		perm = idr_find(&sem_ids(ns).ipcs_idr, next_id);
+		if (perm == NULL)
 			continue;
-		ipc_lock_by_ptr(&sma->sem_perm);
+		ipc_lock_by_ptr(perm);
+		sma = container_of(perm, struct sem_array, sem_perm);
 		freeary(ns, sma);
 		total++;
 	}
@@ -181,6 +183,9 @@ static inline struct sem_array *sem_lock
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_check_down(&sem_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct sem_array *)ipcp;
+
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
@@ -192,6 +197,9 @@ static inline struct sem_array *sem_lock
 {
 	struct kern_ipc_perm *ipcp = ipc_lock(&sem_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct sem_array *)ipcp;
+
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
@@ -200,6 +208,9 @@ static inline struct sem_array *sem_lock
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_check(&sem_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct sem_array *)ipcp;
+
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
Index: b/ipc/shm.c
===================================================================
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -111,6 +111,7 @@ int shm_init_ns(struct ipc_namespace *ns
 void shm_exit_ns(struct ipc_namespace *ns)
 {
 	struct shmid_kernel *shp;
+	struct kern_ipc_perm *perm;
 	int next_id;
 	int total, in_use;
 
@@ -119,10 +120,11 @@ void shm_exit_ns(struct ipc_namespace *n
 	in_use = shm_ids(ns).in_use;
 
 	for (total = 0, next_id = 0; total < in_use; next_id++) {
-		shp = idr_find(&shm_ids(ns).ipcs_idr, next_id);
-		if (shp == NULL)
+		perm = idr_find(&shm_ids(ns).ipcs_idr, next_id);
+		if (perm == NULL)
 			continue;
-		ipc_lock_by_ptr(&shp->shm_perm);
+		ipc_lock_by_ptr(perm);
+		shp = container_of(perm, struct shmid_kernel, shm_perm);
 		do_shm_rmid(ns, shp);
 		total++;
 	}
@@ -149,6 +151,9 @@ static inline struct shmid_kernel *shm_l
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_down(&shm_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct shmid_kernel *)ipcp;
+
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 
@@ -158,6 +163,9 @@ static inline struct shmid_kernel *shm_l
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_check_down(&shm_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct shmid_kernel *)ipcp;
+
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 
@@ -169,6 +177,9 @@ static inline struct shmid_kernel *shm_l
 {
 	struct kern_ipc_perm *ipcp = ipc_lock(&shm_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct shmid_kernel *)ipcp;
+
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 
@@ -177,6 +188,9 @@ static inline struct shmid_kernel *shm_l
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_check(&shm_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct shmid_kernel *)ipcp;
+
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 

-- 
Pierre Peiffer
