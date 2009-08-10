Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbZHJUFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbZHJUFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZHJUFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:05:12 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40440 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbZHJUFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:05:10 -0400
Subject: [PATCH] fix memory leak in virtio_net
From: Shirley Ma <mashirle@us.ibm.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-Why0umBOxGz2UWiN5Nja"
Date: Mon, 10 Aug 2009 13:05:08 -0700
Message-Id: <1249934708.7400.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Why0umBOxGz2UWiN5Nja
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Whild reading virtio code, I found some memory leak in removing
virtio_net.

In virtnet_remove, only skb has been freed not the pages in skb
frags. Here is the patch to fix this, please review it.

Signed-off-by: Shirley Ma <xma@us.ibm.com>

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2a6e81d..7e629d9 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -978,6 +978,7 @@ static void virtnet_remove(struct virtio_device *vdev)
 
 	/* Free our skbs in send and recv queues, if any. */
 	while ((skb = __skb_dequeue(&vi->recv)) != NULL) {
+		trim_pages(vi, skb);
 		kfree_skb(skb);
 		vi->num--;
 	}





--=-Why0umBOxGz2UWiN5Nja
Content-Disposition: attachment; filename="memleak.patch"
Content-Type: text/x-patch; name="memleak.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Signed-off-by: Shirley Ma <xma@us.ibm.com>

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2a6e81d..7e629d9 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -978,6 +978,7 @@ static void virtnet_remove(struct virtio_device *vdev)
 
 	/* Free our skbs in send and recv queues, if any. */
 	while ((skb = __skb_dequeue(&vi->recv)) != NULL) {
+		trim_pages(vi, skb);
 		kfree_skb(skb);
 		vi->num--;
 	}

--=-Why0umBOxGz2UWiN5Nja--

