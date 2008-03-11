Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbYCKMHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbYCKMHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYCKMHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:07:16 -0400
Received: from ozlabs.org ([203.10.76.45]:45559 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbYCKMHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:07:15 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: [PATCH 3/4] virtio: handle > 2 billion page balloon targets
Date: Tue, 11 Mar 2008 23:05:23 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Jeremy Katz <katzj@redhat.com>
References: <200803112303.22984.rusty@rustcorp.com.au> <200803112304.21680.rusty@rustcorp.com.au>
In-Reply-To: <200803112304.21680.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112305.23648.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the host asks for a huge target towards_target() can overflow, and
we up oops as we try to release more pages than we have.  The simple
fix is to use a 64-bit value.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/virtio/virtio_balloon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -r fd0c80dbbd95 drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c	Tue Mar 11 09:21:00 2008 +1100
+++ b/drivers/virtio/virtio_balloon.c	Tue Mar 11 11:25:52 2008 +1100
@@ -152,7 +152,7 @@ static void virtballoon_changed(struct v
 	wake_up(&vb->config_change);
 }
 
-static inline int towards_target(struct virtio_balloon *vb)
+static inline s64 towards_target(struct virtio_balloon *vb)
 {
 	u32 v;
 	__virtio_config_val(vb->vdev,
@@ -176,7 +183,7 @@ static int balloon(void *_vballoon)
 
 	set_freezable();
 	while (!kthread_should_stop()) {
-		int diff;
+		s64 diff;
 
 		try_to_freeze();
 		wait_event_interruptible(vb->config_change,
