Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbYGYJJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbYGYJJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYGYJJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:09:35 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:29389 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752987AbYGYJJe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:09:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lkXyFQjHMwAgGBokBfeLNHppKzjAsC6m0BLPzFEptlj/6x7yDAsdAD/gt7/9SnYzZ6Ziwm9s+yWudR4o7vUMn58GLertXHe1Ir39eqLfaXmrcOMlPSBrUIfIH4vvygDpO6GPwC+y14NARETwN8lLTlHFRoPq0j/3xfaNpqORlxQ=  ;
X-YMail-OSG: RzpG3u0VM1kNwLV_JflIQJnqFCfbYwjpfBz.wxw06TyPd3eViD7cAmLThVS9gup8QRy4xTIx2MX.cFi6a38xwWKugi0caBusWzzJ368I.iSmP8Dv0w1qx.geW10PcL3Qb8s-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [regression] nf_iterate(), BUG: unable to handle kernel NULL pointer dereference
Date: Fri, 25 Jul 2008 19:09:07 +1000
User-Agent: KMail/1.9.5
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, w@1wt.eu, davidn@davidnewall.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl, ilpo.jarvinen@helsinki.fi,
       Dave Jones <davej@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
References: <20080724060448.GA10203@elte.hu> <1216906342.12021.0.camel@penberg-laptop> <1216927309.15519.253.camel@calx>
In-Reply-To: <1216927309.15519.253.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807251909.08661.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 July 2008 05:21, Matt Mackall wrote:
> On Thu, 2008-07-24 at 16:32 +0300, Pekka Enberg wrote:
> > On Thu, Jul 24, 2008 at 10:56:08PM +1000, Nick Piggin wrote:
> > > > > OTOH, skb allocation uses kmalloc don't they? So you could still
> > > > > use SLOB ksize for that I guess.
> >
> > On Thursday 24 July 2008 23:04, Herbert Xu wrote:
> > > > Yes I was referring to the data portion which is kmalloc'ed.
> > > > That is also why I'm interested in ksize because a priori we
> > > > don't know exactly how big it's going to be.  However, we do
> > > > know that statistically 1500 will dominate.
> > > >
> > > > I'm not interested in ksize for kmem_cache at all.  So in fact
> > > > we could have something simpler that's based on kmalloc's rounding
> > > > algorithm instead.
> >
> > ﻿On Thu, 2008-07-24 at 23:13 +1000, Nick Piggin wrote:
> > > Yes you could definitely have a function that returns allocated
> > > bytes for a given kmalloc size. Should be about as fast or faster
> > > than extracting the size from the kaddr...
> >
> > Yup, makes sense.
>
> On the other hand, I can imagine useful allocator changes where this
> would not be a constant of requested size. For instance, imagine we had
> a classless bucket allocator, but with a heuristic to try a larger
> bucket when it wasn't cheap/possible to allocate a right-sized object
> (because of memory pressure, etc.) and larger ones were available.
> This sort of thing is a pretty small change for SLAB/SLUB.

If that comes up, you could make the API take the pointer as well,
then just filter out the new argument in allocators that don't use
it.
