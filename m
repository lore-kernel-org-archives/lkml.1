Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbYJNUxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbYJNUxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbYJNUwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:52:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37749 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbYJNUwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:52:21 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v2 08/16] fanotify: add a userspace interface for fastpaths
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu
Date: Tue, 14 Oct 2008 16:52:12 -0400
Message-ID: <20081014205212.1057.90843.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
References: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

turns out the fastpath code is useless without an interface.  This one
works.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/group.c          |    3 +++
 include/linux/fanotify.h   |    9 +++++++++
 net/fanotify/af_fanotify.c |   31 ++++++++++++++++++++++++++++++-
 3 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/fs/notify/group.c b/fs/notify/group.c
index ff9b5ef..21037cc 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -74,6 +74,9 @@ struct fanotify_group *fanotify_find_group(unsigned int group_num, unsigned int
 	INIT_LIST_HEAD(&group->notification_list);
 	init_waitqueue_head(&group->notification_waitq);
 
+	mutex_init(&group->fastpath_mutex);
+	INIT_LIST_HEAD(&group->fastpath_entries);
+
 	/* add it */
 	list_add_rcu(&group->group_list, &fanotify_groups);
 
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 015cfea..a1ea7e0 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -57,6 +57,15 @@ struct fanotify_event_metadata {
 /* fanotify getsockopt optvals */
 #define FANOTIFY_GET_EVENT	1
 
+/* struct used for FANOTIFY_SET_FASTPATH */
+struct fanotify_so_fastpath {
+	int32_t fd;
+	uint32_t mask;
+};
+
+/* fanotify setsockopt optvals */
+#define FANOTIFY_SET_FASTPATH	1
+
 #ifdef __KERNEL__
 
 #include <linux/fs.h>
diff --git a/net/fanotify/af_fanotify.c b/net/fanotify/af_fanotify.c
index eb2d023..f63ee7a 100644
--- a/net/fanotify/af_fanotify.c
+++ b/net/fanotify/af_fanotify.c
@@ -159,6 +159,35 @@ static unsigned int fan_poll(struct file * file, struct socket *sock, poll_table
 	return 0;
 }
 
+static int fan_setsockopt(struct socket *sock, int level, int optname, char __user *optval, int optlen)
+{
+	struct fanotify_sock *fan_sock;
+	struct fanotify_group *group;
+	struct fanotify_so_fastpath fp_data;
+	int ret = 0;
+
+	if (sock->state != SS_CONNECTED)
+		return -EBADF;
+
+	fan_sock = fan_sk(sock->sk);
+	group = fan_sock->group;
+
+	switch(optname) {
+	case FANOTIFY_SET_FASTPATH:
+		if (optlen < sizeof(struct fanotify_so_fastpath))
+			return -ENOMEM;
+		ret = copy_from_user(&fp_data, optval, sizeof(struct fanotify_so_fastpath));
+		if (ret)
+			return ret;
+		fanotify_fastpath_add(group, fp_data.fd, fp_data.mask);
+		break;
+	default:
+		return -ENOPROTOOPT;
+	}
+
+	return ret;
+}
+
 static int fan_getsockopt(struct socket *sock, int level, int optname, char __user *optval, int __user *optlen)
 {
 	struct fanotify_sock *fan_sock;
@@ -210,7 +239,7 @@ static const struct proto_ops fanotify_proto_ops = {
 	.ioctl =	sock_no_ioctl,
 	.listen =	sock_no_listen,
 	.shutdown =	sock_no_shutdown,
-	.setsockopt =	sock_no_setsockopt,
+	.setsockopt =	fan_setsockopt,
 	.getsockopt =	fan_getsockopt,
 	.sendmsg =	sock_no_sendmsg,
 	.recvmsg =	sock_no_recvmsg,

