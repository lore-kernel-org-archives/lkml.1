Return-Path: <linux-kernel-owner+w=401wt.eu-S1765038AbXHASbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765038AbXHASbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759187AbXHASbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:31:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57578 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465AbXHASbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:31:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 1 Aug 2007 20:30:36 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.22: oops in sbp2_remove_device
To: Olaf Hering <olh@suse.de>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070801175718.GA19589@suse.de>
Message-ID: <tkrat.f4fe19cd6ad9843d@s5r6.in-berlin.de>
References: <20070801175718.GA19589@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On  1 Aug, Olaf Hering wrote:
> This happens when attaching a firewire disk (momobay) to a single cpu
> G5. I suspect there are two bugs, one is the error handling and one is
> the DMA mask setting.
> 
> ieee1394: Node added: ID:BUS[0-00:1023]  GUID[00010410100036e0]
> ieee1394: Host added: ID:BUS[0-01:1023]  GUID[000a95fffea65d66]
> ReiserFS: sdb4: Using r5 hash to sort names
> ieee1394: sbp2: failed to set 4GB DMA mask
> Unable to handle kernel paging request for data at address 0x00000000
> ...
> NIP [d0000000002b48dc] .sbp2_remove_device+0x78/0x498 [sbp2]
> LR [d0000000002b48c8] .sbp2_remove_device+0x64/0x498 [sbp2]
> Call Trace:
> [c00000000f1a3670] [d0000000002b48c8] .sbp2_remove_device+0x64/0x498 [sbp2] (unreliable)
> [c00000000f1a3730] [d0000000002b5f38] .sbp2_probe+0x77c/0x7d4 [sbp2]
> [c00000000f1a37e0] [c0000000002ca2a0] .driver_probe_device+0x13c/0x200


I have now idea why dma_set_mask failed, nor do I see where the
subsequent oops came from.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: revert "sbp2: enforce 32bit DMA mapping"

Revert commit 0555659d63c285ceb7ead3115532e1b71b0f27a7 from 2.6.22-rc1.
The dma_set_mask call somehow failed on a PowerMac G5, PPC64:
http://lkml.org/lkml/2007/8/1/344

Should there ever occur a DMA mapping beyond the physical DMA range, a
proper SBP-2 firmware will report transport errors.  So let's leave it
at that.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |    5 -----
 1 file changed, 5 deletions(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -773,11 +773,6 @@ static struct sbp2_lu *sbp2_alloc_device
 			SBP2_ERR("failed to register lower 4GB address range");
 			goto failed_alloc;
 		}
-#else
-		if (dma_set_mask(hi->host->device.parent, DMA_32BIT_MASK)) {
-			SBP2_ERR("failed to set 4GB DMA mask");
-			goto failed_alloc;
-		}
 #endif
 	}
 


-- 
Stefan Richter
-=====-=-=== =--- ----=
http://arcgraph.de/sr/

