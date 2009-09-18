Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZIRABm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZIRABm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 20:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbZIRABl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 20:01:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46081
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbZIRABk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 20:01:40 -0400
Date: Thu, 17 Sep 2009 17:01:56 -0700 (PDT)
Message-Id: <20090917.170156.152594715.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: JBeulich@novell.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH] fix BUILD_BUG_ON() and a couple of bogus uses of it
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090917162437.b1a890de.akpm@linux-foundation.org>
References: <4A8AEBFD0200007800010580@vpn.id2.novell.com>
	<20090917162437.b1a890de.akpm@linux-foundation.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 17 Sep 2009 16:24:37 -0700

> sparc64:
> 
> In file included from arch/sparc/kernel/vio.c:17:
> /usr/src/devel/arch/sparc/include/asm/vio.h: In function `vio_dring_avail':
> /usr/src/devel/arch/sparc/include/asm/vio.h:261: error: bit-field `<anonymous>' width not an integer constant
> 
> static inline u32 vio_dring_avail(struct vio_dring_state *dr,
> 				  unsigned int ring_size)
> {
> 	BUILD_BUG_ON(!is_power_of_2(ring_size));
> 
> 	return (dr->pending -
> 		((dr->prod - dr->cons) & (ring_size - 1)));
> }
> 
> changing it to MAYBE_BUILD_BUG_ON seems to have fixed it.

That's completely bogus.

First of all, arch/sparc/kernel/vio.c never calls this function
so it should never be evaluated.

Second of all, all the places that do call this function only
pass pure constants as the 'ring_size' parameter.

drivers/block/sunvdc.c:

static inline u32 vdc_tx_dring_avail(struct vio_dring_state *dr)
{
	return vio_dring_avail(dr, VDC_TX_RING_SIZE);
}

drivers/net/sunvnet.c:

static inline u32 vnet_tx_dring_avail(struct vio_dring_state *dr)
{
	return vio_dring_avail(dr, VNET_TX_RING_SIZE);
}

Making this MAYBE_BUILD_BUG_ON shouldn't be necessary.
