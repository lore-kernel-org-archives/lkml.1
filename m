Return-Path: <linux-kernel-owner+w=401wt.eu-S933626AbZIPWr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626AbZIPWr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760305AbZIPWrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:47:00 -0400
Received: from kroah.org ([198.145.64.141]:48919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760295AbZIPWjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:39:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:14 2009
Message-Id: <20090916223714.254153168@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bart Van Assche <bart.vanassche@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [patch 07/45] SCSI: libsrp: fix memory leak in srp_ring_free()
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=scsi-libsrp-fix-memory-leak-in-srp_ring_free.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bart Van Assche <bart.vanassche@gmail.com>

commit afffd3dabe5209882c8cc59a373a4d33b5db304a upstream.

This patch fixes a memory leak in the libsrp function srp_ring_free().
It is not documented whether or not this function should free the ring
pointer itself. But the source code of the callers of this function
(srp_target_alloc() and srp_target_free()) makes it clear that
srp_ring_free() should deallocate the ring pointer itself. Furthermore,
the patch below makes srp_ring_free() deallocate all memory allocated by
srp_ring_alloc().

This patch affects the ibmvstgt driver, which is the only in-tree driver
that calls the srp_ring_free() function (indirectly).

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libsrp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -124,6 +124,7 @@ static void srp_ring_free(struct device 
 		dma_free_coherent(dev, size, ring[i]->buf, ring[i]->dma);
 		kfree(ring[i]);
 	}
+	kfree(ring);
 }
 
 int srp_target_alloc(struct srp_target *target, struct device *dev,


