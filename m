Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbZHRFRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbZHRFRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 01:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZHRFRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 01:17:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43721 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbZHRFRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 01:17:53 -0400
Date: Tue, 18 Aug 2009 15:17:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the fsnotify tree with Linus' tree
Message-Id: <20090818151751.c96a8f49.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Today's linux-next merge of the fsnotify tree got conflicts in
fs/notify/inotify/inotify_fsnotify.c, fs/notify/inotify/inotify_user.c
and fs/notify/notification.c between commits
eef3a116be11d35396efb2a8cc7345fd3221e294 ("notify: unused event private
race") and cd94c8bbef8d4b796a7ed4c551355a334604fd36 ("inotify: tail drop
inotify q_overflow events") from Linus' tree and commits
7bf357aac07084acfac5f0e746aca85c42cc046e ("fsnotify: use
fsnotify_create_event to allocate the q_overflow event"),
cddf930f6410692ba1db0c53753492d119b1bd55 ("fsnotify: allow notification
requests to not include private data") and
7f51531a261beb6be2071f4345482ac488eea734 ("fsnotify: per group
notification queue merge types") from the fsnotify tree.

I fixed it up as best I can (see below) and can carry the fixes as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/notify/inotify/inotify_fsnotify.c
index 5dcbafe,133f080..0000000
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@@ -31,6 -31,56 +31,60 @@@
  
  #include "inotify.h"
  
+ /*
+  * Check if 2 events contain the same information.  We do not compare private data
+  * but at this moment that isn't a problem for any know fsnotify listeners.
+  */
+ static bool event_compare(struct fsnotify_event *old, struct fsnotify_event *new)
+ {
+ 	if ((old->mask == new->mask) &&
+ 	    (old->to_tell == new->to_tell) &&
+ 	    (old->data_type == new->data_type) &&
+ 	    (old->name_len == new->name_len)) {
+ 		switch (old->data_type) {
+ 		case (FSNOTIFY_EVENT_INODE):
+ 			/* remember, after old was put on the wait_q we aren't
+ 			 * allowed to look at the inode any more, only thing
+ 			 * left to check was if the file_name is the same */
+ 			if (old->name_len &&
+ 			    !strcmp(old->file_name, new->file_name))
+ 				return true;
+ 			break;
+ 		case (FSNOTIFY_EVENT_PATH):
+ 			if ((old->path.mnt == new->path.mnt) &&
+ 			    (old->path.dentry == new->path.dentry))
+ 				return true;
+ 			break;
+ 		case (FSNOTIFY_EVENT_NONE):
++			if (old->mask & FS_Q_OVERFLOW)
++				return true;
++			else if (old->mask & FS_IN_IGNORED)
++				return false;
+ 			return true;
+ 		};
+ 	}
+ 	return false;
+ }
+ 
+ static int inotify_merge(struct list_head *list, struct fsnotify_event *event)
+ {
+ 	struct fsnotify_event_holder *last_holder;
+ 	struct fsnotify_event *last_event;
+ 	int ret = 0;
+ 
+ 	/* and the list better be locked by something too */
+ 	spin_lock(&event->lock);
+ 
+ 	last_holder = list_entry(list->prev, struct fsnotify_event_holder, event_list);
+ 	last_event = last_holder->event;
+ 	if (event_compare(last_event, event))
+ 		ret = -EEXIST;
+ 
+ 	spin_unlock(&event->lock);
+ 
+ 	return ret;
+ }
+ 
  static int inotify_handle_event(struct fsnotify_group *group, struct fsnotify_event *event)
  {
  	struct fsnotify_mark_entry *entry;
@@@ -61,15 -111,14 +115,15 @@@
  	fsn_event_priv->group = group;
  	event_priv->wd = wd;
  
- 	ret = fsnotify_add_notify_event(group, event, fsn_event_priv);
+ 	ret = fsnotify_add_notify_event(group, event, fsn_event_priv, inotify_merge);
 -	/* EEXIST is not an error */
 -	if (ret == -EEXIST)
 -		ret = 0;
 -
 -	/* did event_priv get attached? */
 -	if (list_empty(&fsn_event_priv->event_list))
 +	if (ret) {
  		inotify_free_event_priv(fsn_event_priv);
 +		/* EEXIST says we tail matched, EOVERFLOW isn't something
 +		 * to report up the stack. */
 +		if ((ret == -EEXIST) ||
 +		    (ret == -EOVERFLOW))
 +			ret = 0;
 +	}
  
  	/*
  	 * If we hold the entry until after the event is on the queue
diff --cc fs/notify/inotify/inotify_user.c
index dc32ed8,d5e78f6..0000000
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@@ -405,8 -401,10 +402,8 @@@ void inotify_ignored_and_remove_idr(str
  	fsn_event_priv->group = group;
  	event_priv->wd = ientry->wd;
  
- 	ret = fsnotify_add_notify_event(group, ignored_event, fsn_event_priv);
 -	fsnotify_add_notify_event(group, ignored_event, fsn_event_priv, NULL);
 -
 -	/* did the private data get added? */
 -	if (list_empty(&fsn_event_priv->event_list))
++	ret = fsnotify_add_notify_event(group, ignored_event, fsn_event_priv, NULL);
 +	if (ret)
  		inotify_free_event_priv(fsn_event_priv);
  
  skip_send_ignore:
diff --cc fs/notify/notification.c
index 3816d57,4f69b6f..0000000
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@@ -173,9 -140,10 +140,7 @@@ int fsnotify_add_notify_event(struct fs
  {
  	struct fsnotify_event_holder *holder = NULL;
  	struct list_head *list = &group->notification_list;
- 	struct fsnotify_event_holder *last_holder;
- 	struct fsnotify_event *last_event;
 -
 -	/* easy to tell if priv was attached to the event */
 -	if (priv)
 -		INIT_LIST_HEAD(&priv->event_list);
 +	int ret = 0;
  
  	/*
  	 * There is one fsnotify_event_holder embedded inside each fsnotify_event.
@@@ -195,8 -163,7 +160,8 @@@ alloc_holder
  	mutex_lock(&group->notification_mutex);
  
  	if (group->q_len >= group->max_events) {
- 		event = &q_overflow_event;
+ 		event = q_overflow_event;
 +		ret = -EOVERFLOW;
  		/* sorry, no private data on the overflow event */
  		priv = NULL;
  	}
