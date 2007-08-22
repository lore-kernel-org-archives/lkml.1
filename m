Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbXHVI6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbXHVI6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbXHVIw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:57 -0400
Received: from 1wt.eu ([62.212.114.60]:1965 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758142AbXHVIw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:56 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084005.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:06 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 22/58] Fix user struct leakage with locked IPC shem segment
Content-Disposition: inline; filename=0022-Fix-user-struct-leakage-with-locked-IPC-shem-segment.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When user locks an ipc shmem segmant with SHM_LOCK ctl and the segment is
already locked the shmem_lock() function returns 0.  After this the
subsequent code leaks the existing user struct:

== ipc/shm.c: sys_shmctl() ==
     ...
     err = shmem_lock(shp->shm_file, 1, user);
     if (!err) {
          shp->shm_perm.mode |= SHM_LOCKED;
          shp->mlock_user = user;
     }
     ...
==

Other results of this are:
1. the new shp->mlock_user is not get-ed and will point to freed
   memory when the task dies.
2. the RLIMIT_MEMLOCK is screwed on both user structs.

The exploit looks like this:

==
    id = shmget(...);
    setresuid(uid, 0, 0);
    shmctl(id, SHM_LOCK, NULL);
    setresuid(uid + 1, 0, 0);
    shmctl(id, SHM_LOCK, NULL);
==

My solution is to return 0 to the userspace and do not change the
segment's user.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 ipc/shm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index f8e10a2..10b7a2c 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -652,7 +652,7 @@ asmlinkage long sys_shmctl (int shmid, int cmd, struct shmid_ds __user *buf)
 			struct user_struct * user = current->user;
 			if (!is_file_hugepages(shp->shm_file)) {
 				err = shmem_lock(shp->shm_file, 1, user);
-				if (!err) {
+				if (!err && !(shp->shm_perm.mode & SHM_LOCKED)){
 					shp->shm_perm.mode |= SHM_LOCKED;
 					shp->mlock_user = user;
 				}
-- 
1.5.2.5

-- 
