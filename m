Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbYFRCOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbYFRCOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 22:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759488AbYFRCOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 22:14:14 -0400
Received: from [219.93.2.80] ([219.93.2.80]:55396 "EHLO nav6.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759259AbYFRCOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 22:14:14 -0400
Message-ID: <48586F4B.4060404@nav6.org>
Date: Wed, 18 Jun 2008 10:13:31 +0800
From: Ang Way Chuang <wcang@nav6.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: maxk@qualcomm.com, steve.zabele@baesystems.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET: Proper handling of IPv6 header in tun driver when
 TUN_NO_PI is set
References: <4849162D.7000401@nav6.org>	<48499C32.6070703@qualcomm.com> <20080617.163205.160864233.davem@davemloft.net>
In-Reply-To: <20080617.163205.160864233.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Max Krasnyanskiy <maxk@qualcomm.com>
> Date: Fri, 06 Jun 2008 13:21:06 -0700
> 
>> Acked-by: Max Krasnyansky <maxk@qualcomm.com>
>>
>> Dave, can you please add this patch to your tree.
> 
> I can't, the patch is severely whitespace damaged.
> 
Resend. Hopefully Thunderbird won't screw this time.

By default, tun.c running in TUN_TUN_DEV mode will set the protocol of packet
to IPv4 if TUN_NO_PI is set. My program failed to work when I assumed that
the driver will check the first nibble of packet, determine IP version and set
the appropriate protocol.

Signed-off-by: Ang Way Chuang <wcang@nav6.org>
---

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 0ce07a3..f97bb9b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -313,6 +313,21 @@ static __inline__ ssize_t tun_get_user(struct tun_struct *tun, struct iovec *iv,

        switch (tun->flags & TUN_TYPE_MASK) {
        case TUN_TUN_DEV:
+                if (tun->flags & TUN_NO_PI) {
+                        switch (skb->data[0] & 0xf0) {
+                        case 0x40:
+                                pi.proto = htons(ETH_P_IP);
+                                break;
+                        case 0x60:
+                                pi.proto = htons(ETH_P_IPV6);
+                                break;
+                        default:
+                                tun->dev->stats.rx_dropped++;
+                                kfree_skb(skb);
+                                return -EINVAL;
+                        }
+                }
+
                skb_reset_mac_header(skb);
                skb->protocol = pi.proto;
                skb->dev = tun->dev;

--
