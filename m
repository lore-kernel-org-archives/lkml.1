Return-Path: <linux-kernel-owner+w=401wt.eu-S1760956AbXGPMYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbXGPMYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbXGPMYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:24:24 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:23016 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbXGPMYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:24:23 -0400
Message-ID: <469B636C.3060007@openvz.org>
Date: Mon, 16 Jul 2007 16:24:12 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: devel@openvz.org
Subject: [PATCH] Fix user struct leakage with locked IPC shem segment
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When user locks an ipc shmem segmant with SHM_LOCK ctl and the
segment is already locked the shmem_lock() function returns 0. 
After this the subsequent code leaks the existing user struct:

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

---

--- ./ipc/shm.c.shlfix	2007-07-06 10:58:57.000000000 +0400
+++ ./ipc/shm.c	2007-07-16 16:12:34.000000000 +0400
@@ -715,7 +715,7 @@ asmlinkage long sys_shmctl (int shmid, i
 			struct user_struct * user = current->user;
 			if (!is_file_hugepages(shp->shm_file)) {
 				err = shmem_lock(shp->shm_file, 1, user);
-				if (!err) {
+				if (!err && !(shp->shm_perm.mode & SHM_LOCKED)){
 					shp->shm_perm.mode |= SHM_LOCKED;
 					shp->mlock_user = user;
 				}

