Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbZKFWXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbZKFWXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbZKFWXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:00 -0500
Received: from kroah.org ([198.145.64.141]:56877 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760112AbZKFWW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:58 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:44 2009
Message-Id: <20091106221544.780625234@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [45/99] virtio: order used ring after used index read
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=virtio-order-used-ring-after-used-index-read.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael S. Tsirkin <mst@redhat.com>

commit 2d61ba95034f1abbdec7729d52c740870a5eddb6 upstream.

On SMP guests, reads from the ring might bypass used index reads. This
causes guest crashes because host writes to used index to signal ring
data readiness.  Fix this by inserting rmb before used ring reads.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/virtio/virtio_ring.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -281,6 +281,9 @@ static void *vring_get_buf(struct virtqu
 		return NULL;
 	}
 
+	/* Only get used array entries after they have been exposed by host. */
+	rmb();
+
 	i = vq->vring.used->ring[vq->last_used_idx%vq->vring.num].id;
 	*len = vq->vring.used->ring[vq->last_used_idx%vq->vring.num].len;
 


