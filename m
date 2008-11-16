Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYKPXZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYKPXZH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 18:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYKPXYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 18:24:54 -0500
Received: from matrixpower.ru ([195.178.208.66]:54042 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbYKPXYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 18:24:54 -0500
Date: Mon, 17 Nov 2008 02:24:51 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Robert Love <rlove@rlove.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtk.manpages@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Subject: [take 3] Use pid in inotify events.
Message-ID: <20081116232450.GA13547@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

This patch allows to send IO origin PID in inotify events (using cookie
fields for all events except moving, where it is already used to track
move from and move to parts) when its uid matches inotify owner uid or
when inotify owner has admin (CAP_SYS_ADMIN) capabilities (Jeff
Schroeder's idea).

This is a resend of the previous patch, which was not commented by
anyone. Does it mean no one objects? If so, please apply.

Also removed John McCutchan's email, which bounces.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

diff --git a/fs/inotify.c b/fs/inotify.c
index 690e725..835259d 100644
--- a/fs/inotify.c
+++ b/fs/inotify.c
@@ -69,6 +69,9 @@ static atomic_t inotify_cookie;
  * inotify_add_watch() to the final put_inotify_watch().
  */
 
+#define IH_FLAGS_ADMIN		(0x00000001)
+/* handler owner has admin capabilities */
+
 /*
  * struct inotify_handle - represents an inotify instance
  *
@@ -80,6 +83,8 @@ struct inotify_handle {
 	struct list_head	watches;	/* list of watches */
 	atomic_t		count;		/* reference count */
 	u32			last_wd;	/* the last wd allocated */
+	uid_t			uid;		/* owner's uid */
+	u32			flags;		/* operation flags */
 	const struct inotify_operations *in_ops; /* inotify caller operations */
 };
 
@@ -292,6 +297,11 @@ void inotify_inode_queue_event(struct inode *inode, u32 mask, u32 cookie,
 			mutex_lock(&ih->mutex);
 			if (watch_mask & IN_ONESHOT)
 				remove_watch_no_event(watch, ih);
+
+			if (!cookie && ((ih->flags & IH_FLAGS_ADMIN) ||
+					(current->uid == ih->uid)))
+				cookie = task_tgid_vnr(current);
+
 			ih->in_ops->handle_event(watch, watch->wd, mask, cookie,
 						 name, n_inode);
 			mutex_unlock(&ih->mutex);
@@ -459,6 +469,10 @@ struct inotify_handle *inotify_init(const struct inotify_operations *ops)
 	mutex_init(&ih->mutex);
 	ih->last_wd = 0;
 	ih->in_ops = ops;
+	ih->uid = current->user->uid;
+	ih->flags = 0;
+	if (capable(CAP_SYS_ADMIN))
+		ih->flags |= IH_FLAGS_ADMIN;
 	atomic_set(&ih->count, 0);
 	get_inotify_handle(ih);
 
-- 
	Evgeniy Polyakov
