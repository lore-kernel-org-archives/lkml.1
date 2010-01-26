Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195Ab0AZT3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab0AZT3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185Ab0AZT3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:29:51 -0500
Received: from kroah.org ([198.145.64.141]:33625 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087Ab0AZT3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:29:06 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 11:16:25 2010
Message-Id: <20100126191625.055697697@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 11:14:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Serge E. Hallyn" <serue@us.ibm.com>, Nick Piggin <npiggin@suse.de>
Subject: [10/11] ipc ns: fix memory leak (idr)
In-Reply-To: <20100126191730.GA20872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -100,6 +100,7 @@ static void do_shm_rmid(struct ipc_names
 void shm_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &shm_ids(ns), do_shm_rmid);
+	idr_destroy(&ns->ids[IPC_SHM_IDS].ipcs_idr);
 }
 #endif
 


