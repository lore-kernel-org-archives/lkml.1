Return-Path: <linux-kernel-owner+w=401wt.eu-S1762678AbXHVJEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678AbXHVJEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbXHVIxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:37 -0400
Received: from 1wt.eu ([62.212.114.60]:2119 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758698AbXHVIxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:34 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084030.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:24 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 40/58] do not limit locked memory when RLIMIT_MEMLOCK is RLIM_INFINITY
Content-Disposition: inline; filename=0040-do-not-limit-locked-memory-when-RLIMIT_MEMLOCK-is-RL.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug in mm/mlock.c on 32-bit architectures that prevents a user from
locking more than 4GB of shared memory, or allocating more than 4GB of
shared memory in hugepages, when rlim[RLIMIT_MEMLOCK] is set to
RLIM_INFINITY.

Signed-off-by: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
Acked-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 mm/mlock.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 3446b7e..ef8fc94 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -233,9 +233,12 @@ int user_shm_lock(size_t size, struct user_struct *user)
 
 	locked = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+	if (lock_limit == RLIM_INFINITY)
+		allowed = 1;
 	lock_limit >>= PAGE_SHIFT;
 	spin_lock(&shmlock_user_lock);
-	if (locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
+	if (!allowed &&
+	    locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
 		goto out;
 	get_uid(user);
 	user->locked_shm += locked;
-- 
1.5.2.5

-- 
