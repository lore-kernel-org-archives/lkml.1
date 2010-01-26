Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078Ab0AZXtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab0AZXtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953Ab0AZXtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:49:19 -0500
Received: from kroah.org ([198.145.64.141]:35476 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab0AZXoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:10 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:31 2010
Message-Id: <20100126233931.104368551@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Serge E. Hallyn" <serue@us.ibm.com>, Nick Piggin <npiggin@suse.de>
Subject: [78/98] ipc ns: fix memory leak (idr)
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Serge E. Hallyn <serue@us.ibm.com>

commit 7d6feeb287c61aafa88f06345387b1188edf4b86 upstream.

We have apparently had a memory leak since
7ca7e564e049d8b350ec9d958ff25eaa24226352 "ipc: store ipcs into IDRs" in
2007.  The idr of which 3 exist for each ipc namespace is never freed.

This patch simply frees them when the ipcns is freed.  I don't believe any
idr_remove() are done from rcu (and could therefore be delayed until after
this idr_destroy()), so the patch should be safe.  Some quick testing
showed no harm, and the memory leak fixed.

Caught by kmemleak.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 ipc/msg.c |    1 +
 ipc/sem.c |    1 +
 ipc/shm.c |    1 +
 3 files changed, 3 insertions(+)

--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -125,6 +125,7 @@ void msg_init_ns(struct ipc_namespace *n
 void msg_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &msg_ids(ns), freeque);
+	idr_destroy(&ns->ids[IPC_MSG_IDS].ipcs_idr);
 }
 #endif
 
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -129,6 +129,7 @@ void sem_init_ns(struct ipc_namespace *n
 void sem_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &sem_ids(ns), freeary);
+	idr_destroy(&ns->ids[IPC_SEM_IDS].ipcs_idr);
 }
 #endif
 
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -101,6 +101,7 @@ static void do_shm_rmid(struct ipc_names
 void shm_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &shm_ids(ns), do_shm_rmid);
+	idr_destroy(&ns->ids[IPC_SHM_IDS].ipcs_idr);
 }
 #endif
 


