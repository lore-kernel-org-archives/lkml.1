Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbZBFLsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbZBFLsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 06:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZBFLsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 06:48:04 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:43555 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbZBFLsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 06:48:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bgZUsVra+iu+c39ytag8EeJEDd0JUPnTIUr1Z5kK1yh2z4E+mp03ymdIlWrMD2PH59
         cgRkx3FwR/o6Q9akW3zf7GUazWBhk1fhM6VM79i4GirM1vq5SyLa3gwJ2nRQ5I2mspTn
         OXA82ijUo+m2pqZm+eph5oA9BsJQhkbj+0bCU=
Date: Fri, 6 Feb 2009 11:47:53 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>, zbr@ioremap.net,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090206114753.GE4879@ff.dom.local>
References: <20090202084358.GB4129@ff.dom.local> <20090202.235017.253437221.davem@davemloft.net> <20090203094108.GA4639@ff.dom.local> <20090205.235258.257422341.davem@davemloft.net> <20090206091034.GA4879@ff.dom.local> <20090206092326.GC6645@gondor.apana.org.au> <20090206095119.GC4879@ff.dom.local> <20090206102822.GB7175@gondor.apana.org.au> <20090206105807.GD4879@ff.dom.local> <20090206111015.GD15159@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206111015.GD15159@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 12:10:15PM +0100, Willy Tarreau wrote:
> On Fri, Feb 06, 2009 at 10:58:07AM +0000, Jarek Poplawski wrote:
> > On Fri, Feb 06, 2009 at 09:28:22PM +1100, Herbert Xu wrote:
> > > On Fri, Feb 06, 2009 at 09:51:20AM +0000, Jarek Poplawski wrote:
> > > >
> > > > OK, but since there is not so much difference, and we need to waste
> > > > it in some cases anyway, plus handle it later some special way, I'm
> > > > a bit in doubt.
> > > 
> > > Well the thing is cards that don't support SG on tx probably
> > > don't support jumbo frames either.
> > 
> > ?? I mean this 128 byte chunk would be hard to reuse after copying
> > to skb->data, and if reused, we could miss this for some NICs on TX,
> > so the whole packed would need a copy.
> 
> couldn't we stuff up to 32 128-byte chunks in a page and use a 32-bit
> map to indicate which slot is used and which one is free ? This would
> just be a matter of calling ffz() to find one spare place in a page.
> Also, that bitmap might serve as a refcount, because if it drops to
> zero, it means all slots are unused. And -1 means all slots are used.
> 
> This would reduce wastage if wee need to allocate 128 bytes often.

Something like this would be useful for SG NICs for the paged
skb->data area. But I'm concerned with non-SG ones: if I got it right,
for 1500 byte packets we need to allocate such a chunk, copy 128+
bytes to skb->data, and we have 128+ unused. If there are later such
short packets, we don't need this space: why copy?

But even if we find the way to use this, or don't reserve such space
while receiving from SG NIC, than we will need to copy both chunks
to another page for TX on non-SG NICs.

Jarek P.
