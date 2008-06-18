Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbYFRNGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbYFRNGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbYFRNGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:06:00 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:43177 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbYFRNGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:06:00 -0400
Date: Wed, 18 Jun 2008 15:05:57 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Pieter Steyn <pieterste@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] eth_v10.c phy fix
Message-ID: <20080618130557.GA5064@axis.com>
References: <c49e66200806130804u280fdfa1gd1027f3401ae7f4f@mail.gmail.com> <c49e66200806130900i26b3c284q262aef2d85d61f61@mail.gmail.com> <c49e66200806180509g6a391f8fi1567f21cd353c71c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c49e66200806180509g6a391f8fi1567f21cd353c71c@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 02:09:23PM +0200, Pieter Steyn wrote:
> Hi guys,

Hi,

> Any word on this?

The patch seems to be against the 2.6.23 kernel, mdio_phy_addr was
removed in 2.6.24. The following compiles, although I haven't had
time to test it yet:


diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index 65d0a91..c8bcb22 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -1431,6 +1431,14 @@ static int e100_set_settings(struct net_device *dev,
 		e100_set_speed(dev, ecmd->speed == SPEED_10 ? 10: 100);
 	}
 
+	struct net_local *np = netdev_priv(dev);
+	/* Honor ethtool phy address parameter, which was simply */
+	/* discarded before this. */
+	if (ecmd->phy_address <= 31)
+		np->mii_if.phy_id = ecmd->phy_address;
+	else if (ecmd->phy_address == 32)
+		return -ENODEV;
+
 	return 0;
 }
 


I'll add it to my queue (which will be published RSN :), thanks!

Best regards,

/Jesper


> Thanks,
> Pieter
> 
> > On 6/13/08, Pieter Steyn <pieterste@gmail.com> wrote:
> > Ah, I did not consider case when searching...DOH! :]
> >
> >  I've now cc'ed in Jesper who seems to be the maintainer.
> >
> >  Cheers,
> >
> > Pieter Steyn
> >
> >
> >  > On 6/13/08, Pieter Steyn <pieterste@gmail.com> wrote:
> >  > Hi guys,
> >  >
> >  >  This patch allows you to set phy address parameters through ethtool, like:
> >  >
> >  >  /bin/ethtool -s eth0 phyad 8
> >  >
> >  >  --- drivers/net/cris/eth_v10.c  2008-06-12 14:12:33.000000000 +0200
> >  >  +++ drivers/net/cris/eth_v10.c  2008-06-12 14:19:35.000000000 +0200
> >  >  @@ -1430,7 +1430,11 @@
> >  >                 e100_set_duplex(dev, ecmd->duplex == DUPLEX_HALF ? half : full);
> >  >                 e100_set_speed(dev, ecmd->speed == SPEED_10 ? 10: 100);
> >  >         }
> >  >  -
> >  >  +        //Honor ethtool phy address parameter, which was simply
> >  >  discarded before this.
> >  >  +        if (ecmd->phy_address <= 31)
> >  >  +                mdio_phy_addr = ecmd->phy_address;
> >  >  +        else if (ecmd->phy_address == 32)
> >  >  +                return -ENODEV;
> >  >         return 0;
> >  >   }
> >  >
> >  >  I've searched the MAINTAINERS file and haven't seen anything regarding
> >  >  either the source file name or cris.  Please consider applying my
> >  >  patch to main kernel...
> >  >
> >  >  Thanks,
> >  >
> >  > Pieter Steyn
> >  >
> >  >
> >
/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
