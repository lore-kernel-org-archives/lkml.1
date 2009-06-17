Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZFQCPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZFQCPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 22:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZFQCPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 22:15:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:42359 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbZFQCPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 22:15:13 -0400
Date: Wed, 17 Jun 2009 11:15:01 +0900
To: alan@linux.intel.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       malcolm.blaney@maptek.com.au
Subject: [PATCH] parport_pc: set properly the dma_mask for parport_pc device
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090617111443B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 17 Jun 2009 11:15:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/parport/parport_pc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 151bf5b..1af57b7 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2271,6 +2271,9 @@ struct parport *parport_pc_probe_port(unsigned long int base,
 		if (IS_ERR(pdev))
 			return NULL;
 		dev = &pdev->dev;
+
+		dev->coherent_dma_mask = DMA_BIT_MASK(24);
+		dev->dma_mask = &dev->coherent_dma_mask;
 	}
 
 	ops = kmalloc(sizeof(struct parport_operations), GFP_KERNEL);
-- 
1.6.0.6

