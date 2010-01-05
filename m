Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737Ab0AEULg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab0AEULg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516Ab0AEULa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:11:30 -0500
Received: from kroah.org ([198.145.64.141]:49993 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477Ab0AEUGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:14 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:01 2010
Message-Id: <20100105200301.581029574@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Roger Oksanen <roger.oksanen@cs.helsinki.fi>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [20/39] e100: Fix broken cbs accounting due to missing memset.
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roger Oksanen <roger.oksanen@cs.helsinki.fi>

commit 70abc8cb90e679d8519721e2761d8366a18212a6 upstream.

Alan Stern noticed that e100 caused slab corruption.
commit 98468efddb101f8a29af974101c17ba513b07be1 changed
the allocation of cbs to use dma pools that don't return zeroed memory,
especially the cb->status field used to track which cb to clean, causing
(the visible) double freeing of skbs and a wrong free cbs count.

Now the cbs are explicitly zeroed at allocation time.

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e100.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -1803,6 +1803,7 @@ static int e100_alloc_cbs(struct nic *ni
 				  &nic->cbs_dma_addr);
 	if (!nic->cbs)
 		return -ENOMEM;
+	memset(nic->cbs, 0, count * sizeof(struct cb));
 
 	for (cb = nic->cbs, i = 0; i < count; cb++, i++) {
 		cb->next = (i + 1 < count) ? cb + 1 : nic->cbs;
@@ -1811,7 +1812,6 @@ static int e100_alloc_cbs(struct nic *ni
 		cb->dma_addr = nic->cbs_dma_addr + i * sizeof(struct cb);
 		cb->link = cpu_to_le32(nic->cbs_dma_addr +
 			((i+1) % count) * sizeof(struct cb));
-		cb->skb = NULL;
 	}
 
 	nic->cb_to_use = nic->cb_to_send = nic->cb_to_clean = nic->cbs;


