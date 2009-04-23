Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZDWHNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZDWHNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZDWHNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:13:07 -0400
Received: from ozlabs.org ([203.10.76.45]:42455 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbZDWHNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:13:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] virtio-rng: Remove false BUG for spurious callbacks
Date: Thu, 23 Apr 2009 16:42:59 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Christian Borntraeger <borntraeger@de.ibm.com>, stable@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904231642.59939.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

The virtio-rng drivers checks for spurious callbacks. Since
callbacks can be implemented via shared interrupts (e.g. PCI) this
could lead to guest kernel oopses with lots of virtio devices.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 drivers/char/hw_random/virtio-rng.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/char/hw_random/virtio-rng.c
===================================================================
--- linux-2.6.orig/drivers/char/hw_random/virtio-rng.c
+++ linux-2.6/drivers/char/hw_random/virtio-rng.c
@@ -37,9 +37,9 @@ static void random_recv_done(struct virt
 {
 	int len;
 
-	/* We never get spurious callbacks. */
+	/* We can get spurious callbacks, e.g. shared IRQs + virtio_pci. */
 	if (!vq->vq_ops->get_buf(vq, &len))
-		BUG();
+		return;
 
 	data_left = len / sizeof(random_data[0]);
 	complete(&have_data);
