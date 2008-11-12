Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbYKLQRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbYKLQRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYKLQM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:12:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45450 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbYKLQMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:12:25 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 18/21] fanotify: all userspace to set timeouts
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:12:01 -0500
Message-ID: <20081112161201.25434.80001.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify when used to make access decisions has a default 5 second timeout.
This patch will allow userspace listeners to change their timeout on a
group wide basis.  Userspace listeners will still be able to reset the
timeout for individual events.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/access.c         |    2 +-
 fs/notify/fanotify.h       |    1 -
 fs/notify/group.c          |    2 ++
 include/linux/fanotify.h   |    8 ++++++++
 net/fanotify/af_fanotify.c |    9 +++++++++
 5 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/notify/access.c b/fs/notify/access.c
index 5b3b32e..0c04a60 100644
--- a/fs/notify/access.c
+++ b/fs/notify/access.c
@@ -59,7 +59,7 @@ int fanotify_get_response_from_access(struct fanotify_group *group, struct fanot
 retry:
 	ret = wait_event_interruptible_timeout(group->access_waitq,
 						event->response,
-						msecs_to_jiffies(5000));
+						msecs_to_jiffies(group->timeout));
 	/* Timeout or signal? */
 	if (ret <= 0) {
 		struct fanotify_event_holder *holder;
diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index 2721da2..a370ff9 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -98,7 +98,6 @@ extern __init int fanotify_notification_uninit(void);
 extern void fanotify_fastpath_get(struct fanotify_fastpath_entry *entry);
 extern void fanotify_fastpath_put(struct fanotify_fastpath_entry *entry);
 extern int fanotify_is_fastpath(struct file *file, unsigned int mask, struct fanotify_group *group);
-extern void fanotify_fastpath_clear_group(struct fanotify_group *group);
 extern void fanotify_fastpath_clear(struct inode *inode);
 extern __init int fanotify_fastpath_init(void);
 extern __init int fanotify_fastpath_uninit(void);
diff --git a/fs/notify/group.c b/fs/notify/group.c
index 68f895e..650f31e 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -84,6 +84,8 @@ struct fanotify_group *fanotify_find_group(unsigned int priority, unsigned int g
 	INIT_LIST_HEAD(&group->access_list);
 	init_waitqueue_head(&group->access_waitq);
 
+	group->timeout = 5000;
+
 	/* Do we need to be the first entry? */
 	if (list_empty(&fanotify_groups)) {
 		list_add_rcu(&group->group_list, &fanotify_groups);
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index b7ab01f..c6a2a3c 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -90,6 +90,7 @@ struct fanotify_so_access {
 #define FANOTIFY_SET_FASTPATH	1
 #define FANOTIFY_SEND_RESPONSE	2
 #define FANOTIFY_CLEAR_ALL_FASTPATH	3
+#define FANOTIFY_SET_TIMEOUT		4
 
 #ifdef __KERNEL__
 
@@ -121,6 +122,8 @@ struct fanotify_group {
 	struct list_head access_list;	/* event_holder we need an answer from userspace */
 	wait_queue_head_t access_waitq;	/* we wait here for userspace access decisions */
 
+	unsigned int timeout;		/* timeout to wait for access requests in msec */
+
 	unsigned int priority;		/* order this group should receive msgs.  low first */
 };
 
@@ -137,6 +140,7 @@ extern void fanotify_put_group(struct fanotify_group *group);
 extern int fanotify_create_event_fd(struct fanotify_group *group, struct fanotify_event_metadata *data, int nonblock);
 extern int fanotify_fastpath_add(struct fanotify_group *group, int fd, unsigned int mask);
 extern int fanotify_process_access_response(struct fanotify_group *group, unsigned long cookie, unsigned int response);
+extern void fanotify_fastpath_clear_group(struct fanotify_group *group);
 
 #else
 
@@ -175,6 +179,10 @@ static inline int fanotify_process_access_response(struct fanotify_group *group,
 	return 0;
 }
 
+static inline  void fanotify_fastpath_clear_group(struct fanotify_group *group)
+{}
+
+
 #endif	/* CONFIG_FANOTIFY */
 
 #endif	/* __KERNEL __ */
diff --git a/net/fanotify/af_fanotify.c b/net/fanotify/af_fanotify.c
index 7c98a22..f56984e 100644
--- a/net/fanotify/af_fanotify.c
+++ b/net/fanotify/af_fanotify.c
@@ -163,6 +163,7 @@ static int fan_setsockopt(struct socket *sock, int level, int optname, char __us
 	union {
 		struct fanotify_so_fastpath fastpath;
 		struct fanotify_so_access access;
+		uint32_t timeout;
 	} data;
 	int ret = 0;
 
@@ -195,6 +196,14 @@ static int fan_setsockopt(struct socket *sock, int level, int optname, char __us
 	case FANOTIFY_CLEAR_ALL_FASTPATH:
 		fanotify_fastpath_clear_group(group);
 		break;
+	case FANOTIFY_SET_TIMEOUT:
+		if (optlen < sizeof(uint32_t))
+			return -ENOMEM;
+		ret = copy_from_user(&data.timeout, optval, sizeof(uint32_t));
+		if (ret)
+			return ret;
+		group->timeout = data.timeout;
+		break;
 	default:
 		return -ENOPROTOOPT;
 	}

