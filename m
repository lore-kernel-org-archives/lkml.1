Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYKLQM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYKLQM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYKLQLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:11:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47120 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbYKLQLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:11:22 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 08/21] fanotify: add a userspace interface for fastpaths
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:11:08 -0500
Message-ID: <20081112161108.25434.11628.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
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
 net/fanotify/af_fanotify.c |   36 +++++++++++++++++++++++++++++++++++-
 3 files changed, 47 insertions(+), 1 deletions(-)

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
index e0e63f2..0646840 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -52,6 +52,15 @@ struct fanotify_event_metadata {
 /* fanotify getsockopt optvals */
 #define FANOTIFY_GET_EVENT	1
 
+/* struct used for FANOTIFY_SET_FASTPATH */
+struct fanotify_so_fastpath {
+	__s32 fd;
+	__u32 mask;
+}  __attribute__((packed));
+
+/* fanotify setsockopt optvals */
+#define FANOTIFY_SET_FASTPATH	1
+
 #ifdef __KERNEL__
 
 #include <linux/fs.h>
diff --git a/net/fanotify/af_fanotify.c b/net/fanotify/af_fanotify.c
index 7474cf1..6f2357c 100644
--- a/net/fanotify/af_fanotify.c
+++ b/net/fanotify/af_fanotify.c
@@ -156,6 +156,40 @@ static int fan_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	return 0;
 }
 
+static int fan_setsockopt(struct socket *sock, int level, int optname, char __user *optval, int optlen)
+{
+	struct fanotify_sock *fan_sock;
+	struct fanotify_group *group;
+	union {
+		struct fanotify_so_fastpath fastpath;
+	} data;
+	int ret = 0;
+
+	if (sock->state != SS_CONNECTED)
+		return -EBADF;
+
+	if (level != SOL_FANOTIFY)
+		return -ENOPROTOOPT;
+
+	fan_sock = fan_sk(sock->sk);
+	group = fan_sock->group;
+
+	switch(optname) {
+	case FANOTIFY_SET_FASTPATH:
+		if (optlen < sizeof(struct fanotify_so_fastpath))
+			return -ENOMEM;
+		ret = copy_from_user(&data.fastpath, optval, sizeof(struct fanotify_so_fastpath));
+		if (ret)
+			return ret;
+		ret = fanotify_fastpath_add(group, data.fastpath.fd, data.fastpath.mask);
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
@@ -218,7 +252,7 @@ static const struct proto_ops fanotify_proto_ops = {
 	.ioctl =	sock_no_ioctl,
 	.listen =	sock_no_listen,
 	.shutdown =	sock_no_shutdown,
-	.setsockopt =	sock_no_setsockopt,
+	.setsockopt =	fan_setsockopt,
 	.getsockopt =	fan_getsockopt,
 	.sendmsg =	sock_no_sendmsg,
 	.recvmsg =	sock_no_recvmsg,

