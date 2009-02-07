Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbZBGUHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbZBGUHh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 15:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZBGUHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 15:07:01 -0500
Received: from vena.lwn.net ([206.168.112.25]:51311 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbZBGUG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 15:06:59 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Mackall <mpm@selenic.com>,
       Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/4] Rename struct file->f_ep_lock
Date: Sat,  7 Feb 2009 13:06:54 -0700
Message-Id: <1234037217-16124-2-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.6.1.2
In-Reply-To: <1234037217-16124-1-git-send-email-corbet@lwn.net>
References: <1234037217-16124-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lock moves out of the CONFIG_EPOLL ifdef and becomes f_lock.  For now,
epoll remains the only user, but a future patch will use it to protect
f_flags as well.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 fs/eventpoll.c            |   12 +++++++-----
 fs/file_table.c           |    1 +
 include/linux/eventpoll.h |    1 -
 include/linux/fs.h        |    2 +-
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index ba2f9ec..1a59e09 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -427,10 +427,10 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 	ep_unregister_pollwait(ep, epi);
 
 	/* Remove the current item from the list of epoll hooks */
-	spin_lock(&file->f_ep_lock);
+	spin_lock(&file->f_lock);
 	if (ep_is_linked(&epi->fllink))
 		list_del_init(&epi->fllink);
-	spin_unlock(&file->f_ep_lock);
+	spin_unlock(&file->f_lock);
 
 	rb_erase(&epi->rbn, &ep->rbr);
 
@@ -549,7 +549,7 @@ void eventpoll_release_file(struct file *file)
 	struct epitem *epi;
 
 	/*
-	 * We don't want to get "file->f_ep_lock" because it is not
+	 * We don't want to get "file->f_lock" because it is not
 	 * necessary. It is not necessary because we're in the "struct file"
 	 * cleanup path, and this means that noone is using this file anymore.
 	 * So, for example, epoll_ctl() cannot hit here sicne if we reach this
@@ -558,6 +558,8 @@ void eventpoll_release_file(struct file *file)
 	 * will correctly serialize the operation. We do need to acquire
 	 * "ep->mtx" after "epmutex" because ep_remove() requires it when called
 	 * from anywhere but ep_free().
+	 *
+	 * Besides, ep_remove() acquires the lock, so we can't hold it here.
 	 */
 	mutex_lock(&epmutex);
 
@@ -800,9 +802,9 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 		goto error_unregister;
 
 	/* Add the current item to the list of active epoll hook for this file */
-	spin_lock(&tfile->f_ep_lock);
+	spin_lock(&tfile->f_lock);
 	list_add_tail(&epi->fllink, &tfile->f_ep_links);
-	spin_unlock(&tfile->f_ep_lock);
+	spin_unlock(&tfile->f_lock);
 
 	/*
 	 * Add the current item to the RB tree. All RB tree operations are
diff --git a/fs/file_table.c b/fs/file_table.c
index bbeeac6..aa1e180 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -127,6 +127,7 @@ struct file *get_empty_filp(void)
 	atomic_long_set(&f->f_count, 1);
 	rwlock_init(&f->f_owner.lock);
 	f->f_cred = get_cred(cred);
+	spin_lock_init(&f->f_lock);
 	eventpoll_init_file(f);
 	/* f->f_version: 0 */
 	return f;
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index f1e1d3c..f6856a5 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -61,7 +61,6 @@ struct file;
 static inline void eventpoll_init_file(struct file *file)
 {
 	INIT_LIST_HEAD(&file->f_ep_links);
-	spin_lock_init(&file->f_ep_lock);
 }
 
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6022f44..0d71633 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -842,6 +842,7 @@ struct file {
 #define f_dentry	f_path.dentry
 #define f_vfsmnt	f_path.mnt
 	const struct file_operations	*f_op;
+	spinlock_t		f_lock;  /* f_ep_links */
 	atomic_long_t		f_count;
 	unsigned int 		f_flags;
 	fmode_t			f_mode;
@@ -860,7 +861,6 @@ struct file {
 #ifdef CONFIG_EPOLL
 	/* Used by fs/eventpoll.c to link all the hooks to this file */
 	struct list_head	f_ep_links;
-	spinlock_t		f_ep_lock;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
 #ifdef CONFIG_DEBUG_WRITECOUNT
-- 
1.6.1.2

