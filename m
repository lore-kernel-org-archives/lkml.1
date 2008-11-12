Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbYKLQNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbYKLQNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYKLQLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:11:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45344 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbYKLQLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:11:33 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 06/21] fanotify: add a userspace interface for fanotify
	notifications
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:10:58 -0500
Message-ID: <20081112161058.25434.86923.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

notifications from fanotify need a userspace interface.  We are going to
try to do it with sockets.  Scary....

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/fanotify.h   |   29 ++++-
 include/linux/socket.h     |    5 +
 net/Makefile               |    1 
 net/core/sock.c            |    6 +
 net/fanotify/Makefile      |    5 +
 net/fanotify/af_fanotify.c |  240 ++++++++++++++++++++++++++++++++++++++++++++
 net/fanotify/af_fanotify.h |   20 ++++
 7 files changed, 294 insertions(+), 12 deletions(-)
 create mode 100644 net/fanotify/Makefile
 create mode 100644 net/fanotify/af_fanotify.c
 create mode 100644 net/fanotify/af_fanotify.h

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index c991bd9..76d88fd 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -34,17 +34,23 @@
 			 FAN_CLOSE |\
 			 FAN_OPEN)
 
-#ifdef __KERNEL__
 #include <linux/types.h>
-#else
-#include <stdint.h>
-#include <sys/types.h>
-#endif
 
+struct fanotify_addr {
+        __u32 group_num;
+        __u32 mask;
+        __u32 timeout;
+        __u32 unused[9];
+}  __attribute__((packed));
+
+/* struct used for FANOTIFY_GET_EVENT */
 struct fanotify_event_metadata {
-	int32_t fd;
-	uint32_t mask;
-};
+	__s32 fd;
+	__u32 mask;
+}  __attribute__((packed));
+
+/* fanotify getsockopt optvals */
+#define FANOTIFY_GET_EVENT	1
 
 #ifdef __KERNEL__
 
@@ -74,6 +80,8 @@ extern void fanotify(struct file *file, unsigned int mask);
 extern void fanotify_get_group(struct fanotify_group *group);
 extern struct fanotify_group *fanotify_find_group(unsigned int group_num, unsigned int mask);
 extern void fanotify_put_group(struct fanotify_group *group);
+
+extern int fanotify_create_event_fd(struct fanotify_group *group, struct fanotify_event_metadata *data, int nonblock);
 #else
 
 static inline void fanotify(struct file *file, unsigned int mask)
@@ -90,6 +98,11 @@ static inline struct fanotify_group *fanotify_find_group(unsigned int group_num,
 static inline extern void fanotify_put_group(struct fanotify_group *group)
 {}
 
+static inline int fanotify_create_event_fd(struct fanotify_group *group, struct fanotify_event_metadata *data, int nonblock)
+{
+	memset(data, 0, sizeof(struct fanotify_event_metadata));
+	return 0;
+}
 #endif	/* CONFIG_FANOTIFY */
 
 #endif	/* __KERNEL __ */
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 20fc4bb..4fe7b83 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -191,7 +191,8 @@ struct ucred {
 #define AF_RXRPC	33	/* RxRPC sockets 		*/
 #define AF_ISDN		34	/* mISDN sockets 		*/
 #define AF_PHONET	35	/* Phonet sockets		*/
-#define AF_MAX		36	/* For now.. */
+#define AF_FANOTIFY	36	/* fscking all access sockets	*/
+#define AF_MAX		37	/* For now.. */
 
 /* Protocol families, same as address families. */
 #define PF_UNSPEC	AF_UNSPEC
@@ -229,6 +230,7 @@ struct ucred {
 #define PF_RXRPC	AF_RXRPC
 #define PF_ISDN		AF_ISDN
 #define PF_PHONET	AF_PHONET
+#define PF_FANOTIFY	AF_FANOTIFY
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */
@@ -298,6 +300,7 @@ struct ucred {
 #define SOL_PPPOL2TP	273
 #define SOL_BLUETOOTH	274
 #define SOL_PNPIPE	275
+#define SOL_FANOTIFY	276
 
 /* IPX options */
 #define IPX_TYPE	1
diff --git a/net/Makefile b/net/Makefile
index 27d1f10..5b98ba4 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_ATM)		+= atm/
 obj-$(CONFIG_DECNET)		+= decnet/
 obj-$(CONFIG_ECONET)		+= econet/
 obj-$(CONFIG_PHONET)		+= phonet/
+obj-$(CONFIG_FANOTIFY)		+= fanotify/
 ifneq ($(CONFIG_VLAN_8021Q),)
 obj-y				+= 8021q/
 endif
diff --git a/net/core/sock.c b/net/core/sock.c
index 5e2a313..c7b0cee 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -155,7 +155,7 @@ static const char *af_family_key_strings[AF_MAX+1] = {
   "sk_lock-27"       , "sk_lock-28"          , "sk_lock-AF_CAN"      ,
   "sk_lock-AF_TIPC"  , "sk_lock-AF_BLUETOOTH", "sk_lock-IUCV"        ,
   "sk_lock-AF_RXRPC" , "sk_lock-AF_ISDN"     , "sk_lock-AF_PHONET"   ,
-  "sk_lock-AF_MAX"
+  "sk_lock-AF_FANOTIFY", "sk_lock-AF_MAX"
 };
 static const char *af_family_slock_key_strings[AF_MAX+1] = {
   "slock-AF_UNSPEC", "slock-AF_UNIX"     , "slock-AF_INET"     ,
@@ -170,7 +170,7 @@ static const char *af_family_slock_key_strings[AF_MAX+1] = {
   "slock-27"       , "slock-28"          , "slock-AF_CAN"      ,
   "slock-AF_TIPC"  , "slock-AF_BLUETOOTH", "slock-AF_IUCV"     ,
   "slock-AF_RXRPC" , "slock-AF_ISDN"     , "slock-AF_PHONET"   ,
-  "slock-AF_MAX"
+  "slock=AF_FANOTIFY", "slock-AF_MAX"
 };
 static const char *af_family_clock_key_strings[AF_MAX+1] = {
   "clock-AF_UNSPEC", "clock-AF_UNIX"     , "clock-AF_INET"     ,
@@ -185,7 +185,7 @@ static const char *af_family_clock_key_strings[AF_MAX+1] = {
   "clock-27"       , "clock-28"          , "clock-AF_CAN"      ,
   "clock-AF_TIPC"  , "clock-AF_BLUETOOTH", "clock-AF_IUCV"     ,
   "clock-AF_RXRPC" , "clock-AF_ISDN"     , "clock-AF_PHONET"   ,
-  "clock-AF_MAX"
+  "clock-AF_FANOTIFY", "clock-AF_MAX"
 };
 #endif
 
diff --git a/net/fanotify/Makefile b/net/fanotify/Makefile
new file mode 100644
index 0000000..348cf5e
--- /dev/null
+++ b/net/fanotify/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the fanotify AF.
+#
+
+obj-$(CONFIG_FANOTIFY) += af_fanotify.o
diff --git a/net/fanotify/af_fanotify.c b/net/fanotify/af_fanotify.c
new file mode 100644
index 0000000..7474cf1
--- /dev/null
+++ b/net/fanotify/af_fanotify.c
@@ -0,0 +1,240 @@
+#include <linux/errno.h>
+#include <linux/fanotify.h>
+#include <linux/fdtable.h>
+#include <linux/file.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/net.h>
+#include <linux/skbuff.h>
+#include <linux/socket.h>
+#include <linux/types.h>
+
+#include <net/net_namespace.h>
+#include <net/sock.h>
+
+#include "af_fanotify.h"
+
+static const struct proto_ops fanotify_proto_ops;
+
+static struct proto fanotify_proto = {
+	.name     = "FANOTIFY",
+	.owner    = THIS_MODULE,
+	.obj_size = sizeof(struct fanotify_sock),
+};
+
+static int fan_sock_create(struct net *net, struct socket *sock, int protocol)
+{
+	struct sock *sk;
+	struct fanotify_sock *fan_sock;
+
+	/* FIXME maybe a new LSM hook? */
+	if (!capable(CAP_NET_RAW))
+		return -EPERM;
+
+	if (protocol != 0)
+		return -ESOCKTNOSUPPORT;
+
+	if (sock->type != SOCK_RAW)
+		return -ESOCKTNOSUPPORT;
+
+	sock->state = SS_UNCONNECTED;
+
+	sk = sk_alloc(net, PF_FANOTIFY, GFP_KERNEL, &fanotify_proto);
+	if (sk == NULL)
+		return -ENOBUFS;
+
+	sock->ops = &fanotify_proto_ops;
+
+	sock_init_data(sock, sk);
+
+	sk->sk_family = PF_FANOTIFY;
+	//sk->sk_destruct = packet_sock_destruct;
+	sk_refcnt_debug_inc(sk);
+
+	fan_sock = fan_sk(sk);
+	fan_sock->group = NULL;
+
+	return 0;
+}
+
+static int fan_release(struct socket *sock)
+{
+	struct sock *sk;
+	struct fanotify_sock *fan_sock;
+
+	struct files_struct *files;
+	struct socket *testsock;
+	struct fdtable *fdt;
+	long j = -1;
+	unsigned long set, i;
+	int found = 0, err;
+
+	sk = sock->sk;
+	if (!sk)
+		return 0;
+
+	fan_sock = fan_sk(sk);
+
+	if (sock->state == SS_CONNECTED) {
+		sock->state = SS_UNCONNECTED;
+		fanotify_put_group(fan_sock->group);
+	}
+
+	fan_sock->group = NULL;
+
+	sock_orphan(sk);
+	sock->sk = NULL;
+
+	/* Purge queues */
+
+	sk_refcnt_debug_release(sk);
+
+	sock_put(sk);
+
+	/*
+	 * we do all of this shit to figure out if this process is closing the last
+	 * fanotify socket.  If this is the last one being closed we clear the
+	 * exclusion flag.  If this is not the last close we should remain excluded.
+	 *
+	 * the basic idea behind running all of the open fd's was stolen from
+	 * fs/exec.c:flush_old_files.
+	 */
+	files = current->files;
+	if (files)
+		spin_lock(&files->file_lock);
+	for (; !found && files ;) {
+		j++;
+		i = j * __NFDBITS;
+		fdt = files_fdtable(files);
+		if (i >= fdt->max_fds)
+			break;
+		set = fdt->open_fds->fds_bits[j];
+		if (!set)
+			continue;
+		spin_unlock(&files->file_lock);
+		for ( ; set && !found ; i++, set >>= 1) {
+			if (set & 1) {
+				testsock = sockfd_lookup(i, &err);
+				if (!testsock)
+					continue;
+				if ((testsock != sock) && (testsock->ops == &fanotify_proto_ops))
+					found = 1;
+				sockfd_put(testsock);
+			}
+		}
+		spin_lock(&files->file_lock);
+	}
+	if (files)
+		spin_unlock(&files->file_lock);
+
+	if (!found)
+		current->flags &= ~PF_NOFACCESS;
+
+	return 0;
+}
+
+static int fan_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
+{
+	struct fanotify_addr *fan_addr = (struct fanotify_addr *)addr;
+	struct fanotify_sock *fan_sock;
+
+	if (addr_len != sizeof(struct fanotify_addr))
+		return -EINVAL;
+
+	if (sock->state != SS_UNCONNECTED)
+		return -EINVAL;
+
+	fan_sock = fan_sk(sock->sk);
+	fan_sock->group = fanotify_find_group(fan_addr->group_num, fan_addr->mask);
+
+	if (IS_ERR(fan_sock->group))
+		return PTR_ERR(fan_sock->group);
+
+	sock->state = SS_CONNECTED;
+	current->flags |= PF_NOFACCESS;
+
+	return 0;
+}
+
+static int fan_getsockopt(struct socket *sock, int level, int optname, char __user *optval, int __user *optlen)
+{
+	struct fanotify_sock *fan_sock;
+	struct fanotify_group *group;
+	union {
+		struct fanotify_event_metadata event_metadata;
+	} data;
+	int len, ret = 0;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
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
+	switch (optname) {
+	case FANOTIFY_GET_EVENT:
+		if (len < sizeof(struct fanotify_event_metadata))
+			return -ENOMEM;
+		else
+			len = sizeof(struct fanotify_event_metadata);
+		ret = fanotify_create_event_fd(group, &data.event_metadata, !!(sock->file->f_flags & O_NONBLOCK));
+		if (ret)
+			break;
+
+		ret = copy_to_user(optval, &data.event_metadata, sizeof(struct fanotify_event_metadata));
+		break;
+	default:
+		return -ENOPROTOOPT;
+	};
+
+	if (!ret)
+		ret = put_user(len, optlen);
+
+	return ret;
+}
+
+static const struct net_proto_family fanotify_family_ops = {
+	.family		=	PF_FANOTIFY,
+	.create		=	fan_sock_create,
+	.owner		=	THIS_MODULE,
+};
+
+static const struct proto_ops fanotify_proto_ops = {
+	.family =	PF_FANOTIFY,
+	.owner =	THIS_MODULE,
+	.release =	fan_release,
+	.bind =		fan_bind,
+	.connect =	sock_no_connect,
+	.socketpair =	sock_no_socketpair,
+	.accept =	sock_no_accept,
+	.getname =	sock_no_getname,
+	.poll =		sock_no_poll,
+	.ioctl =	sock_no_ioctl,
+	.listen =	sock_no_listen,
+	.shutdown =	sock_no_shutdown,
+	.setsockopt =	sock_no_setsockopt,
+	.getsockopt =	fan_getsockopt,
+	.sendmsg =	sock_no_sendmsg,
+	.recvmsg =	sock_no_recvmsg,
+	.mmap =		sock_no_mmap,
+	.sendpage =	sock_no_sendpage,
+};
+
+static int __init fanotify_socket_register(void)
+{
+	int rc = proto_register(&fanotify_proto, 0);
+
+	if (rc != 0)
+		goto out;
+
+	sock_register(&fanotify_family_ops);
+out:
+	return rc;
+}
+__initcall(fanotify_socket_register);
diff --git a/net/fanotify/af_fanotify.h b/net/fanotify/af_fanotify.h
new file mode 100644
index 0000000..a987d7b
--- /dev/null
+++ b/net/fanotify/af_fanotify.h
@@ -0,0 +1,20 @@
+#ifndef _LINUX_AF_FANOTIFY_H
+#define _LINUX_AF_FANOTIFY_H
+
+#ifdef __KERNEL__
+
+#include <linux/fanotify.h>
+#include <net/sock.h>
+
+struct fanotify_sock {
+	struct sock		sock;
+	struct fanotify_group	*group;
+};
+
+static inline struct fanotify_sock *fan_sk(struct sock *sock)
+{
+	return (struct fanotify_sock *)sock;
+}
+
+#endif /* __KERNEL__ */
+#endif /* _LINUX_AF_NET_H */

