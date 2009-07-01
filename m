Return-Path: <linux-kernel-owner+w=401wt.eu-S1763091AbZGAAot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763091AbZGAAot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761090AbZGAAdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:33:06 -0400
Received: from kroah.org ([198.145.64.141]:59870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761048AbZGAAdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:33:04 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:52 2009
Message-Id: <20090701001552.820343714@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:14:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Alan Cox <alan@linux.intel.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 26/35] parport_pc: set properly the dma_mask for parport_pc device
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=parport_pc-set-properly-the-dma_mask-for-parport_pc-device.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit dfa7c4d869b7d3d37b70f1de856f2901b6ebfcf0 upstream.

parport_pc_probe_port() creates the own 'parport_pc' device if the
device argument is NULL. Then parport_pc_probe_port() doesn't
initialize the dma_mask and coherent_dma_mask of the device and calls
dma_alloc_coherent with it. dma_alloc_coherent fails because
dma_alloc_coherent() doesn't accept the uninitialized dma_mask:

http://lkml.org/lkml/2009/6/16/150

Long ago, X86_32 and X86_64 had the own dma_alloc_coherent
implementations; X86_32 accepted a device having dma_mask that is not
initialized however X86_64 didn't. When we merged them, we chose to
prohibit a device having dma_mask that is not initialized. I think
that it's good to require drivers to set up dma_mask (and
coherent_dma_mask) properly if the drivers want DMA.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reported-by: Malcom Blaney <malcolm.blaney@maptek.com.au>
Tested-by: Malcom Blaney <malcolm.blaney@maptek.com.au>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/parport/parport_pc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2211,6 +2211,9 @@ struct parport *parport_pc_probe_port (u
 		if (IS_ERR(pdev))
 			return NULL;
 		dev = &pdev->dev;
+
+		dev->coherent_dma_mask = DMA_BIT_MASK(24);
+		dev->dma_mask = &dev->coherent_dma_mask;
 	}
 
 	ops = kmalloc(sizeof (struct parport_operations), GFP_KERNEL);


