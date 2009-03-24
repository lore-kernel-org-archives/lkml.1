Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZCXXgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZCXXgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbZCXXgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:36:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48796
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754712AbZCXXgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:36:43 -0400
Date: Tue, 24 Mar 2009 16:36:30 -0700 (PDT)
Message-Id: <20090324.163630.226102764.davem@davemloft.net>
To: pazke@donpac.ru
Cc: thierry.reding@avionic-design.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Add support for the OpenCores 10/100 Mbps
 Ethernet MAC.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090324111359.GA6859@ports.donpac.ru>
References: <1237889923-32257-1-git-send-email-thierry.reding@avionic-design.de>
	<20090324111359.GA6859@ports.donpac.ru>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Panin <pazke@donpac.ru>
Date: Tue, 24 Mar 2009 14:13:59 +0300

> On 083, 03 24, 2009 at 11:18:43AM +0100, Thierry Reding wrote:
> > +static void ethoc_copy_to_io(void __iomem *dest, struct sk_buff *src)
> > +{
> > +	size_t size = (src->len & 0x3) ? (src->len & ~0x3) + 4 : src->len;
> > +	u8 buffer[ETHOC_BUFSIZ];
> 
> Using 1536 bytes of stack is not very nice.

Agreed, this stuff must be fixed.

You could use skb_copy_and_csum_dev() directly into your buffer, then
pad out the end of the buffer with a memset() call, if necessary.

Actually, no you can't...

You should not be using memcpy() to store things into I/O memory.
That's what memcpy_io() is for.

I think because of all of these special padding cases and the use
of I/O memory instead of DMA, there is no real gain by using
skb_copy_and_csum_dev() in this driver.  Just let the network
stack checksum the packet, and use memcpy_io() here which is
the currect interface for copying data into I/O memory.
