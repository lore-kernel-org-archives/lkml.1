Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYHRWQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYHRWQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYHRWQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:16:13 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56349 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYHRWQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:16:12 -0400
From: Anthony Liguori <aliguori@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@qumranet.com>,
       virtualization@lists.linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Anthony Liguori <aliguori@us.ibm.com>
Subject: [PATCH] virtio_balloon: fix towards_target when deflating balloon
Date: Mon, 18 Aug 2008 17:15:31 -0500
Message-Id: <1219097731-1224-1-git-send-email-aliguori@us.ibm.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both v and vb->num_pages are u32 and unsigned int respectively.  If v is less
than vb->num_pages (and it is, when deflating the balloon), the result is a
very large 32-bit number.  Since we're returning a s64, instead of getting the
same negative number we desire, we get a very large positive number.

This handles the case where v < vb->num_pages and ensures we get a small,
negative, s64 as the result.

Rusty: please push this for 2.6.27-rc4.  It's probably appropriate for the
stable tree too as it will cause an unexpected OOM when ballooning.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index bfef604..bd3c384 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -158,7 +158,10 @@ static inline s64 towards_target(struct virtio_balloon *vb)
 	vb->vdev->config->get(vb->vdev,
 			      offsetof(struct virtio_balloon_config, num_pages),
 			      &v, sizeof(v));
-	return v - vb->num_pages;
+	if (v < vb->num_pages)
+		return -(s64)(vb->num_pages - v);
+	else
+		return v - vb->num_pages;
 }
 
 static void update_balloon_size(struct virtio_balloon *vb)
