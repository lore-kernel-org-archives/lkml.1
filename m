Return-Path: <linux-kernel-owner+w=401wt.eu-S934702AbZJIW0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702AbZJIW0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 18:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934673AbZJIW0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 18:26:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37411 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934669AbZJIW0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 18:26:12 -0400
Date: Fri, 9 Oct 2009 17:25:31 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linux Containers <containers@lists.osdl.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH] ipc ns: fix memory leak (idr)
Message-ID: <20091009222531.GA8222@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have apparently had a memory leak since
7ca7e564e049d8b350ec9d958ff25eaa24226352
"ipc: store ipcs into IDRs" in 2007.  The idr of which 3
exist for each ipc namespace is never freed.

This patch simply frees them when the ipcns is freed.  I don't
believe any idr_remove() are done from rcu (and could therefore
be delayed until after this idr_destroy()), so the patch should
be safe.  Some quick testing showed no harm, and the memory
leak fixed.

Caught by kmemleak.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 ipc/msg.c |    1 +
 ipc/sem.c |    1 +
 ipc/shm.c |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 3559d53..861cc32 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -124,6 +124,7 @@ void msg_init_ns(struct ipc_namespace *ns)
 void msg_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &msg_ids(ns), freeque);
+	idr_destroy(&ns->ids[IPC_MSG_IDS].ipcs_idr);
 }
 #endif
 
diff --git a/ipc/sem.c b/ipc/sem.c
index 7361041..23ce7ec 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -128,6 +128,7 @@ void sem_init_ns(struct ipc_namespace *ns)
 void sem_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &sem_ids(ns), freeary);
+	idr_destroy(&ns->ids[IPC_SEM_IDS].ipcs_idr);
 }
 #endif
 
diff --git a/ipc/shm.c b/ipc/shm.c
index 26f9253..82ab773 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -102,6 +102,7 @@ void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 void shm_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &shm_ids(ns), do_shm_rmid);
+	idr_destroy(&ns->ids[IPC_SHM_IDS].ipcs_idr);
 }
 #endif
 
-- 
1.5.4.3

