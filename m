Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYCKMHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYCKMHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbYCKMHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:07:39 -0400
Received: from ozlabs.org ([203.10.76.45]:45568 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757562AbYCKMHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:07:38 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: [PATCH 4/4] virtio: Enable netpoll interface for netconsole logging
Date: Tue, 11 Mar 2008 23:06:30 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, "Amit Shah" <amitshah@gmx.net>
References: <200803112303.22984.rusty@rustcorp.com.au> <200803112304.21680.rusty@rustcorp.com.au> <200803112305.23648.rusty@rustcorp.com.au>
In-Reply-To: <200803112305.23648.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112306.30687.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Amit Shah" <amitshah@gmx.net>

Add a new poll_controller handler that the netpoll interface needs.

This enables netconsole logging from a kvm guest over the virtio
net interface.

Signed-off-by: Amit Shah <amitshah@gmx.net>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/net/virtio_net.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -294,6 +294,15 @@ again:
 	return 0;
 }
 
+#ifdef CONFIG_NET_POLL_CONTROLLER
+static void virtnet_netpoll(struct net_device *dev)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+
+	napi_schedule(&vi->napi);
+}
+#endif
+
 static int virtnet_open(struct net_device *dev)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
@@ -336,6 +345,9 @@ static int virtnet_probe(struct virtio_d
 	dev->stop = virtnet_close;
 	dev->hard_start_xmit = start_xmit;
 	dev->features = NETIF_F_HIGHDMA;
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	dev->poll_controller = virtnet_netpoll;
+#endif
 	SET_NETDEV_DEV(dev, &vdev->dev);
 
 	/* Do we support "hardware" checksums? */
