Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbZIDEfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbZIDEfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 00:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZIDEfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 00:35:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39184
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755300AbZIDEe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 00:34:58 -0400
Date: Thu, 03 Sep 2009 21:35:13 -0700 (PDT)
Message-Id: <20090903.213513.114274532.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       roel.kluin@gmail.com, netdev@vger.kernel.org
Subject: Re: linux-next: net tree build warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090904142846.02ad1b23.sfr@canb.auug.org.au>
References: <20090904142846.02ad1b23.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 4 Sep 2009 14:28:46 +1000

> Today's linux-next build (x86_64 allmodconfig gcc-4.4.0) produced this
> warning:

Thanks, just pushed the following out:

WAN: dscc4: Fix warning pointing out a bug.

Noticed by Stephen Rothwell:

	Today's linux-next build (x86_64 allmodconfig gcc-4.4.0)
	produced this warning:

	drivers/net/wan/dscc4.c: In function 'dscc4_rx_skb':
	drivers/net/wan/dscc4.c:670: warning: suggest parentheses around comparison in operand of '|'

	which actually points out a bug, I think.  It is doing
		(x & (y | z)) != y | z
	when it probably means
		(x & (y | z)) != (y | z)

	Introduced by commit 5de3fcab91b0e1809eec030355d15801daf25083
	("WAN: bit and/or confusion").

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/wan/dscc4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wan/dscc4.c b/drivers/net/wan/dscc4.c
index b2247bd..81c8aec 100644
--- a/drivers/net/wan/dscc4.c
+++ b/drivers/net/wan/dscc4.c
@@ -667,7 +667,7 @@ static inline void dscc4_rx_skb(struct dscc4_dev_priv *dpriv,
 		else if (!(skb->data[pkt_len] & FrameCrc))
 			dev->stats.rx_crc_errors++;
 		else if ((skb->data[pkt_len] & (FrameVfr | FrameRab)) !=
-				FrameVfr | FrameRab)
+			 (FrameVfr | FrameRab))
 			dev->stats.rx_length_errors++;
 		dev->stats.rx_errors++;
 		dev_kfree_skb_irq(skb);
-- 
1.6.4.2

