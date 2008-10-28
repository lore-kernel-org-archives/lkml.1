Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbYJ1LU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbYJ1LU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 07:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbYJ1LUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 07:20:03 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:27046 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753931AbYJ1LUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 07:20:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AZKu62WhshTeFwPtPcz2J8Wyi+mCyVLXmJl9xrLSSwBChWVVR8rUVs1ifJyVQWqf59ftOvR54oFQ6p1eecSFPYMQuMm11QnvYZ3/F//46uXBie3/qsTdTdf6NXWo1mZ4qzFn2wP2qNldX5/2Q/Mu8zOmTmZk7eD7RHKv7ODImRU=  ;
X-YMail-OSG: 6xog6VMVM1mMVD0tqlax.YIzBY7fz0UXbuZGmnwdEMfe6qQs8TK66GdXMZoPtxFNQyd8Y17KutBGNQ1U8RJXwUS.pQSc63dA2ErBYw90_wvIW8LvyZUiqGlyJGKoIe64mwcsL2hRoK45VOwHZA8B0cSx8ERmwl3XXnjEpUc4MG_tWUvzruk.P6bHgHjb
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: SLUB defrag pull request?
Date: Tue, 28 Oct 2008 22:19:43 +1100
User-Agent: KMail/1.9.5
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, hugh@veritas.com,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1223883004.31587.15.camel@penberg-laptop> <4900B0EF.2000108@cosmosbay.com> <1225191983.27477.16.camel@penberg-laptop>
In-Reply-To: <1225191983.27477.16.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810282219.44022.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2008 22:06, Pekka Enberg wrote:
> On Thu, 2008-10-23 at 19:14 +0200, Eric Dumazet wrote:
> > [PATCH] slub: slab_alloc() can use prefetchw()
> >
> > Most kmalloced() areas are initialized/written right after allocation.
> >
> > prefetchw() gives a hint to cpu saying this cache line is going to be
> > *modified*, even if first access is a read.
> >
> > Some architectures can save some bus transactions, acquiring
> > the cache line in an exclusive way instead of shared one.
> >
> > Same optimization was done in 2005 on SLAB in commit
> > 34342e863c3143640c031760140d640a06c6a5f8
> > ([PATCH] mm/slab.c: prefetchw the start of new allocated objects)
> >
> > Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
>
> Christoph, I was sort of expecting a NAK/ACK from you before merging
> this. I would be nice to have numbers on this but then again I don't see
> how this can hurt either.

I've seen explicit prefetches hurt quite surprising amount if they're
not placed in appropriate places (which includes putting them in
places where the object is already in cache, or the processor is in a
good position to have speculatively initiated the operation anyway).

I'm not saying it's going to be the case here, but it can be really
hard to actually tell if it is worthwhile, IMO. For example, some
nice CPU local workloads that are often fitting within cache, might
have the object already in cache 99.x% of the time here. prefetch may
easily slow things down.

