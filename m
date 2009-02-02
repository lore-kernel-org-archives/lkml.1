Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbZBBSVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbZBBSVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbZBBSUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:20:19 -0500
Received: from vena.lwn.net ([206.168.112.25]:53478 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbZBBSUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:20:14 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       linux-api@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/4] Convert epoll to a bitlock
Date: Mon,  2 Feb 2009 11:20:09 -0700
Message-Id: <1233598811-6871-3-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.6.1.1
In-Reply-To: <1233598811-6871-1-git-send-email-corbet@lwn.net>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall suggested converting epoll's ep_lock to a bitlock as a way of
saving space in struct file.  This patch makes that change.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 fs/eventpoll.c              |   13 ++++++++-----
 fs/fcntl.c                  |    2 +-
 include/asm-generic/fcntl.h |    4 ++++
 include/linux/eventpoll.h   |    2 +-
 include/linux/fs.h          |    1 -
 5 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index ba2f9ec..95fae01 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -25,6 +25,7 @@
 #include <linux/list.h>
 #include <linux/hash.h>
 #include <linux/spinlock.h>
+#include <linux/bit_spinlock.h>
 #include <linux/syscalls.h>
 #include <linux/rbtree.h>
 #include <linux/wait.h>
@@ -427,10 +428,10 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 	ep_unregister_pollwait(ep, epi);
 
 	/* Remove the current item from the list of epoll hooks */
-	spin_lock(&file->f_ep_lock);
+	bit_spin_lock(NR_EPOLL_FILE_LOCK, &file->f_flags);
 	if (ep_is_linked(&epi->fllink))
 		list_del_init(&epi->fllink);
-	spin_unlock(&file->f_ep_lock);
+	bit_spin_unlock(NR_EPOLL_FILE_LOCK, &file->f_flags);
 
 	rb_erase(&epi->rbn, &ep->rbr);
 
@@ -549,7 +550,7 @@ void eventpoll_release_file(struct file *file)
 	struct epitem *epi;
 
 	/*
-	 * We don't want to get "file->f_ep_lock" because it is not
+	 * We don't want to get EPOLL_FILE_LOCK because it is not
 	 * necessary. It is not necessary because we're in the "struct file"
 	 * cleanup path, and this means that noone is using this file anymore.
 	 * So, for example, epoll_ctl() cannot hit here sicne if we reach this
@@ -558,6 +559,8 @@ void eventpoll_release_file(struct file *file)
 	 * will correctly serialize the operation. We do need to acquire
 	 * "ep->mtx" after "epmutex" because ep_remove() requires it when called
 	 * from anywhere but ep_free().
+	 *
+	 * Besides, ep_remove() takes the lock.
 	 */
 	mutex_lock(&epmutex);
 
@@ -800,9 +803,9 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 		goto error_unregister;
 
 	/* Add the current item to the list of active epoll hook for this file */
-	spin_lock(&tfile->f_ep_lock);
+	bit_spin_lock(NR_EPOLL_FILE_LOCK, &tfile->f_flags);
 	list_add_tail(&epi->fllink, &tfile->f_ep_links);
-	spin_unlock(&tfile->f_ep_lock);
+	bit_spin_unlock(NR_EPOLL_FILE_LOCK, &tfile->f_flags);
 
 	/*
 	 * Add the current item to the RB tree. All RB tree operations are
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 3affd3e..756119e 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -299,7 +299,7 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		set_close_on_exec(fd, arg & FD_CLOEXEC);
 		break;
 	case F_GETFL:
-		err = filp->f_flags;
+		err = filp->f_flags & ~EPOLL_FILE_LOCK;
 		break;
 	case F_SETFL:
 		err = setfl(fd, filp, arg);
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index 41e9f88..d56a513 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -62,6 +62,10 @@
 #define NR_O_NDELAY	NR_O_NONBLOCK
 #endif
 
+/* Use bit 31 for epoll locking */
+#define NR_EPOLL_FILE_LOCK 31
+#define EPOLL_FILE_LOCK (1 << NR_EPOLL_FILE_LOCK)
+
 #define F_DUPFD		0	/* dup */
 #define F_GETFD		1	/* get close_on_exec */
 #define F_SETFD		2	/* set/clear close_on_exec */
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index f1e1d3c..7b5c58a 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -61,7 +61,7 @@ struct file;
 static inline void eventpoll_init_file(struct file *file)
 {
 	INIT_LIST_HEAD(&file->f_ep_links);
-	spin_lock_init(&file->f_ep_lock);
+	clear_bit(NR_EPOLL_FILE_LOCK, &file->f_flags);
 }
 
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9d7cb0e..ecd9a5b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -865,7 +865,6 @@ struct file {
 #ifdef CONFIG_EPOLL
 	/* Used by fs/eventpoll.c to link all the hooks to this file */
 	struct list_head	f_ep_links;
-	spinlock_t		f_ep_lock;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
 #ifdef CONFIG_DEBUG_WRITECOUNT
-- 
1.6.1.1

