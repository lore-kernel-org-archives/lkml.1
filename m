Return-Path: <linux-kernel-owner+w=401wt.eu-S1765316AbYEBIkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765316AbYEBIkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 04:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758152AbYEBIkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 04:40:04 -0400
Received: from gustav.zipernowsky.hu ([193.225.20.248]:35545 "EHLO
	gustav.zipernowsky.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbYEBIkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 04:40:03 -0400
MIME-Version: 1.0
Date: Fri, 02 May 2008 10:40:00 +0200
From: <oliver@zipernowsky.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [OP] fix-dnotify_close-race.patch added to queue-2.6.22.23-op1
Reply-To: oliver.pntr@gmail.com
Message-ID: <4fe831fbd9276f5f1af605ce258cd649@zipernowsky.hu>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your patch added to queue-2.6.22.23-op1.
If anyone has any objections, please let us know.

http://repo.or.cz/w/linux-2.6.22.y-op-patches.git
git://repo.or.cz/linux-2.6.22.y-op-patches.git

---

>From 214b7049a7929f03bbd2786aaef04b8b79db34e2 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Thu, 1 May 2008 03:52:22 +0100
Subject: [PATCH] Fix dnotify/close race

We have a race between fcntl() and close() that can lead to
dnotify_struct inserted into inode's list *after* the last descriptor
had been gone from current->files.

Since that's the only point where dnotify_struct gets evicted, we are
screwed - it will stick around indefinitely.  Even after struct file in
question is gone and freed.  Worse, we can trigger send_sigio() on it at
any later point, which allows to send an arbitrary signal to arbitrary
process if we manage to apply enough memory pressure to get the page
that used to host that struct file and fill it with the right pattern...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/dnotify.c b/fs/dnotify.c
index 28d01ed..eaecc4c 100644
--- a/fs/dnotify.c
+++ b/fs/dnotify.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
+#include <linux/file.h>
 
 int dir_notify_enable __read_mostly = 1;
 
@@ -66,6 +67,7 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned
long arg)
 	struct dnotify_struct **prev;
 	struct inode *inode;
 	fl_owner_t id = current->files;
+	struct file *f;
 	int error = 0;
 
 	if ((arg & ~DN_MULTISHOT) == 0) {
@@ -92,6 +94,15 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned
long arg)
 		prev = &odn->dn_next;
 	}
 
+	rcu_read_lock();
+	f = fcheck(fd);
+	rcu_read_unlock();
+	/* we'd lost the race with close(), sod off silently */
+	/* note that inode->i_lock prevents reordering problems
+	 * between accesses to descriptor table and ->i_dnotify */
+	if (f != filp)
+		goto out_free;
+
 	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
 	if (error)
 		goto out_free;


