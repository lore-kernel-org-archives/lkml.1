Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbXJKIEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbXJKIEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 04:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbXJKIEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 04:04:02 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40655 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbXJKID7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 04:03:59 -0400
Date: Thu, 11 Oct 2007 10:03:48 +0200
From: Pierre Peiffer <Pierre.Peiffer@bull.net>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH -mm] IPC: fix error checking in all new xxx_lock()
 functions
Message-Id: <20071011100348.abc31218.Pierre.Peiffer@bull.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/10/2007 10:10:13,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/10/2007 10:10:15,
	Serialize complete at 11/10/2007 10:10:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In the new implementation of the [sem|shm|msg]_lock[_check]() routines,
we use the return value of ipc_lock() in container_of() without any check.
But ipc_lock may return a errcode. The use of this errcode in container_of()
may alter this errcode, and we don't want this.

Today, there is no problem because the member used in these container_of()
is the first member of its container (offset == 0), the errcode isn't changed
then. But in the general case, we can't count on this assumption and this
may lead later to a real bug if we don't correct this.

In fact, the proposed solution is simple and correct. But it has the drawback
of adding one more check ('if' statement) in the chain: we do a first check in
ipc_lock(), now in xxx_lock() and then one later in the caller of xxx_lock()
That's why I send this as RFC, may be another approach could be considered.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>

---
 ipc/msg.c |    6 ++++++
 ipc/sem.c |    6 ++++++
 ipc/shm.c |    6 ++++++
 3 files changed, 18 insertions(+)

Index: b/ipc/msg.c
===================================================================
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -140,6 +140,9 @@ static inline struct msg_queue *msg_lock
 {
 	struct kern_ipc_perm *ipcp = ipc_lock(&msg_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct msg_queue *)ipcp;
+
 	return container_of(ipcp, struct msg_queue, q_perm);
 }
 
@@ -148,6 +151,9 @@ static inline struct msg_queue *msg_lock
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
@@ -178,6 +178,9 @@ static inline struct sem_array *sem_lock
 {
 	struct kern_ipc_perm *ipcp = ipc_lock(&sem_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct sem_array *)ipcp;
+
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
@@ -186,6 +189,9 @@ static inline struct sem_array *sem_lock
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
@@ -145,6 +145,9 @@ static inline struct shmid_kernel *shm_l
 {
 	struct kern_ipc_perm *ipcp = ipc_lock(&shm_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct shmid_kernel *)ipcp;
+
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 
@@ -153,6 +156,9 @@ static inline struct shmid_kernel *shm_l
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_check(&shm_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct shmid_kernel *)ipcp;
+
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 


Pierre Peiffer
