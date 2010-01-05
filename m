Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699Ab0AEAoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0AEAoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858Ab0AEAoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:44:13 -0500
Received: from kroah.org ([198.145.64.141]:34485 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab0AEAfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:47 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Roger Oksanen <roger.oksanen@cs.helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 65/97] e100: Fix broken cbs accounting due to missing memset.
Date: Mon,  4 Jan 2010 16:33:18 -0800
Message-Id: <1262651630-7354-65-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index d269a68..0c53c92 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -1817,6 +1817,7 @@ static int e100_alloc_cbs(struct nic *nic)
 				  &nic->cbs_dma_addr);
 	if (!nic->cbs)
 		return -ENOMEM;
+	memset(nic->cbs, 0, count * sizeof(struct cb));
 
 	for (cb = nic->cbs, i = 0; i < count; cb++, i++) {
 		cb->next = (i + 1 < count) ? cb + 1 : nic->cbs;
@@ -1825,7 +1826,6 @@ static int e100_alloc_cbs(struct nic *nic)
 		cb->dma_addr = nic->cbs_dma_addr + i * sizeof(struct cb);
 		cb->link = cpu_to_le32(nic->cbs_dma_addr +
 			((i+1) % count) * sizeof(struct cb));
-		cb->skb = NULL;
 	}
 
 	nic->cb_to_use = nic->cb_to_send = nic->cb_to_clean = nic->cbs;
-- 
1.6.6

