Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbYIULBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbYIULBp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 07:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYIULBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 07:01:38 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53063 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbYIULBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 07:01:36 -0400
Date: Sun, 21 Sep 2008 13:01:31 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: paulus@samba.org, benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] arch/powerpc/platforms/powermac/pic.c: move of_node_put
Message-ID: <Pine.LNX.4.64.0809211301030.7450@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

It seems better to dereference master before decrementing the reference
count rather than afterwards.

The problem was found using the following semantic match:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
expression n,E;
identifier fld;
iterator I;
statement S;
@@

* of_node_put(n)
... when != n = E
    when != I(n,...) S
* n->fld
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

 arch/powerpc/platforms/powermac/pic.c          |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 6d149ae..d17aa2b 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -395,10 +395,10 @@ static void __init pmac_pic_probe_oldstyle(void)
 	if (max_real_irqs > 32)
 		pmac_irq_hw[i++] = (volatile struct pmac_irq_hw __iomem *)
 			(addr + 0x10);
-	of_node_put(master);
 
 	printk(KERN_INFO "irq: Found primary Apple PIC %s for %d irqs\n",
 	       master->full_name, max_real_irqs);
+	of_node_put(master);
 
 	/* Map interrupts of cascaded controller */
 	if (slave && !of_address_to_resource(slave, 0, &r)) {
