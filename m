Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488Ab0ANW2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab0ANW2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888Ab0ANW2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:28:39 -0500
Received: from kroah.org ([198.145.64.141]:60573 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab0ANW2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:36 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Dave Anderson <anderson@redhat.com>, Paul Menage <menage@google.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/52] cgroups: fix 2.6.32 regression causing BUG_ON() in cgroup_diput()
Date: Thu, 14 Jan 2010 14:27:01 -0800
Message-Id: <1263508051-7868-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-21-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Anderson <anderson@redhat.com>

commit bd4f490a079730aadfaf9a728303ea0135c01945 upstream.

The LTP cgroup test suite generates a "kernel BUG at kernel/cgroup.c:790!"
here in cgroup_diput():

                 /*
                  * if we're getting rid of the cgroup, refcount should ensure
                  * that there are no pidlists left.
                  */
                 BUG_ON(!list_empty(&cgrp->pidlists));

The cgroup pidlist rework in 2.6.32 generates the BUG_ON, which is caused
when pidlist_array_load() calls cgroup_pidlist_find():

(1) if a matching cgroup_pidlist is found, it down_write's the mutex of the
     pre-existing cgroup_pidlist, and increments its use_count.
(2) if no matching cgroup_pidlist is found, then a new one is allocated, it
     down_write's its mutex, and the use_count is set to 0.
(3) the matching, or new, cgroup_pidlist gets returned back to pidlist_array_load(),
     which increments its use_count -- regardless whether new or pre-existing --
     and up_write's the mutex.

So if a matching list is ever encountered by cgroup_pidlist_find() during
the life of a cgroup directory, it results in an inflated use_count value,
preventing it from ever getting released by cgroup_release_pid_array().
Then if the directory is subsequently removed, cgroup_diput() hits the
BUG_ON() when it finds that the directory's cgroup is still populated with
a pidlist.

The patch simply removes the use_count increment when a matching pidlist
is found by cgroup_pidlist_find(), because it gets bumped by the calling
pidlist_array_load() function while still protected by the list's mutex.

Signed-off-by: Dave Anderson <anderson@redhat.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Ben Blum <bblum@andrew.cmu.edu>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/cgroup.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0249f4b..1fbcc74 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2468,7 +2468,6 @@ static struct cgroup_pidlist *cgroup_pidlist_find(struct cgroup *cgrp,
 			/* make sure l doesn't vanish out from under us */
 			down_write(&l->mutex);
 			mutex_unlock(&cgrp->pidlist_mutex);
-			l->use_count++;
 			return l;
 		}
 	}
-- 
1.6.6

