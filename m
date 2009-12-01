Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbZLACY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbZLACY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 21:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbZLACYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 21:24:24 -0500
Received: from ozlabs.org ([203.10.76.45]:40467 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbZLACYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 21:24:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adam Litke <agl@us.ibm.com>
Subject: Re: virtio: Add memory statistics reporting to the balloon driver (V4)
Date: Tue, 1 Dec 2009 12:54:22 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; i686; ; )
Cc: Anthony Liguori <anthony@codemonkey.ws>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1259597655.30369.2.camel@aglitke>
In-Reply-To: <1259597655.30369.2.camel@aglitke>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912011254.22861.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009 02:44:15 am Adam Litke wrote:
> Changes since V3:

OK, I applied this.  And here's the fixes I applied afterwards (to save YA
round trip: please ack and I'll fold them together)

virtio: balloon fixes

1) Tag and val args to update_stat() are no longer __le.
2) pages_to_bytes() should promote to u64 so we don't truncate.
3) Fix two checkpatch.pl warnings.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/virtio/virtio_balloon.c |    8 +++++---
 include/linux/virtio_balloon.h  |    3 +--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -158,14 +158,15 @@ static void leak_balloon(struct virtio_b
 }
 
 static inline void update_stat(struct virtio_balloon *vb, int idx,
-				__le16 tag, __le64 val)
+			       u16 tag, u64 val)
 {
 	BUG_ON(idx >= VIRTIO_BALLOON_S_NR);
 	vb->stats[idx].tag = tag;
 	vb->stats[idx].val = val;
 }
 
-#define pages_to_bytes(x) ((x) << PAGE_SHIFT)
+#define pages_to_bytes(x) ((u64)(x) << PAGE_SHIFT)
+
 static void update_balloon_stats(struct virtio_balloon *vb)
 {
 	unsigned long events[NR_VM_EVENT_ITEMS];
@@ -296,7 +297,8 @@ static int virtballoon_probe(struct virt
 		 * use it to signal us later.
 		 */
 		sg_init_one(&sg, vb->stats, sizeof vb->stats);
-		if (vb->stats_vq->vq_ops->add_buf(vb->stats_vq, &sg, 1, 0, vb) < 0)
+		if (vb->stats_vq->vq_ops->add_buf(vb->stats_vq,
+						  &sg, 1, 0, vb) < 0)
 			BUG();
 		vb->stats_vq->vq_ops->kick(vb->stats_vq);
 	}
diff --git a/include/linux/virtio_balloon.h b/include/linux/virtio_balloon.h
--- a/include/linux/virtio_balloon.h
+++ b/include/linux/virtio_balloon.h
@@ -28,8 +28,7 @@ struct virtio_balloon_config
 #define VIRTIO_BALLOON_S_MEMTOT   5   /* Total amount of memory */
 #define VIRTIO_BALLOON_S_NR       6
 
-struct virtio_balloon_stat
-{
+struct virtio_balloon_stat {
 	u16 tag;
 	u64 val;
 } __attribute__((packed));


