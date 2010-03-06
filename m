Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0CFJin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 04:38:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:29072 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab0CFJiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 04:38:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,593,1262592000"; 
   d="scan'208";a="498323382"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mst@redhat.com, jdike@c2.user-mode-linux.org
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [PATCH v1 2/3] Provides multiple submits and asynchronous notifications.
Date: Sat,  6 Mar 2010 17:38:37 +0800
Message-Id: <1267868318-19268-3-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1267868318-19268-2-git-send-email-xiaohui.xin@intel.com>
References: <1267868318-19268-1-git-send-email-xiaohui.xin@intel.com>
 <1267868318-19268-2-git-send-email-xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

The vhost-net backend now only supports synchronous send/recv
operations. The patch provides multiple submits and asynchronous
notifications. This is needed for zero-copy case.

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
---
 drivers/vhost/net.c   |  156 +++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/vhost/vhost.h |   23 +++++++
 2 files changed, 174 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 22d5fef..24a6c3d 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -22,6 +22,7 @@
 #include <linux/if_packet.h>
 #include <linux/if_arp.h>
 #include <linux/if_tun.h>
+#include <linux/mpassthru.h>
 
 #include <net/sock.h>
 
@@ -91,6 +92,12 @@ static void tx_poll_start(struct vhost_net *net, struct socket *sock)
 	net->tx_poll_state = VHOST_NET_POLL_STARTED;
 }
 
+static void handle_async_rx_events_notify(struct vhost_net *net,
+					struct vhost_virtqueue *vq);
+
+static void handle_async_tx_events_notify(struct vhost_net *net,
+					struct vhost_virtqueue *vq);
+
 /* Expects to be always run from workqueue - which acts as
  * read-size critical section for our kind of RCU. */
 static void handle_tx(struct vhost_net *net)
@@ -124,6 +131,8 @@ static void handle_tx(struct vhost_net *net)
 		tx_poll_stop(net);
 	hdr_size = vq->hdr_size;
 
+	handle_async_tx_events_notify(net, vq);
+
 	for (;;) {
 		head = vhost_get_vq_desc(&net->dev, vq, vq->iov,
 					 ARRAY_SIZE(vq->iov),
@@ -151,6 +160,12 @@ static void handle_tx(struct vhost_net *net)
 		/* Skip header. TODO: support TSO. */
 		s = move_iovec_hdr(vq->iov, vq->hdr, hdr_size, out);
 		msg.msg_iovlen = out;
+
+		if (vq->link_state == VHOST_VQ_LINK_ASYNC) {
+			vq->head = head;
+			msg.msg_control = (void *)vq;
+		}
+
 		len = iov_length(vq->iov, out);
 		/* Sanity check */
 		if (!len) {
@@ -166,6 +181,10 @@ static void handle_tx(struct vhost_net *net)
 			tx_poll_start(net, sock);
 			break;
 		}
+
+		if (vq->link_state == VHOST_VQ_LINK_ASYNC)
+			continue;
+
 		if (err != len)
 			pr_err("Truncated TX packet: "
 			       " len %d != %zd\n", err, len);
@@ -177,6 +196,8 @@ static void handle_tx(struct vhost_net *net)
 		}
 	}
 
+	handle_async_tx_events_notify(net, vq);
+
 	mutex_unlock(&vq->mutex);
 	unuse_mm(net->dev.mm);
 }
@@ -206,7 +227,8 @@ static void handle_rx(struct vhost_net *net)
 	int err;
 	size_t hdr_size;
 	struct socket *sock = rcu_dereference(vq->private_data);
-	if (!sock || skb_queue_empty(&sock->sk->sk_receive_queue))
+	if (!sock || (skb_queue_empty(&sock->sk->sk_receive_queue) &&
+			vq->link_state == VHOST_VQ_LINK_SYNC))
 		return;
 
 	use_mm(net->dev.mm);
@@ -214,9 +236,18 @@ static void handle_rx(struct vhost_net *net)
 	vhost_disable_notify(vq);
 	hdr_size = vq->hdr_size;
 
-	vq_log = unlikely(vhost_has_feature(&net->dev, VHOST_F_LOG_ALL)) ?
+	/* In async cases, for write logging, the simple way is to get
+	 * the log info always, and really logging is decided later.
+	 * Thus, when logging enabled, we can get log, and when logging
+	 * disabled, we can get log disabled accordingly.
+	 */
+
+	vq_log = unlikely(vhost_has_feature(&net->dev, VHOST_F_LOG_ALL)) |
+		(vq->link_state == VHOST_VQ_LINK_ASYNC) ?
 		vq->log : NULL;
 
+	handle_async_rx_events_notify(net, vq);
+
 	for (;;) {
 		head = vhost_get_vq_desc(&net->dev, vq, vq->iov,
 					 ARRAY_SIZE(vq->iov),
@@ -245,6 +276,11 @@ static void handle_rx(struct vhost_net *net)
 		s = move_iovec_hdr(vq->iov, vq->hdr, hdr_size, in);
 		msg.msg_iovlen = in;
 		len = iov_length(vq->iov, in);
+		if (vq->link_state == VHOST_VQ_LINK_ASYNC) {
+			vq->head = head;
+			vq->_log = log;
+			msg.msg_control = (void *)vq;
+		}
 		/* Sanity check */
 		if (!len) {
 			vq_err(vq, "Unexpected header len for RX: "
@@ -259,6 +295,10 @@ static void handle_rx(struct vhost_net *net)
 			vhost_discard_vq_desc(vq);
 			break;
 		}
+
+		if (vq->link_state == VHOST_VQ_LINK_ASYNC)
+			continue;
+
 		/* TODO: Should check and handle checksum. */
 		if (err > len) {
 			pr_err("Discarded truncated rx packet: "
@@ -284,10 +324,83 @@ static void handle_rx(struct vhost_net *net)
 		}
 	}
 
+	handle_async_rx_events_notify(net, vq);
+
 	mutex_unlock(&vq->mutex);
 	unuse_mm(net->dev.mm);
 }
 
+struct vhost_notifier *notify_dequeue(struct vhost_virtqueue *vq)
+{
+	struct vhost_notifier *vnotify = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vq->notify_lock, flags);
+	if (!list_empty(&vq->notifier)) {
+		vnotify = list_first_entry(&vq->notifier,
+				struct vhost_notifier, list);
+		list_del(&vnotify->list);
+	}
+	spin_unlock_irqrestore(&vq->notify_lock, flags);
+	return vnotify;
+}
+
+static void handle_async_rx_events_notify(struct vhost_net *net,
+				struct vhost_virtqueue *vq)
+{
+	struct vhost_notifier *vnotify = NULL;
+	struct vhost_log *vq_log = NULL;
+	int rx_total_len = 0;
+	int log, size;
+
+	if (vq->link_state != VHOST_VQ_LINK_ASYNC)
+		return;
+	if (vq != &net->dev.vqs[VHOST_NET_VQ_RX])
+		return;
+
+	if (vq->receiver)
+		vq->receiver(vq);
+	vq_log = unlikely(vhost_has_feature(
+				&net->dev, VHOST_F_LOG_ALL)) ? vq->log : NULL;
+	while ((vnotify = notify_dequeue(vq)) != NULL) {
+		vhost_add_used_and_signal(&net->dev, vq,
+				vnotify->head, vnotify->size);
+		log = vnotify->log;
+		size = vnotify->size;
+		rx_total_len += vnotify->size;
+		vnotify->dtor(vnotify);
+		if (unlikely(vq_log))
+			vhost_log_write(vq, vq_log, log, size);
+		if (unlikely(rx_total_len >= VHOST_NET_WEIGHT)) {
+			vhost_poll_queue(&vq->poll);
+			break;
+		}
+	}
+}
+
+static void handle_async_tx_events_notify(struct vhost_net *net,
+		struct vhost_virtqueue *vq)
+{
+	struct vhost_notifier *vnotify = NULL;
+	int tx_total_len = 0;
+
+	if (vq->link_state != VHOST_VQ_LINK_ASYNC)
+		return;
+	if (vq != &net->dev.vqs[VHOST_NET_VQ_TX])
+		return;
+
+	while ((vnotify = notify_dequeue(vq)) != NULL) {
+		vhost_add_used_and_signal(&net->dev, vq,
+				vnotify->head, 0);
+		tx_total_len += vnotify->size;
+		vnotify->dtor(vnotify);
+		if (unlikely(tx_total_len >= VHOST_NET_WEIGHT)) {
+			vhost_poll_queue(&vq->poll);
+			break;
+		}
+	}
+}
+
 static void handle_tx_kick(struct work_struct *work)
 {
 	struct vhost_virtqueue *vq;
@@ -462,7 +575,19 @@ static struct socket *get_tun_socket(int fd)
 	return sock;
 }
 
-static struct socket *get_socket(int fd)
+static struct socket *get_mp_socket(int fd)
+{
+	struct file *file = fget(fd);
+	struct socket *sock;
+	if (!file)
+		return ERR_PTR(-EBADF);
+	sock = mp_get_socket(file);
+	if (IS_ERR(sock))
+		fput(file);
+	return sock;
+}
+
+static struct socket *get_socket(struct vhost_virtqueue *vq, int fd)
 {
 	struct socket *sock;
 	if (fd == -1)
@@ -473,9 +598,26 @@ static struct socket *get_socket(int fd)
 	sock = get_tun_socket(fd);
 	if (!IS_ERR(sock))
 		return sock;
+	sock = get_mp_socket(fd);
+	if (!IS_ERR(sock)) {
+		vq->link_state = VHOST_VQ_LINK_ASYNC;
+		return sock;
+	}
 	return ERR_PTR(-ENOTSOCK);
 }
 
+static void vhost_init_link_state(struct vhost_net *n, int index)
+{
+	struct vhost_virtqueue *vq = n->vqs + index;
+
+	WARN_ON(!mutex_is_locked(&vq->mutex));
+	if (vq->link_state == VHOST_VQ_LINK_ASYNC) {
+		vq->receiver = NULL;
+		INIT_LIST_HEAD(&vq->notifier);
+		spin_lock_init(&vq->notify_lock);
+	}
+}
+
 static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 {
 	struct socket *sock, *oldsock;
@@ -493,12 +635,15 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	}
 	vq = n->vqs + index;
 	mutex_lock(&vq->mutex);
-	sock = get_socket(fd);
+	vq->link_state = VHOST_VQ_LINK_SYNC;
+	sock = get_socket(vq, fd);
 	if (IS_ERR(sock)) {
 		r = PTR_ERR(sock);
 		goto err;
 	}
 
+	vhost_init_link_state(n, index);
+
 	/* start polling new socket */
 	oldsock = vq->private_data;
 	if (sock == oldsock)
@@ -507,8 +652,8 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	vhost_net_disable_vq(n, vq);
 	rcu_assign_pointer(vq->private_data, sock);
 	vhost_net_enable_vq(n, vq);
-	mutex_unlock(&vq->mutex);
 done:
+	mutex_unlock(&vq->mutex);
 	mutex_unlock(&n->dev.mutex);
 	if (oldsock) {
 		vhost_net_flush_vq(n, index);
@@ -516,6 +661,7 @@ done:
 	}
 	return r;
 err:
+	mutex_unlock(&vq->mutex);
 	mutex_unlock(&n->dev.mutex);
 	return r;
 }
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index d1f0453..295bffa 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -43,6 +43,22 @@ struct vhost_log {
 	u64 len;
 };
 
+enum vhost_vq_link_state {
+	VHOST_VQ_LINK_SYNC = 	0,
+	VHOST_VQ_LINK_ASYNC = 	1,
+};
+
+/* The structure to notify the virtqueue for async socket */
+struct vhost_notifier {
+	struct list_head list;
+	struct vhost_virtqueue *vq;
+	int head;
+	int size;
+	int log;
+	void *ctrl;
+	void (*dtor)(struct vhost_notifier *);
+};
+
 /* The virtqueue structure describes a queue attached to a device. */
 struct vhost_virtqueue {
 	struct vhost_dev *dev;
@@ -96,6 +112,13 @@ struct vhost_virtqueue {
 	/* Log write descriptors */
 	void __user *log_base;
 	struct vhost_log log[VHOST_NET_MAX_SG];
+	/*Differiate async socket for 0-copy from normal*/
+	enum vhost_vq_link_state link_state;
+	int head;
+	int _log;
+	struct list_head notifier;
+	spinlock_t notify_lock;
+	void (*receiver)(struct vhost_virtqueue *);
 };
 
 struct vhost_dev {
-- 
1.5.4.4

