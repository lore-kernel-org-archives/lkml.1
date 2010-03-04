Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab0CDVKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:10:38 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:50977 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab0CDVKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:10:36 -0500
Date: Thu, 4 Mar 2010 16:10:14 -0500
From: Jeff Dike <jdike@addtoit.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Xin Xiaohui <xiaohui.xin@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] vhost - Fix error path in vhost_net_set_backend
Message-ID: <20100304211014.GA10008@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7bee327f8020f81a52ecb362f1fec7a4494dc98b
Author: Jeff Dike <jdike@localhost.localdomain>
Date:   Thu Mar 4 14:48:38 2010 -0500

    Fix vhost_net_set_backend error path
    
    An error could cause vhost_net_set_backend to exit without unlocking
    vq->mutex.
    
    Signed-off-by: Jeff Dike <jdike@linux.intel.com>

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index ad37da2..4ada4b4 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -508,12 +508,12 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	/* Verify that ring has been setup correctly. */
 	if (!vhost_vq_access_ok(vq)) {
 		r = -EFAULT;
-		goto err;
+		goto err_unlock_vq;
 	}
 	sock = get_socket(fd);
 	if (IS_ERR(sock)) {
 		r = PTR_ERR(sock);
-		goto err;
+		goto err_unlock_vq;
 	}
 
 	/* start polling new socket */
@@ -524,12 +524,14 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	vhost_net_disable_vq(n, vq);
 	rcu_assign_pointer(vq->private_data, sock);
 	vhost_net_enable_vq(n, vq);
-	mutex_unlock(&vq->mutex);
 done:
 	if (oldsock) {
 		vhost_net_flush_vq(n, index);
 		fput(oldsock->file);
 	}
+
+err_unlock_vq:
+	mutex_unlock(&vq->mutex);
 err:
 	mutex_unlock(&n->dev.mutex);
 	return r;
