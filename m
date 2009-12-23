Return-Path: <linux-kernel-owner+w=401wt.eu-S1751576AbZLWSsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbZLWSsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 13:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbZLWSsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 13:48:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbZLWSsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 13:48:51 -0500
Message-ID: <4B32660A.8070106@redhat.com>
Date: Wed, 23 Dec 2009 13:48:42 -0500
From: Dave Anderson <anderson@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080515)
MIME-Version: 1.0
To: menage@google.com
CC: linux-kernel@vger.kernel.org, bblum@andrew.cmu.edu, lizf@cn.fujitsu.com
Subject: [PATCH] cgroups: fix 2.6.32 regression causing BUG_ON() in cgroup_diput()
Content-Type: multipart/mixed;
 boundary="------------060609040107020901060603"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060609040107020901060603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


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
BUG_ON() when it finds that the directory's cgroup is still populated
with a pidlist.

The patch simply removes the use_count increment when a matching
pidlist is found by cgroup_pidlist_find(), because it gets bumped by
the calling pidlist_array_load() function while still protected by the
list's mutex.

Signed-off-by: Dave Anderson <anderson@redhat.com>

---



--------------060609040107020901060603
Content-Type: text/x-patch;
 name="cgroup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cgroup.patch"

--- linux-2.6-git/kernel/cgroup.c.orig
+++ linux-2.6-git/kernel/cgroup.c
@@ -2468,7 +2468,6 @@ static struct cgroup_pidlist *cgroup_pid
 			/* make sure l doesn't vanish out from under us */
 			down_write(&l->mutex);
 			mutex_unlock(&cgrp->pidlist_mutex);
-			l->use_count++;
 			return l;
 		}
 	}

--------------060609040107020901060603--
