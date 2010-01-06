Return-Path: <linux-kernel-owner+w=401wt.eu-S932259Ab0AFP0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab0AFP0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 10:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932241Ab0AFPZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 10:25:41 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:40245 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab0AFPZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 10:25:00 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ipc: use helpers for rlimits
Date: Wed,  6 Jan 2010 16:24:39 +0100
Message-Id: <1262791479-26594-11-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <1262791479-26594-1-git-send-email-jslaby@suse.cz>
References: <1262791479-26594-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

I.e. either use rlimit helpers added in
3e10e716abf3c71bdb5d86b8f507f9e72236c9cd
or ACCESS_ONCE if not applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 ipc/mqueue.c                                   |    2 +-
 ipc/shm.c                                      |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index c79bd57..6c97934 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -152,7 +152,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 			spin_lock(&mq_lock);
 			if (u->mq_bytes + mq_bytes < u->mq_bytes ||
 		 	    u->mq_bytes + mq_bytes >
-			    p->signal->rlim[RLIMIT_MSGQUEUE].rlim_cur) {
+			    task_rlimit(p, RLIMIT_MSGQUEUE)) {
 				spin_unlock(&mq_lock);
 				goto out_inode;
 			}
diff --git a/ipc/shm.c b/ipc/shm.c
index 92fe923..784438d 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -761,8 +761,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 			if (euid != shp->shm_perm.uid &&
 			    euid != shp->shm_perm.cuid)
 				goto out_unlock;
-			if (cmd == SHM_LOCK &&
-			    !current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur)
+			if (cmd == SHM_LOCK && !rlimit(RLIMIT_MEMLOCK))
 				goto out_unlock;
 		}
 
-- 
1.6.5.7

