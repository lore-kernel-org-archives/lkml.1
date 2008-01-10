Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYAJCBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYAJCBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYAJCBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:01:30 -0500
Received: from ozlabs.org ([203.10.76.45]:39475 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbYAJCB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:01:28 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
Date: Thu, 10 Jan 2008 13:01:03 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>
References: <200712191731.26512.rusty@rustcorp.com.au> <200801081139.14748.rusty@rustcorp.com.au> <1199916637.3493.72.camel@localhost.localdomain>
In-Reply-To: <1199916637.3493.72.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801101301.03846.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2008 09:10:37 James Bottomley wrote:
> On Tue, 2008-01-08 at 11:39 +1100, Rusty Russell wrote:
> > On Tuesday 08 January 2008 02:48:23 James Bottomley wrote:
> > > We're always open to new APIs (or more powerful and expanded old ones).
> > > The way we've been doing the sg_chain conversion is to slide API layers
> > > into the drivers so sg_chain becomes a simple API flip when we turn it
> > > on.  Unfortunately sg_ring doesn't quite fit nicely into this.
> >
> > Hi James,
> >
> >    Well, it didn't touch any drivers.  The only ones which needed
> > altering were those which wanted to use large scatter-gather lists.  You
> > think of the subtlety of sg-chain conversion as a feature; it's a bug :)
>
> No, I think of the side effect of hiding scatterlist manipulations
> inside accessors as a feature because it insulates the drivers from the
> details of the implementation.

I completely disagree.  Abstractions add complexity, and that costs.  They 
steal information from their users, and as they build up like sediment they 
make debugging and understanding harder.

For example, an array is simple and well understood.   An abstraction would 
just buy confusion and YA thing to learn.

When a single array was no longer sufficient, I figured a linked-list of 
arrays was the simplest replacement.  Easy to understand and accepted 
practice (tho rings are a bit exotic).  Because the implementation is the 
interface, authors can see what is legal.

More concretely, you're already regarding your abstractions as too expensive, 
which is why sg_chain() doesn't handle chained sgs.

Result: you've got a complex implementation and a complex interface with a 
complex abstraction.

> > sg_chains suck for manipulation, and AFAICT that's inherent.  Here, take
> > a look at the sg_ring conversion of scsi_alloc_sgtable and
> > scsi_free_sgtable and you can see why I'm unhappy with the sg_chain code:
> [...]
>
> > Hope that clarifies,
>
> Actually, not really.  If I want to continue the competition, I can just
> point out that your sg_ring code is bigger than those corresponding
> segments are after the sg_table conversion of scsi_lib.c ...
>
> However, this is pointless.

No, it's exactly the point.  These details *matter*.  The implementation 
*matters*.  sg_table moves this code out of scsi_lib (good!), but still 
demonstrates how much of a PITA they are to manipulate.

As for being able to make arbitrary changes in future without hitting drivers: 
this is the Kernel ABI pipe dream writ small.

OK, I give in with -ETIMEDOUT.  I'll go away now and do something 
productive :)

Cheers,
Rusty.
