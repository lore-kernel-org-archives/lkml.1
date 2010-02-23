Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab0BWRBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:01:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492Ab0BWRBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:01:39 -0500
Date: Tue, 23 Feb 2010 18:57:43 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       markmc@redhat.com, gleb@redhat.com, herbert.xu@redhat.com,
       quintela@redhat.com, dlaor@redhat.com, avi@redhat.com
Subject: [PATCH 1/3] vhost: logging math fix
Message-ID: <51e0f786b06c198ab355abab19f0bd11ac6a167b.1266943453.git.mst@redhat.com>
References: <cover.1266943453.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1266943453.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vhost was dong some complex math to get
offset to log at, and got it wrong by a couple of bytes,
while in fact it's simple: get address where we write,
subtract start of buffer, add log base.

Do it this way.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 6eb1525..c767279 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1004,10 +1004,12 @@ int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
 	if (unlikely(vq->log_used)) {
 		/* Make sure data is seen before log. */
 		smp_wmb();
-		log_write(vq->log_base, vq->log_addr + sizeof *vq->used->ring *
-			  (vq->last_used_idx % vq->num),
-			  sizeof *vq->used->ring);
-		log_write(vq->log_base, vq->log_addr, sizeof *vq->used->ring);
+		log_write(vq->log_base,
+			  vq->log_addr + ((void *)used - (void *)vq->used),
+			  sizeof *used);
+		log_write(vq->log_base,
+			  vq->log_addr + offsetof(struct vring_used, idx),
+			  sizeof vq->used->idx);
 		if (vq->log_ctx)
 			eventfd_signal(vq->log_ctx, 1);
 	}
-- 
1.7.0.18.g0d53a5

