Return-Path: <linux-kernel-owner+w=401wt.eu-S1751763AbYDXE4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbYDXE4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 00:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbYDXEz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 00:55:58 -0400
Received: from ozlabs.org ([203.10.76.45]:58748 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488AbYDXEz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 00:55:56 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 23 Apr 2008 23:55:47 -0500
Cc: virtualization@lists.linux-foundation.org
Subject: [PATCH 1/6] virtio: ignore corrupted virtqueues rather than spinning.
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241455.47462.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A corrupt virtqueue (caused by the other end screwing up) can have
strange results such as a driver spinning: just bail when we try to
get a buffer from a known-broken queue.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/virtio/virtio_ring.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -r cbd83e592664 drivers/virtio/virtio_ring.c
--- a/drivers/virtio/virtio_ring.c	Fri Apr 04 22:42:47 2008 +1100
+++ b/drivers/virtio/virtio_ring.c	Sat Apr 05 21:12:42 2008 +1100
@@ -184,6 +184,11 @@ static void *vring_get_buf(struct virtqu
 
 	START_USE(vq);
 
+	if (unlikely(vq->broken)) {
+		END_USE(vq);
+		return NULL;
+	}
+
 	if (!more_used(vq)) {
 		pr_debug("No more buffers in queue\n");
 		END_USE(vq);

