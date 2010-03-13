Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935946Ab0CMA5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:57:42 -0500
Received: from kroah.org ([198.145.64.141]:46822 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935307Ab0CMAbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:16 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:08 2010
Message-Id: <20100313002708.825421266@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>,
       Ajit Khaparde <ajitk@serverengines.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [041/145] net: bug fix for vlan + gro issue
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Ajit Khaparde <ajitk@serverengines.com>

[ Upstream commit e76b69cc0133952c98aa1ad6330cacacd269fd64 ]

Traffic (tcp) doesnot start on a vlan interface when gro is enabled.
Even the tcp handshake was not taking place.
This is because, the eth_type_trans call before the netif_receive_skb
in napi_gro_finish() resets the skb->dev to napi->dev from the previously
set vlan netdev interface. This causes the ip_route_input to drop the
incoming packet considering it as a packet coming from a martian source.

I could repro this on 2.6.32.7 (stable) and 2.6.33-rc7.
With this fix, the traffic starts and the test runs fine on both vlan
and non-vlan interfaces.

CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: Patrick McHardy <kaber@trash.net>
Signed-off-by: Ajit Khaparde <ajitk@serverengines.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2630,7 +2630,7 @@ int napi_frags_finish(struct napi_struct
 	switch (ret) {
 	case GRO_NORMAL:
 	case GRO_HELD:
-		skb->protocol = eth_type_trans(skb, napi->dev);
+		skb->protocol = eth_type_trans(skb, skb->dev);
 
 		if (ret == GRO_NORMAL)
 			return netif_receive_skb(skb);


