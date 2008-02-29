Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbYB2KzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbYB2KzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 05:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbYB2Kyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 05:54:52 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:10377 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbYB2Kyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 05:54:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=fzY6KW8M0q9dLEVyo736PamgMXRvBx7eXmo8m6SWf0wLrYPEoM4oauQ9t7h+rqK/cL6uB9SAvuFtqrQwEwJHpJa7gD9gXaV2ESYktAy13s2uCjAxgRAeARBt6Ei357HlYLxqtOZ0XNUgAP6Ycnf4ryy3J20INz815e4BgA+YpTI=
Message-ID: <877aabc40802290254k2ecc559at2a3bc9740cd82ebc@mail.gmail.com>
Date: Fri, 29 Feb 2008 16:24:50 +0530
From: "Amit Shah" <amitshah@gmx.net>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: [PATCH] VIRTIO NET: Enable netpoll interface for netconsole logging
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 09a978be732a7c12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new poll_controller handler that the netpoll interface needs.

This enables netconsole logging from a kvm guest over the virtio
net interface.

Signed-off-by: Amit Shah <amitshah@gmx.net>
---
 drivers/net/virtio_net.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index fdc2367..3f3d334 100644
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
@@ -336,6 +345,9 @@ static int virtnet_probe(struct virtio_device *vdev)
 	dev->stop = virtnet_close;
 	dev->hard_start_xmit = start_xmit;
 	dev->features = NETIF_F_HIGHDMA;
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	dev->poll_controller = virtnet_netpoll;
+#endif
 	SET_NETDEV_DEV(dev, &vdev->dev);

 	/* Do we support "hardware" checksums? */
-- 
1.5.2.5

-- 
Amit Shah
http://www.amitshah.net/
