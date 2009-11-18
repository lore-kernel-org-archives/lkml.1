Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbZKROyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbZKROyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbZKROxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:53:49 -0500
Received: from server1.wserver.cz ([82.113.45.157]:51279 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbZKROwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:52:00 -0500
From: Jiri Slaby <jslaby@novell.com>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org,
       Jiri Slaby <jslaby@novell.com>, James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 11/16] misc: use ACCESS_ONCE for rlimits
Date: Wed, 18 Nov 2009 15:51:57 +0100
Message-Id: <1258555922-2064-11-git-send-email-jslaby@novell.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <4B040A03.2020508@gmail.com>
References: <4B040A03.2020508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

Signed-off-by: Jiri Slaby <jslaby@novell.com>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/core/umem.c                 |    3 ++-
 drivers/infiniband/hw/ipath/ipath_user_pages.c |    4 ++--
 ipc/mqueue.c                                   |    4 ++--
 ipc/shm.c                                      |    4 ++--
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 6f7c096..90d806b 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -136,7 +136,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	down_write(&current->mm->mmap_sem);
 
 	locked     = npages + current->mm->locked_vm;
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+	lock_limit = ACCESS_ONCE(current->signal->
+			rlim[RLIMIT_MEMLOCK].rlim_cur) >> PAGE_SHIFT;
 
 	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
 		ret = -ENOMEM;
diff --git a/drivers/infiniband/hw/ipath/ipath_user_pages.c b/drivers/infiniband/hw/ipath/ipath_user_pages.c
index 82878e3..f7db156 100644
--- a/drivers/infiniband/hw/ipath/ipath_user_pages.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_pages.c
@@ -59,8 +59,8 @@ static int __get_user_pages(unsigned long start_page, size_t num_pages,
 	size_t got;
 	int ret;
 
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >>
-		PAGE_SHIFT;
+	lock_limit = ACCESS_ONCE(current->signal->
+			rlim[RLIMIT_MEMLOCK].rlim_cur) >> PAGE_SHIFT;
 
 	if (num_pages > lock_limit) {
 		ret = -ENOMEM;
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index ee9d697..d04869f 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -152,8 +152,8 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 
 			spin_lock(&mq_lock);
 			if (u->mq_bytes + mq_bytes < u->mq_bytes ||
-		 	    u->mq_bytes + mq_bytes >
-			    p->signal->rlim[RLIMIT_MSGQUEUE].rlim_cur) {
+			    u->mq_bytes + mq_bytes > ACCESS_ONCE(p->signal->
+			    rlim[RLIMIT_MSGQUEUE].rlim_cur)) {
 				spin_unlock(&mq_lock);
 				goto out_inode;
 			}
diff --git a/ipc/shm.c b/ipc/shm.c
index 464694e..99de87c 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -761,8 +761,8 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 			if (euid != shp->shm_perm.uid &&
 			    euid != shp->shm_perm.cuid)
 				goto out_unlock;
-			if (cmd == SHM_LOCK &&
-			    !current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur)
+			if (cmd == SHM_LOCK && !ACCESS_ONCE(current->signal->
+					rlim[RLIMIT_MEMLOCK].rlim_cur))
 				goto out_unlock;
 		}
 
-- 
1.6.4.2

