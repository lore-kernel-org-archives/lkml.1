Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbXKTQ2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbXKTQ2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 11:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbXKTQ2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 11:28:24 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:49393 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbXKTQ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 11:28:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=fy8PyiKHO+UF757G9m/Pvzv5d5hqgkXHvw8ebAsXJWWpIg2enM8AcrF/MeNNdfKSv/SoPsUIYRFkeEfbNL9AgJQqm/3vcAM072PhUiDXMHBqoXOdXj1KU9eDyWTbrcehIymllNTsew3nyy8ZqwflzgwFVgBiE6L2lqjHMphW+hs=
Message-ID: <cac0ab7d0711200828n3548fadn48cce2837ed6a7c6@mail.gmail.com>
Date: Tue, 20 Nov 2007 17:28:22 +0100
From: "Jonas Danielsson" <the.sator@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][v2] net/ipv4/arp.c: Fix arp reply when sender ip 0
Cc: "David Miller" <davem@davemloft.net>,
       "Alexey Kuznetsov" <kuznet@ms2.inr.ac.ru>, jmorris@namei.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix arp reply when received arp probe with sender ip 0.

Send arp reply with target ip address 0.0.0.0 and target hardware address
set to hardware address of requester. Previously sent reply with target
ip address and target hardware address set to same as source fields.


Signed-off-by: Jonas Danielsson <the.sator@gmail.com>
Acked-by: Alexey Kuznetov <kuznet@ms2.inr.ac.ru>
---
arp.c |    3 ++-
1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -828,7 +828,8 @@ static int arp_process(struct sk_buff *skb)
                if (arp->ar_op == htons(ARPOP_REQUEST) &&
                    inet_addr_type(tip) == RTN_LOCAL &&
                    !arp_ignore(in_dev,dev,sip,tip))
-
arp_send(ARPOP_REPLY,ETH_P_ARP,tip,dev,tip,sha,dev->dev_addr,dev->dev_addr);
+                       arp_send(ARPOP_REPLY, ETH_P_ARP, sip, dev, tip, sha,
+                                dev->dev_addr, sha);
                goto out;
        }
