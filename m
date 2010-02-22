Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab0BVXxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:53:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34671
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930Ab0BVXxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:53:40 -0500
Date: Mon, 22 Feb 2010 15:53:57 -0800 (PST)
Message-Id: <20100222.155357.235673585.davem@davemloft.net>
To: hancockrwd@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: NETIF_F_HIGHDMA misuse in networking drivers?
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B8029FA.2000404@gmail.com>
References: <4B8029FA.2000404@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Hancock <hancockrwd@gmail.com>
Date: Sat, 20 Feb 2010 12:29:14 -0600

> Was just part of a discussion in another thread talking about 64-bit
> DMA support issues where NETIF_F_HIGHDMA came up. I was originally
> under the impression that this flag indicated the device supported
> 64-bit DMA addressing. However, from looking at the code that checks
> for it (and, well, the actual comment for the flag) it really means
> "can access highmem" which has nothing to do with 64-bit at all. And
> if there's no highmem (like on x86_64) it has no effect at all.

I think it's trying to do two things, and doing only one of them
well :-)

It's trying to keep drivers from receiving highmem pages if they are
not able to access them properly.  F.e. imagine a driver that copies
data out of the packet assuming that page_address() is always valid on
the SKB pages.

It's also trying to use this to prevent physical addresses beyond 4GB
from reaching the driver, which as you note is not implemented
precisely here.

Without knowing something about how the driver "DMAs" packet data we
can't really do an accurate test here.  Maybe the driver directly DMAs
using physical addressing (an ASIC inside of a CPU, for example,
drivers/net/niu.c has a case of this).

Maybe the platform uses an IOMMU with 32-bit virtual addressing, so
any physical address is fine even if the card only supports 32-bit
addressing (basically any PCI coard on sparc64 is an example of this).

And finally maybe the card supports 64-bit DMA addressing so anything
works on any platform.

How to test all of these possible cases precisely that at this spot in
the transmit path is the question at hand.  To be honest I consider
the current hack "good enough" :-)


