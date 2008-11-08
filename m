Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbYKHWD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbYKHWD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 17:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbYKHWDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 17:03:19 -0500
Received: from genesysrack.ru ([195.178.208.66]:33196 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbYKHWDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 17:03:18 -0500
Date: Sun, 9 Nov 2008 01:03:02 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Robert Love <rlove@rlove.org>
Cc: John McCutchan <ttb@tentacle.dhs.org>, linux-api@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Subject: Re: [1/1] Use pid in inotify events.
Message-ID: <20081108220302.GA25271@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081108184013.GA11888@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081108184013.GA11888@ioremap.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2008 at 09:40:13PM +0300, Evgeniy Polyakov (zbr@ioremap.net) wrote:
> But I really do not want to start to discuss this, since I already see
> that result will be effectively zero, so returning to the original
> problem with putting pid into events: if inotify_init() caller has 0
> (e)uid or if IO origin has the same (e)uid, are you ok to put pid into
> the event?

Something like this (not tested yet, no normal network access).

Signed-off.

diff --git a/fs/inotify.c b/fs/inotify.c
index 690e725..121f025 100644
--- a/fs/inotify.c
+++ b/fs/inotify.c
@@ -80,6 +80,7 @@ struct inotify_handle {
 	struct list_head	watches;	/* list of watches */
 	atomic_t		count;		/* reference count */
 	u32			last_wd;	/* the last wd allocated */
+	uid_t			uid;		/* watcher's uid */
 	const struct inotify_operations *in_ops; /* inotify caller operations */
 };
 
@@ -292,6 +293,10 @@ void inotify_inode_queue_event(struct inode *inode, u32 mask, u32 cookie,
 			mutex_lock(&ih->mutex);
 			if (watch_mask & IN_ONESHOT)
 				remove_watch_no_event(watch, ih);
+
+			if (!cookie && (ih->uid == 0 ||
+					ih->uid == current->user->uid))
+				cookie = task_tgid_vnr(current);
 			ih->in_ops->handle_event(watch, watch->wd, mask, cookie,
 						 name, n_inode);
 			mutex_unlock(&ih->mutex);
diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index 6024942..e426f7c 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -612,6 +612,8 @@ asmlinkage long sys_inotify_init1(int flags)
 	dev->ih = ih;
 	dev->fa = NULL;
 
+	ih->uid = user->uid;
+
 	filp->f_op = &inotify_fops;
 	filp->f_path.mnt = mntget(inotify_mnt);
 	filp->f_path.dentry = dget(inotify_mnt->mnt_root);


-- 
	Evgeniy Polyakov
