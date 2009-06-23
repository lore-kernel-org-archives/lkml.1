Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbZFWOlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbZFWOlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758167AbZFWOlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:41:16 -0400
Received: from www.tglx.de ([62.245.132.106]:56438 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757112AbZFWOlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:41:15 -0400
Date: Tue, 23 Jun 2009 16:41:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Wilcox <matthew@wil.cx>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] dmapools: protect page_list walk in show_pools()
Message-ID: <alpine.LFD.2.00.0906231634210.2767@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

show_pools() walks the page_list of a pool w/o protection against the
list modifications in alloc/free. Take pool->lock to avoid stomping
into nirvana.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
diff --git a/mm/dmapool.c b/mm/dmapool.c
index b1f0885..3df0637 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -86,10 +86,12 @@ show_pools(struct device *dev, struct device_attribute *attr, char *buf)
 		unsigned pages = 0;
 		unsigned blocks = 0;
 
+		spin_lock_irq(&pool->lock);
 		list_for_each_entry(page, &pool->page_list, page_list) {
 			pages++;
 			blocks += page->in_use;
 		}
+		spin_unlock_irq(&pool->lock);
 
 		/* per-pool info, no real statistics yet */
 		temp = scnprintf(next, size, "%-16s %4u %4Zu %4Zu %2u\n",



