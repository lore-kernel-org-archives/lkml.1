Return-Path: <linux-kernel-owner+w=401wt.eu-S935982AbZLQBbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935982AbZLQBbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763646AbZLQBUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:20:46 -0500
Received: from kroah.org ([198.145.64.141]:48045 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763587AbZLQBUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:39 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:05 2009
Message-Id: <20091217011605.149734203@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Eric Miao <eric.y.miao@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [55/90] NET: smc91x: Fix irq flags
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Russell King - ARM Linux <linux@arm.linux.org.uk>

[ Upstream commit d5ccd67bb77ced5249067d05171992a7d5020393 ]

smc91x.h defines SMC_IRQ_FLAGS to be -1 when it wants the interrupt
flags to be taken from the resource structure.  However, d280ead
changed this to checking for non-zero resource flags.

Unfortunately, this means that on some platforms, we end up passing
'-1' to request_irq rather than the desired result.  Combine the two
conditions into one so that the IRQ flags are taken from the resource
if either SMC_IRQ_FLAGS is -1 or the resource flags specify an
interrupt trigger.

This restores network on at least the Versatile platform.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/smc91x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/smc91x.c
+++ b/drivers/net/smc91x.c
@@ -2283,7 +2283,7 @@ static int __devinit smc_drv_probe(struc
 
 	ndev->irq = ires->start;
 
-	if (ires->flags & IRQF_TRIGGER_MASK)
+	if (irq_flags == -1 || ires->flags & IRQF_TRIGGER_MASK)
 		irq_flags = ires->flags & IRQF_TRIGGER_MASK;
 
 	ret = smc_request_attrib(pdev, ndev);


