Return-Path: <linux-kernel-owner+w=401wt.eu-S933066AbZLNVYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066AbZLNVYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932679AbZLNVYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:24:07 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:46543 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674AbZLNVYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:24:03 -0500
Subject: Re: [PATCH v2 2/4] Defer skb allocation -- new skb_set calls &
 chain pages in virtio_net
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <20091213112452.GB7074@redhat.com>
References: <1258697359.7416.14.camel@localhost.localdomain>
	 <200911231123.18898.rusty@rustcorp.com.au>
	 <20091208122134.GA17286@redhat.com>
	 <1260534506.30371.6.camel@localhost.localdomain>
	 <1260535382.30371.20.camel@localhost.localdomain>
	 <20091213112452.GB7074@redhat.com>
Content-Type: text/plain
Date: Mon, 14 Dec 2009 13:23:45 -0800
Message-Id: <1260825825.8716.81.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-13 at 13:24 +0200, Michael S. Tsirkin wrote:
> Hmm, this scans the whole list each time.
> OTOH, the caller probably can easily get list tail as well as head.
> If we ask caller to give us list tail, and chain them at head, then
> 1. we won't have to scan the list each time
> 2. we get better memory locality reusing same pages over and over
> again

I could use page private to point to a list_head which will have a head
and a tail, but it will induce more alloc, and free, when this page is
passed to ULPs as a part of skb frags, it would induce more overhead.

> So this comment does not explain why this = 0 is here.
> clearly = 0 does not chain anything.
> Please add a bigger comment.
> I think you also want to extend the comment at top of
> file, where datastructure is, that explains the deferred
> alogorigthm and how pages are chained.
Ok, will do.

> Use min for clarity instead of opencoded if.
> This will make it obvious that len won't ever become
> negative below.
Ok.

> > +static struct sk_buff *skb_goodcopy(struct virtnet_info *vi, struct
> page **page,
> 
> I know you got this name from GOOD_COPY_LEN, but it's not
> very good for a function :) and skb_ prefix is also confusing.
> Just copy_small_skb or something like that?
> 
> > +                                 unsigned int *len)
Ok.

> Comments about splitting patches  apply here as well.
> No way to understand what this should do and whether it
> does it correctly just by looking at patch.
> I think reader will still wonder about is "why does it
> need to be 16 byte aligned?". And this is what
> comment should explain I think.

Ok, will put more comments.

> So you are overriding *len here? why bother calculating it
> then?
I can remove the overriding part.

> Also - this does *not* always copy all of data, and *page
> tells us whether it did a copy or not? This is pretty confusing,
> as APIs go. Also, if we have scatter/gather anyway,
> why do we bother copying the head?

If receiving buffer in mergeable buf and big packets, the packet is
small, then there is no scatter/gather, we can release the page for new
receiving, that was the reason to copy skb head. *page will be only used
by big packets path to indicate whether/where to start next skb frag if
any.

> Also, before skb_set_frag skb is linear, right?
> So in fact you do not need generic skb_set_frag,
> you can just put stuff in the first fragment.
> For example, pass the fragment number to skb_set_frag,
> compiler will be able to better optimize.

You meant to reuse skb_put_frags() in ipoib_cm.c?

Thanks
Shirley

