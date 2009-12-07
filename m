Return-Path: <linux-kernel-owner+w=401wt.eu-S934449AbZLGAbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934449AbZLGAbr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934504AbZLGAbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:31:42 -0500
Received: from kroah.org ([198.145.64.141]:34326 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758374AbZLGAMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:55 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:46 2009
Message-Id: <20091207000646.180789285@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Jan Kara <jack@ucw.cz>,
       Andrea Arcangeli <andrea@cpushare.com>, Serge Hallyn <serue@us.ibm.com>
Subject: [036/119] pidns: fix a leak in /proc dentries and inodes with pid namespaces.
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=pidns-fix-a-leak-in-proc-dentries-and-inodes-with-pid-namespaces.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

commit 29f12ca32122db98481150be09d35bd72b68045e upstream.

Daniel Lezcano reported a leak in 'struct pid' and 'struct pid_namespace'
that is discussed in:

	http://lkml.org/lkml/2009/10/2/159.

To summarize the thread, when container-init is terminated, it sets the
PF_EXITING flag, zaps other processes in the container and waits to reap
them.  As a part of reaping, the container-init should flush any /proc
dentries associated with the processes.  But because the container-init is
itself exiting and the following PF_EXITING check, the dentries are not
flushed, resulting in leak in /proc inodes and dentries.

This fix reverts the commit 7766755a2f249e7e0 ("Fix /proc dcache deadlock
in do_exit") which introduced the check for PF_EXITING.  At the time of
the commit, shrink_dcache_parent() flushed dentries from other filesystems
also and could have caused a deadlock which the commit fixed.  But as
pointed out by Eric Biederman, after commit 0feae5c47aabdde59,
shrink_dcache_parent() no longer affects other filesystems.  So reverting
the commit is now safe.

As pointed out by Jan Kara, the leak is not as critical since the
unclaimed space will be reclaimed under memory pressure or by:

	echo 3 > /proc/sys/vm/drop_caches

But since this check is no longer required, its best to remove it.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Reported-by: Daniel Lezcano <dlezcano@fr.ibm.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Jan Kara <jack@ucw.cz>
Cc: Andrea Arcangeli <andrea@cpushare.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/base.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2580,8 +2580,7 @@ static void proc_flush_task_mnt(struct v
 	name.len = snprintf(buf, sizeof(buf), "%d", pid);
 	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
 	if (dentry) {
-		if (!(current->flags & PF_EXITING))
-			shrink_dcache_parent(dentry);
+		shrink_dcache_parent(dentry);
 		d_drop(dentry);
 		dput(dentry);
 	}


