Return-Path: <linux-kernel-owner+w=401wt.eu-S932304AbXBNEsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbXBNEsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 23:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932303AbXBNEsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 23:48:53 -0500
Received: from ozlabs.org ([203.10.76.45]:45553 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304AbXBNEsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 23:48:53 -0500
Subject: Re: [PATCH 5/8] lguest: trivial guest network driver
From: Rusty Russell <rusty@rustcorp.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       jgarzik <jgarzik@pobox.com>
In-Reply-To: <20070213140600.GA24711@gondor.apana.org.au>
References: <1171251578.10409.17.camel@localhost.localdomain>
	 <1171251698.10409.20.camel@localhost.localdomain>
	 <1171251770.10409.23.camel@localhost.localdomain>
	 <1171251894.10409.26.camel@localhost.localdomain>
	 <1171251965.10409.28.camel@localhost.localdomain>
	 <1171252113.10409.30.camel@localhost.localdomain>
	 <1171252219.10409.33.camel@localhost.localdomain>
	 <1171252321.10409.36.camel@localhost.localdomain>
	 <20070212155553.GA15627@gondor.apana.org.au>
	 <1171332919.19842.74.camel@localhost.localdomain>
	 <20070213140600.GA24711@gondor.apana.org.au>
Content-Type: text/plain
Date: Wed, 14 Feb 2007 15:47:55 +1100
Message-Id: <1171428475.19842.102.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-14 at 01:06 +1100, Herbert Xu wrote:
> On Tue, Feb 13, 2007 at 01:15:18PM +1100, Rusty Russell wrote:
> > 
> > Good spotting!  This function needs to be passed skb_headlen(skb),
> > rather than skb->len.  Patch is below (I renamed the parameter as well,
> > for clarity).
> 
> How about just dropping that parameter and using skb_headlen(skb)
> directly?

It's also used to generate dma structs for outgoing packets.  In that
case, skb_headlen() == 0:

static struct sk_buff *lguestnet_alloc_skb(struct net_device *dev, int gfpflags)
{
	struct sk_buff *skb;

	skb = alloc_skb(16 + ETH_HLEN + DATA_SIZE, gfpflags);
	if (!skb)
		return NULL;

	skb->dev = dev;
	skb_reserve(skb, 16);
	return skb;
}

/* Find a new skb to put in this slot in shared mem. */
static int fill_slot(struct net_device *dev, unsigned int slot)
{
	struct lguestnet_info *info = dev->priv;
	/* Try to create and register a new one. */
	info->skb[slot] = lguestnet_alloc_skb(dev, GFP_ATOMIC);
	if (!info->skb[slot]) {
		printk("%s: could not fill slot %i\n", dev->name, slot);
		return -ENOMEM;
	}

	skb_to_dma(info->skb[slot], ETH_HLEN + DATA_SIZE, &info->dma[slot]);

Cheers,
Rusty.


