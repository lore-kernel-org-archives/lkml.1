Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbYDGEbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbYDGEbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 00:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbYDGEaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 00:30:52 -0400
Received: from ozlabs.org ([203.10.76.45]:39199 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYDGEav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 00:30:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Balaji Rao <balajirrao@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] virtio: remove overzealous BUG_ON.
Date: Mon, 7 Apr 2008 14:30:28 +1000
User-Agent: KMail/1.9.9
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071430.28399.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'disable_cb' callback is designed as an optimization to tell the host
we don't need callbacks now.  As it is not reliable, the debug check is
overzealous: it can happen on two CPUs at the same time.  Document this.

Even if it were reliable, the virtio_net driver doesn't disable
callbacks on transmit so the START_USE/END_USE debugging reentrance
protection can be easily tripped even on UP.

Thanks to Balaji Rao for the bug report and testing.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
CC: Balaji Rao <balajirrao@gmail.com>

diff -r 0b3e64be7696 drivers/virtio/virtio_ring.c
--- a/drivers/virtio/virtio_ring.c	Mon Apr 07 07:40:08 2008 +1000
+++ b/drivers/virtio/virtio_ring.c	Mon Apr 07 13:37:03 2008 +1000
@@ -214,10 +215,7 @@ static void vring_disable_cb(struct virt
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	START_USE(vq);
-	BUG_ON(vq->vring.avail->flags & VRING_AVAIL_F_NO_INTERRUPT);
 	vq->vring.avail->flags |= VRING_AVAIL_F_NO_INTERRUPT;
-	END_USE(vq);
 }
 
 static bool vring_enable_cb(struct virtqueue *_vq)
diff -r 0b3e64be7696 include/linux/virtio.h
--- a/include/linux/virtio.h	Mon Apr 07 07:40:08 2008 +1000
+++ b/include/linux/virtio.h	Mon Apr 07 13:37:03 2008 +1000
@@ -41,6 +41,8 @@ struct virtqueue
  *	Returns NULL or the "data" token handed to add_buf.
  * @disable_cb: disable callbacks
  *	vq: the struct virtqueue we're talking about.
+ *	Note that this is not necessarily synchronous, hence unreliable and only
+ *	useful as an optimization.
  * @enable_cb: restart callbacks after disable_cb.
  *	vq: the struct virtqueue we're talking about.
  *	This re-enables callbacks; it returns "false" if there are pending
@@ -48,7 +50,8 @@ struct virtqueue
  *	checking for more work, and enabling callbacks.
  *
  * Locking rules are straightforward: the driver is responsible for
- * locking.  No two operations may be invoked simultaneously.
+ * locking.  No two operations may be invoked simultaneously, with the exception
+ * of @disable_cb.
  *
  * All operations can be called in any context.
  */
