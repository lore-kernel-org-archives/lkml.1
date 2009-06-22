Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbZFVO4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbZFVO4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757014AbZFVO4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:56:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56618 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756971AbZFVOz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:55:59 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] parport_pc: set properly the dma_mask for parport_pc
	device
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 16:54:27 +0100
Message-ID: <20090622155349.17809.246.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090622154702.17809.58975.stgit@t61.ukuu.org.uk>
References: <20090622154702.17809.58975.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

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
Cc: stable@kernel.org
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/parport/parport_pc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 7f1cca7..1032d5f 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2290,6 +2290,9 @@ struct parport *parport_pc_probe_port(unsigned long int base,
 		if (IS_ERR(pdev))
 			return NULL;
 		dev = &pdev->dev;
+
+		dev->coherent_dma_mask = DMA_BIT_MASK(24);
+		dev->dma_mask = &dev->coherent_dma_mask;
 	}
 
 	ops = kmalloc(sizeof(struct parport_operations), GFP_KERNEL);

