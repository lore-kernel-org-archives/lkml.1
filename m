Return-Path: <linux-kernel-owner+w=401wt.eu-S936300AbXHGVFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936300AbXHGVFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935693AbXHGUwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:52:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56465 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935692AbXHGUwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:52:38 -0400
Date: Tue, 7 Aug 2007 13:45:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, xemul@openvz.org
Subject: [2.6.22.2 review 37/84] Fix user struct leakage with locked IPC
	shem segment
Message-ID: <20070807204558.GM23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-user-struct-leakage-with-locked-ipc-shem-segment.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Pavel Emelianov <xemul@openvz.org>

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

---
 ipc/shm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -716,7 +716,7 @@ asmlinkage long sys_shmctl (int shmid, i
 			struct user_struct * user = current->user;
 			if (!is_file_hugepages(shp->shm_file)) {
 				err = shmem_lock(shp->shm_file, 1, user);
-				if (!err) {
+				if (!err && !(shp->shm_perm.mode & SHM_LOCKED)){
 					shp->shm_perm.mode |= SHM_LOCKED;
 					shp->mlock_user = user;
 				}

-- 
