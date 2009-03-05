Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZCEJI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZCEJI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 04:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZCEJIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 04:08:10 -0500
Received: from stinky.trash.net ([213.144.137.162]:62015 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZCEJII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 04:08:08 -0500
Message-ID: <49AF9672.50200@trash.net>
Date: Thu, 05 Mar 2009 10:08:02 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: blaschka@linux.vnet.ibm.com, bart@jukie.net, greearb@candelatech.com,
       shemminger@vyatta.com, dada1@cosmosbay.com, frank.blaschka@de.ibm.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.29-rc* QinQ vlan trunking regression
References: <49AF87D6.5040104@linux.vnet.ibm.com>	<49AF8CE0.6030301@trash.net>	<20090305.005646.115456407.davem@davemloft.net> <20090305.005934.130220849.davem@davemloft.net>
In-Reply-To: <20090305.005934.130220849.davem@davemloft.net>
Content-Type: multipart/mixed;
 boundary="------------020003080003040006090208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020003080003040006090208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 05 Mar 2009 00:56:46 -0800 (PST)
>
>   
>> Then bond_neigh_setup() has the same bug, doesn't it?
>>     

Indeed. But this seems to be the last one.
>
> Looking at the bond_main.c changes in:
>
> commit 008298231abbeb91bc7be9e8b078607b816d1a4a
> Author: Stephen Hemminger <shemminger@vyatta.com>
> Date:   Thu Nov 20 20:14:53 2008 -0800
>
>     netdev: add more functions to netdevice ops
>
> shows that it always behaved that way.
>   

Yes, but that patch introduced the requirement to pass the correct
device down since now the handlers need it to get to the ops of the
underlying device. Previously they all relied on the handlers not
using their private data.

Signed-off-by: Patrick McHardy <kaber@trash.net>

--------------020003080003040006090208
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 9fb3883..383ce48 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4113,7 +4113,7 @@ static int bond_neigh_setup(struct net_device *dev, struct neigh_parms *parms)
 		const struct net_device_ops *slave_ops
 			= slave->dev->netdev_ops;
 		if (slave_ops->ndo_neigh_setup)
-			return slave_ops->ndo_neigh_setup(dev, parms);
+			return slave_ops->ndo_neigh_setup(slave, parms);
 	}
 	return 0;
 }

--------------020003080003040006090208--
