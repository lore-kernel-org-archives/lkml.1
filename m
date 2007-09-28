Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbXI1Pnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbXI1Pnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 11:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbXI1Pne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 11:43:34 -0400
Received: from [198.99.130.12] ([198.99.130.12]:40577 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbXI1Pnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 11:43:33 -0400
Date: Fri, 28 Sep 2007 11:43:14 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] UML - Fix locking in skb alloction failure fix
Message-ID: <20070928154314.GA7185@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add _irqsave/_irqrestore to the locking in update_drop_skb to keep
uml_net_rx out while the drop skb is being messed with.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/net_kern.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.22/arch/um/drivers/net_kern.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/net_kern.c	2007-09-28 11:10:19.000000000 -0400
+++ linux-2.6.22/arch/um/drivers/net_kern.c	2007-09-28 11:13:58.000000000 -0400
@@ -49,9 +49,10 @@ static int drop_max;
 static int update_drop_skb(int max)
 {
 	struct sk_buff *new;
+	unsigned long flags;
 	int err = 0;
 
-	spin_lock(&drop_lock);
+	spin_lock_irqsave(&drop_lock, flags);
 
 	if (max <= drop_max)
 		goto out;
@@ -68,7 +69,7 @@ static int update_drop_skb(int max)
 	drop_max = max;
 	err = 0;
 out:
-	spin_unlock(&drop_lock);
+	spin_unlock_irqrestore(&drop_lock, flags);
 
 	return err;
 }
