Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab0CDVKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:10:54 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:50981 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab0CDVKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:10:52 -0500
Date: Thu, 4 Mar 2010 16:10:14 -0500
From: Jeff Dike <jdike@addtoit.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Xin Xiaohui <xiaohui.xin@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] vhost - cleanup
Message-ID: <20100304211014.GA7882@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 1191aa42193d030470dbd4ab17e4fb57772534ff
Author: Jeff Dike <jdike@localhost.localdomain>
Date:   Thu Mar 4 14:51:20 2010 -0500

    Delete a label and goto from vhost_net_set_backend
    
    Inverting a test allows a label and goto to be eliminated.
    
    Signed-off-by: Jeff Dike <jdike@linux.intel.com>

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 4ada4b4..7abb883 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -518,13 +518,12 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 
 	/* start polling new socket */
 	oldsock = vq->private_data;
-	if (sock == oldsock)
-		goto done;
+	if (sock != oldsock){
+                vhost_net_disable_vq(n, vq);
+                rcu_assign_pointer(vq->private_data, sock);
+                vhost_net_enable_vq(n, vq);
+	}
 
-	vhost_net_disable_vq(n, vq);
-	rcu_assign_pointer(vq->private_data, sock);
-	vhost_net_enable_vq(n, vq);
-done:
 	if (oldsock) {
 		vhost_net_flush_vq(n, index);
 		fput(oldsock->file);
