Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbZC0WyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbZC0WyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbZC0Wx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:53:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37013
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755878AbZC0Wx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:53:58 -0400
Date: Fri, 27 Mar 2009 15:53:46 -0700 (PDT)
Message-Id: <20090327.155346.98210435.davem@davemloft.net>
To: linux@rainbow-software.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Network died completely in 2.6.29
From: David Miller <davem@davemloft.net>
In-Reply-To: <200903272351.37610.linux@rainbow-software.org>
References: <200903272351.37610.linux@rainbow-software.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>
Date: Fri, 27 Mar 2009 23:51:36 +0100

> upgraded to 2.6.29 today. It appeared to work fine for a couple of hours. But 
> suddenly the network stopped. I wasn't even able to ping my local IP. Even 
> pinging 127.0.0.1 did not work. There were no errors in dmesg and the system 
> appeared to work fine otherwise. Had to reboot (into 2.6.28).
> 
> Never seen this before. Anyone with the same problem?

It's a known problem, the following fix will be submitted
to 2.6.29.1 over the weekend.

GRO: Disable GRO on legacy netif_rx path

When I fixed the GRO crash in the legacy receive path I used
napi_complete to replace __napi_complete.  Unfortunately they're
not the same when NETPOLL is enabled, which may result in us
not calling __napi_complete at all.

What's more, we really do need to keep the __napi_complete call
within the IRQ-off section since in theory an IRQ can occur in
between and fill up the backlog to the maximum, causing us to
lock up.

Since we can't seem to find a fix that works properly right now,
this patch reverts all the GRO support from the netif_rx path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/core/dev.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 052dd47..63ec4bf 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2627,18 +2627,15 @@ static int process_backlog(struct napi_struct *napi, int quota)
 		local_irq_disable();
 		skb = __skb_dequeue(&queue->input_pkt_queue);
 		if (!skb) {
+			__napi_complete(napi);
 			local_irq_enable();
-			napi_complete(napi);
-			goto out;
+			break;
 		}
 		local_irq_enable();
 
-		napi_gro_receive(napi, skb);
+		netif_receive_skb(skb);
 	} while (++work < quota && jiffies == start_time);
 
-	napi_gro_flush(napi);
-
-out:
 	return work;
 }
 
-- 
1.6.2.1.222.g570cc

