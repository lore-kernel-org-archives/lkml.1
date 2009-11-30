Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZK3IPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZK3IPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZK3IPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:15:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51465
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753040AbZK3IPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:15:35 -0500
Date: Mon, 30 Nov 2009 00:15:41 -0800 (PST)
Message-Id: <20091130.001541.134590904.davem@davemloft.net>
To: andi@lisas.de
Cc: zambrano@broadcom.com, dave@thedillows.org, mb@bu3sch.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b44.c box lockup fix (netconsole): ratelimit NAPI poll
 error message
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091125213546.GA6168@rhlx01.hs-esslingen.de>
References: <20091125213546.GA6168@rhlx01.hs-esslingen.de>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Mohr <andi@lisas.de>
Date: Wed, 25 Nov 2009 22:35:46 +0100

> See
> http://bugzilla.kernel.org/show_bug.cgi?id=14691
> for background information.

The patch below is what I'll check in to fix this, thanks.

As for the r8169 side, that case is much more complicated
to fix.  That driver messes with the interrupt masking
before the NAPI schedule check, instead of after it's
sure that NAPI isn't already scheduled like b44 does.

Therefore we might need to undo that programming or move
it into the code block where __napi_schedule() is actually
invoked.

I'll queue this b44 patch up for -stable too.

b44: Fix wedge when using netconsole.

Fixes kernel bugzilla #14691

Due to the way netpoll works, it is perfectly legal to see
NAPI already scheduled when new device events are pending
in b44_interrupt().

So logging a message about it is wrong and in fact harmful.

Based upon a patch by Andreas Mohr.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/b44.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index e046943..2a91323 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -912,9 +912,6 @@ static irqreturn_t b44_interrupt(int irq, void *dev_id)
 			bp->istat = istat;
 			__b44_disable_ints(bp);
 			__napi_schedule(&bp->napi);
-		} else {
-			printk(KERN_ERR PFX "%s: Error, poll already scheduled\n",
-			       dev->name);
 		}
 
 irq_ack:
-- 
1.6.5

