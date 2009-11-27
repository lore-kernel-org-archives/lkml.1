Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbZK0XGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbZK0XGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbZK0XGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:06:14 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60459 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbZK0XGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: [PATCH v3 23/27] misc: use helpers for rlimits
Date: Sat, 28 Nov 2009 00:06:03 +0100
Message-Id: <1259363167-9347-23-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

I.e. either use newly added rlimit helpers or ACCESS_ONCE if not
applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/core/umem.c                 |    2 +-
 drivers/infiniband/hw/ipath/ipath_user_pages.c |    3 +--
 ipc/mqueue.c                                   |    2 +-
 ipc/shm.c                                      |    3 +--
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 6f7c096..2a8338a 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -136,7 +136,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	down_write(&current->mm->mmap_sem);
 
 	locked     = npages + current->mm->locked_vm;
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+	lock_limit = rlim_get_cur(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 
 	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
 		ret = -ENOMEM;
diff --git a/drivers/infiniband/hw/ipath/ipath_user_pages.c b/drivers/infiniband/hw/ipath/ipath_user_pages.c
index 82878e3..431ec61 100644
--- a/drivers/infiniband/hw/ipath/ipath_user_pages.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_pages.c
@@ -59,8 +59,7 @@ static int __get_user_pages(unsigned long start_page, size_t num_pages,
 	size_t got;
 	int ret;
 
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >>
-		PAGE_SHIFT;
+	lock_limit = rlim_get_cur(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 
 	if (num_pages > lock_limit) {
 		ret = -ENOMEM;
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index ee9d697..0e18cde 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -153,7 +153,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 			spin_lock(&mq_lock);
 			if (u->mq_bytes + mq_bytes < u->mq_bytes ||
 		 	    u->mq_bytes + mq_bytes >
-			    p->signal->rlim[RLIMIT_MSGQUEUE].rlim_cur) {
+			    task_rlim_get_cur(p, RLIMIT_MSGQUEUE)) {
 				spin_unlock(&mq_lock);
 				goto out_inode;
 			}
diff --git a/ipc/shm.c b/ipc/shm.c
index 464694e..abd1ebd 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -761,8 +761,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 			if (euid != shp->shm_perm.uid &&
 			    euid != shp->shm_perm.cuid)
 				goto out_unlock;
-			if (cmd == SHM_LOCK &&
-			    !current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur)
+			if (cmd == SHM_LOCK && !rlim_get_cur(RLIMIT_MEMLOCK))
 				goto out_unlock;
 		}
 
-- 
1.6.5.3

