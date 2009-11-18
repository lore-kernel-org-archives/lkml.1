Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbZKRDUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbZKRDUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 22:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbZKRDUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 22:20:18 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:1742 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbZKRDUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 22:20:17 -0500
Date: Tue, 17 Nov 2009 20:20:22 -0700
From: Alex Chiang <achiang@hp.com>
To: jens.axboe@oracle.com
Cc: Don Brace <brace@beardog.cce.hp.com>,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] cciss: change Cmd_sg_list.sg_chain_dma type to dma_addr_t
Message-ID: <20091118032022.GA6648@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent commit broke the ia64 build:

	Author: Don Brace <brace@beardog.cce.hp.com>
	Date:   Thu Nov 12 12:50:01 2009 -0600

	cciss: Add enhanced scatter-gather support.

because of this hunk:

	--- a/drivers/block/cciss.h
	+++ b/drivers/block/cciss.h
	+struct Cmd_sg_list {
	+       SGDescriptor_struct     *sgchain;
	+       dma64_addr_t            sg_chain_dma;
	+       int                     chain_block_size;
	+};

The issue is that dma64_addr_t isn't #define'd on ia64.

The way that we're using Cmd_sg_list.sg_chain_dma is to hold an
address returned from pci_map_single().

	+               temp64.val = pci_map_single(h->pdev,
	+                                 h->cmd_sg_list[c->cmdindex]->sgchain,
	+                                 len, dir);
	+
	+               h->cmd_sg_list[c->cmdindex]->sg_chain_dma = temp64.val;

pci_map_single() returns a dma_addr_t too.

This code will still work even on a 32-bit x86 build, where
dma_addr_t is defined to be a u32 because it will simply be
promoted to the __u64 that temp64.val is defined as.

Thus, declaring Cmd_sg_list.sg_chain_dma as dma_addr_t is safe.

Cc: Don Brace <brace@beardog.cce.hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
This changelog is probably an analysis overkill, but I was
concerned about 32 vs 64 bit DMA addresses getting passed to the
hardware. After doing a bunch more reading, I'm satisfied that a)
we're dealing with CPU-side addresses and b) proper type
promotion occurs anyway.

If anyone wants to double-check my work, I won't be offended. ;)

I build tested this on ia64, x86_64, and i386. No gcc nor sparse
warnings. However, I didn't do any run-time testing on i386.
---
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index e5c63e5..1d95db2 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -57,7 +57,7 @@ typedef struct _drive_info_struct
 
 struct Cmd_sg_list {
 	SGDescriptor_struct	*sgchain;
-	dma64_addr_t		sg_chain_dma;
+	dma_addr_t		sg_chain_dma;
 	int			chain_block_size;
 };
 
